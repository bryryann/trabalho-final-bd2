-- TRIGGER: Quando uma nova instancia_item é criada ou atualizada, é verificado
-- se cabe no inventário do player. Caso não caiba, retorne
-- uma EXCEPTION e de rollback na inserção/update.
CREATE OR REPLACE TRIGGER trg_verifica_capacidade_inv
BEFORE INSERT OR UPDATE ON Instancia_Item
FOR EACH ROW
DECLARE
    v_tamanho_item Item.tamanho_item%TYPE;
    v_peso_item Item.peso_item%TYPE;

    v_tamanho_ocupado NUMBER;
    v_peso_ocupado NUMBER;

    v_tamanho_inventario_player Inventario.tamanho_inventario_player%TYPE;
    v_peso_max_player Inventario.peso_max_player%TYPE;

    v_tamanho_adicionado NUMBER;
    v_peso_adicionado NUMBER;
BEGIN
    SELECT tamanho_item, peso_item
    INTO v_tamanho_item, v_peso_item
    FROM Item
    WHERE id_item = :NEW.id_item; -- obtem tamanho e peso do item inserido

    SELECT
        NVL(SUM(it.tamanho_item * inst.quantidade), 0),
        NVL(SUM(it.peso_item * inst.quantidade), 0)
    INTO
        v_tamanho_ocupado, v_peso_ocupado
    FROM Instancia_Item inst
        JOIN Item it ON it.id_item = inst.id_item
    WHERE inst.id_inventario = :NEW.id_inventario; -- obtem o tamanho e o peso dos items ja no inventario

    SELECT tamanho_inventario_player, peso_max_player
    INTO v_tamanho_inventario_player, v_peso_max_player
    FROM Inventario
    WHERE id_inventario = :NEW.id_inventario; -- maximos do inventario

    v_tamanho_adicionado := v_tamanho_item * :NEW.quantidade;
    v_peso_adicionado := v_peso_item * :NEW.quantidade;

    IF v_tamanho_ocupado + v_tamanho_adicionado > v_tamanho_inventario_player THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Espaço insuficiente no inventário.'
        );
    ELSIF v_peso_ocupado + v_peso_adicionado > v_peso_max_player THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Peso máximo do inventario excedido.'
        );
    END IF;
END;
/


--Checa a quantidade de players na partida antes de inserir outro player
CREATE OR REPLACE TRIGGER trg_verifica_quant_players_raid
BEFORE INSERT ON PLAYER_RAID
FOR EACH ROW
DECLARE
    v_quant_players NUMBER := 0;
    v_disponibilidade EXCEPTION;
BEGIN

    SELECT COUNT(*) INTO v_quant_players FROM PLAYER_RAID PLARAD WHERE PLARAD.id_raid = :NEW.id_raid;
    
    IF v_quant_players >= 16 THEN
        RAISE v_disponibilidade;
    END IF;
    
EXCEPTION
   WHEN v_disponibilidade THEN
        RAISE_APPLICATION_ERROR(-20001, 'Raid sem espaço para players');
        
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro ao inserir player');
END;
/


-- TRIGGER PARA VERIFICAR SE UM PLAYER ESTÁ BANIDO ANTES DE ENTRAR EM UMA RAID
-- a trigger é executada automaticamente antes da inserção de um registro
-- na tabela Player_Raid.
--     * se o jogador possuir um banimento ativo, o INSERT é cancelado.
--     * é lançada a exceção ORA-20001 com uma mensagem informativa.
-- critérios para considerar um banimento ativo:
--     * data_desbanimento IS NULL (banimento permanente), ou
--     * data_desbanimento > SYSDATE (banimento ainda vigente).
-- uso: executada automaticamente quando um registro é inserido em Player_Raid.
CREATE OR REPLACE TRIGGER trg_verifica_banimento
BEFORE INSERT ON Player_Raid
FOR EACH ROW
DECLARE
    v_player_banido NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_player_banido
    FROM Banimento
    WHERE id_usuario = (
        SELECT p.id_usuario
        FROM Player p
        WHERE id_player = :NEW.id_player
    )
    AND (data_desbanimento IS NULL OR data_desbanimento > SYSDATE);

    IF v_player_banido > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Jogador está banido e não pode entrar em uma raid.'
        );
    END IF;
END;
/


--Checa o espaço livre no inventário da base (Precisa dar uma mexida e implementar junto do espaço do inventário do jogador)
CREATE OR REPLACE TRIGGER checar_inventario_disponivel
BEFORE INSERT ON INSTANCIA_ITEM
FOR EACH ROW
DECLARE 
    v_espaco_livre NUMBER;
    v_espaco_ocupado_item NUMBER;
    v_id_player NUMBER;
    v_valor_convertido NUMBER;
    v_error EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    v_espaco_livre := ESPACO_LIVRE_ESTOQUE(:NEW.id_inventario);

    SELECT tamanho_item INTO v_espaco_ocupado_item FROM ITEM WHERE id_item = :NEW.id_item;

    v_espaco_ocupado_item := v_espaco_ocupado_item * :NEW.quantidade;

    --Não há espaço para inserir o item no inventário
    IF v_espaco_ocupado_item > v_espaco_livre THEN
        RAISE v_error;
    END IF;
EXCEPTION

    WHEN v_error THEN
        SELECT id_player INTO v_id_player FROM INVENTARIO WHERE id_inventario = :NEW.id_inventario;
        v_valor_convertido := FN_CONVERTER_ITEM_PLAYER_RUBLO(v_id_player, :NEW.id_item, :NEW.quantidade);
        RAISE_APPLICATION_ERROR(
            -20001,
            'Capacidade máxima excedida. Transformando em rublo.'
        );
END;

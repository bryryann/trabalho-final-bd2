-- FUNCTION: Selecionar um mapa aleatorio dentre os mapas disponiveis
-- Em caso de não haver nenhum mapa registrado no banco, é retornado NULL
CREATE OR REPLACE FUNCTION fn_mapa_aleatorio
RETURN NUMBER
IS
    v_id_mapa MAPA.id_mapa%TYPE;
BEGIN
    SELECT id_mapa
    INTO v_id_mapa
    FROM (
        SELECT id_mapa
        FROM Mapa
        ORDER BY DBMS_RANDOM.VALUE
    )
    WHERE ROWNUM = 1;

    RETURN v_id_mapa;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


--function para registrar o K/D do jogador
CREATE OR REPLACE FUNCTION fn_calcular_kd(p_id_player NUMBER) RETURN NUMBER IS
    v_ratio NUMBER;
    v_kills NUMBER;
    v_deaths NUMBER;
    v_error EXCEPTION;
BEGIN

    SELECT kills, deaths INTO v_kills, v_deaths FROM PLAYER WHERE id_player = p_id_player;

    IF v_kills IS NULL AND v_deaths IS NULL THEN
        RAISE v_error;
 
    ELSE
        v_ratio := v_kills/v_deaths;
        UPDATE PLAYER SET kill_death_ratio = ROUND(v_ratio, 2) WHERE id_player = p_id_player;
        COMMIT;

        RETURN v_ratio;
    END IF;

EXCEPTION
    WHEN v_error THEN
        RAISE_APPLICATION_ERROR(-20001, 'VALORES NÃO ENCONTRADOS');
 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERRO AO CALCULAR A TAXA DE K/D');
END;
/


--function para transformar itens em dinheiro
CREATE OR REPLACE FUNCTION fn_converter_item_player_rublo(p_id_player NUMBER, p_id_item NUMBER, p_quantidade NUMBER) RETURN NUMBER IS
    v_total NUMBER;
    v_item_valor NUMBER;
BEGIN
    SELECT valor_item INTO v_item_valor FROM ITEM WHERE id_item = p_id_item;
 
    v_total := (p_quantidade*v_item_valor);
 
    UPDATE PLAYER SET rublo = (rublo+v_total) WHERE id_player = p_id_player;
    COMMIT;

    RETURN v_total;
END;
/


--function para calcular o espaço livre do estoque
CREATE OR REPLACE FUNCTION fn_espaco_livre_estoque(p_id_inventario NUMBER) RETURN NUMBER IS
    v_espaco_estoque NUMBER;
    v_espaco_ocupado NUMBER;
BEGIN

    SELECT tamanho_inventario_base INTO v_espaco_estoque FROM INVENTARIO WHERE id_inventario = p_id_inventario;

    SELECT NVL(SUM(II.quantidade * I.tamanho_item), 0) INTO v_espaco_ocupado 
        FROM INSTANCIA_ITEM II 
        INNER JOIN ITEM I ON II.id_item = I.id_item 
        WHERE II.id_inventario = p_id_inventario;

    RETURN (v_espaco_estoque - v_espaco_ocupado);
END;
/

CREATE OR REPLACE PROCEDURE sp_criar_player(p_id_usuario NUMBER, p_nome_player VARCHAR2, p_faccao VARCHAR2) IS
    v_cont NUMBER;
    v_id_player NUMBER;
    v_plano VARCHAR2(50);
    v_erro EXCEPTION;
BEGIN
    SELECT plano INTO v_plano FROM USUARIO WHERE id_usuario = p_id_usuario;
    --Checa se nao ha outro player nessa conta
    SELECT COUNT(*) INTO v_cont FROM PLAYER WHERE Player.id_usuario = p_id_usuario;
    --Verifica se nao ha outra conta e se o usuario possui o jogo pago
    IF v_cont = 0 AND v_plano != 'FREE' THEN

        --PADRAO
        IF v_plano = 'STANDARD' THEN
            INSERT INTO PLAYER(id_usuario, nome_player, faccao, rublo, dolar, euro) 
                VALUES(p_id_usuario, p_nome_player, p_faccao, 50000, 2500, 3000);

            SELECT id_player INTO v_id_player FROM PLAYER WHERE id_usuario = p_id_usuario;

            INSERT INTO INVENTARIO(id_player, tamanho_inventario_base, tamanho_inventario_player, tamanho_slot_seguro, peso_max_player) 
                VALUES (v_id_player, 300, 80, 4, 75);

        --PREMIUM
        ELSIF v_plano = 'PREMIUM' THEN
            INSERT INTO PLAYER(id_usuario, nome_player, faccao, rublo, dolar, euro) 
                VALUES(p_id_usuario, p_nome_player, p_faccao, 500000, 25000, 30000);

            SELECT id_player INTO v_id_player FROM PLAYER WHERE id_usuario = p_id_usuario;

            INSERT INTO INVENTARIO(id_player, tamanho_inventario_base, tamanho_inventario_player, tamanho_slot_seguro, peso_max_player) 
                VALUES (v_id_player, 720, 80, 9, 75);
        END IF;

        COMMIT;

    ELSE
        RAISE v_erro;
    END IF;

EXCEPTION
    WHEN v_erro THEN
        RAISE_APPLICATION_ERROR(-20003, 'Usuario possui um plano inválido ou já possui conta vinculada.');

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Erro ao criar a conta do player.');
END;
/


-- PROCEDURE: Finalizar partida
CREATE OR REPLACE PROCEDURE sp_terminar_raid (
    p_id_raid Raid.id_raid%TYPE
) IS
    CURSOR c_player IS
        SELECT 
            pr.id_player_raid, 
            pr.id_raid
        FROM Player_Raid pr
            JOIN Raid r ON pr.id_raid = r.id_raid
        WHERE pr.status_player = 'IN ACTION';

    v_player_rec c_player%ROWTYPE;

    v_raid_encontrada NUMBER;
    v_raid_existe EXCEPTION;
BEGIN
    SELECT COUNT(*) 
    INTO v_raid_encontrada 
    FROM Raid WHERE id_raid = p_id_raid;

    if v_raid_encontrada = 0 THEN
        RAISE v_raid_existe;
    END IF;

    OPEN c_player;
    FETCH c_player INTO v_player_rec;
    WHILE (c_player%FOUND) LOOP
        UPDATE Player_Raid
        SET status_player = 'MIA'
        WHERE status_player = 'IN ACTION' 
            AND id_player_raid = v_player_rec.id_player_raid
            AND id_raid = v_player_rec.id_raid;
    END LOOP;

    UPDATE Raid
    SET status_raid = 'FINISHED'
    WHERE status_raid = 'RUNNING' 
        AND id_raid = p_id_raid;

    COMMIT;

    EXCEPTION
        WHEN v_raid_existe THEN
        RAISE_APPLICATION_ERROR(-20001, 'Raid não encontrada');
    WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Erro ao finalizar Raid');
END;
/


--procedure para inserir o jogador na raid
CREATE OR REPLACE PROCEDURE sp_entrar_player_raid(p_id_player NUMBER, p_id_raid NUMBER, p_scav NUMBER) IS
BEGIN
    INSERT INTO Player_Raid(id_player, id_raid, scav)
        VALUES(p_id_player, p_id_raid, p_scav);

    COMMIT;
END;
/



--procedure para criar uma raid
CREATE OR REPLACE PROCEDURE sp_criar_raid(p_id_mapa NUMBER, p_horario_raid VARCHAR2) IS
BEGIN
    INSERT INTO RAID(id_mapa, inicio_raid, final_raid, horario_raid)
        VALUES(p_id_mapa, TO_CHAR(SYSDATE, 'DD/MM/YYYY - HH24:MI:SS'), TO_CHAR(SYSDATE+30/1440, 'DD/MM/YYYY - HH24:MI:SS'), p_horario_raid);

    COMMIT;
END;
/


-- Essa procedure irá processar os dados do player quando o status do player for alterado ('MIA', 'KIA', etc.)
-- A procedure deve ser usada APENAS quando:
--         * a partida acabar e o player ainda estiver em campo (MIA),
--         * quando o player for morto (KIA), ou
--         * quando a extração for bem sucedida. (SURVIVED);
-- O jogo ficará encarregado de programar a lógica para executar essa procedure.
-- Uso: sp_finalizar_raid(id_player, id_raid, status_novo_do_player)
CREATE OR REPLACE PROCEDURE sp_processa_status_player(
    p_id_player Player.id_player%TYPE,
    p_id_raid   Raid.id_raid%TYPE,
    p_status    Player_Raid.status_player%TYPE
)
IS
    v_scav Player_Raid.scav%TYPE;
BEGIN
    UPDATE Player_Raid
    SET status_player = p_status
    WHERE id_player = p_id_player
        AND id_raid = p_id_raid;

    SELECT scav
    INTO v_scav
    FROM Player_Raid
    WHERE id_player = p_id_player
        AND id_raid = p_id_raid;

    UPDATE Player p
    SET kills = kills + (
        SELECT pr.kills
        FROM Player_Raid pr
        WHERE pr.id_player = p_id_player
            AND pr.id_raid = p_id_raid
    )
    WHERE id_player = p_id_player;

    IF p_status IN ('KIA', 'MIA') THEN
        UPDATE Player
        SET deaths = deaths + 1
        WHERE id_player = p_id_player;

        IF v_scav = 0 THEN
            DELETE FROM Instancia_Item
            WHERE id_inventario = (
                SELECT id_inventario
                FROM Inventario
                WHERE id_player = p_id_player
            )
            AND equipado = 1
            AND in_container_seguro = 0;
        END IF;
    END IF;

    COMMIT;
END;
/

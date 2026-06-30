INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (1, 1, 1, 1, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (3, 1, 1, NULL, 0, 60);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (5, 1, 1, NULL, 0, 4);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (11, 1, 0, NULL, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 1, 1, NULL, 1, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 1, 0, NULL, 0, 1);

INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (1, 2, 1, 1, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (3, 2, 1, NULL, 0, 60);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (5, 2, 1, NULL, 0, 4);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (11, 2, 0, NULL, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 2, 1, NULL, 1, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 2, 0, NULL, 0, 1);

INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (1, 3, 1, 1, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (3, 3, 1, NULL, 0, 60);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (5, 3, 1, NULL, 0, 4);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (11, 3, 0, NULL, 0, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 3, 1, NULL, 1, 1);
INSERT INTO Instancia_Item (id_item, id_inventario, equipado, durabilidade, in_container_seguro, quantidade) VALUES (12, 3, 0, NULL, 0, 1);

COMMIT;

SELECT * FROM Usuario;
SELECT * FROM Player;
SELECT * FROM Inventario;
SELECT * FROM Instancia_Item;
SELECT * FROM Item;
SELECT * FROM Raid;
SELECT * FROM Player_Raid;
SELECT * FROM Mapa;

EXEC sp_criar_player(2, 'ANINHA', 'USEC');
EXEC sp_criar_player(3, 'BRUNIM_SAFADIM', 'BEAR');
EXEC sp_criar_player(5, 'LucasLucas', 'USEC');
EXEC sp_criar_player(6, 'Julinha da Balinha', 'BEAR');
EXEC sp_criar_player(8, 'Camila2', 'USEC');
EXEC sp_criar_player(9, 'RafaelDoPneu', 'BEAR');
EXEC sp_criar_player(11, 'RelampagoMarquinhos', 'USEC');
EXEC sp_criar_player(12, 'Leticia', 'BEAR');

EXEC sp_criar_raid(1, '11:59:02');
EXEC sp_criar_raid(4, '21:38:22');

EXEC sp_entrar_player_raid(1, 21, 0);
EXEC sp_entrar_player_raid(2, 21, 0);
EXEC sp_entrar_player_raid(3, 21, 1);

SELECT * FROM Instancia_Item WHERE id_inventario = 3;

UPDATE Player_Raid SET status_player = 'KIA' WHERE id_player = 3 AND id_raid = 21;
UPDATE Player_Raid SET status_player = 'EXTRACTED' WHERE id_player = 2 AND id_raid = 21;

EXEC sp_terminar_raid(21);

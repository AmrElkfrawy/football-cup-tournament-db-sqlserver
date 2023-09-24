CREATE PROCEDURE get_player_stats
    @match_date DATE,
    @host_team_ID INT,
    @guest_team_ID INT
AS
BEGIN
    SELECT players.name, match_players.goals_num, match_players.yellow_card, match_players.red_card
    FROM match_players
    JOIN players ON match_players.player_ID = players.ID
    WHERE match_players.date = @match_date AND match_players.host_ID = @host_team_ID AND match_players.guest_ID = @guest_team_ID;
END

EXEC get_player_stats'2022-01-01', 1, 2;

---------------------------------------------------
---------------------------------------------------

CREATE PROCEDURE insert_player
    @player_dob DATE,
    @player_numshirt INT,
    @player_name VARCHAR(20),
    @player_startyear DATE,
    @player_countery VARCHAR(20),
    @player_team INT
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO players (dob, num_shirt, name, start_year, country, team_ID)
        VALUES(@player_dob, @player_numshirt, @player_name, @player_startyear, @player_countery, @player_team);
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH;
END

--ex
DECLARE @status1 INT;
EXEC @status1 = insert_player '1990-08-09', 12, 'ahmed', '1998', 'egypt', 1;
SELECT @status1;
SELECT * FROM players;
--

---------------------------------------------------
---------------------------------------------------

CREATE PROCEDURE show_players
AS
BEGIN
    SELECT *
    FROM players AS p
    ORDER BY p.team_ID, p.num_shirt;
END

--ex
SELECT * FROM players;
EXECUTE show_players;
--

---------------------------------------------------
---------------------------------------------------

CREATE TRIGGER total_player_insert
ON players
AFTER INSERT
AS
BEGIN
    DECLARE @id INT;
    SELECT @id = i.team_ID
    FROM inserted i;
    UPDATE teams
    SET players_count = players_count + 1
    WHERE teams.ID = @id;
END

-- ex
SELECT players_count FROM teams;
INSERT INTO players
VALUES('1999-12-15', 70, 'Mostafa', '2015-12-14', 'egypt', 1);
SELECT players_count FROM teams;
--

------------------------------------------------
------------------------------------------------

CREATE TRIGGER total_player_delete
ON players
AFTER DELETE
AS
BEGIN
    DECLARE @id INT;
    SELECT @id = d.team_ID
    FROM deleted d;
    UPDATE teams
    SET players_count = players_count - 1
    WHERE teams.ID = @id;
END

-- ex
SELECT players_count FROM teams;
DELETE FROM players
WHERE players.Id = 15;
SELECT players_count FROM teams;
--

----------------------------------------------
----------------------------------------------

CREATE TRIGGER total_palyer_update
ON players
AFTER UPDATE
AS
BEGIN
    DECLARE @old_teamid INT;
    SELECT @old_teamid = d.team_ID
    FROM deleted d;

    DECLARE @new_teamid INT;
    SELECT @new_teamid = i.team_ID
    FROM inserted i;

    UPDATE teams
    SET players_count = players_count - 1
    WHERE teams.ID = @old_teamid;
    UPDATE teams
    SET players_count = players_count + 1
    WHERE teams.ID = @new_teamid;
END

-- ex
SELECT players_count FROM teams;

UPDATE players
SET team_ID = 8
WHERE players.Id = 7;

SELECT team_ID FROM players
WHERE players.id = 7;

SELECT players_count FROM teams;
--

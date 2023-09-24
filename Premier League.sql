USE master;
GO

ALTER DATABASE [Super League] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [Super League];

CREATE DATABASE [Super League];
GO

USE [Super League];

CREATE TABLE teams (
    ID INT IDENTITY PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    stadium VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    players_count INT
);

CREATE TABLE players (
    ID INT IDENTITY PRIMARY KEY,
    dob DATE,
    num_shirt INT,
    name VARCHAR(20),
    start_year DATE,
    country VARCHAR(20),
    team_ID INT,
    CONSTRAINT fk_players_teams FOREIGN KEY (team_ID) REFERENCES teams(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE referees (
    ID INT IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dob DATE
);

CREATE TABLE matches (
    date DATE,
    host_team_goals INT DEFAULT 0,
    guest_team_goals INT DEFAULT 0,
    host_team_ID INT NOT NULL,
    guest_team_ID INT NOT NULL,
    CONSTRAINT pk_match PRIMARY KEY (host_team_ID, guest_team_ID, date),
    CONSTRAINT pk_matches_teams_host FOREIGN KEY (host_team_ID) REFERENCES teams(ID),
    CONSTRAINT pk_matches_teams_guest FOREIGN KEY (guest_team_ID) REFERENCES teams(ID)
);

CREATE TABLE match_players (
    host_ID INT,
    guest_ID INT,
    player_ID INT,
    red_card BIT NOT NULL,
    yellow_card INT CHECK (yellow_card BETWEEN 0 AND 2) NOT NULL,
    goals_num INT,
    date DATE,
    CONSTRAINT fk_match_players_match FOREIGN KEY (player_ID) REFERENCES players(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_match_players_host_teams FOREIGN KEY (host_ID, guest_ID, date) REFERENCES matches(host_team_ID, guest_team_ID, date),
    CONSTRAINT pk_match_players PRIMARY KEY (player_ID, host_ID, guest_ID, date)
);

CREATE TABLE match_referees (
    host_team_ID INT,
    guest_team_ID INT,
    match_date DATE,
    referee_ID INT,
    CONSTRAINT pk_match_referees PRIMARY KEY (referee_ID, host_team_ID, guest_team_ID, match_date),
    CONSTRAINT fk_match_referees_match FOREIGN KEY (host_team_ID, guest_team_ID, match_date) REFERENCES matches(host_team_ID, guest_team_ID, date),
    CONSTRAINT fk_match_referees_referees FOREIGN KEY (referee_ID) REFERENCES referees(ID) 
);

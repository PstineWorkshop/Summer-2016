CREATE USER philip IDENTIFIED BY philip
DEFAULT USERSPACE users;
GRANT ALL PRIVILEGES TO philip


CREATE TABLE PLAYER
(
player_id NUMBER(2) NOT NULL,
player_first_name VARCHAR2(38) NOT NULL,
player_last_name VARCHAR2(38) NOT NULL,
player_height NUMBER(2) NOT NULL,
player_weight NUMBER(3) NOT NULL,
player_throws VARCHAR2(38) NOT NULL,
player_bats VARCHAR2(38) NOT NULL,
player_years_in_league NUMBER(2) NOT NULL,
player_birth_date DATE NOT NULL,

CONSTRAINT player_pk
PRIMARY KEY (player_id)


);
CREATE TABLE TEAM
(
team_id NUMBER(1) NOT NULL,

team_name VARCHAR2(50) NOT NULL,
team_stadium VARCHAR2(50) NOT NULL,
team_cry DATE NOT NULL,
team_city VARCHAR2(50) NOT NULL,
team_state VARCHAR2(50) NOT NULL,

CONSTRAINT team_pk
PRIMARY KEY (team_id)

);
CREATE TABLE SEASON
(
years NUMBER(4) NOT NULL,
games NUMBER(3) NOT NULL,
world_series VARCHAR2(50)     NOT NULL,
all_star_game_winner VARCHAR2(10) NOT NULL,
	CONSTRAINT year_pk
		PRIMARY KEY (years),
	CONSTRAINT season_ck CHECK (years>=2012 AND years <= 2014),
	CONSTRAINT season_cks CHECK (games>=0 and games<=162)
);

CREATE TABLE ASSIGNMENT 
(
years NUMBER (4) NOT NULL,
player_id NUMBER (2) NOT NULL,
team_id NUMBER (1) NOT NULL,
assignment_position VARCHAR2(100) ,
assignment_salary NUMBER(8) ,
CONSTRAINT assignment_pk
	PRIMARY KEY (years,player_id,team_id),
CONSTRAINT year_fk
	FOREIGN KEY (years)
		REFERENCES SEASON (years),
CONSTRAINT player_fk
	FOREIGN KEY (player_id)
		REFERENCES PLAYER (player_id),
CONSTRAINT team_fk
	FOREIGN KEY (team_id)
		REFERENCES TEAM (team_id),
CONSTRAINT assignment_ck CHECK (years>=2012 AND years <= 2014)

);


CREATE TABLE RESULTS

(
team_id NUMBER(1) NOT NULL,
years   NUMBER(4) NOT NULL,
wins   NUMBER(3) NOT NULL,
losses NUMBER(3) NOT NULL,
playoffwins  NUMBER (2) ,	
playofflosses NUMBER (2),
ws VARCHAR2(100) NOT NULL,
ds VARCHAR2(100) NOT NULL,
pennant VARCHAR2(100) NOT NULL,
cy VARCHAR2(100) NOT NULL,
mvp VARCHAR2(100),
CONSTRAINT results_pk
	PRIMARY KEY (team_id,years),
CONSTRAINT years_fk
	FOREIGN KEY (years)
		REFERENCES SEASON (years),
CONSTRAINT teams_fk
	FOREIGN KEY (team_id)
		REFERENCES TEAM (team_id),
CONSTRAINT results_ck CHECK (years>=2012 AND years <= 2014),
CONSTRAINT results_cka CHECK (wins>=0 AND wins <= 162),
CONSTRAINT results_ckb CHECK (losses>=0 AND losses <= 162),
CONSTRAINT results_ckc CHECK (playoffwins>=0 AND playoffwins <= 11),
CONSTRAINT results_ckd CHECK (playofflosses>=0 AND playofflosses <= 7)
);
CREATE TABLE STATS
(
player_id NUMBER (2)NOT NULL,
years NUMBER (4) NOT NULL,
stat_rbi     NUMBER (3),
stat_hr	     NUMBER (2),
stat_avg     NUMBER,
stat_w	     NUMBER (3),
stat_era	 NUMBER ,
stat_sop	 NUMBER (3),
stat_sv     NUMBER (2),
stat_g       NUMBER (3),
CONSTRAINT stats_pk
	PRIMARY KEY (player_id, years),
CONSTRAINT yearss_fk
	FOREIGN KEY (years)
		REFERENCES SEASON (years),
CONSTRAINT playerss_fk
	FOREIGN KEY (player_id)
		REFERENCES PLAYER (player_id),
CONSTRAINT stats_ck CHECK (years>=2012 AND years <= 2014),
CONSTRAINT stats_cka CHECK (stat_avg>=0.000 AND stat_avg <= 1.000),
CONSTRAINT stats_ckb CHECK (stat_era>=0.00 AND stat_era<=10.00),
CONSTRAINT stats_ckc CHECK (stat_g>=0 AND stat_g <= 162)
);

CREATE VIEW all_stats AS
  SELECT 
    player_first_name,
    player_last_name,
    (s.years - TO_NUMBER(TO_CHAR(p.player_birth_date, 'yyyy'))) AS age,
    s.stat_hr,
    s.stat_rbi,
    TO_CHAR((s.stat_avg),.999) AS avg_fixed
  FROM PLAYER p
    JOIN STATS s
      ON s.player_id=p.player_id;

CREATE OR REPLACE TRIGGER results_before_update_state
BEFORE INSERT OR UPDATE OF ws
ON RESULTS
FOR EACH ROW
WHEN (NEW.ws != LOWER(NEW.ws))
BEGIN
  :NEW.ws := LOWER(:NEW.ws);
END;
  

-- Login to PDB using pdbadmin

-- Create Matches table in t20 schema
drop table tgt_t20_dbo.matches;
create table tgt_t20_dbo.matches(
match_id number primary key,
series_name varchar2(200),
match_format varchar2(20),
season varchar2(10),
series_match_no varchar2(100),
match_date date,
match_time varchar2(30),
venue varchar2(200),
city varchar2(50),
country varchar2(50),
home_team_name varchar2(100),
home_team_abb varchar2(5),
home_team_captain varchar2(200),
home_team_match_points number,
away_team_name varchar2(100),
away_team_abb varchar2(5),
away_team_captain varchar2(200),
away_team_match_points number,
inns1_team varchar2(100),
inns1_runs number,
inns1_wkts number,
inns1_overs number,
inns1_mins number,
inns1_extras number,
inns1_byes number,
inns1_leg_byes number,
inns1_wides number,
inns1_no_balls number,
inns1_penalties number,
inns2_team varchar2(100),
inns2_target number,
inns2_total_overs number,
inns2_runs number,
inns2_wkts number,
inns2_overs number,
inns2_mins number,
inns2_extras number,
inns2_byes number,
inns2_leg_byes number,
inns2_wides number,
inns2_no_balls number,
inns2_penalties number,
is_super_over varchar2(10),
Winner varchar2(100),
Result_type varchar2(200),
Toss_Winner varchar2(100),
Toss_decision varchar2(100),
Player_of_Match varchar2(200),
Player_of_Match_team varchar2(100),
Player_of_Series varchar2(100),
umpire1_name varchar2(200),
umpire1_country varchar2(50),
umpire1_gender varchar2(10),
umpire2_name varchar2(200),
umpire2_country varchar2(50),
umpire2_gender varchar2(10),
tv_umpire_name varchar2(200),
tv_umpire_country varchar2(50),
tv_umpire_gender varchar2(10),
reserve_umpire_name varchar2(200),
reserve_umpire_country varchar2(50),
reserve_umpire_gender varchar2(10),
match_referee_name varchar2(200),
match_referee_country varchar2(50),
match_referee_gender varchar2(10),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user
)
partition by range (match_date) interval (NUMTOYMINTERVAL(1,'MONTH'))
(PARTITION def_part VALUES LESS THAN (TO_DATE('01-JAN-2018', 'DD-MON-YYYY')));

grant select, insert, update, delete on tgt_t20_dbo.matches to cric_batch_user;
commit;
truncate table tgt_t20_dbo.matches; 

alter table tgt_t20_dbo.matches add Player_of_Series varchar2(100);
--------------------------------------------------------------------------------------------------------------------
-- Create error logging table in tgt schema
create table tgt_t20_dbo.error_log(
match_id number,
error_msg varchar2(1000),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on tgt_t20_dbo.error_log to cric_batch_user;
commit;
truncate table tgt_t20_dbo.error_log;
------------------------------------------------------------------------------------------------------------------
-- Create players table in tgt schema
drop table tgt_t20_dbo.players;
create table tgt_t20_dbo.players(
player_id number primary key,
player_name varchar2(200),
gender varchar2(5),
playing_role varchar2(100),
Batting_Styles varchar2(100),
Bowling_Styles varchar2(100),
birth_year number,
birth_month number,
birth_date number,
death_year number,
death_month number,
death_date number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on tgt_t20_dbo.players to cric_batch_user;
commit;
truncate table tgt_t20_dbo.players;
---------------------------------------------------------------------------------------------------------------
-- Create batting_scorecard table in tgt schema
drop table tgt_t20_dbo.batting_scorecard;
create table tgt_t20_dbo.batting_scorecard(
match_id number,
innings number,
team varchar2(100),
batter_position number,
batter_id number,
batter_name varchar2(200),
is_batted varchar2(10),
runs number,
balls number,
minutes number,
fours number,
sixes number,
strikerate number,
isOut varchar2(10),
dismissal_bowler_id number,
dismissal_bowler_name varchar2(200),
dismissal_type varchar2(50),
dismissal_fielder_id number,
dismissal_fielder_name varchar2(200),
is_keeper_dismissal number,
is_substitute_dismissal number,
fow_wicket_num number,
fow_runs number,
fow_overs number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_t20_dbo.matches(match_id),
foreign key (batter_id) references tgt_t20_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_t20_dbo.batting_scorecard to cric_batch_user;
commit;
truncate table tgt_t20_dbo.batting_scorecard;
--------------------------------------------------------------------------------------------------------------------------
-- Create bowling_scorecard table in tgt schema
drop table tgt_t20_dbo.bowling_scorecard;
create table tgt_t20_dbo.bowling_scorecard(
match_id number,
innings number,
team varchar2(100),
bowler_position number,
bowler_id number,
bowler_name varchar2(200),
overs number,
maidens number,
runs_conceded number,
wickets number,
economy number,
dots number,
fours number,
sixes number,
wides number,
noballs number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_t20_dbo.matches(match_id),
foreign key (bowler_id) references tgt_t20_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_t20_dbo.bowling_scorecard to cric_batch_user;
commit;
truncate table tgt_t20_dbo.bowling_scorecard;
---------------------------------------------------------------------------------------------------------------------------
-- Create partnerships table in tgt schema
drop table tgt_t20_dbo.partnerships;
create table tgt_t20_dbo.partnerships(
match_id number,
innings number,
team varchar2(100),
partnership_wicket number,
runs number,
balls number,
player1_id number,
player1_objid number,
player1_name varchar2(200),
player2_id number,
player2_objid number,
player2_name varchar2(200),
outPlayerId number,
player1Runs number,
player1Balls number,
player2Runs number,
player2Balls number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_t20_dbo.matches(match_id),
foreign key (player1_objid) references tgt_t20_dbo.players(player_id),
foreign key (player2_objid) references tgt_t20_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_t20_dbo.partnerships to cric_batch_user;
commit;
truncate table tgt_t20_dbo.partnerships;
----------------------------------------------------------------------------------------------------------------------------
-- Create debutants table in tgt schema
drop table tgt_t20_dbo.debutants;
create table tgt_t20_dbo.debutants(
match_id number,
team varchar2(100),
player_id number,
player_name varchar2(200),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_t20_dbo.matches(match_id),
foreign key (player_id) references tgt_t20_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_t20_dbo.debutants to cric_batch_user;
commit;
truncate table tgt_t20_dbo.debutants;
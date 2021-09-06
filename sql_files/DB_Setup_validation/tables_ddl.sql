-- Login to PDB using pdbadmin

-- Create Matches table in t20 schema
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
------------------------------------------------------------------------------------------------------------------
-- Create players table in tgt schema
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
---------------------------------------------------------------------------------------------------------------
-- Create batting_scorecard table in tgt schema
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
--------------------------------------------------------------------------------------------------------------------------
-- Create bowling_scorecard table in tgt schema
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
---------------------------------------------------------------------------------------------------------------------------
-- Create partnerships table in tgt schema
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
----------------------------------------------------------------------------------------------------------------------------
-- Create debutants table in tgt schema
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
-------------------------------------------------------------------------------------------------------------------------
-- Create ball-by-ball table in tgt schema
create table tgt_t20_dbo.bbb_data(
match_id number,
inns number,
batting_team varchar2(100),
bowling_team varchar2(100),
over_number number,
ball_number number,
iswide varchar2(10),
isNoball varchar2(10),
isRetiredHurt varchar2(10),
isBoundary varchar2(10),
total_ball_runs number,
batter_runs number,
wide_runs number,
no_ball_runs number,
bye_legbye_runs number,
total_extras_runs number,
striker_batter_id number,
striker_batter_name varchar2(200),
striker_batter_inns_runs number,
striker_batter_inns_balls number,
non_striker_batter_id number,
non_striker_batter_name varchar2(200),
non_striker_batter_inns_runs number,
non_striker_batter_inns_balls number,
current_bowler_id number,
current_bowler_name varchar2(200),
current_bowler_overs number,
current_bowler_maidens number,
current_bowler_runs number,
current_bowler_wickets number,
partner_bowler_id number,
partner_bowler_name varchar2(200),
partner_bowler_overs number,
partner_bowler_maidens number,
partner_bowler_runs number,
partner_bowler_wickets number,
current_inns_runs number,
current_inns_balls number,
current_inns_wickets number,
is_maiden_over varchar2(10),
over_runs number,
over_wickets number,
run_rate number,
reqd_run_rate number,
remaining_balls number,
remaining_runs number,
is_wicket number,
dismissed_batter_id number,
dismissed_batter_name varchar2(200),
is_bowler_wicket number,
foreign key (match_id) references tgt_t20_dbo.matches(match_id),
foreign key (striker_batter_id) references tgt_t20_dbo.players(player_id),
foreign key (non_striker_batter_id) references tgt_t20_dbo.players(player_id),
foreign key (current_bowler_id) references tgt_t20_dbo.players(player_id),
foreign key (partner_bowler_id) references tgt_t20_dbo.players(player_id),
foreign key (dismissed_batter_id) references tgt_t20_dbo.players(player_id)
);

alter table tgt_t20_dbo.bbb_data disable constraint SYS_C007713;
alter table tgt_t20_dbo.bbb_data disable constraint SYS_C007714;
alter table tgt_t20_dbo.bbb_data disable constraint SYS_C007715;
alter table tgt_t20_dbo.bbb_data disable constraint SYS_C007716;
alter table tgt_t20_dbo.bbb_data disable constraint SYS_C007717;

grant select, insert, update, delete on tgt_t20_dbo.bbb_data to cric_batch_user;
commit;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Matches table in t20 schema
create table tgt_100_dbo.matches(
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
inns1_balls number,
inns1_mins number,
inns1_extras number,
inns1_byes number,
inns1_leg_byes number,
inns1_wides number,
inns1_no_balls number,
inns1_penalties number,
inns2_team varchar2(100),
inns2_target number,
inns2_total_balls number,
inns2_runs number,
inns2_wkts number,
inns2_balls number,
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

alter table tgt_100_dbo.matches modify umpire1_gender varchar2(30);
alter table tgt_100_dbo.matches modify umpire2_gender varchar2(30);
alter table tgt_100_dbo.matches modify tv_umpire_gender varchar2(30);
alter table tgt_100_dbo.matches modify reserve_umpire_gender varchar2(30);
alter table tgt_100_dbo.matches modify match_referee_gender varchar2(30);

grant select, insert, update, delete on tgt_100_dbo.matches to cric_batch_user;
commit;
--------------------------------------------------------------------------------------------------------------------
-- Create error logging table in tgt schema
create table tgt_100_dbo.error_log(
match_id number,
error_msg varchar2(1000),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on tgt_100_dbo.error_log to cric_batch_user;
commit;
------------------------------------------------------------------------------------------------------------------
-- Create players table in tgt schema
create table tgt_100_dbo.players(
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

grant select, insert, update, delete on tgt_100_dbo.players to cric_batch_user;
commit;
---------------------------------------------------------------------------------------------------------------
-- Create batting_scorecard table in tgt schema
create table tgt_100_dbo.batting_scorecard(
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
fow_balls number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_100_dbo.matches(match_id),
foreign key (batter_id) references tgt_100_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_100_dbo.batting_scorecard to cric_batch_user;
commit;
--------------------------------------------------------------------------------------------------------------------------
-- Create bowling_scorecard table in tgt schema
create table tgt_100_dbo.bowling_scorecard(
match_id number,
innings number,
team varchar2(100),
bowler_position number,
bowler_id number,
bowler_name varchar2(200),
balls number,
maidens number,
runs_conceded number,
wickets number,
runs_per_ball number,
dots number,
fours number,
sixes number,
wides number,
noballs number,
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_100_dbo.matches(match_id),
foreign key (bowler_id) references tgt_100_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_100_dbo.bowling_scorecard to cric_batch_user;
commit;
---------------------------------------------------------------------------------------------------------------------------
-- Create partnerships table in tgt schema
create table tgt_100_dbo.partnerships(
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
foreign key (match_id) references tgt_100_dbo.matches(match_id),
foreign key (player1_objid) references tgt_100_dbo.players(player_id),
foreign key (player2_objid) references tgt_100_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_100_dbo.partnerships to cric_batch_user;
commit;
----------------------------------------------------------------------------------------------------------------------------
-- Create debutants table in tgt schema
create table tgt_100_dbo.debutants(
match_id number,
team varchar2(100),
player_id number,
player_name varchar2(200),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user,
foreign key (match_id) references tgt_100_dbo.matches(match_id),
foreign key (player_id) references tgt_100_dbo.players(player_id)
);

grant select, insert, update, delete on tgt_100_dbo.debutants to cric_batch_user;
commit;
-------------------------------------------------------------------------------------------------------------------------
-- Create ball-by-ball table in tgt schema
create table tgt_100_dbo.bbb_data(
match_id number,
inns number,
batting_team varchar2(100),
bowling_team varchar2(100),
set_number number,
ball_number number,
iswide varchar2(10),
isNoball varchar2(10),
isRetiredHurt varchar2(10),
isBoundary varchar2(10),
total_ball_runs number,
batter_runs number,
wide_runs number,
no_ball_runs number,
bye_legbye_runs number,
total_extras_runs number,
striker_batter_id number,
striker_batter_name varchar2(200),
striker_batter_inns_runs number,
striker_batter_inns_balls number,
non_striker_batter_id number,
non_striker_batter_name varchar2(200),
non_striker_batter_inns_runs number,
non_striker_batter_inns_balls number,
current_bowler_id number,
current_bowler_name varchar2(200),
current_bowler_balls number,
current_bowler_maidens number,
current_bowler_runs number,
current_bowler_wickets number,
partner_bowler_id number,
partner_bowler_name varchar2(200),
partner_bowler_balls number,
partner_bowler_maidens number,
partner_bowler_runs number,
partner_bowler_wickets number,
current_inns_runs number,
current_inns_balls number,
current_inns_wickets number,
is_maiden_set varchar2(10),
set_runs number,
set_wickets number,
runs_per_ball number,
reqd_runs_per_ball number,
remaining_balls number,
remaining_runs number,
is_wicket number,
dismissed_batter_id number,
dismissed_batter_name varchar2(200),
is_bowler_wicket number,
foreign key (match_id) references tgt_100_dbo.matches(match_id)
);

grant select, insert, update, delete on tgt_100_dbo.bbb_data to cric_batch_user;
commit;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

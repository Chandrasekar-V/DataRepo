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
select * from tgt_t20_dbo.matches;
select count(*) from tgt_t20_dbo.matches;
------------------------------------------
-- Create temp matches table
drop table temp_tgt_dbo.matches;
create table temp_tgt_dbo.matches(
match_id number primary key,
tournament varchar2(200),
gender varchar2(50),
match_type varchar2(20),
overs number,
match_date date,
team_1 varchar2(100),
team_2 varchar2(100),
venue varchar2(200),
city varchar2(100),
winner varchar2(100),
margin_type varchar2(100),
margin_number varchar2(100),
player_of_match varchar2(200),
toss_winner varchar2(100),
toss_decision varchar2(50),
umpire_1 varchar2(200),
umpire_2 varchar2(200),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user
)
partition by range (match_date) interval (NUMTOYMINTERVAL(1,'MONTH'))
(PARTITION def_part VALUES LESS THAN (TO_DATE('01-JAN-2000', 'DD-MON-YYYY')));

grant select, insert, update, delete on temp_tgt_dbo.matches to cric_batch_user;
commit;
truncate table temp_tgt_dbo.matches; 
select * from temp_tgt_dbo.matches;
select count(*) from temp_tgt_dbo.matches;

---------------------------------------------------------------------------------------------------------------------------
-- Create temporary tgt table for BBB data
drop table temp_tgt_dbo.bbb_data;
create table temp_tgt_dbo.bbb_data(
match_id number,
innings number,
batting_team varchar2(50),
bowling_team varchar2(50),
ball number,
striker varchar2(100),
non_striker varchar2(100),
bowler varchar2(100),
runs_off_bat number,
extras number,
total_ball_runs number,
wicket_type varchar2(50),
player_dismissed varchar2(100),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user
);

grant select, insert, update, delete on TEMP_TGT_DBO.bbb_data to cric_batch_user;
commit;
truncate table TEMP_TGT_DBO.bbb_data;
select * from TEMP_TGT_DBO.bbb_data;
select count(*) from TEMP_TGT_DBO.bbb_data;
--------------------------------------------------------------------------------------------------------------------
-- Create error logging table in tgt and temp schemas
create table tgt_t20_dbo.error_log(
match_id number,
error_msg varchar2(1000),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on tgt_t20_dbo.error_log to cric_batch_user;
commit;
truncate table tgt_t20_dbo.error_log;
select * from tgt_t20_dbo.error_log;
------------------------------------------
create table temp_tgt_dbo.error_log(
match_id number,
error_msg varchar2(1000),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on temp_tgt_dbo.error_log to cric_batch_user;
commit;
truncate table temp_tgt_dbo.error_log;
select * from temp_tgt_dbo.error_log;

----------------------------------------------------------------------------------------------------------------
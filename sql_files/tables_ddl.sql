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
-----------------------------------------------------------------------------------

-- Create error logging table
create table tgt_t20_dbo.error_log(
match_id number,
error_msg varchar2(1000),
rec_upd_tmst timestamp default systimestamp,
rec_upd_usr varchar2(50) default user);

grant select, insert, update, delete on tgt_t20_dbo.error_log to cric_batch_user;
commit;
truncate table tgt_t20_dbo.error_log;
select * from tgt_t20_dbo.error_log;

-- Manual deletes from error_log table to remove match_ids that have been loaded into target
delete tgt_t20_dbo.error_log where match_id in (1257948,1257951);
commit;
delete TGT_T20_DBO.error_log where match_id in (1217738,1217740,1217741,1229824,1235832,1257404,1235829,1235830,1257405,1257406);
commit;
delete TGT_T20_DBO.error_log where match_id in (1215164,1215163,1217744,1217745,1217747,1229820,1229822,1229823,1217742,1192223,1192224);
commit;
delete TGT_T20_DBO.error_log where error_msg like '%NoneType%';
commit;
delete TGT_T20_DBO.error_log where match_id in (1187677,1257183);
commit;

select * from tgt_t20_dbo.matches where extract(year from match_date) = '2018';--73 in DB and 83 in Cricinfo
select * from tgt_t20_dbo.matches where extract(year from match_date) = '2019';--216 in DB and 319 in Cricinfo
select * from tgt_t20_dbo.matches where extract(year from match_date) in ('2020','2021');-- 114 in DB and 166 in Cricinfo
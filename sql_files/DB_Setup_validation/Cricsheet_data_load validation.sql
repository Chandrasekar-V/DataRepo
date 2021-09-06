select * from TEMP_TGT_DBO.matches order by rec_upd_tmst desc;
select count(*) from temp_tgt_dbo.matches;
select distinct tournament from temp_tgt_dbo.matches;

select * from TEMP_TGT_DBO.bbb_data order by rec_upd_tmst desc;
select count(*) from TEMP_TGT_DBO.bbb_data;
select count(distinct match_id) from TEMP_TGT_DBO.bbb_data;

select * from temp_tgt_dbo.error_log;
---------------------------------------------------------------------------------------------
select * from temp_tgt_dbo.matches;
select tournament,count(*) from temp_tgt_dbo.matches group by tournament;
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where tournament='International' and match_type='T20' and gender='female' group by extract(year from match_date);
select min(match_date) from temp_tgt_dbo.matches where tournament='International' and match_type='T20' and gender='female';
delete temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where match_type='IT20');
delete temp_tgt_dbo.matches where match_type='IT20';
commit;

select team_name,count(*) from
(select * from temp_tgt_dbo.matches 
unpivot (
team_name for team in 
(team_1 as 'team', team_2 as 'team')
)) mat where gender='female' and tournament='International' and extract(year from match_date)>=2018 group by team_name order by count(*) desc; 

select * from
(select * from temp_tgt_dbo.matches 
unpivot (
team_name for team in 
(team_1 as 'team', team_2 as 'team')
)) mat where /*gender='male' and tournament='International'*/ match_type='IT20'; 

-- T20I
select gender,match_type,count(*) from temp_tgt_dbo.matches where tournament='International' group by gender,match_type; --1519 International matches - 1023 male and 496 female
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in 
(select match_id from temp_tgt_dbo.matches where tournament='International' and match_type='T20'); --1519 International matches

-- T20 Blast
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%BLAST%'; -- 904 T20 Blast matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%BLAST%'); -- 904 T20 Blast matches
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where upper(tournament) like '%BLAST%' group by extract(year from match_date);

-- BBL
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%BIG BASH%'; -- 414 BBL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%BIG BASH%'); -- 414 BBL matches
select season,count(*) from (select case when to_date(concat('01-JUN-',extract(year from match_date)),'DD-MON-YYYY') > match_date then extract(year from match_date)-1 else extract(year from match_date) end season, mat.*
from temp_tgt_dbo.matches mat where upper(tournament) like '%BIG BASH%') group by season order by season;

-- CPL
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%CARIBBEAN%'; -- 244 CPL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%CARIBBEAN%'); -- 244 CPL matches
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where upper(tournament) like '%CARIBBEAN%' group by extract(year from match_date) order by extract(year from match_date);

-- IPL
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%IPL%'; -- 845 IPL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%IPL%'); -- 845 IPL matches
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where upper(tournament) like '%IPL%' group by extract(year from match_date) order by extract(year from match_date);

-- PSL
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%PAKISTAN%'; -- 180 PSL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%PAKISTAN%'); -- 180 PSL matches
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where upper(tournament) like '%PAKISTAN%' group by extract(year from match_date) order by extract(year from match_date);

-- Super Smash men
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%SMASH%'; -- 180 PSL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%SMASH%'); -- 180 PSL matches
select season,count(*) from (select case when to_date(concat('01-JUN-',extract(year from match_date)),'DD-MON-YYYY') > match_date then extract(year from match_date)-1 else extract(year from match_date) end season, mat.*
from temp_tgt_dbo.matches mat where upper(tournament) like '%SMASH%') group by season order by season;

-- Super Smash women
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%NEW ZEALAND%'; -- 180 PSL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%NEW ZEALAND%'); -- 180 PSL matches
select season,count(*) from (select case when to_date(concat('01-JUN-',extract(year from match_date)),'DD-MON-YYYY') > match_date then extract(year from match_date)-1 else extract(year from match_date) end season, mat.*
from temp_tgt_dbo.matches mat where upper(tournament) like '%NEW ZEALAND%') group by season order by season;

-- Women's BBL
select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%BIG BASH%' and gender='female'; -- 180 PSL matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%BIG BASH%' and gender='female'); -- 180 PSL matches
select season,count(*) from (select case when to_date(concat('01-JUN-',extract(year from match_date)),'DD-MON-YYYY') > match_date then extract(year from match_date)-1 else extract(year from match_date) end season, mat.*
from temp_tgt_dbo.matches mat where upper(tournament) like '%BIG BASH%' and gender='female') group by season order by season;
select * from temp_tgt_dbo.matches where upper(tournament) like '%BIG BASH%' and gender='female' and extract(year from match_date) = 2019;
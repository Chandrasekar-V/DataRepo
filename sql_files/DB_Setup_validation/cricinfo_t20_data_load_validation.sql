select * from tgt_t20_dbo.matches order by match_date desc;
select * from tgt_t20_dbo.players;
select * from tgt_t20_dbo.batting_scorecard;
select * from tgt_t20_dbo.bowling_scorecard;
select * from tgt_t20_dbo.partnerships;
select * from tgt_t20_dbo.debutants;
select * from tgt_t20_dbo.bbb_data order by match_id,inns,over_number,ball_number;
select * from tgt_t20_dbo.error_log;
select distinct match_id from tgt_t20_dbo.error_log;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard;
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard;
select count(distinct match_id) from tgt_t20_dbo.partnerships;
select count(distinct match_id) from tgt_t20_dbo.bbb_data;

delete tgt_t20_dbo.batting_scorecard where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
delete tgt_t20_dbo.bowling_scorecard where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
delete tgt_t20_dbo.partnerships where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
delete tgt_t20_dbo.bbb_data where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
delete tgt_t20_dbo.debutants where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
delete tgt_t20_dbo.matches where match_id in (select distinct match_id from tgt_t20_dbo.error_log);
commit;

delete from tgt_t20_dbo.error_log where match_id in (
select match_id from tgt_t20_dbo.matches);
commit;

delete tgt_t20_dbo.error_log where match_id in (
select match_id from tgt_t20_dbo.matches
intersect
select distinct match_id from tgt_t20_dbo.batting_scorecard
intersect
select distinct match_id from tgt_t20_dbo.bowling_scorecard
intersect
select distinct match_id from tgt_t20_dbo.partnerships
intersect
select distinct match_id from tgt_t20_dbo.bbb_data
);
commit;

delete tgt_t20_dbo.error_log where match_id in (1147733);
commit;

/*merge into tgt_t20_dbo.bbb_data bbb using (select match_id, inns1_team, inns2_team from tgt_t20_dbo.matches) mat on (bbb.match_id = mat.match_id)
when matched then update set bbb.BATTING_TEAM = CASE WHEN INNS = 1 THEN mat.inns1_team ELSE mat.inns2_team END,
                             bbb.BOWLING_TEAM = CASE WHEN INNS = 1 THEN mat.inns2_team ELSE mat.inns1_team END;
commit;*/       

merge into tgt_t20_dbo.bbb_data bbb using (select match_id, inns1_team, NVL(inns2_team, CASE WHEN inns1_team = HOME_TEAM_NAME THEN AWAY_TEAM_NAME ELSE HOME_TEAM_NAME END) inns2_team from tgt_t20_dbo.matches) 
mat on (bbb.match_id = mat.match_id)
when matched then update set bbb.BATTING_TEAM = CASE WHEN INNS = 1 THEN mat.inns1_team ELSE mat.inns2_team END,
                             bbb.BOWLING_TEAM = CASE WHEN INNS = 1 THEN mat.inns2_team ELSE mat.inns1_team END;
commit;

merge into tgt_t20_dbo.batting_scorecard bbb using (select match_id, inns1_team, NVL(inns2_team, CASE WHEN inns1_team = HOME_TEAM_NAME THEN AWAY_TEAM_NAME ELSE HOME_TEAM_NAME END) inns2_team from tgt_t20_dbo.matches) 
mat on (bbb.match_id = mat.match_id)
when matched then update set bbb.TEAM = CASE WHEN INNINGS = 1 THEN mat.inns1_team ELSE mat.inns2_team END;
commit;

merge into tgt_t20_dbo.bowling_scorecard bbb using (select match_id, inns1_team, NVL(inns2_team, CASE WHEN inns1_team = HOME_TEAM_NAME THEN AWAY_TEAM_NAME ELSE HOME_TEAM_NAME END) inns2_team from tgt_t20_dbo.matches) 
mat on (bbb.match_id = mat.match_id)
when matched then update set bbb.TEAM = CASE WHEN INNINGS = 1 THEN mat.inns2_team ELSE mat.inns1_team END;
commit;

select INNS1_TEAM, NVL(inns2_team, CASE WHEN inns1_team = HOME_TEAM_NAME THEN AWAY_TEAM_NAME ELSE HOME_TEAM_NAME END) inns2_team from tgt_t20_dbo.matches where match_id = 1207712;

insert into tgt_t20_dbo.error_log values (1207712,'manual entry', systimestamp, user);
commit;

select * from
(select match_id, count(distinct innings) innings, count(distinct team) teams from tgt_t20_dbo.batting_scorecard group by match_id)
where innings != teams;

select * from
(select match_id, count(distinct innings) innings, count(distinct team) teams from tgt_t20_dbo.bowling_scorecard group by match_id)
where innings != teams;

select * from
(select match_id, count(distinct inns) innings, count(distinct batting_team) batting_teams, count(distinct bowling_team) bowling_teams from tgt_t20_dbo.bbb_data group by match_id)
where (innings != batting_teams) or (innings != bowling_teams) or (batting_teams != bowling_teams);

select * from tgt_t20_dbo.matches where match_id in (select distinct match_id from tgt_t20_dbo.bbb_data where bowling_team is NULL);
select * from tgt_t20_dbo.bbb_data where bowling_team is NULL;
select * from tgt_t20_dbo.batting_scorecard where team is NULL;
select * from tgt_t20_dbo.bowling_scorecard where team is NULL;

select * from
(select match_id, count(inns) innings, count(distinct batting_team) batting_teams, count(distinct bowling_team) bowling_teams from tgt_t20_dbo.bbb_data group by match_id)
where (innings > 250);

-------------------------------------------------------
select bbb.match_id,bbb.over_number,bbb.ball_number,bbb.dismissed_batter_id,bbb.dismissed_batter_name,bat_scr.dismissal_type from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.batting_scorecard bat_scr where bat_scr.batter_id = bbb.dismissed_batter_id
and bat_scr.match_id = bbb.match_id;
select * from tgt_t20_dbo.bbb_data where match_id in (1188428,1249239);
------------------------------------------------------
-- TNPL Data load
select * from (
select distinct striker_batter_id from tgt_t20_dbo.bbb_data
union
select distinct non_striker_batter_id from tgt_t20_dbo.bbb_data
union
select distinct current_bowler_id from tgt_t20_dbo.bbb_data
union
select distinct partner_bowler_id from tgt_t20_dbo.bbb_data) where striker_batter_id not in (select player_id from tgt_t20_dbo.players);

select season,count(*) from tgt_t20_dbo.matches where series_name = 'Tamil Nadu Premier League' group by season order by season;

select match_id from tgt_t20_dbo.matches
minus
select distinct match_id from tgt_t20_dbo.bbb_data;

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Tamil Nadu Premier League' and season='2019')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);
--------------------------------------------------------
-- CPL Data load
delete from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020');
delete from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020');
delete from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020');
delete from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020');
delete from tgt_t20_dbo.debutants where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020');
delete from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2020';
commit;

select season,count(*) from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' group by season order by season;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League');
select count(*) from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League';

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Caribbean Premier League' and season='2019')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);
--------------------------------------------------------
-- IPL Data load
select season,count(*) from tgt_t20_dbo.matches where series_name = 'Indian Premier League' group by season order by season;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Indian Premier League');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Indian Premier League');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Indian Premier League');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Indian Premier League');
select count(*) from tgt_t20_dbo.matches where series_name = 'Indian Premier League';

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Indian Premier League' and season='2021')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);
--------------------------------------------------------
-- PSL Data load
select season,count(*) from tgt_t20_dbo.matches where series_name = 'Pakistan Super League' group by season order by season;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Pakistan Super League');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Pakistan Super League');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Pakistan Super League');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Pakistan Super League');
select count(*) from tgt_t20_dbo.matches where series_name = 'Pakistan Super League';

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Pakistan Super League' and season='2018')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);

select mat.season,count(distinct bbb.match_id) from TGT_T20_DBO.matches mat, TGT_T20_DBO.bbb_data bbb where mat.match_id = bbb.match_id and series_name = 'Pakistan Super League' group by mat.season order by season;
--------------------------------------------------------
-- Vitality Blast Data load
select season,count(*) from tgt_t20_dbo.matches where series_name = 'Vitality Blast' group by season order by season;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast');
select count(*) from tgt_t20_dbo.matches where series_name = 'Vitality Blast';

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast' and season='2018')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);

select mat.season,count(distinct bbb.match_id) from TGT_T20_DBO.matches mat, TGT_T20_DBO.bbb_data bbb where mat.match_id = bbb.match_id and series_name = 'Vitality Blast' group by mat.season order by season;
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast' and season='2019');

delete from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Vitality Blast' and season='2019');
commit;
---------------------------------------------------------
-- BBL Data load
select season,count(*) from tgt_t20_dbo.matches where series_name = 'Big Bash League' group by season order by season;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League');
select count(*) from tgt_t20_dbo.matches where series_name = 'Big Bash League';

select distinct team_name from
(select BATTING_TEAM, BOWLING_TEAM from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League' and season='2018')) 
unpivot (
team_name for team in 
(BATTING_TEAM as 'team', BOWLING_TEAM as 'team')
);

select mat.season,count(distinct bbb.match_id) from TGT_T20_DBO.matches mat, TGT_T20_DBO.bbb_data bbb where mat.match_id = bbb.match_id and series_name = 'Big Bash League' group by mat.season order by season;
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where series_name = 'Big Bash League' and season='2019');
---------------------------------------------------------
-- Men's T20I data load
select extract(year from match_date) year,count(*) from tgt_t20_dbo.matches where match_format = 'T20I' group by extract(year from match_date) order by year;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I');
select count(*) from tgt_t20_dbo.matches where match_format = 'T20I';

select extract(year from match_date) year,count(distinct bbb.match_id) from TGT_T20_DBO.matches mat, TGT_T20_DBO.bbb_data bbb where mat.match_id = bbb.match_id and match_format = 'T20I' group by extract(year from match_date) order by year;
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I' and season='2019');

select * from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I' and match_date > '20-OCT-2019');
delete tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I' and match_date > '20-OCT-2019');
commit;

select distinct match_id from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'T20I' and match_date = '20-OCT-2019');
----------------------------------------------------------
-- Women's T20I data load
select extract(year from match_date) year,count(*) from tgt_t20_dbo.matches where match_format = 'Women''s T20I' group by extract(year from match_date) order by year;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I');
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I');
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I');
select count(distinct match_id) from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I');
select count(*) from tgt_t20_dbo.matches where match_format = 'T20I';

select extract(year from match_date) year,count(distinct bbb.match_id) from TGT_T20_DBO.matches mat, TGT_T20_DBO.bbb_data bbb where mat.match_id = bbb.match_id and match_format = 'Women''s T20I' group by extract(year from match_date) order by year;
select count(distinct match_id) from tgt_t20_dbo.partnerships where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I' and season='2019');

select * from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I' and match_date > '20-OCT-2019');
delete tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I' and match_date > '20-OCT-2019');
commit;

select distinct match_id from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where match_format = 'Women''s T20I' and match_date = '20-OCT-2019');
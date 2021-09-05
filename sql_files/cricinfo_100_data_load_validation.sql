select * from tgt_100_dbo.matches;
select * from tgt_100_dbo.players;
select * from tgt_100_dbo.batting_scorecard;
select * from tgt_100_dbo.bowling_scorecard;
select * from tgt_100_dbo.partnerships;
select * from tgt_100_dbo.debutants;
select * from tgt_100_dbo.bbb_data order by match_id,inns,set_number,ball_number;
select * from tgt_100_dbo.error_log;

select count(distinct match_id) from tgt_100_dbo.batting_scorecard;
select count(distinct match_id) from tgt_100_dbo.bowling_scorecard;
select count(distinct match_id) from tgt_100_dbo.partnerships;
select count(distinct match_id) from tgt_100_dbo.bbb_data;

delete tgt_100_dbo.batting_scorecard where match_id in (select distinct match_id from tgt_100_dbo.error_log);
delete tgt_100_dbo.bowling_scorecard where match_id in (select distinct match_id from tgt_100_dbo.error_log);
delete tgt_100_dbo.partnerships where match_id in (select distinct match_id from tgt_100_dbo.error_log);
delete tgt_100_dbo.bbb_data where match_id in (select distinct match_id from tgt_100_dbo.error_log);
delete tgt_100_dbo.debutants where match_id in (select distinct match_id from tgt_100_dbo.error_log);
delete tgt_100_dbo.matches where match_id in (select distinct match_id from tgt_100_dbo.error_log);

delete tgt_100_dbo.error_log where match_id in (
select match_id from tgt_100_dbo.matches
intersect
select distinct match_id from tgt_100_dbo.batting_scorecard
intersect
select distinct match_id from tgt_100_dbo.bowling_scorecard
intersect
select distinct match_id from tgt_100_dbo.partnerships
intersect
select distinct match_id from tgt_100_dbo.bbb_data
);
commit;
-------------------------------------------------------
select bbb.match_id,bbb.over_number,bbb.ball_number,bbb.dismissed_batter_id,bbb.dismissed_batter_name,bat_scr.dismissal_type from tgt_100_dbo.bbb_data bbb, tgt_100_dbo.batting_scorecard bat_scr where bat_scr.batter_id = bbb.dismissed_batter_id
and bat_scr.match_id = bbb.match_id;
select * from tgt_100_dbo.bbb_data where match_id in (1188428,1249239);
------------------------------------------------------
-- TNPL Data load
select * from (
select distinct striker_batter_id from tgt_100_dbo.bbb_data
union
select distinct non_striker_batter_id from tgt_100_dbo.bbb_data
union
select distinct current_bowler_id from tgt_100_dbo.bbb_data
union
select distinct partner_bowler_id from tgt_100_dbo.bbb_data) where striker_batter_id not in (select player_id from tgt_100_dbo.players);

select match_id from tgt_100_dbo.matches
minus
select distinct match_id from tgt_100_dbo.bbb_data;
--------------------------------------------------------
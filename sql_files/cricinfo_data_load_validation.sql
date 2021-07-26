truncate table tgt_t20_dbo.batting_scorecard;
truncate table tgt_t20_dbo.bowling_scorecard;
truncate table tgt_t20_dbo.partnerships;
truncate table tgt_t20_dbo.debutants;
truncate table tgt_t20_dbo.matches;
truncate table tgt_t20_dbo.players;
truncate table tgt_t20_dbo.error_log;
-------------------------------------------------------
select * from tgt_t20_dbo.matches;
select * from tgt_t20_dbo.players;
select * from tgt_t20_dbo.batting_scorecard;
select * from tgt_t20_dbo.bowling_scorecard;
select * from tgt_t20_dbo.partnerships;
select * from tgt_t20_dbo.debutants;
select * from tgt_t20_dbo.error_log;

select count(distinct match_id) from tgt_t20_dbo.batting_scorecard;
select count(distinct match_id) from tgt_t20_dbo.bowling_scorecard;
select count(distinct match_id) from tgt_t20_dbo.partnerships;
-------------------------------------------------------
delete tgt_t20_dbo.batting_scorecard where match_id = 1243391;
delete tgt_t20_dbo.bowling_scorecard where match_id = 1243391;
delete tgt_t20_dbo.partnerships where match_id = 1243391;
delete tgt_t20_dbo.matches where match_id = 1243391;
commit;
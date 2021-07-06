select * from temp_tgt_dbo.matches;
select tournament,count(*) from temp_tgt_dbo.matches group by tournament;
select extract(year from match_date),count(*) from temp_tgt_dbo.matches where tournament='International' and match_type='T20' and gender='male' group by extract(year from match_date);

select team_name,count(*) from
(select * from temp_tgt_dbo.matches 
unpivot (
team_name for team in 
(team_1 as 'team', team_2 as 'team')
)) mat where gender='male' and tournament='International' and match_type='T20' /*and extract(year from match_date)>=2018*/ group by team_name order by count(*) desc; 

select * from
(select * from temp_tgt_dbo.matches 
unpivot (
team_name for team in 
(team_1 as 'team', team_2 as 'team')
)) mat where gender='male' and tournament='International'; 

select gender,match_type,count(*) from temp_tgt_dbo.matches where tournament='International' group by gender,match_type; --1851 International matches - 1275 male (1023 T20I and 252 T20s) and 576 female (496 T20I and 80 T20s)
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in 
(select match_id from temp_tgt_dbo.matches where tournament='International' and match_type='IT20'); --1851 International matches (1519 T20I and 332 unofficial T20s)

select count(*) from temp_tgt_dbo.matches where upper(tournament) like '%BLAST%'; -- 904 T20 Blast matches
select count(distinct match_id) from temp_tgt_dbo.bbb_data where match_id in (select match_id from temp_tgt_dbo.matches where upper(tournament) like '%BLAST%'); -- 904 T20 Blast matches

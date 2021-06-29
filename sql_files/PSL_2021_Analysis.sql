select * from TEMP_TGT_DBO.PSL_DATA;
select count(*) from TEMP_TGT_DBO.PSL_DATA;
select extract(year from start_date), count(distinct match_id) from TEMP_TGT_DBO.PSL_DATA group by extract(year from start_date) order by extract(year from start_date);

-- 9th June - Highest scoring PP batters in PSL since 2020 season start.
with data_2021_pp as (select * from TEMP_TGT_DBO.PSL_DATA where extract(year from start_date) in (2020,2021) and trunc(ball) between 0 and 5 order by start_date,innings,ball)
select runs.*,balls.balls_count,round((runs_count/balls_count)*100,2) strike_rate from (select data.striker,sum(data.runs_off_bat) runs_count from data_2021_pp data group by data.striker) runs,
(select striker,count(*) balls_count from data_2021_pp where wides is null group by striker) balls where runs.striker = balls.striker and runs_count >= 50 order by strike_rate desc;

-- 10th June
-- Highest scoring teams in PP in PSL 2021 first half and PSL 2020
with data_2021_pp as (select * from TEMP_TGT_DBO.PSL_DATA where extract(year from start_date) in (2020,2021) and trunc(ball) between 0 and 5 order by start_date,innings,ball)
select runs.*,balls.balls_count,round((runs_count/balls_count)*6,2) run_rate, round((balls_count/wickets_lost),2) balls_per_dismissal from (select data.batting_team,sum(data.TOTAL_BALL_RUNS) runs_count, 
sum(case when WICKET_TYPE is null then 0 else 1 end) wickets_lost from data_2021_pp data group by data.batting_team) runs,
(select batting_team,count(*) balls_count from data_2021_pp where wides is null and noballs is null group by batting_team) balls where runs.batting_team = balls.batting_team order by run_rate desc;

-- Best bowling teams in PP
with data_2021_pp as (select * from TEMP_TGT_DBO.PSL_DATA where extract(year from start_date) in (2020,2021) and trunc(ball) between 0 and 5 order by start_date,innings,ball)
select runs.*,balls.balls_count,round((runs_count/balls_count)*6,2) run_rate, round((balls_count/wickets_lost),2) balls_per_dismissal from (select data.bowling_team,sum(data.TOTAL_BALL_RUNS) runs_count, 
sum(case when WICKET_TYPE is null then 0 else 1 end) wickets_lost from data_2021_pp data group by data.bowling_team) runs,
(select bowling_team,count(*) balls_count from data_2021_pp where wides is null and noballs is null group by bowling_team) balls where runs.bowling_team = balls.bowling_team order by run_rate;

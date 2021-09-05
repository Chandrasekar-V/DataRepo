select * from tgt_t20_dbo.matches order by match_date desc;
select * from tgt_t20_dbo.players;
select * from tgt_t20_dbo.batting_scorecard;
select * from tgt_t20_dbo.bowling_scorecard;
select * from tgt_t20_dbo.partnerships;
select * from tgt_t20_dbo.debutants;
select * from tgt_t20_dbo.bbb_data order by match_id,inns,over_number,ball_number;
-------------------------------------------------------------------------------------------------------------
select venue,count(*) from tgt_t20_dbo.matches where series_name like '%Caribbean%' group by venue;

select venue, matches, TOTAL_RUNS, TOTAL_BALLS, TOTAL_WKTS, trunc((TOTAL_RUNS/TOTAL_BALLS)*6,2) RUN_RATE, trunc(TOTAL_BALLS/TOTAL_WKTS,2) DISMISSAL_RATE, trunc(TOTAL_RUNS/TOTAL_WKTS,2) AVERAGE from 
    (select venue, count(*) matches, sum(match_runs) total_runs, sum(match_balls) total_balls, sum(match_wkts) total_wkts from 
        (select venue,inns1_runs+inns2_runs match_runs, inns1_wkts+inns2_wkts match_wkts, (trunc(inns1_overs)*6+(inns1_overs - trunc(inns1_overs))*10) + (trunc(inns2_overs)*6 + (inns2_overs - trunc(inns2_overs))*10) match_balls 
        from tgt_t20_dbo.matches where series_name like '%Caribbean%') 
     group by venue) 
order by DISMISSAL_RATE desc; 
-- St.Kitts most batting friendly venue in last 3 seasons
--------------------------------------------------------------------------------------------------------------

-- Match 1: GAW vs TKR
select bowling_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020') and over_number between 1 and 6 group by bowling_team) 
order by dismissal_rate; 
-- GAW and SLK best, SKNP and JT worst in PP bowling

with bowl_type as 
    (select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select current_bowler_name,bowling_arm,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name,bowling_arm,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020' and bowling_team='Trinbago Knight Riders') and over_number between 1 and 6
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by current_bowler_name,bowling_arm,bowling_type);
-- Ali Khan and Spinners picked wickets for TKR in PP in CPL 2020

with bowl_type as 
    (select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select spin_pace,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select case when bowling_type like '%spin%' then 'Spin' else 'Pace' end spin_pace, sum(runs) runs,sum(balls) balls,sum(wickets) wickets from  
        (select current_bowler_name,bowling_arm,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
        tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
        (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020' and bowling_team='Trinbago Knight Riders') and over_number between 1 and 6
        and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by current_bowler_name,bowling_arm,bowling_type)
    group by case when bowling_type like '%spin%' then 'Spin' else 'Pace' end
); 
-- Stats comparison between Spin and pace bowling 

select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
    case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
         when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
         when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
    end bowling_type
from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null); 
-- Classification of bowling types and arm.

with bowl_type as 
    (select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select striker_batter_name,bowling_arm,bowling_type,runs,balls,wickets,trunc((runs/balls)*100,2) strike_rate, trunc((balls/wickets),2) dismissal_rate from
    (select striker_batter_name,bowling_arm,bowling_type,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets 
    from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where striker_batter_id = 53116 and match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020')
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by striker_batter_name,bowling_arm,bowling_type); 
-- Simmons struggled against bowlers spinning it away from him last CPL
---------------------------------------------------------------------------------------------------------------------------------

-- Match 2: BR v SKNP
select mat.match_id,mat.series_match_no,mat.match_date,bowling_team,runs,balls,wickets from
    (select match_id, bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where bowling_team = 'St Kitts and Nevis Patriots' and over_number between 1 and 6 group by match_id, bowling_team) bbb
, tgt_t20_dbo.matches mat where bbb.match_id = mat.match_id order by match_date desc; 
-- SKNP PP numbers with ball last few matches
----------------------------------------------------------------------------------------------------------------------------------

-- Match 3: JT v SLK
select batting_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 1 and 6 group by batting_team)
order by run_rate desc; 
-- PP batting stats: Run Rate - STZ and TKR best, JT and GAW worst. Dismissal rate - TKR and SKNP best, JT and GAW worst 

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2019','2020')) and batting_team='St Lucia Zouks' and over_number between 1 and 6
    group by striker_batter_name);
-- Bulk of scoring for St Lucia in PP over last 2 seasons done by Cornwall, Fletcher and Deyal

select mat.match_id, mat.match_date, mat.season, mat.series_match_no, bat.batter_position, batter_id, batter_name, runs, balls, strikerate from tgt_t20_dbo.batting_scorecard bat, tgt_t20_dbo.matches mat 
where bat.match_id = mat.match_id and series_name like '%Caribbean%' and season in ('2019','2020') and team = 'St Lucia Zouks' and batter_position between 1 and 3 order by match_date,batter_position;
-- Batting position for St Lucia last 2 seasons

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Indian%' and season in ('2020','2021')) and over_number between 1 and 6
    group by striker_batter_name having sum(BATTER_RUNS) >= 50)
order by strike_rate desc;
-- PP SR since IPL 2020

select mat.match_id,mat.series_match_no,mat.match_date,batting_team,runs,balls,wickets from
    (select match_id, batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where batting_team = 'Jamaica Tallawahs' and over_number between 1 and 6 group by match_id, batting_team) bbb
, tgt_t20_dbo.matches mat where bbb.match_id = mat.match_id order by match_date desc; 
-- JT last few matches PP batting score

select bowling_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020') and over_number between 16 and 20 group by bowling_team)
order by economy_rate; 
-- Death bowling economy rates - Kings good in 2019 but average in 2020, TKR and GAW best in economy rate in 2020

select current_bowler_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and bowling_team like '%St Lucia%' and over_number between 16 and 20
    group by current_bowler_name);
-- St Lucia 2020 CPL death bowlers' stats

select current_bowler_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2019','2018'))  
    and over_number between 16 and 20 group by current_bowler_name having sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) >= 75)
order by economy_rate;
-- Overall death bowlers stats in last 3 CPL seasons

select batting_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 16 and 20 group by batting_team)
order by run_rate desc; 
-- Death overs batting 2020 - TKR and JT at the top, SLK and SKNP bottom

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 16 and 20
    group by striker_batter_name)
order by strike_rate desc;
-- Death overs batting SR last season
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Match 4: BR v TKR
select batting_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 7 and 15 group by batting_team)
order by run_rate desc; 
-- Middle overs batting - TKR leading head and shoulders above rest

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate, trunc(runs/wickets,2) average from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and batting_team like '%Trinbago Knight Riders%' 
    and over_number between 7 and 15 group by striker_batter_name);
-- Simmons, Bravo, Munro leading average and SR for TKR in middle phase in 2020

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate, trunc(runs/wickets,2) average from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020'))  
    and over_number between 7 and 15 group by striker_batter_name having sum(case when iswide = '0' then 1 else 0 end) >= 20)
order by average desc nulls last;
-- Overall stats for middle phase batting last CPL
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Match 5: GAW v SKNP

select match_id, match_date, series_match_no, inns1_team, inns1_runs, inns1_overs, inns2_team, inns2_runs, inns2_overs, winner from tgt_t20_dbo.matches where 
home_team_name = 'Guyana Amazon Warriors' or away_team_name = 'Guyana Amazon Warriors' order by match_date desc;
-- last few matches for GAW

select current_bowler_name,season,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,season,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat where bbb.match_id=mat.match_id and series_name like '%Caribbean%' and current_bowler_id = 495551
    and over_number between 1 and 6 group by current_bowler_name,season /*having sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) >= 75*/)
order by dismissal_rate;
-- Cottrell consistently getting PP wickets every season

select current_bowler_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and bowling_team like '%St Kitts%' and over_number between 1 and 6
    group by current_bowler_name);
-- St Kitts PP bowlers last season numbers

select current_bowler_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 1 and 6
    group by current_bowler_name having sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) >= 30)
order by dismissal_rate;
-- PP bowlers stats last season

select batting_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2021')) and over_number between 1 and 6 group by batting_team)
order by run_rate desc; 
-- PP batting stats 2020: Run Rate - STZ and TKR best, JT and GAW worst. Dismissal rate - TKR and SKNP best, JT and GAW worst 

select current_bowler_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 16 and 20
    group by current_bowler_name)
order by economy_rate;
-- 2020 CPL death bowlers' stats

with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select bowling_team,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select bowling_team,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2019')) and over_number between 7 and 15
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by bowling_team,bowling_type)
order by bowling_team;
-- Pace vs Spin comparison for teams in CPL 2019 and 2020 during middle phase

with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select match_id,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select match_id,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and bowling_team like '%Guyana%' and over_number between 7 and 15
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by match_id,bowling_type)
order by match_id;
-- Pace vs Spin comparison by match for Guyana in CPL 2020 during middle phase

select season,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select season, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat 
     where bbb.match_id = mat.match_id and series_name like '%Caribbean%' and over_number between 1 and 6 group by season)
order by run_rate desc;
-- Evin Lewis vs each bowling type
---------------------------------------------------------------------------------------------------------------------

-- Match 7: SLK v TKR

select season,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select season, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat 
     where bbb.match_id = mat.match_id and series_name like '%Caribbean%' and over_number between 1 and 6 group by season)
order by run_rate desc; 
-- This year has seen PP wickets falling lot more often than previous seasons

with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select season,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select season,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type, tgt_t20_dbo.matches mat where bbb.match_id = mat.match_id and series_name like '%Caribbean%' and over_number between 1 and 6
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by season,bowling_type)
order by season;
-- Season wise breakup of pace vs spin bowlers in PP phase

with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null)),
    first6_mat as
    (select * from
        (select season, match_id, match_date, series_match_no, row_number() over (partition by season order by match_date,match_id,series_match_no) match_rank from tgt_t20_dbo.matches
         where series_name like '%Caribbean%') 
    where match_rank <= 6)
select season,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select season,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type, first6_mat mat where bbb.match_id = mat.match_id and over_number between 1 and 6
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by season,bowling_type)
order by season;
-- Season wise breakup of pace vs spin bowlers in PP phase in first 6 matches of each season

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate, trunc(runs/wickets,2) average from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and batting_team like '%St Lucia%' 
    and over_number between 7 and 15 group by striker_batter_name);
-- Middle over batter SR for St. Lucia last season

select BATTING_TEAM, DOTS, (DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES) total_balls, trunc((DOTS/(DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES))*100,2) dots_percentage from
    ((select batting_team, total_ball_runs from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2021'))  
    and over_number between 7 and 15 and iswide = '0')
    pivot 
    (
        count(total_ball_runs) for total_ball_runs in (0 as dots,1 as singles,2 as twos,3 as three,4 as fours,5 as fives,6 as sixes)
    ))
order by dots_percentage;
-- Dot ball percenatges since last CPL during middle phase for all teams - TKR least in that aspect

with batter_id as 
    (select striker_batter_id,striker_batter_name,sum(BATTER_RUNS) runs from tgt_t20_dbo.bbb_data bbb where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) 
    and over_number between 7 and 15 group by striker_batter_id,striker_batter_name having sum(BATTER_RUNS) >= 25)
select striker_batter_name, DOTS, (DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES) total_balls, trunc((DOTS/(DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES))*100,2) dots_percentage from
    ((select bbb.striker_batter_name, bbb.BATTER_RUNS from tgt_t20_dbo.bbb_data bbb, batter_id where bbb.striker_batter_id = batter_id.striker_batter_id
      and match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020'))  
      and over_number between 7 and 15 and iswide = '0')
    pivot 
    (
        count(BATTER_RUNS) for BATTER_RUNS in (0 as dots,1 as singles,2 as twos,3 as three,4 as fours,5 as fives,6 as sixes)
    ))
order by dots_percentage 
;
-- Dot ball percenatges per player last CPL during middle phase
--------------------------------------------------------------------------------------------------------------------------------------------

-- Match 8: SKNP v GAW
select bowling_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 1 and 6 group by bowling_team) 
order by dismissal_rate; 

select current_bowler_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name, count(distinct match_id) matches, sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and bowling_team like '%Guyana%' and over_number between 1 and 6
    group by current_bowler_name);
--------------------------------------------------------------------------------------------------------------------------------------------

-- Match 10: BR v JT
select bowling_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2021')) and over_number between 7 and 15 group by bowling_team)
order by dismissal_rate; 
-- BR worst since last season start in middle overs bowling (ER 6.8, DR: 26.8) - St Lucia (ER: 6.86 and DR: 20.91)

select current_bowler_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name, count(distinct match_id) matches, sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2019','2020')) and bowling_team like '%Barbados%' and over_number between 7 and 15
    group by current_bowler_name);
-- Hayden Walsh struggling this season but was very good in 2019 and 2020.

select current_bowler_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select current_bowler_name, count(distinct match_id) matches, sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2019','2020')) /*and bowling_team like '%Barbados%'*/ and over_number between 7 and 15
    group by current_bowler_name)
where balls>=75 order by dismissal_rate;
--------------------------------------------------------------------------------------------------------------------------------------------

-- Match 11: TKR v GAW
select batting_team,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2021')) and over_number between 1 and 6 group by batting_team)
order by run_rate desc; 
-- PP batting stats - TKR lowest run rate this season

select striker_batter_name,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate, trunc(runs/wickets,2) average from
    (select striker_batter_name,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) 
    and over_number between 1 and 6 group by striker_batter_name);

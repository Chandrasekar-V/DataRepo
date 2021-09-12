-- Venue wise overall stats 
select venue, matches, TOTAL_RUNS, TOTAL_BALLS, TOTAL_WKTS, trunc((TOTAL_RUNS/TOTAL_BALLS)*6,2) RUN_RATE, trunc(TOTAL_BALLS/TOTAL_WKTS,2) DISMISSAL_RATE, trunc(TOTAL_RUNS/TOTAL_WKTS,2) AVERAGE from 
    (select venue, count(*) matches, sum(match_runs) total_runs, sum(match_balls) total_balls, sum(match_wkts) total_wkts from 
        (select venue,inns1_runs+inns2_runs match_runs, inns1_wkts+inns2_wkts match_wkts, (trunc(inns1_overs)*6+(inns1_overs - trunc(inns1_overs))*10) + (trunc(inns2_overs)*6 + (inns2_overs - trunc(inns2_overs))*10) match_balls 
        from tgt_t20_dbo.matches where series_name like '%Caribbean%') 
     group by venue) 
order by DISMISSAL_RATE desc; 

-- Match wise details on toss winner, match winner, Inns1 and Inns2 teams filtered for a team
select match_id, match_date, series_match_no, inns1_team, inns2_team, winner, toss_winner, toss_decision from tgt_t20_dbo.matches where (home_team_name = 'Guyana Amazon Warriors' or away_team_name = 'Guyana Amazon Warriors') 
and season='2021' order by match_date desc;

-- Season wise stats for a particular phase
select season,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select season, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat 
     where bbb.match_id = mat.match_id and series_name like '%Caribbean%' and over_number between 1 and 6 group by season)
order by dismissal_rate; 

-- Season wise breakup of pace vs spin bowlers in a phase
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

-- Season wise breakup of pace vs spin bowlers in a phase in first x matches of season        
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

-- Batting teams in a particular phase
select batting_team,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) run_rate from
    (select batting_team, count(distinct match_id) matches, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and over_number between 1 and 6 group by batting_team)
order by run_rate desc; 

-- Batters in a particular phase
select striker_batter_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name, count(distinct match_id) matches, sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2019','2020')) and over_number between 1 and 6
    group by striker_batter_name)
order by strike_rate desc;

-- Batters for a team in a particular phase
select striker_batter_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name,count(distinct match_id) matches,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2019','2020')) and batting_team='St Lucia Zouks' and over_number between 1 and 6
    group by striker_batter_name)
order by strike_rate desc;

-- Season wise stats for a batter in a phase
select striker_batter_name,season,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*100,2) strike_rate from
    (select striker_batter_name,season,count(distinct bbb.match_id) matches,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat where bbb.match_id=mat.match_id and series_name like '%Caribbean%' and striker_batter_id = 391832
    /*and over_number between 1 and 6*/ group by striker_batter_name,season)
order by season;

-- Bowling teams in a particular phase
select bowling_team,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select bowling_team, count(distinct match_id) matches, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from tgt_t20_dbo.bbb_data where match_id in (select match_id from 
    tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020') and over_number between 1 and 6 group by bowling_team) 
order by dismissal_rate; 

-- Bowlers in a particular phase
select current_bowler_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,count(distinct match_id) matches,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2019'))  
    and over_number between 16 and 20 group by current_bowler_name)
where balls >= 75 order by economy_rate;

-- Bowlers for a team in a particular phase
select current_bowler_name,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,count(distinct match_id) matches,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2021')) and bowling_team like '%Barbados%'  
    and over_number between 1 and 6 group by current_bowler_name)
/*where balls >= 75*/ order by economy_rate;

-- Season wise stats for a bowler in a phase
select current_bowler_name,season,matches,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) economy_rate from
    (select current_bowler_name,season,count(distinct bbb.match_id) matches,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.matches mat where bbb.match_id=mat.match_id and series_name like '%Caribbean%' and current_bowler_id = 495551
    and over_number between 1 and 6 group by current_bowler_name,season)
order by season;

-- Bowlers stats along with Arm and bowling type for a team
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
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020') and bowling_team='Trinbago Knight Riders' and over_number between 1 and 6
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by current_bowler_name,bowling_arm,bowling_type);

-- Pace vs Spin comparison for bowlers of a team
with bowl_type as 
    (select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select bowling_team,spin_pace,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select bowling_team,case when bowling_type like '%spin%' then 'Spin' else 'Pace' end spin_pace, sum(runs) runs,sum(balls) balls,sum(wickets) wickets from  
        (select bowling_team,current_bowler_name,bowling_arm,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
        tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
        (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020') and bowling_team like '%Barbados%' and over_number between 1 and 6
        and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by bowling_team,current_bowler_name,bowling_arm,bowling_type)
    group by bowling_team,case when bowling_type like '%spin%' then 'Spin' else 'Pace' end
    ); 

-- Pace vs Spin bowling comparison among all teams in a phase
with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select bowling_team,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select bowling_team,bowling_type,sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2021')) and over_number between 1 and 6
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by bowling_team,bowling_type)
order by bowling_team;

-- Pace vs Spin comparison for a team per match in a phase
with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select bowling_team,match_id,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select bowling_team,match_id,bowling_type,sum(BATTER_RUNS+WIDE_RUNS+NO_BALL_RUNS) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020')) and bowling_team like '%Guyana%' and over_number between 7 and 15
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by bowling_team,match_id,bowling_type)
order by bowling_type;

-- A batter vs each bowling type and arm
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

-- A batter vs pace and spin
with bowl_type as 
    (select bowling_styles, case when bowling_styles like '%left%' then 'Left' else 'Right' end bowling_arm,
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Off spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Leg spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select striker_batter_name,spin_pace,runs,balls,wickets,trunc((runs/balls)*100,2) strike_rate, trunc((balls/wickets),2) dismissal_rate from
    (select striker_batter_name,case when bowling_type like '%spin%' then 'Spin' else 'Pace' end spin_pace, sum(runs) runs,sum(balls) balls,sum(wickets) wickets from  
        (select striker_batter_name,bowling_arm,bowling_type,sum(BATTER_RUNS) runs,sum(case when iswide = '0' then 1 else 0 end) balls, sum(is_wicket) wickets 
        from tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where striker_batter_id = 53116 and match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season='2020')
        and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by striker_batter_name,bowling_arm,bowling_type)
    group by striker_batter_name,case when bowling_type like '%spin%' then 'Spin' else 'Pace' end
    ); 

-- Pace vs Spin batting comparison among all teams in a phase
with bowl_type as 
    (select bowling_styles, 
        case when (bowling_styles like '%fast%' or bowling_styles like '%medium%') then 'Pace'
             when (bowling_styles like '%offbreak%' or bowling_styles like '%orthodox%') then 'Spin'
             when (bowling_styles like '%legbreak%' or bowling_styles like '%wrist%') then 'Spin'
        end bowling_type
    from (select distinct bowling_styles from tgt_t20_dbo.players where bowling_styles is not null))
select batting_team,bowling_type,runs,balls,wickets,trunc(balls/wickets,2) dismissal_rate, trunc((runs/balls)*6,2) econoomy_rate from
    (select batting_team,bowling_type,sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb, tgt_t20_dbo.players players, bowl_type where match_id in 
    (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2019')) and over_number between 7 and 15
    and bbb.current_bowler_id = players.player_id and players.bowling_styles = bowl_type.bowling_styles group by batting_team,bowling_type)
order by batting_team;

-- Per match team bowling performances in a phase, sorted by match recency
select mat.match_id,mat.series_match_no,mat.match_date,bowling_team,runs,balls,wickets from
    (select match_id, bowling_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where bowling_team = 'St Kitts and Nevis Patriots' and over_number between 1 and 6 group by match_id, bowling_team) 
bbb,tgt_t20_dbo.matches mat where bbb.match_id = mat.match_id order by match_date desc; 

-- Per match team batting performances in a phase, sorted by match recency
select mat.match_id,mat.series_match_no,mat.match_date,batting_team,runs,balls,wickets from
    (select match_id, batting_team, sum(total_ball_runs) runs,sum(case when iswide = '0' and isnoball = '0' then 1 else 0 end) balls, sum(is_wicket) wickets from 
    tgt_t20_dbo.bbb_data bbb where batting_team = 'St Kitts and Nevis Patriots' and over_number between 1 and 6 group by match_id, batting_team) 
bbb,tgt_t20_dbo.matches mat where bbb.match_id = mat.match_id order by match_date desc; 

-- Performances of top 3 batters for a team per match
select mat.match_id, mat.match_date, mat.season, mat.series_match_no, bat.batter_position, batter_id, batter_name, runs, balls, strikerate from tgt_t20_dbo.batting_scorecard bat, tgt_t20_dbo.matches mat 
where bat.match_id = mat.match_id and series_name like '%Caribbean%' and season in ('2019','2020') and team = 'St Lucia Zouks' and batter_position between 1 and 3 order by match_date,batter_position;

-- Season wise batting performances for a team for batters in positions 1-3
select BATTER_NAME, MATCHES, RUNS, BALLS, DISMISSALS, trunc((runs/balls)*100,2) strike_rate, trunc((balls/DISMISSALS),2) dismissal_rate from
    (select batter_name, count(bat.match_id) matches, sum(runs) runs, sum(balls) balls, sum(isout) dismissals from tgt_t20_dbo.batting_scorecard bat, tgt_t20_dbo.matches mat 
    where bat.match_id = mat.match_id and series_name like '%Caribbean%' and season in ('2019','2020') and team = 'St Lucia Zouks' and batter_position between 1 and 3
    group by batter_name);
    
-- Season wise batting performances among all teams for batters in positions 1-3 combined
select team, MATCHES, RUNS, BALLS, DISMISSALS, trunc((runs/balls)*100,2) strike_rate, trunc((balls/DISMISSALS),2) dismissal_rate from
    (select team, count(bat.match_id) matches, sum(runs) runs, sum(balls) balls, sum(isout) dismissals from tgt_t20_dbo.batting_scorecard bat, tgt_t20_dbo.matches mat 
    where bat.match_id = mat.match_id and series_name like '%Caribbean%' and season in ('2021') and batter_position between 1 and 3
    group by team);   

-- Dot ball percenatges in a phase for teams    
select BATTING_TEAM, DOTS, (DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES) total_balls, trunc((DOTS/(DOTS + SINGLES + TWOS + THREE + FOURS + FIVES + SIXES))*100,2) dots_percentage from
    ((select batting_team, total_ball_runs from tgt_t20_dbo.bbb_data where match_id in (select match_id from tgt_t20_dbo.matches where series_name like '%Caribbean%' and season in ('2020','2021'))  
    and over_number between 7 and 15 and iswide = '0')
    pivot 
    (
        count(total_ball_runs) for total_ball_runs in (0 as dots,1 as singles,2 as twos,3 as three,4 as fours,5 as fives,6 as sixes)
    ))
order by dots_percentage;

-- Dot ball percentages in a phase for batters
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


    
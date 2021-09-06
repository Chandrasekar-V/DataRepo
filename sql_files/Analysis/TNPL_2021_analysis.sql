with mat as (select match_id from tgt_t20_dbo.matches where series_name = 'Tamil Nadu Premier League' and season=2021),
bbb_1 as
(select bbb.striker_batter_id,bbb.striker_batter_name,sum(batter_runs) batter_runs,sum(case iswide when '0' then 1 else 0 end) balls from tgt_t20_dbo.bbb_data bbb, mat where over_number between 1 and 6 and bbb.match_id = mat.match_id 
group by bbb.striker_batter_id,bbb.striker_batter_name)
select striker_batter_id, striker_batter_name, batter_runs, balls, round((batter_runs/balls)*100,2) strike_rate from bbb_1 order by strike_rate desc;
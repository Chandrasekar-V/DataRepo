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

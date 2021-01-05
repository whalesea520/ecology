delete from HrmUserSetting where id not in (select MIN(id) from HrmUserSetting  group by resourceId)
/
update HrmUserSetting set skin = 'default' where theme='ecology8'
/
update HrmUserSetting set isCoworkHead ='1' where isCoworkHead is null
/
update HrmUserSetting set rtxOnload =(select RtxOnload from RTXSetting) where rtxOnload is null
/

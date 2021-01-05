delete from HrmUserSetting where id not in (select MIN(id) from HrmUserSetting  group by resourceId)
GO
update HrmUserSetting set skin = 'default' where theme='ecology8'
GO
update HrmUserSetting set isCoworkHead ='1' where isCoworkHead is null
GO
update HrmUserSetting set rtxOnload =(select RtxOnload from RTXSetting) where rtxOnload is null
GO

ALTER procedure HrmResourceDateCheck
 (@today_1 char(10),
  @flag int output, @msg varchar(60) output)
 as 
 /* ???芍那?豕??迆米?芍?米?豕??㊣???a?TD∫℅∩足? */
 delete from hrmrolemembers where resourceid in (
        select id from HrmResource 
        where (status = 0 or status = 1 or status = 2 or status = 3) 
        and enddate < @today_1 and enddate <>'' and enddate is not null 
 )
 delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue in (
        select id from HrmResource  
        where (status = 0 or status = 1 or status = 2 or status = 3) 
        and enddate < @today_1 and enddate <>'' and enddate is not null 
 )
 update HrmResource set status = 7 where (status = 0 or status = 1 or status = 2 or status = 3) and enddate < @today_1 and enddate <>'' and enddate is not null
 
 /* ??那?車?豕??迆米?芍?米?豕??㊣???a那?車??車?迆℅∩足? */
 update HrmResource set status = 3 where status = 0 and probationenddate < @today_1 and probationenddate<>'' and probationenddate is not null

 /* ??那?車?豕??迆?∩米?米?豕??㊣車谷那?車??車?迆????那?車?℅∩足? */
 update HrmResource set status = 0 where status = 3 and (probationenddate >= @today_1 or probationenddate='' or probationenddate is null)
GO
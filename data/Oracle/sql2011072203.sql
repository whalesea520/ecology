CREATE or REPLACE procedure HrmResourceDateCheck
 (today_1 char,
	flag out integer  ,
	msg  out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as
 begin
 /* 将结束日期到了的人员改为无效状态 */
  delete from hrmrolemembers where resourceid in (
        select id from HrmResource 
        where (status = 0 or status = 1 or status = 2 or status = 3) 
        and enddate < today_1  and enddate is not null 
  );
  delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue in (
        select id from HrmResource  
        where (status = 0 or status = 1 or status = 2 or status = 3) 
        and enddate < today_1 and enddate is not null 
 );
 update HrmResource set status = 7 , loginid='',password='' where (status = 0 or status = 1 or status = 2 or status = 3) and enddate < today_1 and enddate is not null ;

 /* 将试用日期到了的人员改为试用延期状态 */
 update HrmResource set status = 3 where status = 0 and probationenddate < today_1 and probationenddate is not null ;

 /* 将试用日期未到的人员由试用延期改回试用状态 */
 update HrmResource set status = 0 where status = 3 and (probationenddate >= today_1 or probationenddate is null) ;
end;
/
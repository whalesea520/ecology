/*td:996 by dp for 人力资源发生解聘、离职、退休后,清除登录名*/
ALTER PROC HrmResourceDateCheck
 (@today_1 char(10),
  @flag int output,
  @msg varchar(60) output)
 as 
 update HrmResource set status = 7 , loginid='',password='' where (status = 0 or status = 1 or status = 2 or status = 3) and enddate < @today_1 and enddate <>''
 update HrmResource set status = 3  where   status = 0 and probationenddate < @today_1 
go
update HrmResource set loginid='',password='' where status not in (0,1,2,3)
go

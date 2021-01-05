ALTER PROCEDURE [Prj_TaskProcess_Sum] 
 ( @prjid 	int, @flag	int		output, @msg	varchar(80)	output) AS 
  DECLARE @sumWorkday decimal(9) 
  SELECT @sumWorkday=SUM(workday) FROM Prj_TaskProcess
   WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') 
   IF @sumWorkday<>0 BEGIN SELECT sum(workday) as workday, min(begindate)
    as begindate, max(enddate) as enddate,MIN(begintime) AS begintime ,MAX(endtime) AS endtime ,min(actualBeginDate) 
    as actualBeginDate, max(actualEndDate) as actualEndDate, min(actualBegintime) 
    as actualBegintime, max(actualEndtime) as actualEndDtime,
    sum(finish*workday)/sum(workday) as finish, sum(fixedcost)
     as fixedcost FROM Prj_TaskProcess WHERE
      ( prjid = @prjid and parentid = '0' and isdelete<>'1') END ELSE BEGIN SELECT
       sum(workday) as workday, min(begindate) as begindate, max(enddate) as enddate,min(begintime) as begintime, max(endtime) as endtime,
        min(actualBeginDate) as actualBeginDate, max(actualEndDate) as actualEndDate,min(actualBegintime) as actualBegintime, max(actualEndtime) as actualEndtime
        , 0 as finish, sum(fixedcost) as fixedcost 
        FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') END
GO
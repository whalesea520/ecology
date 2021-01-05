ALTER PROCEDURE Prj_TaskProcess_Sum (
@prjid 	int,
@flag	int		output,
@msg	varchar(80)	output) 
AS

DECLARE @sumWorkday decimal(9)
SELECT @sumWorkday=SUM(workday) FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1')
IF @sumWorkday<>0
BEGIN
	SELECT sum(workday) as workday,
	min(begindate) as begindate, 
	max(enddate) as enddate, 
  min(actualBeginDate) as actualBeginDate,
  max(actualEndDate) as actualEndDate,             
	sum(finish*workday)/sum(workday) as finish,
	sum(fixedcost) as fixedcost
	FROM Prj_TaskProcess
	WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1')
END
ELSE
BEGIN
	SELECT sum(workday) as workday,
	min(begindate) as begindate, 
	max(enddate) as enddate, 
  min(actualBeginDate) as actualBeginDate,
  max(actualEndDate) as actualEndDate,             	
	0 as finish,
	sum(fixedcost) as fixedcost
	FROM Prj_TaskProcess
	WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1')
END
GO

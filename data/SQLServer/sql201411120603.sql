drop FUNCTION getPrjBeginDate
go
CREATE FUNCTION getPrjBeginDate
(@prjid int)
RETURNS char(10) AS
BEGIN
Return (SELECT MIN(begindate)  FROM Prj_TaskProcess WHERE prjid=@prjid)
END
go
drop FUNCTION getPrjEndDate
go
CREATE FUNCTION getPrjEndDate
(@prjid int)
RETURNS char(10) AS
BEGIN
Return (SELECT MAX(enddate)  FROM Prj_TaskProcess WHERE prjid=@prjid)
END
go
drop FUNCTION getPrjFinish
go
CREATE FUNCTION getPrjFinish
(@prjid int)
RETURNS int AS
BEGIN
DECLARE @sumWorkday decimal(9)
DECLARE @finish int
set @finish=0
SELECT @sumWorkday=SUM(workday) FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') ;
IF @sumWorkday<>0 
	SELECT @finish= (sum(finish*workday)/sum(workday))  FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') 
Return @finish
END
go
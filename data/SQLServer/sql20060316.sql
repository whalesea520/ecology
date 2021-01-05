CREATE PROCEDURE UpdateTaskParentIds
@_taskid int,
@taskid int
AS 
DECLARE @tmpParentId int
DECLARE @tmpParentId2 int 
DECLARE @tmpParentHrmId int
BEGIN 
 SELECT @tmpParentId=parentid FROM Prj_TaskProcess WHERE id=@taskid
 IF @tmpParentId<>0
 BEGIN

  UPDATE Prj_TaskProcess SET parentids=parentids+CONVERT(VARCHAR(10),@tmpParentId)+',' WHERE id=@_taskid
 SELECT @tmpParentHrmId=hrmid FROM Prj_TaskProcess WHERE id=@tmpParentId
  UPDATE Prj_TaskProcess SET parenthrmids=parenthrmids+'|'+CONVERT(VARCHAR(10),@tmpParentId)+','+CONVERT(VARCHAR(10),@tmpParentHrmId)+'|' 
  WHERE id=@_taskid
 
  SELECT @tmpParentId2=parentid FROM Prj_TaskProcess WHERE id=@tmpParentId
  IF @tmpParentId<>0
  BEGIN 
   EXEC UpdateTaskParentIds @_taskid,@tmpParentId
  END
 END
END 
GO



DECLARE @task_id int, @task_parentid int, @hrmid int
DECLARE c CURSOR FOR
SELECT id,parentid,hrmid FROM Prj_TaskProcess
OPEN c
FETCH NEXT FROM c INTO @task_id,@task_parentid,@hrmid
WHILE @@FETCH_STATUS = 0
BEGIN
 UPDATE Prj_TaskProcess SET parentids=CONVERT(VARCHAR(10),@task_id)+',' WHERE id=@task_id 
 UPDATE Prj_TaskProcess SET parenthrmids='|'+CONVERT(VARCHAR(10),@task_id)+','+CONVERT(VARCHAR(10),@hrmid)+'|' WHERE id=@task_id

 SELECT @task_parentid=parentid FROM Prj_TaskProcess WHERE id=@task_id
 IF @task_parentid<>0
 BEGIN
  EXEC UpdateTaskParentIds @task_id,@task_id
 END

 FETCH NEXT FROM c INTO @task_id,@task_parentid,@hrmid
END
CLOSE c
DEALLOCATE c

GO




DROP PROCEDURE UpdateTaskParentIds
GO



create PROCEDURE Prj_TaskProcess_UParentHrmIds(
	@hrmid int,
	@oldhrmid int,
	@id int,
	@flag int output,
	@msg varchar(80) output
)
AS

if @hrmid<>@oldhrmid
begin
Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
UPDATE Prj_TaskProcess set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO

 




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
	0 as finish,
	sum(fixedcost) as fixedcost
	FROM Prj_TaskProcess
	WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1')
END
GO

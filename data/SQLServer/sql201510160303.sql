create procedure [Prj_Task_UpdateParent] 
(@parentid	int, @flag integer output, @msg varchar(4000) output ) 
AS Declare @finish int 
select @finish = convert(int,sum(workday*finish)/sum(workday)) from Prj_TaskProcess where parentid=@parentid   
if @finish>100 set @finish=100  
UPDATE Prj_TaskProcess SET finish = @finish WHERE ( id = @parentid) 
go
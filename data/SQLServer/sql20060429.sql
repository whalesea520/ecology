


ALTER PROCEDURE Prj_TaskProcess_UpdateParent 
 (@parentid	int,
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
Declare 
@begindate varchar(10), 
@enddate varchar(10), 
@workday decimal (10,1), 
@finish int ,
@fixedcost_1 decimal(10,2)
select @begindate = min(begindate), @enddate = max(enddate), @workday = sum(workday), 
@finish = convert(int,sum(workday*finish)/sum(workday)) , @fixedcost_1 = sum(fixedcost)
from Prj_TaskProcess
where parentid=@parentid

/*TD4174 added by hubo,2006-04-17*/
if @finish>100 
    set @finish=100

UPDATE Prj_TaskProcess 
SET  
begindate = @begindate, 
enddate = @enddate,
workday = @workday, 
finish = @finish  ,
fixedcost = @fixedcost_1
WHERE ( id = @parentid) 

GO

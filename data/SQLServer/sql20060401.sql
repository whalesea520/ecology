ALTER TABLE Prj_TaskProcess ALTER COLUMN fixedcost DECIMAL(18,2)
GO
ALTER TABLE Prj_TaskModifyLog ALTER COLUMN fixedcost DECIMAL(18,2)
GO


ALTER PROCEDURE Prj_TaskProcess_Update 
 (@id	int,
 @wbscoding varchar(20),
 @subject 	varchar(80) ,
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @actualbegindate 	varchar(10),
 @actualenddate 	varchar(10), 
 @workday decimal (10,1), 
 @content 	varchar(255),

 @fixedcost decimal (18,2), 
 @hrmid int, 
 @oldhrmid int, 
 @finish tinyint, 
 @taskconfirm char(1),
 @islandmark char(1),
 @prefinish_1 varchar(4000),
 @realManDays decimal (6,1),
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
UPDATE Prj_TaskProcess  
SET  
wbscoding = @wbscoding, 
subject = @subject ,
begindate = @begindate,
enddate = @enddate 	, 
actualbegindate = @actualbegindate,
actualenddate = @actualenddate 	, 
workday = @workday, 
content = @content,
fixedcost = @fixedcost,
hrmid = @hrmid, 
finish = @finish ,
taskconfirm = @taskconfirm,
islandmark = @islandmark,
prefinish = @prefinish_1,
realManDays = @realManDays
WHERE ( id	 = @id) 
if @hrmid<>@oldhrmid
begin
Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
UPDATE Prj_TaskProcess set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO

ALTER PROCEDURE Prj_TaskModifyLog_Insert 
  (
@ProjID_1	   INT ,
@TaskID_1	   INT ,
@Subject_1	   VARCHAR(100),
@HrmID_1	   INT ,
@BeginDate_1  VARCHAR(10) ,
@EndDate_1	   VARCHAR(10) ,
@WorkDay_1	   DECIMAL  ,
@FixedCost_1  DECIMAL (18,2),
@Finish_1	   TINYINT ,
@ParentID_1 INT,
@Prefinish_1  VARCHAR(4000)  ,
@IsLandMark_1 Char(1) ,
@ModifyDate_1 VARCHAR(10) ,
@ModifyTime_1 VARCHAR(8) ,
@ModifyBy_1   INT ,
@Status_1	   TINYINT ,
@OperationType_1	TINYINT,
@ClientIP_1	Varchar(20),
@realManDays decimal (6,1),
@flag integer output, @msg varchar(80) output  ) 
AS 

INSERT INTO Prj_TaskModifyLog (
ProjID	   ,
TaskID	   ,
Subject	   ,
HrmID	   ,
BeginDate  ,
EndDate	   ,
WorkDay	   ,
FixedCost  ,
Finish	   ,
ParentID   ,
Prefinish  ,
IsLandMark ,
ModifyDate ,
ModifyTime ,
ModifyBy   ,
Status	   ,
OperationType	,
ClientIP,
realManDays
)
VALUES(
@ProjID_1	   ,
@TaskID_1	   ,
@Subject_1	   ,
@HrmID_1	   ,
@BeginDate_1       ,
@EndDate_1	   ,
@WorkDay_1	   ,
@FixedCost_1       ,
@Finish_1	   ,
@ParentID_1        ,
@Prefinish_1  ,
@IsLandMark_1 ,
@ModifyDate_1 ,
@ModifyTime_1 ,
@ModifyBy_1   ,
@Status_1	   ,
@OperationType_1	,
@ClientIP_1,
@realManDays
)

set @flag = 1 set @msg = 'OK!'

GO

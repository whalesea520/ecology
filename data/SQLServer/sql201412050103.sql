CREATE  PROCEDURE CptUseLogUse_Insert2 (
@capitalid_1 	[int], 
@usedate_2 	[char](10), 
@usedeptid_3 	[int], 
@useresourceid_4 	[int], 
@usecount_5 	decimal(18,3), 
@userequest_6 [int],
@maintaincompany_8  [varchar](100), 
@fee_9 	[decimal](18,3), 
@usestatus_10 	[varchar](2), 
@remark_11 	[text], 
@useaddress_12 [varchar](200), 
@sptcount	[char](1),  
@flag integer output, @msg varchar(80) output)  
AS declare @num decimal(18,3) 
if @sptcount<>'1' begin select @num=capitalnum  from CptCapital where id = @capitalid_1 if @num<@usecount_5 begin select -1 return end else begin select @num = @num-@usecount_5 end end  
INSERT INTO [CptUseLog] ( [capitalid], [usedate], [usedeptid], [useresourceid], [usecount],[userequest], [maintaincompany], [fee], [usestatus], [remark], [useaddress], [olddeptid])  VALUES ( @capitalid_1, @usedate_2, @usedeptid_3, @useresourceid_4, @usecount_5,@userequest_6, @maintaincompany_8, @fee_9, '2', @remark_11, @useaddress_12, 0)  
if @sptcount='1' begin  Update CptCapital Set olddepartment=departmentid where id = @capitalid_1 Update CptCapital Set departmentid = @usedeptid_3, resourceid   = @useresourceid_4, stateid = @usestatus_10 where id = @capitalid_1 insert INTO HrmCapitalUse (capitalid,hrmid,cptnum) values(@capitalid_1,@useresourceid_4,1) end 
else begin Update CptCapital Set capitalnum = @num where id = @capitalid_1 insert INTO HrmCapitalUse (capitalid,hrmid,cptnum) values(@capitalid_1,@useresourceid_4,@usecount_5) end  select 1 
GO

create procedure Capital_Adjust2 ( 
@capitalid_1 int, 
@usedate_1 varchar(12), 
@usedeptid_1 int, 
@useresourceid_1 int, 
@userequest_1 int, 
@usecount_1 int, 
@useaddress_1 varchar(200), 
@usestatus_1 varchar(2), 
@remark_1 text, 
@olddeptid_1 int, 
@flag integer output, @msg varchar(80) 
output )
 as insert INTO CptUseLog ( capitalid, usedate, usedeptid, useresourceid, userequest,usecount, useaddress, usestatus, remark, olddeptid) values ( @capitalid_1  , @usedate_1  , @usedeptid_1  , @useresourceid_1  ,@userequest_1 , @usecount_1  , @useaddress_1   , @usestatus_1   , @remark_1  , @olddeptid_1  )   update CptCapital set departmentid = @usedeptid_1  , resourceid = @useresourceid_1 WHERE id=@capitalid_1
GO
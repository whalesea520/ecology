alter PROCEDURE CptUseLogBack_Insert (
@capitalid_1 	[int], 
@usedate_2 	[char](10), 
@usedeptid_3 	[int], 
@useresourceid_4 	[int], 
@usecount_5 	[int], 
@useaddress_6 	[varchar](200), 
@userequest_7 	[int], 
@maintaincompany_8 	[varchar](100), 
@fee_9 	[decimal](18,3), 
@usestatus_10 	[varchar](2), 
@remark_11 	[text], 
@costcenterid   [int], 
@sptcount	[char](1), 
@flag integer output, 
@msg varchar(80) output)  
AS 
declare @num int 

if @sptcount<>'1' 
begin 
	select @num=capitalnum  from CptCapital where id = @capitalid_1 
end  
INSERT INTO [CptUseLog] ( [capitalid], [usedate], [usedeptid], [useresourceid], [usecount], [useaddress], [userequest], [maintaincompany], [fee], [usestatus], [remark])  
VALUES ( @capitalid_1, @usedate_2, @usedeptid_3, @useresourceid_4, @usecount_5, @useaddress_6, @userequest_7, @maintaincompany_8, @fee_9, '0', @remark_11) 

if @sptcount='1' 
begin 
	Update CptCapital Set departmentid=olddepartment where id = @capitalid_1 
	Update CptCapital Set  costcenterid=null, resourceid=null, stateid = @usestatus_10, deprestartdate = null where id = @capitalid_1 
end 

else 
begin 
	Update CptCapital Set capitalnum = @num+@usecount_5 where id = @capitalid_1 
end  
select 1 

GO
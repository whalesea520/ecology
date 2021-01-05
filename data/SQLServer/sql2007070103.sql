alter table CptCapital add olddepartment int
go

/*资产流程新增:资产领用*/
 ALTER  PROCEDURE CptUseLogUse_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	decimal(18,3),
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @useaddress_12 [varchar](200),
	 @sptcount	[char](1),

	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num decimal(18,3)


/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [useaddress],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @maintaincompany_8,
	 @fee_9,
	 '2',
	 @remark_11,
	 @useaddress_12,
              0)

/*单独核算的资产*/
if @sptcount='1'
begin

        Update CptCapital Set olddepartment=departmentid where id = @capitalid_1
	Update CptCapital
	Set 
	departmentid = @usedeptid_3,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(@capitalid_1,@useresourceid_4,1)
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(@capitalid_1,@useresourceid_4,@usecount_5)
end

select 1

GO


/*资产流程新增:资产归还*/ alter PROCEDURE CptUseLogBack_Insert (@capitalid_1 	[int], @usedate_2 	[char](10), @usedeptid_3 	[int], @useresourceid_4 	[int], @usecount_5 	[int], @useaddress_6 	[varchar](200), @userequest_7 	[int], @maintaincompany_8 	[varchar](100), @fee_9 	[decimal](18,3), @usestatus_10 	[varchar](2), @remark_11 	[text], @costcenterid   [int], @sptcount	[char](1), @flag integer output, @msg varchar(80) output)  AS declare @num int /*判断数量是否足够(对于非单独核算的资产*/ if @sptcount<>'1' begin select @num=capitalnum  from CptCapital where id = @capitalid_1 end  INSERT INTO [CptUseLog] ( [capitalid], [usedate], [usedeptid], [useresourceid], [usecount], [useaddress], [userequest], [maintaincompany], [fee], [usestatus], [remark])  VALUES ( @capitalid_1, @usedate_2, @usedeptid_3, @useresourceid_4, @usecount_5, @useaddress_6, @userequest_7, @maintaincompany_8, @fee_9, '0', @remark_11) /*单独核算的资产*/ if @sptcount='1' begin 
Update CptCapital Set departmentid=olddepartment where id = @capitalid_1 
Update CptCapital Set  costcenterid=null, resourceid=null, stateid = @usestatus_10 where id = @capitalid_1 end /*非单独核算的资产*/ else begin Update CptCapital Set capitalnum = @num+@usecount_5 where id = @capitalid_1 end  select 1 

GO



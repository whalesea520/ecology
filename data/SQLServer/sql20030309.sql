CREATE TABLE [CptCapitalModify] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptid] [int] NULL ,
	[field] [int] NULL ,
	[oldvalue] [varchar] (200)  NULL ,
	[currentvalue] [varchar] (200)  NULL ,
	[resourceid] [int] NULL ,
	[modifydate] [char](10) NULL 
)
GO

CREATE TABLE [CptCapitalModifyField] (
	[field] [int] NULL ,
	[name] [varchar] (100)  NULL
)
GO

/*资产流程新增:资产租借*/
 ALTER PROCEDURE CptUseLogLend_Insert 
	(@capitalid_1 	[int],
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
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '3',
	 @remark_11)

Update CptCapital
Set 
departmentid = @usedeptid_3,
resourceid   = @useresourceid_4,
location	     =  @useaddress_6,
stateid = @usestatus_10
where id = @capitalid_1

GO



/*资产流程新增:资产损失*/
 ALTER PROCEDURE CptUseLogLoss_Insert 
	(@capitalid_1 	[int],
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
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '-7',
	 @remark_11)
/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	departmentid=null,
	costcenterid=null,
	resourceid=null,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1

GO


/*资产流程新增:资产归还*/
 CREATE PROCEDURE CptUseLogBack_Insert 
	(@capitalid_1 	[int],
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
/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '0',
	 @remark_11)
/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	departmentid=null,
	costcenterid=null,
	resourceid=null,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num+@usecount_5
	where id = @capitalid_1
end

select 1

GO

/*资产流程新增:资产报废*/
ALTER PROCEDURE CptUseLogDiscard_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	[int],
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	varchar(2),
	 @remark_11 	[text],
	 @sptcount_12	[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS
declare @num int
/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount_12<>'1'
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
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	 '5',
	 @remark_11)
/*单独核算的资产*/
if @sptcount_12 ='1'
begin
	Update CptCapital
	Set 
	departmentid = null,
	costcenterid = null,
	resourceid   = null,
	location	     =  null,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1
GO


/*资产变更记录*/
CREATE PROCEDURE CptCapitalModify_Insert 
	(@capitalid_1 	[int],
	 @field_1	[int],
	 @oldvalue_1 	[varchar](200),
	 @currentvalue_1 	[varchar](200),
	 @resourceid_1 [int],
	 @modifydate_1 [char](10),
	 @flag integer output,
	 @msg varchar(80) output)

AS

INSERT INTO CptCapitalModify
	(cptid ,
	field  ,
	oldvalue  ,
	currentvalue  ,
	resourceid ,
	modifydate )
VALUES 
	( @capitalid_1,
	 @field_1,
	 @oldvalue_1,
	 @currentvalue_1,
	 @resourceid_1,
	 @modifydate_1)

GO




CREATE PROCEDURE CptCapitalModifyField_SAll 
	(
	 @flag integer output,
	 @msg varchar(80) output)

AS
select * from CptCapitalModifyField order by field 
GO

insert into CptCapitalModifyField (field,name) values ('1','名称')
GO
insert into CptCapitalModifyField (field,name) values ('2','条形码')
GO
insert into CptCapitalModifyField (field,name) values ('3','生效日')
GO
insert into CptCapitalModifyField (field,name) values ('4','生效至')
GO
insert into CptCapitalModifyField (field,name) values ('5','安全级别')
GO
insert into CptCapitalModifyField (field,name) values ('6','使用人')
GO
insert into CptCapitalModifyField (field,name) values ('7','币种')
GO
insert into CptCapitalModifyField (field,name) values ('8','成本')
GO
insert into CptCapitalModifyField (field,name) values ('9','开始价格')
GO
insert into CptCapitalModifyField (field,name) values ('10','折旧底价')
GO
insert into CptCapitalModifyField (field,name) values ('11','规格型号')
GO
insert into CptCapitalModifyField (field,name) values ('12','等级')
GO
insert into CptCapitalModifyField (field,name) values ('13','制造厂商')
GO
insert into CptCapitalModifyField (field,name) values ('14','出厂日期')
GO
insert into CptCapitalModifyField (field,name) values ('15','资产类型')
GO
insert into CptCapitalModifyField (field,name) values ('16','资产组')
GO
insert into CptCapitalModifyField (field,name) values ('17','计量单位')
GO
insert into CptCapitalModifyField (field,name) values ('18','替代')
GO
insert into CptCapitalModifyField (field,name) values ('19','版本')
GO
insert into CptCapitalModifyField (field,name) values ('20','存放地点')
GO
insert into CptCapitalModifyField (field,name) values ('21','备注')
GO
insert into CptCapitalModifyField (field,name) values ('22','折旧方法一')
GO
insert into CptCapitalModifyField (field,name) values ('23','折旧方法二')
GO
insert into CptCapitalModifyField (field,name) values ('24','折旧开始日期')
GO
insert into CptCapitalModifyField (field,name) values ('25','折旧结束日期')
GO
insert into CptCapitalModifyField (field,name) values ('26','供应商')
GO
insert into CptCapitalModifyField (field,name) values ('27','属性')
GO

insert into CptCapitalModifyField (field,name) values ('28','date1')
GO
insert into CptCapitalModifyField (field,name) values ('29','date2')
GO
insert into CptCapitalModifyField (field,name) values ('30','date3')
GO
insert into CptCapitalModifyField (field,name) values ('31','date4')
GO
insert into CptCapitalModifyField (field,name) values ('32','date5')
GO
insert into CptCapitalModifyField (field,name) values ('33','float1')
GO
insert into CptCapitalModifyField (field,name) values ('34','float2')
GO
insert into CptCapitalModifyField (field,name) values ('35','float3')
GO
insert into CptCapitalModifyField (field,name) values ('36','float4')
GO
insert into CptCapitalModifyField (field,name) values ('37','float5')
GO
insert into CptCapitalModifyField (field,name) values ('38','text1')
GO
insert into CptCapitalModifyField (field,name) values ('39','text2')
GO
insert into CptCapitalModifyField (field,name) values ('40','text3')
GO
insert into CptCapitalModifyField (field,name) values ('41','text4')
GO
insert into CptCapitalModifyField (field,name) values ('42','text5')
GO
insert into CptCapitalModifyField (field,name) values ('43','boolean1')
GO
insert into CptCapitalModifyField (field,name) values ('44','boolean2')
GO
insert into CptCapitalModifyField (field,name) values ('45','boolean3')
GO
insert into CptCapitalModifyField (field,name) values ('46','boolean4')
GO
insert into CptCapitalModifyField (field,name) values ('47','boolean5')
GO

insert into CptCapitalModifyField (field,name) values ('48','财务编号')
GO
insert into CptCapitalModifyField (field,name) values ('49','报警数量')
GO


insert into HtmlLabelIndex (id,indexdesc) values (6055,'资产变更')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6055,'资产变更',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6055,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6056,'原值')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6056,'原值',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6056,'',8)
GO


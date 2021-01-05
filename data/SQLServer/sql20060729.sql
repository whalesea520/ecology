alter table CptStockInDetail add customerid	int
GO
alter table CptStockInDetail add SelectDate	char(10)
GO
alter table CptStockInDetail add capitalspec	varchar(60)
GO
alter table CptStockInDetail add location	varchar(100)
GO
alter table CptStockInDetail add invoice	varchar(80)
GO

alter table CptCapital add invoice varchar(80)
GO

CREATE  PROCEDURE CRM_CustomerInfo_InsertByCpt (
	@name varchar(50), 
	@manager int, 
	@flag int output, 
	@msg	varchar(80) output) 
AS INSERT INTO CRM_CustomerInfo (
	name, 
	engname,
	manager, 
	deleted,
	type) 
VALUES ( 
	@name, 
	@name, 
	@manager, 
	0,
	2) 
SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!'

GO

ALTER  PROCEDURE CptCapital_Duplicate (
@capitalid 	int,
@customerid	int,
@price		decimal,
@capitalspec	varchar(60),
@location	varchar(100),
@invoice	varchar(80),
@flag integer output,
@msg varchar(80) output)
AS 
declare @maxid int

INSERT INTO [CptCapital] 
(mark,
name,
barcode,
startdate,
enddate,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid,
invoice)

select 
mark,
name,
barcode,
startdate,
enddate	,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
@price,
depreendprice,
@capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
@customerid,
attribute,
stateid,
@location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid,
@invoice
from CptCapital
where id = @capitalid

select @maxid = max(id)  from CptCapital
update CptCapital set capitalnum = 0 where id = @maxid
select @maxid

GO

ALTER PROCEDURE CptCapital_SCountByDataType (
@datatype 	int, 
@flag		integer output, 
@msg		varchar(80) output )
AS 
select mark from CptCapital where id=(select max(id) from CptCapital where datatype =@datatype and isdata='2')

if @@error<>0 begin 
	set @flag=1 
	set @msg='查询资产信息成功' 
	return 
end else begin 
	set @flag=0 
	set @msg='查询资产信息失败' 
	return 
end

GO



ALTER  PROCEDURE CptCapital_UpdatePrice(
@id 		int, 
@price 		decimal(18,3), 
@capitalspec	varchar(60),
@customerid	int,
@location	varchar(100),
@invoice	varchar(80)  ,
@flag	int	output, 
@msg	varchar(80)	output) AS 

UPDATE CptCapital 
SET  startprice=@price ,
capitalspec=@capitalspec , 
customerid=@customerid , 
location=@location ,
invoice=@invoice
WHERE ( id = @id) 

set @flag = 1 
set @msg = 'OK!'
GO


ALTER  PROCEDURE CptStockInDetail_Insert ( 
@cptstockinid_1 	int  , 
@cpttype_1 		int  , 
@plannumber_1 		int  , 
@innumber_1 		int  , 
@price_1 		decimal(10, 2)  , 
@customerid_1		int  ,
@SelectDate_1		char(10)  ,
@capitalspec_1		varchar(60)  ,
@location_1		varchar(100)  ,
@invoice_1		varchar(80)  ,
@flag	int	output, 
@msg	varchar(80)	output ) AS 

INSERT INTO CptStockInDetail (cptstockinid, cpttype, plannumber, innumber, price, customerid, SelectDate, capitalspec, location, invoice) 
VALUES (@cptstockinid_1, @cpttype_1, @plannumber_1, @innumber_1 , @price_1, @customerid_1, @SelectDate_1, @capitalspec_1, @location_1, @invoice_1) 

select max(id) from CptStockInDetail

GO


ALTER PROCEDURE CptStockInDetail_SByStockid 
( @cptstockinid_1 [int] , @flag	[int]	output, @msg	[varchar](80)	output ) AS 

select * from CptStockInDetail where cptstockinid = @cptstockinid_1 order by id

GO

ALTER    PROCEDURE CRM_CustomerInfo_InsertByCpt (
	@name varchar(50), 
	@manager int, 
	@CreditAmount decimal(15, 2),
	@CreditTime int,
	@flag int output, 
	@msg	varchar(80) output) 
AS INSERT INTO CRM_CustomerInfo (
	name, 
	engname,
	manager,
	CreditAmount,
	CreditTime,
	status,
	deleted,
	type) 
VALUES ( 
	@name, 
	@name, 
	@manager, 
	@CreditAmount,
	@CreditTime,
	1,
	0,
	2) 
SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!'

GO


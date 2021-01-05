/*insert altered at 2002-8-13,
新增6个字段*/ 
/*2002-9-16增加类型数计算*/ 
/*新增资产*/ 

INSERT INTO HtmlLabelIndex values(19598,'折旧年限') 
GO
INSERT INTO HtmlLabelInfo VALUES(19598,'折旧年限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19598,'Depreciation Year',8) 
GO

alter table CptCapital add depreyear decimal(18,2)
go
alter table CptCapital add deprerate decimal(18,2)
go


insert into CptCapitalModifyField (field,name)
values (53,'折旧年限')
go
insert into CptCapitalModifyField (field,name)
values (54,'残值率')
go




ALTER  PROCEDURE CptCapital_Insert (
@mark                   varchar(60),
@name_2                 varchar(60),
@barcode_3              varchar(30),
@seclevel_6             tinyint,
@resourceid             int,
@sptcount               char(1),
@currencyid_10          int,
@capitalcost_11         decimal(18,3),
@startprice_12          decimal(18,3),
@depreendprice          decimal(18,3),
@capitalspec            varchar(60),
@capitallevel           varchar(30),
@manufacturer           varchar(100),
@capitaltypeid_13       int,
@capitalgroupid_14      int,
@unitid_15              int,
@capitalnum             decimal(18,3),
@replacecapitalid_17    int,
@version_18             varchar(60),
@remark_20              text,
@capitalimageid_21      int,
@depremethod1_22        int,
@depremethod2_23        int,
@customerid_26          int,
@attribute_27           tinyint,
@datefield1_30          char(10),
@datefield2_31          char(10),
@datefield3_32          char(10),
@datefield4_33          char(10),
@datefield5_34          char(10),
@numberfield1_35        float,
@numberfield2_36        float,
@numberfield3_37        float,
@numberfield4_38        float,
@numberfield5_39        float,
@textfield1_40          varchar(100),
@textfield2_41          varchar(100),
@textfield3_42          varchar(100),
@textfield4_43          varchar(100),
@textfield5_44          varchar(100),
@tinyintfield1_45       char(1),
@tinyintfield2_46       char(1),
@tinyintfield3_47       char(1),
@tinyintfield4_48       char(1),
@tinyintfield5_49       char(1),
@createrid_50           int,
@createdate_51          char(10),
@createtime_52          char(8),
@lastmoderid_53         int,
@lastmoddate_54         char(10),
@lastmodtime_55         char(8),
@isdata_56              char(1),
@depreyear_57		decimal(18,2),
@deprerate_58		decimal(18,2),
@flag integer output,
@msg varchar(80) output) AS 
    
INSERT INTO CptCapital ( 
mark,
name,
barcode,
seclevel,
resourceid,
sptcount,
currencyid,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
replacecapitalid,
version,
remark,
capitalimageid,
depremethod1,
depremethod2,
customerid,
attribute,
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
depreyear,
deprerate)  

VALUES (
@mark,
@name_2,
@barcode_3,
@seclevel_6,
@resourceid,
@sptcount,
@currencyid_10,
@capitalcost_11,
@startprice_12,
@depreendprice,
@capitalspec,
@capitallevel,
@manufacturer,
@capitaltypeid_13,
@capitalgroupid_14,
@unitid_15,
@capitalnum,
@replacecapitalid_17,
@version_18,
@remark_20,
@capitalimageid_21,
@depremethod1_22,
@depremethod2_23,
@customerid_26,
@attribute_27,
@datefield1_30,
@datefield2_31,
@datefield3_32,
@datefield4_33,
@datefield5_34,
@numberfield1_35,
@numberfield2_36,
@numberfield3_37,
@numberfield4_38,
@numberfield5_39,
@textfield1_40,
@textfield2_41,
@textfield3_42,
@textfield4_43,
@textfield5_44,
@tinyintfield1_45,
@tinyintfield2_46,
@tinyintfield3_47,
@tinyintfield4_48,
@tinyintfield5_49,
@createrid_50,
@createdate_51,
@createtime_52,
@lastmoderid_53,
@lastmoddate_54,
@lastmodtime_55,
@isdata_56,
@depreyear_57,
@deprerate_58)   

declare @thisid int  
select @thisid = max(id) from CptCapital  
update CptCapitalAssortment set capitalcount = capitalcount+1 
where id in (select capitalgroupid from CptCapital where id = @thisid)  

select max(id) from CptCapital

GO
ALTER    PROCEDURE CptCapital_Duplicate (
@capitalid 	int,
@customerid	int,
@price		decimal,
@capitalspec	varchar(60),
@location	varchar(100),
@invoice	varchar(80),
@StockInDate	char(10),
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
invoice,
StockInDate,
depreyear,
deprerate)  

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
@invoice,
@StockInDate,
depreyear,
deprerate    
from CptCapital
where id = @capitalid

select @maxid = max(id)  from CptCapital
update CptCapital set capitalnum = 0 where id = @maxid
select @maxid



GO

ALTER    PROCEDURE CptCapital_Update 
	(@id_1 	int,
	 @mark_2        varchar(60),
	 @name_3 	varchar(60),
	 @barcode_4 	varchar(30),
	 @startdate		char(10),
	 @enddate		char(10),
	 @seclevel_7 	tinyint,
	 @resourceid	int,
	 @sptcount 	char(1),
	 @currencyid_11 	int,
	 @capitalcost_12 	decimal(18,3),
	 @startprice_13 	decimal(18,3),
	@depreendprice decimal(18,3),
	@capitalspec		varchar(60),			
	@capitallevel		varchar(30),			
	@manufacturer		varchar(100),
	@manudate		char(10),			
	 @capitaltypeid_14 	int,
	 @capitalgroupid_15 	int,
	 @unitid_16 	int,
	 @replacecapitalid_18 	int,
	 @version_19 	varchar(60),
	 @location      varchar(100),
	 @remark_21 	text,
	 @capitalimageid_22 	int,
	 @depremethod1_23 	int,
	 @depremethod2_24 	int,
	 @customerid_27 	int,
	 @attribute_28 	tinyint,
	 @datefield1_31 	char(10),
	 @datefield2_32 	char(10),
	 @datefield3_33 	char(10),
	 @datefield4_34 	char(10),
	 @datefield5_35 	char(10),
	 @numberfield1_36 	float,
	 @numberfield2_37 	float,
	 @numberfield3_38 	float,
	 @numberfield4_39 	float,
	 @numberfield5_40 	float,
	 @textfield1_41 	varchar(100),
	 @textfield2_42 	varchar(100),
	 @textfield3_43 	varchar(100),
	 @textfield4_44 	varchar(100),
	 @textfield5_45 	varchar(100),
	 @tinyintfield1_46 	char(1),
	 @tinyintfield2_47 	char(1),
	 @tinyintfield3_48 	char(1),
	 @tinyintfield4_49 	char(1),
	 @tinyintfield5_50 	char(1),
	 @lastmoderid_51 	int,
	 @lastmoddate_52 	char(10),
	 @lastmodtime_53 	char(8),
	 @relatewfid		int,
	 @alertnum          decimal(18,3),
	 @fnamark			varchar(60),
	 @isinner			char(1),
	 @invoice		varchar(80),
	 @StockInDate		char(10),
	 @depreyear	 	decimal(18,2),
	 @deprerate 		decimal(18,2),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
/*更新资产组中的资产卡片数量信息*/
declare @tempgroupid int
select @tempgroupid=capitalgroupid from CptCapital where id=@id_1
if @tempgroupid<>@capitalgroupid_15
begin
	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=@tempgroupid
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=@capitalgroupid_15
end
UPDATE CptCapital 
SET  	 mark	 = @mark_2,
	 name	 = @name_3,
	 barcode	 = @barcode_4,
	 startdate = @startdate,
	 enddate	 = @enddate,	
	 seclevel	 = @seclevel_7,
	 resourceid = @resourceid,
	 sptcount	= @sptcount,	
	 currencyid	 = @currencyid_11,
	 capitalcost	 = @capitalcost_12,
	 startprice	 = @startprice_13,
	 depreendprice	= @depreendprice,
	 capitalspec	= @capitalspec,
	 capitallevel	= @capitallevel,
	 manufacturer	= @manufacturer,
	 manudate      = @manudate,
	 capitaltypeid	 = @capitaltypeid_14,
	 capitalgroupid	 = @capitalgroupid_15,
	 unitid	 = @unitid_16,
	 replacecapitalid	 = @replacecapitalid_18,
	 version	 = @version_19,
	 location	  = @location,
	 remark	 = @remark_21,
	 capitalimageid	 = @capitalimageid_22,
	 depremethod1	 = @depremethod1_23,
	 depremethod2	 = @depremethod2_24,
	 customerid	 = @customerid_27,
	 attribute	 = @attribute_28,
	 datefield1	 = @datefield1_31,
	 datefield2	 = @datefield2_32,
	 datefield3	 = @datefield3_33,
	 datefield4	 = @datefield4_34,
	 datefield5	 = @datefield5_35,
	 numberfield1	 = @numberfield1_36,
	 numberfield2	 = @numberfield2_37,
	 numberfield3	 = @numberfield3_38,
	 numberfield4	 = @numberfield4_39,
	 numberfield5	 = @numberfield5_40,
	 textfield1	 = @textfield1_41,
	 textfield2	 = @textfield2_42,
	 textfield3	 = @textfield3_43,
	 textfield4	 = @textfield4_44,
	 textfield5	 = @textfield5_45,
	 tinyintfield1	 = @tinyintfield1_46,
	 tinyintfield2	 = @tinyintfield2_47,
	 tinyintfield3	 = @tinyintfield3_48,
	 tinyintfield4	 = @tinyintfield4_49,
	 tinyintfield5	 = @tinyintfield5_50,
	 lastmoderid	 = @lastmoderid_51,
	 lastmoddate	 = @lastmoddate_52,
	 lastmodtime	 = @lastmodtime_53,
	 relatewfid	= @relatewfid,
	 alertnum	 = @alertnum,
	 fnamark	= @fnamark,
	 isinner	= @isinner,
	 invoice	= @invoice,
	 StockInDate	= @StockInDate,
	 depreyear	= @depreyear,
	 deprerate	= @deprerate

	 
WHERE 
	( id	 = @id_1)




GO



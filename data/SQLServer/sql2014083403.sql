alter table CRM_ContacterTitle 
add orderkey int
GO
alter table CRM_AddressType 
add orderkey int
GO
alter table CRM_ContactWay 
add orderkey int
GO
alter table CRM_CustomerSize 
add orderkey int
GO
alter table CRM_CustomerDesc
add orderkey int
GO
alter table CRM_CustomerStatus
add orderkey int
GO
alter table CRM_CustomerStatus add
usname varchar (300),
cnname varchar (300),
twname varchar (300)
GO
alter table CRM_Evaluation_Level
add orderkey int
GO
alter table CRM_Evaluation
add orderkey int
GO
alter table CRM_Successfactor
add orderkey int
GO
alter table CRM_Failfactor
add orderkey int
GO
alter table CRM_CustomerCredit
add currencytype int
GO
alter table CRM_CreditInfo
add orderkey int
GO
alter table CRM_TradeInfo
add orderkey int
GO
alter table CRM_ContractType
add orderkey int
GO
alter table CRM_CustomerType
add orderkey int
GO
alter table CRM_SectorInfo
add orderkey int
GO





CREATE PROCEDURE CRM_ContacterTitle_InsertID 
(@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id from CRM_ContacterTitle ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO

CREATE PROCEDURE CRM_AddressType_InsertID 
(@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id from CRM_AddressType ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO


CREATE PROCEDURE CRM_ContactWay_InsertID 
(@flag	[int]	output, @msg	[varchar](80)	output)  AS SELECT top 1 id from CRM_ContactWay ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO

ALTER PROCEDURE [CRM_CustomerStatus_Update]
(@id 	[int], 
@fullname 	[varchar](50), 
@description 	[varchar](150), 
@cnname		[varchar](150),
@usname		[varchar](150),
@twname		[varchar](150),
@flag	[int]	output, 
@msg	[varchar](80)	output) 
AS UPDATE [CRM_CustomerStatus] 
SET  
[fullname]	 = @fullname, 
[description]	 = @description, 
[cnname]	= @cnname,
[usname]	= @usname,
[twname]	= @twname
WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!'
GO
ALTER PROCEDURE [CRM_CustomerCredit_Insert] 
(@CreditAmount_1  [decimal](10, 2)  , 
@CreditTime_1  [int]  , 
@currencytype_1  [int]  , 
@flag integer output, 
@msg varchar(80) output)  
AS 
INSERT INTO [CRM_CustomerCredit] (CreditAmount,CreditTime,currencytype) 
VALUES(@CreditAmount_1, @CreditTime_1, @currencytype_1)
GO
delete from MainMenuInfo where id=158
GO
delete from MainMenuInfo where id=159
GO
delete from MainMenuInfo where id=139
GO
delete from MainMenuInfo where id=134
GO
delete from MainMenuInfo where id=135
GO
delete from MainMenuInfo where id=362
GO
delete from MainMenuInfo where id=363
GO
delete from MainMenuInfo where id=151
GO
ALTER PROCEDURE [LgcAssetAssortment_Insert] 
 (@assortmentmark_1 	[varchar](60), 
 @assortmentname_2 	[varchar](60), 
 @seclevel_3 	[tinyint], 
 @resourceid_4 	[int], 
 @assortmentimageid_5 	[int], 
 @assortmentremark_6 	[text], 
 @supassortmentid_7 	[int], 
 @supassortmentstr_8 	[varchar](200), 
 @dff01name_11 	[varchar](100), @dff01use_12 	[tinyint], @dff02name_13 	[varchar](100), @dff02use_14 	[tinyint], @dff03name_15 	[varchar](100), @dff03use_16 	[tinyint], @dff04name_17 	[varchar](100), @dff04use_18 	[tinyint], @dff05name_19 	[varchar](100), @dff05use_20 	[tinyint], @nff01name_21 	[varchar](100), @nff01use_22 	[tinyint], @nff02name_23 	[varchar](100), @nff02use_24 	[tinyint], @nff03name_25 	[varchar](100), @nff03use_26 	[tinyint], @nff04name_27 	[varchar](100), @nff04use_28 	[tinyint], @nff05name_29 	[varchar](100), @nff05use_30 	[tinyint], @tff01name_31 	[varchar](100), @tff01use_32 	[tinyint], @tff02name_33 	[varchar](100), @tff02use_34 	[tinyint], @tff03name_35 	[varchar](100), @tff03use_36 	[tinyint], @tff04name_37 	[varchar](100), @tff04use_38 	[tinyint], @tff05name_39 	[varchar](100), @tff05use_40 	[tinyint], @bff01name_41 	[varchar](100), @bff01use_42 	[tinyint], @bff02name_43 	[varchar](100), @bff02use_44 	[tinyint], @bff03name_45 	[varchar](100), @bff03use_46 	[tinyint], @bff04name_47 	[varchar](100), @bff04use_48 	[tinyint], @bff05name_49 	[varchar](100), @bff05use_50 	[tinyint], 
 @flag integer output, 
 @msg varchar(80) output )  
 AS 
 begin 
 UPDATE LgcAssetAssortment SET subassortmentcount=subassortmentcount+1 WHERE id = @supassortmentid_7 
 end  
 INSERT INTO [LgcAssetAssortment] 
 ( [assortmentmark], 
 [assortmentname], 
 [seclevel], 
 [resourceid], 
 [assortmentimageid], 
 [assortmentremark], 
 [supassortmentid], 
 [supassortmentstr], 
 [subassortmentcount], 
 [assetcount], 
 [dff01name], [dff01use], [dff02name], [dff02use], [dff03name], [dff03use], [dff04name], [dff04use], [dff05name], [dff05use], [nff01name], [nff01use], [nff02name], [nff02use], [nff03name], [nff03use], [nff04name], [nff04use], [nff05name], [nff05use], [tff01name], [tff01use], [tff02name], [tff02use], [tff03name], [tff03use], [tff04name], [tff04use], [tff05name], [tff05use], [bff01name], [bff01use], [bff02name], [bff02use], [bff03name], [bff03use], [bff04name], [bff04use], [bff05name], [bff05use])  
 VALUES ( 
 @assortmentmark_1, 
 @assortmentname_2, 
 @seclevel_3, 
 @resourceid_4, 
 @assortmentimageid_5, 
 @assortmentremark_6, 
 @supassortmentid_7, 
 @supassortmentstr_8, 
 0, 
 0, 
 @dff01name_11, @dff01use_12, @dff02name_13, @dff02use_14, @dff03name_15, @dff03use_16, @dff04name_17, @dff04use_18, @dff05name_19, @dff05use_20, @nff01name_21, @nff01use_22, @nff02name_23, @nff02use_24, @nff03name_25, @nff03use_26, @nff04name_27, @nff04use_28, @nff05name_29, @nff05use_30, @tff01name_31, @tff01use_32, @tff02name_33, @tff02use_34, @tff03name_35, @tff03use_36, @tff04name_37, @tff04use_38, @tff05name_39, @tff05use_40, @bff01name_41, @bff01use_42, @bff02name_43, @bff02use_44, @bff03name_45, @bff03use_46, @bff04name_47, @bff04use_48, @bff05name_49, @bff05use_50) 
 select max(id) from LgcAssetAssortment
 GO
 CREATE TABLE [CRM_CustomerDefinField](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fieldname] [varchar](60) NULL,
	[fieldlabel] [varchar] (2000) NULL,
	[fielddbtype] [varchar](40) NULL,
	[fieldhtmltype] [char](1) NULL,
	[selectid] int NULL,
	[type] [int] NULL,
	[viewtype] [int] NULL,
	[usetable] [varchar](50) NULL,
	[textheight] [int] NULL,
	[imgwidth] [int] NULL,
	[imgheight] [int] NULL,
	[dsporder] [decimal](15, 2) NULL,
	[isopen] [char](1) NULL,
	[ismust] [char](1) NULL,
	[places] [int] NULL,
	[candel] [char](1) NULL
)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff01name',dff01name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff01use,'n' from Base_FreeField where tablename='c1' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff02name',dff02name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff02use,'n' from Base_FreeField where tablename='c1' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff03name',dff03name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff03use,'n' from Base_FreeField where tablename='c1' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff04name',dff04name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff04use,'n' from Base_FreeField where tablename='c1' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff05name',dff05name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff05use,'n' from Base_FreeField where tablename='c1' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield5 <>'' and datefield5 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff01name',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff01use,'n' from Base_FreeField where tablename='c1' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield1 <>'' and numberfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff02name',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff02use,'n' from Base_FreeField where tablename='c1' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield2 <>'' and numberfield2 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff03name',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff03use,'n' from Base_FreeField where tablename='c1' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff04name',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff04use,'n' from Base_FreeField where tablename='c1' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff05name',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff05use,'n' from Base_FreeField where tablename='c1' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff01name',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff01use,'n' from Base_FreeField where tablename='c1' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff02name',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff02use,'n' from Base_FreeField where tablename='c1' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff03name',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff03use,'n' from Base_FreeField where tablename='c1' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff04name',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff04use,'n' from Base_FreeField where tablename='c1' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff05name',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff05use,'n' from Base_FreeField where tablename='c1' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff01name',bff01name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff01use,'n' from Base_FreeField where tablename='c1' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff02name',bff02name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff02use,'n' from Base_FreeField where tablename='c1' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff03name',bff03name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff03use,'n' from Base_FreeField where tablename='c1' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff04name',bff04name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff04use,'n' from Base_FreeField where tablename='c1' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff05name',bff05name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff05use,'n' from Base_FreeField where tablename='c1' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff01name',dff01name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff01use,'n' from Base_FreeField where tablename='c2' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff02name',dff02name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff02use,'n' from Base_FreeField where tablename='c2' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff03name',dff03name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff03use,'n' from Base_FreeField where tablename='c2' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff04name',dff04name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff04use,'n' from Base_FreeField where tablename='c2' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff05name',dff05name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff05use,'n' from Base_FreeField where tablename='c2' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield5 <>'' and datefield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff01name',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff01use,'n' from Base_FreeField where tablename='c2' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield1 <>'' and numberfield1 is not null) >0))
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff02name',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff02use,'n' from Base_FreeField where tablename='c2' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield2 <>'' and numberfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff03name',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff03use,'n' from Base_FreeField where tablename='c2' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff04name',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff04use,'n' from Base_FreeField where tablename='c2' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff05name',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff05use,'n' from Base_FreeField where tablename='c2' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff01name',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff01use,'n' from Base_FreeField where tablename='c2' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff02name',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff02use,'n' from Base_FreeField where tablename='c2' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff03name',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff03use,'n' from Base_FreeField where tablename='c2' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff04name',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff04use,'n' from Base_FreeField where tablename='c2' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff05name',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff05use,'n' from Base_FreeField where tablename='c2' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff01name',bff01name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff01use,'n' from Base_FreeField where tablename='c2' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff02name',bff02name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff02use,'n' from Base_FreeField where tablename='c2' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff03name',bff03name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff03use,'n' from Base_FreeField where tablename='c2' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff04name',bff04name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff04use,'n' from Base_FreeField where tablename='c2' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff05name',bff05name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff05use,'n' from Base_FreeField where tablename='c2' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff01name',dff01name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff01use,'n' from Base_FreeField where tablename='c3' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield1 <>'' and datefield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff02name',dff02name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff02use,'n' from Base_FreeField where tablename='c3' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield2 <>'' and datefield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff03name',dff03name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff03use,'n' from Base_FreeField where tablename='c3' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield3 <>'' and datefield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff04name',dff04name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff04use,'n' from Base_FreeField where tablename='c3' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield4 <>'' and datefield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'dff05name',dff05name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff05use,'n' from Base_FreeField where tablename='c3' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield5 <>'' and datefield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff01name',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff01use,'n' from Base_FreeField where tablename='c3' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield1 <>'' and numberfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff02name',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff02use,'n' from Base_FreeField where tablename='c3' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield2 <>'' and numberfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff03name',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff03use,'n' from Base_FreeField where tablename='c3' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield3 <>'' and numberfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff04name',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff04use,'n' from Base_FreeField where tablename='c3' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield4 <>'' and numberfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'nff05name',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff05use,'n' from Base_FreeField where tablename='c3' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield5 <>'' and numberfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff01name',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff01use,'n' from Base_FreeField where tablename='c3' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield1 <>'' and textfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff02name',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff02use,'n' from Base_FreeField where tablename='c3' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield2 <>'' and textfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff03name',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff03use,'n' from Base_FreeField where tablename='c3' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield3 <>'' and textfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff04name',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff04use,'n' from Base_FreeField where tablename='c3' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield4 <>'' and textfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tff05name',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff05use,'n' from Base_FreeField where tablename='c3' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield5 <>'' and textfield5 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff01name',bff01name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff01use,'n' from Base_FreeField where tablename='c3' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff02name',bff02name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff02use,'n' from Base_FreeField where tablename='c3' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff03name',bff03name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff03use,'n' from Base_FreeField where tablename='c3' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff04name',bff04name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff04use,'n' from Base_FreeField where tablename='c3' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'bff05name',bff05name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff05use,'n' from Base_FreeField where tablename='c3' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
GO

ALTER PROCEDURE [CRM_SectorInfo_SelectAll] (@parentid	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_SectorInfo] WHERE	([parentid] = @parentid)  order by orderkey asc  set @flag = 1 set @msg = 'OK!'

GO

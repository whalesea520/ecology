alter table HrmLocations add showOrder decimal(15,2) null
GO
update HrmLocations set showOrder=0
GO
update SystemLogItem set lableId=15712,itemDesc='办公地点' where itemId=23
GO

ALTER PROCEDURE HrmLocations_Insert (
@locationname_1 	varchar(200), 
@locationdesc_2 	varchar(200),
@address1_3 	varchar(200),
@address2_4 	varchar(200),
@locationcity_5 	varchar(200),
@postcode_6 	varchar(20),
@countryid_7 	int,
@telephone_8 	varchar(60),
@fax_9 	varchar(60),
@showOrder_10 	decimal(15,2),
@flag integer output,
@msg varchar(80) output )
AS
INSERT INTO HrmLocations ( 
locationname,
locationdesc,
address1,
address2, 
locationcity, 
postcode, 
countryid, 
telephone, 
fax, 
showOrder)
VALUES ( 
@locationname_1,
@locationdesc_2,
@address1_3,
@address2_4,
@locationcity_5,
@postcode_6,
@countryid_7,
@telephone_8,
@fax_9,
@showOrder_10)
select max(id) from HrmLocations
if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end
else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

ALTER PROCEDURE HrmLocations_Update (
@id_1 	int,
@locationname_2 	varchar(200),
@locationdesc_3 	varchar(200),
@address1_4 	varchar(200),
@address2_5 	varchar(200),
@locationcity_6 	varchar(200),
@postcode_7 	varchar(20),
@countryid_8 	int, 
@telephone_9 	varchar(60),
@fax_10 	varchar(60),
@showOrder_11 	decimal(15,2),
@flag integer output,
@msg varchar(80) output )
AS
UPDATE HrmLocations
SET  
locationname	 = @locationname_2,
locationdesc	 = @locationdesc_3,
address1	 = @address1_4, 
address2	 = @address2_5,
locationcity	 = @locationcity_6,
postcode	 = @postcode_7,
countryid	 = @countryid_8,
telephone	 = @telephone_9,
fax	 = @fax_10,
showOrder	 = @showOrder_11
WHERE ( id	 = @id_1)
if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end 
else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

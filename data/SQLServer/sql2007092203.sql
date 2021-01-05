Alter procedure Crm_ExcelToDB (
  @name varchar(50),
  @engname varchar(50),
  @address1 varchar(250),
  @zipcode varchar(10),
  @phone varchar(50),
  @fax varchar(50),
  @email varchar(150),
  @country  varchar(50),
  @type int,
  @description int,
  @size int, @sector int,
  @creditamount varchar(9),
  @credittime int,
  @website varchar(50),
  @city int,
  @province int ,
  @manager int,
  @status int,
  @crmCode varchar(100),
  @bankName varchar(200),
  @accountName varchar(20),
  @accounts varchar(200),
  @flag int output,
  @msg varchar(80) output )
  as
  insert into Crm_CustomerInfo (name,engname,address1,zipcode,phone,fax,email,country,type,description , size_n,sector,creditamount,credittime,deleted,status,rating,website,source,manager,city,province,language,crmcode,bankName,accountName,accounts) values (@name,@engname,@address1,@zipcode,@phone,@fax,@email,@country,@type,@description, @size, @sector,cast(@creditamount as decimal(9)),@credittime,'0',@status,'1',@website,'9',@manager,@city,@province,'7',@crmCode,@bankName,@accountName,@accounts)
GO
INSERT INTO HtmlLabelIndex values(17678,'客户导入')
GO
INSERT INTO HtmlLabelInfo VALUES(17678,'客户导入',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17678,'Import customer data form Excel',8)
GO

INSERT INTO HtmlLabelIndex values(17648,'客户监控')
GO
INSERT INTO HtmlLabelInfo VALUES(17648,'客户监控',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17648,'customer monitor',8)
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3157,'客户删除','EditCustomer:Delete',101)
GO

insert into SystemRights (id,rightdesc,righttype) values (583,'客户删除','0') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (583,7,'客户删除','客户监控，用来删除客户') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (583,8,'Customer Delete','Customer Monitor to delete') 
GO

  CREATE procedure Crm_ExcelToDB (
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
  @flag int output, 
  @msg varchar(80) output ) 
  as  
  insert into Crm_CustomerInfo (name,engname,address1,zipcode,phone,fax,email,country,type,description , size_n,sector,creditamount,credittime,deleted,status,rating,website,source,manager,city,province,language) values (@name,@engname,@address1,@zipcode,@phone,@fax,@email,@country,@type,@description, @size, @sector,cast(@creditamount as decimal(9)),@credittime,'0','2','1',@website,'9',@manager,@city,@province,'7') 
  declare @maxid int select @maxid=max(id) from Crm_CustomerInfo
  insert into CrmShareDetail (crmid,userid,usertype,sharelevel) values(@maxid,'1','1','2')
GO

ALTER PROCEDURE CRM_CustomerInfo_Insert (
@name varchar(200), @language int, @engname varchar(50), @address1 varchar(250), @address2 varchar(250), 
@address3 varchar(250), @zipcode varchar(10), @city	int, @country int, @province int, @county varchar(50), 
@phone varchar(50), @fax varchar(50), @email varchar(150), @website varchar(150), @source int, @sector int, 
@size_n	int, @manager int, @agent int, @parentid int, @department int, @subcompanyid1 int, @fincode int, 
@currency int, @contractlevel	int, @creditlevel int, @creditoffset varchar(50), @discount real, 
@taxnumber varchar(50), @bankacount varchar(50), @invoiceacount	int, @deliverytype int, @paymentterm int, 
@paymentway int, @saleconfirm int, @creditcard varchar(50), @creditexpire varchar(10), @documentid int, 
@seclevel int, @picid int, @type int, @typebegin varchar(10), @description int, @status int, @rating int, 
@introductionDocid int, @CreditAmount decimal(10, 2) , @CreditTime int, @datefield1 varchar(10), 
@datefield2 varchar(10), @datefield3 varchar(10), @datefield4 varchar(10), @datefield5 varchar(10), 
@numberfield1 float, @numberfield2 float, @numberfield3 float, @numberfield4 float, @numberfield5 float, 
@textfield1 varchar(100), @textfield2 varchar(100), @textfield3 varchar(100), @textfield4 varchar(100), 
@textfield5 varchar(100), @tinyintfield1 tinyint, @tinyintfield2 tinyint, @tinyintfield3 tinyint, 
@tinyintfield4 tinyint, @tinyintfield5 tinyint, @createdate varchar(10), @bankName varchar(200), @accountName varchar(40),
@accounts varchar(200), @crmCode varchar(100),@introduction varchar(500), @flag int output, @msg	varchar(80) output)  
AS 
INSERT INTO CRM_CustomerInfo (
name, language, engname, address1, address2, address3, zipcode, city, country, province, county, 
phone, fax, email, website, source, sector, size_n, manager, agent, parentid, department, 
subcompanyid1, fincode, currency, contractlevel, creditlevel, creditoffset, discount, taxnumber, 
bankacount, invoiceacount, deliverytype, paymentterm, paymentway, saleconfirm, creditcard, creditexpire, 
documentid, seclevel, picid, type, typebegin, description, status, rating, datefield1, datefield2, 
datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, 
textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, 
tinyintfield4, tinyintfield5, deleted, createdate, introductionDocid, CreditAmount, CreditTime, bankName, accountName, accounts,
crmcode,introduction)  
VALUES ( @name, @language, @engname, @address1, @address2, @address3, @zipcode, @city, @country, @province, @county, @phone,
@fax, @email, @website, @source, @sector, @size_n, @manager, @agent, @parentid, @department, @subcompanyid1, @fincode, 
@currency, @contractlevel, @creditlevel, convert(money,@creditoffset), @discount, @taxnumber, @bankacount, @invoiceacount, 
@deliverytype, @paymentterm, @paymentway, @saleconfirm, @creditcard, @creditexpire, @documentid, @seclevel, @picid, 
@type, @typebegin, @description, @status, @rating, @datefield1, @datefield2, @datefield3, @datefield4, @datefield5, 
@numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, 
@textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5, 0, @createdate, 
@introductionDocid, @CreditAmount , @CreditTime, @bankName, @accountName, @accounts, @crmCode,@introduction)  
SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 

GO

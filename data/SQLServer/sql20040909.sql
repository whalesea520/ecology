/* td:1032 创建客户，返回空白页面，并提示Database FindData Error!  dfdf*/
ALTER PROCEDURE Sales_CRM_CreditInfo_Select (
@creditAmount varchar(20), 
@flag integer output ,
@msg varchar(80) output)
AS 
SELECT id FROM CRM_CreditInfo 
WHERE creditamount <= convert(money, @creditAmount) AND highamount >= convert(money, @creditAmount)
GO

ALTER PROCEDURE CRM_CustomerInfo_Insert (
@name varchar(50), @language int, @engname varchar(50), @address1 varchar(250), @address2 varchar(250), 
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
@tinyintfield4 tinyint, @tinyintfield5 tinyint, @createdate varchar(10), @bankName varchar(20), @accountName varchar(20),
@accounts varchar(20), @crmCode varchar(100), @flag int output, @msg	varchar(80) output)  
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
crmcode)  
VALUES ( @name, @language, @engname, @address1, @address2, @address3, @zipcode, @city, @country, @province, @county, @phone,
@fax, @email, @website, @source, @sector, @size_n, @manager, @agent, @parentid, @department, @subcompanyid1, @fincode, 
@currency, @contractlevel, @creditlevel, convert(money,@creditoffset), @discount, @taxnumber, @bankacount, @invoiceacount, 
@deliverytype, @paymentterm, @paymentway, @saleconfirm, @creditcard, @creditexpire, @documentid, @seclevel, @picid, 
@type, @typebegin, @description, @status, @rating, @datefield1, @datefield2, @datefield3, @datefield4, @datefield5, 
@numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, 
@textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5, 0, @createdate, 
@introductionDocid, @CreditAmount , @CreditTime, @bankName, @accountName, @accounts, @crmCode)  
SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 
GO


ALTER PROCEDURE CRM_CustomerInfo_Update (
@id int, @name varchar(50), @language int, @engname varchar(50), @address1 varchar(250), @address2 varchar(250),
@address3 varchar(250), @zipcode varchar(10), @city	int, @country int, @province int, @county varchar(50), 
@phone varchar(50), @fax varchar(50), @email varchar(150), @website varchar(150), @source int, @sector int, 
@size_n	int, @manager int, @agent int, @parentid int, @department int, @subcompanyid1 int, @fincode int, 
@currency int, @contractlevel	int, @creditlevel int, @creditoffset varchar(50), @discount real, 
@taxnumber varchar(50), @bankacount varchar(50), @invoiceacount int, @deliverytype int, @paymentterm int, 
@paymentway int, @saleconfirm int, @creditcard varchar(50), @creditexpire varchar(10), @documentid int, 
@seclevel int, @picid int, @type int, @typebegin varchar(10), @description int, @status int, @rating int, 
@introductionDocid int, @CreditAmount decimal(10, 2), @CreditTime int, @datefield1 varchar(10), 
@datefield2 varchar(10), @datefield3 varchar(10), @datefield4 varchar(10), @datefield5 varchar(10), 
@numberfield1 float, @numberfield2 float, @numberfield3 float, @numberfield4 float, @numberfield5 float, 
@textfield1 varchar(100), @textfield2 varchar(100), @textfield3 varchar(100), @textfield4 varchar(100), 
@textfield5 varchar(100), @tinyintfield1 tinyint, @tinyintfield2 tinyint, @tinyintfield3 tinyint, 
@tinyintfield4 tinyint, @tinyintfield5 tinyint, @bankName varchar(20), @accountName varchar(20), @accounts varchar(20), @crmCode varchar(100),
@flag int output, @msg varchar(80) output) 
AS 
UPDATE CRM_CustomerInfo SET name = @name, language = @language, engname = @engname, address1 = @address1, 
address2 = @address2, address3 = @address3, zipcode = @zipcode, city = @city, country = @country, 
province = @province, county = @county, phone = @phone, fax = @fax, email = @email, website	= @website, 
source = @source, sector = @sector, size_n = @size_n, manager = @manager, agent = @agent, parentid = @parentid, 
department = @department, subcompanyid1	= @subcompanyid1, fincode = @fincode, currency = @currency, 
contractlevel = @contractlevel, creditlevel = @creditlevel, creditoffset = convert(money,@creditoffset), 
discount = @discount, taxnumber = @taxnumber, bankacount = @bankacount, invoiceacount = @invoiceacount, 
deliverytype = @deliverytype, paymentterm = @paymentterm, paymentway = @paymentway, saleconfirm = @saleconfirm, 
creditcard = @creditcard, creditexpire = @creditexpire, documentid = @documentid, seclevel = @seclevel, 
picid = @picid, type = @type, typebegin = @typebegin, description = @description, status = @status, 
rating = @rating, datefield1 = @datefield1, datefield2 = @datefield2, datefield3 = @datefield3, 
datefield4 = @datefield4, datefield5 = @datefield5, numberfield1 = @numberfield1, numberfield2 = @numberfield2, 
numberfield3 = @numberfield3, numberfield4 = @numberfield4, numberfield5 = @numberfield5, textfield1 = @textfield1, 
textfield2 = @textfield2, textfield3 = @textfield3, textfield4 = @textfield4, textfield5 = @textfield5, 
tinyintfield1 = @tinyintfield1, tinyintfield2 = @tinyintfield2, tinyintfield3 = @tinyintfield3, 
tinyintfield4	= @tinyintfield4, tinyintfield5 = @tinyintfield5, introductionDocid = @introductionDocid, 
CreditAmount = @CreditAmount, CreditTime = @CreditTime, bankName = @bankName, accountName = @accountName, accounts = @accounts, crmcode = @crmCode
WHERE (id = @id) set @flag = 1 set @msg = 'OK!' 
GO
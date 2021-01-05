ALTER TABLE hrmresource 
ALTER COLUMN seclevel INT
GO
CREATE TABLE hrmresourceout(
id INT IDENTITY(1,1) PRIMARY KEY,
resourceid INT,
wxname VARCHAR(500),
wxopenid INT,
wxuuid INT,
customid INT,
country VARCHAR(500), 
province VARCHAR(500), 
city VARCHAR(500), 
customfrom VARCHAR(500),
isoutmanager INT
)
GO
create TABLE customresourceout(
id int IDENTITY PRIMARY KEY,
customid int,
subcompanyid int,
crmdeptid int,
crmmanagerdeptid int
)
GO

set Identity_insert HrmCompanyVirtual on ;
INSERT HrmCompanyVirtual( id,companyname ,companycode ,companydesc ,canceled ,showorder ,virtualType ,virtualtypedesc)
VALUES  ( -10000,'�ͻ�γ��' , '�ͻ�γ��' , '�ͻ�γ��' ,0 , 0 , '�ͻ�γ��' , '�ͻ�γ��' )
set Identity_insert HrmCompanyVirtual off ;
GO
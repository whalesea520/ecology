alter table CPLMLICENSEAFFIX  alter column affixindex float
GO
alter table CompanyBusinessService add affixindex float
GO
alter table CompanyBusinessService add affdesc varchar(50)
GO
update CompanyBusinessService set affixindex=id
GO
alter table Companyattributable add affixindex float
GO
alter table Companyattributable add affdesc varchar(50)
GO
update Companyattributable set affixindex=id
GO
update CPLMLICENSEAFFIX set affixindex=-1 where licenseaffixid=1
GO
alter table CPCOMPANYINFO  alter column COMPANYVESTIN varchar(50)
GO
alter table CPCOMPANYINFO  alter column BUSINESSTYPE varchar(50)
GO
insert into CompanyBusinessService (name,affixindex,affdesc) values('自然人','-1','自然人')
GO

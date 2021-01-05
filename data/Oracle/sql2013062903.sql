alter table CPLMLICENSEAFFIX  add fledname_temp varchar2(50)
/
update CPLMLICENSEAFFIX set fledname_temp=affixindex
/
update CPLMLICENSEAFFIX set affixindex=null
/
alter table CPLMLICENSEAFFIX modify affixindex Number
/
update CPLMLICENSEAFFIX set affixindex=fledname_temp
/
alter table  CPLMLICENSEAFFIX drop column fledname_temp
/
alter table CompanyBusinessService add affixindex number
/
alter table CompanyBusinessService add affdesc varchar2(50)
/
update CompanyBusinessService set affixindex=id
/
alter table Companyattributable add affixindex number
/
alter table Companyattributable add affdesc varchar2(50)
/
update Companyattributable set affixindex=id
/
update CPLMLICENSEAFFIX set affixindex=-1 where licenseaffixid=1
/
alter table CPCOMPANYINFO  add COMPANYVESTIN_temp varchar2(50)
/
update CPCOMPANYINFO set COMPANYVESTIN_temp=COMPANYVESTIN
/
update CPCOMPANYINFO set COMPANYVESTIN=null
/
alter table CPCOMPANYINFO modify COMPANYVESTIN varchar2(50)
/
update CPCOMPANYINFO set COMPANYVESTIN=COMPANYVESTIN_temp
/
alter table  CPCOMPANYINFO drop column COMPANYVESTIN_temp
/
alter table CPCOMPANYINFO  add BUSINESSTYPE_tepm varchar2(50)
/
update CPCOMPANYINFO set BUSINESSTYPE_tepm=BUSINESSTYPE
/
update CPCOMPANYINFO set BUSINESSTYPE=null
/
alter table CPCOMPANYINFO modify BUSINESSTYPE varchar2(50)
/
update CPCOMPANYINFO set BUSINESSTYPE=BUSINESSTYPE_tepm
/
alter table  CPCOMPANYINFO drop column BUSINESSTYPE_tepm
/
insert into CompanyBusinessService (name,affixindex,affdesc) values('自然人','-1','自然人')
/
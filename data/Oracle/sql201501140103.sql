create or replace view tempHrmSubCompanyView
as
select HrmSubCompany.id,
       HrmSubCompany.subcompanyname,
       HrmSubCompany.subcompanydesc,
       HrmSubCompany.companyid,
       HrmSubCompany.supsubcomid,
       HrmSubCompany.url,
       HrmSubCompany.showorder,
       HrmSubCompany.canceled,
       HrmSubCompany.subcompanycode,
       level templevel
  from HrmSubCompany
 start with nvl(supsubcomid,0) = 0
 connect by prior id=supsubcomid
/
create or replace view tempHrmSubCompanyVirtualView
as
select id, supsubcomid, level templevel
  from HrmSubCompanyVirtual
 start with nvl(supsubcomid,0) = 0
connect by prior id = supsubcomid
/

create or replace view tempHrmDepartmentView
as
select id,
       supdepid,
       ((select templevel
          from tempHrmSubCompanyView
         where HrmDepartment.subcompanyid1 = tempHrmSubCompanyView.id) + level) templevel
  from HrmDepartment
 start with nvl(supdepid,0) = 0 
 connect by prior id = supdepid
/

create or replace view tempHrmDepartmentVirtualView
as
select id,
       supdepid,
       ((select templevel
          from tempHrmSubCompanyVirtualView
         where HrmDepartmentVirtual.subcompanyid1 = tempHrmSubCompanyVirtualView.id) + level) templevel
  from HrmDepartmentVirtual
 start with nvl(supdepid,0) = 0 
 connect by prior id = supdepid
/
alter table HrmDepartment add tlevel int
/
alter table HrmDepartmentVirtual add tlevel int
/
alter table HrmSubCompany add tlevel int
/
alter table HrmSubCompanyVirtual add tlevel int
/
update HrmSubCompany set tlevel=(select templevel from tempHrmSubCompanyView where tempHrmSubCompanyView.id=HrmSubCompany.id)
/
update HrmSubCompanyVirtual set tlevel=(select templevel from tempHrmSubCompanyVirtualView where tempHrmSubCompanyVirtualView.id=HrmSubCompanyVirtual.id)
/
update HrmDepartment set tlevel=(select templevel from tempHrmDepartmentView where tempHrmDepartmentView.id=HrmDepartment.id)
/
update HrmDepartmentVirtual set tlevel=(select templevel from tempHrmDepartmentVirtualView where tempHrmDepartmentVirtualView.id=HrmDepartmentVirtual.id)
/
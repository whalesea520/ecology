create view tempHrmSubCompanyView
as
with tempHrmSubCompany as(
select HrmSubCompany.id,
       HrmSubCompany.subcompanyname,
       HrmSubCompany.subcompanydesc,
       HrmSubCompany.companyid,
       HrmSubCompany.supsubcomid,
       HrmSubCompany.url,
       HrmSubCompany.showorder,
       HrmSubCompany.canceled,
       HrmSubCompany.subcompanycode,
       1 as level
  from HrmSubCompany
 where supsubcomid = 0
 union all
 select HrmSubCompany.id,
       HrmSubCompany.subcompanyname,
       HrmSubCompany.subcompanydesc,
       HrmSubCompany.companyid,
       HrmSubCompany.supsubcomid,
       HrmSubCompany.url,
       HrmSubCompany.showorder,
       HrmSubCompany.canceled,
       HrmSubCompany.subcompanycode,
       tempHrmSubCompany.level + 1 as level
  from tempHrmSubCompany, HrmSubCompany
 where tempHrmSubCompany.id = HrmSubCompany.supsubcomid
)
select id,
       subcompanyname,
       subcompanydesc,
       companyid,
       supsubcomid,
       url,
       showorder,
       canceled,
       subcompanycode,
       level
  from tempHrmSubCompany
GO

create view tempHrmSubCompanyVirtualView
as
with tempHrmSubCompanyVirtual as(select id,supsubcomid,1 as level from HrmSubCompanyVirtual where supsubcomid=0
 union all
 select HrmSubCompanyVirtual.id,HrmSubCompanyVirtual.supsubcomid,
       tempHrmSubCompanyVirtual.level + 1 as level
  from tempHrmSubCompanyVirtual, HrmSubCompanyVirtual
 where tempHrmSubCompanyVirtual.id = HrmSubCompanyVirtual.supsubcomid
)
select * from tempHrmSubCompanyVirtual
GO

create view tempHrmDepartmentView
as
with tempHrmDepartment as(select id,supdepid,(select level from tempHrmSubCompanyView where HrmDepartment.subcompanyid1=tempHrmSubCompanyView.id)+1 as level from HrmDepartment where supdepid=0
 union all
 select HrmDepartment.id,HrmDepartment.supdepid,
       tempHrmDepartment.level + 1 as level
  from tempHrmDepartment, HrmDepartment
 where tempHrmDepartment.id = HrmDepartment.supdepid
)
select * from tempHrmDepartment
GO

create view tempHrmDepartmentVirtualView
as
with tempHrmDepartmentVirtual as(select id,supdepid,(select level from tempHrmSubCompanyVirtualView where HrmDepartmentVirtual.subcompanyid1=tempHrmSubCompanyVirtualView.id)+1 as level from HrmDepartmentVirtual where supdepid=0
 union all
 select HrmDepartmentVirtual.id,HrmDepartmentVirtual.supdepid,
       tempHrmDepartmentVirtual.level + 1 as level
  from tempHrmDepartmentVirtual, HrmDepartmentVirtual
 where tempHrmDepartmentVirtual.id = HrmDepartmentVirtual.supdepid
)
select * from tempHrmDepartmentVirtual
GO

update HrmSubCompany set tlevel=(select level from tempHrmSubCompanyView where tempHrmSubCompanyView.id=HrmSubCompany.id)
GO
update HrmSubCompanyVirtual set tlevel=(select level from tempHrmSubCompanyVirtualView where tempHrmSubCompanyVirtualView.id=HrmSubCompanyVirtual.id)
GO
update HrmDepartment set tlevel=(select level from tempHrmDepartmentView where tempHrmDepartmentView.id=HrmDepartment.id)
GO
update HrmDepartmentVirtual set tlevel=(select level from tempHrmDepartmentVirtualView where tempHrmDepartmentVirtualView.id=HrmDepartmentVirtual.id)
GO
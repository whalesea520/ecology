create view HrmSubCompanyView
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

create view HrmSubCompanyVirtualView
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

create view HrmDepartmentView
as
with tempHrmDepartment as(select id,supdepid,(select level from HrmSubCompanyView where HrmDepartment.subcompanyid1=HrmSubCompanyView.id)+1 as level from HrmDepartment where supdepid=0
 union all
 select HrmDepartment.id,HrmDepartment.supdepid,
       tempHrmDepartment.level + 1 as level
  from tempHrmDepartment, HrmDepartment
 where tempHrmDepartment.id = HrmDepartment.supdepid
)
select * from tempHrmDepartment
GO

create view HrmDepartmentVirtualView
as
with tempHrmDepartmentVirtual as(select id,supdepid,(select level from HrmSubCompanyVirtualView where HrmDepartmentVirtual.subcompanyid1=HrmSubCompanyVirtualView.id)+1 as level from HrmDepartmentVirtual where supdepid=0
 union all
 select HrmDepartmentVirtual.id,HrmDepartmentVirtual.supdepid,
       tempHrmDepartmentVirtual.level + 1 as level
  from tempHrmDepartmentVirtual, HrmDepartmentVirtual
 where tempHrmDepartmentVirtual.id = HrmDepartmentVirtual.supdepid
)
select * from tempHrmDepartmentVirtual
GO

alter table HrmDepartment add tlevel int
GO
alter table HrmDepartmentVirtual add tlevel int
GO
alter table HrmSubCompany add tlevel int
GO
alter table HrmSubCompanyVirtual add tlevel int
GO
update HrmSubCompany set tlevel=(select level from HrmSubCompanyView where HrmSubCompanyView.id=HrmSubCompany.id)
GO
update HrmSubCompanyVirtual set tlevel=(select level from HrmSubCompanyVirtualView where HrmSubCompanyVirtualView.id=HrmSubCompanyVirtual.id)
GO
update HrmDepartment set tlevel=(select level from HrmDepartmentView where HrmDepartmentView.id=HrmDepartment.id)
GO
update HrmDepartmentVirtual set tlevel=(select level from HrmDepartmentVirtualView where HrmDepartmentVirtualView.id=HrmDepartmentVirtual.id)
GO
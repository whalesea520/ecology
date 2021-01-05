create table ProjectAccessory
(
pathcategory varchar(100),
maincategory varchar(10),
subcategory varchar(10),
seccategory varchar(10)
)
GO

alter table Prj_ProjectInfo add accessory varchar(500) null
GO

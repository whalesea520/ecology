create table crm_customerSettings(
	id int,
	modifyuser varchar(20),
	crm_rmd_create varchar(1),
	crm_rmd_create2 varchar(1),
	modifydate varchar(10),
	modifytime varchar(10)
)
GO
insert into crm_customerSettings (id,crm_rmd_create,crm_rmd_create2) values (-1,'Y',1)
GO
alter table crm_customerSettings add sell_rmd_create varchar(1)
GO
alter table crm_customerSettings add sell_rmd_create2 varchar(1)
GO
update crm_customerSettings set sell_rmd_create='Y',sell_rmd_create2=1
GO
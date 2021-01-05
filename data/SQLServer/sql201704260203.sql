alter table formactionset add dmlsource int
GO
alter table formactionset add dmlsourcetype varchar(10)
GO
alter table formactionset add dmlsourceorder int
GO
update formactionset set dmlsource = formid,dmlsourcetype = 'main',dmlsourceorder = 1
GO
alter table formactionfieldmap add transttype int
GO
alter table formactionfieldmap add extrainfo text
GO

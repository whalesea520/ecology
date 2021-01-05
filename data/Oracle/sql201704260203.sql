alter table formactionset add dmlsource int
/
alter table formactionset add dmlsourcetype varchar2(10)
/
alter table formactionset add dmlsourceorder int
/
update formactionset set dmlsource = formid,dmlsourcetype = 'main',dmlsourceorder = 1
/
alter table formactionfieldmap add transttype int
/
alter table formactionfieldmap add extrainfo clob
/

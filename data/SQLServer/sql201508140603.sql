alter table hrsyncset add  subcomouternew varchar(200)
GO
ALTER TABLE hrsyncset add  deptouternew varchar(200)
GO
ALTER TABLE hrsyncset add  jobouternew varchar(200)
GO
ALTER TABLE hrsyncset add  hrmouternew varchar(200)
GO
update hrsyncset set subcomouternew=(select outfield  from hrsyncsetparam where type=1 and isnewfield=1 ),
deptouternew=(select outfield  from hrsyncsetparam where type=2 and isnewfield=1 ),
jobouternew=(select outfield  from hrsyncsetparam where type=3 and isnewfield=1 ),
hrmouternew=(select outfield  from hrsyncsetparam where type=4 and isnewfield=1 )
GO
delete hrsyncsetparam where  isnewfield=1
GO

insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) select id,'id','性别id','sex id','int','1','2','0' from Sys_tabledict where tablename='hrmsex'
/
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) select id,'sexname','人员性别','sex','varchar(10)','1','1','1' from Sys_tabledict where tablename='hrmsex'
/

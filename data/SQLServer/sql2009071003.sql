create table hrmsex(
id int,
sexname varchar(10)
)
GO

insert into hrmsex values(0,'男')
GO
insert into hrmsex values(1,'女')
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('hrmsex','人员性别表','sex of people',0,1,'人员性别表')
GO

insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(46,'id','性别id','sex id','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(46,'sexname','人员性别','sex','varchar(10)',1,1,1)
GO

insert into Sys_fielddict values(1,'sex','性别','sex','char(1)',1,1,50) 

GO
 
 
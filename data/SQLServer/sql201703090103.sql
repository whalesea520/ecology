alter table cpt_cptwfconf add cptno varchar(100)
go
alter table cpt_cptwfconf add zclx int
go
alter table cpt_cptwfconf add rkrq varchar(10)
go
alter table cpt_cptwfconf add ssbm int
go
insert into cptcapitalstate values(7,'变更','变更的资产',1)
go
insert into CptCapitalModifyField(field,name) values(78,'数量')
go
insert into CptCapitalModifyField(field,name) values(79,'入库日期')
go
insert into CptCapitalModifyField(field,name) values(80,'所属分部')
go
insert into CptCapitalModifyField(field,name) values(81,'所属部门')
go
insert into CptCapitalModifyField(field,name) values(82,'使用部门')
go
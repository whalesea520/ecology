alter table cpt_cptwfconf add cptno varchar(100)
/
alter table cpt_cptwfconf add zclx int
/
alter table cpt_cptwfconf add rkrq varchar(10)
/
alter table cpt_cptwfconf add ssbm int
/
insert into cptcapitalstate values(7,'变更','变更的资产',1)
/
insert into CptCapitalModifyField(field,name) values(78,'数量')
/
insert into CptCapitalModifyField(field,name) values(79,'入库日期')
/
insert into CptCapitalModifyField(field,name) values(80,'所属分部')
/
insert into CptCapitalModifyField(field,name) values(81,'所属部门')
/
insert into CptCapitalModifyField(field,name) values(82,'使用部门')
/
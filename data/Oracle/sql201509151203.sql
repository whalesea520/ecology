update prjDefineField set fielddbtype='varchar(500)' where fieldname='name'
/
create table prj_projectinfo_bak as select id,name from prj_projectinfo
/
update prj_projectinfo set name=null
/
alter table prj_projectinfo modify(name varchar2(500))
/

UPDATE prj_projectinfo a 
SET name = (SELECT b.name FROM prj_projectinfo_bak b WHERE b.id = a.id)
WHERE EXISTS (SELECT * FROM prj_projectinfo_bak b WHERE b.id = a.id)
/
drop table prj_projectinfo_bak
/



alter table hpbaselayout add  ftl varchar(30)
/
update hpbaselayout set ftl='OneRow.htm' where id=1
/
update hpbaselayout set ftl='TwoRow.htm' where id=2
/
update hpbaselayout set ftl='ThereRow.htm' where id=3
/
update hpbaselayout set ftl='OtherRow.htm' where id=4
/
update hpbaselayout set ftl='OtherRow_2.htm' where id=5
/


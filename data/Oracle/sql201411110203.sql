alter table modehtmllayout add isdefault int
/
update modehtmllayout set isdefault =1
/

alter table modeformfield add layoutid int
/
update modeformfield a SET a.layoutid= (SELECT ID FROM modehtmllayout b WHERE a.modeid=b.modeid and a.type=b.type)
/

alter table modefieldattr add layoutid int
/
update modefieldattr a SET a.layoutid= (SELECT ID FROM modehtmllayout b WHERE a.modeid=b.modeid and a.type=b.type and a.formid=b.formid)
/

alter table modeformgroup add layoutid int
/
update modeformgroup a SET a.layoutid= (SELECT ID FROM modehtmllayout b WHERE a.modeid=b.modeid and a.type=b.type and a.formid=b.formid)
/

alter table moderightinfo add layoutid int
/

alter table moderightinfo add layoutid1 int
/

alter table moderightinfo add layoutorder int
/

alter table mode_searchPageshareinfo add layoutid int
/

alter table mode_searchPageshareinfo add layoutid1 int
/

alter table mode_searchPageshareinfo add layoutorder int
/
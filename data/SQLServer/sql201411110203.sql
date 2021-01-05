alter table modehtmllayout add isdefault int
go
update modehtmllayout set isdefault =1
go

alter table modeformfield add layoutid int
go
update modeformfield set layoutid= b.id from   modeformfield a ,  modehtmllayout b where a.modeid=b.modeid and a.type=b.type
go

alter table modefieldattr add layoutid int
go
update modefieldattr set layoutid= b.id from   modefieldattr a ,  modehtmllayout b where a.modeid=b.modeid and a.type=b.type and a.formid=b.formid
go

alter table modeformgroup add layoutid int
go
update modeformgroup set layoutid= b.id from   modeformgroup a ,  modehtmllayout b where a.modeid=b.modeid and a.type=b.type and a.formid=b.formid
go

alter table moderightinfo add layoutid int
go

alter table moderightinfo add layoutid1 int
go

alter table moderightinfo add layoutorder int
go

alter table mode_searchPageshareinfo add layoutid int
go

alter table mode_searchPageshareinfo add layoutid1 int
go

alter table mode_searchPageshareinfo add layoutorder int
go
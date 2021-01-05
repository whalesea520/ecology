alter table AppHomepage_Model add isdefault int
go
update AppHomepage_Model set isdefault=1 where uitype in(0,1,2)
go
alter table AppHomepage_Model add layoutid int
go
update AppHomepage_Model set layoutid=b.id from AppHomepage_Model a, modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type+1 and b.type=0
go	
update AppHomepage_Model set layoutid=b.id from AppHomepage_Model a, modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type-1 and b.type=1
go
update AppHomepage_Model set layoutid=b.id from AppHomepage_Model a, modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type and b.type=2
go
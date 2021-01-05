alter table AppHomepage_Model add isdefault int
/
update AppHomepage_Model set isdefault=1 where uitype in(0,1,2)
/
alter table AppHomepage_Model add layoutid int
/
update AppHomepage_Model a set layoutid=(select b.id from modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type+1 and b.type=0)
/
update AppHomepage_Model a set layoutid=(select b.id from modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type-1 and b.type=1)
/
update AppHomepage_Model a set layoutid=(select b.id from modehtmllayout b,AppHomepage c where a.modelid=b.modeid and b.isdefault=1 and a.apphomepageid=c.id and a.uitype=b.type and b.type=2)
/

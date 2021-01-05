update modeattrlinkage set layoutid= b.id from   modeattrlinkage a ,  modehtmllayout b where a.modeid=b.modeid and a.type=b.type and b.isdefault=1
go
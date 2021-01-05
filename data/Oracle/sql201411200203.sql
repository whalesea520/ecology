update modeattrlinkage a SET a.layoutid= (SELECT id FROM modehtmllayout b WHERE a.modeid=b.modeid and a.type=b.type and b.isdefault=1)
/
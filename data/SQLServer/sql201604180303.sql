delete from  ColorStyleInfo where userid in  (SELECT id FROM HrmResource WHERE subcompanyid1 in (select a.subcompanyid from SystemTemplateSubComp a inner join SystemTemplate b on a.templateid=b.id))
GO
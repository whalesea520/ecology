update hrmdepartment set supdepid=0 where supdepid not in (select id from hrmdepartment)
GO

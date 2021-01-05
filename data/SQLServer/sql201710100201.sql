delete from HtmlLabelIndex where id=131820 
GO
delete from HtmlLabelInfo where indexid=131820 
GO
INSERT INTO HtmlLabelIndex values(131820,'存在空行时仅会导入空行以上的数据，空行以下的数据不会导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(131820,'存在空行时仅会导入空行以上的数据，空行以下的数据不会导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131820,'When there is a blank line, only the data above the empty line is imported, and the data below the empty line is not imported',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131820,'存在空行時僅會導入空行以上的數據，空行以下的數據不會導入',9) 
GO
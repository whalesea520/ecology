delete from HtmlLabelIndex where id=24784 
GO
delete from HtmlLabelInfo where indexid=24784 
GO
INSERT INTO HtmlLabelIndex values(24784,'请用半角逗号分隔 (15012345678,15112345678...),号码五个之内!') 
GO
INSERT INTO HtmlLabelInfo VALUES(24784,'请用半角逗号分隔 (15012345678,15112345678...),号码五个之内!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24784,'pleas separated by "," (15012345678,15112345678...),Number within five!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24784,'請用半角逗號分隔 (15012345678,15112345678...),號碼五個之內！',9) 
GO

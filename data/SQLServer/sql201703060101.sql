delete from HtmlLabelIndex where id=129944 
GO
delete from HtmlLabelInfo where indexid=129944 
GO
INSERT INTO HtmlLabelIndex values(129944,'附件格式为"." + 后缀,不区分大小写,支持通配符"*" ,多个以";"分割,如*.txt;') 
GO
INSERT INTO HtmlLabelInfo VALUES(129944,'附件格式为"." + 后缀,不区分大小写,支持通配符"*" ,多个以";"分割,如*.txt;',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129944,'The attachment format "." + suffix, separated with ";" such as *.txt;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129944,'附件格式為"."+尾碼，不區分大小寫，支持萬用字元"*"，多個以";"分割，如*.txt;',9) 
GO
delete from HtmlLabelIndex where id=127231 
GO
delete from HtmlLabelInfo where indexid=127231 
GO
INSERT INTO HtmlLabelIndex values(127231,'附件上传格式') 
GO
INSERT INTO HtmlLabelInfo VALUES(127231,'附件上传格式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127231,'annex format',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127231,'附件上傳格式',9) 
GO
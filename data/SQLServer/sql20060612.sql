INSERT INTO HtmlLabelIndex values(19206,'默认值') 
GO
INSERT INTO HtmlLabelInfo VALUES(19206,'默认值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19206,'default value',8) 
GO

INSERT INTO HtmlLabelIndex values(19207,'关联文档目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19207,'关联文档目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19207,'Doc Catalog of connection',8) 
GO

INSERT INTO HtmlLabelIndex values(19213,'固定目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19213,'固定目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19213,'root catalog',8) 
GO

INSERT INTO HtmlLabelIndex values(19214,'选择目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19214,'选择目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19214,'select catalog',8) 
GO

ALTER TABLE workflow_base ADD catelogType INT NULL
GO

ALTER TABLE workflow_base ADD selectedCateLog INT NULL
GO

ALTER TABLE workflow_SelectItem ADD docPath VARCHAR(100) NULL
GO

ALTER TABLE workflow_SelectItem ADD docCategory VARCHAR(200) NULL
GO

INSERT INTO HtmlLabelIndex values(19255,'已选择条件') 
GO
INSERT INTO HtmlLabelInfo VALUES(19255,'已选择条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19255,'Chose Condition',8) 
GO

delete from HtmlLabelIndex where id=19255
GO
delete from HtmlLabelInfo where indexid=19255
GO

INSERT INTO HtmlLabelIndex values(19255,'已选择条件') 
GO
INSERT INTO HtmlLabelInfo VALUES(19255,'已选择条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19255,'Chose Condition',8) 
GO

delete from HtmlLabelIndex where id=19303
GO
delete from HtmlLabelInfo where indexid=19303
GO

INSERT INTO HtmlLabelIndex values(19303,'人力资源条件') 
GO
INSERT INTO HtmlLabelInfo VALUES(19303,'人力资源条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19303,'Resource Condition',8) 
GO

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 141,19303,'text','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp','','','','')
GO

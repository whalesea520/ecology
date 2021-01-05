ALTER TABLE LeftMenuInfo ADD
	isAdvance int NULL,
	fromModule int NULL,
	menuType int NULL,
	displayUsage int NULL,
	selectedContent varchar(500) NULL
GO


INSERT INTO HtmlLabelIndex values(19094,'显示全部项目') 
GO
INSERT INTO HtmlLabelInfo VALUES(19094,'显示全部项目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19094,'Show All Project',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19119,'缩略图显示') 
GO
INSERT INTO HtmlLabelInfo VALUES(19119,'缩略图显示',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19119,'Thumbnail View',8) 
GO
 
 
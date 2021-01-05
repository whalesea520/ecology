/*FOR BUG 517*/
INSERT INTO HtmlLabelIndex values(17428,'系统不支持10层以上的组织结构') 
GO
INSERT INTO HtmlLabelInfo VALUES(17428,'系统不支持10层以上的组织结构',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17428,'The system doesn''t support 10 level of department',8) 
GO
/*FOR BUG 454*/
UPDATE Meeting SET meetingstatus = 2 WHERE isapproved >=2
GO

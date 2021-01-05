DELETE FROM HtmlLabelIndex WHERE id=20290
GO
DELETE FROM HtmlLabelInfo WHERE indexId=20290
GO
INSERT INTO HtmlLabelIndex values(20290,'相册空间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20290,'相册空间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20290,'Album Size',8) 
GO
update  LeftMenuInfo set labelId=20290 where id=208 
GO

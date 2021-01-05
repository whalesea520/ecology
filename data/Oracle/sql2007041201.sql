DELETE FROM HtmlLabelIndex WHERE id=20290
/
DELETE FROM HtmlLabelInfo WHERE indexId=20290
/
INSERT INTO HtmlLabelIndex values(20290,'相册空间') 
/
INSERT INTO HtmlLabelInfo VALUES(20290,'相册空间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20290,'Album Size',8) 
/
update  LeftMenuInfo set labelId=20290 where id=208 
/

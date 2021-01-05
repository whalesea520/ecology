DELETE FROM HtmlLabelIndex WHERE id=19995
/
DELETE FROM HtmlLabelInfo WHERE indexid=19995
/

INSERT INTO HtmlLabelIndex VALUES(19995,'该名称模版已经存在，请重新输入新的名称！') 
/
INSERT INTO HtmlLabelInfo VALUES(19995,'该名称模版已经存在，请重新输入新的名称！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19995,'This name has existed,Please input another!',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=19996
/
DELETE FROM HtmlLabelInfo WHERE indexid=19996
/

INSERT INTO HtmlLabelIndex VALUES(19996,'源目录') 
/
INSERT INTO HtmlLabelInfo VALUES(19996,'源目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19996,'Source Directory',8) 
/

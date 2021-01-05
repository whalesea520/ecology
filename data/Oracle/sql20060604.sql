ALTER TABLE LeftMenuInfo ADD isAdvance integer NULL
/

ALTER TABLE LeftMenuInfo ADD fromModule integer NULL
/

ALTER TABLE LeftMenuInfo ADD menuType integer NULL
/

ALTER TABLE LeftMenuInfo ADD displayUsage integer NULL
/

ALTER TABLE LeftMenuInfo ADD selectedContent varchar2(500) NULL
/


INSERT INTO HtmlLabelIndex values(19094,'显示全部项目') 
/
INSERT INTO HtmlLabelInfo VALUES(19094,'显示全部项目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19094,'Show All Project',8) 
/
 
INSERT INTO HtmlLabelIndex values(19119,'缩略图显示') 
/
INSERT INTO HtmlLabelInfo VALUES(19119,'缩略图显示',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19119,'Thumbnail View',8) 
/
 
 
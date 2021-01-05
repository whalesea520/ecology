update MainMenuInfo set linkAddress='/cloudstore/system/index.jsp', baseTarget='_blank'   where labelid=33644 and  (SELECT count(*)  FROM license WHERE cversion like '7%')>0
/
 delete from MainMenuInfo where labelId in(25432,128769,128770,128771,128772) and (SELECT count(*)  FROM license WHERE cversion like '7%')>0
/

delete from HtmlLabelIndex where id=129523 
/
delete from HtmlLabelInfo where indexid=129523 
/
INSERT INTO HtmlLabelIndex values(129523,'云服务') 
/
INSERT INTO HtmlLabelInfo VALUES(129523,'云服务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(129523,'cloud service',8) 
/
INSERT INTO HtmlLabelInfo VALUES(129523,'雲服務',9) 
/

DELETE FROM MainMenuInfo WHERE id = 10010
/
delete HtmlLabelIndex where id in(20281,20282,20283,20284,20285)
/
delete HtmlLabelInfo where  indexid in(20281,20282,20283,20284,20285)
/
INSERT INTO HtmlLabelIndex values(20285,'向下') 
/
INSERT INTO HtmlLabelIndex values(20282,'向左') 
/
INSERT INTO HtmlLabelIndex values(20283,'向右') 
/
INSERT INTO HtmlLabelIndex values(20284,'向上') 
/
INSERT INTO HtmlLabelIndex values(20281,'滚动方向') 
/
INSERT INTO HtmlLabelInfo VALUES(20281,'滚动方向',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20281,'roll direction',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20282,'向左',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20282,'Left',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20283,'向右',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20283,'Right',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20284,'向上',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20284,'Up',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20285,'向下',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20285,'Down',8) 
/

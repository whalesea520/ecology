delete HtmlLabelIndex where id in(20281,20282,20283,20284,20285)
GO
delete HtmlLabelInfo where  indexid in(20281,20282,20283,20284,20285)
GO
INSERT INTO HtmlLabelIndex values(20285,'向下') 
GO
INSERT INTO HtmlLabelIndex values(20282,'向左') 
GO
INSERT INTO HtmlLabelIndex values(20283,'向右') 
GO
INSERT INTO HtmlLabelIndex values(20284,'向上') 
GO
INSERT INTO HtmlLabelIndex values(20281,'滚动方向') 
GO
INSERT INTO HtmlLabelInfo VALUES(20281,'滚动方向',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20281,'roll direction',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20282,'向左',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20282,'Left',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20283,'向右',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20283,'Right',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20284,'向上',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20284,'Up',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20285,'向下',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20285,'Down',8) 
GO

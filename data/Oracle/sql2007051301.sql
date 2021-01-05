delete from HtmlLabelIndex where id in (20305,20306,20307)
/

delete from HtmlLabelInfo where indexid in (20305,20306,20307)
/

INSERT INTO HtmlLabelIndex values(20305,'监控权限') 
/
INSERT INTO HtmlLabelIndex values(20306,'可查看') 
/
INSERT INTO HtmlLabelIndex values(20307,'可删除') 
/
INSERT INTO HtmlLabelInfo VALUES(20305,'监控权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20305,'monitor rights',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20306,'可查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20306,'can view',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20307,'可删除',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20307,'can delete',8) 
/
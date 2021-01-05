delete from HtmlLabelIndex where id in(20272,20273)
/
delete from HtmlLabelInfo where indexId in(20272,20273)
/
INSERT INTO HtmlLabelIndex values(20272,'请输入客户名称，系统将搜索是否有重名客户。') 
/
INSERT INTO HtmlLabelIndex values(20273,'如已有类似名称客户存在，系统将给出提醒，否则直接进入新建客户卡片页面。') 
/
INSERT INTO HtmlLabelInfo VALUES(20272,'请输入客户名称，系统将搜索是否有重名客户。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20272,'Please input customer name,system will search whether has repeated customer name.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20273,'如已有类似名称客户存在，系统将给出提醒，否则直接进入新建客户卡片页面。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20273,'If it has similar customer name,system will remind,otherwise it direct turn to new customer card page.',8) 
/
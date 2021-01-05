update CRM_ADDRESSTYPE set ORDERKEY=id
/
update CRM_CONTACTWAY set ORDERKEY=id
/
update CRM_CUSTOMERSIZE set ORDERKEY=id
/
update CRM_CUSTOMERDESC set ORDERKEY=id
/
update CRM_CUSTOMERTYPE set ORDERKEY=id
/
delete from HtmlLabelIndex where id=26963 
/
delete from HtmlLabelInfo where indexid=26963 
/
INSERT INTO HtmlLabelIndex values(26963,'当前没有关注的人') 
/
INSERT INTO HtmlLabelInfo VALUES(26963,'当前没有关注的人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(26963,'People who are not currently concerned about',8) 
/
INSERT INTO HtmlLabelInfo VALUES(26963,'當前沒有關注的人',9) 
/



	





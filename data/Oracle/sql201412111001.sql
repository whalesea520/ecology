delete from HtmlLabelIndex where id=31106 
/
delete from HtmlLabelInfo where indexid=31106 
/
INSERT INTO HtmlLabelIndex values(31106,'ҵ������') 
/
INSERT INTO HtmlLabelInfo VALUES(31106,'ҵ������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31106,'Business name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31106,'�I�����Q',9) 
/
INSERT into CRM_CustomizeOption(id,tabledesc,fieldname,labelid,labelname) VALUES (213,1,'textfield2',31106,'ҵ������')
/
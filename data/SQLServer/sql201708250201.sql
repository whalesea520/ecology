delete from HtmlLabelIndex where id=131396 
GO
delete from HtmlLabelInfo where indexid=131396 
GO
INSERT INTO HtmlLabelIndex values(131396,'����ʱ���滻ԭ��Ա�б�') 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'����ʱ���滻ԭ��Ա�б�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'When overridden, the original staff list will be replaced',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'���w�r����Qԭ�ˆT�б�',9) 
GO
delete from HtmlLabelIndex where id=131423 
GO
delete from HtmlLabelInfo where indexid=131423 
GO
INSERT INTO HtmlLabelIndex values(131423,'������ʾ��ѯͬʱ������ѡ�������е���Ա') 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'������ʾ��ѯͬʱ������ѡ�������е���Ա',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'Open the query indicating the presence of people in the selected common group',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'�_����ʾ��ԃͬ�r�������x���ýM�е��ˆT',9) 
GO
alter table hrmsearchmould drop column groupid 
GO
alter table hrmsearchmould add groupid char(480)
GO
alter table hrmsearchmould add groupVaild char(1)
GO
delete from HtmlLabelIndex where id=127277 
GO
delete from HtmlLabelInfo where indexid=127277 
GO
INSERT INTO HtmlLabelIndex values(127277,'�Ƿ��ų��ǹ�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(127277,'�Ƿ��ų��ǹ�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127277,'Whether to exclude non working days',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127277,'�Ƿ��ų��ǹ�����',9) 
GO
alter table hrm_att_proc_set add field016 varchar(1)
GO
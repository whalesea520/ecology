delete from SystemLogItem where itemid='156' 
GO
insert into SystemLogItem(itemid,lableid,itemdesc) values('156',32713,'��ɫ���ι���')
GO



delete from HtmlLabelIndex where id=32713 
GO
delete from HtmlLabelInfo where indexid=32713 
GO
INSERT INTO HtmlLabelIndex values(32713,'��ɫ���ι���') 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'��ɫ���ι���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'The role of network management',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'��ɫ�W�ι���',9) 
GO

delete from HtmlLabelIndex where id=32717 
GO
delete from HtmlLabelInfo where indexid=32717 
GO
INSERT INTO HtmlLabelIndex values(32717,'����') 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'Segment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'�W��',9) 
GO

delete from HtmlLabelIndex where id=32721 
GO
delete from HtmlLabelInfo where indexid=32721 
GO
INSERT INTO HtmlLabelIndex values(32721,'�������ѱ���ɫʹ�ã��޷�ɾ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'�������ѱ���ɫʹ�ã��޷�ɾ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'This network has been the role of use, cannot be deleted',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'�˾W���ѱ���ɫʹ�ã��o��ɾ��',9) 
GO
delete from SystemLogItem where itemid='156' 
/
insert into SystemLogItem(itemid,lableid,itemdesc) values('156',32713,'��ɫ���ι���')
/



delete from HtmlLabelIndex where id=32713 
/
delete from HtmlLabelInfo where indexid=32713 
/
INSERT INTO HtmlLabelIndex values(32713,'��ɫ���ι���') 
/
INSERT INTO HtmlLabelInfo VALUES(32713,'��ɫ���ι���',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32713,'The role of network management',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32713,'��ɫ�W�ι���',9) 
/

delete from HtmlLabelIndex where id=32717 
/
delete from HtmlLabelInfo where indexid=32717 
/
INSERT INTO HtmlLabelIndex values(32717,'����') 
/
INSERT INTO HtmlLabelInfo VALUES(32717,'����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32717,'Segment',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32717,'�W��',9) 
/

delete from HtmlLabelIndex where id=32721 
/
delete from HtmlLabelInfo where indexid=32721 
/
INSERT INTO HtmlLabelIndex values(32721,'�������ѱ���ɫʹ�ã��޷�ɾ��') 
/
INSERT INTO HtmlLabelInfo VALUES(32721,'�������ѱ���ɫʹ�ã��޷�ɾ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32721,'This network has been the role of use, cannot be deleted',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32721,'�˾W���ѱ���ɫʹ�ã��o��ɾ��',9) 
/
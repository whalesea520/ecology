alter table cowork_discuss ADD remarkback TEXT
GO
ALTER TABLE COWORK_DISCUSS ADD delUserId INTEGER
GO
ALTER TABLE COWORK_DISCUSS ADD delTime VARCHAR(19)
GO
create index index_cowork_delUserId on COWORK_DISCUSS(delUserId)
go

create index index_cowork_delTime on COWORK_DISCUSS(delTime)
go

update COWORK_DISCUSS set remarkBack = remark where isDel = 1
GO

delete from HtmlLabelIndex where id=131886 
GO
delete from HtmlLabelInfo where indexid=131886 
GO
INSERT INTO HtmlLabelIndex values(131886,'���ۼ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(131886,'���ۼ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131886,'Comments on monitoring',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131886,'�uՓ�O��',9) 
GO

Delete from LeftMenuInfo where id=756
GO
EXECUTE LMConfig_U_ByInfoInsert 2,80,12
GO
EXECUTE LMInfo_Insert 756,131886,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=commentMonitor',2,80,12,10 
GO


delete from HtmlNoteIndex where id=4827 
GO
delete from HtmlNoteInfo where indexid=4827 
GO
INSERT INTO HtmlNoteIndex values(4827,'ע�⣺�˲���������ɾ�����⣬�Լ����������н��������ɻָ���') 
GO
INSERT INTO HtmlNoteInfo VALUES(4827,'ע�⣺�˲���������ɾ�����⣬�Լ����������н��������ɻָ���',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4827,'Note: This will permanently delete the theme, as well as all the exchanges in the subject, can not b',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4827,'ע�⣺�˲���������ɾ�����}���Լ����}�����н��������ɻ��}��',9) 
GO

delete from HtmlNoteIndex where id=4828 
GO
delete from HtmlNoteInfo where indexid=4828 
GO
INSERT INTO HtmlNoteIndex values(4828,'ͬʱɾ�������ӵ���������') 
GO
INSERT INTO HtmlNoteInfo VALUES(4828,'ͬʱɾ�������ӵ���������',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4828,'Also delete all comments for that post',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4828,'ͬ�rɾ��ԓ���ӵ������uՓ',9) 
GO
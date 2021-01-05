ALTER TABLE COWORK_DISCUSS ADD remarkBack CLOB
/
ALTER TABLE COWORK_DISCUSS ADD delUserId NUMBER
/
ALTER TABLE COWORK_DISCUSS ADD delTime VARCHAR2(19)
/
create index index_cowork_delUserId on COWORK_DISCUSS(delUserId)
/

create index index_cowork_delTime on COWORK_DISCUSS(delTime)
/

update COWORK_DISCUSS set remarkBack = remark where isDel = 1

/
delete from HtmlLabelIndex where id=131886 
/
delete from HtmlLabelInfo where indexid=131886 
/
INSERT INTO HtmlLabelIndex values(131886,'���ۼ��') 
/
INSERT INTO HtmlLabelInfo VALUES(131886,'���ۼ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(131886,'Comments on monitoring',8) 
/
INSERT INTO HtmlLabelInfo VALUES(131886,'�uՓ�O��',9) 
/

Delete from LeftMenuInfo where id=756
/
CALL LMConfig_U_ByInfoInsert (2,80,12)
/
CALL LMInfo_Insert (756,131886,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif','/cowork/coworkview.jsp?menuType=commentMonitor',2,80,12,10) 
/

delete from HtmlNoteIndex where id=4827 
/
delete from HtmlNoteInfo where indexid=4827 
/
INSERT INTO HtmlNoteIndex values(4827,'ע�⣺�˲���������ɾ�����⣬�Լ����������н��������ɻָ���') 
/
INSERT INTO HtmlNoteInfo VALUES(4827,'ע�⣺�˲���������ɾ�����⣬�Լ����������н��������ɻָ���',7) 
/
INSERT INTO HtmlNoteInfo VALUES(4827,'Note: This will permanently delete the theme, as well as all the exchanges in the subject, can not b',8) 
/
INSERT INTO HtmlNoteInfo VALUES(4827,'ע�⣺�˲���������ɾ�����}���Լ����}�����н��������ɻ��}��',9) 
/
delete from HtmlNoteIndex where id=4828 
/
delete from HtmlNoteInfo where indexid=4828 
/
INSERT INTO HtmlNoteIndex values(4828,'ͬʱɾ�������ӵ���������') 
/
INSERT INTO HtmlNoteInfo VALUES(4828,'ͬʱɾ�������ӵ���������',7) 
/
INSERT INTO HtmlNoteInfo VALUES(4828,'Also delete all comments for that post',8) 
/
INSERT INTO HtmlNoteInfo VALUES(4828,'ͬ�rɾ��ԓ���ӵ������uՓ',9) 
/

delete from SystemRightDetail where rightid =1748
/
delete from SystemRightsLanguage where id =1748
/
delete from SystemRights where id =1748
/
insert into SystemRights (id,rightdesc,righttype) values (1748,'����Ӧ������','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,8,'workflow application setting','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,7,'����Ӧ������','����ͨ�����ÿ�ݵ��������̵ĳ�ʱ��������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1748,9,'���̑����O��','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43018,'����Ӧ������','WorkflowManage:PsSet',1748) 
/
DELETE from systemrighttogroup where (GROUPid=8 and RIGHTid=1748) 
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (8, 1748)
/
delete from SystemRightDetail where rightid =1729
/
delete from SystemRightsLanguage where id =1729
/
delete from SystemRights where id =1729
/
insert into SystemRights (id,rightdesc,righttype) values (1729,'�ճ�Ӧ������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,7,'�ճ�Ӧ������','�ճ�Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,9,'�ճ̑����O��','�ճ̑����O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1729,8,'WorkPlan Set','WorkPlan Set') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42958,'�ճ�Ӧ������','WorkPlan:Set',1729) 
/
delete from SystemRightDetail where rightid =1849
/
delete from SystemRightsLanguage where id =1849
/
delete from SystemRights where id =1849
/
insert into SystemRights (id,rightdesc,righttype) values (1849,'������������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,9,'������������','������������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,7,'������������','������������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,8,'Attendance process Settings','Attendance process Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43078,'������������','HrmAttendanceProcess:setting',1849) 
/
delete from SystemRightDetail where rightid =1850
/
delete from SystemRightsLanguage where id =1850
/
delete from SystemRights where id =1850
/
insert into SystemRights (id,rightdesc,righttype) values (1850,'������Ч������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,8,'Paid leave Settings','Paid leave Settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,7,'������Ч������','������Ч������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,9,'������Ч������','������Ч������') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43079,'������Ч������','HrmPaidLeave:setting',1850) 
/
delete from SystemRightDetail where rightid =1851
/
delete from SystemRightsLanguage where id =1851
/
delete from SystemRights where id =1851
/
insert into SystemRights (id,rightdesc,righttype) values (1851,'����ʱ������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,8,'Paid leave time to query','Paid leave time to query') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,7,'����ʱ������','����ʱ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,9,'����ʱ������','����ʱ������') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43080,'����ʱ������','HrmPaidLeaveTime:search',1851) 
/
delete from SystemRightDetail where rightid =1852
/
delete from SystemRightsLanguage where id =1852
/
delete from SystemRights where id =1852
/
insert into SystemRights (id,rightdesc,righttype) values (1852,'�¿�����������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,8,'Month calendar of check on work attendance report','Month calendar of check on work attendance report') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,7,'�¿�����������','�¿�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,9,'�¿�����������','�¿�����������') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43081,'�¿�����������','HrmMonthAttendanceReport:report',1852) 
/
delete from SystemRightDetail where rightid =790
/
delete from SystemRightsLanguage where id =790
/
delete from SystemRights where id =790
/
insert into SystemRights (id,rightdesc,righttype) values (790,'�����������','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,7,'�����������','�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,8,'Leave type Settings','Leave type Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4300,'�����������','LeaveTypeColor:all',790) 
/
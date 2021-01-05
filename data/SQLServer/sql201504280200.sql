delete from SystemRightDetail where rightid =1849
GO
delete from SystemRightsLanguage where id =1849
GO
delete from SystemRights where id =1849
GO
insert into SystemRights (id,rightdesc,righttype) values (1849,'考勤流程设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,9,'考勤流程设置','考勤流程设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,7,'考勤流程设置','考勤流程设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1849,8,'Attendance process Settings','Attendance process Settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43078,'考勤流程设置','HrmAttendanceProcess:setting',1849) 
GO
delete from SystemRightDetail where rightid =1850
GO
delete from SystemRightsLanguage where id =1850
GO
delete from SystemRights where id =1850
GO
insert into SystemRights (id,rightdesc,righttype) values (1850,'调休有效期设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,8,'Paid leave Settings','Paid leave Settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,7,'调休有效期设置','调休有效期设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1850,9,'调休有效期设置','调休有效期设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43079,'调休有效期设置','HrmPaidLeave:setting',1850) 
GO
delete from SystemRightDetail where rightid =1851
GO
delete from SystemRightsLanguage where id =1851
GO
delete from SystemRights where id =1851
GO
insert into SystemRights (id,rightdesc,righttype) values (1851,'调休时间设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,8,'Paid leave time to query','Paid leave time to query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,7,'调休时间设置','调休时间设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1851,9,'调休时间设置','调休时间设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43080,'调休时间设置','HrmPaidLeaveTime:search',1851) 
GO
delete from SystemRightDetail where rightid =1852
GO
delete from SystemRightsLanguage where id =1852
GO
delete from SystemRights where id =1852
GO
insert into SystemRights (id,rightdesc,righttype) values (1852,'月考勤日历报表','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,8,'Month calendar of check on work attendance report','Month calendar of check on work attendance report') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,7,'月考勤日历报表','月考勤日历报表') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1852,9,'月考勤日历报表','月考勤日历报表') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43081,'月考勤日历报表','HrmMonthAttendanceReport:report',1852) 
GO
delete from SystemRightDetail where rightid =790
GO
delete from SystemRightsLanguage where id =790
GO
delete from SystemRights where id =790
GO
insert into SystemRights (id,rightdesc,righttype) values (790,'请假类型设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,7,'请假类型设置','请假类型设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,8,'Leave type Settings','Leave type Settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4300,'请假类型设置','LeaveTypeColor:all',790) 
GO
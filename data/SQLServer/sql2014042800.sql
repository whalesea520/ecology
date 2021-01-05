delete from SystemRightDetail where rightid =1590
GO
delete from SystemRightsLanguage where id =1590
GO
delete from SystemRights where id =1590
GO
insert into SystemRights (id,rightdesc,righttype) values (1590,'会议应用设置','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,8,'meeting manager','meeting manager') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,7,'会议应用设置','会议应用设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,9,'會議應用設置','會議應用設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42829,'会议应用设置','meetingmanager:all',1590) 
GO
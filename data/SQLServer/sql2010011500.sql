delete from SystemRights where id = 906
GO
delete from SystemRightsLanguage where id = 906
GO
delete from SystemRightDetail where id = 4432
GO
insert into SystemRights (id,rightdesc,righttype) values (906,'带薪病假批量处理设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (906,7,'带薪病假批量处理设置','带薪病假批量处理设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (906,8,'Paid sick leave batch processing settings','Paid sick leave batch processing settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (906,9,'帶薪病假批量處理設置','帶薪病假批量處理設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4432,'带薪病假批量处理设置','PSLBatch:All',906) 
GO

delete from SystemRights where id = 907
GO
delete from SystemRightsLanguage where id = 907
GO
delete from SystemRightDetail where id = 4433
GO
insert into SystemRights (id,rightdesc,righttype) values (907,'带薪病假有效期设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (907,7,'带薪病假有效期设置','带薪病假有效期设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (907,8,'Paid sick leave period is set','Paid sick leave period is set') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (907,9,'帶薪病假有效期設置','帶薪病假有效期設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4433,'带薪病假有效期设置','PSLPeriod:All',907) 
GO

delete from SystemRights where id = 908
GO
delete from SystemRightsLanguage where id = 908
GO
delete from SystemRightDetail where id = 4434
GO
insert into SystemRights (id,rightdesc,righttype) values (908,'带薪病假管理','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (908,7,'带薪病假管理','带薪病假管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (908,8,'Paid sick leave management','Paid sick leave management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (908,9,'帶薪病假管理','帶薪病假管理') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4434,'带薪病假管理','PaidSickLeave:All',908) 
GO

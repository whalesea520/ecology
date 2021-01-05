delete from CPT_SELECTITEM where fieldid=-8
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'自制','0',0,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'采购','1',1,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'租赁','2',2,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'出租','3',3,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'维护','4',4,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'租用','5',5,'n','0','1')
GO
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,isbill) values(-8,'其它','6',6,'n','0','1')
GO
update cpt_SelectItem set selectlabel='1366' where fieldid='-8' and selectvalue='0'
GO
update cpt_SelectItem set selectlabel='1367' where fieldid='-8' and selectvalue='1'
GO
update cpt_SelectItem set selectlabel='1368' where fieldid='-8' and selectvalue='2'
GO
update cpt_SelectItem set selectlabel='1369' where fieldid='-8' and selectvalue='3'
GO
update cpt_SelectItem set selectlabel='60' where fieldid='-8' and selectvalue='4'
GO
update cpt_SelectItem set selectlabel='1370' where fieldid='-8' and selectvalue='5'
GO
update cpt_SelectItem set selectlabel='811' where fieldid='-8' and selectvalue='6'
GO
update cpt_SelectItem set selectlabel='15298' where fieldid='-21' and selectvalue='0'
GO
update cpt_SelectItem set selectlabel='15299' where fieldid='-21' and selectvalue='1'
GO
ALTER table bill_meeting add repeatStrategy int
GO
INSERT into workflow_billfield(billid,fieldname,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,viewtype ,fromUser ,dsporder) VALUES

(85,'repeatStrategy',33018,'int',5,1,0,1,3.70)
GO
update meeting_wf_relation set bill_fieldname='repeatStrategy'  where fieldid=14 and billid=85
GO
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','0','非工作日时：日期不变',1.00,'n' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
GO
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','1','非工作日时：推迟到下一工作日',2.00,'n' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
GO
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','2','非工作日时：取消会议',3.00,'y' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
GO
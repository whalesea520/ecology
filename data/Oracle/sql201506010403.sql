ALTER table bill_meeting add repeatStrategy int
/
INSERT into workflow_billfield(billid,fieldname,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,viewtype ,fromUser ,dsporder) VALUES(85,'repeatStrategy',33018,'int',5,1,0,1,3.70)
/
update meeting_wf_relation set bill_fieldname='repeatStrategy'  where fieldid=14 and billid=85
/
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','0','�ǹ�����ʱ�����ڲ���',1.00,'n' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
/
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','1','�ǹ�����ʱ���Ƴٵ���һ������',2.00,'n' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
/
INSERT into workflow_SelectItem (fieldid,isbill,selectvalue,selectname,listorder,isdefault)
select id,'1','2','�ǹ�����ʱ��ȡ������',3.00,'y' from  workflow_billfield where billid=85 and fieldname='repeatStrategy'
/
create table hrm_paid_leave_set (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	field001 int NOT NULL,
	field002 int NOT NULL,
	field003 int NOT NULL
)
GO
create table hrm_leave_type (
	id bigint IDENTITY(1,1) NOT NULL primary key,
	field001 varchar(100),
	field002 int,
	field003 int,
	field004 int,
	field005 varchar(100),
	field006 int,
	field007 varchar(100),
	field008 int
)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('ÊÂ¼Ù',0,0,1,'leaveType',62,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('²¡¼Ù',0,0,2,'leaveType',63,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('Ì½Ç×¼Ù',0,0,1,'otherLeaveType',66,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('Äê¼Ù',0,0,2,'otherLeaveType',67,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('»é¼Ù',0,0,3,'otherLeaveType',68,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('²ú¼Ù¼°¿´»¤¼Ù',0,0,4,'otherLeaveType',69,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('²¸Èé¼Ù',0,0,5,'otherLeaveType',70,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('É¥¼Ù',0,0,6,'otherLeaveType',71,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('¶ùÍ¯Åã»¤¼Ù',0,0,7,'otherLeaveType',72,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('´øÐ½²¡¼Ù',0,0,11,'otherLeaveType',106,'#FF0000', 7)
GO
insert into hrm_leave_type(field001,field002,field003,field004,field005,field006,field007,field008) values('µ÷ÐÝ',0,0,13,'otherLeaveType',-1,'#FF0000', 7)
GO
alter table hrmleavetypecolor add field004 int
GO
alter table hrmleavetypecolor add field005 varchar(50)
GO
update hrmLeaveTypeColor set 
field001 = (case when itemid = 108 then 'µ÷ÐÝ' else (select selectname from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) and id = itemid) end), 
field002 = 0, field003 = 0,
field004 = (case when itemid = 108 then '13' else (select selectvalue from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) and id = itemid) end), 
field005 = (case when itemid = 108 or itemid = -1 then 'otherLeaveType' else (select (select fieldname from workflow_billfield where id = fieldid) as fieldname from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) and id = itemid) end)
GO
update hrm_att_proc_fields set field001 = 45 where field001 = 161
GO
insert into workflow_selectitem(fieldid, isbill, selectvalue, selectname, listorder, isdefault,isAccordToSubCom,cancel) values(655, 1, 13, 'µ÷ÐÝ', 13.00, 'n', 0, '')
GO
alter table workflow_nodefieldattr add transtype int null
go

alter table workflow_crmcssfile add type int
go
alter table workflow_crmcssfile add detailid int
go

update workflow_crmcssfile set type=1
go

create table workflow_cssdetail(
	detailid int IDENTITY,
	outerbordercolor varchar(10),
	outerbordersize int,
	requestnamesize int,
	requestnamecolor varchar(10),
	requestnamefont varchar(20),
	requestnamestyle0 int,
	requestnamestyle1 int,
	maintablecolor varchar(10),
	maintablesize int,
	mainfieldsize int,
	mainfieldcolor varchar(10),
	mainfieldnamecolor varchar(10),
	mainfieldvaluecolor varchar(10),
	mainfieldheight int,
	detailtablecolor varchar(10),
	detailtablesize int,
	detailfieldheight int,
	detailfieldsize int,
	detailfieldcolor varchar(10),
	detailfieldnamecolor varchar(10),
	detailfieldvaluecolor varchar(10)
)
go


insert into workflow_crmcssfile(cssname, realfilename, realpath, type, detailid)
values
('蓝绿风格', 'lanlv.css', '/css/crmcss/lanlv.css', 2, 0)
go

insert into workflow_crmcssfile(cssname, realfilename, realpath, type, detailid)
values
('公文风格', 'gongwen.css', '/css/crmcss/gongwen.css', 2, 0)
go

insert into workflow_crmcssfile(cssname, realfilename, realpath, type, detailid)
values
('经典灰色风格', 'huise.css', '/css/crmcss/huise.css', 2, 0)
go

create table workflow_fieldtrans(
	id int,
	typename varchar(100),
	classname varchar(200)
)
go

insert into workflow_fieldtrans(id, typename, classname)
values
(1, '金额转换', 'weaver.workflow.html.MoneyTrans4FieldTrans')
go

insert into workflow_fieldtrans(id, typename, classname)
values
(2, '金额千分位', 'weaver.workflow.html.MoneySpilt4FieldTrans')
go
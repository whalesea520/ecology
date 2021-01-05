CREATE TABLE OfUrlIcon ( 
    id int IDENTITY PRIMARY KEY,
	name varchar(100) ,
	type varchar(20) ,
	icon varchar(400) ,
	url varchar(400) ,
        counturl varchar(400),
	sort int ,
) 
GO

CREATE TABLE OfIconList ( 
    id int IDENTITY PRIMARY KEY,
	name varchar(20) ,
	url varchar(400) ,
	width int,
	height int 
) 
GO

delete from OfIconList
GO
insert into OfIconList (name,url) values ('ͼ��1','/plugins/emessage/images/icontab_cblog.png')
GO
insert into OfIconList (name,url) values ('ͼ��2','/plugins/emessage/images/icontab_createworkflow.png')
GO
insert into OfIconList (name,url) values ('ͼ��3','/plugins/emessage/images/icontab_customer.png')
GO
insert into OfIconList (name,url) values ('ͼ��4','/plugins/emessage/images/icontab_duanxin.png')
GO
insert into OfIconList (name,url) values ('ͼ��5','/plugins/emessage/images/icontab_email.png')
GO
insert into OfIconList (name,url) values ('ͼ��6','/plugins/emessage/images/icontab_handledworkflow.png')
GO
insert into OfIconList (name,url) values ('ͼ��7','/plugins/emessage/images/icontab_meetting.png')
GO
insert into OfIconList (name,url) values ('ͼ��8','/plugins/emessage/images/icontab_message.png')
GO
insert into OfIconList (name,url) values ('ͼ��9','/plugins/emessage/images/icontab_myrequest.png')
GO
insert into OfIconList (name,url) values ('ͼ��10','/plugins/emessage/images/icontab_processedworkflow.png')
GO
insert into OfIconList (name,url) values ('ͼ��11','/plugins/emessage/images/icontab_proj.png')
GO
insert into OfIconList (name,url) values ('ͼ��12','/plugins/emessage/images/icontab_todolist.png')
GO
insert into OfIconList (name,url) values ('ͼ��13','/plugins/emessage/images/icontab_xiezuo.png')
GO
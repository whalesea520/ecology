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
insert into OfIconList (name,url) values ('图标1','/plugins/emessage/images/icontab_cblog.png')
GO
insert into OfIconList (name,url) values ('图标2','/plugins/emessage/images/icontab_createworkflow.png')
GO
insert into OfIconList (name,url) values ('图标3','/plugins/emessage/images/icontab_customer.png')
GO
insert into OfIconList (name,url) values ('图标4','/plugins/emessage/images/icontab_duanxin.png')
GO
insert into OfIconList (name,url) values ('图标5','/plugins/emessage/images/icontab_email.png')
GO
insert into OfIconList (name,url) values ('图标6','/plugins/emessage/images/icontab_handledworkflow.png')
GO
insert into OfIconList (name,url) values ('图标7','/plugins/emessage/images/icontab_meetting.png')
GO
insert into OfIconList (name,url) values ('图标8','/plugins/emessage/images/icontab_message.png')
GO
insert into OfIconList (name,url) values ('图标9','/plugins/emessage/images/icontab_myrequest.png')
GO
insert into OfIconList (name,url) values ('图标10','/plugins/emessage/images/icontab_processedworkflow.png')
GO
insert into OfIconList (name,url) values ('图标11','/plugins/emessage/images/icontab_proj.png')
GO
insert into OfIconList (name,url) values ('图标12','/plugins/emessage/images/icontab_todolist.png')
GO
insert into OfIconList (name,url) values ('图标13','/plugins/emessage/images/icontab_xiezuo.png')
GO

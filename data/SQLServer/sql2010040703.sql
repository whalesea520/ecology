drop table HrmMessagerGroup
GO
CREATE TABLE HrmMessagerGroup (
	groupname int NOT NULL ,
	groupdesc  varchar(1000)  NOT NULL 
) 
GO

insert into HrmMessagerGroup (groupname,groupdesc) values(1,'all users')
GO

insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin)
select loginid,1,'N' from hrmresource where loginid!=''
GO

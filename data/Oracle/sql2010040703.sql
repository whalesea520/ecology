drop table HrmMessagerGroup
/
CREATE TABLE HrmMessagerGroup (
	groupname int NOT NULL ,
	groupdesc  varchar2(1000)  NOT NULL 
)
/

insert into HrmMessagerGroup (groupname,groupdesc) values(1,'all users')
/

insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin)
select loginid,1,'N' from hrmresource where loginid is not null
/

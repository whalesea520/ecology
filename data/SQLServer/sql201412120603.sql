ALTER TABLE LDAPSET add needSynPassword char(1)
GO
ALTER TABLE LDAPSET add keystorepath varchar(500)
GO
ALTER TABLE LDAPSET add keystorepassword varchar(100)
GO
ALTER TABLE LDAPSET add ldapserverurl2 varchar(500)
GO
ALTER TABLE LDAPSET add needSynOrg char(1)
GO
ALTER TABLE LDAPSET add needDismiss char(1)
GO
ALTER TABLE LDAPSET add needCloseDep char(1)
GO
ALTER TABLE LDAPSET add needSynPerson char(1)
GO
ALTER TABLE LDAPSET add passwordpolicy varchar(500)
GO
CREATE TABLE ldapsetdetail (
id int NOT NULL IDENTITY(1,1) ,
subcompanycode varchar(100) NULL ,
subcomusertodepcode varchar(100) NULL ,
subcompanydomain varchar(500) NULL 
)
GO
CREATE TABLE addepmap (
id int NOT NULL IDENTITY(1,1) ,
dep varchar(100) NULL ,
pguid varchar(200) NULL ,
distin varchar(200) NULL ,
subcomcode varchar(100) NULL ,
orgtype varchar(10) NULL ,
guid varchar(200) NULL 
)
GO
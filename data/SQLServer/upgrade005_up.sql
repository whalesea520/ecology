if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='versionNo') BEGIN print 'message:versionNo���Ѵ���' END
ELSE BEGIN alter table ecologyuplist add versionNo varchar(300) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='content') BEGIN print 'message:content���Ѵ���' END
ELSE BEGIN alter table ecologyuplist add content varchar(2000) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationDate') BEGIN print 'message:operationDate���Ѵ���' END
ELSE BEGIN alter table ecologyuplist add operationDate varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationTime') BEGIN print 'message:operationTime���Ѵ���' END
ELSE BEGIN alter table ecologyuplist add operationTime varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='configContent') BEGIN print 'message:configContent���Ѵ���' END
ELSE BEGIN alter table ecologyuplist add configContent varchar(2000) END
GO
insert into ecologyuplist(label,versionNo,content,configContent,operationDate,operationTime) values ('005','�Ϻ�Ⱥ�׷���SHQYFSecology20170220-005','1�������ͬ��ſ�������
','null', convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114))
GO
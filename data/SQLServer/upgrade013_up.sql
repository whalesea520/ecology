if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='versionNo') BEGIN print 'message:versionNo列已存在' END
ELSE BEGIN alter table ecologyuplist add versionNo varchar(300) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='content') BEGIN print 'message:content列已存在' END
ELSE BEGIN alter table ecologyuplist add content varchar(2000) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationDate') BEGIN print 'message:operationDate列已存在' END
ELSE BEGIN alter table ecologyuplist add operationDate varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationTime') BEGIN print 'message:operationTime列已存在' END
ELSE BEGIN alter table ecologyuplist add operationTime varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='configContent') BEGIN print 'message:configContent列已存在' END
ELSE BEGIN alter table ecologyuplist add configContent varchar(2000) END
GO
insert into ecologyuplist(label,versionNo,content,configContent,operationDate,operationTime) values ('013','上海群易服饰SHQYFSecology20181019-013','1、解决请假流程问题
','null', convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114))
GO
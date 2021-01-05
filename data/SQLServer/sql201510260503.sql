if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='versionNo') BEGIN print 'message:versionNo列已存在' END
ELSE BEGIN alter table ecologyuplist add versionNo varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='content') BEGIN print 'message:content列已存在' END
ELSE BEGIN alter table ecologyuplist add content varchar(2000) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationDate') BEGIN print 'message:operationDate列已存在' END
ELSE BEGIN alter table ecologyuplist add operationDate varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='operationTime') BEGIN print 'message:operationTime列已存在' END
ELSE BEGIN alter table ecologyuplist add operationTime varchar(100) END
if exists(select * from syscolumns  where id=object_id('ecologyuplist') and name='configContent') BEGIN print 'message:configContent列已存在' END
ELSE BEGIN alter table ecologyuplist add configContent varchar(2000) END
GO
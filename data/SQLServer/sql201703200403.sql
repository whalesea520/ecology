ALTER TABLE ldapset ADD ldapSyncMethod nvarchar(1) default '1'
GO
update ldapset set ldapSyncMethod = '3' where EXISTS(select 1 from ldapimporttime where usertime <> '0')
GO
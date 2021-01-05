ALTER TABLE ldapset ADD(ldapSyncMethod char default '1')
/
update ldapset set ldapSyncMethod = '3' where EXISTS(select 1 from ldapimporttime where usertime <> '0')
/
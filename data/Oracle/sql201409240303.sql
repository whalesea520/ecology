ALTER TABLE mode_customsearch ADD customsearchcode VARCHAR2(32)
/
update mode_customsearch set customsearchcode = sys_guid() where customsearchcode is null or customsearchcode=''
/
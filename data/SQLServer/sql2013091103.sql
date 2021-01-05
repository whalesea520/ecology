if not exists (select * from syscolumns where id=object_id('sysPhrase') and name='phraseMark')
begin 
	alter table sysPhrase add phraseMark varchar(4000)
end
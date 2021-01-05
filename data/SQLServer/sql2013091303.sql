if  exists (select * from syscolumns where id=object_id('sysPhrase') and name='phraseMark')
begin 
	alter table sysPhrase alter column phraseDesc varchar(4000)
end
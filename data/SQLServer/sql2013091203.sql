if  exists (select * from syscolumns where id=object_id('sysPhrase') and name='phraseMark')
begin 
	 DECLARE table_cursor CURSOR FOR   select id,phraseDesc from sysPhrase
	 DECLARE @ROWID int
	 DECLARE @PHRASEMARK varchar(4000)
	 OPEN table_cursor
	 FETCH NEXT FROM table_cursor into  @ROWID, @PHRASEMARK
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
           update sysPhrase set phraseMark = @PHRASEMARK where id = @ROWID
		 FETCH NEXT FROM table_cursor into  @ROWID, @PHRASEMARK
	  END
	  CLOSE table_cursor
	  DEALLOCATE table_cursor
end
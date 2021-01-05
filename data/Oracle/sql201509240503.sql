alter table moderightinfo add hrmCompanyVirtualType varchar2(400)
/
ALTER TABLE mode_searchPageshareinfo ADD hrmCompanyVirtualType INTEGER
/
ALTER TABLE mode_reportshareinfo ADD hrmCompanyVirtualType INTEGER
/

create or replace PROCEDURE mode_alert_p AS
	tableIndex  integer;
	tablename   varchar2(100);
	sqltext     varchar2(1000);
	existstable integer;
	existsisdefault integer;
	CURSOR tableindex_cur IS
    	select id from modeinfo;
BEGIN
	OPEN tableindex_cur;
	LOOP
    	FETCH tableindex_cur
      	INTO tableIndex;
    	EXIT WHEN tableindex_cur%NOTFOUND;
		
		tablename := 'modeDataShare_' || tableIndex ||'_set';
    	select count(*)
      	into existstable
      	from user_tables t
     	where lower(t.table_name) = lower(tablename);    	
    	
    	if existstable > 0 then		
			select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex||'_set' ) and upper(COLUMN_NAME) = upper('hrmCompanyVirtualType');
			if existsisdefault <= 0 then
				sqltext := 'alter table modeDataShare_'||tableIndex||'_set add hrmCompanyVirtualType INTEGER';
				EXECUTE IMMEDIATE (sqltext);
			end if;    
    	end if;
	END LOOP;
  	CLOSE tableindex_cur;
END;
/
begin
 mode_alert_p();
end;
/
drop PROCEDURE mode_alert_p
/
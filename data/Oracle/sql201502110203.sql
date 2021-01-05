create or replace PROCEDURE mode_alert_higherlevel AS
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
		tablename := 'modeDataShare_' || tableIndex;
    	select count(*)
      	into existstable
      	from user_tables t
     	where lower(t.table_name) = lower(tablename);    	
    	
    	if existstable > 0 then		
			select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex ) and upper(COLUMN_NAME) = upper('higherlevel');
			if existsisdefault <= 0 then
				sqltext := 'alter table modeDataShare_'||tableIndex||' add higherlevel int';
				EXECUTE IMMEDIATE (sqltext);
			end if;    
    	end if;
	END LOOP;
  	CLOSE tableindex_cur;
END;
/
begin
 mode_alert_higherlevel();
end;
/
drop PROCEDURE mode_alert_higherlevel
/
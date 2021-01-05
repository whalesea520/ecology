alter table moderightinfo add modifytime varchar2(30)
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
    tablename := 'modeDataShare_' || tableIndex;
      select count(*)
        into existstable
        from user_tables t
       where lower(t.table_name) = lower(tablename);
      
      if existstable > 0 then    
	      select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex ) and upper(COLUMN_NAME) = upper('setid');
	      if existsisdefault <= 0 then
	        sqltext := 'alter table modeDataShare_'||tableIndex||' add setid int';
	        EXECUTE IMMEDIATE (sqltext);
	      end if;    
	      select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex ) and upper(COLUMN_NAME) = upper('rightid');
	      if existsisdefault <= 0 then
	        sqltext := 'alter table modeDataShare_'||tableIndex||' add rightid int';
	        EXECUTE IMMEDIATE (sqltext);
	      end if;    
      end if;
    
    tablename := 'modeDataShare_' || tableIndex ||'_set';
      select count(*)
        into existstable
        from user_tables t
       where lower(t.table_name) = lower(tablename);      
      
      if existstable > 0 then    
	      select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex||'_set' ) and upper(COLUMN_NAME) = upper('rightid');
	      if existsisdefault <= 0 then
	        sqltext := 'alter table modeDataShare_'||tableIndex||'_set add rightid int';
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
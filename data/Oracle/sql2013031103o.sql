create or replace PROCEDURE mode_createviewlog_p AS
  tableIndex  integer;
  tablename   varchar2(100);
  sqltext     varchar2(1000);
  existstable integer;
  CURSOR tableindex_cur IS
    select id from modeinfo;
BEGIN
  OPEN tableindex_cur;
  LOOP
    FETCH tableindex_cur
      INTO tableIndex;
    EXIT WHEN tableindex_cur%NOTFOUND;
    tablename := 'ModeViewLog_' || tableIndex;
    select count(*)
      into existstable
      from user_tables t
     where lower(t.table_name) = lower(tablename);
     
	if existstable <= 0 then
		sqltext := 'CREATE TABLE ' || tablename || ' (
          id int primary key NOT NULL ,
          relatedid int NOT NULL ,
          relatedname varchar2(1000)  NOT NULL ,
          operatetype int  NOT NULL ,
          operatedesc varchar2(4000)  NULL ,
          operateuserid int NOT NULL ,
          operatedate char(10)  NOT NULL ,
          operatetime char(8)  NOT NULL ,
          clientaddress varchar2(30)  NULL
        )';
	EXECUTE IMMEDIATE (sqltext);
      
	sqltext := 'create sequence ' || tablename || '_id
		start with 1
		increment by 1
		nomaxvalue
		nocycle';
	EXECUTE IMMEDIATE (sqltext);

	sqltext := 'create or replace trigger ' || tablename || '_Tri
		before insert on ' || tablename || '
		for each row
		begin
		select ' || tablename || '_id.nextval into :new.id from dual;
		end;';
	EXECUTE IMMEDIATE (sqltext);
      
      sqltext := 'create index ' ||tablename|| '_operatetype on ' ||tablename|| ' (relatedid,operatetype,operateuserid)';
      EXECUTE IMMEDIATE (sqltext);
    end if;
  END LOOP;
  CLOSE tableindex_cur;
END;
/

declare
begin
	mode_createviewlog_p();
end;
/

drop PROCEDURE mode_createviewlog_p
/


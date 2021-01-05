declare v_cnt number;V_SQL VARCHAR2 (500) := '';
begin 
  select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'VERSIONNO';
if v_cnt != 0 THEN dbms_output.put_line('message:versionNo列已存在');else  V_SQL := 'alter table ecologyuplist add versionNo varchar(100)';
 EXECUTE IMMEDIATE V_SQL;end if;
 select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'CONTENT';
if v_cnt != 0 THEN dbms_output.put_line('message:content列已存在');else  V_SQL := 'alter table ecologyuplist add content varchar(2000)';
 EXECUTE IMMEDIATE V_SQL;end if;
 select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'OPERATIONDATE';
if v_cnt != 0 THEN dbms_output.put_line('message:operationDate列已存在');else  V_SQL := 'alter table ecologyuplist add operationDate varchar(100)';
 EXECUTE IMMEDIATE V_SQL;end if;
 select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'OPERATIONTIME';
if v_cnt != 0 THEN dbms_output.put_line('message:operationTime列已存在');else  V_SQL := 'alter table ecologyuplist add operationTime varchar(100)';
 EXECUTE IMMEDIATE V_SQL;end if;
 select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'OPERATIONTIME';
if v_cnt != 0 THEN dbms_output.put_line('message:operationTime列已存在');else  V_SQL := 'alter table ecologyuplist add operationTime varchar(100)';
 EXECUTE IMMEDIATE V_SQL;end if;
 select count(*) into v_cnt from  USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ecologyuplist') AND COLUMN_NAME = 'CONFIGCONTENT';
if v_cnt != 0 THEN dbms_output.put_line('message:configContent列已存在');else  V_SQL := 'alter table ecologyuplist add configContent varchar(2000)';
 EXECUTE IMMEDIATE V_SQL;end if;
end; 
/
insert into ecologyuplist(label,versionNo,content,configContent,operationDate,operationTime) values ('004','上海群易服饰SHQYFSecology20161226-004','1、解决设置头像相关问题
','null',to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'))
/
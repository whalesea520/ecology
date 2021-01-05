alter table modeinfo add DefaultShared char(1)
/
alter table modeinfo add NonDefaultShared char(1)
/

update modeinfo set DefaultShared = 0,NonDefaultShared=1
/

create or replace PROCEDURE mode_createshareset_p AS
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
    	
    	if existstable <= 0 then
			sqltext := 'CREATE TABLE ' || tablename || ' (
	          	id integer primary key NOT NULL ,
	          	sourceid integer NOT NULL ,
	          	righttype integer NULL ,
	          	sharetype integer NULL ,
	          	relatedid integer NULL ,
	          	rolelevel integer NULL ,
         	 	showlevel integer NULL ,
	          	isdefault integer NULL
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

			sqltext := 'create index ' ||tablename|| '_in on ' ||tablename|| ' (sourceid,righttype,sharetype)';
			EXECUTE IMMEDIATE (sqltext);
			
			select count(*) into existsisdefault from user_tab_columns where upper(table_name)=upper('modedatashare_'||tableIndex ) and upper(COLUMN_NAME) = upper('isdefault');
			if existsisdefault <= 0 then
				sqltext := 'alter table modeDataShare_'||tableIndex||' add isdefault integer';
				EXECUTE IMMEDIATE (sqltext);
				
				sqltext := 'update modeDataShare_'||tableIndex||' set isdefault = 1';
				EXECUTE IMMEDIATE (sqltext);
			end if;
			
			sqltext := 'insert into ' || tablename || '(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,srcfrom,0 content,0 rolelevel,seclevel,isDefault from modedatashare_'|| tableIndex ||' where srcfrom in (80,81,84,85) order by srcfrom asc';
			EXECUTE IMMEDIATE (sqltext);
			
			sqltext := 'insert into ' || tablename || '(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,content,0 rolelevel,seclevel,isDefault from modedatashare_'|| tableIndex ||' where srcfrom in (1,2,3) order by srcfrom asc';
			EXECUTE IMMEDIATE (sqltext);
			
			sqltext := 'insert into ' || tablename || '(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,substr(TO_CHAR(content),0,length(content)-1) content,min(substr(TO_CHAR(content),length(content),length(content))) rolelevel,seclevel,isDefault from modedatashare_'|| tableIndex ||' where srcfrom = 4 group by sourceid,type,seclevel,sharelevel,srcfrom,substr(TO_CHAR(content),0,length(content)-1),isDefault';
			EXECUTE IMMEDIATE (sqltext);
			
			sqltext := 'insert into ' || tablename || '(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,type,0 content,0 rolelevel,seclevel,isDefault from modedatashare_'|| tableIndex ||' where srcfrom = 5';
			EXECUTE IMMEDIATE (sqltext);
			
			sqltext := 'insert into ' || tablename || '(sourceid,righttype,sharetype,relatedid,rolelevel,showlevel,isdefault) select sourceid,sharelevel,srcfrom,opuser,0 rolelevel,seclevel,isDefault from modedatashare_'|| tableIndex ||' where srcfrom = 1000';
			EXECUTE IMMEDIATE (sqltext);
      
    	end if;
	END LOOP;
  	CLOSE tableindex_cur;
END;
/
declare
begin
	mode_createshareset_p();
end;
/
drop PROCEDURE mode_createshareset_p
/
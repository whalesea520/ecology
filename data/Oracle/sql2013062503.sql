create table departmentDefineField
(
  ID            INTEGER not null,
  BILLID        INTEGER,
  FIELDNAME     VARCHAR2(60),
  FIELDLABEL    INTEGER,
  FIELDDBTYPE   VARCHAR2(40),
  FIELDHTMLTYPE CHAR(1),
  TYPE          INTEGER,
  VIEWTYPE      INTEGER default 0,
  DETAILTABLE   VARCHAR2(50),
  FROMUSER      CHAR(1) default '1',
  TEXTHEIGHT    INTEGER,
  DSPORDER      NUMBER(15,2),
  CHILDFIELDID  INTEGER,
  IMGHEIGHT     INTEGER default (0),
  IMGWIDTH      INTEGER default (0),
  ISOPEN        CHAR(1)
)
/
CREATE sequence departmentDefineField_id
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER departmentDefineField_Tri
before INSERT ON departmentDefineField
FOR each ROW
BEGIN
SELECT departmentDefineField_id.NEXTVAL INTO :NEW.id FROM dual;
END;
/

create table subcompanyDefineField
(
  ID            INTEGER not null,
  BILLID        INTEGER,
  FIELDNAME     VARCHAR2(60),
  FIELDLABEL    INTEGER,
  FIELDDBTYPE   VARCHAR2(40),
  FIELDHTMLTYPE CHAR(1),
  TYPE          INTEGER,
  VIEWTYPE      INTEGER default 0,
  DETAILTABLE   VARCHAR2(50),
  FROMUSER      CHAR(1) default '1',
  TEXTHEIGHT    INTEGER,
  DSPORDER      NUMBER(15,2),
  CHILDFIELDID  INTEGER,
  IMGHEIGHT     INTEGER default (0),
  IMGWIDTH      INTEGER default (0),
  ISOPEN        CHAR(1)
)
/
CREATE sequence subcompanyDefineField_id
START WITH 1
INCREMENT BY 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER subcompanyDefineField_Tri
before INSERT ON subcompanyDefineField
FOR each ROW
BEGIN
SELECT subcompanyDefineField_id.NEXTVAL INTO :NEW.id FROM dual;
END;
/


ALTER TABLE workflow_groupdetail ADD deptField varchar2(200)
/

ALTER TABLE workflow_groupdetail ADD subcompanyField varchar2(200)
/

create or replace PROCEDURE create_HrmDepartment_field AS
  zzjgbmfzr_temp   integer;
  zzjgbmfgld_temp  integer;
  jzglbmfzr_temp   integer;
  jzglbmfgld_temp  integer;
  bmfzr_temp       integer;
  bmfgld_temp      integer;
  
  sqltext     varchar2(1000);
  rscount     integer;
  isOpen1      varchar2(2);
  isOpen2      varchar2(2);
  isOpen3      varchar2(2);
  isOpen4      varchar2(2);
  isOpen5      varchar2(2);
  isOpen6      varchar2(2);

BEGIN
  zzjgbmfzr_temp   := 0;
  zzjgbmfgld_temp  := 0;
  jzglbmfzr_temp   := 0;
  jzglbmfgld_temp  := 0;
  bmfzr_temp       := 0;
  bmfgld_temp      := 0;
  rscount          := 0;
  isOpen1           :='1';
  isOpen2           :='1';
  isOpen3           :='1';
  isOpen4           :='1';
  isOpen5           :='1';
  isOpen6           :='1';
                           
   select count(column_name) as a
     into bmfzr_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('bmfzr')
   order by column_id; 
   IF(bmfzr_temp  <1) THEN
     isOpen5           :='0';
     sqltext := 'alter table HRMDEPARTMENT add bmfzr varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);        
   END IF; 
   select count(1) into rscount from departmentDefineField where fieldname='bmfzr';
   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'bmfzr',
         26592,
         'varchar(4000)',
         3,
         17,
         -2,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen5
         );     
     commit;  
    END IF;    
                               

   select count(column_name) as a
     into bmfgld_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('bmfgld')
   order by column_id; 
   IF(bmfgld_temp  <1) THEN
     isOpen6           :='0';
     sqltext := 'alter table HRMDEPARTMENT add bmfgld varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);          
   END IF;  
   select count(1) into rscount from departmentDefineField where fieldname='bmfgld';
   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'bmfgld',
         28442,
         'varchar(4000)',
         3,
         17,
         -1,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen6
         );     
     commit;  
    END IF;     
  
   IF (bmfzr_temp<1 AND bmfgld_temp<1) then 
     isOpen1           :='0';
     isOpen2           :='0';
     isOpen3           :='0';
     isOpen4           :='0';
   END IF;   
                                             
   select count(column_name) as a
     into zzjgbmfzr_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('zzjgbmfzr')
   order by column_id; 
   IF(zzjgbmfzr_temp <1) THEN
     sqltext := 'alter table HRMDEPARTMENT add zzjgbmfzr varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);
   END IF; 
   select count(1) into rscount from departmentDefineField where fieldname='zzjgbmfzr';

   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'zzjgbmfzr',
         27107,
         'varchar(4000)',
         3,
         17,
         -6,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen1
         );     
     commit;  
    END IF;    
                                           


   select count(column_name) as a
     into zzjgbmfgld_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('zzjgbmfgld')
   order by column_id; 
   IF(zzjgbmfgld_temp  <1) THEN
     sqltext := 'alter table HRMDEPARTMENT add zzjgbmfgld varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);     

   END IF;
   select count(1) into rscount from departmentDefineField where fieldname='zzjgbmfgld';
   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'zzjgbmfgld',
         27108,
         'varchar(4000)',
         3,
         17,
         -5,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen2
         );     
     commit;  
    END IF;    
                             

   select count(column_name) as a
     into jzglbmfzr_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('jzglbmfzr')
   order by column_id; 
   IF(jzglbmfzr_temp  <1) THEN
     sqltext := 'alter table HRMDEPARTMENT add jzglbmfzr varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);     
   END IF;
   select count(1) into rscount from departmentDefineField where fieldname='jzglbmfzr';

   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'jzglbmfzr',
         27109,
         'varchar(4000)',
         3,
         17,
         -4,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen3
         );     
     commit;  
    END IF;    
                              

   select count(column_name) as a
     into jzglbmfgld_temp
     from user_tab_columns
   where table_name = upper('HRMDEPARTMENT')
     and  column_name=upper('jzglbmfgld')
   order by column_id; 
   IF(jzglbmfgld_temp  <1) THEN
     sqltext := 'alter table HRMDEPARTMENT add jzglbmfgld varchar(4000)';
     EXECUTE IMMEDIATE (sqltext);       
   END IF;
   select count(1) into rscount from departmentDefineField where fieldname='jzglbmfgld';

   IF(rscount <1) THEN

      INSERT INTO departmentDefineField
        (billid,
         fieldname,
         fieldlabel,
         fielddbtype,
         fieldhtmltype,
         type,
         dsporder,
         viewtype,
         detailtable,
         textheight,
         childfieldid,
         imgwidth,
         imgheight,
         isopen
         )
      VALUES
        (0,
         'jzglbmfgld',
         27110,
         'varchar(4000)',
         3,
         17,
         -3,
         0,
         '',
         0,
         0,
         0,
         0,
         isOpen4
         );     
     commit;  
    END IF;  
   
     

END;
/

declare
begin
	create_HrmDepartment_field();
end;
/
drop PROCEDURE create_HrmDepartment_field
/

create or replace procedure outter_encryptclassIni  
as
str1 varchar2(1000);
str2 varchar2(1000);
tempsysid varchar2(1000); 
tempid number;
begin    

DECLARE CURSOR  cur is  SELECT sysid,encryptclass,encryptmethod FROM outter_sys;
BEGIN
 open cur;
 LOOP
      FETCH cur INTO tempsysid,str1,str2;
       EXIT WHEN cur%NOTFOUND;
      
       if str1 is not null  then
     
         begin
  
          insert into outter_encryptclass(encryptclass,encryptmethod) values(str1,str2);
    commit;
        select max(id) into tempid from outter_encryptclass;
              update outter_sys set  encryptclass='',encryptmethod='',encryptclassId=tempid where sysid=tempsysid;
          commit;
        end;
 
     end if;

  END LOOP;
       CLOSE cur; 
END;
 END;
 /
 call  outter_encryptclassIni()
 /
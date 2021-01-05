declare 
      num   number; 
begin 
      select count(1) into num from user_tables where TABLE_NAME = 'SMSPROPERTIS'; 
      if   num>0   then 
          execute immediate 'ALTER TABLE smspropertis MODIFY val varchar2(1000)  '; 
      end   if; 
end;
/
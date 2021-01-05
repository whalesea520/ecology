declare
   v_num   int; 
begin
    select count(*) into v_num 
      from User_Tab_Columns where table_name='SYSPHRASE' and column_name='PHRASEMARK';
      if v_num =0  then 
         execute immediate 'alter table sysPhrase add PHRASEMARK  varchar(4000)';
     end if;   
end;
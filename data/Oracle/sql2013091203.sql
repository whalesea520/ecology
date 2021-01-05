declare
   v_num   int; 
   r_phrase sysPhrase%ROWTYPE;
   CURSOR c_phrase IS select * from sysPhrase;
begin
    select count(*) into v_num 
      from User_Tab_Columns where table_name='SYSPHRASE' and column_name='PHRASEMARK';
      if v_num > 0  then 
          OPEN c_phrase;
            LOOP
              FETCH c_phrase into r_phrase;
              EXIT WHEN c_phrase%NOTFOUND;
            execute immediate  'update sysPhrase set PHRASEMARK =:1 where id =:2 ' using  r_phrase.PHRASEDESC,r_phrase.id ;
            END LOOP;
           Close c_phrase;
     end if;  
     commit;
end;
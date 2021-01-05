create or replace trigger social_imAllWinDepart_trigger 
before insert on social_imAllowWinDepart
for each row 
begin 
  select social_imAllWinDepart_seq.nextval into:new.id from dual;
end;
/
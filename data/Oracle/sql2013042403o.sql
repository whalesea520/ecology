create or replace trigger trigge_GroupAndContact_Tri
before insert on GroupAndContact
for each row
begin
select GroupAndContact_id.nextval into :new.id from dual;
end;
/
create or replace trigger trigge_email_label_Tri
before insert on email_label
for each row
begin
select email_label_id.nextval into :new.id from dual;
end;
/
create or replace trigger trigge_email_label_detail_Tri
before insert on email_label_detail
for each row
begin
select email_label_detail_id.nextval into :new.id from dual;
end;
/
create or replace trigger trigge_emailGuide_Tri
before insert on emailGuide
for each row
begin
select emailGuide_id.nextval into :new.id from dual;
end;
/

create or replace trigger mode_barcode_id_Tri
before insert on mode_barcode
for each row
begin
select  mode_barcode_id.nextval into :new.id from dual;
end;
/

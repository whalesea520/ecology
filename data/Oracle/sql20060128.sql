CREATE OR REPLACE TRIGGER cus_fielddata_Trigger before insert on cus_fielddata for each row
begin select cus_fielddata_seqorder.nextval into :new.seqorder from dual; end;
/

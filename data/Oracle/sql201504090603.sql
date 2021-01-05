CREATE OR REPLACE TRIGGER wfec_idsetdetail_Trigger before 
INSERT ON wfec_indatasetdetail FOR EACH ROW
begin
select wfec_idsetdetail_sequence.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER wfec_indatawfset_Trigger before 
INSERT ON wfec_indatawfset FOR EACH ROW
begin
select wfec_indatawfset_sequence.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER wfec_odsetdetail_Trigger before 
INSERT ON wfec_outdatasetdetail FOR EACH ROW
begin
select wfec_odsetdetail_sequence.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER wfec_odws_Trigger before 
INSERT ON  wfec_outdatawfset FOR EACH ROW
begin
select wfec_odws_sequence.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER wfec_tablefield_Trigger before 
INSERT ON wfec_tablefield FOR EACH ROW
begin
select wfec_tablefield_sequence.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER wfec_tablelist_Trigger before 
INSERT ON wfec_tablelist FOR EACH ROW
begin
select wfec_tablelist_sequence.nextval into :new.id from dual;
end;
/

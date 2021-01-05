create table outerdatawfset(
  id integer,
  setname varchar2(100),
  workflowid integer,
  outermaintable varchar2(30),
  outermainwhere varchar2(500),
  successback varchar2(500),
  failback varchar2(500),
  outerdetailtables varchar2(2000),
  outerdetailwheres varchar2(2000)
)
/
create sequence outerdatawfset_Id start with 1 increment by 1 nomaxvalue nocycle
/
CREATE OR REPLACE TRIGGER outerdatawfset_Id_Trigger before insert on outerdatawfset for each row begin select outerdatawfset_Id.nextval into :new.id from dual; end;
/
create table outerdatawfsetdetail(
  id integer,
  mainid integer,
  wffieldid integer,
  wffieldname varchar2(30),
  wffieldhtmltype integer,
  wffieldtype integer,
  wffielddbtype varchar2(50),
  outerfieldname varchar2(50),
  changetype integer,
  iswriteback char(1)
)
/
create sequence outerdatawfsetD_Id start with 1 increment by 1 nomaxvalue nocycle
/
CREATE OR REPLACE TRIGGER outerdatawfsetD_Id_Trigger before insert on outerdatawfsetdetail for each row begin select outerdatawfsetD_Id.nextval into :new.id from dual; end;
/

create table outerdatawfperiodset(
  periodvalue integer
)
/

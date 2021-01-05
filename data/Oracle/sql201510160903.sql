ALTER TABLE fnaFeeWfInfo ADD isAllNodesControl integer NULL
/
update fnaFeeWfInfo set isAllNodesControl = 1
/
CREATE TABLE fnaFeeWfInfoNodeCtrl(
	id integer PRIMARY KEY NOT NULL,
	mainid integer NULL,
	nodeid integer NULL,
	checkway int NULL
)
/
create sequence seq_fnaFeeWfInfoNodeCtrl_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/
create index idx_fFWINodeCtrl_mainid on fnaFeeWfInfoNodeCtrl(mainid)
/


create or replace trigger fnaFeeWfInfoNodeCtrl_Trigger
before insert 
on fnaFeeWfInfoNodeCtrl
for each row 
begin 
	select seq_fnaFeeWfInfoNodeCtrl_ID.nextval into :new.id from dual; 
end;
/

CREATE TABLE bill_Discard ( 
    id integer PRIMARY KEY NOT NULL,
    resourceid integer,
    departmentid integer,
    requestid integer) 
/ 
create sequence bill_Discard_Id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
CREATE OR REPLACE TRIGGER bill_Discard_Id_Trigger
	before insert on bill_Discard
	for each row
	begin
	select bill_Discard_Id.nextval into :new.id from dual;
	end;
/
CREATE TABLE bill_Discard_Detail ( 
    id integer,
    capitalid integer,
    numbers integer,
    dates varchar(10),
    fee decimal(15,3),
    remark varchar(100),
    detailrequestid integer) 
/
CREATE OR REPLACE PROCEDURE bill_Discard_Detail_Insert 
    (detailrequestid_1 integer,
    capitalid_2 integer,
    numbers_3 integer,
    date_4 char,
    fee_5 float,
    remark_6 varchar2,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO bill_Discard_Detail
    (detailrequestid,
    capitalid,
    numbers,
    dates,
    fee,
    remark)
VALUES 
    (detailrequestid_1,
    capitalid_2,
    numbers_3,
    date_4,
    fee_5,
    remark_6);
end;
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(201,21541,'bill_Discard','AddBillCptDiscard.jsp','ManageBillCptDiscard.jsp','ViewBillCptDiscard.jsp','bill_Discard_Detail','','BillCptDiscardOperation.jsp') 
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'resourceid',368,'int',3,1,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'departmentid',18939,'int',3,4,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'capitalid',21545,'int',3,23,3,1,'bill_Discard_Detail')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'numbers',16816,'int',1,2,4,1,'bill_Discard_Detail')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'date',1392,'char(10)',3,2,5,1,'bill_Discard_Detail')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'fee',1393,'decimal(15,3)',1,3,6,1,'bill_Discard_Detail')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'remark',20820,'varchar(100)',1,1,7,1,'bill_Discard_Detail')
/

update workflow_billfield set fieldname='number_n' where id=326
/
update workflow_billfield set fieldname='number_n' where id=200
/

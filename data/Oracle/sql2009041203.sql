INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(220,6051,'bill_cptlend','','','','','','BillCptLendOperation.jsp') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendCpt',15304,'integer',3,23,0,0,'')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendPerson',368,'integer',3,1,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendDepartment',18939,'integer',3,4,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lenddate',22593,'char(10)',3,2,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'saveAddress',1387,'varchar2(200)',1,1,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'remark',20820,'varchar2(4000)',2,0,5,0,'')
/

 
CREATE TABLE bill_cptlend ( 
    id integer,
    lendCpt integer,
    lendPerson integer,
    lendDepartment integer,
    lenddate char(10),
    saveAddress varchar2(200),
    remark varchar2(4000),
    requestid integer) 
/

create sequence bill_cptlend_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_cptlend_Tri
before insert on bill_cptlend
for each row
begin
select bill_cptlend_id.nextval into :new.id from dual;
end;
/





INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(221,6054,'bill_cptloss','AddBillLossCpt.jsp','BillCptManageBody.jsp','','','','BillCptLossOperation.jsp') 
/

 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossCpt',535,'integer',3,23,0,0,'')
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'losscount',1331,'number(15,3)',1,3,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossPerson',179,'integer',3,1,4,0,'')
/
 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossDepartment',124,'integer',3,4,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossdate',1406,'char(10)',3,2,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossfee',1393,'number(15,3)',1,3,5,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'remark',20820,'varchar2(4000)',2,0,6,0,'')
/

 
CREATE TABLE bill_cptloss ( 
    id integer,
    lossCpt number(15,3),
    losscount integer,
    lossPerson integer,
    lossDepartment integer,
    lossdate char(10),
    lossfee number(15,3),
    remark varchar2(4000),
    requestid int) 
/

create sequence bill_cptloss_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_cptloss_Tri
before insert on bill_cptloss
for each row
begin
select bill_cptloss_id.nextval into :new.id from dual;
end;
/




INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(222,22459,'bill_mendCpt','','','','','','BillCptMendOperation.jsp') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'cptMend',15308,'integer',3,23,0,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendPerson',1047,'integer',3,1,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendDate',21062,'char(10)',3,2,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendLong',22457,'char(10)',3,2,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendCustomer',1399,'integer',3,7,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'remark',20820,'varchar2(4000)',2,0,5,0,'')
/
 
  
CREATE TABLE bill_mendCpt ( 
    id integer,
    cptMend integer,
    mendPerson integer,
    mendDate char(10),
    mendLong char(10),
    mendCustomer integer,
    remark varchar2(4000),
    requestid integer) 
/

create sequence bill_mendCpt_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_mendCpt_Tri
before insert on bill_mendCpt
for each row
begin
select bill_mendCpt_id.nextval into :new.id from dual;
end;
/


INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(224,15305,'bill_returncpt','','','','','','BillCptReturnOperation.jsp') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'returnCpt',535,'integer',3,23,0,0,'')
/
 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'returnDate',22674,'char(10)',3,2,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'remark',20820,'varchar2(4000)',2,0,3,0,'')
/

CREATE TABLE bill_returncpt ( 
    id integer,
    returnCpt integer,
    returnDate char(10),
    remark varchar2(4000),
    requestid integer) 
/
create sequence bill_returncpt_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_returncpt_Tri
before insert on bill_mendCpt
for each row
begin
select bill_returncpt_id.nextval into :new.id from dual;
end;
/
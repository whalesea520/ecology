CREATE TABLE bill_Discard ( 
    id int IDENTITY,
    resourceid int,
    departmentid int,
    requestid int) 
GO 
CREATE TABLE bill_Discard_Detail ( 
    id int IDENTITY,
    capitalid int,
    numbers int,
    dates char(10),
    fee decimal(15,3),
    remark varchar(100),
    detailrequestid int) 
GO 
CREATE PROCEDURE bill_Discard_Detail_Insert 
    (@detailrequestid_1 int,
    @capitalid_2 int,
    @numbers_3 int,
    @date_4 char(10),
    @fee_5 decimal(15,3),
    @remark_6 varchar(100),
    @flag int output,
    @msg varchar(80) output)
AS INSERT INTO bill_Discard_Detail
    (detailrequestid,
    capitalid,
    numbers,
    dates,
    fee,
    remark)
VALUES 
    (@detailrequestid_1,
    @capitalid_2,
    @numbers_3,
    @date_4,
    @fee_5,
    @remark_6)
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(201,21541,'bill_Discard','AddBillCptDiscard.jsp','ManageBillCptDiscard.jsp','ViewBillCptDiscard.jsp','bill_Discard_Detail','','BillCptDiscardOperation.jsp') 
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'resourceid',368,'int',3,1,1,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'departmentid',18939,'int',3,4,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'capitalid',21545,'int',3,23,3,1,'bill_Discard_Detail')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'numbers',16816,'int',1,2,4,1,'bill_Discard_Detail')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'date',1392,'char(10)',3,2,5,1,'bill_Discard_Detail')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'fee',1393,'decimal(15,3)',1,3,6,1,'bill_Discard_Detail')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (201,'remark',20820,'varchar(100)',1,1,7,1,'bill_Discard_Detail')
GO 

update workflow_billfield set fieldname='number_n' where id=326
GO
update workflow_billfield set fieldname='number_n' where id=200
GO

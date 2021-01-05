INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(220,6051,'bill_cptlend','','','','','','BillCptLendOperation.jsp') 
GO
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendCpt',15304,'int',3,23,0,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendPerson',368,'int',3,1,1,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lendDepartment',18939,'int',3,4,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'lenddate',22593,'char(10)',3,2,3,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'saveAddress',1387,'varchar(200)',1,1,4,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (220,'remark',20820,'text',2,0,5,0,'')
GO 

 
CREATE TABLE bill_cptlend ( 
    id int IDENTITY,
    lendCpt int,
    lendPerson int,
    lendDepartment int,
    lenddate char(10),
    saveAddress varchar(200),
    remark text,
    requestid int) 
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(221,6054,'bill_cptloss','AddBillLossCpt.jsp','BillCptManageBody.jsp','','','','BillCptLossOperation.jsp') 
GO

 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossCpt',535,'int',3,23,0,0,'')
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'losscount',1331,'decimal(15,1)',1,3,1,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossPerson',179,'int',3,1,4,0,'')
GO
 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossDepartment',124,'int',3,4,3,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossdate',1406,'char(10)',3,2,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'lossfee',1393,'decimal(15,3)',1,3,5,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (221,'remark',20820,'text',2,0,6,0,'')
GO 

 
CREATE TABLE bill_cptloss ( 
    id int IDENTITY,
    lossCpt int,
    losscount decimal(15,1),
    lossPerson int,
    lossDepartment int,
    lossdate char(10),
    lossfee decimal(15,3),
    remark text,
    requestid int) 
GO


INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(222,22459,'bill_mendCpt','','','','','','BillCptMendOperation.jsp') 
GO
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'cptMend',15308,'int',3,23,0,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendPerson',1047,'int',3,1,1,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendDate',21062,'char(10)',3,2,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendLong',22457,'char(10)',3,2,3,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'mendCustomer',1399,'int',3,7,4,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (222,'remark',20820,'text',2,0,5,0,'')
GO
 
  
CREATE TABLE bill_mendCpt ( 
    id int IDENTITY,
    cptMend int,
    mendPerson int,
    mendDate char(10),
    mendLong char(10),
    mendCustomer int,
    remark text,
    requestid int) 
GO




INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(224,15305,'bill_returncpt','','','','','','BillCptReturnOperation.jsp') 
GO
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'returnCpt',535,'int',3,23,0,0,'')
GO
 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'returnDate',22674,'char(10)',3,2,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (224,'remark',20820,'text',2,0,3,0,'')
GO 

CREATE TABLE bill_returncpt ( 
    id int IDENTITY,
    returnCpt int,
    returnDate char(10),
    remark text,
    requestid int) 
GO
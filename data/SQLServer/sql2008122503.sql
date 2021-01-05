alter table CarInfo add usefee decimal(10,2)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'usefee',21064,'decimal(10,2)',1,3,5.50,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'totalfee',2019,'decimal(10,2)',1,3,6.50,0,'')
GO
alter table CarUseApprove add usefee decimal(10,2)
GO
alter table CarUseApprove add totalfee decimal(10,2)
GO


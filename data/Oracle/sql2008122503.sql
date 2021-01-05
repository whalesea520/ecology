alter table CarInfo add usefee number(10,2)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'usefee',21064,'number(10,2)',1,3,5.50,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'totalfee',2019,'number(10,2)',1,3,6.50,0,'')
/
alter table CarUseApprove add usefee number(10,2)
/
alter table CarUseApprove add totalfee number(10,2)
/


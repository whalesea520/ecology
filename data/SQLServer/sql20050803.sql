ALTER TABLE bill_CptRequireMain ADD   manager int
go
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (15,'manager',144,'int',3,1,19,0)
go

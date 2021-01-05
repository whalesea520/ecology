delete from fnaVoucherObjInfo
go

ALTER TABLE fnaVoucherObjInfo ADD constraint un_fnaVoucherObjInfo01 UNIQUE (fnavoucherinittypestr, fielddbtbname, detailtable, fielddbname) 
go
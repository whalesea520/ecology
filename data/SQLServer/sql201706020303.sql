create table DocCheckInOut (
    id integer  IDENTITY(1,1) not null,
    docId integer null,
    checkOutStatus char(1) null,
    checkOutUserId integer null,
    checkOutUserType char(1) null,
    checkOutDate char(10) null,
    checkOutTime char(8) null
)  
go


create  INDEX DocCheckInOut_docId on DocCheckInOut(docId)
go
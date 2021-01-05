UPDATE outerdatawfdetail  SET outerdatawfdetail.OUTERMAINTABLE=(select outerdatawfset.OUTERMAINTABLE from outerdatawfset  WHERE outerdatawfset.ID=outerdatawfdetail.mainid)
go
DELETE FROM outerdatawfdetail  WHERE outerdatawfdetail.OUTERMAINTABLE IS NULL
go
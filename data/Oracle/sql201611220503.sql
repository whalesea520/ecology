UPDATE outerdatawfdetail odwfd SET odwfd.OUTERMAINTABLE=(select odwfs.OUTERMAINTABLE from outerdatawfset odwfs WHERE odwfs.ID=odwfd.mainid)
/
DELETE FROM outerdatawfdetail odwfd WHERE odwfd.OUTERMAINTABLE IS NULL
/
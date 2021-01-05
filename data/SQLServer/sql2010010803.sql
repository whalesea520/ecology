update hpfieldelement set fieldname=743 where elementid=10 and fieldcolumn='planendtime'
GO
delete from hpfieldelement where elementid=10 and fieldcolumn='planenddate'
GO
update hpfieldelement set fieldwidth=100 where elementid=10 and fieldColumn='planendtime'
GO

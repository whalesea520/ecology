alter table CptStockInDetail
add tempprice decimal(10,2)
GO
update CptStockInDetail
set tempprice=price
GO
alter table CptStockInDetail
drop column price
GO
alter table CptStockInDetail
add price decimal(15,2)
GO
update CptStockInDetail
set price=tempprice
GO
alter table CptStockInDetail
drop column tempprice
GO
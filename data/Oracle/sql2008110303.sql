alter table CptStockInDetail
add tempprice decimal(10,2)
/
update CptStockInDetail
set tempprice=price
/
alter table CptStockInDetail
drop column price
/
alter table CptStockInDetail
add price decimal(15,2)
/
update CptStockInDetail
set price=tempprice
/
alter table CptStockInDetail
drop column tempprice
/
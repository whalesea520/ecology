
alter table CptUseLog
add tempfee decimal(10,2)
/
update CptUseLog
set tempfee=fee
/
alter table CptUseLog
drop column fee
/
alter table CptUseLog
add fee decimal(15,2)
/
update CptUseLog
set fee=tempfee
/
alter table CptUseLog
drop column tempfee
/
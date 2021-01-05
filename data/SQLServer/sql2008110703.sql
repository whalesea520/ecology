
alter table CptUseLog
add tempfee decimal(10,2)
GO
update CptUseLog
set tempfee=fee
GO
alter table CptUseLog
drop column fee
GO
alter table CptUseLog
add fee decimal(15,2)
GO
update CptUseLog
set fee=tempfee
GO
alter table CptUseLog
drop column tempfee
GO
alter table workflow_bill add invalid int
go
update workflow_bill set invalid=1 where id in(50,66,67,68,6,22,23,29,161,162)
go
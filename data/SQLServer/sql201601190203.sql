alter table bill_Discard_Detail add mainid int
go
update workflow_bill set detailkeyfield='mainid' where id=201
go
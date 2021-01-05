alter table MailResource add isTemp char(1)
go
update MailResource set isTemp='0'
go
update SequenceIndex set currentid=(select isnull(max(mailgroupid),0)+1 FROM mailusergroup) where indexdesc='mailusergroup'
go
update SequenceIndex set currentid=(select isnull(max(id),0)+1 FROM mailuseraddress) where indexdesc='mailuseraddress'
go
update SequenceIndex set currentid=(select isnull(max(id),0)+1 FROM mailinboxfolder) where indexdesc='mailinboxfolder'
go

alter table MailResource add isTemp char(1)
/
update MailResource set isTemp='0'
/
update SequenceIndex set currentid=(select nvl(max(mailgroupid),0)+1 FROM mailusergroup) where indexdesc='mailusergroup'
/
update SequenceIndex set currentid=(select nvl(max(id),0)+1 FROM mailuseraddress) where indexdesc='mailuseraddress'
/
update SequenceIndex set currentid=(select nvl(max(id),0)+1 FROM mailinboxfolder) where indexdesc='mailinboxfolder'
/

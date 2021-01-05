delete  from MailUserAddress t where t.rowid > (select min(p.rowid) from MailUserAddress p where t.mailaddress =p.mailaddress and t.userid = p.userid)
/

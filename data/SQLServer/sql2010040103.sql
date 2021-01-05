delete   MailUserAddress   from   MailUserAddress   t   inner   join(select   mailaddress,userid,max(id)   as   id   from   MailUserAddress   group   by   mailaddress,userid)   a   
  on   t.mailaddress   =   a.mailaddress  and t.userId = a.userid and   t.id   <>   a.id
GO

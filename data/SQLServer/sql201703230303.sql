update outerdatawfset
   set CreateDate = convert(varchar(100),getdate(),23),
       createtime = convert(varchar(100),getdate(),24),
       modifydate = convert(varchar(100),getdate(),23),
       modifytime = convert(varchar(100),getdate(),24)
 where CreateDate is null
    or CreateDate = ''
GO
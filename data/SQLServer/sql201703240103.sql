alter table outerdatawfsetdetail add CreateDate varchar(10)
GO
alter table outerdatawfsetdetail add CreateTime varchar(10)
GO
alter table outerdatawfsetdetail add ModifyDate varchar(10)
GO
alter table outerdatawfsetdetail add ModifyTime varchar(10)
GO

update outerdatawfsetdetail
   set CreateDate = convert(varchar(100),getdate(),23),
       createtime = convert(varchar(100),getdate(),24),
       modifydate = convert(varchar(100),getdate(),23),
       modifytime = convert(varchar(100),getdate(),24)
 where CreateDate is null
    or CreateDate = ''
GO
alter table menucustom add  sharetype varchar(1)
GO
update menucustom set sharetype ='5'
GO
alter table menucustom add  sharevalue varchar(200)
GO
update menucustom set sharevalue ='1'
GO

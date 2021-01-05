alter table workflow_bill
add formdes varchar(500) null,subcompanyid int null
GO

alter table workflow_billfield
add textheight int null
GO

delete from MainMenuInfo where id=423
GO

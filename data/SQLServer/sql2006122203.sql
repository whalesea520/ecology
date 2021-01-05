create procedure MailResourceContentUpdate(
@mailid int,
@content text,
@flag int output, 
@msg varchar(80) output
)
as
update MailResource set hasHtmlImage='1',content=@content where id=@mailid
go
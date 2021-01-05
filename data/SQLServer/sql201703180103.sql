alter table social_IMsessionkey add socketstatus int
go
update social_IMsessionkey set socketstatus = 0
go
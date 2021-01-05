create table worktask_wtuserdefault(
	id int IDENTITY,
	userid int,
	perpage int
)
go

insert into worktask_wtuserdefault(userid, perpage)
values(1, 20)
go

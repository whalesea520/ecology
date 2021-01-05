alter table worktask_requestbase add liablepersonnew varchar(4000)
GO
update worktask_requestbase set liablepersonnew=liableperson
GO
alter table worktask_requestbase drop column liableperson
GO
alter table worktask_requestbase add liableperson varchar(4000)
GO
update worktask_requestbase set liableperson=liablepersonnew
GO
alter table worktask_requestbase drop column liablepersonnew
GO

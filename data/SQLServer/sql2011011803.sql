alter table cowork_items add  principal int
GO
update cowork_items set principal=creater
GO

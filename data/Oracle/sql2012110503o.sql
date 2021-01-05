alter table cowork_items add remark_temp clob
GO
update cowork_items set remark_temp=remark
GO
ALTER TABLE cowork_items RENAME COLUMN remark TO remark_bak
GO
ALTER TABLE cowork_items RENAME COLUMN remark_temp TO remark
GO
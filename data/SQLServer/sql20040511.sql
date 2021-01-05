/*原来的日志没有区分内/外部用户，因此增加两个type字段:创建者类型、操作者类型。BUG 380 ,Created BY wangjingyong*/
alter table DocDetailLog add usertype char(1)
go
alter table DocDetailLog add creatertype char(1)
go
UPDATE DocDetailLog SET usertype = '1', creatertype = '1'
GO

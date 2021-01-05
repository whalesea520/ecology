alter table workflow_bill add hasFileUp char(1)
GO
/*执行以上脚本外，美的项目还需执行以下脚本*/
update workflow_bill set hasFileUp='1' where id>=121 and id<=143
GO
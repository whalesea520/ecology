alter table workflow_monitor_bound add isintervenor char(1)
GO

alter  PROCEDURE workflow_groupdetail_Insert (@groupid_1 	int, @type_2 	int, @objid_3 	int, @level_4 	int, @level2_5 	int,@conditions varchar(1000),@conditioncn varchar(1000),@orders varchar(5) ,@signorder char(1), @flag integer output , @msg varchar(80) output ) AS INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n, level2_n,conditions,conditioncn,orders,signorder)  VALUES ( @groupid_1, @type_2, @objid_3, @level_4, @level2_5,@conditions,@conditioncn,@orders,@signorder) select max(id) from workflow_groupdetail set @flag = 0 set @msg = 'ok' 
go

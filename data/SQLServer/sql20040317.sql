alter table workflow_groupdetail add level2_n int
go
alter PROCEDURE workflow_groupdetail_Insert (@groupid_1 	int, @type_2 	int, @objid_3 	int, @level_4 	int, @level2_5 	int, @flag integer output , @msg varchar(80) output ) AS INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n, level2_n)  VALUES ( @groupid_1, @type_2, @objid_3, @level_4, @level2_5) set @flag = 0 set @msg = '????????' 
GO
select * into hrm_transfer_log_bak from hrm_transfer_log
GO
alter table hrm_transfer_log_bak alter column id varchar(1000) 
GO
EXEC sp_rename 'hrm_transfer_log', 'hrm_transfer_log_backup' 
GO
EXEC sp_rename 'hrm_transfer_log_bak', 'hrm_transfer_log' 
GO
select * into hrm_transfer_log_detail_bak from hrm_transfer_log_detail
GO
alter table hrm_transfer_log_detail_bak alter column log_id varchar(1000) 
GO
EXEC sp_rename 'hrm_transfer_log_detail', 'hrm_transfer_log_detail_backup' 
GO
EXEC sp_rename 'hrm_transfer_log_detail_bak', 'hrm_transfer_log_detail' 
GO
CREATE TABLE multilang_permission_list(
	id int IDENTITY(1,1) NOT NULL,
	userid int,
	wbList int
)
GO
alter table SystemSet add wbList int
GO
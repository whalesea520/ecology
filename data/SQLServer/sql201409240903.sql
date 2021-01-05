create table hrm_chart_set(
	id int identity(1,1) NOT NULL primary key,
	is_sys int NOT NULL default 0,
	author int NOT NULL default 0,
	show_type int NOT NULL default 0,
	show_num int NOT NULL default 0
)
GO
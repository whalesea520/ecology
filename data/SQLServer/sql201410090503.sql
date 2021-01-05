create table hrm_transfer_log(
	id bigint NOT NULL primary key,
	type varchar(50) NOT NULL,
	fromid varchar(50) NOT NULL,
	toid varchar(1000) NOT NULL,
	p_type int NOT NULL,
	p_begin_date datetime NOT NULL,
	p_finish_date datetime,
	p_member int NOT NULL,
	p_ip varchar(50),
	p_status int NOT NULL,
	is_read int NOT NULL,
	read_date datetime,
	p_time int NOT NULL,
	all_num int NOT NULL
)
GO
create table hrm_transfer_log_detail(
	id int identity(1,1) NOT NULL primary key,
	log_id bigint NOT NULL,
	code_name varchar(50) NOT NULL,
	p_num int NOT NULL,
	is_all int NOT NULL,
	id_str varchar(4000),
	p_time int NOT NULL
)
GO
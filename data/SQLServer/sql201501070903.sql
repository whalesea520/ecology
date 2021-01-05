create table hrm_user_status ( 
	id int identity(1,1) not null PRIMARY KEY,
	user_id int not null,
	online_flag int not null
)
GO
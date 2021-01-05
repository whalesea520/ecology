create table hrm_usb_auto_date ( 
	id bigint identity(1,1) not null PRIMARY KEY,
	user_id bigint not null,
	need_auto int not null,
	enable_date varchar(50) null,
	enable_usb_type int not null,
	delflag int not null
)
GO
ALTER table meeting add ck_begindate VARCHAR(10)
GO
ALTER table meeting add ck_begintime VARCHAR(8)
go
ALTER table meeting add ck_enddate VARCHAR(10)
GO
ALTER table meeting add ck_endtime VARCHAR(8)
go
ALTER table meeting add ck_address int
GO
ALTER table meeting add ck_hrmmembers text
go
ALTER table meeting add ck_crmmembers text
GO
ALTER table meeting add ck_isck varchar(5)
go
ALTER table meeting add ck_time varchar(20)
go
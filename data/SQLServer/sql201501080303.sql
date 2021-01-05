alter table HrmSubCompany add limitUsers int default 0
GO
update HrmSubCompany set limitUsers = 0
GO
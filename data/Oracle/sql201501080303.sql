alter table HrmSubCompany add limitUsers number default 0
/
update HrmSubCompany set limitUsers = 0
/
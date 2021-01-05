alter table DocSecCategory add maxOfficeDocFileSize integer  default 8
/
update DocSecCategory set  maxOfficeDocFileSize=8
/
alter table DocSecCategoryTemplate add maxOfficeDocFileSize integer  default 8
/
update DocSecCategoryTemplate set  maxOfficeDocFileSize=8
/
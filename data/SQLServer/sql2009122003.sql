alter table DocSecCategory add maxOfficeDocFileSize int  default 8
GO
update DocSecCategory set  maxOfficeDocFileSize=8
GO
alter table DocSecCategoryTemplate add maxOfficeDocFileSize int  default 8
GO
update DocSecCategoryTemplate set  maxOfficeDocFileSize=8
GO
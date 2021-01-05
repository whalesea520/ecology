create table mode_excelField(
    id int IDENTITY(1,1) NOT NULL,
    modeid int,
    formid int,
    note varchar(2000)
)
GO
create table mode_excelFieldDetail(
    id int IDENTITY(1,1) NOT NULL,
    mainid int,
    fieldid text,
    selectids varchar(1000),
    selectvalue int
)
GO
alter table mode_DataBatchImport add validateid int
GO



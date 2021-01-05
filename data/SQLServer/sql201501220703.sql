alter table moderightinfo add isrolelimited int
GO
alter table moderightinfo add rolefieldtype int
GO
alter table moderightinfo add rolefield int
GO
update moderightinfo set isrolelimited=0
GO
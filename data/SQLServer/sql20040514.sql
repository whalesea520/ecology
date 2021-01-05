insert into HtmlNoteIndex (id,indexdesc) values (55,'结束时间必须大于开始时间！') 
GO

insert into HtmlNoteInfo (indexid,notename,languageid) values (55, '结束时间必须大于开始时间！', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (55, 'The end time must later than the start time!', 8) 
GO
insert into HtmlNoteIndex (id,indexdesc) values (54,'结束日期必须大于开始日期！') 
go

insert into HtmlNoteInfo (indexid,notename,languageid) values (54, '结束日期必须大于开始日期！', 7) 
go
insert into HtmlNoteInfo (indexid,notename,languageid) values (54, 'The end date must later than the start date!', 8) 
go
ALTER TABLE HrmResource ADD countryid int DEFAULT 1
GO

UPDATE HrmResource SET countryid = 1
go
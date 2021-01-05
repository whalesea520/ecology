insert into HtmlNoteIndex (id,indexdesc) values (55,'结束时间必须大于开始时间！') 
/

insert into HtmlNoteInfo (indexid,notename,languageid) values (55, '结束时间必须大于开始时间！', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (55, 'The end time must later than the start time!', 8) 
/
insert into HtmlNoteIndex (id,indexdesc) values (54,'结束日期必须大于开始日期！') 
/

insert into HtmlNoteInfo (indexid,notename,languageid) values (54, '结束日期必须大于开始日期！', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (54, 'The end date must later than the start date!', 8) 
/
ALTER TABLE HrmResource ADD countryid integer DEFAULT 1
/

UPDATE HrmResource SET countryid = 1
/
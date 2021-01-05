alter table modehtmllayout add version int default 0
GO
update modehtmllayout set version=0
GO
alter table modehtmllayout add operuser int
GO
alter table modehtmllayout add opertime varchar(50)
GO
alter table modehtmllayout add datajson text
GO
alter table modehtmllayout add pluginjson text
GO
alter table modehtmllayout add scripts text
GO
alter table modeformgroup add isprintserial char(1)
GO
alter table modeformgroup add allowscroll char(1)
GO
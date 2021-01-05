alter table modehtmllayout add version int default 0
/
update modehtmllayout set version=0
/
alter table modehtmllayout add operuser int
/
alter table modehtmllayout add opertime varchar(50)
/
alter table modehtmllayout add datajson clob
/
alter table modehtmllayout add pluginjson clob
/
alter table modehtmllayout add scripts clob
/
alter table modeformgroup add isprintserial char(1)
/
alter table modeformgroup add allowscroll char(1)
/
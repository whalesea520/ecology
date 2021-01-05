alter table pagelayout add layouttable  varchar2(4000)
/
alter table pagelayout add cellmergeinfo varchar2(4000)
/
alter table pagelayout add layoutimage varchar2(500)
/
alter table pagelayout add allowArea varchar2(100)
/
alter table pagelayout add ftl  varchar2(200)
/
alter table pagelayout add layoutcode varchar2(2000)
/
alter table hpinfo add pid int
/
alter table hpinfo add ordernum1 int
/

update pagelayout set  layoutimage='\images\homepage\layout\layout_01.png' where id=1
/
update pagelayout set  layoutimage='\images\homepage\layout\layout_02.png' where id=2
/
update pagelayout set  layoutimage='\images\homepage\layout\layout_03.png' where id=3
/
update pagelayout set  layoutimage='\images\homepage\layout\layout_04.png' where id=4
/
update pagelayout set  layoutimage='\images\homepage\layout\layout_05.png' where id=5
/

alter table pagelayout add layouttable  varchar(8000),cellmergeinfo varchar(8000)
GO
alter table pagelayout add layoutimage varchar(500),allowArea varchar(100),ftl  varchar(200)
GO
alter table pagelayout add layoutcode varchar(2000)
GO
alter table hpinfo add pid int,ordernum1 int
GO

update pagelayout set  layoutimage='\images\homepage\layout\layout_01.png' where id=1
GO
update pagelayout set  layoutimage='\images\homepage\layout\layout_02.png' where id=2
GO
update pagelayout set  layoutimage='\images\homepage\layout\layout_03.png' where id=3
GO
update pagelayout set  layoutimage='\images\homepage\layout\layout_04.png' where id=4
GO
update pagelayout set  layoutimage='\images\homepage\layout\layout_05.png' where id=5
GO

delete mainmenuconfig where infoid in (select id  from mainmenuinfo where parentid=624)
GO
delete  mainmenuinfo where parentid=624
GO
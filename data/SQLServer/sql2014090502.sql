delete from SystemRightDetail where id=42853
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42853,'文档主目录查看','DocMainCategory:All',1) 
GO

delete from SystemRightDetail where id=42857
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42857,'文档模板查看','DocMould:all',10) 
GO

delete from SystemRightDetail where id=42859
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42859,'文档新闻页设置查看','DocFrontpage:all',11) 
GO

delete from SystemRightDetail where id=3144
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3144,'期刊设置维护','WebMagazine:Main',453) 
GO

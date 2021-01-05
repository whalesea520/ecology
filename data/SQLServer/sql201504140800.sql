delete from SystemRightDetail where rightid =1841
GO
delete from SystemRightsLanguage where id =1841
GO
delete from SystemRights where id =1841
GO
insert into SystemRights (id,rightdesc,righttype) values (1841,'资产浏览框查询定义','4') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,8,'CapitalBrowser Def','CapitalBrowser Def') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,7,'资产浏览框查询定义','资产浏览框查询定义') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,9,'資產瀏覽框查詢定義','資產瀏覽框查詢定義') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41841,'资产浏览框查询定义','CptMaint:CptBrowDef',1841) 
GO
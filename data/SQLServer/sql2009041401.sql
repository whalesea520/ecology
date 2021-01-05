delete from HtmlLabelIndex where id=22755 
GO
delete from HtmlLabelInfo where indexid=22755 
GO
INSERT INTO HtmlLabelIndex values(22755,'选择框字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(22755,'选择框字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22755,'Selection Box Field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22755,'選擇框欄位',9) 
GO
delete from HtmlLabelIndex where id=22215 
GO
delete from HtmlLabelInfo where indexid=22215 
GO
INSERT INTO HtmlLabelIndex values(22215,'选择框字段单独流水') 
GO
INSERT INTO HtmlLabelInfo VALUES(22215,'选择框字段单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22215,'Selection Box Field Sequence Alone',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22215,'選擇框欄位單獨流水',9) 
GO
delete from HtmlLabelIndex where id=22756 
GO
delete from HtmlLabelInfo where indexid=22756 
GO
INSERT INTO HtmlLabelIndex values(22756,'机构单独流水') 
GO
INSERT INTO HtmlLabelInfo VALUES(22756,'机构单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22756,'Structure Sequence Alone',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22756,'機構單獨流水',9) 
GO
delete from HtmlLabelIndex where id=22764 
GO
delete from HtmlLabelInfo where indexid=22764 
GO
INSERT INTO HtmlLabelIndex values(22764,'机构代字') 
GO
INSERT INTO HtmlLabelInfo VALUES(22764,'机构代字',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22764,'Stru Abbr',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22764,'機構代字',9) 
GO

delete from HtmlLabelIndex where id=22779 
GO
delete from HtmlLabelInfo where indexid=22779 
GO
INSERT INTO HtmlLabelIndex values(22779,'预留编号') 
GO
delete from HtmlLabelIndex where id=22781 
GO
delete from HtmlLabelInfo where indexid=22781 
GO
INSERT INTO HtmlLabelIndex values(22781,'当前编号') 
GO
delete from HtmlLabelIndex where id=22783 
GO
delete from HtmlLabelInfo where indexid=22783 
GO
INSERT INTO HtmlLabelIndex values(22783,'新建预留号') 
GO
delete from HtmlLabelIndex where id=22780 
GO
delete from HtmlLabelInfo where indexid=22780 
GO
INSERT INTO HtmlLabelIndex values(22780,'选择框字段值') 
GO
delete from HtmlLabelIndex where id=22782 
GO
delete from HtmlLabelInfo where indexid=22782 
GO
INSERT INTO HtmlLabelIndex values(22782,'查看预留号') 
GO
delete from HtmlLabelIndex where id=22784 
GO
delete from HtmlLabelInfo where indexid=22784 
GO
INSERT INTO HtmlLabelIndex values(22784,'重新生成编号') 
GO
delete from HtmlLabelIndex where id=22785 
GO
delete from HtmlLabelInfo where indexid=22785 
GO
INSERT INTO HtmlLabelIndex values(22785,'选择预留号') 
GO
INSERT INTO HtmlLabelInfo VALUES(22779,'预留编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22779,'Reserved Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22779,'預留編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22780,'选择框字段值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22780,'Selection Box Field Value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22780,'選擇框欄位值',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22781,'当前编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22781,'Current Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22781,'當前編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22782,'查看预留号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22782,'View Reserved Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22782,'查看預留號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22783,'新建预留号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22783,'New Reserved Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22783,'新建預留號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22784,'重新生成编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22784,'Create Code Again',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22784,'重新生成編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22785,'选择预留号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22785,'Choose Reserved Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22785,'選擇預留號',9) 
GO

delete from HtmlLabelIndex where id=22787 
GO
delete from HtmlLabelInfo where indexid=22787 
GO
INSERT INTO HtmlLabelIndex values(22787,'创建人上级分部') 
GO
delete from HtmlLabelIndex where id=22788 
GO
delete from HtmlLabelInfo where indexid=22788 
GO
INSERT INTO HtmlLabelIndex values(22788,'创建人分部') 
GO
INSERT INTO HtmlLabelInfo VALUES(22787,'创建人上级分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22787,'Creator SupSubcompany',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22787,'創建人上級分部',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22788,'创建人分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22788,'Creator Subcompany',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22788,'創建人分部',9) 
GO

delete from HtmlLabelIndex where id=22793 
GO
delete from HtmlLabelInfo where indexid=22793 
GO
INSERT INTO HtmlLabelIndex values(22793,'当前年份') 
GO
delete from HtmlLabelIndex where id=22794 
GO
delete from HtmlLabelInfo where indexid=22794 
GO
INSERT INTO HtmlLabelIndex values(22794,'当前月份') 
GO
INSERT INTO HtmlLabelInfo VALUES(22793,'当前年份',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22793,'Current Year',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22793,'當前年份',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22794,'当前月份',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22794,'Current Month',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22794,'當前月份',9) 
GO

delete from SystemRightDetail where rightid=831
GO
delete from SystemRightsLanguage where id=831
GO
delete from SystemRights where id=831
GO
insert into SystemRights (id,rightdesc,righttype) values (831,'机构代字维护','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,9,'機構代字維護','機構代字維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,7,'机构代字维护','机构代字维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,8,'Stru Abbr Maintenance','Stru Abbr Maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4346,'机构代字维护','StruAbbr:Maintenance',831) 
GO



delete from HtmlLabelIndex where id=22755 
/
delete from HtmlLabelInfo where indexid=22755 
/
INSERT INTO HtmlLabelIndex values(22755,'选择框字段') 
/
INSERT INTO HtmlLabelInfo VALUES(22755,'选择框字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22755,'Selection Box Field',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22755,'選擇框欄位',9) 
/
delete from HtmlLabelIndex where id=22215 
/
delete from HtmlLabelInfo where indexid=22215 
/
INSERT INTO HtmlLabelIndex values(22215,'选择框字段单独流水') 
/
INSERT INTO HtmlLabelInfo VALUES(22215,'选择框字段单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22215,'Selection Box Field Sequence Alone',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22215,'選擇框欄位單獨流水',9) 
/
delete from HtmlLabelIndex where id=22756 
/
delete from HtmlLabelInfo where indexid=22756 
/
INSERT INTO HtmlLabelIndex values(22756,'机构单独流水') 
/
INSERT INTO HtmlLabelInfo VALUES(22756,'机构单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22756,'Structure Sequence Alone',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22756,'機構單獨流水',9) 
/
delete from HtmlLabelIndex where id=22764 
/
delete from HtmlLabelInfo where indexid=22764 
/
INSERT INTO HtmlLabelIndex values(22764,'机构代字') 
/
INSERT INTO HtmlLabelInfo VALUES(22764,'机构代字',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22764,'Stru Abbr',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22764,'機構代字',9) 
/

delete from HtmlLabelIndex where id=22779 
/
delete from HtmlLabelInfo where indexid=22779 
/
INSERT INTO HtmlLabelIndex values(22779,'预留编号') 
/
delete from HtmlLabelIndex where id=22781 
/
delete from HtmlLabelInfo where indexid=22781 
/
INSERT INTO HtmlLabelIndex values(22781,'当前编号') 
/
delete from HtmlLabelIndex where id=22783 
/
delete from HtmlLabelInfo where indexid=22783 
/
INSERT INTO HtmlLabelIndex values(22783,'新建预留号') 
/
delete from HtmlLabelIndex where id=22780 
/
delete from HtmlLabelInfo where indexid=22780 
/
INSERT INTO HtmlLabelIndex values(22780,'选择框字段值') 
/
delete from HtmlLabelIndex where id=22782 
/
delete from HtmlLabelInfo where indexid=22782 
/
INSERT INTO HtmlLabelIndex values(22782,'查看预留号') 
/
delete from HtmlLabelIndex where id=22784 
/
delete from HtmlLabelInfo where indexid=22784 
/
INSERT INTO HtmlLabelIndex values(22784,'重新生成编号') 
/
delete from HtmlLabelIndex where id=22785 
/
delete from HtmlLabelInfo where indexid=22785 
/
INSERT INTO HtmlLabelIndex values(22785,'选择预留号') 
/
INSERT INTO HtmlLabelInfo VALUES(22779,'预留编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22779,'Reserved Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22779,'預留編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22780,'选择框字段值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22780,'Selection Box Field Value',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22780,'選擇框欄位值',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22781,'当前编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22781,'Current Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22781,'當前編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22782,'查看预留号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22782,'View Reserved Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22782,'查看預留號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22783,'新建预留号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22783,'New Reserved Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22783,'新建預留號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22784,'重新生成编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22784,'Create Code Again',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22784,'重新生成編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22785,'选择预留号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22785,'Choose Reserved Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22785,'選擇預留號',9) 
/

delete from HtmlLabelIndex where id=22787 
/
delete from HtmlLabelInfo where indexid=22787 
/
INSERT INTO HtmlLabelIndex values(22787,'创建人上级分部') 
/
delete from HtmlLabelIndex where id=22788 
/
delete from HtmlLabelInfo where indexid=22788 
/
INSERT INTO HtmlLabelIndex values(22788,'创建人分部') 
/
INSERT INTO HtmlLabelInfo VALUES(22787,'创建人上级分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22787,'Creator SupSubcompany',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22787,'創建人上級分部',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22788,'创建人分部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22788,'Creator Subcompany',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22788,'創建人分部',9) 
/


delete from HtmlLabelIndex where id=22793 
/
delete from HtmlLabelInfo where indexid=22793 
/
INSERT INTO HtmlLabelIndex values(22793,'当前年份') 
/
delete from HtmlLabelIndex where id=22794 
/
delete from HtmlLabelInfo where indexid=22794 
/
INSERT INTO HtmlLabelIndex values(22794,'当前月份') 
/
INSERT INTO HtmlLabelInfo VALUES(22793,'当前年份',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22793,'Current Year',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22793,'當前年份',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22794,'当前月份',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22794,'Current Month',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22794,'當前月份',9) 
/


delete from SystemRightDetail where rightid=831
/
delete from SystemRightsLanguage where id=831
/
delete from SystemRights where id=831
/
insert into SystemRights (id,rightdesc,righttype) values (831,'机构代字维护','5') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,9,'機構代字維護','機構代字維護') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,7,'机构代字维护','机构代字维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (831,8,'Stru Abbr Maintenance','Stru Abbr Maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4346,'机构代字维护','StruAbbr:Maintenance',831) 
/


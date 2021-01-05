delete from HtmlLabelIndex where id=30643 
GO
delete from HtmlLabelInfo where indexid=30643 
GO
INSERT INTO HtmlLabelIndex values(30643,'每页显示') 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'每页显示',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'Per Page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30643,'每頁顯示',9) 
GO
delete from HtmlLabelIndex where id=81511 
GO
delete from HtmlLabelInfo where indexid=81511 
GO
INSERT INTO HtmlLabelIndex values(81511,'已有数据集成') 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'已有数据集成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'Existing Data Integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81511,'已有數據集成',9) 
GO
delete from HtmlLabelIndex where id=30688 
GO
delete from HtmlLabelInfo where indexid=30688 
GO
INSERT INTO HtmlLabelIndex values(30688,'数据选择') 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'数据选择',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'Data selection',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30688,'數據選擇',9) 
GO
delete from HtmlLabelIndex where id=32219 
GO
delete from HtmlLabelInfo where indexid=32219 
GO
INSERT INTO HtmlLabelIndex values(32219,'自定义方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'自定义方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'Customize the way',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32219,'自定義方式',9) 
GO
delete from HtmlLabelIndex where id=22970 
GO
delete from HtmlLabelInfo where indexid=22970 
GO
INSERT INTO HtmlLabelIndex values(22970,'TAB页') 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'TAB页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'Tab Page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22970,'TAB页',9) 
GO
delete from hpBaseElement where id='OutData'
GO 
INSERT INTO hpBaseElement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview) VALUES ('OutData','2','外部数据元素','resource/image/8.gif','10','2','getNoreadFlow','外部数据元素','1','OutData','外部数据元素','0')
GO
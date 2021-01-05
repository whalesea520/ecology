delete from HtmlLabelIndex where id=30643 
/
delete from HtmlLabelInfo where indexid=30643 
/
INSERT INTO HtmlLabelIndex values(30643,'每页显示') 
/
INSERT INTO HtmlLabelInfo VALUES(30643,'每页显示',7) 
/
INSERT INTO HtmlLabelInfo VALUES(30643,'Per Page',8) 
/
INSERT INTO HtmlLabelInfo VALUES(30643,'每頁顯示',9) 
/
delete from HtmlLabelIndex where id=81511 
/
delete from HtmlLabelInfo where indexid=81511 
/
INSERT INTO HtmlLabelIndex values(81511,'已有数据集成') 
/
INSERT INTO HtmlLabelInfo VALUES(81511,'已有数据集成',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81511,'Existing Data Integration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81511,'已有數據集成',9) 
/
delete from HtmlLabelIndex where id=30688 
/
delete from HtmlLabelInfo where indexid=30688 
/
INSERT INTO HtmlLabelIndex values(30688,'数据选择') 
/
INSERT INTO HtmlLabelInfo VALUES(30688,'数据选择',7) 
/
INSERT INTO HtmlLabelInfo VALUES(30688,'Data selection',8) 
/
INSERT INTO HtmlLabelInfo VALUES(30688,'數據選擇',9) 
/
delete from HtmlLabelIndex where id=32219 
/
delete from HtmlLabelInfo where indexid=32219 
/
INSERT INTO HtmlLabelIndex values(32219,'自定义方式') 
/
INSERT INTO HtmlLabelInfo VALUES(32219,'自定义方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32219,'Customize the way',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32219,'自定義方式',9) 
/
delete from HtmlLabelIndex where id=22970 
/
delete from HtmlLabelInfo where indexid=22970 
/
INSERT INTO HtmlLabelIndex values(22970,'TAB页') 
/
INSERT INTO HtmlLabelInfo VALUES(22970,'TAB页',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22970,'Tab Page',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22970,'TAB页',9) 
/
delete from hpBaseElement where id='OutData'
/
INSERT INTO hpBaseElement(id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview
) VALUES ('OutData','2','外部数据元素','resource/image/8.gif','10','2 ','getNoreadFlow','外部数据元素','1 ','OutData','外部数据元素','0')
/
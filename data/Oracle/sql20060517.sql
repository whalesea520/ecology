INSERT INTO HtmlLabelIndex values(18990,'请先清除该模板的指定状态') 
/
INSERT INTO HtmlLabelInfo VALUES(18990,'请先清除该模板的指定状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18990,'Firstly, delete the appointed status',8) 
/

CREATE TABLE SystemTemplateSubComp(
    subcompanyid integer,
    templateid integer
)
/
insert into SystemTemplateSubComp (subcompanyid,templateid) select id,-1 from HrmSubCompany
/

insert into SysPoppupInfo values (11,'/cpt/search/CptInstockSearch.jsp','资产入库验收提醒','y','资产入库验收提醒')
/  
INSERT INTO HtmlLabelIndex values(18993,'显著的') 
/
INSERT INTO HtmlLabelIndex values(18995,'总分') 
/
INSERT INTO HtmlLabelIndex values(18996,'平均分') 
/
INSERT INTO HtmlLabelIndex values(18998,'一共有') 
/
INSERT INTO HtmlLabelIndex values(18999,'个人打分') 
/
INSERT INTO HtmlLabelIndex values(18992,'平淡的') 
/
INSERT INTO HtmlLabelIndex values(18991,'请给当前文档打分') 
/
INSERT INTO HtmlLabelIndex values(18994,'在下面写出评价的原因') 
/
INSERT INTO HtmlLabelIndex values(18997,'详细情况') 
/
INSERT INTO HtmlLabelInfo VALUES(18991,'请给当前文档打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18991,'Please mark the current doc',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18992,'平淡的',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18992,'Insipid',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18993,'显著的',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18993,'Conspicuous',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18994,'在下面写出评价的原因',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18994,'Write the reason of this evaluation below',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18995,'总分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18995,'Total',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18996,'平均分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18996,'Average',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18997,'详细情况',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18997,'Detail',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18998,'一共有',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18998,'Totally',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18999,'个人打分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18999,'people marked',8) 
/

INSERT INTO HtmlLabelIndex values(19003,'打分日期') 
/
INSERT INTO HtmlLabelIndex values(19002,'打分人') 
/
INSERT INTO HtmlLabelIndex values(19000,'你必须要选择好分数才能提交！') 
/
INSERT INTO HtmlLabelIndex values(19001,'没有选择需要订阅的文档，请查看相关错误日志！') 
/
INSERT INTO HtmlLabelInfo VALUES(19000,'你必须要选择好分数才能提交！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19000,'You must choose a point to submit!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19001,'没有选择需要订阅的文档，请查看相关错误日志！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19001,'No choosing doc to read,please check the related error log!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19002,'打分人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19002,'Marker',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19003,'打分日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19003,'Mark Date',8) 
/

update Htmllabelinfo set labelname='Value of Point' where indexid=18093 and languageid=8
/

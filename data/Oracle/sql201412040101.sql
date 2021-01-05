delete from HtmlLabelIndex where id=81723 
/
delete from HtmlLabelInfo where indexid=81723 
/
INSERT INTO HtmlLabelIndex values(81723,'项目卡片显示栏目') 
/
INSERT INTO HtmlLabelInfo VALUES(81723,'项目卡片显示栏目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81723,'PrjCardItem',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81723,'項目卡片顯示欄目',9) 
/

delete from HtmlLabelIndex where id=81724 
/
delete from HtmlLabelInfo where indexid=81724 
/
INSERT INTO HtmlLabelIndex values(81724,'资产卡片显示栏目') 
/
INSERT INTO HtmlLabelInfo VALUES(81724,'资产卡片显示栏目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81724,'CptCardItem',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81724,'資産卡片顯示欄目',9) 
/

delete from HtmlLabelInfo where indexid=81725 
/
INSERT INTO HtmlLabelIndex values(81725,'资产卡片字段定义') 
/
INSERT INTO HtmlLabelInfo VALUES(81725,'资产卡片字段定义',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81725,'CptCardFieldDefine',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81725,'資産卡片字段定義',9) 
/


delete from HtmlLabelIndex where id=81726 
/
delete from HtmlLabelInfo where indexid=81726 
/
INSERT INTO HtmlLabelIndex values(81726,'资产管理流程配置') 
/
INSERT INTO HtmlLabelInfo VALUES(81726,'资产管理流程配置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81726,'CptManageWorkflowCfg',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81726,'資産管理流程配置',9) 
/


update HtmlLabelInfo set labelname='通用项目字段定义' where indexid=33091 and languageid=7
/
update HtmlLabelInfo set labelname='通用項目欄位自訂' where indexid=33091 and languageid=9
/

update HtmlLabelInfo set labelname='项目类型字段定义' where indexid=18630 and languageid=7
/
update HtmlLabelInfo set labelname='項目類型欄位自訂' where indexid=18630 and languageid=9
/

delete from HtmlLabelIndex where id in(20323,20324,20325,20326,20327,20328,20329)
GO
delete from HtmlLabelInfo where indexId in(20323,20324,20325,20326,20327,20328,20329)
GO
INSERT INTO HtmlLabelIndex values(20323,'客户信息') 
GO
INSERT INTO HtmlLabelIndex values(20326,'机构分部设置') 
GO
INSERT INTO HtmlLabelIndex values(20328,'客户重要性设置') 
GO
INSERT INTO HtmlLabelIndex values(20329,'人员重要性设置') 
GO
INSERT INTO HtmlLabelIndex values(20327,'工作方式设置') 
GO
INSERT INTO HtmlLabelIndex values(20324,'联系人导入') 
GO
INSERT INTO HtmlLabelIndex values(20325,'机构总部设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(20323,'客户信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20323,'Customer Info',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20324,'联系人导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20324,'Contacter Import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20325,'机构总部设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20325,'Structure HQ Set',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20326,'机构分部设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20326,'Structure Subsection Set',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20327,'工作方式设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20327,'Working Fashion Set',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20328,'客户重要性设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20328,'Customer Importance Set',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20329,'人员重要性设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20329,'Contacter Importance Set',8) 
GO 

delete from HtmlLabelIndex where id in(20332,20333,20334,20335,20336,20337,20338,20339,20340,20341)
GO
delete from HtmlLabelInfo where indexId in(20332,20333,20334,20335,20336,20337,20338,20339,20340,20341)
GO
INSERT INTO HtmlLabelIndex values(20332,'机构总部') 
GO
INSERT INTO HtmlLabelIndex values(20333,'机构分部') 
GO
INSERT INTO HtmlLabelIndex values(20338,'按客户分类查看') 
GO
INSERT INTO HtmlLabelIndex values(20339,'网点名称') 
GO
INSERT INTO HtmlLabelIndex values(20340,'区域经理') 
GO
INSERT INTO HtmlLabelIndex values(20335,'客户重要性') 
GO
INSERT INTO HtmlLabelIndex values(20336,'人员重要性') 
GO
INSERT INTO HtmlLabelIndex values(20337,'按地域分类查看') 
GO
INSERT INTO HtmlLabelIndex values(20334,'工作方式') 
GO
INSERT INTO HtmlLabelIndex values(20341,'联系对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(20332,'机构总部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20332,'Structure HQ',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20333,'机构分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20333,'Structure Subsection',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20334,'工作方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20334,'Working Fashion',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20335,'客户重要性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20335,'Customer Importance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20336,'人员重要性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20336,'Contacter Importance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20337,'按地域分类查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20337,'View By Location',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20338,'按客户分类查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20338,'View By Customer Type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20339,'网点名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20339,'Outlets Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20340,'区域经理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20340,'Regional Manager',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20341,'联系对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20341,'Contact Object',8) 
GO
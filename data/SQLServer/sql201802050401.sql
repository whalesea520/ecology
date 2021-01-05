delete from HtmlLabelIndex where id=382393 
GO
delete from HtmlLabelInfo where indexid=382393 
GO
INSERT INTO HtmlLabelIndex values(382393,'当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【报销金额】必须也是明细字段，请调整字段对应关系！') 
GO
delete from HtmlLabelIndex where id=382394 
GO
delete from HtmlLabelInfo where indexid=382394 
GO
INSERT INTO HtmlLabelIndex values(382394,'当【报销金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382394,'当【报销金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382394,'When the [reimbursement amount] is a detail field, [budgetary information] must also be a detailed field, please adjust the field correspondence!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382394,'當【報銷金額】是明細字段時，【預算信息】必須也是明細字段，請調整字段對應關系！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382393,'当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【报销金额】必须也是明细字段，请调整字段对应关系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382393,'When a subject is assumed to have a detail field, the reimbursement amount must be a detail field. Please adjust the relationship between the fields.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382393,'當【科目】【承擔主體類型】【承擔主體】【報銷日期】中有任意一個是明細字段時，【報銷金額】必須也是明細字段，請調整字段對應關系！',9) 
GO

delete from HtmlLabelIndex where id=382395 
GO
delete from HtmlLabelInfo where indexid=382395 
GO
INSERT INTO HtmlLabelIndex values(382395,'当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【变更金额】必须也是明细字段，请调整字段对应关系！') 
GO
delete from HtmlLabelIndex where id=382396 
GO
delete from HtmlLabelInfo where indexid=382396 
GO
INSERT INTO HtmlLabelIndex values(382396,'当【变更金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！') 
GO
delete from HtmlLabelIndex where id=382397 
GO
delete from HtmlLabelInfo where indexid=382397 
GO
INSERT INTO HtmlLabelIndex values(382397,'当转出【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，转出【预算信息】必须也是明细字段，请调整字段对应关系！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382397,'当转出【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，转出【预算信息】必须也是明细字段，请调整字段对应关系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382397,'When there are any details in the subject [commitment body [commitment body] [reimbursement date], the budget information must also be the detail field. Please adjust the corresponding relationship between the fields.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382397,'當轉出【科目】【承擔主體類型】【承擔主體】【報銷日期】中有任意一個是明細字段時，轉出【預算信息】必須也是明細字段，請調整字段對應關系！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382396,'当【变更金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382396,'When the change amount is the detail field, the budget information must also be the detail field, please adjust the field correspondence.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382396,'當【變更金額】是明細字段時，【預算信息】必須也是明細字段，請調整字段對應關系！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382395,'当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【变更金额】必须也是明细字段，请调整字段对应关系！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382395,'When a subject is assumed to have a detail field, the amount of change must also be the detail field. Please adjust the corresponding relationship between fields.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382395,'當【科目】【承擔主體類型】【承擔主體】【報銷日期】中有任意一個是明細字段時，【變更金額】必須也是明細字段，請調整字段對應關系！',9) 
GO

delete from HtmlLabelIndex where id=382399 
GO
delete from HtmlLabelInfo where indexid=382399 
GO
INSERT INTO HtmlLabelIndex values(382399,'【承担主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382399,'【承担主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382399,'[the subject type] can only be 0, 1, 2, 3; 0: individual; 1: Department; 2: Division; 3: cost center, check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382399,'【承擔主體類型】可選項範圍隻能是0、1、2、3；0：個人；1：部門；2：分部；3：成本中心，請檢查！',9) 
GO

delete from HtmlLabelIndex where id=382400 
GO
delete from HtmlLabelInfo where indexid=382400 
GO
INSERT INTO HtmlLabelIndex values(382400,'【变更主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！') 
GO
delete from HtmlLabelIndex where id=382401 
GO
delete from HtmlLabelInfo where indexid=382401 
GO
INSERT INTO HtmlLabelIndex values(382401,'【转出主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382401,'【转出主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382401,'The option range can only be 0, 1, 2, 3; 0: individual; 1: Department; 2: Division; 3: cost center, check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382401,'【轉出主體類型】可選項範圍隻能是0、1、2、3；0：個人；1：部門；2：分部；3：成本中心，請檢查！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382400,'【变更主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382400,'[change subject type] optional range can only be 0, 1, 2, 3; 0: individual; 1: Department; 2: branch; 3: cost center, check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382400,'【變更主體類型】可選項範圍隻能是0、1、2、3；0：個人；1：部門；2：分部；3：成本中心，請檢查！',9) 
GO

delete from HtmlLabelIndex where id=382402 
GO
delete from HtmlLabelInfo where indexid=382402 
GO
INSERT INTO HtmlLabelIndex values(382402,'【调出主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！') 
GO
delete from HtmlLabelIndex where id=382403 
GO
delete from HtmlLabelInfo where indexid=382403 
GO
INSERT INTO HtmlLabelIndex values(382403,'【调入主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382403,'【调入主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382403,'The option range can only be 0, 1, 2, 3; 0: individual; 1: Department; 2: Division; 3: cost center, check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382403,'【調入主體類型】可選項範圍隻能是0、1、2、3；0：個人；1：部門；2：分部；3：成本中心，請檢查！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382402,'【调出主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382402,'The option range can only be 0, 1, 2, 3; 0: individual; 1: Department; 2: Division; 3: cost center, check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382402,'【調出主體類型】可選項範圍隻能是0、1、2、3；0：個人；1：部門；2：分部；3：成本中心，請檢查！',9) 
GO

delete from HtmlLabelIndex where id=382404 
GO
delete from HtmlLabelInfo where indexid=382404 
GO
INSERT INTO HtmlLabelIndex values(382404,'【借款类型】可选项范围只能是0、1；0：个人借款；1：公务借款，请检查！') 
GO
INSERT INTO HtmlLabelInfo VALUES(382404,'【借款类型】可选项范围只能是0、1；0：个人借款；1：公务借款，请检查！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382404,'The option range can only be 0, 1; 0: personal loan; 1: official loan, please check!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382404,'【借款類型】可選項範圍隻能是0、1；0：個人借款；1：公務借款，請檢查！',9) 
GO
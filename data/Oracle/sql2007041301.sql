delete from HtmlLabelIndex where id in(20291,20292,20293,20294,20295,20296,20297,20298)
/
delete from HtmlLabelInfo where indexId in(20291,20292,20293,20294,20295,20296,20297,20298)
/
INSERT INTO HtmlLabelIndex values(20294,'所选工作流只能是对应单据“审批流转单”的有效流程。') 
/
INSERT INTO HtmlLabelIndex values(20291,'所选工作流为所有的有效流程。') 
/
INSERT INTO HtmlLabelIndex values(20296,'流程下一个节点操作人执行“批准”操作后文档状态变为“正常”，执行“退回”操作后文档状态变为“退回”。') 
/
INSERT INTO HtmlLabelIndex values(20297,'审批流程必须有表现形式为“浏览按钮 - 文档”或“浏览按钮 - 多文档”的字段。') 
/
INSERT INTO HtmlLabelIndex values(20298,'必须要有一个表现形式为“浏览按钮 - 文档”或“浏览按钮 - 多文档”的流程字段对应文挡属性页字段“文档标题”。') 
/
INSERT INTO HtmlLabelIndex values(20292,'新建或编辑该子目录下的文档时触发文档生效审批流程；失效该子目录下的文档时触发文档失效审批流程。') 
/
INSERT INTO HtmlLabelIndex values(20293,'文档的状态改变由出口附加规则决定。') 
/
INSERT INTO HtmlLabelIndex values(20295,'只有在新建或编辑该子目录下的文档时才触发该流程。') 
/
INSERT INTO HtmlLabelInfo VALUES(20291,'所选工作流为所有的有效流程。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20291,'All of valid workflows could be approval workflows.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20292,'新建或编辑该子目录下的文档时触发文档生效审批流程；失效该子目录下的文档时触发文档失效审批流程。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20292,'The validity approval workflow will be triggered when create or edit a document in this SecCategory;the invalidity Approval workflow will be triggered when invalid a document in this SecCategory.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20293,'文档的状态改变由出口附加规则决定。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20293,'The change of document status depends on the additional rule of exit.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20294,'所选工作流只能是对应单据“审批流转单”的有效流程。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20294,'Only valid workflows that related to approvement move bill could be Confirmation Workflow.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20295,'只有在新建或编辑该子目录下的文档时才触发该流程。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20295,'The validity confirmation workflow will be triggered when create or edit a document in this SecCategory.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20296,'流程下一个节点操作人执行“批准”操作后文档状态变为“正常”，执行“退回”操作后文档状态变为“退回”。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20296,'The status of document will be ‘normal’ after the next operator of workflow confirm the workflow;the status of document will be ‘reject’ after the next operator of workflow reject the workflow.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20297,'审批流程必须有表现形式为“浏览按钮 - 文档”或“浏览按钮 - 多文档”的字段。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20297,'The Approve Workflow must has the field of the show type is ''BrowserButton - Document'' or ''BrowserButton - Multi-Document''.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20298,'必须要有一个表现形式为“浏览按钮 - 文档”或“浏览按钮 - 多文档”的流程字段对应文挡属性页字段“文档标题”。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20298,'It must has one workflow field of the show type is ''BrowserButton - Document'' or ''BrowserButton - Multi-Document''.The field is related to the Document Properties Field ''Document Title''.',8) 
/

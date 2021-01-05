
INSERT INTO HtmlLabelIndex values(19677,'显示流程状态') 
/
INSERT INTO HtmlLabelIndex values(19678,'隐藏流程状态') 
/
INSERT INTO HtmlLabelIndex values(19676,'隐藏流程图') 
/
INSERT INTO HtmlLabelIndex values(19675,'显示流程图') 
/
INSERT INTO HtmlLabelInfo VALUES(19675,'显示流程图',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19675,'Show Workflow Chart',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19676,'隐藏流程图',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19676,'Hide Workflow Chart',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19677,'显示流程状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19677,'Show Workflow Status',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19678,'隐藏流程状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19678,'Hide Workflow Status',8) 
/

update HtmlLabelInfo set  labelName='Workflow Status' where indexid=19061 and languageid=8
/
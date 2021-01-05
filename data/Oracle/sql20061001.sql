INSERT INTO HtmlLabelIndex values(19758,'启用批准工作流') 
/
INSERT INTO HtmlLabelInfo VALUES(19758,'启用批准工作流',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19758,'Open Confirm Workflow',8) 
/

update DocSecCategory set isOpenApproveWf='2' where approveWorkflowId>0
/

update DocDetail set approveType='1' where docStatus='3'
/

INSERT INTO HtmlLabelIndex values(19761,'批准类型') 
/
INSERT INTO HtmlLabelIndex values(19762,'批准流程') 
/
INSERT INTO HtmlLabelInfo VALUES(19761,'批准类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19761,'Confirm Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19762,'批准流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19762,'Confirm Workflow',8) 
/

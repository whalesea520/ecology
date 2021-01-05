ALTER TABLE workflow_report ADD
(
	formId Integer NULL,
	isbill CHAR(1) NULL
)
/


ALTER TABLE WorkFlow_Report ADD
(
    reportWFIDTemp VARCHAR(200)
)
/

UPDATE WorkFlow_Report SET reportWFIDTemp = reportWFID, reportWFID = NULL
/

ALTER TABLE workflow_report MODIFY
(
	reportWFID VARCHAR(200)
)
/

UPDATE WorkFlow_Report SET reportWFID = reportWFIDTemp
/

ALTER TABLE WorkFlow_Report DROP
(
    reportWFIDTemp
)
/


UPDATE workflow_report 
SET formId =
(
	SELECT formid FROM workflow_base WHERE id = reportwfid
),
isbill =
(
	SELECT isbill FROM workflow_base WHERE id = reportwfid
)
/


INSERT INTO HtmlLabelIndex values(19514,'相关表单或单据名称') 
/
INSERT INTO HtmlLabelInfo VALUES(19514,'相关表单或单据名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19514,'The Relative Name of Form or Bill',8) 
/

INSERT INTO HtmlLabelIndex values(19532,'表单') 
/
INSERT INTO HtmlLabelInfo VALUES(19532,'表单',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19532,'Form',8) 
/

INSERT INTO HtmlLabelIndex values(19533,'表单或单据') 
/
INSERT INTO HtmlLabelInfo VALUES(19533,'表单或单据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19533,'Form or Bill',8) 
/

INSERT INTO HtmlLabelIndex values(17736,'排序类型') 
/
INSERT INTO HtmlLabelInfo VALUES(17736,'排序类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17736,'type of compositor',8) 
/

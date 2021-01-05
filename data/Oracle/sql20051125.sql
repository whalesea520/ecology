INSERT INTO HtmlLabelIndex values(18010,'节点后附加操作') 
/
INSERT INTO HtmlLabelInfo VALUES(18010,'节点后附加操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18010,'followed odditional operation',8) 
/

INSERT INTO HtmlLabelIndex values(18009,'节点前附加操作') 
/
INSERT INTO HtmlLabelInfo VALUES(18009,'节点前附加操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18009,'pre odditional operation',8) 
/

alter table workflow_addinoperate add ispreadd char(1)
/

update  workflow_addinoperate set ispreadd = '0'
/

CREATE OR REPLACE PROCEDURE workflow_addinoperate_Insert (objid_1 INTEGER,
isnode_2 INTEGER, workflowid_3 INTEGER, fieldid_4 INTEGER, fieldop1id_5 INTEGER, fieldop2id_6 INTEGER,
operation_7 INTEGER, customervalue_8 VARCHAR2, rules_9 INTEGER, type_10 INTEGER,ispreadd_11 char, flag OUT INTEGER,
msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor) 
AS
BEGIN
   INSERT INTO workflow_addinoperate (objid, isnode, workflowid, fieldid, fieldop1id,
   fieldop2id, operation, customervalue, rules, TYPE,ispreadd) 
   VALUES(objid_1, isnode_2, workflowid_3, fieldid_4, fieldop1id_5, fieldop2id_6,
   operation_7, customervalue_8, rules_9, type_10,ispreadd_11);
END;

/

CREATE OR REPLACE PROCEDURE workflow_addinoperate_select (id1 	INTEGER, isnode1 	INTEGER,ispreadding char,
flag OUT INTEGER, msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor)

AS
BEGIN
   OPEN thecursor FOR SELECT * 
   FROM workflow_addinoperate 
   WHERE objid = id1 
   AND isnode = isnode1 
   AND ispreadd=ispreadding
   ORDER BY id;

END;

/
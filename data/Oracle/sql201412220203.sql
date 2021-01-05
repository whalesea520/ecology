DELETE FROM workflow_browserurl WHERE id=267
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
 VALUES (267,122,'','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','HrmRoles','RolesMark','ID','/hrm/roles/HrmRolesEdit.jsp?id=')
/

CREATE TABLE workflow_browdef_fieldconf (
	id NUMBER(38) PRIMARY KEY,
	fieldtype NUMBER(38) NOT NULL,
	fieldname VARCHAR2(100) NOT NULL,
	namelabel VARCHAR2(100) NOT NULL,
	conditionfieldtype VARCHAR2(100) NOT NULL,
	defaultshoworder VARCHAR2(100) NOT NULL
)
/

CREATE TABLE workflow_browdef_selitemconf (
	configid NUMBER(38) NOT NULL,
	namelabel VARCHAR2(100) NOT NULL,
	value VARCHAR2(500) NOT NULL,
	showorder VARCHAR2(100) NOT NULL,
	browsertype NUMBER(38),
	singlebrowser CHAR(1),
	browserparams VARCHAR2(500),
	defaultitem CHAR(1)
)
/

CREATE TABLE workflow_browdef (
	workflowid NUMBER(38) NOT NULL,
	fieldid NUMBER(38) NOT NULL,
	viewtype NUMBER(38) NOT NULL,
	fieldtype NUMBER(38) NOT NULL,
	title VARCHAR2(500) NOT NULL
)
/

CREATE TABLE workflow_browdef_field (
	configid NUMBER(38) NOT NULL,
	workflowid NUMBER(38) NOT NULL,
	fieldid NUMBER(38) NOT NULL,
	viewtype NUMBER(38) NOT NULL,
	showorder VARCHAR2(100) NOT NULL,
	hide CHAR(1),
	readonly CHAR(1),
	canselectvalues VARCHAR2(500),
	valuetype VARCHAR2(500),
	value VARCHAR2(500)
)
/

INSERT INTO workflow_browdef_fieldconf VALUES('1', '1', 'lastname', '413', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('2', '1', 'status', '602', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '332', '9', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '1831', '8', '2.0', '', '', '','1')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '15710', '0', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '15711', '1', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '480', '2', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '15844', '3', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '6094', '4', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '6091', '5', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '6092', '6', '9.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('2', '2245', '7', '10.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('3', '1', 'subcompanyid', '141', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('3', '20558,141', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('3', '19437', '2', '2.0', '164', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('3', '21740', '3', '3.0', '-1', '1', 'type=164,194,169,170,4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('4', '1', 'departmentid', '124', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('4', '20558,124', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('4', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('4', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('5', '1', 'jobtitle', '6086', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('5', '17908,6086', '2', '2.0', '24', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('5', '21740', '3', '3.0', '-1', '1', 'type=24','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('6', '1', 'roleid', '122', 'select_browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('6', '17908,122', '2', '2.0', '267', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('6', '21740', '3', '3.0', '-1', '1', 'type=267,65','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('7', '17', 'lastname', '413', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('8', '17', 'status', '602', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '332', '9', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '1831', '8', '2.0', '', '', '','1')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '15710', '0', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '15711', '1', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '480', '2', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '15844', '3', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '6094', '4', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '6091', '5', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '6092', '6', '9.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('8', '2245', '7', '10.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('9', '17', 'subcompanyid', '141', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('9', '20558,141', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('9', '19437', '2', '2.0', '164', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('9', '21740', '3', '3.0', '-1', '1', 'type=164,194,169,170,4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('10', '17', 'departmentid', '124', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('10', '20558,124', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('10', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('10', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('11', '17', 'jobtitle', '6086', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('11', '17908,6086', '2', '2.0', '24', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('11', '21740', '3', '3.0', '-1', '1', 'type=24','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('12', '17', 'roleid', '122', 'select_browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('12', '17908,122', '2', '2.0', '267', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('12', '21740', '3', '3.0', '-1', '1', 'type=267,65','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('13', '165', 'lastname', '413', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('14', '165', 'status', '602', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '332', '9', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '1831', '8', '2.0', '', '', '','1')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '15710', '0', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '15711', '1', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '480', '2', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '15844', '3', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '6094', '4', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '6091', '5', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '6092', '6', '9.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('14', '2245', '7', '10.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('15', '165', 'subcompanyid', '141', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('15', '20558,141', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('15', '19437', '2', '2.0', '164', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('15', '21740', '3', '3.0', '-1', '1', 'type=164,194,169,170,4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('16', '165', 'departmentid', '124', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('16', '20558,124', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('16', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('16', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('17', '165', 'jobtitle', '6086', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('17', '17908,6086', '2', '2.0', '24', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('17', '21740', '3', '3.0', '-1', '1', 'type=24','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('18', '165', 'roleid', '122', 'select_browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('18', '17908,122', '2', '2.0', '267', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('18', '21740', '3', '3.0', '-1', '1', 'type=267,65','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('19', '166', 'lastname', '413', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('20', '166', 'status', '602', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '332', '9', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '1831', '8', '2.0', '', '', '','1')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '15710', '0', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '15711', '1', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '480', '2', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '15844', '3', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '6094', '4', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '6091', '5', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '6092', '6', '9.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('20', '2245', '7', '10.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('21', '166', 'subcompanyid', '141', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('21', '20558,141', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('21', '19437', '2', '2.0', '164', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('21', '21740', '3', '3.0', '-1', '1', 'type=164,194,169,170,4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('22', '166', 'departmentid', '124', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('22', '20558,124', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('22', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('22', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('23', '166', 'jobtitle', '6086', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('23', '17908,6086', '2', '2.0', '24', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('23', '21740', '3', '3.0', '-1', '1', 'type=24','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('24', '166', 'roleid', '122', 'select_browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('24', '17908,122', '2', '2.0', '267', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('24', '21740', '3', '3.0', '-1', '1', 'type=267,65','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('25', '9', 'searchsubject', '229', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('26', '9', 'secCategory', '16398', 'single_doc_category', '2.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('27', '9', 'doccreatedateselect', '25733', 'date', '3.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('28', '9', 'searchcreater', '362', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('28', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('28', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('28', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('29', '9', 'txtCrmId', '21313', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('29', '18647', '2', '2.0', '7', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('29', '21740', '3', '3.0', '-1', '1', 'type=7,18','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('30', '9', 'date2during', '81675', 'wfdateduring', '6.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('31', '9', 'searchid', '84', 'text', '7.0')
/

INSERT INTO workflow_browdef_fieldconf VALUES('32', '37', 'searchsubject', '229', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('33', '37', 'secCategory', '16398', 'single_doc_category', '2.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('34', '37', 'doccreatedateselect', '25733', 'date', '3.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('35', '37', 'searchcreater', '362', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('35', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('35', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('35', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('36', '37', 'txtCrmId', '21313', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('36', '18647', '2', '2.0', '7', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('36', '21740', '3', '3.0', '-1', '1', 'type=7,18','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('37', '37', 'date2during', '81675', 'wfdateduring', '6.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('38', '37', 'searchid', '84', 'text', '7.0')
/

INSERT INTO workflow_browdef_fieldconf VALUES('39', '8', 'name', '33439', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('40', '8', 'status', '587', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '225', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '2244', '2', '2.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '555', '3', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '1232', '4', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '2243', '5', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '2242', '6', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '1010', '7', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('40', '220', '0', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('41', '8', 'prjtype', '586', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('41', '17908,586', '2', '2.0', '244', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('41', '21740', '3', '3.0', '-1', '1', 'type=244','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('42', '8', 'worktype', '432', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('42', '17908,432', '2', '2.0', '245', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('42', '21740', '3', '3.0', '-1', '1', 'type=245','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('43', '8', 'manager', '144', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('43', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('43', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('43', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('44', '135', 'name', '33439', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('45', '135', 'status', '587', 'select_config', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '225', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '2244', '2', '2.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '555', '3', '3.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '1232', '4', '4.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '2243', '5', '5.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '2242', '6', '6.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '1010', '7', '7.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('45', '220', '0', '8.0', '', '', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('46', '135', 'prjtype', '586', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('46', '17908,586', '2', '2.0', '244', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('46', '21740', '3', '3.0', '-1', '1', 'type=244','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('47', '135', 'worktype', '432', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('47', '17908,432', '2', '2.0', '245', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('47', '21740', '3', '3.0', '-1', '1', 'type=245','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('48', '135', 'manager', '144', 'select_browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('48', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('48', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('48', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('49', '7', 'name', '1268', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('50', '7', 'engname', '17080', 'text', '2.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('51', '7', 'type', '33234', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('51', '17908,33234,', '2', '2.0', '60', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('51', '21740', '3', '3.0', '-1', '1', 'type=60','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('52', '7', 'customerStatus', '602', 'browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('52', '17908,602', '2', '2.0', '259', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('53', '7', 'country1', '377', 'browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('53', '17908,377', '2', '2.0', '258', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('54', '7', 'City', '493', 'browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('54', '17908,493', '2', '2.0', '58', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('55', '7', 'crmManager', '1278', 'select_browser', '7.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('55', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('55', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('55', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('56', '7', 'departmentid', '1278,27511', 'select_browser', '8.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('56', '20558,27511', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('56', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('56', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('57', '7', 'customerDesc', '433', 'select_browser', '9.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('57', '17908,433', '2', '2.0', '61', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('57', '21740', '3', '3.0', '-1', '1', 'type=61','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('58', '7', 'customerSize', '576', 'select_browser', '10.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('58', '17908,576', '2', '2.0', '62', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('58', '21740', '3', '3.0', '-1', '1', 'type=62','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('59', '7', 'sectorInfo', '575', 'select_browser', '11.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('59', '17908,575', '2', '2.0', '63', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('59', '21740', '3', '3.0', '-1', '1', 'type=63','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('60', '18', 'name', '1268', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('61', '18', 'engname', '17080', 'text', '2.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('62', '18', 'type', '33234', 'select_browser', '3.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('62', '17908,33234', '2', '2.0', '60', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('62', '21740', '3', '3.0', '-1', '1', 'type=60','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('63', '18', 'customerStatus', '602', 'browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('63', '17908,602', '2', '2.0', '259', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('64', '18', 'country1', '377', 'browser', '5.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('64', '17908,377', '2', '2.0', '258', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('65', '18', 'City', '493', 'browser', '6.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('65', '17908,493', '2', '2.0', '58', '1', '','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('66', '18', 'crmManager', '1278', 'select_browser', '7.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('66', '20558', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('66', '81811', '2', '2.0', '1', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('66', '21740', '3', '3.0', '-1', '1', 'type=1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('67', '18', 'departmentid', '1278,27511', 'select_browser', '8.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('67', '20558,27511', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('67', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('67', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('68', '18', 'customerDesc', '433', 'select_browser', '9.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('68', '17908,433', '2', '2.0', '61', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('68', '21740', '3', '3.0', '-1', '1', 'type=61','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('69', '18', 'customerSize', '576', 'select_browser', '10.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('69', '17908,576', '2', '2.0', '62', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('69', '21740', '3', '3.0', '-1', '1', 'type=62','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('70', '18', 'sectorInfo', '575', 'select_browser', '11.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('70', '17908,575', '2', '2.0', '63', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('70', '21740', '3', '3.0', '-1', '1', 'type=63','')
/

INSERT INTO workflow_browdef_fieldconf VALUES('71', '23', 'mark', '714', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('72', '23', 'fnamark', '15293', 'text', '2.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('73', '23', 'name', '195', 'text', '3.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('74', '23', 'departmentid', '27511', 'select_browser', '4.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('74', '20558,27511', '1', '1.0', '', '', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('74', '19438', '2', '2.0', '4', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('74', '21740', '3', '3.0', '-1', '1', 'type=4,57,167,168,1,17,165,166','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('75', '23', 'capitalSpec', '904', 'text', '5.0')
/

INSERT INTO workflow_browdef_fieldconf VALUES('76', '28', 'name', '195', 'text', '1.0')
/
INSERT INTO workflow_browdef_fieldconf VALUES('77', '28', 'address', '780', 'select_browser', '2.0')
/
INSERT INTO workflow_browdef_selitemconf VALUES('77', '17908,780', '2', '2.0', '87', '1', '','')
/
INSERT INTO workflow_browdef_selitemconf VALUES('77', '21740', '3', '3.0', '-1', '1', 'type=87','')
/
INSERT INTO workflow_browdef_fieldconf VALUES('78', '28', 'begindateselect', '742', 'date', '3.0')
/
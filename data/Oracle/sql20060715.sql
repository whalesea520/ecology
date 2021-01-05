
INSERT INTO HtmlLabelIndex values(19387,'主目录编码') 
/
INSERT INTO HtmlLabelIndex values(19388,'分目录编码') 
/
INSERT INTO HtmlLabelIndex values(19389,'子目录编码') 
/
INSERT INTO HtmlLabelIndex values(19386,'文档编码') 
/
INSERT INTO HtmlLabelInfo VALUES(19386,'文档编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19386,'Document Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19387,'主目录编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19387,'MainCategory Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19388,'分目录编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19388,'SubCategory Code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19389,'子目录编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19389,'SecCategory Code',8) 
/
INSERT INTO HtmlLabelIndex values(19417,'子目录单独流水') 
/
INSERT INTO HtmlLabelIndex values(19415,'启用子目录编码规则') 
/
INSERT INTO HtmlLabelIndex values(19416,'子文档单独编码') 
/
INSERT INTO HtmlLabelIndex values(19418,'日期单独流水') 
/
INSERT INTO HtmlLabelInfo VALUES(19415,'启用子目录编码规则',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19415,'Use SecCategory Code Rule',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19416,'子文档单独编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19416,'SecDocument Code Alone',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19417,'子目录单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19417,'SecCategory Sequence Alone',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19418,'日期单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19418,'Date Sequence Alone',8) 
/

INSERT INTO HtmlLabelIndex values(19381,'编码规则') 
/
INSERT INTO HtmlLabelInfo VALUES(19381,'编码规则',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19381,'Code Rule',8) 
/

INSERT INTO HtmlNoteIndex values(86,'该子目录下有文档存在，不能被删除！') 
/
INSERT INTO HtmlNoteInfo VALUES(86,'该子目录下有文档存在，不能被删除！',7) 
/
INSERT INTO HtmlNoteInfo VALUES(86,'There are docs under this seccategory,it can''t be deleted!',8) 
/

ALTER TABLE codemain ADD secDocCodeAlone char(1)
/
ALTER TABLE codemain ADD secCategorySeqAlone char(1)
/
ALTER TABLE codemain ADD dateSeqAlone char(1)
/
ALTER TABLE codemain ADD dateSeqSelect char(1)
/
ALTER TABLE codemain ADD secCategoryId integer
/

ALTER TABLE DocMainCategory ADD coder varchar2(20)
/
ALTER TABLE DocSubCategory ADD coder varchar2(20)
/
ALTER TABLE DocSecCategory ADD coder varchar2(20)
/

CREATE TABLE DocSecCategoryCoderSeq (
	id integer  NOT NULL ,
	sequence integer NULL ,
	yearSeq  integer NULL ,  
	monthSeq  integer NULL , 
    daySeq   integer NULL , 
    secCategoryId  integer NULL , 
    isUse char (1)     NULL 
)
/

create sequence DocSecCategoryCoderSeq_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSecCategoryCoderSeq_Tri
before insert on DocSecCategoryCoderSeq
for each row
begin
select DocSecCategoryCoderSeq_Id.nextval into :new.id from dual;
end;
/




CREATE or REPLACE PROCEDURE Doc_SecCategory_Update 
( 
	id_1	integer,
	subcategoryid_2 	integer,
	categoryname_3 	varchar2,
    coder_43 	varchar2,
	docmouldid_4 	integer,
	publishable_5 	char,
	replyable_6 	char,
	shareable_7 	char,
	cusertype_8 	integer,
	cuserseclevel_9 	smallint,
	cdepartmentid1_10 	integer,
	cdepseclevel1_11 	smallint,
	cdepartmentid2_12 	integer,
	cdepseclevel2_13 	smallint,
	croleid1_14	 		integer,
	crolelevel1_15	 	char,
	croleid2_16	 	integer,
	crolelevel2_17 	char,
	croleid3_18	 	integer,
	crolelevel3_19 	char,
	hasaccessory_20	 	char,
	accessorynum_21	 	smallint,
	hasasset_22		 	char,
	assetlabel_23	 	varchar2,
	hasitems_24	 	char,
	itemlabel_25 	varchar2,
	hashrmres_26 	char,
	hrmreslabel_27 	varchar2,
	hascrm_28	 	char,
	crmlabel_29	 	varchar2,
	hasproject_30 	char,
	projectlabel_31 	varchar2,
	hasfinance_32 	char,
	financelabel_33 	varchar2,
	approveworkflowid_34	integer,
	markable_35   char,
	markAnonymity_36   char,
	orderable_37     char,
	defaultLockedDoc_38   integer,
	allownModiMShareL_39 integer,
	allownModiMShareW_40 integer,
	maxUploadFileSize_41 integer,
    wordmouldid_42  integer,
	flag	out integer,
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor)
as
begin 
	update docseccategory set
	subcategoryid= subcategoryid_2,
	categoryname= categoryname_3,
    coder= coder_43,
	docmouldid= docmouldid_4,
	publishable= publishable_5,
	replyable= replyable_6,
	shareable= shareable_7,
	cusertype= cusertype_8,
	cuserseclevel= cuserseclevel_9,
	cdepartmentid1= cdepartmentid1_10,
	cdepseclevel1= cdepseclevel1_11,
	cdepartmentid2= cdepartmentid2_12,
	cdepseclevel2= cdepseclevel2_13,
	croleid1= croleid1_14,
	crolelevel1= crolelevel1_15,
	croleid2= croleid2_16,
	crolelevel2= crolelevel2_17,
	croleid3= croleid3_18,
	crolelevel3= crolelevel3_19,
	hasaccessory= hasaccessory_20,
	accessorynum= accessorynum_21,
	hasasset= hasasset_22,
	assetlabel= assetlabel_23,
	hasitems= hasitems_24,
	itemlabel= itemlabel_25,
	hashrmres= hashrmres_26,
	hrmreslabel= hrmreslabel_27,
	hascrm= hascrm_28,
	crmlabel= crmlabel_29,
	hasproject= hasproject_30,
	projectlabel= projectlabel_31,
	hasfinance= hasfinance_32,
	financelabel= financelabel_33,
	approveworkflowid= approveworkflowid_34,
	markable = markable_35       ,
	markAnonymity = markAnonymity_36  ,
	orderable = orderable_37 ,
	defaultLockedDoc=defaultLockedDoc_38,
	allownModiMShareL=allownModiMShareL_39,
	allownModiMShareW=allownModiMShareW_40,
	maxUploadFileSize=maxUploadFileSize_41,
    wordmouldid=wordmouldid_42
	where id= id_1;
end;
/




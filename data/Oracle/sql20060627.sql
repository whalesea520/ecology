alter table DocMould add mouldType integer
/
alter table DocMould add mouldPath  varchar2(200)
/

CREATE TABLE MouldBookMark (
	id integer  NOT NULL ,
	mouldId integer NULL ,
	name   varchar2(100) NULL,
	descript   varchar2(200) NULL
)
/
create sequence MouldBookMark_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MouldBookMark_Trigger
before insert on MouldBookMark
for each row
begin
select MouldBookMark_Id.nextval into :new.id from dual;
end;
/


CREATE TABLE DocMouldBookMark (
	id integer  NOT NULL ,
	docId integer NULL ,
	mouldId  integer NULL ,
	bookMarkId  integer NULL ,
    bookMarkValue varchar2(200) NULL
)
/
create sequence DocMouldBookMark_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMouldBookMark_Tri
before insert on DocMouldBookMark
for each row
begin
select DocMouldBookMark_Id.nextval into :new.id from dual;
end;
/


alter table DocSecCategory add wordmouldid integer
/
INSERT INTO HtmlLabelIndex values(19333,'从已有模板导入') 
/
INSERT INTO HtmlLabelInfo VALUES(19333,'从已有模板导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19333,'import from existing',8) 
/
 
CREATE or REPLACE PROCEDURE Doc_SecCategory_Insert 
	(subcategoryid_1 	integer,
	categoryname_2 	varchar2,
	docmouldid_3 	integer,
	publishable_4 	char,
	replyable_5 	char,
	shareable_6 	char,
	cusertype_7 	integer,
	cuserseclevel_8 	smallint,
	cdepartmentid1_9 	integer,
	cdepseclevel1_10 	smallint,
	cdepartmentid2_11 	integer,
	cdepseclevel2_12 	smallint,
	croleid1_13	 		integer,
	crolelevel1_14	 	char,
	croleid2_15	 	integer,
	crolelevel2_16 	char,
	croleid3_17	 	integer,
	crolelevel3_18 	char,
	hasaccessory_19	 	char,
	accessorynum_20	 	smallint,
	hasasset_21		 	char,
	assetlabel_22	 	varchar2,
	hasitems_23	 	char,
	itemlabel_24 	varchar2,
	hashrmres_25 	char,
	hrmreslabel_26 	varchar2,
	hascrm_27	 	char,
	crmlabel_28	 	varchar2,
	hasproject_29 	char,
	projectlabel_30 	varchar2,
	hasfinance_31 	char,
	financelabel_32 	varchar2,
	approveworkflowid_33	integer,
	markable_34   char,
	markAnonymity_35   char,
	orderable_36     char,
	defaultLockedDoc_37   integer,
	allownModiMShareL_38 integer,
	allownModiMShareW_39 integer,
	maxUploadFileSize_40 integer,
    wordmouldid_41 integer,
	flag	out integer,
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor)
as 
begin 

	insert into docseccategory 
		(subcategoryid  ,
		categoryname  ,
		docmouldid  ,
		publishable  ,
		replyable  ,
		shareable  ,
		cusertype  ,
		cuserseclevel  ,
		cdepartmentid1  ,
		cdepseclevel1  ,
		cdepartmentid2  ,
		cdepseclevel2  ,
		croleid1 ,
		crolelevel1  ,
		croleid2  ,
		crolelevel2 ,
		croleid3  ,
		crolelevel3  ,
		hasaccessory  ,
		accessorynum  ,
		hasasset  ,
		assetlabel  ,
		hasitems  ,
		itemlabel  ,
		hashrmres ,
		hrmreslabel  ,
		hascrm  ,
		crmlabel  ,
		hasproject  ,
		projectlabel  ,
		hasfinance  ,
		financelabel  ,
		approveworkflowid ,
		markable ,
		markAnonymity ,
		orderable,
		defaultLockedDoc,
		allownModiMShareL,
		allownModiMShareW,
		maxUploadFileSize,
        wordmouldid)
	values(
		subcategoryid_1 	,
		categoryname_2 	,
		docmouldid_3 		,
		publishable_4		,
		replyable_5 		,
		shareable_6 		,
		cusertype_7 		,
		cuserseclevel_8 	,
		cdepartmentid1_9 	,
		cdepseclevel1_10 	,
		cdepartmentid2_11 ,
		cdepseclevel2_12 	,
		croleid1_13	 	,
		crolelevel1_14	,
		croleid2_15	 	,
		crolelevel2_16 	,
		croleid3_17	 	,
		crolelevel3_18 	,
		hasaccessory_19	,
		accessorynum_20	,
		hasasset_21		,
		assetlabel_22	 	,
		hasitems_23	 	,
		itemlabel_24 		,
		hashrmres_25 		,
		hrmreslabel_26 	,
		hascrm_27	 	,
		crmlabel_28	 	,
		hasproject_29 	,
		projectlabel_30 	,
		hasfinance_31 	,
		financelabel_32 	,
		approveworkflowid_33,
		markable_34       ,
		markAnonymity_35  ,
		orderable_36     ,
		defaultLockedDoc_37,
		allownModiMShareL_38 ,
		allownModiMShareW_39,
		maxUploadFileSize_40,
        wordmouldid_41);
	open thecursor for 
	select max(id) from docseccategory;
end;
/

CREATE or REPLACE PROCEDURE Doc_SecCategory_Update 
( 
	id_1	integer,
	subcategoryid_2 	integer,
	categoryname_3 	varchar2,
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
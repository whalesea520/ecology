/*文档打分表*/
CREATE TABLE DocMark (
	id integer   NOT NULL,
	docId integer NULL  ,
	markHrmType integer NULL  ,
    markHrmId integer null,
    mark integer null,
    remark varchar2(500) NULL,    
    markDate Char(10) NULL
) 
/
create sequence  DocMark_id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
create or replace trigger DocMark_trigger
before insert on DocMark
for each row
begin
	select DocMark_id.nextval into :new.id from dual;
end ;
/



/*按ID(文档打分表)选择相应的订阅信息*/

CREATE or replace PROCEDURE DocMark_SelectById(
    id_1 integer ,	
    flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
    AS
    begin
    open thecursor for
	select * from DocMark where id =  id_1;
end;
/


 /*按(文档的ID)选择相应的打分信息*/

CREATE or replace PROCEDURE DocMark_SelectByDocId(
    docId_1  integer ,	
    flag out 	integer	, 
    msg out	varchar2,
    thecursor IN OUT cursor_define.weavercursor)
    AS
    begin
    open thecursor for
	select * from DocMark where docid =  docId_1;
end;
/

/*对文档打分表表进行插入*/

CREATE or replace PROCEDURE  DocMark_Insert(
    docId_1 integer ,	
    markHrmType_2 integer ,	
    markHrmId_3 integer,
    mark_4 integer,
    remark_5 varchar2,
    markDate_6 char,
    flag out 	integer	, 
    msg out	varchar2,
    thecursor IN OUT cursor_define.weavercursor)
    AS
    begin
	insert into  DocMark(docId,markHrmType,markHrmId,mark,remark,markDate) values (docId_1,markHrmType_2,markHrmId_3,mark_4,remark_5,markDate_6);
    open thecursor for
    select max(id) from  DocMark;
end;
/


 /*对文档打分表表进行修改*/

CREATE or replace PROCEDURE  DocMark_update(
    id_1 integer ,
    docId_2 integer ,	
    markHrmType_3 integer ,	
    markHrmId_4 integer,
    mark_5 integer,
    remark_6 varchar2,
    markDate_7 char,
    flag out 	integer	, 
    msg out	varchar2,
    thecursor IN OUT cursor_define.weavercursor)
    AS
    begin
	update  docmark set docId = docId_2,markHrmType = markHrmType_3,markHrmId = markHrmId_4,mark = mark_5,remark = remark_6,markDate = markDate_7 where id = id_1;
     open thecursor for
    select max(id) from  DocMark;
end;
/


alter table DocSecCategory add  markable char(1)/*增加是否可打分字段　1,可打分 0,不可打分*/
/
alter table DocSecCategory add markAnonymity char(1)/*打分时是否采用匿名　1,采用 0,不采用*/
/


/*更新以下存储过程*/

  CREATE or replace  PROCEDURE Doc_SecCagory_Insert 
  ( subtecagoryid_1 	integer,
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
  markAnonymity_35  char,
  flag out 	integer	, 
  msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor)
  as
  begin
  insert into docseccategory(SUBCATEGORYID,categoryname, docmouldid, publishable, replyable, shareable, cusertype, cuserseclevel, cdepartmentid1, cdepseclevel1, cdepartmentid2, cdepseclevel2, croleid1, crolelevel1, croleid2, crolelevel2, croleid3, crolelevel3, hasaccessory, accessorynum, hasasset, assetlabel, hasitems, itemlabel, hashrmres, hrmreslabel, hascrm, crmlabel, hasproject, projectlabel, hasfinance, financelabel, approveworkflowid,markable,markAnonymity) values( subtecagoryid_1, categoryname_2, docmouldid_3, publishable_4, replyable_5, shareable_6, cusertype_7, cuserseclevel_8, cdepartmentid1_9, cdepseclevel1_10, cdepartmentid2_11, cdepseclevel2_12, croleid1_13, crolelevel1_14, croleid2_15, crolelevel2_16, croleid3_17, crolelevel3_18, hasaccessory_19, accessorynum_20, hasasset_21, assetlabel_22, hasitems_23, itemlabel_24, hashrmres_25, hrmreslabel_26, hascrm_27, crmlabel_28, hasproject_29, projectlabel_30, hasfinance_31, financelabel_32, approveworkflowid_33,markable_34,markAnonymity_35) ;
  open thecursor for
  select max(id) from docseccategory;
end;
/

create or replace  PROCEDURE Doc_SecCagory_Update 
(id_1	integer, 
subcategoryid_2 	integer,
categoryname_3 	varchar2,
docmouldid_3 	integer, 
publishable_4 	char ,
replyable_5 	char ,
shareable_6 	char ,
cusertype_7 	integer,
cuserseclevel_8 	smallint,
cdepartmentid1_9 	integer,
cdepseclevel1_10 	smallint,
cdepartmentid2_11 	integer,
cdepseclevel2_12 	smallint,
croleid1_13	 	integer,
crolelevel1_14	 	char, 
croleid2_15	 	integer, 
crolelevel2_16 	char,
croleid3_17	 	integer,
crolelevel3_18 	char,
hasaccessory_19	 	char,
accessorynum_20	 	smallint, 
hasasset_21		 	char, 
assetlabel_22	 	varchar2,
hasitems_23	 	char , 
itemlabel_24 	varchar2,
hashrmres_25 	char ,
hrmreslabel_26 	varchar2,
hascrm_27	 	char ,
crmlabel_28	 	varchar2,
hasproject_29 	char,
projectlabel_30 	varchar2,
hasfinance_31 	char, 
financelabel_32 	varchar2,
approveworkflowid_33	integer,
markable_34  char ,
markAnonymity_35 char ,
flag out 	integer	, 
msg out	varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update docseccategory set 
subcategoryid=subcategoryid_2,
categoryname=categoryname_3,
docmouldid=docmouldid_3,
publishable=publishable_4,
replyable=replyable_5,
shareable=shareable_6,
cusertype=cusertype_7,
cuserseclevel=cuserseclevel_8,
cdepartmentid1=cdepartmentid1_9,
cdepseclevel1=cdepseclevel1_10, 
cdepartmentid2=cdepartmentid2_11,
cdepseclevel2=cdepseclevel2_12, 
croleid1=croleid1_13,
crolelevel1=crolelevel1_14,
croleid2=croleid2_15,
crolelevel2=crolelevel2_16,
croleid3=croleid3_17, 
crolelevel3=crolelevel3_18,
approveworkflowid=approveworkflowid_33,
hasaccessory=hasaccessory_19, 
accessorynum=accessorynum_20, 
hasasset=hasasset_21, 
assetlabel=assetlabel_22,
hasitems=hasitems_23, 
itemlabel=itemlabel_24,
hashrmres=hashrmres_25, 
hrmreslabel=hrmreslabel_26,
hascrm=hascrm_27,
crmlabel=crmlabel_28,
hasproject=hasproject_29,
projectlabel=projectlabel_30,
hasfinance=hasfinance_31,
financelabel=financelabel_32,
markable=markable_34 ,
markAnonymity=markAnonymity_35 
where id=id_1 ;
end;
/

/*对 docdetail 表 增加三个字段,以便于后面做排序用*/
alter table docdetail add  countMark integer  default 0
/
alter table docdetail add  sumMark integer default 0
/
alter table docdetail add  sumReadCount integer default 0
/

/*对 docdetail 表 countMark sumMark sumReadCount 三个字段进行初始化*/
/*对 docdetail 表 countMark sumMark sumReadCount 三个字段进行初始化*/
create or replace  PROCEDURE initDocdetailMarkRead 
AS
    docid_1 integer;
    countIds_2 integer;
    sumMark_3 integer;
    sumReadCount_4 integer;
    begin
    for mark_cursor in(
    select docid,count(id) as countIds,sum(mark) as sumMark from docmark group by docid )
        loop
        countIds_2 := mark_cursor.countIds;
        docid_1 := mark_cursor.docid;
        sumMark_3 := mark_cursor.sumMark;
        update docdetail set countMark=countIds_2,sumMark=sumMark_3 where id = docid_1;
        end loop; 

    for readtag_cursor in(   
	select docid,sum(readcount) as sumReadCount from docreadtag group by docid )
        loop
            docid_1 := readtag_cursor.docid;
            sumReadCount_4 := readtag_cursor.sumReadCount;
            update docdetail set sumReadCount=sumReadCount_4 where id = docid_1;
        end loop;
end;   
/
call initDocdetailMarkRead ()
/


/*对docReadTag表,建立修改和插入时的trigger*/
CREATE or REPLACE TRIGGER Tri_insert_docreadtag after INSERT or update ON docreadtag
for each row
Declare	
docid_1 integer;
sumreadcount_2 integer;

begin                 
 docid_1 := :new.docid;
 update docdetail set sumreadcount = nvl(sumreadcount,0)+1 where id =docid_1;
end;
/


/*对docmark表,建立修改和插入时的trigger*/
CREATE or REPLACE TRIGGER Tri_U_I_docmark after insert or update  ON docmark
for each row

Declare	
id_1 integer;
docid_2 integer;
markold_3 integer;
marknew_4 integer;
    
    begin
        id_1 := :old.id;
        markold_3 := :old.mark;
        docid_2 := :new.docid;
        marknew_4 := :new.mark;
        if (id_1 is null) /*insert*/   
            then     
                update docdetail set countmark = nvl(countmark,0)+1,summark = nvl(summark,0)+marknew_4 where id=docid_2;        
        else
             update docdetail set summark = summark-markold_3+marknew_4 where  id =docid_2;
        end if;
    end;
/



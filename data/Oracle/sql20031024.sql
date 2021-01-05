create table T_InputReport (
	inprepid integer PRIMARY KEY NOT NULL,     
	inprepname    varchar2(200) ,
	inpreptablename       varchar2(60) ,
	inprepbugtablename	varchar2(60) ,
	inprepfrequence       char(1) ,
	inprepbudget         char(1) 			
)
/

create sequence inputReport_Id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/

CREATE OR REPLACE TRIGGER inputReport_Id_Trigger
	before insert on T_InputReport
	for each row
	begin
	select inputReport_Id.nextval into :new.inprepid from dual;
	end;
/

create table T_InputReportItemtype (
       itemtypeid integer PRIMARY KEY NOT NULL,    
       inprepid              int ,
       itemtypename          varchar2(100),
       itemtypedesc          varchar2(200)
)
/

create sequence inputReportItemtype_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportItemtype_Id_Trigger
	     before insert on T_InputReportItemtype
	     for each row
	     begin
	     select inputReportItemtype_Id.nextval into :new.itemtypeid from dual;
	     end ;
/

create table T_InputReportItem  (
       itemid  integer PRIMARY KEY NOT NULL,     
       inprepid              integer,
       itemtypeid            integer,
       itemdspname           varchar2(60) ,
       itemfieldname         varchar2(60) ,
       itemfieldtype         char(1),
       itemfieldscale       integer,
       itemexcelsheet       varchar2(100),
       itemexcelrow         integer,
       itemexcelcolumn      integer
)
/

create sequence inputReportItem_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportItem_Id_Trigger
	before insert on T_InputReportItem
	for each row
	begin
	select inputReportItem_Id.nextval into :new.itemid from dual;
	end;
       
/

create table T_InputReportItemDetail (
       inprepitemdetailid  integer PRIMARY KEY NOT NULL,     
       itemid       integer,
       itemdsp      varchar2(100) ,
       itemvalue    varchar2(100)
)
/

create sequence inputReportItemDetail_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inprepitemdetailid_Trigger
	before insert on T_InputReportItemDetail
	for each row
	begin
	select inputReportItemDetail_Id.nextval into :new.inprepitemdetailid from dual;
	end;
/

create table T_InputReportCrm (
       inprepcrmid  integer PRIMARY KEY NOT NULL,     
       inprepid     integer,
       crmid        integer 
)
/

create sequence inputReportCrm_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportCrm_Id_Trigger
       before insert on T_InputReportCrm
       for each row
       begin
       select inputReportCrm_Id.nextval into :new.inprepcrmid from dual;
       end;
/

create table T_InputReportConfirm (
       confirmid  integer primary key not null,     
       inprepid              integer ,
       inprepbudget          char(1) ,
       thetable             varchar2(60) ,
       inputid		          integer,
       inprepdspdate        varchar2(80) ,
       crmid                integer,
       confirmuserid        integer
)
/

create sequence inputReportConfirm_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportConfirm_Id_Trigger
       before insert on T_InputReportConfirm
       for each row
       begin
       select inputReportConfirm_Id.nextval into :new.confirmid from dual;
       end;
/

create table T_Condition (
	conditionid  integer primary key not null,     
	conditionname     varchar2(100),
	conditiondesc     varchar2(100),
	conditionitemfieldname       varchar2(60) ,
	conditiontype     char(1) ,
	issystemdef      char(1) default '0'			
)
/

create sequence condition_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER condition_Id_Trigger
       before insert on T_Condition
       for each row
       begin
       select condition_Id.nextval into :new.conditionid from dual;
       end;
/

insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位','基层单位','crm',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('从年','从年','yearf',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('从月','从月','monthf',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('从日','从日','dayf',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('到年','到年','yeart',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('到月','到月','montht',null,'1')
/
insert into T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('到日','到日','dayt',null,'1')
/

create table T_ConditionDetail (
	conditiondetailid  integer primary key not null,     
	conditionid       integer,
	conditiondsp      varchar2(100) ,
	conditionvalue    varchar2(100)
)
/

create sequence conditionDetail_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER conditionDetail_Id_Trigger
       before insert on T_ConditionDetail
	     for each row
	     begin
	     select conditionDetail_Id.nextval into :new.conditiondetailid from dual;
	     end;
/

create table T_OutReport (
       outrepid  integer primary key not null,     
       outrepname    varchar2(200) ,
       outreprow     integer,
       outrepcolumn     integer,
       outrepdesc       varchar2(255)
)
/

create sequence outReport_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReport_Id_Trigger
       before insert on T_OutReport
	     for each row
	     begin
	     select outReport_Id.nextval into :new.outrepid from dual;
	     end;

/

create table T_OutReportCondition (
       outrepconditionid  integer primary key not null,     
       outrepid       integer ,
       conditionid    integer 
)
/

create sequence outReportCondition_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportCondition_Id_Trigger
       before insert on T_OutReportCondition
	     for each row
	     begin
	     select outReportCondition_Id.nextval into :new.outrepconditionid from dual;
	     end;
/

create table T_OutReportShare (
       outrepshareid  integer primary key not null,     
       outrepid       integer ,
       userid         integer ,
       usertype       char(1)				
)
/

create sequence outReportShare_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportShare_Id_Trigger
       before insert on T_OutReportShare
	     for each row
	     begin
	     select outReportShare_Id.nextval into :new.outrepshareid from dual;
	     end;
/

create table T_OutReportItem (
       itemid  integer primary key not null,    
       outrepid     integer ,
       itemrow      integer ,
       itemcolumn   integer ,
       itemtype char(1) ,
       picstat       char(1) default 0 ,
       itemexpress   varchar2(4000) ,
       itemtable    varchar2(4000) ,
       itemcondition  varchar2(4000)
)
/

create sequence outReportItem_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportItem_Id_Trigger
       before insert on T_OutReportItem
	     for each row
	     begin
	     select outReportItem_Id.nextval into :new.itemid from dual;
	     end;       
/

create table T_OutReportItemTable (
       itemtableid  integer primary key not null,     
       itemid     integer ,
       itemtable   varchar2(60) ,
       itemtablealter  varchar2(20) 
)
/

create sequence outReportItemTable_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportItemTable_Id_Trigger
       before insert on T_OutReportItemTable
	     for each row
	     begin
	     select outReportItemTable_Id.nextval into :new.itemtableid from dual;
	     end;
/

create table T_OutReportItemCondition (
       itemconditionid  integer primary key not null,     
       itemid     integer ,
       conditionid   integer ,
       conditionvalue  varchar2(100) 
)
/

create sequence outReportItemCondition_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportItemCId_Trigger
       before insert on T_OutReportItemCondition
	     for each row
	     begin
	     select outReportItemCondition_Id.nextval into :new.itemconditionid from dual;
	     end;
/

alter table T_OutReportItem add itemdesc varchar2(200)
/
alter table T_OutReportItem add itemexpresstype char(1)            
/
alter table T_OutReportItem add picstatbudget char(1)             
/
alter table T_OutReportItem add picstatlast char(1)             
/

create table T_OutReportItemCoordinate  (
       itemcoordinateid integer primary key not null,     
       itemid     integer ,
       coordinatename   varchar2(100) ,
       coordinatevalue  varchar2(100) 
)
/

create sequence outReportItemCoordinate_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportICoordinate_Trigger
       before insert on T_OutReportItemCoordinate
	     for each row
	     begin
	     select outReportItemCoordinate_Id.nextval into :new.itemcoordinateid from dual;
	     end;
/

alter table T_InputReport add inprepbudgetstatus char(1) default '1'    
/

CREATE OR REPLACE PROCEDURE T_InputReport_SelectAll(
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor  
) 
AS 
  begin
     open thecursor for
     select * from T_InputReport;
  end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_SelectByInprepid(
  inprepid_1  integer ,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor  
) 
AS 
  begin
    open thecursor for
    select * from T_InputReport where inprepid = inprepid_1;
  end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_Insert(
   inprepname_1 	varchar2,
   inpreptablename_2 	varchar2,
   inprepbugtablename_3 	varchar2,
   inprepfrequence_4 	char,
   inprepbudget_5 	char,
   flag out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor  
)
AS 
 begin 
   INSERT INTO T_InputReport( 
     inprepname,
     inpreptablename,
     inprepbugtablename,
     inprepfrequence,
     inprepbudget
     ) 
   VALUES( 
     inprepname_1,
     inpreptablename_2,
     inprepbugtablename_3,
     inprepfrequence_4,
     inprepbudget_5
     );
end;   
/

CREATE OR REPLACE PROCEDURE T_InputReport_Update(
   inprepid_1 	integer,
   inprepname_2 	varchar2,
   inpreptablename_3 	varchar2,
   inprepbugtablename_4 	varchar2,
   inprepfrequence_5 	char,
   inprepbudget_6 	char,
   flag out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor  
)
AS 
begin
  UPDATE T_InputReport 
  SET  
    inprepname	= inprepname_2,
    inpreptablename = inpreptablename_3,
    inprepbugtablename = inprepbugtablename_4,
    inprepfrequence = inprepfrequence_5,
    inprepbudget = inprepbudget_6 
  WHERE(inprepid = inprepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_Delete(
   inprepid_1 integer,
   flag out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
   DELETE T_InputReport WHERE(inprepid = inprepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_IRItemtype_SelectByInprepid(
  inprepid_1  integer,
  flag out integer, 
  msg out varchar2,	
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select * from T_InputReportItemtype where inprepid = inprepid_1;
end;  
/

CREATE OR REPLACE PROCEDURE T_IRIT_SelectByItemtypeid(
  itemtypeid_1  integer,
  flag out integer, 
  msg out varchar2,	
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select * from T_InputReportItemtype where itemtypeid = itemtypeid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Insert(
   inprepid_1 integer,
   itemtypename_2 varchar2,
   itemtypedesc_3 varchar2,
   flag	out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  INSERT INTO T_InputReportItemtype( 
    inprepid,
    itemtypename,
    itemtypedesc
  ) 
  VALUES(
    inprepid_1,
    itemtypename_2,
    itemtypedesc_3
  );
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Update(
   itemtypeid_1 integer,
   itemtypename_2 varchar2,
   itemtypedesc_3 varchar2,
   flag	out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  UPDATE T_InputReportItemtype 
  SET  
   itemtypename	= itemtypename_2,
   itemtypedesc = itemtypedesc_3 
  WHERE(itemtypeid = itemtypeid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Delete(
  itemtypeid_1 	integer,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  DELETE T_InputReportItemtype WHERE (itemtypeid = itemtypeid_1);
  DELETE T_InputReportItem WHERE (itemtypeid = itemtypeid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_IRItem_SelectByInprepid(
  inprepid_1 integer,
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
begin
  open thecursor for
  select * from T_InputReportItem where inprepid = inprepid_1;
end;
/

CREATE  OR REPLACE PROCEDURE T_IRItem_SelectByItemtypeid(
  itemtypeid_1 integer,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
  open thecursor for 
  select * from T_InputReportItem where itemtypeid = itemtypeid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_IReportItem_SelectByItemid(
  itemid_1 integer,
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
begin
  open thecursor for
  select * from T_InputReportItem where itemid = itemid_1;
end; 
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Insert(
   inprepid_1 	integer,
   itemdspname_2 	varchar2,
   itemfieldname_3 	varchar2,
   itemfieldtype_4 	char,
   itemfieldscale_5 	integer,
   itemtypeid_6 	integer,
   itemexcelsheet_7 	varchar2,
   itemexcelrow_8 	integer,
   itemexcelcolumn_9 	integer,
   flag	out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  INSERT INTO T_InputReportItem ( 
    inprepid,
    itemdspname,
    itemfieldname,
    itemfieldtype,
    itemfieldscale,
    itemtypeid,
    itemexcelsheet,
    itemexcelrow,
    itemexcelcolumn) 
  VALUES( 
   inprepid_1,
   itemdspname_2,
   itemfieldname_3,
   itemfieldtype_4,
   itemfieldscale_5,
   itemtypeid_6,
   itemexcelsheet_7,
   itemexcelrow_8,
   itemexcelcolumn_9);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Update(
   itemid_1 integer,
   itemdspname_2 	varchar2,
   itemfieldname_3 	varchar2,
   itemfieldtype_4 	char,
   itemfieldscale_5 	integer,
   itemtypeid_6 	integer,
   itemexcelsheet_7 	varchar2,
   itemexcelrow_8 	integer,
   itemexcelcolumn_9 	integer ,
   flag	out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   UPDATE T_InputReportItem 
   SET  itemdspname = itemdspname_2,
	 itemfieldname = itemfieldname_3,
	 itemfieldtype	= itemfieldtype_4,
	 itemfieldscale	= itemfieldscale_5,
	 itemtypeid = itemtypeid_6,
	 itemexcelsheet	 = itemexcelsheet_7,
	 itemexcelrow = itemexcelrow_8,
	 itemexcelcolumn = itemexcelcolumn_9 
   WHERE(itemid	= itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Delete(
  itemid_1 	integer,
	flag	out integer,
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
begin
  DELETE T_InputReportItem WHERE(itemid	= itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_IRItemDetail_SelectByItemid(
  itemid_1  integer ,
	flag	out integer, 
	msg	out varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
  open thecursor for
  select * from T_InputReportItemDetail where itemid = itemid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemDetail_Insert(
   itemid_1 	integer,
	 itemdsp_2 	varchar2,
	 itemvalue_3 	varchar2 ,
	 flag	out integer, 
	 msg out	varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  INSERT INTO T_InputReportItemDetail (itemid,itemdsp,itemvalue)VALUES (itemid_1,itemdsp_2,itemvalue_3);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemDetail_Delete(
  itemid_1 	integer ,
	flag out integer , 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
   DELETE T_InputReportItemDetail WHERE(itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_IReportCrm_SelectByInprepid(
  inprepid_1  integer,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select * from T_InputReportCrm where inprepid = inprepid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportCrm_Insert(
   inprepid_1 integer,
	 crmid_2 	integer,
	 flag	out integer, 
	 msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   INSERT INTO T_InputReportCrm(inprepid,crmid) VALUES (inprepid_1,crmid_2);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportCrm_Delete(
  inprepcrmid_1 integer ,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
  DELETE T_InputReportCrm WHERE (inprepcrmid = inprepcrmid_1);
end;  
/

CREATE OR REPLACE PROCEDURE T_InputReport_SelectByCrmid(
  crmid_1  integer ,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   open thecursor for
   select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b where a.inprepid = b.inprepid and b.crmid = crmid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportConfirm_Insert(
   inprepid_1 	integer,
	 inprepbudget_2 	char,
	 thetable_2 	varchar2,
	 inputid_3      integer,
	 inprepdspdate_3 	varchar2,
	 crmid_4 	integer,
	 confirmuserid_5 integer,
	 flag	out integer, 
	 msg out	varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   INSERT INTO T_InputReportConfirm (inprepid,inprepbudget,thetable ,inputid ,inprepdspdate,crmid,confirmuserid) 
   VALUES (inprepid_1,inprepbudget_2,thetable_2 ,inputid_3 ,inprepdspdate_3,crmid_4,confirmuserid_5);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportConfirm_Delete(
        confirmid_1 integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   DELETE T_InputReportConfirm WHERE (confirmid	= confirmid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_IRConfirm_SelectByUserid(
  confirmuserid_1  integer ,
	flag out integer, 
	msg	out varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select b.confirmid ,b.inputid ,a.inprepname ,b.inprepdspdate, b.inprepbudget , b.crmid ,b.thetable 
  from T_InputReport a, T_InputReportConfirm b 
  where a.inprepid = b.inprepid and b.confirmuserid = confirmuserid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_IRConfirm_SelectByConfirmid(
  confirmid_1  integer ,
	flag out	integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select b.* , a.inprepname from T_InputReport a,  T_InputReportConfirm b 
  where a.inprepid = b.inprepid and confirmid = confirmid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_Condition_SelectAll(
   flag	out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   open thecursor for
   select * from T_Condition;
end;
/

CREATE OR REPLACE PROCEDURE T_CT_SelectByConditionid(
  conditionid_1 integer,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_Condition where conditionid = conditionid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_CDetail_SelectByConditionid(
  conditionid_1  integer,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_ConditionDetail where conditionid = conditionid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_Condition_Insert(
         conditionname_1 	varchar2,
	 conditiondesc_2 	varchar2,
	 conditionitemfieldname_3 	varchar2,
	 conditiontype_4 	char ,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_Condition (conditionname,conditiondesc,conditionitemfieldname,conditiontype) 
VALUES (conditionname_1,conditiondesc_2,conditionitemfieldname_3,conditiontype_4);
end;
/

CREATE OR REPLACE PROCEDURE T_Condition_Update(
         conditionid_1 	integer,
	 conditionname_2  varchar2,
	 conditiondesc_3  varchar2,
	 conditionitemfieldname_4  varchar2,
	 conditiontype_5  char,
	 flag	out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
UPDATE T_Condition 
SET conditionname = conditionname_2,
    conditiondesc = conditiondesc_3,
    conditionitemfieldname = conditionitemfieldname_4,
    conditiontype = conditiontype_5 
WHERE(conditionid = conditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_Condition_Delete(
         conditionid_1 	integer ,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE T_Condition WHERE(conditionid = conditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_ConditionDetail_Insert(
         conditionid_1 	integer,
	 conditiondsp_2  varchar2,
	 conditionvalue_3  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO T_ConditionDetail(conditionid,conditiondsp,conditionvalue)  
VALUES(conditionid_1,conditiondsp_2,conditionvalue_3);
end;
/

CREATE OR REPLACE PROCEDURE T_ConditionDetail_Delete(
         conditionid_1 	integer ,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE T_ConditionDetail WHERE(conditionid = conditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_SelectAll(
        flag out integer, 
	msg out	varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReport;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_SelectByOutrepid(
        outrepid integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReport where outrepid = outrepid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRC_SelectByOutrepid(
        outrepid integer ,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReportCondition where outrepid = outrepid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRShare_SelectByOutrepid(
        outrepid integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReportShare where outrepid = outrepid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Insert(
         outrepname_1 	varchar2,
	 outreprow_2 	integer,
	 outrepcolumn_3 integer,
	 outrepdesc_4 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS
begin
INSERT INTO T_OutReport (outrepname,outreprow,outrepcolumn,outrepdesc) 
VALUES (outrepname_1,outreprow_2,outrepcolumn_3,outrepdesc_4);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Update(
         outrepid_1 	integer,
	 outrepname_2 	varchar2,
	 outrepdesc_3 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	= outrepname_2,outrepdesc = outrepdesc_3 WHERE(outrepid	= outrepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Delete(
        outrepid_1 integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE T_OutReport WHERE (outrepid = outrepid_1);
DELETE T_OutReportCondition WHERE (outrepid = outrepid_1);
DELETE T_OutReportShare WHERE (outrepid	= outrepid_1);
DELETE T_OutReportItem WHERE (outrepid = outrepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportCondition_Insert(
        outrepid_1 	integer,
	conditionid_2 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO T_OutReportCondition(outrepid,conditionid)VALUES (outrepid_1,conditionid_2);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportCondition_Delete(
        outrepconditionid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE T_OutReportCondition WHERE(outrepconditionid = outrepconditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportShare_Insert(
        outrepid_1 	integer,
	userid_2 	integer,
	usertype_3 	char ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO T_OutReportShare(outrepid,userid,usertype) VALUES (outrepid_1,userid_2,usertype_3);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportShare_Delete(
        outrepshareid_1 integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE T_OutReportShare WHERE(outrepshareid = outrepshareid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_SelectByRowCol(
        outrepid integer ,
	itemrow integer,
	itemcolumn integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where outrepid = outrepid and itemrow = itemrow and itemcolumn= itemcolumn;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItem_SelectByOutrepid(
        outrepid integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where outrepid = outrepid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_SelectByItemid(
        itemid integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where itemid = itemid; 
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByRowCol(
  outrepid integer ,
	itemrow integer,
	itemcolumn integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS
itemid integer;
begin
select itemid into itemid from T_OutReportItem where outrepid = outrepid and itemrow = itemrow and itemcolumn= itemcolumn;
delete T_OutReportItem where itemid = itemid;
delete T_OutReportItemTable where itemid = itemid;
delete T_OutReportItemCondition where itemid = itemid;
delete T_OutReportItemCoordinate where itemid = itemid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByRow(
        outrepid integer,
	      itemrow integer,
	      flag out integer, 
	      msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
itemid integer;
begin
 for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid and itemrow = itemrow)
 loop
   itemid := itemid_cursor.itemid; 
	 delete T_OutReportItem where itemid = itemid;
	 delete T_OutReportItemTable where itemid = itemid;
	 delete T_OutReportItemCondition where itemid = itemid;
	 delete T_OutReportItemCoordinate where itemid = itemid;
 end loop;
end; 
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByCol(
  outrepid integer,
	itemcolumn integer ,
	flag	out integer,
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
itemid integer;
begin
  for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid and itemcolumn= itemcolumn)
  loop
    itemid := itemid_cursor.itemid;
	  delete T_OutReportItem where itemid = itemid;
	  delete T_OutReportItemTable where itemid = itemid;
	  delete T_OutReportItemCondition where itemid = itemid;
	  delete T_OutReportItemCoordinate where itemid = itemid;
  end loop;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItemTable_SelectByItemid(
        itemid integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItemTable where itemid = itemid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRICondition_SByItemid(
        itemid integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
open thecursor for
select * from T_OutReportItemCondition where itemid = itemid;
end;

/
CREATE OR REPLACE PROCEDURE T_OutReportItemTable_Insert(
     itemid_1 	integer,
     itemtable     varchar2,
     itemtablealter  varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)VALUES(itemid_1,itemtable,itemtablealter);
end;

/
CREATE OR REPLACE PROCEDURE T_OutRItemCondition_Insert(
        itemid_1 	integer,
	conditionid     integer,
	conditionvalue  varchar2,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)VALUES(itemid_1,conditionid,conditionvalue);
end;

/
CREATE OR REPLACE PROCEDURE T_OutReportItem_Insert(
   itemid_1 	integer,
	 outrepid_2 	integer,
	 itemrow_2 	integer,
	 itemcolumn_2 	integer,
	 itemtype       char,
	 itemexpress    varchar2,
	 itemdesc       varchar2,
	 itemexpresstype char,
	 picstatbudget  char,
	 picstatlast   char,
	 picstat       char,
	 flag	out integer,
	 msg out	varchar2,
   thecursor IN OUT cursor_define.weavercursor
)
AS
itemid_temp integer;
begin
if itemid_1 = 0 then
   insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition)
       values(outrepid_2,itemrow_2,itemcolumn_2,itemtype,itemexpress ,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,'','');
   select max(itemid) into itemid_temp from T_OutReportItem;
else
   update T_OutReportItem
      set itemtype = itemtype,itemexpress = itemexpress,itemdesc = itemdesc,itemexpresstype = itemexpresstype,picstatbudget = picstatbudget,picstatlast = picstatlast, picstat = picstat, itemtable = '',itemcondition = ''
      where itemid = itemid_temp;
end if;
DELETE T_OutReportItemTable WHERE  (itemid	= itemid_temp);
DELETE T_OutReportItemCondition WHERE  (itemid	= itemid_temp);
DELETE T_OutReportItemCoordinate WHERE  (itemid	= itemid_temp);
end;


/
CREATE OR REPLACE PROCEDURE T_OutReportItem_Copy(
   outrepid_2 	integer,
	 itemrow_2 	integer,
	 itemcolumn_2 	integer,
	 fromitemrow_2      integer,
	 fromitemcolumn_2    integer,
	 flag	out integer,
	 msg out	varchar2,
   thecursor IN OUT cursor_define.weavercursor
)
AS
itemid integer;
itemid1 integer;
itemtype char(1);
begin
  open thecursor for
  select itemid into itemid from T_OutReportItem where itemrow = fromitemrow_2 and itemcolumn = fromitemcolumn_2 and outrepid = outrepid_2;
  select itemtype into itemtype from T_OutReportItem where itemrow = fromitemrow_2 and itemcolumn = fromitemcolumn_2 and outrepid = outrepid_2;
 
  if itemid is null then
    return;
  end if;

  select itemid1 into itemid
  from T_OutReportItem
  where itemrow = itemrow_2 and itemcolumn = itemcolumn_2 and outrepid = outrepid_2;

  if itemid1 is not null then
    delete T_OutReportItem where itemid = itemid1;
    delete T_OutReportItemTable where itemid = itemid1;
    delete T_OutReportItemCondition where itemid = itemid1;
    delete T_OutReportItemCoordinate where itemid = itemid1;
  end if;

  insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemtable,itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat)
    select outrepid,itemrow_2,itemcolumn_2,itemtype,itemexpress,itemtable,itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat
    from T_OutReportItem where itemid = itemid;

  if itemtype = '2' then
	   select max(itemid) into itemid1 from T_OutReportItem;

	   insert into T_OutReportItemTable(itemid,itemtable,itemtablealter)
      select itemid1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid;

	   insert into T_OutReportItemCondition(itemid,conditionid,conditionvalue)
      select itemid1, conditionid, conditionvalue from T_OutReportItemCondition where itemid = itemid;

	   insert into T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue)
      select itemid1, coordinatename, coordinatevalue from T_OutReportItemCoordinate where itemid = itemid;
   end if;
end;

/
CREATE OR REPLACE PROCEDURE T_OutReportItemTable_Delete(
        itemid 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE T_OutReportItemTable WHERE(itemid = itemid);
end;

/
CREATE OR REPLACE PROCEDURE T_OutRItemCondition_Delete(
        itemid  integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
DELETE T_OutReportItemCondition WHERE(itemid = itemid);
end;

/
CREATE OR REPLACE PROCEDURE T_OutReportItem_Delete(
        itemid 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
delete T_OutReportItem where itemid = itemid;
delete T_OutReportItemTable where itemid = itemid;
delete T_OutReportItemCondition where itemid = itemid;
delete T_OutReportItemCoordinate where itemid = itemid;
end;

/
CREATE OR REPLACE PROCEDURE T_OutReport_SelectByUserid(
        userid integer ,
	usertype char,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS
begin
open thecursor for
select a.* from T_OutReport a, T_OutReportShare b
where a.outrepid = b.outrepid and b.userid=userid and b.usertype = usertype;
end;

/
CREATE OR REPLACE PROCEDURE T_OutRItemCoordinate_Delete(
        itemid 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE T_OutReportItemCoordinate WHERE (itemid = itemid);
end;

/
CREATE OR REPLACE PROCEDURE T_OutRICdinate_SelectByItemid(
        itemid integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
open thecursor for
select * from T_OutReportItemCoordinate where itemid = itemid ;
end;

/
CREATE OR REPLACE PROCEDURE T_OutReportICoordinate_Insert(
         itemid_1 	integer,
	 coordinatename     varchar2,
	 coordinatevalue  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemCoordinate (itemid,coordinatename,coordinatevalue)VALUES (itemid_1,coordinatename,coordinatevalue);
end;

/
alter table T_InputReportItem add itemfieldunit varchar2(60)
/
alter table T_InputReportItem add dsporder integer

/
CREATE OR REPLACE PROCEDURE T_InputReportItem_Insert(
         inprepid_1 	integer,
	 itemdspname_2 	varchar2,
	 itemfieldname_3 	varchar2,
	 itemfieldtype_4 	char,
	 itemfieldscale_5 	integer,
	 itemtypeid_6 	        integer,
	 itemexcelsheet_7 	varchar2,
	 itemexcelrow_8 	integer,
	 itemexcelcolumn_9 	integer ,
	 itemfieldunit   varchar2,
	 dsporder               integer,
	 flag out integer, 
	 msg	varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
INSERT INTO T_InputReportItem(
	inprepid,
	itemdspname,
	itemfieldname,
	itemfieldtype,
	itemfieldscale,
	itemtypeid,
	itemexcelsheet,
	itemexcelrow,
	itemexcelcolumn,
	itemfieldunit,
	dsporder
) 
VALUES(
	inprepid_1,
	itemdspname_2,
	itemfieldname_3,
	itemfieldtype_4,
	itemfieldscale_5,
	itemtypeid_6,
	itemexcelsheet_7,
	itemexcelrow_8,
	itemexcelcolumn_9,
	itemfieldunit,
	dsporder
);
end;

/
CREATE OR REPLACE PROCEDURE T_InputReportItem_Update(
         itemid_1 	integer,
	 itemdspname_2 	varchar2,
	 itemfieldname_3 	varchar2,
	 itemfieldtype_4 	char,
	 itemfieldscale_5 	integer,
	 itemtypeid_6 	        integer,
	 itemexcelsheet_7 	varchar2,
	 itemexcelrow_8 	integer,
	 itemexcelcolumn_9 	integer,
	 itemfieldunit          varchar2,
	 dsporder               integer,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
UPDATE T_InputReportItem 
SET      itemdspname	= itemdspname_2,
         itemfieldname	 = itemfieldname_3,
	 itemfieldtype	 = itemfieldtype_4,
	 itemfieldscale	 = itemfieldscale_5,
	 itemtypeid	 = itemtypeid_6,
	 itemexcelsheet	 = itemexcelsheet_7,
	 itemexcelrow	 = itemexcelrow_8,
	 itemexcelcolumn = itemexcelcolumn_9,
	 itemfieldunit = itemfieldunit ,
	 dsporder = dsporder 
WHERE(itemid = itemid_1);
end;

/
CREATE OR REPLACE PROCEDURE T_IRItem_SelectByItemtypeid(
  itemtypeid_1 integer,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
  open thecursor for 
  select * from T_InputReportItem where itemtypeid = itemtypeid_1 order by dsporder ;
end;
/

alter table T_OutReportItem add itemmodtype char(1)             
/
update T_OutReportItem set itemmodtype = '0'
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('修正','修正','modify',null,'1')

/
create table T_InputReportItemClose (
closeid  integer primary key not null,   
inprepid    integer ,
itemid     integer ,   
crmid    integer
)
/
create sequence inputReportItemClose_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER inputRItemClose_Id_Trigger
	before insert on T_InputReportItemClose
	for each row
	begin
	select inputReportItemClose_Id.nextval into :new.closeid from dual;
	end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_Insert(
         itemid_1 	integer,
      	 outrepid_2 	integer,
      	 itemrow_2 	integer,
      	 itemcolumn_2 	integer,
      	 itemtype       char,
      	 itemexpress    varchar2,
      	 itemdesc       varchar2,
      	 itemexpresstype char,
      	 picstatbudget char,
      	 picstatlast   char,
      	 picstat       char,
      	 itemmodtype    char,
      	 flag out integer,
      	 msg out varchar2,
      	 thecursor IN OUT cursor_define.weavercursor
)
AS
itemid_temp integer;
begin
itemid_temp:=itemid_1;
if itemid_temp = 0 then
  insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition,itemmodtype)
    values(outrepid_2,itemrow_2,itemcolumn_2,itemtype,itemexpress,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat,'','',itemmodtype);
  select  max(itemid) into itemid_temp from T_OutReportItem;
 
else
  update T_OutReportItem
    set  itemtype = itemtype,
      	 itemexpress = itemexpress,
      	 itemdesc = itemdesc,
      	 itemexpresstype = itemexpresstype,
      	 picstatbudget = picstatbudget,
      	 picstatlast = picstatlast,
      	 picstat = picstat,
      	 itemtable = '',
      	 itemcondition = '',
      	 itemmodtype = itemmodtype
    where itemid = itemid_temp;
end if;

DELETE T_OutReportItemTable WHERE  (itemid = itemid_temp);
DELETE T_OutReportItemCondition WHERE  (itemid	= itemid_temp);
DELETE T_OutReportItemCoordinate WHERE  (itemid = itemid_temp);
end;


/
CREATE OR REPLACE PROCEDURE T_InputReportItemClose_Insert(
         inprepid_1 	integer,
	 itemid_2 	integer,
	 crmid_3 	integer ,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_InputReportItemClose(inprepid,itemid,crmid)VALUES(inprepid_1,itemid_2,crmid_3);
end;

/
CREATE OR REPLACE PROCEDURE T_InputReportItemClose_Delete(
        closeid_1 	integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
DELETE T_InputReportItemClose WHERE(closeid = closeid_1);
end;

/
alter table T_InputReport add inprepforecast char(1) default '0'           
/
update T_InputReport set inprepforecast='0'
/
CREATE OR REPLACE PROCEDURE T_InputReport_Insert(
         inprepname_1 	varchar2,
	 inpreptablename_2 	varchar2,
	 inprepbugtablename_3 	varchar2,
	 inprepfrequence_4 	char,
	 inprepbudget_5 	char,
	 inprepforecast	char,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_InputReport (inprepname,inpreptablename,inprepbugtablename,inprepfrequence,inprepbudget,inprepforecast) 
VALUES(inprepname_1,inpreptablename_2,inprepbugtablename_3,inprepfrequence_4,inprepbudget_5,inprepforecast);
end;

/
CREATE OR REPLACE PROCEDURE T_InputReport_Update(
         inprepid_1 integer,
	 inprepname_2 	varchar2,
	 inpreptablename_3 	varchar2,
	 inprepbugtablename_4 	varchar2,
	 inprepfrequence_5 	char,
	 inprepbudget_6 	char,
	 inprepforecast	char,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
UPDATE T_InputReport 
SET  inprepname	 = inprepname_2,
	 inpreptablename	 = inpreptablename_3,
	 inprepbugtablename	 = inprepbugtablename_4,
	 inprepfrequence	 = inprepfrequence_5,
	 inprepbudget	 = inprepbudget_6 ,
	 inprepforecast	 = inprepforecast 
WHERE(inprepid = inprepid_1);
end;

/
create table T_OutReportItemRow (
row_id  integer primary key not null,    
outrepid     integer,
itemrow      integer 
)
/
create sequence outReportItemRow_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER outReportItemRow_Id_Trigger
	before insert on T_OutReportItemRow
	for each row
	begin
	select outReportItemRow_Id.nextval into :new.row_id from dual;
	end;
/

create table T_DatacenterUser (
id integer primary key not null,    
crmid  integer,
contacterid integer ,
loginid  varchar2(60),
password varchar2(60),
status   char(1)
)
/
create sequence datacenterUser_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER datacenterUser_Id_Trigger
	before insert on T_DatacenterUser
	for each row
	begin
	select datacenterUser_Id.nextval into :new.id from dual;
	end;

/
CREATE OR REPLACE PROCEDURE T_DatacenterUser_Insert(
         crmid_1 	integer,
	 contacterid_2 	integer,
	 loginid_3 	varchar2,
	 password_4 	varchar2,
	 status_5 	char,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_DatacenterUser(crmid,contacterid,loginid,password,status) 
 VALUES (crmid_1,contacterid_2,loginid_3,password_4,status_5);
end;

/
CREATE OR REPLACE PROCEDURE T_DatacenterUser_Delete(
         flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE T_DatacenterUser;
end;

/
alter table T_InputReportConfirm add reportuserid integer

/
CREATE OR REPLACE PROCEDURE T_InputReportConfirm_Insert(
         inprepid_1 	integer,
	 inprepbudget_2 	char,
	 thetable_2 	varchar2,
	 inputid_3      integer ,
	 inprepdspdate_3 	varchar2,
	 crmid_4 	integer,
	 confirmuserid_5 	integer ,
         reportuserid_6 	integer ,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
INSERT INTO T_InputReportConfirm(inprepid,inprepbudget,thetable ,inputid ,inprepdspdate,crmid,confirmuserid,reportuserid) 
  VALUES (inprepid_1,inprepbudget_2,thetable_2 ,inputid_3 ,inprepdspdate_3,crmid_4,confirmuserid_5,reportuserid_6);
end;

/
CREATE OR REPLACE PROCEDURE T_IReportConfirm_SelectByCrmid(
        crmid_1  integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
open thecursor for
select b.* ,a.inprepname from T_InputReport a, T_InputReportConfirm b 
where a.inprepid = b.inprepid and b.crmid = crmid_1;
end;

/
alter table T_InputReport add startdate char(10)
/
alter table T_InputReport add enddate char(10)
/

update T_InputReport set startdate = '',enddate = ''
/

CREATE OR REPLACE PROCEDURE T_InputReport_Insert(
         inprepname_1 	varchar2,
	 inpreptablename_2 	varchar2,
	 inprepbugtablename_3 	varchar(60),
	 inprepfrequence_4 	char,
	 inprepbudget_5 	char,
	 inprepforecast_6	char,
         startdate_7	char,
         enddate_8	char,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_InputReport(inprepname,inpreptablename,inprepbugtablename,inprepfrequence,inprepbudget,inprepforecast,startdate,enddate) 
  VALUES(inprepname_1,inpreptablename_2,inprepbugtablename_3,inprepfrequence_4,inprepbudget_5,inprepforecast_6,startdate_7,enddate_8);
end;

/
CREATE OR REPLACE PROCEDURE T_InputReport_Update(
         inprepid_1 	integer,
	 inprepname_2 	varchar2,
	 inpreptablename_3 	varchar2,
	 inprepbugtablename_4 	varchar2,
	 inprepfrequence_5 	char,
	 inprepbudget_6 	char,
	 inprepforecast_7	char,
         startdate_8	char,
         enddate_9	char,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
UPDATE T_InputReport 
SET       inprepname = inprepname_2,
	 inpreptablename = inpreptablename_3,
	 inprepbugtablename = inprepbugtablename_4,
	 inprepfrequence = inprepfrequence_5,
	 inprepbudget = inprepbudget_6 ,
	 inprepforecast	 = inprepforecast_7 , 
         startdate = startdate_8 , 
         enddate = enddate_9  
WHERE(inprepid = inprepid_1);
end;

/
CREATE OR REPLACE PROCEDURE T_InputReport_SelectByCrmid(
        crmid_1  integer ,
        currentdate_2 char,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
open thecursor for
select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b 
where a.inprepid = b.inprepid and b.crmid = crmid_1 and 
(a.startdate = '' or a.startdate is null or a.startdate <= currentdate_2 ) and 
(a.enddate = '' or a.enddate is null or a.enddate >= currentdate_2 );
end;

/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位1','基层单位1','crm1',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位2','基层单位2','crm2',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位3','基层单位3','crm3',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位4','基层单位4','crm4',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位5','基层单位5','crm5',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位6','基层单位6','crm6',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位7','基层单位7','crm7',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位8','基层单位8','crm8',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位9','基层单位9','crm9',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('基层单位10','基层单位10','crm10',null,'1')

/
CREATE OR REPLACE PROCEDURE T_OutReport_Copy(
  outrepid_1 	integer,
	flag out integer,
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
    newoutrepid_1 integer;
    itemid_1 integer;
    newitemid_1 integer;
begin

   INSERT INTO T_OutReport(outrepname,outreprow,outrepcolumn,outrepdesc)
   (select concat('复制_',outrepname),outreprow,outrepcolumn,outrepdesc from T_OutReport where outrepid = outrepid_1);

   select max(outrepid) into newoutrepid_1 from T_OutReport;

   INSERT INTO T_OutReportCondition(outrepid,conditionid)
    (select newoutrepid_1,conditionid from T_OutReportCondition where outrepid = outrepid_1);

   INSERT INTO T_OutReportShare(outrepid,userid,usertype)
    (select newoutrepid_1,userid,usertype from T_OutReportShare where outrepid = outrepid_1);

   INSERT INTO T_OutReportItemRow(outrepid,itemrow)
    (select newoutrepid_1,itemrow from T_OutReportItemRow where outrepid = outrepid_1);

   for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1) 
     loop
       itemid_1 := itemid_cursor.itemid;
       INSERT INTO T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
          itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype)
       (select newoutrepid_1,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
          itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype
       from T_OutReportItem where itemid = itemid_1);

       select max(itemid) into newitemid_1 from T_OutReportItem;

       INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)
       (select newitemid_1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid_1);

       INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)
       (select newitemid_1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid_1);

       INSERT INTO T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue)
       (select newitemid_1,coordinatename,coordinatevalue from T_OutReportItemCoordinate where itemid = itemid_1) ;
      end loop;
end;


/

create table T_InputReportCrmContacter (
       inprepcontacterid  integer  primary key not null,     
       inprepcrmid  integer ,
       contacterid  integer 
)
/
create sequence inputReportCrmContacter_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER inputRCrmContacter_Id_Trigger
	before insert on T_InputReportCrmContacter
	for each row
	begin
	select inputReportCrmContacter_Id.nextval into :new.inprepcontacterid from dual;
	end;
/
create OR REPLACE PROCEDURE T_IReport_SelectByContacterid(
  contacter_1  integer ,
  currentdate_2 char,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
  open thecursor for
  select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b , T_InputReportCrmContacter c 
  where a.inprepid = b.inprepid and b.inprepcrmid = c.inprepcrmid and c.contacterid = contacter_1 
  and (a.startdate = '' or a.startdate is null or a.startdate <= currentdate_2 ) 
  and (a.enddate = '' or a.enddate is null or a.enddate >= currentdate_2 );
end;

/

insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('分别汇总','分别汇总','isonebyone',null,'1')
/


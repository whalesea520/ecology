delete workflow_browserurl where id in(226,227)
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 226,30312,'varchar2(1000)','/systeminfo/BrowserMain.jsp?url=/integration/sapSingleBrowser.jsp','','','','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 227,30313,'varchar2(1000)','/systeminfo/BrowserMain.jsp?url=/integration/sapMutilBrowser.jsp','','','','')
/
create table int_serviceCompParamsList
(
	id	integer primary key not null, 
	servId    integer not null, 
	paramID integer not null,
	paramDesc varchar2(200),
	paramName varchar2(200)
)
/
create sequence sq_int_serviceCompParamsList
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_serviceCompParamsList
before insert on int_serviceCompParamsList
for each row
begin
select sq_int_serviceCompParamsList.nextval into :new.id from dual;
end;
/
create table int_serviceParamMode
(
	id	integer primary key not null, 
	sid	integer not null,
	servId    integer not null,
	paramModeName varchar2(200)
)
/
create sequence sq_int_serviceParamMode
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_serviceParamMode
before insert on int_serviceParamMode
for each row
begin
select sq_int_serviceParamMode.nextval into :new.id from dual;
end;
/
create table int_serviceParams
(
	id	integer primary key not null, 
	servId    integer not null,
	paramType varchar2(200),
	paramDesc varchar2(200),
	paramName varchar2(200),
	isCompSty char(1),
	compStyTypeName varchar2(200)
)
/
create sequence sq_int_serviceParams
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_serviceParams
before insert on int_serviceParams
for each row
begin
select sq_int_serviceParams.nextval into :new.id from dual;
end;
/
create table int_servParamModeDis
(
	id	integer primary key not null, 
	servId    integer not null,
	paramModeId integer not null,
	paramType varchar2(200),
	paramDesc varchar2(200),
	paramName varchar2(200),
	isCompSty char(1),
	compStyTypeName varchar2(200),
	compstyname varchar2(200),
	paramIsMust char(1),
	paramCons varchar2(200),
	paramOrderNum  varchar2(10)
)
/
create sequence sq_int_servParamModeDis
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_servParamModeDis
before insert on int_servParamModeDis
for each row
begin
select sq_int_servParamModeDis.nextval into :new.id from dual;
end;
/
create table sap_datasource
(
	id	integer primary key not null, 
	hpid    integer not null,
	dataname  varchar2(200),
	poolname  varchar2(200),
	hostname  varchar2(200),
	systemNum varchar2(200),
	sapRouter varchar2(200),
	client    varchar2(200),
	language  varchar2(200),
	username  varchar2(200),
	password  varchar2(200),
	maxConnNum integer,
	datasourceDes varchar2(2000)	
)
/
create sequence sq_sap_datasource
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_datasource
before insert on sap_datasource
for each row
begin
select sq_sap_datasource.nextval into :new.id from dual;
end;
/
create table sap_paramsmode 
(
	id	integer primary key not null, 
	servId    integer not null,
	baseId integer not null
)
/
create sequence sq_sap_paramsmode
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_paramsmode
before insert on sap_paramsmode
for each row
begin
select sq_sap_paramsmode.nextval into :new.id from dual;
end;
/
create table dml_datasource
(
	id	integer primary key not null, 
	hpid  integer,
	sourcename  varchar2(200),	
	DBtype   varchar2(200),	
	serverip  varchar2(200),	
	port  varchar2(200),	
	dbname  varchar2(200),	
	username  varchar2(200),	
	password  varchar2(200),	
	minConnNum integer,
	maxConnNum integer,
	datasourceDes  varchar2(2000)	
)
/
create sequence sq_dml_datasource
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_dml_datasource
before insert on dml_datasource
for each row
begin
select sq_dml_datasource.nextval into :new.id from dual;
end;
/
create table dml_service
(
	id  integer primary key not null, 
	hpid  integer, 
	regname  varchar2(200),	
	poolid   varchar2(200),	
	opermode  varchar2(200),	
	serdesc  varchar2(500)
)
/
create sequence sq_dml_service
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_dml_service
before insert on dml_service
for each row
begin
select sq_dml_service.nextval into :new.id from dual;
end;
/
create table int_authorizeDetaRight
(
	id integer primary key not null, 
	rightid	integer,
	isinclude	integer,
	value	varchar2(2000)
)
/
create sequence sq_int_authorizeDetaRight
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_authorizeDetaRight
before insert on int_authorizeDetaRight
for each row
begin
select sq_int_authorizeDetaRight.nextval into :new.id from dual;
end;
/
create table int_authorizeRight
(
	id integer primary key not null, 
	baseid   integer,
	type     integer, 
	resourceids varchar2(2000), 
	roleids     varchar2(2000),
	wfids     varchar2(2000),
	ordernum  integer
)
/
create sequence sq_int_authorizeRight
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_authorizeRight
before insert on int_authorizeRight
for each row
begin
select sq_int_authorizeRight.nextval into :new.id from dual;
end;
/
create or replace procedure int_authorizeRight_Insert
(       
	baseid_1  integer,
	type_2    varchar2,
	resourceids_3    varchar2,	
	roleids_4	    varchar2,		
	wfids_5    varchar2,
	ordernum_6 varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into int_authorizeRight (baseid,type,resourceids,roleids,wfids,ordernum)
	values (baseid_1,type_2,resourceids_3,roleids_4,wfids_5,ordernum_6);
	/*查出最大值*/
	select MAX(id) into maxid_  from int_authorizeRight;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create or replace procedure int_authorizeRight_update
(    
    id_1     integer,
	baseid_2  integer,
	type_3    varchar2,
	resourceids_4    varchar2,	
	roleids_5	    varchar2,		
	wfids_6    varchar2,
	ordernum_7 varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
begin
     update int_authorizeRight set baseid=baseid_2,type=type_3,resourceids=resourceids_4,roleids=roleids_5,wfids=wfids_6,ordernum=ordernum_7
     where id=id_1;
	 open thecursor for  select id_1  from dual;                             
end;
/
create table int_browermark
(
    id  integer primary key not null, 
    mark  varchar2(500)  
)
/
create sequence sq_int_browermark
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_browermark
before insert on int_browermark
for each row
begin
select sq_int_browermark.nextval into :new.id from dual;
end;
/
create or replace procedure int_browermark_Insert
(       
	mark_1   varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into int_browermark (mark) values (mark_1);
	/*查出最大值*/
	select MAX(id) into maxid_  from int_browermark; 
  /*修改刚才的值*/
  update int_browermark set mark=mark_1||maxid_ where id=maxid_;
	open thecursor for  select mark  from int_browermark where id=maxid_;                             
end;
/
create table int_BrowserbaseInfo
(
	id integer primary key not null, 
	mark         varchar2(200),
	hpid         integer,
	poolid       integer,
	regservice   integer,
	brodesc       varchar2(2000),
	authcontorl   integer,
	w_fid integer,
	w_nodeid integer,
	w_actionorder  integer,
	w_enable       integer,	
	w_type         integer,
	ispreoperator  integer,
	nodelinkid    integer
)
/
create sequence sq_int_BrowserbaseInfo
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_BrowserbaseInfo
before insert on int_BrowserbaseInfo
for each row
begin
select sq_int_BrowserbaseInfo.nextval into :new.id from dual;
end;
/
create or replace procedure int_BrowserbaseInfo_insert
(       
	mark_1         varchar2,
	hpid_2   integer,
	poolid_3     integer,
	regservice_4 varchar2,
	brodesc_5	varchar2,
	authcontorl_6 	varchar2,
     w_fid_7 integer,
	w_nodeid_8 integer,
	w_actionorder_9  integer,
	w_enable_10       integer,
	w_type_11     integer,
	ispreoperator_12  integer,
	nodelinkid_13    integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into int_BrowserbaseInfo (mark,hpid,poolid,regservice,brodesc,authcontorl,w_fid,w_nodeid,w_actionorder,w_enable,w_type,ispreoperator,nodelinkid)
	values (mark_1,hpid_2,poolid_3,regservice_4,brodesc_5,authcontorl_6,w_fid_7,w_nodeid_8,w_actionorder_9,w_enable_10,w_type_11,ispreoperator_12,nodelinkid_13);
	/*查出最大值*/
	select MAX(id) into maxid_  from int_BrowserbaseInfo;      
	open thecursor for  select maxid_  from dual;                             
end;  
/
create table int_dataInter
(
	id	integer primary key not null, 
	dataname  varchar2(200),
	datadesc varchar2(500),
	Sysbuilt	  integer
)
/
create sequence sq_int_dataInter
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_dataInter
before insert on int_dataInter
for each row
begin
select sq_int_dataInter.nextval into :new.id from dual;
end;
/
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('DML数据交互','采用中间表技术来实现异构系统之间的交互。','1')
/
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('webservice数据交互','异构系统间采用同一标准，通过发布、调用webservice来实现系统间的数据交互。','1')
/
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('ABAP-RFC数据交互','SAP套件中专用于异构系统之间数据交互的方式。','1')
/
create table int_heteProducts
(
	id	integer primary key not null, 
	hetename varchar2(200),
	hetedesc varchar2(500),
	sid varchar2(200)
)
/
create sequence sq_int_heteProducts
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_heteProducts
before insert on int_heteProducts
for each row
begin
select sq_int_heteProducts.nextval into :new.id from dual;
end;
/
create table sap_complexname
(
	id  integer primary key not null, 
	baseid  integer,
	comtype integer,
	name varchar2(200),
	backtable varchar2(200),
    backoper integer 
)
/
create sequence sq_sap_complexname
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_complexname
before insert on sap_complexname
for each row
begin
select sq_sap_complexname.nextval into :new.id from dual;
end;
/
create or replace procedure sap_complexname_Insert
(       
	baseid_1  integer,
	comtype_2    varchar2,
	name_3        varchar2,
	backtable_4 varchar2,
	backoper_5  integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_complexname (baseid,comtype,name,backtable,backoper)
	values (baseid_1,comtype_2,name_3,backtable_4,backoper_5);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_complexname;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_inParameter
(
    id  integer primary key not null, 
    baseid   integer,
    sapfield varchar2(200),
    oafield  varchar2(200),
    constant varchar2(200),
    ordernum  integer,
    ismainfield   integer,
    fromfieldid  integer,
    isbill         integer
)
/
create sequence sq_sap_inParameter
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_inParameter
before insert on sap_inParameter
for each row
begin
select sq_sap_inParameter.nextval into :new.id from dual;
end;
/
create or replace procedure sap_inParameter_Insert
(       
	baseid_1   integer,
	sapfield_2 varchar2,
	oafield_3  varchar2,
	constant_4 varchar2,
	ordernum_5 varchar2,
	ismainfield_6  varchar2,
	fromfieldid_7 varchar2,
	isbill_8       varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_inParameter (baseid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill)
	values (baseid_1,sapfield_2,oafield_3,constant_4,ordernum_5,ismainfield_6,fromfieldid_7,isbill_8);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_inParameter;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_inStructure
(
	id  integer primary key not null, 
	baseid  integer,
	nameid    varchar2(200),
	sapfield    varchar2(200),	
	oafield	    varchar2(200),		
	constant    varchar2(200),
	ordernum  integer,
	orderGroupnum  integer,
	ismainfield   integer,
	fromfieldid  integer,
	isbill           integer
)
/
create sequence sq_sap_inStructure
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_inStructure
before insert on sap_inStructure
for each row
begin
select sq_sap_inStructure.nextval into :new.id from dual;
end;
/
create or replace procedure sap_inStructure_Insert
(       
	baseid_1  integer,
	nameid_2    varchar2,
	sapfield_3    varchar2,	
	oafield_4	    varchar2,		
	constant_5    varchar2,
	ordernum_6  varchar2,
	orderGroupnum_7  varchar2,
	ismainfield_8  varchar2,
	fromfieldid_9  varchar2,
	isbill_10          varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_inStructure (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill)
	values (baseid_1,nameid_2,sapfield_3,oafield_4,constant_5,ordernum_6,orderGroupnum_7,ismainfield_8,fromfieldid_9,isbill_10);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_inStructure;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_inTable
(
	id  integer primary key not null, 
	baseid  integer,
	nameid    varchar2(200),	
	sapfield   varchar2(200),	
	oafield    varchar2(200),
	constant    varchar2(200),
	ordernum  integer,
	orderGroupnum  integer,
	ismainfield   integer,
    fromfieldid  integer,
    isbill          integer
)
/
create sequence sq_sap_inTable
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_inTable
before insert on sap_inTable
for each row
begin
select sq_sap_inTable.nextval into :new.id from dual;
end;
/
create or replace procedure sap_inTable_Insert
(       
	baseid_1  integer,
	nameid_2    varchar2,
	sapfield_3    varchar2,	
	oafield_4	    varchar2,		
	constant_5    varchar2,
	ordernum_6  varchar2,
	orderGroupnum_7  varchar2,
	ismainfield_8  varchar2,
	fromfieldid_9  varchar2,
	isbill_10    varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_inTable (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill)
	values (baseid_1,nameid_2,sapfield_3,oafield_4,constant_5,ordernum_6,orderGroupnum_7,ismainfield_8,fromfieldid_9,isbill_10);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_inTable;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_outParameter
(
	id  integer primary key not null, 
	baseid  integer,
	sapfield   varchar2(200),	
	showname   varchar2(200),	
	display    varchar2(1),
	ordernum  integer,
	oafield    varchar2(200),
	ismainfield   integer,
    fromfieldid  integer,
    isbill  integer
)
/
create sequence sq_sap_outParameter
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_outParameter
before insert on sap_outParameter
for each row
begin
select sq_sap_outParameter.nextval into :new.id from dual;
end;
/
create or replace procedure sap_outParameter_Insert
(       
	baseid_1  integer,
	sapfield_2   varchar2,	
	showname_3   varchar2,	
	Display_4    varchar2,
	ordernum_5  varchar2,
	oafield_6  varchar2,
	ismainfield_7  varchar2,
	fromfieldid_8   varchar2,
	isbill_9   varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_outParameter (baseid,sapfield,showname,Display,ordernum,oafield,ismainfield,fromfieldid,isbill)
	values (baseid_1,sapfield_2,showname_3,Display_4,ordernum_5,oafield_6,ismainfield_7,fromfieldid_8,isbill_9);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_outParameter;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_outparaprocess
(
	id  integer primary key not null, 
	baseid  integer,
	nameid  varchar2(200),
	sapfield   varchar2(200),
	oafield    varchar2(200),
	constant    varchar2(200),
	ordernum  integer,
	ismainfield   integer,
    fromfieldid  integer,
    isbill          integer
)
/
create sequence sq_sap_outparaprocess
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_outparaprocess
before insert on sap_outparaprocess
for each row
begin
select sq_sap_outparaprocess.nextval into :new.id from dual;
end;
/
create or replace procedure sap_outparaprocess_Insert
(       
	baseid_1  integer,
	nameid_2   varchar2,	
	sapfield_3    varchar2,	
    oafield_4    varchar2,	
    constant_5  varchar2,	
    ordernum_6  varchar2,	
    ismainfield_7  varchar2,	
    fromfieldid_8  varchar2,	
    isbill_9          varchar2,	
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_outparaprocess (baseid,nameid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill)
	values (baseid_1,nameid_2,sapfield_3,oafield_4,constant_5,ordernum_6,ismainfield_7,fromfieldid_8,isbill_9);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_outparaprocess;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_outStructure
(
	id  integer primary key not null, 
	baseid  integer,
	nameid    varchar2(200),	
	sapfield   varchar2(200),	
	showname    varchar2(200),	
	Display  varchar2(1),	
	Search  varchar2(1),
	ordernum  integer,
	orderGroupnum  integer,
	oafield    varchar2(200),
	ismainfield   integer,
    fromfieldid  integer,
    isbill  integer
)
/
create sequence sq_sap_outStructure
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_outStructure
before insert on sap_outStructure
for each row
begin
select sq_sap_outStructure.nextval into :new.id from dual;
end;
/
create or replace procedure sap_outStructure_Insert
(       
	baseid_1  integer,
	nameid_2    varchar2,
	sapfield_3   varchar2,
	showname_4    varchar2,	
	Display_5  varchar2,
	Search_6  varchar2,
	ordernum_7  integer,
	orderGroupnum_8   integer,
	oafield_9      varchar2,
	ismainfield_10 	varchar2,
	fromfieldid_11 varchar2,
	isbill_12   varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_outStructure (baseid,nameid,sapfield,showname,Display,Search,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill)
	values (baseid_1,nameid_2,sapfield_3,showname_4,Display_5,Search_6,ordernum_7,orderGroupnum_8,oafield_9,ismainfield_10,fromfieldid_11,isbill_12);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_outStructure;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_outTable
(
	id  integer primary key not null, 
	baseid  integer,
	nameid    varchar2(200),	
	sapfield   varchar2(200),	
	showname    varchar2(200),	
	Display  varchar2(1),	
	Search  varchar2(1),	
	Primarykey varchar2(1),
	ordernum  integer,
	orderGroupnum  integer,
	oafield    varchar2(200),
	ismainfield   integer,
    fromfieldid  integer,
    isbill          integer
)
/
create sequence sq_sap_outTable
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_outTable
before insert on sap_outTable
for each row
begin
select sq_sap_outTable.nextval into :new.id from dual;
end;
/
create or replace procedure sap_outTable_Insert
(       
	baseid_1  integer,
	nameid_2    varchar2,	
	sapfield_3   varchar2,	
	showname_4    varchar2,	
	Display_5  varchar2,	
	Search_6  varchar2,	
	Primarykey_7 varchar2,
	ordernum_8  varchar2,
	orderGroupnum_9 varchar2,
	oafield_10   varchar2,
	ismainfield_11 varchar2,
	fromfieldid_12 varchar2,
	isbill_13     varchar2,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
as    
      maxid_ varchar2(50); 
begin
	/*插入数据*/
	insert into sap_outTable (baseid,nameid,sapfield,showname,Display,Search,Primarykey,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill)
	values (baseid_1,nameid_2,sapfield_3,showname_4,Display_5,Search_6,Primarykey_7,ordernum_8,orderGroupnum_9,oafield_10,ismainfield_11,fromfieldid_12,isbill_13);
	/*查出最大值*/
	select MAX(id) into maxid_  from sap_outTable;      
	open thecursor for  select maxid_  from dual;                             
end;
/
create table sap_service
(
	id  integer primary key not null, 
	hpid  integer, 
	regname  varchar2(200),	
	poolid   varchar2(200),	
	funname  varchar2(200),	
	fundesc  varchar2(500),	
	loadmb	 integer,	
	serdesc  varchar2(500)
)
/
create sequence sq_sap_service
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_service
before insert on sap_service
for each row
begin
select sq_sap_service.nextval into :new.id from dual;
end;
/
create table ws_datasource
(
	id  integer primary key not null, 
	hpid  integer,
	poolname varchar2(200),	
	wsdladdress varchar2(200),
	pooldesc varchar2(500)
)
/
create sequence sq_ws_datasource
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_ws_datasource
before insert on ws_datasource
for each row
begin
select sq_ws_datasource.nextval into :new.id from dual;
end;
/
create table ws_service
(
	id  integer primary key not null, 
	hpid  integer, 
	regname  varchar2(200),	
	poolid   varchar2(200),	
	serdesc  varchar2(500)
)
/
create sequence sq_ws_service
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_ws_service
before insert on ws_service
for each row
begin
select sq_ws_service.nextval into :new.id from dual;
end;
/

create table int_saplog
(
  id  integer primary key not null, 
  funname  varchar2(60),
  hpid    integer,
  poolid  integer,
  borwmark      Varchar2(20),
  clientMessage Varchar2(20),
  startFunTime  Varchar2(20),
  funResult  Varchar2(2),
  endFunTime  Varchar2(20),
  Logtype  Varchar2(2),
  regserviceid varchar2(50),
  logcreateData  varchar2(10),
  logcreatetime  varchar2(20)
)
/
create sequence sq_int_saplog
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_saplog
before insert on int_saplog
for each row
begin
select sq_int_saplog.nextval into :new.id from dual;
end;
/
create table int_saplogpar
(
  id  integer primary key not null, 
  baseid integer,
  Type  integer,
  Parkey  varchar2(50),
  parvalue varchar2(50)
)
/
create sequence sq_int_saplogpar
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_saplogpar
before insert on int_saplogpar
for each row
begin
select sq_int_saplogpar.nextval into :new.id from dual;
end;
/
create table int_saplogstu
(
  id  integer primary key not null, 
  baseid integer,
  Type  integer,
  name    varchar2(100),
  Parkey  varchar2(50),
  parvalue varchar2(50)
)
/
create sequence sq_int_saplogstu
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_saplogstu
before insert on int_saplogstu
for each row
begin
select sq_int_saplogstu.nextval into :new.id from dual;
end;
/
create table int_saplogtab
(
  id  integer primary key not null, 
  baseid integer,
  Type  integer,
  name    varchar2(100),
  Parkey  varchar2(50),
  parvalue varchar2(50),
  rowids   integer
)
/
create sequence sq_int_saplogtab
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_saplogtab
before insert on int_saplogtab
for each row
begin
select sq_int_saplogtab.nextval into :new.id from dual;
end;
/
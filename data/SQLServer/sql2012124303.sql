delete workflow_browserurl where id in(226,227)
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 226,30312,'varchar(1000)','GOsysteminfoGOBrowserMain.jsp?url=GOintegrationGOsapSingleBrowser.jsp','','','','')
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 227,30313,'varchar(1000)','GOsysteminfoGOBrowserMain.jsp?url=GOintegrationGOsapMutilBrowser.jsp','','','','')
GO
CREATE TABLE int_serviceCompParamsList (
	id	int primary key not null identity(1,1), 
	servId    int not null, 
	paramID int not null,
	paramDesc varchar(200),
	paramName varchar(200)	
)
GO
create table int_serviceParamMode
(
	id	int primary key not null identity(1,1), 
	sid	int not null,
	servId    int not null,
	paramModeName varchar(200)
)
GO
create table int_serviceParams
(
	id	int primary key not null identity(1,1), 
	servId    int not null,
	paramType varchar(200),
	paramDesc varchar(200),
	paramName varchar(200),
	isCompSty char(1),
	compStyTypeName varchar(200)
)
GO
create table int_servParamModeDis
(
	id	int primary key not null identity(1,1), 
	servId    int not null,
	paramModeId int not null,
	paramType varchar(200),
	paramDesc varchar(200),
	paramName varchar(200),
	isCompSty char(1),
	compStyTypeName varchar(200),
	compstyname varchar(200),
	paramIsMust char(1),
	paramCons varchar(200),
	paramOrderNum  varchar(10)
)
GO
create table sap_datasource
(
	id	int primary key not null identity(1,1), 
	hpid    int not null,
	dataname  varchar(200),
	poolname  varchar(200),
	hostname  varchar(200),
	systemNum varchar(200),
	sapRouter varchar(200),
	client    varchar(200),
	language  varchar(200),
	username  varchar(200),
	password  varchar(200),
	maxConnNum int,
	datasourceDes varchar(2000)	
)
GO
create table sap_paramsmode 
(
	id	int primary key not null identity(1,1), 
	servId    int not null,
	baseId int not null
)
GO
create table dml_datasource
(
	id	int primary key not null identity(1,1), 
	hpid  int,
	sourcename  varchar(200),	
	DBtype   varchar(200),	
	serverip  varchar(200),	
	port  varchar(200),	
	dbname  varchar(200),	
	username  varchar(200),	
	password  varchar(200),	
	minConnNum int,
	maxConnNum int,
	datasourceDes  varchar(2000)	
)
GO
create table dml_service
(
	id  int primary key not null identity(1,1), 
	hpid  int, 
	regname  varchar(200),	
	poolid   varchar(200),	
	opermode  varchar(200),	
	serdesc  varchar(500)
)
GO
create table int_authorizeDetaRight
(
	id int primary key not null identity(1,1), 
	rightid	int,
	isinclude	int,
	value	varchar(2000)
)
GO
create table int_authorizeRight
(
	id int primary key not null identity(1,1), 
	baseid   int,
	type     int,  
	resourceids varchar(2000),
	roleids     varchar(2000), 
	wfids     varchar(2000),
	ordernum  int
)
GO
create table int_browermark
(
    id  int primary key not null identity(1,1), 
    mark  varchar(500)  
)
GO
create table int_BrowserbaseInfo
(
	id int primary key not null identity(1,1), 
	mark         varchar(200),
	hpid         int,
	poolid       int,
	regservice   int,
	brodesc       varchar(2000),
	authcontorl   int,
	w_fid int,
	w_nodeid int,
	w_actionorder  int,
	w_enable       int,	
	w_type         int,
	ispreoperator  int,
	nodelinkid    int
)
GO
create table int_dataInter
(
	id	int primary key not null identity(1,1), 
	dataname  varchar(200),
	datadesc varchar(500),
	Sysbuilt	 int
)
GO
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('DML数据交互','采用中间表技术来实现异构系统之间的交互。','1')
GO
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('webservice数据交互','异构系统间采用同一标准,通过发布、调用webservice来实现系统间的数据交互。','1')
GO
insert into int_dataInter (dataname,datadesc,Sysbuilt) values ('ABAP-RFC数据交互','SAP套件中专用于异构系统之间数据交互的方式。','1')
GO
create table int_heteProducts
(
	id	int primary key not null identity(1,1), 
	hetename varchar(200),
	hetedesc varchar(500),
	sid varchar(200)
)
GO
create table sap_complexname
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	comtype int,
	name varchar(200),
	backtable varchar(200),
    backoper int 
)
GO
create table sap_inParameter
(
    id  int primary key not null identity(1,1), 
    baseid   int,
    sapfield varchar(200),
    oafield  varchar(200),
    constant varchar(200),
    ordernum  int,
    ismainfield   int,
    fromfieldid  int,
    isbill         int
)
GO
create table sap_inStructure
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	nameid    varchar(200),
	sapfield    varchar(200),	
	oafield	    varchar(200),		
	constant    varchar(200),
	ordernum  int,
	orderGroupnum  int,
	ismainfield   int,
	fromfieldid  int,
	isbill           int
)
GO
create table sap_inTable
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	nameid    varchar(200),	
	sapfield   varchar(200),	
	oafield    varchar(200),
	constant    varchar(200),
	ordernum  int,
	orderGroupnum  int,
	ismainfield   int,
    fromfieldid  int,
    isbill          int
)
GO
create table sap_outParameter
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	sapfield   varchar(200),	
	showname   varchar(200),	
	display    varchar(1),
	ordernum  int,
	oafield    varchar(200),
	ismainfield   int,
    fromfieldid  int,
    isbill  int
)
GO
create table sap_outparaprocess
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	nameid  varchar(200),
	sapfield   varchar(200),
	oafield    varchar(200),
	constant    varchar(200),
	ordernum  int,
	ismainfield   int,
    fromfieldid  int,
    isbill          int
)
GO
create table sap_outStructure
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	nameid    varchar(200),	
	sapfield   varchar(200),	
	showname    varchar(200),	
	Display  varchar(1),	
	Search  varchar(1),
	ordernum  int,
	orderGroupnum  int,
	oafield    varchar(200),
	ismainfield   int,
    fromfieldid  int,
    isbill  int
)
GO
create table sap_outTable
(
	id  int primary key not null identity(1,1), 
	baseid  int,
	nameid    varchar(200),	
	sapfield   varchar(200),	
	showname    varchar(200),	
	Display  varchar(1),	
	Search  varchar(1),	
	Primarykey varchar(1),
	ordernum  int,
	orderGroupnum  int,
	oafield    varchar(200),
	ismainfield   int,
    fromfieldid  int,
    isbill          int
)
GO
create table sap_service
(
	id  int primary key not null identity(1,1), 
	hpid  int, 
	regname  varchar(200),	
	poolid   varchar(200),	
	funname  varchar(200),	
	fundesc  varchar(500),	
	loadmb	 integer,	
	serdesc  varchar(500)
)
GO
create table ws_datasource
(
	id  int primary key not null identity(1,1), 
	hpid  int,
	poolname varchar(200),	
	wsdladdress varchar(200),
	pooldesc varchar(500)
)
GO
create table ws_service
(
	id  int primary key not null identity(1,1), 
	hpid  int, 
	regname  varchar(200),	
	poolid   varchar(200),	
	serdesc  varchar(500)
)
GO
create proc int_authorizeRight_Insert
(       
	@baseid_1  int,
	@type_2    varchar(50),
	@resourceids_3    varchar(50),	
	@roleids_4	    varchar(50),		
	@wfids_5    varchar(50),
	@ordernum_6 varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
    declare   @maxid_ varchar(50);
begin
	/*插入数据*/
	insert into int_authorizeRight (baseid,type,resourceids,roleids,wfids,ordernum)
	values (@baseid_1,@type_2,@resourceids_3,@roleids_4,@wfids_5,@ordernum_6);
	/*查出最大值*/
	select @maxid_=MAX(id) from int_authorizeRight;      
	select @maxid_                       
end;
GO
create proc int_authorizeRight_update
(    
    @id_1     int,
	@baseid_2  int,
	@type_3    varchar(50),
	@resourceids_4    varchar(50),
	@roleids_5	    varchar(50),
	@wfids_6    varchar(50),
	@ordernum_7 varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as  
begin
     update int_authorizeRight set baseid=@baseid_2,type=@type_3,resourceids=@resourceids_4,roleids=@roleids_5,wfids=@wfids_6,ordernum=@ordernum_7
     where id=@id_1;   
     select @id_1                    
end;
GO
create proc int_browermark_Insert
(       
	@mark_1  varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
    declare @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into int_browermark (mark) values (@mark_1);
	/*查出最大值*/
	select @maxid_=MAX(id) from int_browermark; 
    /*修改刚才的值*/
    update int_browermark set mark=@mark_1+@maxid_ where id=@maxid_;
	select mark  from int_browermark where id=@maxid_;                                 
end;
GO
create proc int_BrowserbaseInfo_insert
(       
	@mark_1    varchar(50),
	@hpid_2   int,
	@poolid_3     int,
	@regservice_4 varchar(50),
	@brodesc_5	varchar(50),
	@authcontorl_6 	varchar(50),
    @w_fid_7 int,
	@w_nodeid_8 int,
	@w_actionorder_9  int,
	@w_enable_10       int,
	@w_type_11     int,
	@ispreoperator_12  int,
	@nodelinkid_13    int,
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
    declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into int_BrowserbaseInfo (mark,hpid,poolid,regservice,brodesc,authcontorl,w_fid,w_nodeid,w_actionorder,w_enable,w_type,ispreoperator,nodelinkid)
	values (@mark_1,@hpid_2,@poolid_3,@regservice_4,@brodesc_5,@authcontorl_6,@w_fid_7,@w_nodeid_8,@w_actionorder_9,@w_enable_10,@w_type_11,@ispreoperator_12,@nodelinkid_13);
	/*查出最大值*/
	select @maxid_=MAX(id)  from int_BrowserbaseInfo;      
	select @maxid_                      
end;  
GO
create proc sap_complexname_Insert
(       
	@baseid_1  int,
	@comtype_2    varchar(50),
	@name_3        varchar(50),
	@backtable_4 varchar(50),
	@backoper_5  int,
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
    declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_complexname (baseid,comtype,name,backtable,backoper)
	values (@baseid_1,@comtype_2,@name_3,@backtable_4,@backoper_5);
	/*查出最大值*/
	select @maxid_=MAX(id)  from sap_complexname;      
    select @maxid_                         
end;
GO
create proc sap_inParameter_Insert
(       
	@baseid_1   int,
	@sapfield_2 varchar(50),
	@oafield_3  varchar(50),
	@constant_4 varchar(50),
	@ordernum_5 varchar(50),
	@ismainfield_6  varchar(50),
	@fromfieldid_7 varchar(50),
	@isbill_8       varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_inParameter (baseid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@sapfield_2,@oafield_3,@constant_4,@ordernum_5,@ismainfield_6,@fromfieldid_7,@isbill_8);
	/*查出最大值*/
	select @maxid_=MAX(id) from sap_inParameter;      
	select @maxid_                           
end;
GO
create proc sap_inStructure_Insert
(       
	@baseid_1  int,
	@nameid_2    varchar(50),
	@sapfield_3    varchar(50),
	@oafield_4	    varchar(50),
	@constant_5    varchar(50),
	@ordernum_6  varchar(50),
	@orderGroupnum_7  varchar(50),
	@ismainfield_8  varchar(50),
	@fromfieldid_9  varchar(50),
	@isbill_10          varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare   @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_inStructure (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@nameid_2,@sapfield_3,@oafield_4,@constant_5,@ordernum_6,@orderGroupnum_7,@ismainfield_8,@fromfieldid_9,@isbill_10);
	/*查出最大值*/
	select @maxid_=MAX(id) from sap_inStructure;      
	select @maxid_                           
end;
GO
create proc sap_inTable_Insert
(       
	@baseid_1  int,
	@nameid_2    varchar(50),
	@sapfield_3    varchar(50),
	@oafield_4	    varchar(50),
	@constant_5    varchar(50),
	@ordernum_6  varchar(50),
	@orderGroupnum_7  varchar(50),
	@ismainfield_8  varchar(50),
	@fromfieldid_9  varchar(50),
	@isbill_10    varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_inTable (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@nameid_2,@sapfield_3,@oafield_4,@constant_5,@ordernum_6,@orderGroupnum_7,@ismainfield_8,@fromfieldid_9,@isbill_10);
	/*查出最大值*/
	select @maxid_ =MAX(id)   from sap_inTable;      
	select @maxid_                            
end;
GO
create proc sap_outParameter_Insert
(       
	@baseid_1  int,
	@sapfield_2   varchar(50),
	@showname_3   varchar(50),
	@Display_4    varchar(50),
	@ordernum_5  varchar(50),
	@oafield_6  varchar(50),
	@ismainfield_7  varchar(50),
	@fromfieldid_8   varchar(50),
	@isbill_9   varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_outParameter (baseid,sapfield,showname,Display,ordernum,oafield,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@sapfield_2,@showname_3,@Display_4,@ordernum_5,@oafield_6,@ismainfield_7,@fromfieldid_8,@isbill_9);
	/*查出最大值*/
	select @maxid_=MAX(id)  from sap_outParameter;      
	select @maxid_                          
end;
GO
create proc sap_outparaprocess_Insert
(       
	@baseid_1  int,
	@nameid_2   varchar(50),
	@sapfield_3    varchar(50),
    @oafield_4    varchar(50),
    @constant_5  varchar(50),
    @ordernum_6  varchar(50),
    @ismainfield_7  varchar(50),
    @fromfieldid_8  varchar(50),
    @isbill_9       varchar(50),
    @flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare   @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_outparaprocess (baseid,nameid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@nameid_2,@sapfield_3,@oafield_4,@constant_5,@ordernum_6,@ismainfield_7,@fromfieldid_8,@isbill_9);
	/*查出最大值*/
	select @maxid_=MAX(id)   from sap_outparaprocess;      
	select @maxid_                          
end;
GO
create proc sap_outStructure_Insert
(       
	@baseid_1  int,
	@nameid_2    varchar(50),
	@sapfield_3   varchar(50),
	@showname_4    varchar(50),
	@Display_5  varchar(50),
	@Search_6  varchar(50),
	@ordernum_7  varchar(50),
	@orderGroupnum_8   varchar(50),
	@oafield_9      varchar(50),
	@ismainfield_10 	varchar(50),
	@fromfieldid_11 varchar(50),
	@isbill_12   varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare   @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_outStructure (baseid,nameid,sapfield,showname,Display,Search,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@nameid_2,@sapfield_3,@showname_4,@Display_5,@Search_6,@ordernum_7,@orderGroupnum_8,@oafield_9,@ismainfield_10,@fromfieldid_11,@isbill_12);
	/*查出最大值*/
	select @maxid_=MAX(id)  from sap_outStructure;      
    select @maxid_                        
end;
GO
create proc  sap_outTable_Insert
(       
	@baseid_1  int,
	@nameid_2    varchar(50),
	@sapfield_3   varchar(50),
	@showname_4    varchar(50),
	@Display_5  varchar(50),
	@Search_6  varchar(50),
	@Primarykey_7 varchar(50),
	@ordernum_8  varchar(50),
	@orderGroupnum_9 varchar(50),
	@oafield_10   varchar(50),
	@ismainfield_11 varchar(50),
	@fromfieldid_12 varchar(50),
	@isbill_13     varchar(50),
	@flag 		integer 	output ,
	@msg 		varchar(80) 	output 
)
as    
   declare   @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into sap_outTable (baseid,nameid,sapfield,showname,Display,Search,Primarykey,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill)
	values (@baseid_1,@nameid_2,@sapfield_3,@showname_4,@Display_5,@Search_6,@Primarykey_7,@ordernum_8,@orderGroupnum_9,@oafield_10,@ismainfield_11,@fromfieldid_12,@isbill_13);
	/*查出最大值*/
	select @maxid_=MAX(id)   from sap_outTable;      
	select @maxid_                              
end;
GO

create table int_saplog
(
  id  int primary key not null identity(1,1), 
  funname  varchar(60),
  hpid    int,
  poolid  int,
  borwmark      varchar(20),
  clientMessage varchar(20),
  startFunTime  varchar(20),
  funResult  varchar(2),
  endFunTime  varchar(20),
  Logtype  varchar(2),
  regserviceid varchar(50),
  logcreateData  varchar(10),
  logcreatetime  varchar(20)
)
GO
create table int_saplogpar
(
  id  int primary key not null identity(1,1), 
  baseid int,
  Type  int,
  Parkey  varchar(50),
  parvalue varchar(50)
)
GO
create table int_saplogstu
(
  id  int primary key not null identity(1,1), 
  baseid int,
  Type  int,
  name    varchar(100),
  Parkey  varchar(50),
  parvalue varchar(50)
)
GO
create table int_saplogtab
(
  id  int primary key not null identity(1,1), 
  baseid int,
  Type  int,
  name    varchar(100),
  Parkey  varchar(50),
  parvalue varchar(50),
  rowids   int
)
GO
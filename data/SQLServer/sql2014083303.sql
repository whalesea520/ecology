CREATE TABLE synergy_base(
	id int NOT NULL,
	frommodule varchar(50) NOT NULL,
	frompage varchar(200) NULL,
	wftype int NULL,
	wfid int NULL,
	supid int NULL,
	modulename int NOT NULL,
	orderkey int NULL,
	styleid varchar(50) NULL,
	layoutid int NULL,
	subcompanyid int NULL,
	haslayout int NULL,
	showtree int NULL,
	frompagepara varchar(200) NULL,
	samepageid int NULL
)
GO
CREATE TABLE synergy_params(
	id int IDENTITY(1,1) NOT NULL,
	paramname varchar(50) NULL,
	paramlabelid int NULL,
	elementbaseid varchar(50) NULL,
	synergybaseid int NULL,
	wfid int NULL,
	ftype int NULL,
	browserid varchar(200) NULL
)
GO
CREATE TABLE sypara_expressionbase(
	id int NOT NULL,
	eid int NOT NULL,
	variableID int NULL,
	relation int NULL,
	valueType int NULL,
	value varchar(255) NULL,
	valueName varchar(1000) NULL,
	valueVariableid int NULL,
	systemParam varchar(255) NULL
) 
GO

CREATE TABLE sypara_expressions(
	id int NOT NULL,
	eid int NOT NULL,
	relation int NULL,
	expids varchar(500) NULL,
	expbaseid varchar(500) NULL
)
GO

CREATE TABLE sypara_variablebase(
	id int NOT NULL,
	name varchar(255) NULL,
	type int NULL,
	browsertype int NULL,
	eid int NULL,
	spid int NULL,
	formid int NULL,
	isbill int NULL
)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('subcompanyid1',22788,'7','-1',NULL,3,164)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('departmentid',19225,'7','-1',NULL,3,4)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('userid',882,'7','-1',NULL,3,1)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('createdate',722,'7','-1',NULL,3,2)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('title',19541,'7','-1',NULL,1,1)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('title',1334,'8','-1',NULL,1,1)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('userid',882,'8','-1',NULL,3,1)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('subcompanyid1',22788,'8','-1',NULL,3,164)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('departmentid',19225,'8','-1',NULL,3,4)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('createdate',722,'8','-1',NULL,3,2)
GO
insert into synergy_params(paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid)
values ('urgent',15534,'8','-1',NULL,5,'0,1,2')
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('3','wf|menu','','0','0','1','32771','1','synergys','1','1','1','1','',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('4','wf|operat','','0','0','1','16579','2','synergys','1','1','1','1','',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('5','workflow','/workflow/request/RequestTypeShow.jsp','0','0','3','16392','1','synergys','1','1','0','1','',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('6','workflow','/workflow/request/RequestTypeShowWithLetter.jsp','0','0','3','16392','1','synergys','1','1','0','0','','5')
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('7','workflow','/workflow/search/WFSearchResult.jsp','0','0','3','1207','2','synergys','1','1','0','1','scope=doing',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('8','workflow','/workflow/search/WFSuperviseList.jsp','0','0','3','21218','3','synergys','1','1','0','1','',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('9','workflow','/workflow/search/WFSearchResult.jsp','0','0','3','17991','4','synergys','1','1','0','1','scope=done',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('10','workflow','/workflow/search/WFSearchResult.jsp','0','0','3','17992','5','synergys','1','1','0','1','scope=complete',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('11','workflow','/workflow/search/WFSearchResult.jsp','0','0','3','1210','7','synergys','1','1','0','1','scope=mine',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('12','workflow','/workflow/request/wfAgentList.jsp','0','0','3','32611','8','synergys','1','1','0','1','scope=1',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('13','workflow','/workflow/request/wfAgentList.jsp','0','0','3','32610','9','synergys','1','1','0','1','scope=0',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('14','workflow','/system/systemmonitor/workflow/WorkflowMonitorList.jsp','0','0','3','16758','10','synergys','1','1','0','1','',NULL)
GO
insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values('15','workflow','/workflow/search/WFSearchShow.jsp','0','0','3','16393','11','synergys','1','1','0','1','',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(16,'doc|menu','',0,0,1,32771,1,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(17,'doc|operat','',0,0,1,16579,2,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(18,'doc','/docs/docs/DocList.jsp',0,0,16,1986,1,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(19,'doc','/docs/search/DocCommonContent.jsp',0,0,16,1212,2,'synergys',1,1,0,1,'scope=5',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(20,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32121,3,'synergys',1,1,0,1,'scope=7',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(21,'doc','/docs/docs/ApproveDocList.jsp',0,0,16,2069,4,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(22,'doc','/docs/search/DocCommonContent.jsp',0,0,16,18037,5,'synergys',1,1,0,1,'scope=10',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(23,'doc','/docs/docs/DocShareView.jsp',0,0,16,16396,6,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(24,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32124,7,'synergys',1,1,0,1,'scope=2',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(25,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32120,8,'synergys',1,1,0,1,'scope=1',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(26,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32123,9,'synergys',1,1,0,1,'scope=4',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(27,'doc','/docs/search/DocCommonContent.jsp',0,0,16,16397,10,'synergys',1,1,0,1,'scope=0',NULL)
GO

insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(28,'doc','/docs/search/DocCommonContent.jsp',0,0,16,16399,11,'synergys',1,1,0,1,'scope=6',NULL)
GO

insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(29,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32125,11,'synergys',1,1,0,1,'scope=3',NULL)
GO

insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(30,'doc','/docs/docdummy/DocDummyRight.jsp',0,0,16,20482,12,'synergys',1,1,0,1,'',NULL)
GO

insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(31,'doc','/system/systemmonitor/docs/DocMonitor.jsp',0,0,16,16757,13,'synergys',1,1,0,1,'',NULL)
GO



insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('userself',33006,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('usersuperior',27340,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('usersubordinate',15764,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('currentyear',15384,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('currentmonth',15541,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('currentday',15537,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('currentdepart',21837,'sysparam',-1,NULL,NULL,NULL)
GO
insert into synergy_params (paramname,paramlabelid,elementbaseid,synergybaseid,wfid,ftype,browserid) 
values('currentsubcompany',30792,'sysparam',-1,NULL,NULL,NULL)
GO

delete from synergy_base where supid= 16
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(18,'doc','/docs/docs/DocList.jsp',0,0,16,1986,1,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(19,'doc','/docs/search/DocCommonContent.jsp',0,0,16,1212,2,'synergys',1,1,0,1,'scope=5',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(20,'doc','/docs/search/DocCommonContent.jsp',0,0,16,16399,3,'synergys',1,1,0,1,'scope=14',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(21,'doc','/docs/search/DocCommonContent.jsp',0,0,16,16398,4,'synergys',1,1,0,1,'scope=6',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(22,'doc','/docs/docdummy/DocDummyRight.jsp',0,0,16,20482,5,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(23,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32122,6,'synergys',1,1,0,1,'scope=2',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(24,'doc','/docs/search/DocCommonContent.jsp',0,0,16,16397,7,'synergys',1,1,0,1,'scope=0',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(25,'doc','/docs/search/DocCommonContent.jsp',0,0,16,32121,8,'synergys',1,1,0,1,'scope=7',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(26,'doc','/docs/search/DocCommonContent.jsp',0,0,16,18037,9,'synergys',1,1,0,1,'scope=13',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(27,'doc','/docs/tools/DocCopyMove.jsp',0,0,16,16397,10,'synergys',1,1,0,1,'',NULL)
GO
insert into synergy_base(id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree,frompagepara,samepageid)
values(28,'doc','/system/systemmonitor/docs/DocMonitor.jsp',0,0,16,16399,11,'synergys',1,1,0,1,'',NULL)
GO
delete from synergy_base where modulename='17992'
GO
delete from synergy_base where modulename='32610'
GO
update synergy_base set modulename = '18052' where id=27
GO
update synergy_base set modulename = '16757' where id=28
GO

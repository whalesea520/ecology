CREATE TABLE cptcode1(id int  not null,isuse int null,subcompanyflow varchar2(10) null,departmentflow varchar2(10) null,capitalgroupflow varchar2(10) null,capitaltypeflow varchar2(10) null,buydateflow varchar2(10) null,Warehousingflow varchar2(10) null,startcodenum int null,assetdataflow varchar2(10) null)
/
create sequence cptcode1_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cptcode1_TRIGGER before insert on cptcode1 for each row 
begin select cptcode1_ID.nextval into :new.id from dual; end;
/

insert into cptcode1(id,isuse,subcompanyflow,departmentflow,capitalgroupflow,capitaltypeflow,buydateflow,Warehousingflow,startcodenum,assetdataflow) Values(1,1,'','','1','','0|1','0|1',1,'')
/ 
  




CREATE TABLE cptcodeset1(id int  not null,codeid int null,showname varchar2(10) null,showtype int null,value varchar2(100) null,codeorder int null)
/
create sequence cptcodeset1_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cptcodeset1_TRIGGER before insert on cptcodeset1 for each row 
begin select cptcodeset1_ID.nextval into :new.id from dual; end;
/

insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(1,1,'18729',2,'',0)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(2,1,'20344',1,'1',1)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(3,1,'22291',1,'0',2)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(4,1,'18811',2,'2',3)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(5,1,'20571',2,'',4)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(6,1,'20572',2,'',5)
/
insert into cptcodeset1(id,codeid,showname,showtype,value,codeorder) Values(7,1,'20573',2,'',6)
/

CREATE TABLE cptcapitalcodeseq1(id int  not null,sequenceid int null,subcompanyid int null,departmentid int null,capitalgroupid int null,capitaltypeid int null,buydateyear int null,buydatemonth int null,buydateday int null,warehouseyear int null,warehousemonth int null,warehouseday int null,assetid int null)
/
create sequence cptcapitalcodeseq1_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cptcapitalcodeseq1_TRIGGER before insert on cptcapitalcodeseq1 for each row 
begin select cptcapitalcodeseq1_ID.nextval into :new.id from dual; end;
/

CREATE TABLE cptDefineField(id int  not null,billid int null,fieldname varchar2(60) null,fieldlabel int null,fielddbtype varchar2(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar2(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
/
create sequence cptDefineField_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cptDefineField_TRIGGER before insert on cptDefineField for each row 
begin select cptDefineField_ID.nextval into :new.id from dual; end;
/
CREATE TABLE cpt_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar2(250) null,id int  not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar2(660) null,docCategory varchar2(200) null,isAccordToSubCom char(1) null ,childitemid varchar2(2000) null,cancel varchar2(1) null)
/
create sequence cpt_SelectItem_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cpt_SelectItem_TRIGGER before insert on cpt_SelectItem for each row 
begin select cpt_SelectItem_ID.nextval into :new.id from dual; end;
/
CREATE TABLE cpt_specialfield(id int  not null,fieldid int null,displayname varchar2(1000) null,linkaddress varchar2(1000) null,descriptivetext varchar2(2000) null,isbill int null,isform int null)
/
create sequence cpt_specialfield_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cpt_specialfield_TRIGGER before insert on cpt_specialfield for each row 
begin select cpt_specialfield_ID.nextval into :new.id from dual; end;
/




CREATE or REPLACE PROCEDURE cpt_selectitem_insert_new 
( fieldid2 INT , isbill2 INT , selectvalue2 INT , selectname2 varchar2 , listorder2 NUMERIC , isdefault2 CHAR , cancel2 varchar2, flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor ) 
AS 
BEGIN
	INSERT  INTO cpt_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( fieldid2 , isbill2 , selectvalue2 , selectname2 , listorder2 , isdefault2,cancel2 );
END;
/


insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(1,0,'datefield1',31595,'char(10)','3',2,0,'','',0,'1',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(2,0,'datefield2',31596,'char(10)','3',2,0,'','',0,'2',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(3,0,'datefield3',31597,'char(10)','3',2,0,'','',0,'3',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(4,0,'datefield4',31598,'char(10)','3',2,0,'','',0,'4',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(5,0,'datefield5',31599,'char(10)','3',2,0,'','',0,'5',0,0,0,'0','0','1')
/


insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(6,0,'numberfield1',31600,'decimal(15,2)','1',3,0,'','',0,'6',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(7,0,'numberfield2',31601,'decimal(15,2)','1',3,0,'','',0,'7',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(8,0,'numberfield3',31602,'decimal(15,2)','1',3,0,'','',0,'8',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(9,0,'numberfield4',31603,'decimal(15,2)','1',3,0,'','',0,'9',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(10,0,'numberfield5',31604,'decimal(15,2)','1',3,0,'','',0,'10',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(11,0,'textfield1',31605,'varchar2(100)','1',1,0,'','',0,'11',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(12,0,'textfield2',31606,'varchar2(100)','1',1,0,'','',0,'12',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(13,0,'textfield3',31607,'varchar2(100)','1',1,0,'','',0,'13',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(14,0,'textfield4',31608,'varchar2(100)','1',1,0,'','',0,'14',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(15,0,'textfield5',31609,'varchar2(100)','1',1,0,'','',0,'15',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(16,0,'tinyintfield1',31610,'char(1)','4',1,0,'','',0,'16',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(17,0,'tinyintfield2',31611,'char(1)','4',1,0,'','',0,'17',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(18,0,'tinyintfield3',31612,'char(1)','4',1,0,'','',0,'18',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(19,0,'tinyintfield4',31613,'char(1)','4',1,0,'','',0,'19',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(20,0,'tinyintfield5',31614,'char(1)','4',1,0,'','',0,'20',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(21,0,'docff01name',32960,'text','3',37,0,'','',0,'21',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(22,0,'docff02name',32961,'text','3',37,0,'','',0,'22',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(23,0,'docff03name',32962,'text','3',37,0,'','',0,'23',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(24,0,'docff04name',32963,'text','3',37,0,'','',0,'24',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(25,0,'docff05name',32964,'text','3',37,0,'','',0,'25',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(26,0,'depff01name',32965,'text','3',57,0,'','',0,'26',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(27,0,'depff02name',32966,'text','3',57,0,'','',0,'27',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(28,0,'depff03name',32967,'text','3',57,0,'','',0,'28',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(29,0,'depff04name',32968,'text','3',57,0,'','',0,'29',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(30,0,'depff05name',32969,'text','3',57,0,'','',0,'30',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(31,0,'crmff01name',32970,'text','3',18,0,'','',0,'31',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(32,0,'crmff02name',32971,'text','3',18,0,'','',0,'32',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(33,0,'crmff03name',32972,'text','3',18,0,'','',0,'33',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(34,0,'crmff04name',32973,'text','3',18,0,'','',0,'34',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(35,0,'crmff05name',32974,'text','3',18,0,'','',0,'35',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(36,0,'reqff01name',32975,'text','3',152,0,'','',0,'36',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(37,0,'reqff02name',32976,'text','3',152,0,'','',0,'37',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(38,0,'reqff03name',32977,'text','3',152,0,'','',0,'38',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(39,0,'reqff04name',32978,'text','3',152,0,'','',0,'39',0,0,0,'0','0','1')
/
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(40,0,'reqff05name',32979,'text','3',152,0,'','',0,'40',0,0,0,'0','0','1')
/



CREATE OR REPLACE PROCEDURE cpt_selectitembyid_new (
   id_1                 VARCHAR2,
   isbill_1             VARCHAR2,
   flag        OUT      INTEGER,
   msg         OUT      VARCHAR2,
   thecursor   IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   OPEN thecursor FOR
      SELECT   *
          FROM cpt_SelectItem
         WHERE fieldid = id_1 AND isbill = isbill_1
         AND (cancel!='1' or cancel is null)
      ORDER BY listorder, ID;
END;
/

 
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 242,703,'int','/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypelBrowser.jsp','CptCapitalType','name','id','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 243,830,'int','/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp','CptCapitalState','name','id','')
/

alter table CptAssortmentShare add subcompanyid int
/
alter table CptCapitalShareInfo add subcompanyid int
/

drop procedure CptAssortmentShare_Insert
/
CREATE OR REPLACE PROCEDURE CptAssortmentShare_Insert (assortmentid_1 integer, sharetype_2 smallint, seclevel_3 smallint, rolelevel_4 smallint, sharelevel_5 smallint, userid_6 integer, departmentid_7 integer, roleid_8 integer, foralluser_9 smallint,subcompanyid_10 smallint, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )  AS begin INSERT INTO CptAssortmentShare ( assortmentid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid) VALUES ( assortmentid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9,subcompanyid_10); open thecursor for select max(id)  id from CptAssortmentShare; end;
/


drop procedure CptAssortmentShareInfo_Insert
/
CREATE OR REPLACE PROCEDURE CptAssortmentShareInfo_Insert (relateditemid_1 integer, sharetype_2 smallint, seclevel_3 smallint, rolelevel_4 smallint, sharelevel_5 smallint, userid_6 integer, departmentid_7 integer, roleid_8 integer, foralluser_9 smallint, sharefrom_10 integer,subcompanyid_11 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO CptCapitalShareInfo (relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser, sharefrom,subcompanyid) VALUES (relateditemid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9, sharefrom_10,subcompanyid_11); end;
/


drop procedure CptCapitalShareInfo_Insert
/
CREATE OR REPLACE PROCEDURE CptCapitalShareInfo_Insert (relateditemid_1 integer, sharetype_2 smallint, seclevel_3 smallint, rolelevel_4 smallint, sharelevel_5 smallint, userid_6 integer, departmentid_7 integer, roleid_8 integer, foralluser_9 smallint,subcompanyid_10 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor )  AS begin INSERT INTO CptCapitalShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid)    VALUES ( relateditemid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9,subcompanyid_10); open thecursor for select max(id)  id from CptCapitalShareInfo; end;
/


drop procedure CptCapitalAssortment_Select
/
CREATE OR REPLACE PROCEDURE CptCapitalAssortment_Select (  flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin open thecursor for select * from CptCapitalAssortment order by assortmentmark; end;
/

 
alter table CptCapitalAssortment add subcompanyid1 int
/

alter table CptCapital add capitalnum_1 decimal(18,2)
/
update CptCapital set capitalnum_1=capitalnum
/
alter table CptCapital drop column capitalnum
/
alter table CptCapital rename column capitalnum_1 to capitalnum
/


drop procedure CptUseLogBack_Insert
/
CREATE OR REPLACE PROCEDURE CptUseLogBack_Insert (capitalid_1 	integer, usedate_2 	char, usedeptid_3 	integer, useresourceid_4 	integer, usecount_5 	integer, useaddress_6 	varchar2, userequest_7 	integer, maintaincompany_8 	varchar2, fee_9 	decimal, usestatus_10 	varchar2, remark_11 	varchar2, costcenterid_12   integer, sptcount_13	char, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS num_1 integer ; begin if sptcount_13<>'1' then select capitalnum into num_1 from CptCapital where id = capitalid_1 ; end if;  INSERT INTO CptUseLog (capitalid , usedate , usedeptid , useresourceid , usecount , useaddress , userequest , maintaincompany , fee , usestatus , remark )  VALUES (capitalid_1, usedate_2, usedeptid_3, useresourceid_4, usecount_5, useaddress_6, userequest_7, maintaincompany_8, fee_9, '0', remark_11) ; if sptcount_13 ='1' then Update CptCapital Set departmentid=null where id = capitalid_1; Update CptCapital Set  costcenterid=null, resourceid=null, stateid = usestatus_10 where id = capitalid_1 ; else Update CptCapital Set capitalnum = num_1 + usecount_5 where id = capitalid_1 ; end if;  open thecursor for select 1 from dual; return; end;
/

insert into CptCapitalModifyField(field,name) values(77,'±àºÅ')
/
 


alter table Prj_ProjectType add dsporder decimal(10,2)
/

drop procedure Prj_ProjectType_Insert
/
CREATE OR REPLACE PROCEDURE Prj_ProjectType_Insert ( fullname_1 varchar2 , description_1 varchar2, wfid_1 integer, protypecode_1 varchar2, insertWorkPlan_1 char,dsporder_1 decimal,guid1_1 char, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO Prj_ProjectType ( fullname, description, wfid, protypecode, insertWorkPlan,dsporder,guid1) VALUES ( fullname_1, description_1, wfid_1, protypecode_1, insertWorkPlan_1,dsporder_1,guid1_1) ; end;
/


drop procedure Prj_ProjectType_Update
/
CREATE OR REPLACE PROCEDURE Prj_ProjectType_Update ( id_1	 	integer, fullname_1 	varchar2, description_1 	varchar2, protypecode_1 varchar2, wfid_1	 	integer, insertWorkPlan_1 char,dsporder_1 decimal, flag out	integer, msg	out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin UPDATE Prj_ProjectType SET  fullname=fullname_1, description=description_1, wfid=wfid_1, protypecode=protypecode_1, insertWorkPlan=insertWorkPlan_1,dsporder=dsporder_1 WHERE (id=id_1); end;
/


alter table Prj_T_ShareInfo add subcompanyid int
/
drop procedure Prj_T_ShareInfo_Insert
/
CREATE OR REPLACE PROCEDURE Prj_T_ShareInfo_Insert ( relateditemid_1 integer, sharetype_1 smallint, seclevel_1  smallint, rolelevel_1 smallint, sharelevel_1 smallint, userid_1 integer, departmentid_1 integer, roleid_1 integer, foralluser_1 smallint,subcompanyid_1 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin INSERT INTO Prj_T_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid ) VALUES ( relateditemid_1 , sharetype_1 , seclevel_1 , rolelevel_1 , sharelevel_1, userid_1, departmentid_1, roleid_1, foralluser_1,subcompanyid_1  ) ; end;
/


alter table Prj_WorkType add dsporder decimal(10,2)
/

drop procedure Prj_ProjectType_Insert
/
CREATE OR REPLACE PROCEDURE Prj_ProjectType_Insert ( fullname_1 varchar2 , description_1 varchar2, wfid_1 integer, protypecode_1 varchar2, insertWorkPlan_1 char,dsporder_1 decimal,guid1_1 char, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO Prj_ProjectType ( fullname, description, wfid, protypecode, insertWorkPlan,dsporder,guid1) VALUES ( fullname_1, description_1, wfid_1, protypecode_1, insertWorkPlan_1,dsporder_1,guid1_1) ; end;
/

drop procedure Prj_ProjectType_Update
/
CREATE OR REPLACE PROCEDURE Prj_ProjectType_Update ( id_1	 	integer, fullname_1 	varchar2, description_1 	varchar2, protypecode_1 varchar2, wfid_1	 	integer, insertWorkPlan_1 char,dsporder_1 decimal, flag out	integer, msg	out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin UPDATE Prj_ProjectType SET  fullname=fullname_1, description=description_1, wfid=wfid_1, protypecode=protypecode_1, insertWorkPlan=insertWorkPlan_1,dsporder=dsporder_1 WHERE (id=id_1); end;
/

drop procedure Prj_WorkType_Insert
/
CREATE OR REPLACE PROCEDURE Prj_WorkType_Insert ( fullname_1 	Varchar2, description_2 	Varchar2, worktypecode_3 Varchar2,dsporder_1 decimal, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS BEGIN INSERT INTO Prj_WorkType (fullname, description,worktypecode,dsporder) VALUES ( fullname_1, description_2,worktypecode_3,dsporder_1); END;
/




drop procedure Prj_WorkType_Update
/
CREATE OR REPLACE PROCEDURE Prj_WorkType_Update ( id_1	 	integer, fullname_2 	Varchar2, description_3 	Varchar2, worktypecode_4 Varchar2,dsporder_1 decimal, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS BEGIN UPDATE Prj_WorkType SET  fullname	 = fullname_2, description = description_3,worktypecode= worktypecode_4,dsporder=dsporder_1 WHERE ( id	 = id_1); END;
/


CREATE TABLE Prj_code(id int  not null,isuse int null,subcompanyflow varchar2(10) null,departmentflow varchar2(10) null,capitalgroupflow varchar2(10) null,capitaltypeflow varchar2(10) null,buydateflow varchar2(10) null,Warehousingflow varchar2(10) null,startcodenum int null,assetdataflow varchar2(10) null)
/
create sequence Prj_code_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Prj_code_TRIGGER before insert on Prj_code for each row 
begin select Prj_code_ID.nextval into :new.id from dual; end;
/

insert into prj_code(id,isuse,subcompanyflow,departmentflow,capitalgroupflow,capitaltypeflow,buydateflow,Warehousingflow,startcodenum,assetdataflow) Values(1,1,'','','','','0|1','0|',1,'')
/


CREATE TABLE prj_codeseq(id int  not null,sequenceid int null,subcompanyid int null,departmentid int null,capitalgroupid int null,capitaltypeid int null,buydateyear int null,buydatemonth int null,buydateday int null,warehouseyear int null,warehousemonth int null,warehouseday int null,assetid int null)
/
create sequence prj_codeseq_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_codeseq_TRIGGER before insert on prj_codeseq for each row 
begin select prj_codeseq_ID.nextval into :new.id from dual; end;
/


CREATE TABLE Prj_Settings(
id int  not null,
subcompanyid int,
departmentid int,
userid int,
prj_dsc_doc char(1),
prj_dsc_wf char(1),
prj_dsc_crm char(1),
prj_dsc_prj char(1),
prj_dsc_tsk char(1),
prj_dsc_acc char(1),
prj_dsc_accsec int,
tsk_dsc_doc char(1),
tsk_dsc_wf char(1),
tsk_dsc_crm char(1),
tsk_dsc_prj char(1),
tsk_dsc_tsk char(1),
tsk_dsc_acc char(1),
tsk_dsc_accsec int,
prj_acc char(1),
prj_accsec int,
tsk_acc char(1),
tsk_accsec int,
prj_gnt_showplan_ char(1),
prj_gnt_warningday int
)
/

create sequence Prj_Settings_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Prj_Settings_TRIGGER before insert on Prj_Settings for each row 
begin select Prj_Settings_ID.nextval into :new.id from dual; end;
/



insert into Prj_Settings(id) values(-1)
/

CREATE TABLE prjDefineField(id int  not null,billid int null,fieldname varchar2(60) null,fieldlabel int null,fielddbtype varchar2(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar2(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
/
create sequence prjDefineField_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prjDefineField_TRIGGER before insert on prjDefineField for each row 
begin select prjDefineField_ID.nextval into :new.id from dual; end;
/


CREATE TABLE prj_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar2(250) null,id int  not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar2(660) null,docCategory varchar2(200) null,isAccordToSubCom char(1) null ,childitemid varchar2(2000) null,cancel varchar2(1) null )
/
create sequence prj_SelectItem_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_SelectItem_TRIGGER before insert on prj_SelectItem for each row 
begin select prj_SelectItem_ID.nextval into :new.id from dual; end;
/

CREATE TABLE prj_specialfield(id int  not null,fieldid int null,displayname varchar2(1000) null,linkaddress varchar2(1000) null,descriptivetext varchar2(2000) null,isbill int null,isform int null)
/
create sequence prj_specialfield_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_specialfield_TRIGGER before insert on prj_specialfield for each row 
begin select prj_specialfield_ID.nextval into :new.id from dual; end;
/


CREATE or REPLACE PROCEDURE prj_selectitem_insert_new 
( fieldid2 INT , isbill2 INT , selectvalue2 INT , selectname2 varchar2 , listorder2 NUMERIC , isdefault2 CHAR , cancel2 varchar2, flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor ) 
AS 
BEGIN
	INSERT  INTO prj_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( fieldid2 , isbill2 , selectvalue2 , selectname2 , listorder2 , isdefault2,cancel2 );
END;
/

insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(1,0,'datefield1',31595,'char(10)','3',2,0,'','',0,'1',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(2,0,'datefield2',31596,'char(10)','3',2,0,'','',0,'2',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(3,0,'datefield3',31597,'char(10)','3',2,0,'','',0,'3',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(4,0,'datefield4',31598,'char(10)','3',2,0,'','',0,'4',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(5,0,'datefield5',31599,'char(10)','3',2,0,'','',0,'5',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(6,0,'numberfield1',31600,'decimal(15,2)','1',3,0,'','',0,'6',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(7,0,'numberfield2',31601,'decimal(15,2)','1',3,0,'','',0,'7',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(8,0,'numberfield3',31602,'decimal(15,2)','1',3,0,'','',0,'8',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(9,0,'numberfield4',31603,'decimal(15,2)','1',3,0,'','',0,'9',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(10,0,'numberfield5',31604,'decimal(15,2)','1',3,0,'','',0,'10',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(11,0,'textfield1',31605,'varchar2(100)','1',1,0,'','',0,'11',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(12,0,'textfield2',31606,'varchar2(100)','1',1,0,'','',0,'12',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(13,0,'textfield3',31607,'varchar2(100)','1',1,0,'','',0,'13',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(14,0,'textfield4',31608,'varchar2(100)','1',1,0,'','',0,'14',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(15,0,'textfield5',31609,'varchar2(100)','1',1,0,'','',0,'15',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(16,0,'tinyintfield1',31610,'char(1)','4',1,0,'','',0,'16',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(17,0,'tinyintfield2',31611,'char(1)','4',1,0,'','',0,'17',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(18,0,'tinyintfield3',31612,'char(1)','4',1,0,'','',0,'18',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(19,0,'tinyintfield4',31613,'char(1)','4',1,0,'','',0,'19',0,0,0,'0','0','1')
/
insert into prjDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused) Values(20,0,'tinyintfield5',31614,'char(1)','4',1,0,'','',0,'20',0,0,0,'0','0','1')
/

alter table Prj_Template add updatedate char(10)
/

alter table cus_formfield add prj_isopen char(1)
/
alter table cus_formfield add prj_fieldlabel int
/

update cus_formfield set prj_isopen='1'
/

alter table cus_selectitem add prj_isdefault char(1)
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 244,586,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp','Prj_ProjectType','fullname','id','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 245,432,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp','Prj_WorkType','fullname','id','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 246,587,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectStatusBrowser.jsp','Prj_ProjectStatus','description','id','')
/



CREATE TABLE Prj_TaskShareInfo(id int  not null,relateditemid int null,sharetype int null,seclevel int null,rolelevel int null,sharelevel int null,userid int null,departmentid int null,roleid int null,foralluser int null,crmid int null,sharefrom int null,subcompanyid int null )
/
create sequence Prj_TaskShareInfo_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Prj_TaskShareInfo_TRIGGER before insert on Prj_TaskShareInfo for each row 
begin select Prj_TaskShareInfo_ID.nextval into :new.id from dual; end;
/
 
 
CREATE PROCEDURE Prj_TaskShareInfo_Delete (id_1 int, flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor)  
AS 
BEGIN
	DELETE Prj_TaskShareInfo  WHERE ( id = id_1) ;
END;
/

CREATE PROCEDURE Prj_TaskShareInfo_Insert 
(relateditemid_1 int, sharetype_2 int, seclevel_3 int, rolelevel_4 int, sharelevel_5 int, userid_6 int, departmentid_7 int, roleid_8 int, foralluser_9 int,subcompanyid_10 int, flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor)  
AS 
BEGIN
	INSERT INTO Prj_TaskShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid)  VALUES ( relateditemid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, userid_6, departmentid_7, roleid_8, foralluser_9,subcompanyid_10);
	open thecursor for   select max(id)  id from Prj_TaskShareInfo ;
END;
/

CREATE OR REPLACE FUNCTION getPrjBeginDate
(i_prjid int)
RETURN char IS
o_mindate char(10);
BEGIN
  SELECT MIN(begindate) into o_mindate  FROM Prj_TaskProcess WHERE prjid=i_prjid;
  Return o_mindate;
END;
/

CREATE OR REPLACE FUNCTION getPrjEndDate
(i_prjid int)
RETURN char IS
o_maxdate char(10);
BEGIN
	SELECT MAX(enddate) into o_maxdate  FROM Prj_TaskProcess WHERE prjid=i_prjid;
	Return o_maxdate;
END;
/

CREATE OR REPLACE FUNCTION getPrjFinish
(i_prjid int)
RETURN int IS
i_sumWorkday decimal(9);
i_finish int default 0;
BEGIN
	SELECT SUM(workday) into i_sumWorkday FROM Prj_TaskProcess WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1') ;
	IF i_sumWorkday<>0 then
		SELECT (sum(finish*workday)/sum(workday)) into i_finish  FROM Prj_TaskProcess WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1') ;
	END IF;
Return i_finish;
END;
/

update Task_Modify set fieldname='1352' where fieldname='subject'
/
update Task_Modify set fieldname='17501' where fieldname='realManDays'
/
update Task_Modify set fieldname='2097' where fieldname='hrmid'
/
update Task_Modify set fieldname='1322' where fieldname='begindate'
/
update Task_Modify set fieldname='741' where fieldname='enddate'
/
update Task_Modify set fieldname='1298' where fieldname='workday'
/
update Task_Modify set fieldname='555' where fieldname='finish'
/
update Task_Modify set fieldname='15274' where fieldname='fixedcost'
/
update Task_Modify set fieldname='2232' where fieldname='islandmark'
/
update Task_Modify set fieldname='2240' where fieldname='content'
/
update Task_Modify set fieldname='2233' where fieldname='pretask'
/
update Task_Modify set fieldname='33351' where fieldname='actualbegindate'
/
update Task_Modify set fieldname='24697' where fieldname='actualenddate'
/

alter table Prj_SearchMould add finish int
/
alter table Prj_SearchMould add finish1 int
/
alter table Prj_SearchMould add subcompanyid1 int
/
alter table Prj_ShareInfo add subcompanyid int
/

drop procedure Prj_ShareInfo_Insert
/
CREATE OR REPLACE PROCEDURE Prj_ShareInfo_Insert (relateditemid1 integer, sharetype1 smallint, seclevel1  smallint, rolelevel1 smallint, sharelevel1 smallint, userid1 integer, departmentid1 integer, roleid1 integer, foralluser1 smallint,subcompanyid1 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin INSERT INTO Prj_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid ) VALUES ( relateditemid1 , sharetype1 , seclevel1 , rolelevel1 , sharelevel1, userid1, departmentid1, roleid1, foralluser1,subcompanyid1  ) ; end;
/
CREATE OR REPLACE PROCEDURE prj_selectitembyid_new (
   id_1                 VARCHAR2,
   isbill_1             VARCHAR2,
   flag        OUT      INTEGER,
   msg         OUT      VARCHAR2,
   thecursor   IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   OPEN thecursor FOR
      SELECT   *
          FROM prj_SelectItem
         WHERE fieldid = id_1 AND isbill = isbill_1
         AND (cancel!='1' or cancel is null)
      ORDER BY listorder, ID;
END;
/


alter table prj_taskprocess add accessory varchar2(2000)
/
alter table Exchange_Info add accessory varchar2(2000)
/

alter table Exchange_Info add relatedtsk varchar2(2000)
/
alter table Exchange_Info add tskids varchar2(2000)
/

CREATE OR REPLACE PROCEDURE ExchangeInfo_Insert_PRJ
( sortid_1 int  , name_1  varchar2, 
remark_1 varchar2  , creater_1  int  ,
createDate_1  char    , 
createTime_1  char   , type_n_1 char, 
relateddoc_1	varchar2, 
relatedwf_1	varchar2, 
relatedcus_1	varchar2, 
relatedprj_1	varchar2, 
relatedtsk_1	varchar2, 
relatedacc_1	varchar2, 
flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor)  
AS 
BEGIN
INSERT INTO Exchange_Info( sortid , name , 
remark , creater , createDate , createTime, type_n, 
docids, requestIds, crmIds, projectIds, tskids,accessory)  
VALUES( sortid_1 , name_1, 
remark_1, creater_1 , createDate_1 , createTime_1, type_n_1, 
relateddoc_1, relatedwf_1, relatedcus_1, relatedprj_1, relatedtsk_1,relatedacc_1) ;
END;
/


insert into Prj_ProjectStatus (
  id
  ,fullname
  ,description
) VALUES (
  0
  , 220
  ,'²Ý¸å'
)
/

alter TABLE Prj_Template add accessory varchar2(2000)
/
alter TABLE Prj_TemplateTask add accessory varchar2(2000)
/
alter table Prj_TaskInfo add realManDays decimal(6,1)
/
alter table Prj_TaskInfo add actualBeginDate varchar2(10)
/
alter table Prj_TaskInfo add actualEndDate varchar2(10)
/
alter table Prj_TaskInfo add finish int
/

alter table Prj_TempletTask_needdoc add isTempletTask char(1)
/
alter table Prj_TempletTask_needwf add isTempletTask char(1)
/
alter table Prj_TempletTask_referdoc add isTempletTask char(1)
/

alter table Prj_TaskInfo add status int
/
alter table Prj_TaskInfo add islandmark char(1)
/

CREATE TABLE Prj_XchgInfo_ViewLog
(
id int  not null,
xchg_id int  null,
sortid int  null,
type_n char(2) null,
viewer_id int null,
view_date varchar2(50) null,
view_time varchar2(50) null
)
/
create sequence Prj_XchgInfo_ViewLog_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Prj_XchgInfo_ViewLog_TRIGGER before insert on Prj_XchgInfo_ViewLog for each row 
begin select Prj_XchgInfo_ViewLog_ID.nextval into :new.id from dual; end;
/


alter table Prj_TaskInfo add creater int
/
alter table Prj_TaskInfo add createdate varchar2(50)
/
alter table Prj_TaskInfo add createtime varchar2(50)
/

drop procedure Prj_Plan_SaveFromProcess
/
CREATE OR REPLACE PROCEDURE Prj_Plan_SaveFromProcess 
(prjid_1 	integer, version_1	smallint,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) 
AS  
taskid_1 	integer; wbscoding_1 	varchar2(20); subject_1 	varchar2(50); begindate_1 	varchar2(10); enddate_1 	varchar2(10); workday_1        number (10,1); content_1 	varchar2(255); fixedcost_1	number(10,2); parentid_1	integer; parentids_1	varchar2(255); parenthrmids_1	varchar2(255); level_1		smallint; hrmid_1		integer;  CURSOR all_cursor is select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1, content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,'1',version_1,creater_1,createdate_1,createtime_1); end  loop;   CLOSE all_cursor; end;
/

drop procedure Prj_Plan_Approve
/
CREATE OR REPLACE PROCEDURE Prj_Plan_Approve (prjid_1 	integer,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) AS  taskid_1 	integer; wbscoding_1 	varchar2(200); subject_1 	varchar2(500); begindate_1 	varchar2(50); enddate_1 	varchar2(50); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	number(18,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000); level_1		smallint; hrmid_1		integer;   CURSOR all_cursor is select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,2,1,creater_1,createdate_1,createtime_1); end  loop;  CLOSE all_cursor; end;
/



























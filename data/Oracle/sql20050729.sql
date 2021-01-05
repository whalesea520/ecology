INSERT INTO HtmlLabelIndex values(17749,'所属项目') 
/
INSERT INTO HtmlLabelInfo VALUES(17749,'所属项目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17749,'Affiliated Project',8) 
/
INSERT INTO HtmlLabelIndex values(17855,'协作') 
/
INSERT INTO HtmlLabelInfo VALUES(17855,'协作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17855,'Coworks',8) 
/
INSERT INTO HtmlLabelIndex values(17859,'新建协作事件') 
/
INSERT INTO HtmlLabelInfo VALUES(17859,'新建协作事件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17859,'New Cowork',8) 
/

alter table cowork_items modify(relatedprj varchar2(500))
/
alter table cowork_items modify(relatedcus varchar2(500))
/
alter table cowork_items modify(relatedwf varchar2(500))
/
alter table cowork_items modify(relateddoc varchar2(500))
/
alter table cowork_items add userids varchar2(4000)
/

update cowork_items set relatedprj = '' where relatedprj='0'
/
update cowork_items set relatedcus = '' where relatedcus='0'
/
update cowork_items set relatedwf = '' where relatedwf='0'
/
update cowork_items set relateddoc = '' where relateddoc='0'
/
create or replace  PROCEDURE cowork_items_insert
	(name_1 	varchar2,
	 typeid_2 	integer,
	 levelvalue_3 	integer,
	 creater_4 	integer,
	 coworkers_5 	varchar2,
	 createdate_6 	char,
	 createtime_7 	char,
	 begindate_8 	char,
	 beingtime_9 	char,
	 enddate_10 	char,
	 endtime_11 	char,
	 relatedprj_12 varchar2,
	 relatedcus_13 varchar2,
	 relatedwf_14 	varchar2,
	 relateddoc_15 varchar2,
	 remark_16 	Varchar2,
	 status_17 	integer,
	 isnew 	varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO cowork_items 
	 ( name,
	 typeid,
	 levelvalue,
	 creater,
	 coworkers,
	 createdate,
	 createtime,
	 begindate,
	 beingtime,
	 enddate,
	 endtime,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc,
	 remark,
	 status,
	 isnew) 
 
VALUES 
	( name_1,
	 typeid_2,
	 levelvalue_3,
	 creater_4,
	 coworkers_5,
	 createdate_6,
	 createtime_7,
	 begindate_8,
	 beingtime_9,
	 enddate_10,
	 endtime_11,
	 relatedprj_12,
	 relatedcus_13,
	 relatedwf_14,
	 relateddoc_15,
	 remark_16,
	 status_17,
	 isnew);
open thecursor for
select max(id) from cowork_items;
end;
/

CREATE or REPLACE PROCEDURE cowork_items_update
	(id_1 	integer,
	 name_2 	varchar2,
	 typeid_3 	integer,
	 levelvalue_4 	integer,
	 creater_5 	integer,
	 coworkers_6 	varchar2,
	 begindate_7 	char,
	 beingtime_8 	char,
	 enddate_9 	char,
	 endtime_10 	char,
	 relatedprj_11 varchar2,
	 relatedcus_12 varchar2,
	 relatedwf_13 	varchar2,
	 relateddoc_14 varchar2,
	 remark_15 	varchar2,
	 isnew_16 	varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE cowork_items SET  
	 name	 = name_2,
	 typeid	 = typeid_3,
	 levelvalue	 = levelvalue_4,
	 creater	 = creater_5,
	 coworkers	 = coworkers_6,
	 begindate	 = begindate_7,
	 beingtime	 = beingtime_8,
	 enddate	 = enddate_9,
	 endtime	 = endtime_10,
	 relatedprj	 = relatedprj_11,
	 relatedcus	 = relatedcus_12,
	 relatedwf	 = relatedwf_13,
	 relateddoc	 = relateddoc_14,
	 remark	 = remark_15,
	 isnew	 = isnew_16 
WHERE ( id	 = id_1);
end;
/
ALTER TABLE cowork_discuss ADD relatedprj varchar2(500) NULL
/
ALTER TABLE cowork_discuss ADD relatedcus varchar2(500) NULL
/
ALTER TABLE cowork_discuss ADD relatedwf varchar2(500) NULL
/
ALTER TABLE cowork_discuss ADD relateddoc varchar2(500) NULL
/
CREATE or REPLACE PROCEDURE cowork_discuss_insert
	(coworkid_1 	integer,
	 discussant_2 	integer,
	 createdate_3 	char,
	 createtime_4 	char,
	 remark_5 	varchar2,
	 relatedprj_6  varchar2,
	 relatedcus_7  varchar2,
	 relatedwf_8 	varchar2,
	 relateddoc_9  varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO cowork_discuss 
	 (coworkid,
	 discussant,
	 createdate,
	 createtime,
	 remark,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc) 
VALUES 
	( coworkid_1,
	 discussant_2,
	 createdate_3,
	 createtime_4,
	 remark_5,
	 relatedprj_6,
	 relatedcus_7,
	 relatedwf_8,
	 relateddoc_9);
end;
/
CREATE TABLE cowork_log (
	coworkid integer NULL ,
	type integer NULL ,
	modifydate varchar2 (10) NULL ,
	modifytime varchar2 (8) NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL 
)
/



CREATE or REPLACE PROCEDURE cowork_log_insert
	(coworkid_1 	integer,
	 type_2 	integer,
	 modifydate_3 	char,
	 modifytime_4 	char,
	 modifier_5 	integer,
	 clientip_6  char,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO cowork_log 
	 ( coworkid,
	 type,
	 modifydate,
	 modifytime,
	 modifier,
	 clientip) 
 VALUES 
	( coworkid_1,
	 type_2,
	 modifydate_3,
	 modifytime_4,
	 modifier_5,
	 clientip_6);
end;
/
ALTER TABLE WorkPlan ADD relatedprj varchar2(500) NULL
/
ALTER TABLE WorkPlan ADD relatedcus varchar2(500) NULL
/
ALTER TABLE WorkPlan ADD relatedwf varchar2(500) NULL
/
ALTER TABLE WorkPlan ADD relateddoc varchar2(500) NULL
/
CREATE or REPLACE PROCEDURE WorkPlan_InsertPlus (
	type_n_1 char,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,
	description_1 varchar2,
	requestid_1 varchar2,
	projectid_1 varchar2,
	crmid_1 varchar2,
	docid_1 varchar2,
	meetingid_1 varchar2,
	isremind_1 integer,
	waketime_1 integer,
	createrid_1 integer,
	createrType_1 char,
	createdate_1 char,
	createtime_1 char,
	taskid_1 varchar2,
	urgentLevel_1 char,
	status_1 char,
	relatedprj_1	varchar2,
	relatedcus_1	varchar2,
	relatedwf_1	varchar2,
	relateddoc_1	varchar2,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
 m_id integer;
 m_deptId integer;
 m_subcoId integer;
begin
INSERT INTO WorkPlan (
	type_n,
	name,
	resourceid,
	begindate,
	begintime,
	enddate,
	endtime,
	description,
	requestid,
	projectid,
	crmid,
	docid,
	meetingid,
	status,
	isremind,
	waketime,
	createrid,
	createdate,
	createtime,
	deleted,
	taskid,
	urgentLevel,
	createrType,
	relatedprj,
	relatedcus,
	relatedwf,
	relateddoc
) VALUES (
	type_n_1,
	name_1,
	resourceid_1,
	begindate_1,
	begintime_1,
	enddate_1,
	endtime_1,
	description_1,
	requestid_1,
	projectid_1,
	crmid_1,
	docid_1,
	meetingid_1,
	status_1,
	isremind_1,
	waketime_1,
	createrid_1,
	createdate_1,
	createtime_1,
	'0',
	taskid_1,
	urgentLevel_1,
	createrType_1,
	relatedprj_1,
	relatedcus_1,
	relatedwf_1,
	relateddoc_1
);
SELECT MAX(id) into m_id  FROM WorkPlan;
SELECT departmentid , subcompanyid1 into m_deptId  , m_subcoId   FROM HrmResource WHERE id = createrid_1;
UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
open thecursor for 
select m_id  id  from dual;
end;
/

ALTER TABLE Exchange_Info ADD relatedprj varchar2(500) NULL
/
ALTER TABLE Exchange_Info ADD relatedcus varchar2(500) NULL
/
ALTER TABLE Exchange_Info ADD relatedwf varchar2(500) NULL
/
ALTER TABLE Exchange_Info ADD relateddoc varchar2(500) NULL
/

/***
*销售机会相关交流 type_n=CS 
*客户相关交流    type_n=CC
*客户联系相关交流 type_n=CT
*合同的相关交流	type_n=CH
*项目的相关交流   type_n=PP
*任务的相关交流	type_n=PT
*
*
*/

CREATE or REPLACE PROCEDURE ExchangeInfo_Insert( 
	sortid_1 integer  ,
	name_1  varchar2 ,
	remark_1 varchar2  ,
	creater_1  integer  ,
	createDate_1  char  ,
	createTime_1  char ,
	type_n_1 char,
	docids_1 varchar2,
 	relatedprj_1	varchar2,
	relatedcus_1	varchar2,
	relatedwf_1	varchar2,
	relateddoc_1	varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO Exchange_Info(
	sortid ,
	name , 
	remark , 
	creater ,
	createDate ,
	createTime,
	type_n,
	docids,
	relatedprj,
	relatedcus,
	relatedwf,
	relateddoc) 
VALUES(
	sortid_1 ,
	name_1,
	remark_1,
	creater_1 ,
	createDate_1 ,
	createTime_1,
	type_n_1,
	docids_1,
	relatedprj_1,
	relatedcus_1,
	relatedwf_1,
	relateddoc_1);
end;
/
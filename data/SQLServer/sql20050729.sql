INSERT INTO HtmlLabelIndex values(17749,'所属项目') 
GO
INSERT INTO HtmlLabelInfo VALUES(17749,'所属项目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17749,'Affiliated Project',8) 
GO
INSERT INTO HtmlLabelIndex values(17855,'协作') 
GO
INSERT INTO HtmlLabelInfo VALUES(17855,'协作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17855,'Coworks',8) 
GO
INSERT INTO HtmlLabelIndex values(17859,'新建协作事件') 
GO
INSERT INTO HtmlLabelInfo VALUES(17859,'新建协作事件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17859,'New Cowork',8) 
GO

alter table cowork_items alter column relatedprj varchar(500)
GO
alter table cowork_items alter column relatedcus varchar(500)
GO
alter table cowork_items alter column relatedwf varchar(500)
GO
alter table cowork_items alter column relateddoc varchar(500)
GO
alter table cowork_items add userids varchar(5000)
GO

update cowork_items set relatedprj = '' where relatedprj='0'
GO
update cowork_items set relatedcus = '' where relatedcus='0'
GO
update cowork_items set relatedwf = '' where relatedwf='0'
GO
update cowork_items set relateddoc = '' where relateddoc='0'
GO



alter PROCEDURE cowork_items_insert
	(@name_1 	varchar(100),
	 @typeid_2 	int,
	 @levelvalue_3 	int,
	 @creater_4 	int,
	 @coworkers_5 	varchar(255),
	 @createdate_6 	char(10),
	 @createtime_7 	char(5),
	 @begindate_8 	char(10),
	 @beingtime_9 	char(5),
	 @enddate_10 	char(10),
	 @endtime_11 	char(5),
	 @relatedprj_12 varchar(500),
	 @relatedcus_13 varchar(500),
	 @relatedwf_14 	varchar(500),
	 @relateddoc_15 varchar(500),
	 @remark_16 	text,
	 @status_17 	int,
	 @isnew 	varchar(255),
	@flag integer output , 
  	@msg varchar(80) output)

AS INSERT INTO cowork_items 
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
	( @name_1,
	 @typeid_2,
	 @levelvalue_3,
	 @creater_4,
	 @coworkers_5,
	 @createdate_6,
	 @createtime_7,
	 @begindate_8,
	 @beingtime_9,
	 @enddate_10,
	 @endtime_11,
	 @relatedprj_12,
	 @relatedcus_13,
	 @relatedwf_14,
	 @relateddoc_15,
	 @remark_16,
	 @status_17,
	 @isnew)
	 
	 
select max(id) from cowork_items
GO

alter PROCEDURE cowork_items_update
	(@id_1 	int,
	 @name_2 	varchar(100),
	 @typeid_3 	int,
	 @levelvalue_4 	int,
	 @creater_5 	int,
	 @coworkers_6 	varchar(255),
	 @begindate_7 	char(10),
	 @beingtime_8 	char(5),
	 @enddate_9 	char(10),
	 @endtime_10 	char(5),
	 @relatedprj_11 varchar(500),
	 @relatedcus_12 varchar(500),
	 @relatedwf_13 	varchar(500),
	 @relateddoc_14 varchar(500),
	 @remark_15 	text,
	 @isnew_16 	varchar(255),
	@flag integer output , 
  	@msg varchar(80) output)

AS UPDATE cowork_items 

SET  name	 = @name_2,
	 typeid	 = @typeid_3,
	 levelvalue	 = @levelvalue_4,
	 creater	 = @creater_5,
	 coworkers	 = @coworkers_6,
	 begindate	 = @begindate_7,
	 beingtime	 = @beingtime_8,
	 enddate	 = @enddate_9,
	 endtime	 = @endtime_10,
	 relatedprj	 = @relatedprj_11,
	 relatedcus	 = @relatedcus_12,
	 relatedwf	 = @relatedwf_13,
	 relateddoc	 = @relateddoc_14,
	 remark	 = @remark_15,
	 isnew	 = @isnew_16 

WHERE 
	( id	 = @id_1)

GO


ALTER TABLE cowork_discuss ADD relatedprj varchar(500) NULL
go
ALTER TABLE cowork_discuss ADD relatedcus varchar(500) NULL
GO
ALTER TABLE cowork_discuss ADD relatedwf varchar(500) NULL
GO
ALTER TABLE cowork_discuss ADD relateddoc varchar(500) NULL
GO



alter PROCEDURE cowork_discuss_insert
	(@coworkid_1 	int,
	 @discussant_2 	int,
	 @createdate_3 	char(10),
	 @createtime_4 	char(5),
	 @remark_5 	text,
	 @relatedprj_6  varchar(500),
	 @relatedcus_7  varchar(500),
	 @relatedwf_8 	varchar(500),
	 @relateddoc_9  varchar(500),
	 @flag integer output , 
  	 @msg varchar(80) output)

AS INSERT INTO cowork_discuss 
	 ( coworkid,
	 discussant,
	 createdate,
	 createtime,
	 remark,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc) 
 
VALUES 
	( @coworkid_1,
	 @discussant_2,
	 @createdate_3,
	 @createtime_4,
	 @remark_5,
	 @relatedprj_6,
	 @relatedcus_7,
	 @relatedwf_8,
	 @relateddoc_9)
	 

GO



CREATE TABLE cowork_log (
	coworkid int NULL ,
	type int NULL ,
	modifydate varchar (10) ,
	modifytime varchar (8) ,
	modifier int NULL ,
	clientip char (15)  NULL 
) 
GO



CREATE PROCEDURE cowork_log_insert
	(@coworkid_1 	int,
	 @type_2 	int,
	 @modifydate_3 	char(10),
	 @modifytime_4 	char(8),
	 @modifier_5 	int,
	 @clientip_6  char(15),
	 @flag integer output , 
  	 @msg varchar(80) output)

AS INSERT INTO cowork_log 
	 ( coworkid,
	 type,
	 modifydate,
	 modifytime,
	 modifier,
	 clientip) 
 
VALUES 
	( @coworkid_1,
	 @type_2,
	 @modifydate_3,
	 @modifytime_4,
	 @modifier_5,
	 @clientip_6)
	 

GO


ALTER TABLE WorkPlan ADD relatedprj varchar(500) NULL
go
ALTER TABLE WorkPlan ADD relatedcus varchar(500) NULL
go
ALTER TABLE WorkPlan ADD relatedwf varchar(500) NULL
go
ALTER TABLE WorkPlan ADD relateddoc varchar(500) NULL
GO



alter PROCEDURE WorkPlan_InsertPlus (
	@type_n_1 char(1),
	@name_1 varchar(100),
	@resourceid_1 varchar(200),
	@begindate_1 char(10),
	@begintime_1 char(8),
	@enddate_1 char(10),
	@endtime_1 char(8),
	@description_1 text,
	@requestid_1 varchar(100),
	@projectid_1 varchar(100),
	@crmid_1 varchar(100),
	@docid_1 varchar(100),
	@meetingid_1 varchar(100),
	@isremind_1 int,
	@waketime_1 int,
	@createrid_1 int,
	@createrType_1 char(1),
	@createdate_1 char(10),
	@createtime_1 char(8),
	@taskid_1 varchar(100),
	@urgentLevel_1 char(1),
	@status_1 char(1),
	@relatedprj_1	varchar(500),
	@relatedcus_1	varchar(500),
	@relatedwf_1	varchar(500),
	@relateddoc_1	varchar(500),
	@flag integer output,
	@msg varchar(80) output)
AS INSERT INTO WorkPlan (
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
	@type_n_1,
	@name_1,
	@resourceid_1,
	@begindate_1,
	@begintime_1,
	@enddate_1,
	@endtime_1,
	@description_1,
	@requestid_1,
	@projectid_1,
	@crmid_1,
	@docid_1,
	@meetingid_1,
	@status_1,
	@isremind_1,
	@waketime_1,
	@createrid_1,
	@createdate_1,
	@createtime_1,
	'0',
	@taskid_1,
	@urgentLevel_1,
	@createrType_1,
	@relatedprj_1,
	@relatedcus_1,
	@relatedwf_1,
	@relateddoc_1
)

DECLARE @m_id int 
DECLARE @m_deptId int 
DECLARE @m_subcoId int  
SELECT @m_id = MAX(id) FROM WorkPlan SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1 
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id SELECT @m_id AS id
GO


ALTER TABLE Exchange_Info ADD relatedprj varchar(500) NULL
go
ALTER TABLE Exchange_Info ADD relatedcus varchar(500) NULL
go
ALTER TABLE Exchange_Info ADD relatedwf varchar(500) NULL
go
ALTER TABLE Exchange_Info ADD relateddoc varchar(500) NULL
GO



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

alter PROCEDURE ExchangeInfo_Insert( 
	@sortid_1 int  ,
	@name_1  varchar (200)   ,
	@remark_1 text  ,
	@creater_1  int  ,
	@createDate_1  char (10)   ,
	@createTime_1  char (10)  ,
	@type_n_1 char(2),
	@docids_1 varchar(600),
 	@relatedprj_1	varchar(500),
	@relatedcus_1	varchar(500),
	@relatedwf_1	varchar(500),
	@relateddoc_1	varchar(500),
	@flag integer output,
	@msg varchar(80) output)

AS INSERT INTO Exchange_Info(
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
	@sortid_1 ,
	@name_1,
	@remark_1,
	@creater_1 ,
	@createDate_1 ,
	@createTime_1,
	@type_n_1,
	@docids_1,
	@relatedprj_1,
	@relatedcus_1,
	@relatedwf_1,
	@relateddoc_1)

GO



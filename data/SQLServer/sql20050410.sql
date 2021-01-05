create table cowork_maintypes (
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    typename     varchar(100)
)
go

create table cowork_types (
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    typename     varchar(100),
    departmentid int,  
    managerid     varchar(255),
    members	varchar(255)
)
go

create table cowork_items (
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    name     varchar(100),
    typeid	int,
    levelvalue	int,
    creater	int,
    coworkers	varchar(255),    
    createdate       char(10),  
    createtime       char(5),      
    begindate       char(10),       /*开始日期*/
    beingtime       char(5),        /*开始时间*/
    enddate         char(10),       /*结束日期*/
    endtime         char(5),        /*结束时间*/
    relatedprj	int,
    relatedcus	int,
    relatedwf	int,
    relateddoc	varchar(255),
    remark	text,
    status	int,
    readers	varchar(255),    
    isnew	varchar(255)
)
go

create table cowork_discuss (
    coworkid	int,
    discussant int,    
    createdate       char(10),  
    createtime       char(5),    
    remark	text
)
go

CREATE PROCEDURE [cowork_types_insert]
	(@typename_1 	[varchar](100),
	 @departmentid_2 	[int],
	 @managerid_3 	[varchar](255),
	 @members_4 	[varchar](255),
	@flag integer output , 
  	@msg varchar(80) output  )

AS INSERT INTO [cowork_types] 
	 ( [typename],
	 [departmentid],
	 [managerid],
	 [members]) 
 
VALUES 
	( @typename_1,
	 @departmentid_2,
	 @managerid_3,
	 @members_4)
	 
go

CREATE PROCEDURE [cowork_types_delete]
	(@id_1 	[int],
	@flag integer output , 
  	@msg varchar(80) output)

AS DELETE [cowork_types] 

WHERE 
	( [id]	 = @id_1)
	
go

CREATE PROCEDURE [cowork_types_update]
	(@id_1 	[int],
	 @typename_2 	[varchar](100),
	 @departmentid_3 	[int],
	 @managerid_4 	[varchar](255),
	 @members_5 	[varchar](255),
	@flag integer output , 
  	@msg varchar(80) output)

AS UPDATE [cowork_types] 

SET  [typename]	 = @typename_2,
	 [departmentid]	 = @departmentid_3,
	 [managerid]	 = @managerid_4,
	 [members]	 = @members_5 

WHERE 
	( [id]	 = @id_1)
	
go

CREATE PROCEDURE [cowork_items_insert]
	(@name_1 	[varchar](100),
	 @typeid_2 	[int],
	 @levelvalue_3 	[int],
	 @creater_4 	[int],
	 @coworkers_5 	[varchar](255),
	 @createdate_6 	[char](10),
	 @createtime_7 	[char](5),
	 @begindate_8 	[char](10),
	 @beingtime_9 	[char](5),
	 @enddate_10 	[char](10),
	 @endtime_11 	[char](5),
	 @relatedprj_12 	[int],
	 @relatedcus_13 	[int],
	 @relatedwf_14 	[int],
	 @relateddoc_15 	[varchar](255),
	 @remark_16 	[text],
	 @status_17 	[int],
	 @isnew 	[varchar](255),
	@flag integer output , 
  	@msg varchar(80) output)

AS INSERT INTO [cowork_items] 
	 ( [name],
	 [typeid],
	 [levelvalue],
	 [creater],
	 [coworkers],
	 [createdate],
	 [createtime],
	 [begindate],
	 [beingtime],
	 [enddate],
	 [endtime],
	 [relatedprj],
	 [relatedcus],
	 [relatedwf],
	 [relateddoc],
	 [remark],
	 [status],
	 [isnew]) 
 
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
go

CREATE PROCEDURE [cowork_discuss_insert]
	(@coworkid_1 	[int],
	 @discussant_2 	[int],
	 @createdate_3 	[char](10),
	 @createtime_4 	[char](5),
	 @remark_5 	[text],
	@flag integer output , 
  	@msg varchar(80) output)

AS INSERT INTO [cowork_discuss] 
	 ( [coworkid],
	 [discussant],
	 [createdate],
	 [createtime],
	 [remark]) 
 
VALUES 
	( @coworkid_1,
	 @discussant_2,
	 @createdate_3,
	 @createtime_4,
	 @remark_5)
	 
go


CREATE PROCEDURE [cowork_items_update]
	(@id_1 	[int],
	 @name_2 	[varchar](100),
	 @typeid_3 	[int],
	 @levelvalue_4 	[int],
	 @creater_5 	[int],
	 @coworkers_6 	[varchar](255),
	 @begindate_7 	[char](10),
	 @beingtime_8 	[char](5),
	 @enddate_9 	[char](10),
	 @endtime_10 	[char](5),
	 @relatedprj_11 	[int],
	 @relatedcus_12 	[int],
	 @relatedwf_13 	[int],
	 @relateddoc_14 	[varchar](255),
	 @remark_15 	[text],
	 @isnew_16 	[varchar](255),
	@flag integer output , 
  	@msg varchar(80) output)

AS UPDATE [cowork_items] 

SET  [name]	 = @name_2,
	 [typeid]	 = @typeid_3,
	 [levelvalue]	 = @levelvalue_4,
	 [creater]	 = @creater_5,
	 [coworkers]	 = @coworkers_6,
	 [begindate]	 = @begindate_7,
	 [beingtime]	 = @beingtime_8,
	 [enddate]	 = @enddate_9,
	 [endtime]	 = @endtime_10,
	 [relatedprj]	 = @relatedprj_11,
	 [relatedcus]	 = @relatedcus_12,
	 [relatedwf]	 = @relatedwf_13,
	 [relateddoc]	 = @relateddoc_14,
	 [remark]	 = @remark_15,
	 [isnew]	 = @isnew_16 

WHERE 
	( [id]	 = @id_1)

Go
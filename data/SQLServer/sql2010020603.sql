alter PROCEDURE HrmDepartment_Insert (@departmentmark_1 [varchar](60), @departmentname_2 	[varchar](200), @supdepid_3 int, @allsupdepid_4 varchar(200), @subcompanyid1_5 [int], @showorder_6 int,@coadjutant_7 int, @flag integer output , @msg varchar(80) output ) AS
declare @count int
declare @count1 int
 select @count=count(*)  from HrmDepartment where subcompanyid1=@subcompanyid1_5 and departmentmark=@departmentmark_1 and supdepid=@supdepid_3
 select @count1=count(*)  from HrmDepartment where subcompanyid1=@subcompanyid1_5 and departmentname=@departmentname_2 and supdepid=@supdepid_3
 if @count>0
 begin set @flag=2 set @msg='该部门简称已经存在，不能保存！' 
 return
 end 
 if @count1>0
 begin set @flag=3 set @msg='该部门全称已经存在，不能保存！' 
 return
 end 
INSERT INTO [HrmDepartment] ( [departmentmark], [departmentname], supdepid, allsupdepid, [subcompanyid1], showorder,coadjutant) VALUES ( @departmentmark_1, @departmentname_2, @supdepid_3, @allsupdepid_4, @subcompanyid1_5, @showorder_6,@coadjutant_7) 
select (max(id)) from [HrmDepartment] 
if @@error<>0 
begin 
set @flag=1 set @msg='插入储存过程失败' 
return 
end 
else 
begin 
set @flag=0 set @msg='插入储存过程成功' 
return 
end
GO

alter PROCEDURE HrmDepartment_Update (@id_1 [int], @departmentmark_2 [varchar](60), @departmentname_3 [varchar](200), @supdepid_4 int, @allsupdepid_5 varchar(200), @subcompanyid1_6 	[int], @showorder_7 int,@coadjutant_8 int, @flag integer output, @msg varchar(80) output  )  AS
  declare @count int
  declare @count1 int
 select @count=count(*)  from HrmDepartment where subcompanyid1=@subcompanyid1_6 and departmentmark=@departmentmark_2 and id!=@id_1 and supdepid=@supdepid_4
 select @count1=count(*)  from HrmDepartment where subcompanyid1=@subcompanyid1_6 and departmentname=@departmentname_3 and id!=@id_1 and supdepid=@supdepid_4
 if @count>0
 begin set @flag=2 set @msg='该部门简称已经存在，不能保存！' 
 return
 end 
 if @count1>0
 begin set @flag=3 set @msg='该部门全称已经存在，不能保存！' 
 return
 end 
  UPDATE [HrmDepartment]  SET  [departmentmark] = @departmentmark_2, [departmentname]	= @departmentname_3, supdepid = @supdepid_4,allsupdepid = @allsupdepid_5, [subcompanyid1] = @subcompanyid1_6,  showorder = @showorder_7,coadjutant=@coadjutant_8 WHERE ( [id]	 = @id_1) 
  IF @@error<>0 begin 
  set @flag=1 set @msg='更新储存过程失败' 
  return 
  END 
  ELSE 
  begin 
  set @flag=1 
  set @msg='更新储存过程失败' 
  return 
  END
GO

ALTER PROCEDURE workflow_CurOpe_UbySend
	@requestid	integer, 
	@userid		integer, 
	@usertype	integer,
	@isremark char(1),
	@flag 		integer 	output , 
	@msg 		varchar(80) 	output 
AS declare 
	@currentdate char(10), 
	@currenttime char(8)  
	set @currentdate=convert(char(10),getdate(),20) 
	set @currenttime=convert(char(8),getdate(),108)  
update workflow_currentoperator 
set isremark=2,operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and userid =@userid and usertype=@usertype and isremark=@isremark
GO 

ALTER PROCEDURE workflow_CurOpe_UbySendNB
	@requestid	integer, 
	@userid		integer, 
	@usertype	integer,
	@isremark char(1),
	@flag 		integer 	output , 
	@msg 		varchar(80) 	output 
AS declare 
	@currentdate char(10), 
	@currenttime char(8)  
	set @currentdate=convert(char(10),getdate(),20) 
	set @currenttime=convert(char(8),getdate(),108)  
update workflow_currentoperator 
set isremark=2,operatedate=@currentdate,operatetime=@currenttime,needwfback='0'
where requestid =@requestid and userid =@userid and usertype=@usertype and isremark=@isremark
GO 

alter PROCEDURE workflow_CurOpe_UpdatebySubmit 
@userid	int, 
@requestid	int, 
@groupid	int,
@nodeid	int,
@isremark char(1),
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime,viewtype=-2 where requestid =@requestid and userid=@userid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2' where requestid =@requestid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2' where requestid =@requestid and (isremark='5' or isremark='8' or isremark='9') and  userid=@userid

GO

alter  PROCEDURE workflow_groupdetail_Insert (@groupid_1 	int, @type_2 	int, @objid_3 	int, @level_4 	int, @level2_5 	int,@conditions varchar(1000),@conditioncn varchar(1000),@orders varchar(5) ,@signorder char(1),@IsCoadjutant char(1),@signtype char(1),@issyscoadjutant char(1),@issubmitdesc char(1),@ispending char(1),@isforward char(1),@ismodify char(1),@coadjutants varchar(500),@coadjutantcn varchar(1000),  @flag integer output , @msg varchar(80) output ) AS INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n, level2_n,conditions,conditioncn,orders,signorder,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn)  VALUES ( @groupid_1, @type_2, @objid_3, @level_4, @level2_5,@conditions,@conditioncn,@orders,@signorder,@IsCoadjutant,@signtype,@issyscoadjutant,@issubmitdesc,@ispending,@isforward,@ismodify,@coadjutants,@coadjutantcn) select max(id) from workflow_groupdetail set @flag = 0 set @msg = 'ok'
go

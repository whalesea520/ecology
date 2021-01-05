alter PROCEDURE HrmDepartment_Insert (@departmentmark_1 [varchar](60), @departmentname_2 	[varchar](200), @supdepid_3 int, @allsupdepid_4 varchar(200), @subcompanyid1_5 [int], @showorder_6 int, @flag integer output , @msg varchar(80) output ) AS  
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
INSERT INTO [HrmDepartment] ( [departmentmark], [departmentname], supdepid, allsupdepid, [subcompanyid1], showorder) VALUES ( @departmentmark_1, @departmentname_2, @supdepid_3, @allsupdepid_4, @subcompanyid1_5, @showorder_6) 
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

  alter PROCEDURE HrmDepartment_Update (@id_1 [int], @departmentmark_2 [varchar](60), @departmentname_3 [varchar](200), @supdepid_4 int, @allsupdepid_5 varchar(200), @subcompanyid1_6 	[int], @showorder_7 int, @flag integer output, @msg varchar(80) output  )  AS 
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
  UPDATE [HrmDepartment]  SET  [departmentmark] = @departmentmark_2, [departmentname]	= @departmentname_3, supdepid = @supdepid_4,allsupdepid = @allsupdepid_5, [subcompanyid1] = @subcompanyid1_6,  showorder = @showorder_7 WHERE ( [id]	 = @id_1) 
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
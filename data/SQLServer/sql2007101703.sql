alter table Prj_SearchMould add procode varchar(100)
go

alter PROCEDURE Prj_SearchMould_Update (@id_1 	[int], @userid_2 	[int], @prjid_3 	[varchar](60), @status_4 	[varchar](60), @prjtype_5 	[varchar](60), @worktype_6 	[int], @nameopt_7 	[int], @name_8 	[varchar](60), @description_9 	[varchar](250), @customer_10 	[int], @parent_11 	[int], @securelevel_12 	[int], @department_13 	[int], @manager_14 	[int], @member_15 	[int],@procode_16 [varchar](100), @flag integer output, @msg varchar(80) output )  AS UPDATE [Prj_SearchMould]  SET  [userid]	 = @userid_2, [prjid]	 = @prjid_3, [status]	 = @status_4, [prjtype]	 = @prjtype_5, [worktype]	 = @worktype_6, [nameopt]	 = @nameopt_7, [name]	 = @name_8, [description]	 = @description_9, [customer]	 = @customer_10, [parent]	 = @parent_11, [securelevel]	 = @securelevel_12, [department]	 = @department_13, [manager]	 = @manager_14, [member]	 = @member_15,[procode]=@procode_16  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

alter PROCEDURE Prj_SearchMould_Insert (@mouldname_1 	[varchar](200), @userid_2 	[int], @prjid_3 	[varchar](60), @status_4 	[varchar](60), @prjtype_5 	[varchar](60), @worktype_6 	[int], @nameopt_7 	[int], @name_8 	[varchar](60), @description_9 	[varchar](250), @customer_10 	[int], @parent_11 	[int], @securelevel_12 	[int], @department_13 	[int], @manager_14 	[int], @member_15 	[int],@procode_16 [varchar](100), @flag integer output, @msg varchar(80) output )  AS INSERT INTO [Prj_SearchMould] ( [mouldname], [userid], [prjid], [status], [prjtype], [worktype], [nameopt], [name], [description], [customer], [parent], [securelevel], [department], [manager], [member],[procode])  VALUES ( @mouldname_1, @userid_2, @prjid_3, @status_4, @prjtype_5, @worktype_6, @nameopt_7, @name_8, @description_9, @customer_10, @parent_11, @securelevel_12, @department_13, @manager_14, @member_15,@procode_16) select max(id) from [Prj_SearchMould] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO


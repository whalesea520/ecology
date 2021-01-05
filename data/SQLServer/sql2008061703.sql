CREATE PROCEDURE HrmRoles_insert_name @rolesmark varchar(60), @rolesname varchar(200), @docid int, @type int, @subcompanyid int output, @flag int output, @msg varchar(80) output 

  as
	  begin 
		  insert into HrmRoles(rolesmark,rolesname,docid,type,subcompanyid) values(@rolesmark,@rolesname,@docid,@type,@subcompanyid) 

		  if @@error<>0 
			begin 
			set @flag=1 set @msg='插入失败' 
		 	end 
		 else 
			 begin 
			set @flag=0 set @msg='操作成功'
	        	  end
			select max(id) as id from hrmroles 
	end 
GO
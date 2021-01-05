ALTER  PROCEDURE HrmResource_UpdatePassword 
    (@id_1 	int,
      @passwordold_2     varchar(100),
      @passwordnew_3     varchar(100),
      @flag                             integer output,
      @msg                             varchar(80) output 
     ) AS
declare @rowcountsum int

set @rowcountsum=0

     update HrmResource set password = @passwordnew_3,passwdchgdate=convert(char(10),getdate(),120)
      where id=@id_1 and password = @passwordold_2

if @@ROWCOUNT<>0 set @rowcountsum=1

      update HrmResourceManager set password = @passwordnew_3
       where id=@id_1 and password = @passwordold_2 

if @@ROWCOUNT<>0 set @rowcountsum=1

 if @rowcountsum<>0 begin set @flag=1 set @msg='更改密码成功' select 1 return end 
 else             begin set @flag=1 set @msg='更改密码失败' select 2 return end

GO
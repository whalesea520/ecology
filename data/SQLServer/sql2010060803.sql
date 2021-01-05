alter PROCEDURE HrmResourceSystemInfo_Insert (@id_1 int, @loginid_2 varchar(20), @password_3 varchar(60), @systemlanguage_4 int, @seclevel_5 int, @email_6 varchar(60) ,@needusb1 int,@serial1 varchar(32),@account_2 varchar(60),@lloginid_2 varchar(60),@needdynapass_2 int,@passwordstate_11 int,@flag int output, @msg varchar(60) output) AS
   declare @count int
   declare @oldpass varchar(60)
   declare @chgpasswddate char(10)
   if @loginid_2 is null or @loginid_2 = ''
   UPDATE HrmResource SET loginid ='',lloginid='',account='', systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6 WHERE id = @id_1
   else begin
   set @chgpasswddate=null select @oldpass=password from HrmResource where id=@id_1
   if (@oldpass is null and @password_3<>'0' ) or @oldpass<>@password_3
   set @chgpasswddate=convert(char(10),getdate(),120)
   if @loginid_2 is not null and @loginid_2 != '' and @loginid_2 != 'sysadmin'
   select @count = count(id) from HrmResource where id != @id_1 and loginid = @loginid_2
   if ( @count is not null and @count > 0 ) or @loginid_2 = 'sysadmin'
   select 0
   else begin
   if @password_3 = '0' begin
   if @serial1='0'
   UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,account=@account_2,lloginid=@lloginid_2,needdynapass=@needdynapass_2,passwordstate=@passwordstate_11 WHERE id = @id_1
   else UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2,passwordstate=@passwordstate_11 WHERE id = @id_1
   end
   else begin
   if @serial1='0'
   UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,account=@account_2,lloginid=@lloginid_2,needdynapass=@needdynapass_2,passwordstate=@passwordstate_11  WHERE id = @id_1
   else UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2,needdynapass=@needdynapass_2,passwordstate=@passwordstate_11  WHERE id = @id_1
   end
   end
   end

GO

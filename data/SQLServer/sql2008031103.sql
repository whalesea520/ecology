create table HrmnetworkSegStr
(id int IDENTITY (1, 1) not null,
 inceptipaddress varchar(50) null,
 endipaddress varchar(50) null,
 createrid int null,
 createdate char(20) null,
 createtime char(20) null,
 segmentdesc varchar(60) null
 )
go

delete from SystemlogItem where itemid = '101'
go

insert into SystemLogItem (itemid,lableid,itemdesc) values('101',21384,'Íø¶Î²ßÂÔ')
go

alter table HrmResource add passwordstate int
go

CREATE PROCEDURE HrmnetworkSegStr_Insert (
@inceptipaddress_1 varchar(50), 
@endipaddress_2 varchar(50), 
@createrid_3 int, 
@createdate_4 char(20),
@createtime_5 char(20), 
@segmentdesc_6 varchar(60), 
@flag int output, 
@msg varchar(60) output) 
AS 
INSERT INTO HrmnetworkSegStr (inceptipaddress, endipaddress, createrid, createdate, createtime,segmentdesc) VALUES (@inceptipaddress_1, @endipaddress_2, @createrid_3, @createdate_4,@createtime_5, @segmentdesc_6)
GO

CREATE PROCEDURE HrmnetworkSegStr_Update (
@id_1 int,
@inceptipaddress_2 varchar(50), 
@endipaddress_3 varchar(50),  
@segmentdesc_7 varchar(60), 
@flag integer output , 
@msg varchar(80) output)  
AS 
UPDATE HrmnetworkSegStr  SET inceptipaddress= @inceptipaddress_2,endipaddress = @endipaddress_3,segmentdesc=@segmentdesc_7  WHERE ( id = @id_1)
GO

CREATE PROCEDURE HrmnetworkSegStr_Delete (
@id_1 	int, 
@flag integer output , 
@msg varchar(80) output)  
AS 
DELETE HrmnetworkSegStr  WHERE ( id = @id_1)
GO

alter PROCEDURE HrmResourceSystemInfo_Insert (
@id_1 int, 
@loginid_2 varchar(20), 
@password_3 varchar(60), 
@systemlanguage_4 int, 
@seclevel_5 int, 
@email_6 varchar(60) ,
@needusb1 int,
@serial1 varchar(20),
@account_2 varchar(60),
@lloginid_2 varchar(60),
@needdynapass_2 int,
@passwordstate_11 int,
@flag int output, 
@msg varchar(60) output) 
AS
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
   else UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2 WHERE id = @id_1
   end
   else begin
   if @serial1='0'
   UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,account=@account_2,lloginid=@lloginid_2,needdynapass=@needdynapass_2,passwordstate=@passwordstate_11  WHERE id = @id_1
   else UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1,account=@account_2,lloginid=@lloginid_2,needdynapass=@needdynapass_2,passwordstate=@passwordstate_11  WHERE id = @id_1
   end
   end
   end

GO
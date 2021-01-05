insert into ErrorMsgIndex values (45,'插入usb令牌') 
go

insert into ErrorMsgInfo values (45,'请插入usb令牌',7) 
GO
insert into ErrorMsgInfo values (45,'please insert your usb token',8) 
GO

insert into ErrorMsgIndex values (46,'usb驱动') 
GO
insert into ErrorMsgInfo values (46,'未安装usb令牌驱动程序',7) 
GO
insert into ErrorMsgInfo values (46,'usb token''s driver hasn''t been installed',8) 
GO

insert into ErrorMsgIndex values (47,'usb令牌错误') 
GO
insert into ErrorMsgInfo values (47,'usb令牌错误',7) 
GO
insert into ErrorMsgInfo values (47,'incorrect usb token',8) 
GO

insert into ErrorMsgIndex values (48,'服务器令牌') 
GO
insert into ErrorMsgInfo values (48,'服务器usb令牌未准备好',7) 
GO
insert into ErrorMsgInfo values (48,'incorrect server side usb token',8) 
GO

INSERT INTO HtmlLabelIndex values(17588,'硬件加密') 
GO
INSERT INTO HtmlLabelInfo VALUES(17588,'硬件加密',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17588,'hardware encrypt',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17589,'加密') 
GO
INSERT INTO HtmlLabelInfo VALUES(17589,'加密',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17589,'encrypt',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17590,'取消加密') 
GO
INSERT INTO HtmlLabelInfo VALUES(17590,'取消加密',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17590,'cancel encrypt',8) 
GO

INSERT INTO SystemLogItem VALUES(89,17588,'硬件加密')
GO

INSERT INTO HtmlLabelIndex values(17591,'加密日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(17591,'加密日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17591,'encrypt log',8) 
GO

INSERT INTO HtmlLabelIndex values(17592,'更换usb令牌') 
GO
INSERT INTO HtmlLabelInfo VALUES(17592,'更换usb令牌',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17592,'update usb token',8) 
GO

INSERT INTO HtmlLabelIndex values(17593,'使用usb令牌')
GO
INSERT INTO HtmlLabelInfo VALUES(17593,'使用usb令牌',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17593,'use usb token',8) 
GO
alter table HrmResource add needusb int
GO
alter table HrmResource add serial char(10)
GO

drop table HrmOtherSettings
GO
create table HrmOtherSettings(remindperiod char(4),
                              valid char(1),
                              birthremindperiod char(4), 
                              birthvalid char(1),
                              congratulation varchar(50),
                              birthremindmode char(1),
                              needusb char(1),
                              firmcode char(10),
                              usercode char(10),
                              relogin char(1)
                              )
GO

                                 
insert HrmOtherSettings values('30','1','3','1', '祝$生日快乐', '1','0','10','13','0')
GO

   alter PROCEDURE HrmResourceSystemInfo_Insert (@id_1 int, @loginid_2 varchar(20), @password_3 varchar(60), @systemlanguage_4 int, @seclevel_5 int, @email_6 varchar(60) ,@needusb1 int,@serial1 char(10),@flag int output, @msg varchar(60) output) AS 
   declare @count int  
   declare @oldpass varchar(60)  
   declare @chgpasswddate char(10)  
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
   UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1 WHERE id = @id_1 
   else UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1 WHERE id = @id_1 
   end
   else begin
   if @serial1='0' 
   UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1  WHERE id = @id_1 
   else UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate,needusb=@needusb1,serial=@serial1  WHERE id = @id_1 
   end
   end
   
GO



   

 

 

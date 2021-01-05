alter PROCEDURE FnaCurrency_Update 
 (@id_1 	int, 
 @currencyname_1 	varchar(60),
 @currencydesc_2 	varchar(200), 
 @activable_3 	char(1), 
 @isdefault 	char(1), 
 @flag                             integer output, 
 @msg                             varchar(80) output )  
AS 
declare @count integer 
select @count = count(id) from FnaCurrency where currencyname = @currencyname_1 
if @count <>0 
begin 
    select -1 
    return 
end  

if @isdefault = '1' 
begin 
    update FnaCurrency set isdefault = '0' 
    UPDATE FnaCurrency SET  
    currencyname	 = @currencyname_1,
    currencydesc	 = @currencydesc_2, 
    activable	 = @activable_3 , 
    isdefault = '1' 
    WHERE ( id	 = @id_1) 
end 
else 
begin 
    UPDATE FnaCurrency  SET  
    currencyname	 = @currencyname_1,
    currencydesc	 = @currencydesc_2, 
    activable	 = @activable_3  
    WHERE ( id	 = @id_1) 
end 
GO



update workflow_groupdetail set objid=5 where groupid = 1
GO

update SystemRights set rightdesc = '财务预算通过' where id = 73 
GO

update SystemRightsLanguage set rightname = '财务预算通过' , rightdesc = '财务预算通过' where id=73  and languageid=7 
GO


/* 清理工作流提醒数据 */
delete SysRemindInfo 
GO



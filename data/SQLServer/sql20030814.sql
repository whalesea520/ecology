
 /*以下是杨国生《ecology产品开发资产组不能删除提交测试报告》的脚本*/
 ALTER  PROCEDURE CptCapitalAssortment_Delete
 (@id_1 	[int], 
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 declare @count integer , 
	 @supassortmentid int  
	 /*不能有相同的标识*/ 
	 select @count = capitalcount from CptCapitalAssortment where id = @id_1 
	 if @count <> 0 begin select -1 return end  
	 select @count = subassortmentcount  from CptCapitalAssortment where id = @id_1 
	 if @count <> 0 begin select -1 return end  
	 /*一级目录不可删除*/ 
	 select @supassortmentid = supassortmentid from CptCapitalAssortment where id= @id_1  

	 /* if @supassortmentid = 0 begin select -1 return end */

	 update CptCapitalAssortment set subassortmentcount = subassortmentcount-1 where id= @supassortmentid   
	 DELETE [CptCapitalAssortment] WHERE [id] = @id_1
GO


/*以下是刘煜的《Ecology产品开发-城市维护BUG修改V1.0提交测试报告2003-08-14》的脚本*/

alter table Prj_TaskProcess add dsporder int 
GO

alter table SystemSet add defmailserver varchar(60), defmailfrom varchar(60) , defneedauth tinyint
GO



/*以下是刘煜的《Ecology产品开发-邮件群发V1.0提交测试报告2003-08-14》的脚本*/
alter PROCEDURE HrmCity_Insert 
 (@cityname 	varchar(60), 
  @citylongitude decimal(8,3),  
  @citylatitude decimal(8,3), 
  @provinceid int, 
  @countryid int, 
  @flag integer output, 
  @msg varchar(80) output )  
AS 
declare @cityid int
select @cityid = ( max(id)+1 ) from HrmCity
INSERT INTO HrmCity ( id , cityname, citylongitude, citylatitude, provinceid, countryid )  
VALUES ( @cityid , @cityname, @citylongitude, @citylatitude, @provinceid, @countryid ) 
select @cityid
GO



alter PROCEDURE HrmCity_Select 
 (@countryid int , 
 @provinceid int , 
 @flag integer output , 
 @msg varchar(80) output )
AS 
if @countryid = 0 
    select * from HrmCity order by countryid , provinceid
else if @provinceid = 0 
    select * from HrmCity where countryid = @countryid order by countryid , provinceid
else 
    select * from HrmCity where countryid = @countryid and provinceid = @provinceid order by countryid , provinceid
GO


/* 开始  */
Create PROCEDURE CrmNoDepChange 
AS 
declare @manager int , @departmentid int , @subcompanyid1 int
declare manager_cursor cursor for 
select manager from CRM_CustomerInfo where department is null or department = 0 group by manager
open manager_cursor 
fetch next from manager_cursor into @manager
while @@fetch_status=0 
begin 
    select @departmentid = departmentid , @subcompanyid1=subcompanyid1 from HrmResource 
    where id = @manager  
    update CRM_CustomerInfo set department = @departmentid , subcompanyid1 = @subcompanyid1 
    where (department is null or department = 0) and manager = @manager
    fetch next from manager_cursor into @manager
end 
close manager_cursor deallocate manager_cursor 
GO

exec CrmNoDepChange 
GO

drop PROCEDURE CrmNoDepChange 
GO

/* 结束 */


alter PROCEDURE Prj_TaskProcess_Insert 
 (@prjid 	int,
 @taskid 	int, 
 @wbscoding 	varchar(20),
 @subject 	varchar(80) , 
 @version 	tinyint, 
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @workday decimal (10,1), 
 @content 	varchar(255),
 @fixedcost decimal (10,2),
 @parentid int, 
 @parentids varchar (255), 
 @parenthrmids varchar (255), 
 @level_n tinyint,
 @hrmid int,
 @prefinish_1 varchar(4000),
 @flag integer output, @msg varchar(80) output  ) 
AS 
declare @dsporder_9 int, @current_maxid int

select @current_maxid = max(dsporder) from Prj_TaskProcess 
where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
if @current_maxid is null set @current_maxid = 0 
set @dsporder_9 = @current_maxid + 1

INSERT INTO Prj_TaskProcess 
( prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish,
dsporder
)  
VALUES 
( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate,
@workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9) 
Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
select @id = max(id) from Prj_TaskProcess 
set @maxid = convert(varchar(10), @id) + ','
set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
set @flag = 1 set @msg = 'OK!'

GO


alter PROCEDURE Prj_TaskProcess_DeleteByID 
 (@id varchar(10), 
  @flag integer output, 
  @msg varchar(80) output )  
AS 
declare @dsporder_1 int ,  @prjid_2 int , @version_3 int , @parentid_4 int 

select @dsporder_1 = dsporder , @prjid_2 = prjid, @version_3 = version , @parentid_4 = parentid 
from Prj_TaskProcess where ( id	 = @id )

update Prj_TaskProcess set dsporder = dsporder - 1 
where  prjid = @prjid_2 and version = @version_3 and parentid = @parentid_4 
and isdelete<>'1' and dsporder > @dsporder_1

update Prj_TaskProcess set isdelete='1' , dsporder = -1 
WHERE ( id	 = @id or ','+parentids like  '%,'+@id+',%') 

update Prj_TaskProcess set childnum = childnum -1 where id = @parentid_4

GO


/* 对原有系统的项目进行排序处理 */
/* 开始  */
Create PROCEDURE PrjDspOrderSet 
AS 
declare @processid_1 int , @version_2 int , @projid_3 int , @parentid_4 int, @dsporderid_5 int , @version_6 int , @projid_7 int , @parentid_8 int
set @version_6 = -1
set @projid_7 = -1
set @parentid_8 = -1

declare manager_cursor cursor for 
select id,version,prjid,parentid from Prj_TaskProcess where isdelete != '1' 
order by version , prjid , parentid, id
open manager_cursor 
fetch next from manager_cursor into @processid_1,@version_2,@projid_3,@parentid_4
while @@fetch_status=0 
begin 
    if @version_2 != @version_6 or @projid_3 != @projid_7 or @parentid_4 != @parentid_8
    begin
        set @version_6 = @version_2
        set @projid_7 = @projid_3
        set @parentid_8 = @parentid_4
        set @dsporderid_5 = 1
    end
    else
       set @dsporderid_5 = @dsporderid_5 + 1 

    update Prj_TaskProcess set dsporder = @dsporderid_5 where ( id = @processid_1 ) 
    fetch next from manager_cursor into @processid_1,@version_2,@projid_3,@parentid_4
end 
close manager_cursor deallocate manager_cursor 

update Prj_TaskProcess set dsporder = -1 where ( isdelete = '1'  ) 
GO

exec PrjDspOrderSet 
GO

drop PROCEDURE PrjDspOrderSet 
GO

/* 结束 */



CREATE PROCEDURE PrjTaskProcess_UOrder
	(@processid_1  int ,
     @upordown  int ,
    @flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare  @otherprocessid_1 int , @version_2 int , @projid_3 int , @parentid_4 int, @dsporderid_5 int 
select @dsporderid_5 = dsporder , @version_2 = version, @projid_3 = prjid, @parentid_4 = parentid   
from Prj_TaskProcess where ( id	 = @processid_1)

if @upordown = 1 
begin
    select @otherprocessid_1 = id from Prj_TaskProcess 
    where version = @version_2 and prjid = @projid_3 and parentid = @parentid_4 and dsporder = @dsporderid_5 - 1
    update Prj_TaskProcess set dsporder = @dsporderid_5 - 1 where id = @processid_1
    update Prj_TaskProcess set dsporder = @dsporderid_5 where id = @otherprocessid_1
end
else 
begin
    select @otherprocessid_1 = id from Prj_TaskProcess 
    where version = @version_2 and prjid = @projid_3 and parentid = @parentid_4 and dsporder = @dsporderid_5 + 1
    update Prj_TaskProcess set dsporder = @dsporderid_5 + 1 where id = @processid_1
    update Prj_TaskProcess set dsporder = @dsporderid_5 where id = @otherprocessid_1
end
GO



/* 下面对现有项目任务的子任务数量bug作更正：原有系统删除子任务时候，上级任务的子任务数量没有减少1 */

/* 开始  */
Create PROCEDURE PrjChildnumChange 
AS 
declare @parentid_1 int , @countsbuid int 

update Prj_TaskProcess set childnum = 0 where isdelete != '1'

declare manager_cursor cursor for 
select count(id),parentid from Prj_TaskProcess where isdelete != '1' and parentid != 0 
group by parentid
open manager_cursor 
fetch next from manager_cursor into @countsbuid,@parentid_1
while @@fetch_status=0 
begin 
    update Prj_TaskProcess set childnum = @countsbuid where ( id = @parentid_1 ) 
    fetch next from manager_cursor into @countsbuid,@parentid_1
end 
close manager_cursor deallocate manager_cursor 
GO

exec PrjChildnumChange 
GO

drop PROCEDURE PrjChildnumChange 
GO

/* 结束 */



/* 增加群发服务器 */
alter PROCEDURE SystemSet_Update 
 (@emailserver_1  varchar(60) , 
  @debugmode_2   char(1) , 
  @logleaveday_3  tinyint ,
  @defmailuser_4  varchar(60) ,
  @defmailpassword_5  varchar(60) ,
  @pop3server_6  varchar(60),
  @filesystem_7 varchar(200),
  @filesystembackup_8 varchar(200),
  @filesystembackuptime_9 int ,
  @needzip_10 char(1),
  @needzipencrypt_11 char(1),
  @defmailserver_12 varchar(60),
  @defmailfrom_13 varchar(60),
  @defneedauth_14 char(1),
  @flag int output, 
  @msg varchar(80) output) 
AS 
 update SystemSet set 
        emailserver=@emailserver_1 , 
        debugmode=@debugmode_2,
        logleaveday=@logleaveday_3 ,
        defmailuser=@defmailuser_4 , 
        defmailpassword=@defmailpassword_5 , 
        pop3server=@pop3server_6 ,
        filesystem=@filesystem_7,
        filesystembackup=@filesystembackup_8 ,
        filesystembackuptime=@filesystembackuptime_9 , 
        needzip=@needzip_10 , 
        needzipencrypt=@needzipencrypt_11 ,
        defmailserver=@defmailserver_12 ,
        defmailfrom=@defmailfrom_13 ,
        defneedauth=@defneedauth_14 
GO




/*以下是刘煜的《Ecology产品开发-文档是否阅读BUG修改V1.0提交测试报告2003-08-14》的脚本*/

create PROCEDURE docReadTag_AddByUser 
 (@docid_1 	int ,
  @userid_2 	int ,
  @userType_3	int ,
  @flag	int	output, 
  @msg	varchar(80)	output)
AS 
declare @readcount int
select @readcount = count(userid) from docReadTag 
where docid = @docid_1 and userid = @userid_2 and userType = @userType_3

if @readcount is not null and @readcount > 0
    update DocReadTag set readcount = readcount+1 
    where docid = @docid_1 and userid = @userid_2 and userType = @userType_3
else 
    insert into  DocReadTag (docid,userid,readcount,usertype) 
    values(@docid_1, @userid_2, 1, @userType_3)
GO


delete docReadTag where readcount = 0 
GO


CREATE PROCEDURE docReadTag_SRead 
	@docid_1  int,
	@userid_2 int,
    @usertype_3 int,
	@flag integer output , 
  	@msg varchar(80) output  
as
declare @count1 int , @count2 int
select @count1 = count(docid) from docReadTag where docid=@docid_1 and userid=@userid_2 and usertype=@usertype_3
select @count2 = count(id) from docdetail where id=@docid_1 and doccreaterid=@userid_2 and usertype=convert(char(1),@usertype_3)

if @count1 is null set @count1 = 0 ;
if @count2 is null set @count2 = 0 ;
select @count1 + @count2
GO



/* 下面的脚本将原来阅读文章的记录从 DocDetailLog 复制到 DocReadTag */
/* 开始 */
create PROCEDURE  docReadTagInit
AS
declare @resourceid int , @docid int , @readcount int

delete DocReadTag where usertype = 1

declare resource_cursor cursor for 
select id from hrmresource 
open resource_cursor 
fetch next from resource_cursor into @resourceid
while @@fetch_status=0 
begin 
    declare doc_cursor cursor for 
    select count(docid), docid from DocDetailLog where operatetype='0' and operateuserid=@resourceid
    group by docid 
    open doc_cursor 
    fetch next from doc_cursor into @readcount, @docid 
    while @@fetch_status=0 
    begin 
        insert into  DocReadTag (docid,userid,readcount,usertype) 
        values(@docid, @resourceid, @readcount , 1)
        fetch next from doc_cursor into @readcount, @docid 
    end 
    close doc_cursor deallocate doc_cursor
    fetch next from resource_cursor into @resourceid
end
close resource_cursor deallocate resource_cursor 
GO

exec docReadTagInit
GO

drop PROCEDURE  docReadTagInit
GO

/* 结束 */

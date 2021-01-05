declare @table varchar(100)
declare @length varchar(100)
declare @fieldname varchar(100)
declare varchar_Cursor cursor for
select fieldname,ByteLength,name from (
select fieldname,ByteLength,name from 
(SELECT  c.id,
     C.name as FieldName,T.name as TypeName  
     ,C.IsNullable    
     ,case when exists(SELECT 1 FROM sysobjects where xtype='PK' and parent_obj=c.id and name in (  
         SELECT name FROM sysindexes WHERE indid in(  
         SELECT indid FROM sysindexkeys WHERE id = c.id AND colid=c.colid))) then 1 else 0 end   
           as IsPrimary  
     ,COLUMNPROPERTY(c.id,c.name,'IsIdentity') as IsIdentity  
     ,C.Length as ByteLength   
     ,COLUMNPROPERTY(C.id,C.name,'PRECISION') as StringLength  
     ,isnull(COLUMNPROPERTY(c.id,c.name,'Scale'),0) as DotPrecision  
     ,ISNULL(CM.text,'') as DefaultValue  
     ,isnull(ETP.value,'') AS [Description]  
FROM syscolumns C  
INNER JOIN systypes T ON C.xusertype = T.xusertype   
left JOIN sys.extended_properties ETP   ON  ETP.major_id = c.id AND ETP.minor_id = C.colid AND ETP.name ='MS_Description'   
left join syscomments CM on C.cdefault=CM.id   ) a  ,  sysobjects where a.TypeName='varchar'  and sysobjects.id=a.id and xtype='U' 
and  ByteLength<1000 and ByteLength>0)a where a.fieldname not in(
SELECT d.name  
FROM   sysindexes   a1  
JOIN   sysindexkeys   b   ON   a1.id=b.id   AND   a1.indid=b.indid  
JOIN   sysobjects   c   ON   b.id=c.id  
JOIN   syscolumns   d   ON   b.id=d.id   AND   b.colid=d.colid  where c.name=a.name)

open varchar_Cursor
fetch next from varchar_Cursor into @fieldname,@length ,@table
while (@@FETCH_STATUS=0)
begin
print @length 
if (@length<=125)
begin
set @length=@length*8
print 'alter table '+ @table+  ' alter column '+@fieldname+ ' varchar'+'('+@length+')'
begin try
exec ('alter table '+ @table+  ' alter column '+@fieldname+ ' varchar(1000)')
end try
begin catch
 print ERROR_MESSAGE()
end catch
end
else
begin
print 'alter table '+ @table+  ' alter column '+@fieldname+ ' varchar(1000)'
begin try
exec ('alter table '+ @table+  ' alter column '+@fieldname+ ' varchar(1000)')
end try
begin catch
 print ERROR_MESSAGE()
end catch
end
fetch next from varchar_Cursor into @fieldname,@length ,@table
end
close varchar_Cursor
deallocate varchar_Cursor
GO

alter function [SplitStr] ( @RowData nvarchar(4000), @SplitOn nvarchar(4000) ) RETURNS @RtnValue table ( Data nvarchar(4000) ) AS BEGIN Declare @Cnt int Set @Cnt = 1 While (Charindex(@SplitOn,@RowData)>0) Begin Insert Into @RtnValue (data) Select Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))  Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData)) Set @Cnt = @Cnt + 1 End Insert Into @RtnValue (data) Select Data = ltrim(rtrim(@RowData)) Return END

GO
alter function  [getPinYin](@str nvarchar(4000)) returns nvarchar(4000) as begin declare @word nchar(1),@PY nvarchar(4000) set @PY='' while len(@str)>0 begin set @word=left(@str,1) set @PY=@PY+(case when unicode(@word) between 19968 and 19968+20901 then ( select top 1 PY from ( select 'A' as PY,N'òˆ' as word union all select 'B',N'²¾' union all select 'C',N'åe' union all select 'D',N'ùz' union all select 'E',N'˜Þ' union all select 'F',N'öv' union all select 'G',N'ÄB' union all select 'H',N'‰þ' union all select 'J',N'”h' union all select 'K',N'·i' union all select 'L',N'÷w' union all select 'M',N'”æ' union all select 'N',N'–þ' union all select 'O',N'a' union all select 'P',N'ÆØ' union all select 'Q',N'‡Ý' union all select 'R',N'úU' union all select 'S',N'ÎR' union all select 'T',N'»X' union all select 'W',N'úF' union all select 'X',N'èR' union all select 'Y',N'í' union all select 'Z',N'…ø' ) T where word>=@word collate Chinese_PRC_CS_AS_KS_WS order by PY ASC ) else @word end) set @str=right(@str,len(@str)-1) end return @PY end

GO
alter function [fun_getUUID32](@newid varchar(4000)) RETURNS varchar(4000) AS BEGIN DECLARE @id varchar(4000);  select @id=SUBSTRING(@newid,1,8)+SUBSTRING(@newid,10,4)+SUBSTRING(@newid,15,4)+ SUBSTRING(@newid,20,4)+SUBSTRING(@newid,25,12)  RETURN @id  END

GO
alter function  [f_GetPy](@str   nvarchar(4000)) returns   nvarchar(4000) as begin declare   @strlen   int,@re   nvarchar(4000) declare   @t   table(chr   nchar(1)   collate   Chinese_PRC_CI_AS,letter   nchar(1)) insert   into   @t(chr,letter) select   'ß¹ ', 'A '   union   all   select   '°Ë ', 'B '   union   all select   'àê ', 'C '   union   all   select   '…ö ', 'D '   union   all select   'ŠŠ ', 'E '   union   all   select   '·¢ ', 'F '   union   all select   'ê¸ ', 'G '   union   all   select   'îþ ', 'H '   union   all select   'Ø¢ ', 'J '   union   all   select   'ßÇ ', 'K '   union   all select   'À¬ ', 'L '   union   all   select   '‡` ', 'M '   union   all select   '’‚ ', 'N '   union   all   select   'àÞ ', 'O '   union   all select   'Šr ', 'P '   union   all   select   'Æß ', 'Q '   union   all select   '…ß ', 'R '   union   all   select   'Øí ', 'S '   union   all select   'Ëû ', 'T '   union   all   select   'ŒÜ ', 'W '   union   all select   'Ï¦ ', 'X '   union   all   select   'Ñ¾ ', 'Y '   union   all select   'Ž‰ ', 'Z ' select   @strlen=len(@str),@re= ' ' while   @strlen> 0 begin select   top   1   @re=letter+@re,@strlen=@strlen-1 from   @t   a   where   chr <=substring(@str,@strlen,1) order   by   chr   desc if   @@rowcount=0 select   @re=substring(@str,@strlen,1)+@re,@strlen=@strlen-1 end return(@re) end

GO
alter function  [getFccArchive1](@pId INT) returns INT as begin declare @pCnt int;  WITH allsub(id,name,supFccId,archive,code) as ( SELECT id,name,supFccId,archive,code FROM FnaCostCenter where id=@pId UNION ALL SELECT aa.id,aa.name,aa.supFccId,aa.archive,aa.code FROM FnaCostCenter aa,allsub b where aa.id = b.supFccId ) select @pCnt = count(*) from allsub tt where tt.archive = 1  return @pCnt end

GO
alter function  [getchilds] ( @id int ) returns  @childtabes TABLE (id int ) as begin declare @hrmid int,@childs   nvarchar(4000)  set  @childs='0'  declare childid_cursor cursor for WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.managerid = b.id and a.managerid !=a.id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>'' ) select id from allhrm  open childid_cursor fetch next from childid_cursor into @hrmid  while @@fetch_status=0 begin insert  @childtabes values(@hrmid) fetch next from childid_cursor into  @hrmid  end close childid_cursor return end

GO
alter function  [getparents] ( @id int ) returns  @childtabes TABLE (id int ) as begin declare @hrmid int,@childs   nvarchar(4000)  set  @childs='0'  declare childid_cursor cursor for WITH allhrm(id,lastname,managerid) as (SELECT id,lastname ,managerid FROM hrmresource where id=@id UNION ALL SELECT a.id,a.lastname,a.managerid FROM hrmresource a,allhrm b where a.id = b.managerid and a.managerid !=a.id and a.status in (0,1,2,3) and a.loginid is not null and a.loginid<>'' ) select id from allhrm  open childid_cursor fetch next from childid_cursor into @hrmid  while @@fetch_status=0 begin insert  @childtabes values(@hrmid) fetch next from childid_cursor into  @hrmid  end close childid_cursor return end

GO
alter function  [getSubComParentTree] (@subcom_id int) RETURNS @tree Table (id int,supsubcomid int) AS BEGIN declare @temptree Table (num int IDENTITY(1,1),id int,supsubcomid int) declare @parent_id int  select @parent_id=supsubcomid from hrmsubcompany where id=@subcom_id  while(@parent_id<>0) begin insert @temptree select id,supsubcomid from hrmsubcompany where id =@parent_id select top 1 @parent_id=supsubcomid from @temptree order by num desc end  insert @tree select id,supsubcomid from @temptree order by num desc  RETURN END

GO
alter function [getPrjFinish] (@prjid int) RETURNS int AS BEGIN DECLARE @sumWorkday decimal(9) DECLARE @finish int set @finish=0 SELECT @sumWorkday=SUM(workday) FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') ; IF @sumWorkday<>0 SELECT @finish= (sum(finish*workday)/sum(workday))  FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') Return @finish END

GO
alter function [getPrjEndDate] (@prjid int) RETURNS char(10) AS BEGIN Return (SELECT MAX(enddate)  FROM Prj_TaskProcess WHERE prjid=@prjid) END

GO
alter function [getPrjBeginDate] (@prjid int) RETURNS char(10) AS BEGIN Return (SELECT MIN(begindate)  FROM Prj_TaskProcess WHERE prjid=@prjid) END

GO
alter function [GetDocShareDetailTable]  (@userid varchar(4000) ,@usertype  varchar(4000)) RETURNS @DocShareDetail  TABLE (sourceid int , sharelevel int) AS BEGIN Declare @seclevel varchar(4000),@departmentid varchar(4000),@subcompanyid varchar(4000),@type varchar(4000),@isSysadmin integer if @usertype='1' begin select @seclevel=seclevel,@departmentid=departmentid,@subcompanyid=subcompanyid1 from hrmresource where id=@userid begin select @isSysadmin=count(*) from hrmresourcemanager where id=@userid if @isSysadmin=1 insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where (type=1 and content=@userid) or (  type=4 and content in (select convert(varchar(4000),roleid)+CONVERT(varchar(4000),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) GROUP BY sourceid else insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where (type=1 and content=@userid) or  (type=2 and content=@subcompanyid and seclevel<=@seclevel) or (type=3 and content=@departmentid and seclevel<=@seclevel) or (  type=4 and content in (select convert(varchar(4000),roleid)+CONVERT(varchar(4000),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) GROUP BY sourceid end end else begin select @type=type,@seclevel=seclevel from crm_customerinfo where id=@userid insert @DocShareDetail  SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareouterdoc where (type=9 and content=@userid) or (type=10 and content=@type and seclevel<=@seclevel) GROUP BY sourceid end RETURN END
GO

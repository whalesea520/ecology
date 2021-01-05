insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'description', 22462, 'varchar2(3000)', 2, 1, 7, 0, '', 1)
GO

insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
         (select id
            from workflow_billfield
           where billid = 85
             and fieldname = 'description'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = 504
GO

alter table Bill_Meeting add description varchar(8000)
GO
alter table Meeting add description varchar(8000)
GO

DROP PROCEDURE Meeting_Insert
GO

CREATE  PROCEDURE Meeting_Insert 
( @meetingtype [int] , @name [varchar] (255) , @caller [int] , 
@contacter [int] , @projectid[int], @address [int] , 
@begindate [varchar] (10), @begintime [varchar] (8), @enddate [varchar] (10), 
@endtime [varchar] (8), @desc_n [varchar] (4000), @creater [int], @createdate [varchar] (10),
 @createtime [varchar] (8) , @totalmember   int, @othermembers   text, @addressdesc   varchar(255), 
 @description varchar(8000),@customizeAddress   varchar(400), @flag integer output, @msg varchar(80) output) 
 AS 
 INSERT INTO [Meeting] ( [meetingtype] , [name] , [caller] , [contacter] , 
 [projectid], [address] , [begindate]  , [begintime] , [enddate] , [endtime] , 
 [desc_n], [creater] , [createdate] , [createtime], totalmember, othermembers, 
 addressdesc, description,customizeAddress) 
 VALUES ( @meetingtype , @name, @caller, @contacter, @projectid, @address , 
 @begindate , @begintime , @enddate , @endtime , @desc_n , @creater , @createdate , 
 @createtime, @totalmember, @othermembers, @addressdesc,@description, @customizeAddress) 
 select IDENT_CURRENT('Meeting') set @flag = 1 set @msg = 'OK!'
GO

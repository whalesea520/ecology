 Create  PROCEDURE PDocShare_SetById (
	@docid_1  int , 
	@flag int output,
	@msg varchar(80) output 
	)
AS
    Declare @doccreaterid int ,
            @hrmid int,
            @sharelevel int,
            @all_cursor cursor

    /*删除docsharedetail里相关的数据*/
    delete docsharedetail where docid = @docid_1;

    /*插入文档创建者的共享*/
    select @doccreaterid = doccreaterid from docdetail where id =  @docid_1;
    insert into docsharedetail(docid,userid,usertype,sharelevel) values(@docid_1,@doccreaterid,1,2);

    /*循环插入docshare中的记录*/
    SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
    	select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2 where  t1.loginid is not null and t1.loginid <> ''and t2.docid = @docid_1 and ( (t2.foralluser=1 and t2.seclevel<=t1.seclevel)  or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid and t2.seclevel<=t1.seclevel))	
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @hrmid,@sharelevel
	WHILE @@FETCH_STATUS = 0
	begin
		insert into docsharedetail(docid,userid,usertype,sharelevel) values(@docid_1,@hrmid,1,@sharelevel);      
		FETCH NEXT FROM @all_cursor INTO  @hrmid,@sharelevel
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor   
GO

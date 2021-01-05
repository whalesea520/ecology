ALTER table  workflow_selectitem add cancel varchar(1) default 0
go

CREATE PROCEDURE workflow_selectitem_insert_new
    (
      @fieldid INT ,
      @isbill INT ,
      @selectvalue INT ,
      @selectname VARCHAR(250) ,
      @listorder NUMERIC(10, 2) ,
      @isdefault CHAR(1) ,
      @cancel2 VARCHAR(1),
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    INSERT  INTO workflow_selectitem
            ( fieldid ,
              isbill ,
              selectvalue ,
              selectname ,
              listorder ,
              isdefault,cancel
            )
    VALUES  ( @fieldid ,
              @isbill ,
              @selectvalue ,
              @selectname ,
              @listorder ,
              @isdefault,@cancel2
            ) 
GO

CREATE PROCEDURE workflow_selectitembyid_new
    @id VARCHAR(100) ,
    @isbill VARCHAR(100) ,
    @flag INTEGER OUTPUT ,
    @msg VARCHAR(80) OUTPUT
  AS 
    SELECT  *
    FROM    workflow_SelectItem
    WHERE   fieldid = @id
            AND isbill = @isbill AND ( cancel!='1' or cancel is null)
    ORDER BY listorder ,
            id
    SET @flag = 0
    SET @msg = '' 
GO
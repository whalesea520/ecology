CREATE PROCEDURE hrm_schedule_personnel_spit
AS
  DECLARE @id INT;
	DECLARE	@delflag INT;
	DECLARE	@creater BIGINT;
	DECLARE	@create_time VARCHAR(100);
	DECLARE	@last_modifier BIGINT;
	DECLARE	@last_modification_time VARCHAR(100);
	DECLARE	@sn INT;
	DECLARE	@field001 INT;
	DECLARE	@field002 VARCHAR(100);
	DECLARE	@field003 INT;
	DECLARE	@field004 INT;
	DECLARE	@field005 INT;
	DECLARE	@field006 INT;
	DECLARE	@field007  VARCHAR(100);
    DECLARE cursor0 CURSOR
    FOR
        SELECT  id,delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,field002,field003,field004,field005,field006,field007
        FROM    hrm_schedule_personnel
		WHERE CHARINDEX(';', field002) > 0
        ORDER BY id;
    OPEN cursor0;
    FETCH NEXT FROM cursor0  INTO @id,@delflag,@creater,@create_time,@last_modifier,@last_modification_time,@sn,@field001,@field002,@field003,@field004,@field005,@field006,@field007;
	WHILE ( @@fetch_status = 0 )
		BEGIN
			 DECLARE @idx1 int,@idx2 int,@key varchar(50), @split as varchar(2)
			 set @idx1 = 1  
			 set @idx2 = 0
			 set @split =';'
			 if right(@field002,1) <> @split set @field002 = @field002 + @split   
			 while 1=1  
			 BEGIN  
			  set @idx2 = CharIndex(@split,@field002,@idx2 + 1);  
			  if @idx2 <= 0 
				BEGIN
					BREAK;
				END;
			  insert into hrm_schedule_personnel (delflag,creater,create_time,last_modifier,last_modification_time,sn,field001,field002,field003,field004,field005,field006,field007) 
			  select @delflag,@creater,@create_time,@last_modifier,@last_modification_time,@sn,@field001,substring(@field002,@idx1,@idx2 - @idx1) as field002,@field003,@field004,@field005,@field006,@field007 ;   
			  set @idx1 = @idx2 + 1;  
			END; 
			FETCH NEXT FROM cursor0  INTO @id,@delflag,@creater,@create_time,@last_modifier,@last_modification_time,@sn,@field001,@field002,@field003,@field004,@field005,@field006,@field007;
		END;
	CLOSE cursor0;
  DEALLOCATE cursor0; 
GO
EXEC hrm_schedule_personnel_spit
GO
DROP PROCEDURE hrm_schedule_personnel_spit
GO

create FUNCTION dbo.convToCN
    (
      @multilang VARCHAR(4000)
    )
RETURNS NVARCHAR(4000)
AS 
    BEGIN
        DECLARE @v_index INT ,
            @v_endindex INT ,
            @rst VARCHAR(4000)

        SET @v_index = CHARINDEX('~`~`',@multilang);
        SET @v_endindex = CHARINDEX('`~`',@multilang,@v_index+4);

        IF ( @v_index > 0 ) 
            BEGIN  
                       SET @rst = SUBSTRING(@multilang, @v_index + 6,
                                                 @v_endindex - @v_index - 6)
            END  
        ELSE
			BEGIN
			 SET @rst =@multilang
			END
        RETURN  @rst          
    END;
GO

create FUNCTION dbo.convToMultiLang
    (
      @multilang VARCHAR(4000),
      @languageId INT
    )
RETURNS NVARCHAR(4000)
AS 
    BEGIN
        DECLARE @v_index INT ,
            @v_midindex INT ,
			@v_midindex2 INT ,
			@v_endindex INT,
            @rst VARCHAR(4000),
            @lang1 VARCHAR(4000),
            @lang2 VARCHAR(4000),
            @lang3 VARCHAR(4000)

        SET @v_index = CHARINDEX('~`~`',@multilang);
        SET @v_midindex = CHARINDEX('`~`',@multilang,@v_index+4);
        SET @v_midindex2 = CHARINDEX('`~`',@multilang,@v_midindex+3);
        SET @v_endindex = CHARINDEX('`~`~',@multilang,@v_midindex2+3);

        IF ( @v_index > 0 ) 
            BEGIN  
                       SET @lang1 = SUBSTRING(@multilang, @v_index + 4,
                                                 @v_midindex - @v_index - 4);
                       SET @lang2 = SUBSTRING(@multilang, @v_midindex + 3,
                                                 @v_midindex2 - @v_midindex - 3);
                       SET @lang3 = SUBSTRING(@multilang, @v_midindex2 + 3,
                                                 @v_endindex - @v_midindex2 - 3);
                       if( convert(int,SUBSTRING(@lang1,1,2)) = @languageId )
                       BEGIN
						SET @rst =  SUBSTRING(@lang1,2,len(@lang1)-1)
					   END
					  Else if( convert(int,SUBSTRING(@lang2,1,2)) = @languageId )
                       BEGIN
						SET @rst =  SUBSTRING(@lang2,2,len(@lang2)-1)
					   END
					   Else if(convert(int,SUBSTRING(@lang3,1,2)) = @languageId )
                       BEGIN
						SET @rst =  SUBSTRING(@lang3,2,len(@lang3)-1)
					   END 
					   Else
					   BEGIN
						SET @rst =  SUBSTRING(@lang1,2,len(@lang1)-1)
					   END 			                     
            END  
        ELSE
			BEGIN
			 SET @rst =@multilang
			END
        RETURN  @rst          
    END;
GO
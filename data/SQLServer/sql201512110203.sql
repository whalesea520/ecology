create proc p_updateReportSqlWHere
as
declare @tempStr varchar(4000)
declare @sqlWhere varchar(4000)
declare @tabTitle varchar(1000)
declare @inSqlWhere varchar(1000)
declare @eid int
declare @count int
DECLARE @splitlen int
DECLARE @split2 varchar(10)
declare @split1 varchar(10)
declare oldLine cursor  for select id,strsqlwhere from hpElement where ebaseid = 'reportForm' and strsqlwhere is not null and strsqlwhere<>'';
begin
	SET @count = 0
	SET @splitlen  = 3
	SET @split2 = '^,^'
	SET @split1 = '_$_'
	open oldLine;
	fetch next from  oldLine into @eid,@sqlWhere;
	WHILE @@FETCH_STATUS = 0  
	begin

		WHILE CHARINDEX(@split1,@sqlWhere)>0
		BEGIN
			SET @tempStr = LEFT(@sqlWhere,CHARINDEX(@split1,@sqlWhere)-1)
			SET @inSqlWhere = LEFT(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen-1)
			SET @tempStr =  substring(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen,LEN(@tempStr))
			SET @tabTitle = LEFT(@tempStr,CHARINDEX(@split2,@tempStr)-1)
			SET @inSqlWhere = @inSqlWhere + substring(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen,LEN(@tempStr))
			INSERT INTO hpNewsTabInfo(eid,tabid,tabTitle,sqlWhere,orderNum)  VALUES(@eid,@count,@tabTitle,@inSqlWhere, @count)
			SET @sqlWhere=substring(@sqlWhere,CHARINDEX(@split1,@sqlWhere)+@splitlen,LEN(@sqlWhere))
			SET @count = @count + 1
		END
		SET @tempStr = @sqlWhere
		SET @inSqlWhere = LEFT(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen-1)
		SET @tempStr =  substring(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen,LEN(@tempStr))
		SET @tabTitle = LEFT(@tempStr,CHARINDEX(@split2,@tempStr)-1)
		SET @inSqlWhere = @inSqlWhere + substring(@tempStr,CHARINDEX(@split2,@tempStr)+@splitlen,LEN(@tempStr))
		INSERT INTO hpNewsTabInfo(eid,tabid,tabTitle,sqlWhere,orderNum)  VALUES(@eid,@count,@tabTitle,@inSqlWhere, @count)
		fetch next from  oldLine into @eid,@sqlWhere;
	end
 close oldLine;
 deallocate oldLine;
end
GO
exec p_updateReportSqlWHere
Go
drop proc p_updateReportSqlWHere
GO
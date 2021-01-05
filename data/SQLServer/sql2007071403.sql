
alter PROCEDURE bill_workinfodetail_SByType @infoid		int, @type		int, @flag integer output , @msg varchar(80) output as select * from bill_weekinfodetail where infoid=@infoid and type=@type   order by id

GO

alter PROCEDURE bill_monthinfodetail_SByType @infoid		int, @type		int, @flag integer output , @msg varchar(80) output as select * from bill_monthinfodetail where infoid=@infoid and type=@type order by id

GO

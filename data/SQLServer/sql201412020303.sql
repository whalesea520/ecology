alter PROCEDURE FnaBudgetfeeType_Select @flag	int	output, @msg	varchar(80) output as select * from fnaBudgetfeetype order by name 

GO
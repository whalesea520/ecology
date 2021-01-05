ALTER PROCEDURE bill_CptAdjustDetail_Select (@cptadjustid 	[int], @flag integer output , @msg varchar(80) output)  AS select * from  [bill_CptAdjustDetail] WHERE ( [cptadjustid]	 = @cptadjustid) order by id

GO

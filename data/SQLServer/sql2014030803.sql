alter PROCEDURE bill_CptFetchDetail_Select (@cptfetchid 	[int], @flag integer output , @msg varchar(80) output)  AS select * from  [bill_CptFetchDetail] WHERE ( [cptfetchid]	 = @cptfetchid) order by id
GO

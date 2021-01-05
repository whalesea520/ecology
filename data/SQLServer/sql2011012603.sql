alter PROCEDURE bill_CptApplyDetail_Select (@cptapplyid 	[int], @flag integer output , @msg varchar(80) output)  AS select * from  [bill_CptApplyDetail] WHERE ( [cptapplyid]	 = @cptapplyid) order by id

GO

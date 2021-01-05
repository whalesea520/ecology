INSERT INTO workflow_billfield  ( billid , fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,viewtype ,detailtable ,fromUser ,textheight , dsporder ,childfieldid ,imgheight ,imgwidth ) VALUES ( 14 , 'cptspec' , 904 ,'varchar(50)' , '1' , 1 ,1 ,  '' , '1' ,null , 16 ,  null , null , null)
GO
UPDATE workflow_billfield SET dsporder = 17 WHERE id = 329
GO
UPDATE workflow_billfield SET dsporder = 18 WHERE id = 160
GO
UPDATE workflow_billfield SET dsporder = 19 WHERE id = 161
GO
Alter table bill_CptApplyDetail add cptspec VARCHAR(50)
GO
CREATE  PROCEDURE bill_CptApplyDetail_Insert2  (@cptapplyid [int], @cpttype [int], @cptid_1 [int], @number_2 [decimal](10,3), @unitprice_3 [decimal](10,3),  @amount_4 	[decimal](10,3), @needdate_5 	[varchar](10), @purpose_6 	[varchar](60),  @cptdesc_7 	[varchar](60), @capitalid_8 	[int], @cptspec_9 VARCHAR(50),@flag integer output , @msg varchar(80) output ) AS INSERT INTO [bill_CptApplyDetail] ( [cptapplyid], [cpttype], [cptid], [number_n], [unitprice],[amount], [needdate], [purpose], [cptdesc],[capitalid],[cptspec])  VALUES ( @cptapplyid, @cpttype, @cptid_1, @number_2, @unitprice_3, @amount_4, @needdate_5, @purpose_6, @cptdesc_7 , @capitalid_8,@cptspec_9)
GO   

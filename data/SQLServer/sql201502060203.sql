ALTER TABLE fnaFeeWfInfoField ADD showAllType INT
GO


update fnaFeeWfInfoField set showAllType=0
GO



ALTER TABLE fnaFeeWfInfo ADD templateFile varchar(4000)
GO
ALTER TABLE fnaFeeWfInfo ADD templateFileMobile varchar(4000)
GO


update fnaFeeWfInfo 
set templateFile='FnaSubmitRequestJs.jsp', 
templateFileMobile='FnaSubmitRequestJs4Mobile.jsp' 
GO
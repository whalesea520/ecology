drop index idx_fnaFeeWfInfo_fnaWfType on fnaFeeWfInfo
GO

alter table fnaFeeWfInfo alter column FNAWFTYPE varCHAR(50)
GO

update fnaFeeWfInfo set FNAWFTYPE = rtrim(ltrim(FNAWFTYPE))
GO

create index idx_fnaFeeWfInfo_fnaWfType on fnaFeeWfInfo (FNAWFTYPE) 
GO
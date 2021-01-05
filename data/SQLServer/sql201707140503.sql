ALTER table fnaFeeWfInfoField add automaticTake int
GO

update fnaFeeWfInfoField set automaticTake = 1 where automaticTake is null 
GO
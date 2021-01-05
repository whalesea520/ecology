ALTER table fnaFeeWfInfoField add automaticTake integer
/

update fnaFeeWfInfoField set automaticTake = 1 where automaticTake is null 
/
update HrmResource set dsporder = id where dsporder is null
/
ALTER table  HrmResource  ADD demandnumcc FLOAT(126)
/
update   HrmResource set demandnumcc = dsporder
/
ALTER table  HrmResource  drop column dsporder
/
ALTER TABLE HrmResource RENAME COLUMN demandnumcc TO dsporder
/
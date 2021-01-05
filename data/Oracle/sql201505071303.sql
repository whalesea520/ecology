ALTER TABLE FnaSystemSet ADD fnaWfSysWf int
/

ALTER TABLE FnaSystemSet ADD fnaWfCustom int
/


update FnaSystemSet set fnaWfSysWf = 1, fnaWfCustom = 1 
/
ALTER TABLE FnaSystemSet ADD timeModul INTEGER
/

ALTER TABLE FnaSystemSet ADD dayTime1 INTEGER
/

ALTER TABLE FnaSystemSet ADD fer INTEGER
/

ALTER TABLE FnaSystemSet ADD dayTime2 INTEGER
/

update FnaSystemSet set timeModul = 0, dayTime1 = 1, fer = 1, dayTime2 = 1
/
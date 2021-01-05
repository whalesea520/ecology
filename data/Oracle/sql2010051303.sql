ALTER table  CptSearchDefinition  ADD displayorder1 float
/
update   CptSearchDefinition set displayorder1 = displayorder
/
ALTER table  CptSearchDefinition  drop column displayorder
/
ALTER TABLE CptSearchDefinition RENAME COLUMN displayorder1 TO displayorder
/

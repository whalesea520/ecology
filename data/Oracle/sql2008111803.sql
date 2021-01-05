ALTER table  HrmSearchMould  ADD datefield1 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefield2 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefield3 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefield4 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefield5 varchar(60)
/


ALTER table  HrmSearchMould  ADD datefieldto1 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefieldto2 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefieldto3 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefieldto4 varchar(60)
/

ALTER table  HrmSearchMould  ADD datefieldto5 varchar(60)
/


ALTER table  HrmSearchMould  ADD textfield1 varchar(100)
/

ALTER table  HrmSearchMould  ADD textfield2 varchar(100)
/

ALTER table  HrmSearchMould  ADD textfield3 varchar(100)
/

ALTER table  HrmSearchMould  ADD textfield4 varchar(100)
/

ALTER table  HrmSearchMould  ADD textfield5 varchar(100)
/

ALTER table  HrmSearchMould  ADD numberfield1 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfield2 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfield3 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfield4 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfield5 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfieldto1 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfieldto2 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfieldto3 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfieldto4 varchar(60)
/

ALTER table  HrmSearchMould  ADD numberfieldto5 varchar(60)
/


ALTER table  HrmSearchMould  ADD tinyintfield1 integer
/

ALTER table  HrmSearchMould  ADD tinyintfield2 integer
/

ALTER table  HrmSearchMould  ADD tinyintfield3 integer
/

ALTER table  HrmSearchMould  ADD tinyintfield4 integer
/

ALTER table  HrmSearchMould  ADD tinyintfield5 integer
/


CREATE OR REPLACE PROCEDURE HrmSearchMouldDefine_Update(id_1 integer, dff01name varchar2,dff02name varchar2,dff03name varchar2,dff04name varchar2,dff05name varchar2,dff01nameto varchar2,dff02nameto varchar2,dff03nameto varchar2,dff04nameto varchar2,dff05nameto varchar2, nff01name varchar2,nff02name varchar2,nff03name varchar2,nff04name varchar2,nff05name varchar2,nff01nameto varchar2,nff02nameto varchar2,nff03nameto varchar2,nff04nameto varchar2,nff05nameto varchar2, tff01name varchar2,tff02name varchar2,tff03name varchar2,tff04name varchar2,tff05name varchar2,bff01name integer, bff02name integer,bff03name integer,bff04name integer,bff05name integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin UPDATE HrmSearchMould set datefield1 = dff01name ,datefield2 = dff02name ,datefield3 = dff03name ,datefield4 = dff04name ,datefield5 = dff05name ,datefieldto1 = dff01nameto ,datefieldto2 = dff02nameto ,datefieldto3 = dff03nameto ,datefieldto4 = dff04nameto ,datefieldto5 = dff05nameto ,numberfield1 = nff01name ,numberfield2 = nff02name ,numberfield3 = nff03name ,numberfield4 = nff04name ,numberfield5 = nff05name ,numberfieldto1 = nff01nameto ,numberfieldto2 = nff02nameto ,numberfieldto3 = nff03nameto ,numberfieldto4 = nff04nameto ,numberfieldto5 = nff05nameto ,textfield1 = tff01name ,textfield2 = tff02name ,textfield3 = tff03name ,textfield4 = tff04name ,textfield5 = tff05name ,tinyintfield1 = bff01name,tinyintfield2 = bff02name,tinyintfield3 = bff03name,tinyintfield4 = bff04name,tinyintfield5 = bff05name where id = id_1; end;
/
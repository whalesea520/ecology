create table fnaTmpTbLogColInfo(
	id Integer PRIMARY KEY NOT NULL, 
	guid1 VARCHAR2(250), 
	colDbName VARCHAR2(50),
	colType VARCHAR2(50),
	colValue VARCHAR2(250),
	colValueInt Integer
)
/

create sequence fnaTmpTbLogColInfo_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create index idx_fnaTmpTbLogColInfo_1 on fnaTmpTbLogColInfo (guid1)
/

create index idx_fnaTmpTbLogColInfo_2 on fnaTmpTbLogColInfo (colType)
/

create index idx_fnaTmpTbLogColInfo_3 on fnaTmpTbLogColInfo (colValue)
/

create index idx_fnaTmpTbLogColInfo_4 on fnaTmpTbLogColInfo (colValueInt)
/

create or replace trigger fnaTmpTbLogColInfo_Trigger before insert on fnaTmpTbLogColInfo for each row 
begin select fnaTmpTbLogColInfo_ID.nextval INTO :new.id from dual; end;
/
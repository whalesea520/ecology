alter table sysfavourite drop column addtime
/
alter table sysfavourite modify Adddate varchar(20)
/
alter table sysfavourite add  importlevel  Number NULL
/
alter table sysfavourite add  favouritetype  Number  DEFAULT 0
/



CREATE TABLE SysFavourite_favourite(
	id Number NOT NULL PRIMARY KEY,
	favouriteid  Number  NULL ,
	sysfavouriteid  Number  NULL ,
	resourceid  Number  NULL
)
/


CREATE TABLE favourite(
	id Number NOT NULL PRIMARY KEY,
	Resourceid Number NULL ,
	Adddate varchar(20),
	favouritename varchar(150),
	favouritedesc varchar(1000),
	displayorder  Number  NULL ,
	parentid Number NULL 
) 
/


CREATE TABLE favourite_tab(
	id Number NOT NULL PRIMARY KEY,
	favouriteid Number NULL,
	tabid  Number  NULL,
	favouriteAlias varchar(200),
	favouritePageSize  Number  DEFAULT 10,
	favouriteTitleSize  Number  DEFAULT 25,
	showFavouriteTitle  Number  DEFAULT 1,
	showFavouriteLevel  Number  DEFAULT 1,
	Resourceid  Number  NULL ,
	position  Number DEFAULT 1
)
/


CREATE TABLE favouritetab(
	id  Number  NOT NULL PRIMARY KEY,
	Resourceid  Number  NULL ,
	Adddate varchar(20),
	tabname varchar(150),
	tabdesc varchar(1000),
	displayorder  Number  NULL 
)
/


CREATE TABLE FavouriteLastActive(
	activeid  Number  NULL ,
	Resourceid  Number  NULL ,
	activetitle varchar(150),
	activetype  Number  NULL 
)
/
create sequence SysFavourite_f_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysFavourite_f_id_Tri
before insert on SysFavourite_favourite
for each row
begin
select SysFavourite_f_id.nextval into :new.id from dual;
end;
/
CREATE or replace PROCEDURE SysFavourite_Insert
(
	userid_1 integer,
	adddate_2 varchar,
	pagename_3 varchar,
	url_4 varchar,
	importlevel_5 integer,
	favouritetype_6 integer,
	flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into sysfavourite(resourceid,adddate,pagename,url,importlevel,favouritetype)
	VALUES (userid_1,adddate_2,pagename_3,url_4,importlevel_5,favouritetype_6);
	commit;
	open thecursor for
		select max(id) as id from sysfavourite;
end;
/
create sequence favourite_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger favourite_id_Tri
before insert on favourite
for each row
begin
select favourite_id.nextval into :new.id from dual;
end;
/

CREATE or replace PROCEDURE Favourite_Insert(
	userid_1 integer,
	adddate_2 varchar,
	favouritename_3 varchar,
	favouritedesc_4 varchar,
	displayorder_5 integer,
	parentid_6 integer,
	flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into favourite(resourceid,adddate,favouritename,favouritedesc,displayorder,parentid)
	VALUES (userid_1,adddate_2,favouritename_3,favouritedesc_4,displayorder_5,parentid_6);
	commit;
	open thecursor for
		SELECT max(id) as id from favourite;
end;
/
create sequence favourite_tab_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger favourite_tab_id_Tri
before insert on favourite_tab
for each row
begin
select favourite_tab_id.nextval into :new.id from dual;
end;
/
CREATE or replace PROCEDURE Favourite_Tab_Insert
(
	favouriteid_1 integer,
	tabid_2 integer,
	favouritealias_3 varchar,
	favouritepagesize_4 integer,
	favouritetitlesize_5 integer,
	showFavouritetitle_6 integer,
	showfavouritelevel_7 integer,
	resourceid_8 integer,
	flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into favourite_tab(favouriteid,tabid,favouriteAlias,favouritepagesize,favouritetitlesize,showFavouritetitle,showfavouritelevel,resourceid)
	VALUES (favouriteid_1,tabid_2,favouritealias_3,favouritepagesize_4,favouritetitlesize_5,showFavouritetitle_6,showfavouritelevel_7,resourceid_8);
	commit;
	open thecursor for
		select max(id) as id from favourite_tab;
end;
/
create sequence favouritetab_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger favouritetab_id_Tri
before insert on favouritetab
for each row
begin
select favouritetab_id.nextval into :new.id from dual;
end;
/

CREATE or replace PROCEDURE FavouriteTab_Insert
(
	resourceid_1 integer,
	adddate_2 varchar,
	tabname_3 varchar,
	tabdesc_4 varchar,
	displayorder_5 integer,
	flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into favouritetab(resourceid,adddate,tabname,tabdesc,displayorder)
	VALUES (resourceid_1,adddate_2,tabname_3,tabdesc_4,displayorder_5);
	commit;
	open thecursor for
		select max(id) as id from favouritetab;
end;
/


CREATE or replace PROCEDURE SelectSysFavourite_Insert
(
	sysfavouriteid_1 integer,
	adddate_2 varchar,
	flag out integer,
  msg out varchar,
  thecursor IN OUT cursor_define.weavercursor)
AS
begin
	insert into sysfavourite
	  (resourceid, adddate, pagename, url, importlevel,favouritetype)
	  select resourceid, adddate, pagename, url, importlevel,favouritetype
	    from sysfavourite
	   where id = sysfavouriteid_1;
	   commit;
open thecursor for
		select max(id) as id from sysfavourite;
end;
/

CREATE or replace PROCEDURE SysFavourite_SelectByUserID 
(
	resourceid_1 integer,
	flag out integer,
  	msg out varchar2,
  	thecursor IN OUT cursor_define.weavercursor)
AS
begin
	open thecursor for
	select * from sysfavourite where resourceid=resourceid_1 and rownum<=20 order by resourceid,adddate desc;
end;
/

update sysfavourite set importlevel=1,favouritetype=0
/
insert into sysfavourite_favourite
  (favouriteid, sysfavouriteid, resourceid)
  select -1, id, resourceid
    from sysfavourite
   where id not in (select sysfavouriteid from sysfavourite_favourite)
/
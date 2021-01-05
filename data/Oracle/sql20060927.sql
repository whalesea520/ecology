create or replace  PROCEDURE cowork_items_insert
	(name_1 	varchar2,
	 typeid_2 	integer,
	 levelvalue_3 	integer,
	 creater_4 	integer,
	 coworkers_5 	clob,
	 createdate_6 	char,
	 createtime_7 	char,
	 begindate_8 	char,
	 beingtime_9 	char,
	 enddate_10 	char,
	 endtime_11 	char,
	 relatedprj_12 varchar2,
	 relatedcus_13 varchar2,
	 relatedwf_14 	varchar2,
	 relateddoc_15 varchar2,
	 remark_16 	clob,
	 status_17 	integer,
	 isnew_18 	clob,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO cowork_items 
	 ( name,
	 typeid,
	 levelvalue,
	 creater,
	 coworkers,
	 createdate,
	 createtime,
	 begindate,
	 beingtime,
	 enddate,
	 endtime,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc,
	 remark,
	 status,
	 isnew) 
VALUES 
	( name_1,
	 typeid_2,
	 levelvalue_3,
	 creater_4,
	 coworkers_5,
	 createdate_6,
	 createtime_7,
	 begindate_8,
	 beingtime_9,
	 enddate_10,
	 endtime_11,
	 relatedprj_12,
	 relatedcus_13,
	 relatedwf_14,
	 relateddoc_15,
	 remark_16,
	 status_17,
	 isnew_18);
	 open thecursor for 
	 select max(id) from docseccategory;
end;
/


create or replace  PROCEDURE cowork_items_update
	(id_1 	integer,
	 name_2 	varchar2,
	 typeid_3 	integer,
	 levelvalue_4 	integer,
	 creater_5 	integer,
	 coworkers_6 	clob,
	 begindate_7 	char,
	 beingtime_8 	char,
	 enddate_9 	char,
	 endtime_10 	char,
	 relatedprj_11 varchar2,
	 relatedcus_12 varchar2,
	 relatedwf_13 	varchar2,
	 relateddoc_14 varchar2,
	 remark_15 	clob,
	 isnew_16 	clob,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE cowork_items SET 
	 name	 = name_2,
	 typeid	 = typeid_3,
	 levelvalue	 = levelvalue_4,
	 creater	 = creater_5,
	 coworkers	 = coworkers_6,
	 begindate	 = begindate_7,
	 beingtime	 = beingtime_8,
	 enddate	 = enddate_9,
	 endtime	 = endtime_10,
	 relatedprj	 = relatedprj_11,
	 relatedcus	 = relatedcus_12,
	 relatedwf	 = relatedwf_13,
	 relateddoc	 = relateddoc_14,
	 remark	 = remark_15,
	 isnew	 = isnew_16 
WHERE 
	( id	 = id_1);
end;
/

alter table cowork_items rename column isnew to isnewtemp
/
alter table cowork_items add isnew clob
/
update  cowork_items set isnew = isnewtemp
/
alter table cowork_items drop column isnewtemp
/


alter table cowork_items rename column readers to readerstemp
/
alter table cowork_items add readers clob
/
update  cowork_items set readers = readerstemp
/
alter table cowork_items drop column readerstemp
/

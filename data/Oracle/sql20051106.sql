create or replace  PROCEDURE cowork_items_insert
	(name_1 	varchar2,
	 typeid_2 	integer,
	 levelvalue_3 	integer,
	 creater_4 	integer,
	 coworkers_5 	varchar2,
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
	 remark_16 	Varchar2,
	 status_17 	integer,
	 isnew 	varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
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
	 isnew);
open thecursor for
select max(id) from cowork_items;
end;
/

CREATE or REPLACE PROCEDURE cowork_discuss_insert
	(coworkid_1 	integer,
	 discussant_2 	integer,
	 createdate_3 	char,
	 createtime_4 	char,
	 remark_5 	varchar2,
	 relatedprj_6  varchar2,
	 relatedcus_7  varchar2,
	 relatedwf_8 	varchar2,
	 relateddoc_9  varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO cowork_discuss 
	 (coworkid,
	 discussant,
	 createdate,
	 createtime,
	 remark,
	 relatedprj,
	 relatedcus,
	 relatedwf,
	 relateddoc) 
VALUES 
	( coworkid_1,
	 discussant_2,
	 createdate_3,
	 createtime_4,
	 remark_5,
	 relatedprj_6,
	 relatedcus_7,
	 relatedwf_8,
	 relateddoc_9);
end;
/

alter table cowork_items modify createtime char(8)
/
alter table cowork_discuss modify createtime char(8)
/
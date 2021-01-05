create table CoworkAccessory
(
pathcategory varchar2(100),
maincategory varchar2(10),
subcategory varchar2(10),
seccategory varchar2(10)
)
/

alter table cowork_items
add accessory varchar2(500) null
/

alter table cowork_discuss
add ralatedaccessory varchar2(500) null
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
	 relatedacc_10 varchar2,
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
	 relateddoc,
	 ralatedaccessory) 
VALUES 
	( coworkid_1,
	 discussant_2,
	 createdate_3,
	 createtime_4,
	 remark_5,
	 relatedprj_6,
	 relatedcus_7,
	 relatedwf_8,
	 relateddoc_9,
	 relatedacc_10);
end;
/

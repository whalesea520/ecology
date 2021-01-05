ALTER TABLE cowork_items ADD mutil_prjs VARCHAR2(500) NULL
/
ALTER TABLE cowork_discuss ADD mutil_prjs VARCHAR2(500) NULL
/

CREATE or REPLACE PROCEDURE cowork_discuss_insert
	(coworkid_1 	integer,
	 discussant_2 	integer,
	 createdate_3 	char,
	 createtime_4 	char,
	 remark_5 	clob,
	 relatedprj_6  varchar2,
	 relatedcus_7  varchar2,
	 relatedwf_8 	varchar2,
	 relateddoc_9  varchar2,
	 relatedacc_10 varchar2,
	 mutil_prjs_11 varchar2,
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
	 ralatedaccessory,
	 mutil_prjs) 
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
	 relatedacc_10,
	 mutil_prjs_11);
end;
/
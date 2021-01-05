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
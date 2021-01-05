ALTER TABLE DocSearchMould ADD  createrid2 integer
/
ALTER TABLE DocSearchMould ADD ownerid2 integer
/
CREATE or REPLACE PROCEDURE DocSearchMould_Insert 
	(mouldname_1 	varchar2,
	 userid_2 	integer,
	 docsubject_3 	varchar2,
	 doccontent_4 	varchar2,
	 containreply_5 	char,
	 maincategory_6 	integer,
	 subcategory_7 	integer,
	 seccategory_8 	integer,
	 docid_9 	integer,
	 createrid_10 	integer,
     createrid2_11 	integer,
	 departmentid_12 	integer,
	 doclangurage_13 	integer,
	 hrmresid_14 	integer,
	 itemid_15 	integer,
	 itemmaincategoryid_16 	integer,
	 crmid_17 	integer,
	 projectid_18 	integer,
	 financeid_19 	integer,
	 docpublishtype_20 	char,
	 docstatus_21 	char,
	 keyword_22 	varchar2,
	 ownerid_23 	integer,
     ownerid2_24 	integer,
	 docno_25 	varchar2,
	 doclastmoddatefrom_26 	char,
	 doclastmoddateto_27 	char,
	 docarchivedatefrom_28 	char,
	 docarchivedateto_29 	char,
	 doccreatedatefrom_30 	char,
	 doccreatedateto_31 	char,
	 docapprovedatefrom_32 	char,
	 docapprovedateto_33 	char,
	 replaydoccountfrom_34 	integer,
	 replaydoccountto_35 	integer,
	 accessorycountfrom_36 	integer,
	 accessorycountto_37 	integer,
	 doclastmoduserid_38 	integer,
	 docarchiveuserid_39 	integer,
	 docapproveuserid_40 	integer,
	 assetid_41 	integer,
     flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT into DocSearchMould 
	 ( mouldname,
	 userid,
	 docsubject,
	 doccontent,
	 containreply,
	 maincategory,
	 subcategory,
	 seccategory,
	 docid,
	 createrid,
     createrid2,
	 departmentid,
	 doclangurage,
	 hrmresid,
	 itemid,
	 itemmaincategoryid,
	 crmid,
	 projectid,
	 financeid,
	 docpublishtype,
	 docstatus,
	 keyword,
	 ownerid,
     ownerid2,
	 docno,
	 doclastmoddatefrom,
	 doclastmoddateto,
	 docarchivedatefrom,
	 docarchivedateto,
	 doccreatedatefrom,
	 doccreatedateto,
	 docapprovedatefrom,
	 docapprovedateto,
	 replaydoccountfrom,
	 replaydoccountto,
	 accessorycountfrom,
	 accessorycountto,
	 doclastmoduserid,
	 docarchiveuserid,
	 docapproveuserid,
	 assetid) 
 
VALUES 
	( mouldname_1,
	 userid_2,
	 docsubject_3,
	 doccontent_4,
	 containreply_5,
	 maincategory_6,
	 subcategory_7,
	 seccategory_8,
	 docid_9,
	 createrid_10,
     createrid2_11,
	 departmentid_12,
	 doclangurage_13,
	 hrmresid_14,
	 itemid_15,
	 itemmaincategoryid_16,
	 crmid_17,
	 projectid_18,
	 financeid_19,
	 docpublishtype_20,
	 docstatus_21,
	 keyword_22,
	 ownerid_23,
     ownerid2_24,
	 docno_25,
	 doclastmoddatefrom_26,
	 doclastmoddateto_27,
	 docarchivedatefrom_28,
	 docarchivedateto_29,
	 doccreatedatefrom_30,
	 doccreatedateto_31,
	 docapprovedatefrom_32,
	 docapprovedateto_33,
	 replaydoccountfrom_34,
	 replaydoccountto_35,
	 accessorycountfrom_36,
	 accessorycountto_37,
	 doclastmoduserid_38,
	 docarchiveuserid_39,
	 docapproveuserid_40,
	 assetid_41);
open thecursor for
select max(id) from DocSearchMould;
end;
/


CREATE or REPLACE PROCEDURE DocSearchMould_Update 
	(id_1 	integer,
	 mouldname_2 	varchar2,
	 userid_3 	integer,
	 docsubject_4 	varchar2,
	 doccontent_5 	varchar2,
	 containreply_6 	char,
	 maincategory_7 	integer,
	 subcategory_8 	integer,
	 seccategory_9 	integer,
	 docid_10 	integer,
	 createrid_11 	integer,
     createrid2_12 	integer,
	 departmentid_13 	integer,
	 doclangurage_14 	integer,
	 hrmresid_15 	integer,
	 itemid_16 	integer,
	 itemmaincategoryid_17 	integer,
	 crmid_18 	integer,
	 projectid_19 	integer,
	 financeid_20 	integer,
	 docpublishtype_21 	char,
	 docstatus_22 	char,
	 keyword_23 	varchar2,
	 ownerid_24 	integer,
     ownerid2_25 	integer,
	 docno_26 	varchar2,
	 doclastmoddatefrom_27 	char,
	 doclastmoddateto_28 	char,
	 docarchivedatefrom_29 	char,
	 docarchivedateto_30 	char,
	 doccreatedatefrom_31 	char,
	 doccreatedateto_32 	char,
	 docapprovedatefrom_33 	char,
	 docapprovedateto_34 	char,
	 replaydoccountfrom_35 	integer,
	 replaydoccountto_36 	integer,
	 accessorycountfrom_37 	integer,
	 accessorycountto_38 	integer,
	 doclastmoduserid_39 	integer,
	 docarchiveuserid_40 	integer,
	 docapproveuserid_41 	integer,
	 assetid_42 	integer,
     flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE DocSearchMould 
SET  mouldname	 = mouldname_2,
	 userid	 = userid_3,
	 docsubject	 = docsubject_4,
	 doccontent	 = doccontent_5,
	 containreply	 = containreply_6,
	 maincategory	 = maincategory_7,
	 subcategory	 = subcategory_8,
	 seccategory	 = seccategory_9,
	 docid	 = docid_10,
	 createrid	 = createrid_11,
     createrid2	 = createrid2_12,
	 departmentid	 = departmentid_13,
	 doclangurage	 = doclangurage_14,
	 hrmresid	 = hrmresid_15,
	 itemid	 = itemid_16,
	 itemmaincategoryid	 = itemmaincategoryid_17,
	 crmid	 = crmid_18,
	 projectid	 = projectid_19,
	 financeid	 = financeid_20,
	 docpublishtype	 = docpublishtype_21,
	 docstatus	 = docstatus_22,
	 keyword	 = keyword_23,
	 ownerid	 = ownerid_24,
     ownerid2	 = ownerid2_25,
	 docno	 = docno_26,
	 doclastmoddatefrom	 = doclastmoddatefrom_27,
	 doclastmoddateto	 = doclastmoddateto_28,
	 docarchivedatefrom	 = docarchivedatefrom_29,
	 docarchivedateto	 = docarchivedateto_30,
	 doccreatedatefrom	 = doccreatedatefrom_31,
	 doccreatedateto	 = doccreatedateto_32,
	 docapprovedatefrom	 = docapprovedatefrom_33,
	 docapprovedateto	 = docapprovedateto_34,
	 replaydoccountfrom	 = replaydoccountfrom_35,
	 replaydoccountto	 = replaydoccountto_36,
	 accessorycountfrom	 = accessorycountfrom_37,
	 accessorycountto	 = accessorycountto_38,
	 doclastmoduserid	 = doclastmoduserid_39,
	 docarchiveuserid	 = docarchiveuserid_40,
	 docapproveuserid	 = docapproveuserid_41,
	 assetid	 = assetid_42 

WHERE 
	( id= id_1);
end;
/
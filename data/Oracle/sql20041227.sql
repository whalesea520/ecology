/*td:1317 增加工作流日志，节点日志，节点操作组日志，出口日志*/
INSERT INTO SystemLogItem VALUES(85,2118,'工作流程')
/
INSERT INTO SystemLogItem VALUES(86,15586,'工作流节点')
/
INSERT INTO SystemLogItem VALUES(87,15544,'工作流节点操作者组')
/
INSERT INTO SystemLogItem VALUES(88,15587,'工作流节点出口')
/

/*td：1319  增加新闻文档的置顶功能*/
alter table DocFrontPage add importdocid_1 varchar2(200)
/
update DocFrontPage set importdocid_1=importdocid
/
alter table DocFrontPage drop column importdocid
/
alter table DocFrontPage add importdocid varchar2(200)
/
update DocFrontPage set importdocid=importdocid_1
/
alter table DocFrontPage drop column importdocid_1
/

CREATE or REPLACE PROCEDURE DocFrontpage_Insert 
	(frontpagename_1 varchar2,
	 frontpagedesc_2 varchar2,
	 isactive_3 char ,
	 departmentid_4 integer,
	 linktype_5 varchar2,
	 hasdocsubject_6 char ,
	 hasfrontpagelist_7 char ,
	 newsperpage_8  smallint,
	 titlesperpage_9  smallint,
	 defnewspicid_10 integer,
	 backgroundpicid_11 integer,
	 importdocid_12 varchar2,
	 headerdocid_13 integer,
	 footerdocid_14 integer,
	 secopt_15 	varchar2,
	 seclevelopt_16  smallint,
	 departmentopt_17 integer,
	 dateopt_18 integer,
	 languageopt_19 integer,
	 clauseopt_20 varchar2,
	 newsclause_21 varchar2,
	 languageid_22 integer,
	 publishtype_23 integer ,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO DocFrontpage 
	 ( frontpagename,
	 frontpagedesc,
	 isactive,
	 departmentid,
	 linktype,
	 hasdocsubject,
	 hasfrontpagelist,
	 newsperpage,
	 titlesperpage,
	 defnewspicid,
	 backgroundpicid,
	 importdocid,
	 headerdocid,
	 footerdocid,
	 secopt,
	 seclevelopt,
	 departmentopt,
	 dateopt,
	 languageopt,
	 clauseopt,
	 newsclause,
	 languageid,
	 publishtype) 
 
VALUES 
	( frontpagename_1,
	 frontpagedesc_2,
	 isactive_3,
	 departmentid_4,
	 linktype_5,
	 hasdocsubject_6,
	 hasfrontpagelist_7,
	 newsperpage_8,
	 titlesperpage_9,
	 defnewspicid_10,
	 backgroundpicid_11,
	 importdocid_12,
	 headerdocid_13,
	 footerdocid_14,
	 secopt_15,
	 seclevelopt_16,
	 departmentopt_17,
	 dateopt_18,
	 languageopt_19,
	 clauseopt_20,
	 newsclause_21,
	 languageid_22,
	 publishtype_23);
open thecursor for
select max(id) from DocFrontpage;
end;
/

 CREATE or REPLACE PROCEDURE DocFrontpage_Update 
	(id_1 integer,
	 frontpagename_2 varchar2,
	 frontpagedesc_3 varchar2,
	 isactive_4 char ,
	 departmentid_5 integer,
	 hasdocsubject_7 char ,
	 hasfrontpagelist_8 char ,
	 newsperpage_9  smallint,
	 titlesperpage_10  smallint,
	 defnewspicid_11 integer,
	 backgroundpicid_12 integer,
	 importdocid_13 varchar2,
	 headerdocid_14 integer,
	 footerdocid_15	integer,
	 secopt_16 	varchar2,
	 seclevelopt_17  smallint,
	 departmentopt_18 integer,
	 dateopt_19 integer,
	 languageopt_20 integer,
	 clauseopt_21 	varchar,
	 newsclause_22 	varchar,
	 languageid_23 	integer,
	 publishtype_24 integer ,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
UPDATE DocFrontpage SET  frontpagename = frontpagename_2,
	 frontpagedesc = frontpagedesc_3,
	 isactive = isactive_4,
	 departmentid = departmentid_5,
	 hasdocsubject = hasdocsubject_7,
	 hasfrontpagelist = hasfrontpagelist_8,
	 newsperpage = newsperpage_9,
	 titlesperpage = titlesperpage_10,
	 defnewspicid = defnewspicid_11,
	 backgroundpicid	 = backgroundpicid_12,
	 importdocid = importdocid_13,
	 headerdocid = headerdocid_14,
	 footerdocid = footerdocid_15,
	 secopt	 = secopt_16,
	 seclevelopt = seclevelopt_17,
	 departmentopt	 = departmentopt_18,
	 dateopt = dateopt_19,
	 languageopt = languageopt_20,
	 clauseopt	 = clauseopt_21,
	 newsclause	 = newsclause_22,
	 languageid	 = languageid_23,
	 publishtype = publishtype_24 
WHERE 
	( id = id_1);
end;
/
alter table cowork_types rename column managerid to manageridtemp
/
alter table cowork_types add managerid clob
/

alter table cowork_types rename column members to memberstemp
/
alter table cowork_types add members clob
/
declare
id_1 integer;
manageridtemp_1 varchar2(4000);
memberstemp_1 varchar2(4000);
managerid_clob clob;
members_clob clob;
begin
    for c1 IN (select id,manageridtemp,memberstemp from cowork_types) loop
         DBMS_lob.CREATETEMPORARY(managerid_clob,TRUE);
         DBMS_lob.CREATETEMPORARY(members_clob,TRUE);
         id_1 :=c1.id;
         manageridtemp_1 :=to_char(','||c1.manageridtemp||',');
         memberstemp_1 :=to_char(','||c1.memberstemp||',');
         dbms_lob.write(managerid_clob,length(manageridtemp_1),1,manageridtemp_1);
         dbms_lob.write(members_clob,length(memberstemp_1),1,memberstemp_1);
         update cowork_types set managerid=managerid_clob,members=members_clob where id=id_1;
    end loop;
end;
/
alter table cowork_types drop column manageridtemp
/
alter table cowork_types drop column memberstemp
/

alter table cowork_items rename column coworkers to coworkerstemp
/
alter table cowork_items add coworkers clob
/

alter table cowork_items rename column readers to readerstemp
/
alter table cowork_items add readers clob
/

alter table cowork_items rename column isnew to isnewtemp
/
alter table cowork_items add isnew clob
/
declare
id_1 integer;
coworkerstemp_1 varchar2(4000);
readerstemp_1 varchar2(4000);
isnewtemp_1 varchar2(4000);
coworkers_clob clob;
readers_clob clob;
isnew_clob clob;
begin
    for c1 IN (select id,coworkerstemp,readerstemp,isnewtemp from cowork_items) loop
         DBMS_lob.CREATETEMPORARY(coworkers_clob,TRUE);
         DBMS_lob.CREATETEMPORARY(readers_clob,TRUE);
         DBMS_lob.CREATETEMPORARY(isnew_clob,TRUE);
         id_1 :=c1.id;
         coworkerstemp_1 :=to_char(','||c1.coworkerstemp||',');
         readerstemp_1 :=to_char(','||c1.readerstemp||',');
         isnewtemp_1 :=to_char(','||c1.isnewtemp||',');
         dbms_lob.write(coworkers_clob,length(coworkerstemp_1),1,coworkerstemp_1);
         dbms_lob.write(readers_clob,length(readerstemp_1),1,readerstemp_1);
         dbms_lob.write(isnew_clob,length(isnewtemp_1),1,isnewtemp_1);
         update cowork_items set coworkers=coworkers_clob,readers=readers_clob,isnew=isnew_clob where id=id_1;
    end loop;
end;
/
alter table cowork_items drop column coworkerstemp
/
alter table cowork_items drop column readerstemp
/
alter table cowork_items drop column isnewtemp
/
INSERT INTO HtmlLabelIndex values(19780,'标记为重要协作事件') 
/
INSERT INTO HtmlLabelIndex values(19779,'标记为不重要协作事件') 
/
INSERT INTO HtmlLabelInfo VALUES(19779,'标记为不重要协作事件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19779,'Sign Not Importent',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19780,'标记为重要协作事件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19780,'Sign importent',8) 
/

create or replace PROCEDURE cowork_items_insert
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
	 isnew_18 	varchar2,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

as begin 
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

CREATE or replace  PROCEDURE cowork_items_update
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
	 isnew_16 	varchar2,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
as 
begin 
UPDATE cowork_items SET  
	 name = name_2,
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
	( id = id_1);
end;
/


Declare
id2 integer;
readers2 varchar2(8000);
isnew2 varchar2(8000);

begin
FOR all_cursor2 in(
select id,isnew,readers from cowork_items)
loop	
    id2 := all_cursor2.id;
	readers2 := all_cursor2.isnew;
	isnew2 := all_cursor2.readers;
	readers2 := ','|| to_char(readers2) ||',';
	isnew2 := ','|| to_char(isnew2)||',';

	update cowork_items set readers = readers2,isnew = isnew2 where id = id2;
END loop;
end;
/

CREATE OR REPLACE PROCEDURE cowork_items_insert
  (name_1   varchar2,
   typeid_2   integer,
   levelvalue_3   integer,
   creater_4   integer,
   principal_5   integer,
   createdate_6   char,
   createtime_7   char,
   begindate_8   char,
   beingtime_9   char,
   enddate_10   char,
   endtime_11   char,
   relatedprj_12 varchar2,
   relatedcus_13 varchar2,
   relatedwf_14   varchar2,
   relateddoc_15 varchar2,
   remark_16   clob,
   status_17   integer,
   accessory_18   varchar2,
   mutil_prjs_19   varchar2,
   lastdiscussant_20 integer,
   flag out integer  ,
   msg out varchar2 ,
   thecursor        IN OUT cursor_define.weavercursor)
AS begin
INSERT INTO cowork_items
   ( name,
   typeid,
   levelvalue,
   creater,
   principal,
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
   accessory,
   mutil_prjs,
   lastdiscussant)
VALUES
  ( name_1,
   typeid_2,
   levelvalue_3,
   creater_4,
   principal_5,
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
   accessory_18,
   mutil_prjs_19,
   lastdiscussant_20);
   open thecursor for
select max(id) from cowork_items;
end;
/

CREATE OR REPLACE PROCEDURE cowork_items_update
  (id_1   integer,
   name_2   varchar2,
   typeid_3   integer,
   levelvalue_4   integer,
   principal_5 	integer,
   mutil_prjs_6   varchar2,
   begindate_7   char,
   beingtime_8   char,
   enddate_9   char,
   endtime_10   char,
   relatedprj_11 varchar2,
   relatedcus_12 varchar2,
   relatedwf_13   varchar2,
   relateddoc_14 varchar2,
   remark_15   clob,
   accessory_16   varchar2,
   flag out integer  ,
   msg out varchar2 ,
   thecursor  IN OUT cursor_define.weavercursor)
AS begin
UPDATE cowork_items

SET
   name   = name_2,
   typeid   = typeid_3,
   levelvalue   = levelvalue_4,
   principal=principal_5,
   mutil_prjs   = mutil_prjs_6,
   begindate   = begindate_7,
   beingtime   = beingtime_8,
   enddate   = enddate_9,
   endtime   = endtime_10,
   relatedprj   = relatedprj_11,
   relatedcus   = relatedcus_12,
   relatedwf   = relatedwf_13,
   relateddoc   = relateddoc_14,
   remark   = remark_15,
   accessory   = accessory_16
WHERE
  ( id = id_1);
end;
/
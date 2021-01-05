alter table voting add descr varchar(1000)
/
alter table voting add deploytype varchar(5)
/
alter table voting add autoshowvote varchar(5)
/
alter table voting add votetimecontrol varchar(5)
/
alter table voting add votetimecontroltime varchar(100)
/
alter table voting add forcevote varchar(5)
/
alter table voting add remindtype varchar(5)
/
alter table voting add remindtimebeforestart varchar(50)
/
alter table voting add remindtimebeforeend varchar(50)
/
alter table voting add tmp_isanony varchar(5)
/
update voting set tmp_isanony = isanony
/
update voting set isanony = null 
/
alter table voting modify isanony varchar(5)
/
update voting set isanony =tmp_isanony 
/
alter table voting drop column  tmp_isanony
/
alter table voting add hasremindedbeforestart varchar(5)
/
alter table voting add hasremindedbeforeend varchar(5)
/
alter table votingquestion  add pagenum varchar(5)
/
alter table votingquestion  add questiontype  varchar(5)
/
alter table votingoption  add roworcolumn  varchar(5)
/

alter table votingquestion  add ismustinput  varchar(5)
/
alter table votingquestion  add limit  varchar(5)
/
alter table votingquestion  add max  varchar(5)
/
alter table votingquestion  add perrowcols  varchar(5)
/
alter table votingquestion  add israndomsort  varchar(5)
/

alter table votingresource add tmp_optionid varchar(5)
/
update votingresource set tmp_optionid = optionid
/
update votingresource set optionid = null 
/
alter table votingresource modify optionid varchar(5)
/
update votingresource set optionid =tmp_optionid 
/
alter table votingresource drop column  tmp_optionid
/

alter table voting  add istemplate  varchar(5)
/
 
CREATE OR REPLACE  PROCEDURE Voting_Insert ( subject_1   varchar2, detail_2    varchar2, createrid_3 integer, createdate_4    char, createtime_5    char, approverid_6    integer, approvedate_7   char, approvetime_8   char, begindate_9     char, begintime_10     char, enddate_11       char,
endtime_12       char, isanony_13       integer, docid_14         integer, crmid_15     integer, projid_16    integer, requestid_17 integer, votingcount_18   integer, status_19        integer, isSeeResult_20 varchar2, descr_21 varchar2, deploytype_22 varchar2, autoshowvote_23 varchar2, votetimecontrol_24 varchar2, votetimecontroltime_25 varchar2, forcevote_26 varchar2, remindtype_27 varchar2, remindtimebeforestart_28 varchar2, remindtimebeforeend_29 varchar2, istemplate_30 varchar2,  flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin 
 insert into voting ( subject, detail, createrid, createdate, createtime, approverid, approvedate, approvetime, begindate, begintime, enddate, endtime, isanony, docid, crmid, projid, requestid, votingcount, status, isSeeResult,descr,deploytype,autoshowvote,votetimecontrol,votetimecontroltime,forcevote,remindtype,remindtimebeforestart,remindtimebeforeend,istemplate) values ( subject_1, detail_2, createrid_3, createdate_4, createtime_5, approverid_6, approvedate_7, approvetime_8, begindate_9, begintime_10, enddate_11, endtime_12, isanony_13, docid_14, crmid_15, projid_16, requestid_17, votingcount_18, status_19, isSeeResult_20,descr_21, deploytype_22, autoshowvote_23, votetimecontrol_24 , votetimecontroltime_25 , forcevote_26 , remindtype_27 , remindtimebeforestart_28 , remindtimebeforeend_29, istemplate_30  ); open thecursor for select max(id) from voting; end;

 /


CREATE OR REPLACE  PROCEDURE Voting_Update ( id_1    integer, subject_2   varchar2, detail_3    varchar2, createrid_4 integer, createdate_5    char, createtime_6    char, approverid_7    integer, approvedate_8   char, approvetime_9   char, begindate_10     char, begintime_11     char, enddate_12       char, endtime_13       char, isanony_14       integer, docid_15         integer, crmid_16     integer, projid_17    integer, requestid_18 integer, isSeeResult_19 varchar2,  descr_20 varchar2, deploytype_21 varchar2, autoshowvote_22 varchar2, votetimecontrol_23 varchar2, votetimecontroltime_24 varchar2, forcevote_25 varchar2, remindtype_26 varchar2, remindtimebeforestart_27 varchar2, remindtimebeforeend_28 varchar2 , istemplate_29 varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin update voting set subject=subject_2, detail=detail_3, createrid=createrid_4, createdate=createdate_5, createtime=createtime_6, approverid =approverid_7, approvedate=approvedate_8, approvetime=approvetime_9, begindate=begindate_10, begintime=begintime_11, enddate=enddate_12, endtime=endtime_13, isanony=isanony_14, docid=docid_15, crmid=crmid_16, projid=projid_17, requestid=requestid_18, isSeeResult=isSeeResult_19,  descr= descr_20, deploytype = deploytype_21, autoshowvote = autoshowvote_22 , votetimecontrol=votetimecontrol_23, votetimecontroltime=votetimecontroltime_24 , forcevote=forcevote_25, remindtype=remindtype_26 , remindtimebeforestart = remindtimebeforestart_27  , remindtimebeforeend = remindtimebeforeend_28, istemplate = istemplate_29 where id=id_1; end;

/


CREATE TABLE  votingconfig
(
   id                 int,
   doc                varchar(5),
   flow               varchar(5),
   customer           varchar(5),
   project            varchar(5),
   annex              varchar(5),
   annexcatalogpath   varchar(500),
   mainid             int,
   subid              int,
   seccateid          int,
   votingid           int
)

/

insert into  votingconfig(id) values(0)

/
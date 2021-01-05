alter table Bill_Meeting add(remindType integer default 0)
/
alter table Bill_Meeting add(remindBeforeStart integer default 0)
/
alter table Bill_Meeting add(remindBeforeEnd integer default 0)
/
alter table Bill_Meeting add(remindTimesBeforeStart integer default 0)
/
alter table Bill_Meeting add(remindTimesBeforeEnd integer default 0)
/
alter table Meeting add (remindType integer default 0)
/
alter table Meeting add (remindBeforeStart integer default 0)
/
alter table Meeting add (remindBeforeEnd integer default 0)
/
alter table Meeting add (remindTimesBeforeStart integer default 0)
/
alter table Meeting add (remindTimesBeforeEnd integer default 0)
/

insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindType', 18713, 'int', 5, 1, 7, 0, '', 1)
/
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 1, '不提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
/
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 2, '短信提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
/
insert into workflow_selectitem
  (fieldid, isbill, selectvalue, selectname,listorder,isdefault)
  select id, 1, 3, '邮件提醒',.00,'n'
    from workflow_billfield
   where fieldname = 'remindType'
     and billid = 85
/
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindBeforeStart', 23807, 'int', 1, 1, 7, 0, '', 1)
/
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindBeforeEnd', 23806, 'int', 1, 1, 7, 0, '', 1)
/
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindTimesBeforeStart', 23808, 'int', 1, 1, 7, 0, '', 1)
/
insert into workflow_billfield
  (billid,
   fieldname,
   fieldlabel,
   fielddbtype,
   fieldhtmltype,
   type,
   dsporder,
   viewtype,
   detailtable,
   fromuser)
values
  (85, 'remindTimesBeforeEnd', 23809, 'int', 1, 1, 7, 0, '', 1)
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
   (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindType'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
   (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindBeforeStart'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
   (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindBeforeEnd'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
   (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindTimesBeforeStart'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
/
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
   (select id
  from workflow_billfield
 where billid = 85
   and fieldname = 'remindTimesBeforeEnd'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = (select id from workflow_billfield where billid=85 and fieldname='MeetingName')
/

CREATE OR REPLACE PROCEDURE Meeting_Insert(meetingtype_1      integer,
                                           name_1             varchar2,
                                           caller_1           integer,
                                           contacter_1        integer,
                                           projectid_1        integer,
                                           address_1          integer,
                                           begindate_1        varchar2,
                                           begintime_1        varchar2,
                                           enddate_1          varchar2,
                                           endtime_1          varchar2,
                                           desc_n_1           varchar2,
                                           creater_1          integer,
                                           createdate_1       varchar2,
                                           createtime_1       varchar2,
                                           totalmember_1      integer,
                                           othermembers_1     clob,
                                           addressdesc_1      varchar2,
                                           description_1        varchar2,
                                           remindType_1        integer,
                                           remindBeforeStart_1 integer,
                                           remindBeforeEnd_1   integer, 
                                           remindTimesBeforeStart_1 integer,
                                           remindTimesBeforeEnd_1 integer,
                                           customizeAddress_1 varchar2,
                                           flag               out integer,
                                           msg                out varchar2,
                                           thecursor          IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO Meeting
    (meetingtype,
     name,
     caller,
     contacter,
     projectid,
     address,
     begindate,
     begintime,
     enddate,
     endtime,
     desc_n,
     creater,
     createdate,
     createtime,
     totalmember,
     othermembers,
     addressdesc,
     description,
     remindType,
     remindBeforeStart,
     remindBeforeEnd,
     remindTimesBeforeStart,
     remindTimesBeforeEnd,
     customizeAddress)
  VALUES
    (meetingtype_1,
     name_1,
     caller_1,
     contacter_1,
     projectid_1,
     address_1,
     begindate_1,
     begintime_1,
     enddate_1,
     endtime_1,
     desc_n_1,
     creater_1,
     createdate_1,
     createtime_1,
     totalmember_1,
     othermembers_1,
     addressdesc_1,
     description_1,
     remindType_1,
     remindBeforeStart_1,
     remindBeforeEnd_1,
     remindTimesBeforeStart_1,
     remindTimesBeforeEnd_1,
     customizeAddress_1);
end;
/

CREATE OR REPLACE PROCEDURE Meeting_Update(meetingid_1        integer,
                                           name_1             varchar2,
                                           caller_1           integer,
                                           contacter_1        integer,
                                           projectid_1        integer,
                                           address_1          integer,
                                           begindate_1        varchar2,
                                           begintime_1        varchar2,
                                           enddate_1          varchar2,
                                           endtime_1          varchar2,
                                           desc_n_1           varchar2,
                                           totalmember_1      integer,
                                           othermembers_1     clob,
                                           addressdesc_1      varchar2,
                                           description_1        varchar2,
                                           remindType_1        integer,
                                           remindBeforeStart_1 integer,
                                           remindBeforeEnd_1   integer, 
                                           remindTimesBeforeStart_1 integer,
                                           remindTimesBeforeEnd_1 integer,
                                           customizeAddress_1 varchar2,
                                           flag               out integer,
                                           msg                out varchar,
                                           thecursor          IN OUT cursor_define.weavercursor) AS
begin
  Update Meeting
     set name             = name_1,
         caller           = caller_1,
         contacter        = contacter_1,
         projectid        = projectid_1,
         address          = address_1,
         begindate        = begindate_1,
         begintime        = begintime_1,
         enddate          = enddate_1,
         endtime          = endtime_1,
         desc_n           = desc_n_1,
         totalmember      = totalmember_1,
         othermembers     = othermembers_1,
         addressdesc      = addressdesc_1,
         description	  = description_1, 
         remindType       = remindType_1,
         remindBeforeStart= remindBeforeStart_1,
         remindBeforeEnd  = remindBeforeEnd_1,
         remindTimesBeforeStart=remindTimesBeforeStart_1,
         remindTimesBeforeEnd=remindTimesBeforeEnd_1,
         customizeAddress = customizeAddress_1
   where id = meetingid_1;
end;
/

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
  (85, 'description', 22462, 'varchar2(3000)', 2, 1, 7, 0, '', 1)
/

insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
  select nodeid,
         (select id
            from workflow_billfield
           where billid = 85
             and fieldname = 'description'),
         isview,
         isedit,
         ismandatory
    from workflow_nodeform wn
   where wn.fieldid = 504
/

alter table Bill_Meeting add (description varchar2(3000))
/
alter table Meeting add (description varchar2(3000))
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
     customizeAddress_1);
end;
/


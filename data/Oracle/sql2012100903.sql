alter table workflow_requestUserdefault add  commonuse varchar2(10)
/
update workflow_requestUserdefault set  commonuse = 1
/
alter table DocUserDefault add commonuse varchar2(10)
/
update DocUserDefault set commonuse=1
/
create or replace PROCEDURE workflow_RUserDefault_Insert(userid_1               integer,
                                                         selectedworkflow_2     varchar2,
                                                         isuserdefault_3        char,
                                                         hascreatetime_4        char,
                                                         hascreater_5           char,
                                                         hasworkflowname_6      char,
                                                         hasrequestlevel_7      char,
                                                         hasrequestname_8       char,
                                                         hasreceivetime_9       char,
                                                         hasstatus_10           char,
                                                         hasreceivedpersons_11  char,
                                                         hascurrentnode_13      char,
                                                         numperpage_12          integer,
                                                         noReceiveMailRemind_14 char,
                                                         Showoperator_15        char,
                                                         commonuse_16           char,
                                                         flag                   out integer,
                                                         msg                    out varchar2,
                                                         thecursor              IN OUT cursor_define.weavercursor) AS
begin
  insert into workflow_requestUserdefault
    (USERID,
     SELECTEDWORKFLOW,
     ISUSERDEFAULT,
     NUMPERPAGE,
     HASCREATETIME,
     HASCREATER,
     HASWORKFLOWNAME,
     HASREQUESTLEVEL,
     HASREQUESTNAME,
     HASRECEIVETIME,
     HASSTATUS,
     HASRECEIVEDPERSONS,
     HASCURRENTNODE,
     NORECEIVEMAILREMIND,
     Showoperator,
     commonuse)
  values
    (userid_1,
     selectedworkflow_2,
     isuserdefault_3,
     numperpage_12,
     hascreatetime_4,
     hascreater_5,
     hasworkflowname_6,
     hasrequestlevel_7,
     hasrequestname_8,
     hasreceivetime_9,
     hasstatus_10,
     hasreceivedpersons_11,
     hascurrentnode_13,
     noReceiveMailRemind_14,
     Showoperator_15,
     commonuse_16);
end;
/
create or replace PROCEDURE workflow_RUserDefault_Update(userid_1               integer,
                                                         selectedworkflow_2     varchar2,
                                                         isuserdefault_3        char,
                                                         hascreatetime_4        char,
                                                         hascreater_5           char,
                                                         hasworkflowname_6      char,
                                                         hasrequestlevel_7      char,
                                                         hasrequestname_8       char,
                                                         hasreceivetime_9       char,
                                                         hasstatus_10           char,
                                                         hasreceivedpersons_11  char,
                                                         hascurrentnode_13      char,
                                                         numperpage_12          integer,
                                                         noReceiveMailRemind_14 char,
                                                         Showoperator_15        char,
                                                         commonuse_16           char,
                                                         flag                   out integer,
                                                         msg                    out varchar2,
                                                         thecursor              IN OUT cursor_define.weavercursor) AS
begin
  Update workflow_requestUserdefault
     set selectedworkflow    = selectedworkflow_2,
         isuserdefault       = isuserdefault_3,
         hascreatetime       = hascreatetime_4,
         hascreater          = hascreater_5,
         hasworkflowname     = hasworkflowname_6,
         hasrequestlevel     = hasrequestlevel_7,
         hasrequestname      = hasrequestname_8,
         hasreceivetime      = hasreceivetime_9,
         hasstatus           = hasstatus_10,
         hasreceivedpersons  = hasreceivedpersons_11,
         hascurrentnode      = hascurrentnode_13,
         numperpage          = numperpage_12,
         noreceivemailremind = noReceiveMailRemind_14,
         Showoperator        = Showoperator_15,
         commonuse			 = commonuse_16
   where userid = userid_1;
end;
/
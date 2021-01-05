alter table workflow_base add chatsType int  
GO
alter table workflow_base add chatsAlertType   int  
GO
alter table workflow_base add notRemindifArchived  int  
GO

alter table workflow_nodecustomrcmenu add haschats char(1)    
GO
alter table workflow_nodecustomrcmenu add chatsfieldid  int
GO
alter table workflow_nodecustomrcmenu add newCHATSName7  varchar(50)  
GO
alter table workflow_nodecustomrcmenu add newCHATSName8  varchar(50)  
GO
alter table workflow_nodecustomrcmenu add newCHATSName9  varchar(50)  
GO
alter table workflow_nodecustomrcmenu add customChats  varchar(200)  
GO

alter table workflow_requestbase   add chatsType int  
GO
 
alter table workflow_nodelink   add ChatsRemind char(1) 
GO 



CREATE PROCEDURE workflow_requestbase_insertnew
               @requestid        INT,
               @workflowid       INT,
               @lastnodeid       INT,
               @lastnodetype     CHAR(1),
               @currentnodeid    INT,
               @currentnodetype  CHAR(1),
               @status           VARCHAR(50),
               @passedgroups     INT,
               @totalgroups      INT,
               @requestname      VARCHAR(255),
               @creater          INT,
               @createdate       CHAR(10),
               @createtime       CHAR(8),
               @lastoperator     INT,
               @lastoperatedate  CHAR(10),
               @lastoperatetime  CHAR(8),
               @deleted          INT,
               @creatertype      INT,
               @lastoperatortype INT,
               @nodepasstime     FLOAT,
               @nodelefttime     FLOAT,
               @docids           [text],
               @crmids           [text],
               @hrmids           [text],
               @prjids           [text],
               @cptids           [text],
               @messageType      INT,
               @chatsType        INT,
               @flag             INTEGER OUTPUT,
               @msg              VARCHAR(80) OUTPUT
AS
  DECLARE
    @currentdate CHAR(10),
    @currenttime CHAR(8)
  SET @currentdate = Convert(CHAR(10),Getdate(),20)
  SET @currenttime = Convert(CHAR(8),Getdate(),108)
  INSERT INTO workflow_requestbase(requestid,
                                   workflowid,
                                   lastnodeid,
                                   lastnodetype,
                                   currentnodeid,
                                   currentnodetype,
                                   status,
                                   passedgroups,
                                   totalgroups,
                                   requestname,
                                   creater,
                                   createdate,
                                   createtime,
                                   lastoperator,
                                   lastoperatedate,
                                   lastoperatetime,
                                   deleted,
                                   creatertype,
                                   lastoperatortype,
                                   nodepasstime,
                                   nodelefttime,
                                   docids,
                                   crmids,
                                   hrmids,
                                   prjids,
                                   cptids,
                                   messagetype,
                                   chatstype)
  VALUES     (@requestid,
              @workflowid,
              @lastnodeid,
              @lastnodetype,
              @currentnodeid,
              @currentnodetype,
              @status,
              @passedgroups,
              @totalgroups,
              @requestname,
              @creater,
              @currentdate,
              @currenttime,
              @lastoperator,
              @lastoperatedate,
              @lastoperatetime,
              @deleted,
              @creatertype,
              @lastoperatortype,
              @nodepasstime,
              @nodelefttime,
              @docids,
              @crmids,
              @hrmids,
              @prjids,
              @cptids,
              @messageType,
              @chatsType)

GO

ALTER PROCEDURE workflow_requestbase_insert
                @requestid        INT,
                @workflowid       INT,
                @lastnodeid       INT,
                @lastnodetype     CHAR(1),
                @currentnodeid    INT,
                @currentnodetype  CHAR(1),
                @status           VARCHAR(50),
                @passedgroups     INT,
                @totalgroups      INT,
                @requestname      VARCHAR(255),
                @creater          INT,
                @createdate       CHAR(10),
                @createtime       CHAR(8),
                @lastoperator     INT,
                @lastoperatedate  CHAR(10),
                @lastoperatetime  CHAR(8),
                @deleted          INT,
                @creatertype      INT,
                @lastoperatortype INT,
                @nodepasstime     FLOAT,
                @nodelefttime     FLOAT,
                @docids           [text],
                @crmids           [text],
                @hrmids           [text],
                @prjids           [text],
                @cptids           [text],
                @messageType      INT,
                @flag             INTEGER OUTPUT,
                @msg              VARCHAR(80) OUTPUT
AS
  EXEC [workflow_Requestbase_InsertNew]  @requestid ,
                                      @workflowid ,
                                      @lastnodeid ,
                                      @lastnodetype ,
                                      @currentnodeid ,
                                      @currentnodetype ,
                                      @status ,
                                      @passedgroups ,
                                      @totalgroups ,
                                      @requestname ,
                                      @creater ,
                                      @createdate ,
                                      @createtime ,
                                      @lastoperator ,
                                      @lastoperatedate ,
                                      @lastoperatetime ,
                                      @deleted ,
                                      @creatertype ,
                                      @lastoperatortype ,
                                      @nodepasstime ,
                                      @nodelefttime ,
                                      @docids ,
                                      @crmids ,
                                      @hrmids ,
                                      @prjids ,
                                      @cptids ,
                                      @messageType ,
                                      null ,
                                      @flag ,
                                      @msg

GO

insert into wechat_reminder_mode values('workflow','����ģ��')
GO
insert into wechat_reminder_type values('wf_reject','�����˻�','workflow')
GO
insert into wechat_reminder_type values('wf_approve','��������','workflow')
GO
insert into wechat_reminder_type values('wf_submit','����ȷ��','workflow')
GO
insert into wechat_reminder_type values('wf_archive','���̹鵵','workflow')
GO
insert into wechat_reminder_type values('wf_notice','���̳���','workflow')
GO
insert into wechat_reminder_set values('�˻�����:','','���˻أ������˽�','','wf_reject','1')
GO
insert into wechat_reminder_set values('��������:�����µĹ�������Ҫ����:','','','','wf_approve','0')
GO
insert into wechat_reminder_set values('ȷ������:','','��Ҫ����ȷ�ϣ������','','wf_submit','0')
GO
insert into wechat_reminder_set values('�鵵����:','','�ѹ鵵�������','','wf_archive','0')
GO
insert into wechat_reminder_set values('��������:','','���͸����������','','wf_notice','0')
GO
update  workflow_base set chatsType ='0'  where chatsType  is null
GO



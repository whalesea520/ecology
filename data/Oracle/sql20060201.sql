ALTER table workflow_requestUserdefault ADD numperpage integer null
/
ALTER table workflow_requestUserdefault ADD hascreatetime char(1) null
/
ALTER table workflow_requestUserdefault ADD hascreater char(1) null
/
ALTER table workflow_requestUserdefault ADD	hasworkflowname char(1) null
/
ALTER table workflow_requestUserdefault ADD	hasrequestlevel char(1) null
/
ALTER table workflow_requestUserdefault ADD	hasrequestname char(1) null
/
ALTER table workflow_requestUserdefault ADD	hasreceivetime char(1) null
/
ALTER table workflow_requestUserdefault ADD hasstatus char(1) null
/
ALTER table workflow_requestUserdefault ADD hasreceivedpersons char(1) null
/



create or replace PROCEDURE workflow_RUserDefault_Update (
@userid_1	integer, 
@selectedworkflow_2 varchar2, 
@isuserdefault_3    char, 
@hascreatetime_4 char ,
@hascreater_5 char ,
@hasworkflowname_6 char ,
@hasrequestlevel_7 char ,
@hasrequestname_8 char,
@hasreceivetime_9 char,
@hasstatus_10 char ,
@hasreceivedpersons_11 char ,
@numperpage_12 integer ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
Update workflow_requestUserdefault set 
selectedworkflow=@selectedworkflow_2 ,
isuserdefault=@isuserdefault_3 ,
hascreatetime=@hascreatetime_4 ,
hascreater=@hascreater_5 ,
hasworkflowname=@hasworkflowname_6 ,
hasrequestlevel=@hasrequestlevel_7 ,
hasrequestname=@hasrequestname_8 ,
hasreceivetime=@hasreceivetime_9 ,
hasstatus=@hasstatus_10 ,
hasreceivedpersons=@hasreceivedpersons_11 ,
numperpage=@numperpage_12 
where userid=@userid_1; 

end;
/


create or replace PROCEDURE workflow_RUserDefault_Insert (
@userid_1	integer, 
@selectedworkflow_2 varchar2, 
@isuserdefault_3    char, 
@hascreatetime_4 char,
@hascreater_5 char ,
@hasworkflowname_6 char ,
@hasrequestlevel_7 char ,
@hasrequestname_8 char ,
@hasreceivetime_9 char ,
@hasstatus_10 char,
@hasreceivedpersons_11 char ,
@numperpage_12 integer ,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
insert into workflow_requestUserdefault 
values(@userid_1 ,@selectedworkflow_2 ,@isuserdefault_3 ,@hascreatetime_4 ,@hascreater_5 ,@hasworkflowname_6 ,
@hasrequestlevel_7 ,@hasrequestname_8 ,@hasreceivetime_9 ,@hasstatus_10 ,@hasreceivedpersons_11 ,@numperpage_12) ;

end;
/



INSERT INTO HtmlLabelIndex values(18256,'Ìõ') 
/
INSERT INTO HtmlLabelInfo VALUES(18256,'Ìõ',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18256,'row',8) 
/

update workflow_RequestUserDefault 
set hascreatetime ='1',hascreater ='1',hasworkflowname ='1',hasrequestlevel ='1',hasrequestname ='1',hasreceivetime ='1',hasstatus ='1',hasreceivedpersons ='0',numperpage =10
/
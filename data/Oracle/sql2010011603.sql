CREATE TABLE voting_type (
    id integer primary key not null,     /*id*/
    typename varchar2(100),
    approver integer
) 
/
CREATE sequence voting_type_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER voting_type_Id_Trigger
  before insert on voting_type
  for each row
  begin
  select voting_type_Id.nextval into :new.id from dual;
  end;
/

ALTER TABLE Voting ADD votingtype integer default 0
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 182,24094,'int','/systeminfo/BrowserMain.jsp?url=/voting/VotingInfoBrowser.jsp?isfromworkflow=1','voting','subject','id','/voting/VotingView.jsp?isfromworkflow=1&votingid=')
/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(241,24095,'bill_VotingApprove','','','','','','BillVotingApproveOperation.jsp') 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (241,'votingname',24096,'int',3,182,1,0,'')
/

CREATE TABLE bill_VotingApprove ( 
    id integer primary key not null,     /*id*/
    votingname integer,
    requestid integer
)
/
CREATE sequence bill_VotingApprove_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER bill_VotingApprove_Trigger
  before insert on bill_VotingApprove
  for each row
  begin
  select bill_VotingApprove_Id.nextval into :new.id from dual;
  end;
/

ALTER TABLE VotingQuestion ADD showorder integer default 0
/
ALTER TABLE VotingOption ADD showorder integer default 0
/

CREATE or REPLACE PROCEDURE VotingOption_Insert
(votingid_1  integer,
 questionid_2    integer,
 description_3   varchar2,
 optioncount_4   integer,
 showorder_5     integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	insert into votingoption (votingid,questionid,description,optioncount,showorder)
	values (votingid_1,questionid_2,description_3,optioncount_4,showorder_5);
    open thecursor for
    select greatest(id) from votingoption;
end;
/

CREATE or REPLACE PROCEDURE VotingOption_SelectByQuestion
(questionid_1  integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
	select * from votingoption where questionid=questionid_1 order by showorder;
end;
/

CREATE OR REPLACE PROCEDURE VotingQuestion_Insert (
	votingid_1  integer, 
	subject_2   varchar2, 
	description_3   varchar2, 
	ismulti_4       integer, 
	isother_5       integer, 
	questioncount_6 integer, 
	ismultino_7 integer,
        showorder_8 integer,
	flag out integer, 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
insert into votingquestion (
	votingid,
	subject,
	description,
	ismulti,
	isother,
	questioncount,
	ismultino,
        showorder
)values(
	votingid_1,
	subject_2,
	description_3,
	ismulti_4,
	isother_5,
	questioncount_6,
	ismultino_7,
        showorder_8
); 
open thecursor for 
select greatest(id) from votingquestion; 
end;
/

CREATE or REPLACE PROCEDURE VotingQuestion_SelectByVoting
(votingid_1  integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
	select * from votingquestion where votingid=votingid_1 order by showorder;
end;
/

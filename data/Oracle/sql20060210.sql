CREATE or REPLACE PROCEDURE SystemSet_DftSCUpdate(
	dftsubcomid_1 integer,
	flag OUT INTEGER,
	msg OUT VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	update HrmRoles set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0 or subcompanyid=-1;
	update workflow_formdict set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0 or subcompanyid=-1;
	update workflow_formdictdetail set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0 or subcompanyid=-1;
	update workflow_formbase set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0 or subcompanyid=-1;
	update workflow_base set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0 or subcompanyid=-1;
end;
/

ALTER TABLE HrmOtherSettings ADD   needvalidate integer
/
ALTER TABLE HrmOtherSettings ADD   validatetype integer
/
ALTER TABLE HrmOtherSettings ADD   validatenum integer
/
update HrmOtherSettings set needvalidate=0
/

insert into ErrorMsgIndex(id,indexdesc) values(52,'验证码错误')
/
insert into ErrorMsgInfo(indexid,msgname,languageid) values(52,'验证码错误',7)
/
insert into ErrorMsgInfo(indexid,msgname,languageid) values(52,'Validate code is not true',8)
/
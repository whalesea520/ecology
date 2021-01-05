/*以下脚本是对应的oracle脚本*/
CREATE TABLE SysPopRemindInfo (
	userid integer NULL ,
	usertype smallint NULL ,
	hascrmcontact smallint default 0,
	hasnewwf varchar2(4000) null,
	hasdealwf smallint default 0 ,
	hasendwf  varchar2(4000) NULL ,
	haspasstimenode smallint default 0,
	hasapprovedoc smallint default 0 ,
	hasdealdoc smallint default 0 ,
	hasnewemail smallint default 0
)
/

delete SysRemindInfo 
/

CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
   tmp varchar2(255);
   recordcount integer;
begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount=0 then
    insert into SysRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1));
  else
	select userid,hasnewwf into   tmpid, tmp from SysRemindInfo where userid = userid1 and usertype = usertype1;
	if tmp = '' or tmp is null then
		 update SysRemindInfo set hasnewwf = to_char(requestid1)
		 where userid = userid1 and usertype = usertype1;
	else 
        if instr (  concat(concat(',',tmp),',') , concat(concat(',', to_char(requestid1)),',') , 1, 1 )=0 then  
		    update SysRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1))
		    where userid = userid1 and usertype = usertype1;
	    end if;
	end if;
  end if; 

  recordcount := 0 ;

  select count(*) INTO recordcount  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount=0 then
    insert into SysPopRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1));
  else
	select userid,hasnewwf into   tmpid, tmp from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
	if tmp = '' or tmp is null then
		 update SysPopRemindInfo set hasnewwf = to_char(requestid1)
		 where userid = userid1 and usertype = usertype1;
	else 
        if instr (  concat(concat(',',tmp),',') , concat(concat(',', to_char(requestid1)),',') , 1, 1 )=0 then  
		    update SysPopRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1))
		    where userid = userid1 and usertype = usertype1;
	    end if;
	end if;
  end if;
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_InserHasendwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
   tmpid integer ;
    tmp varchar2(255);
	recordcount integer;
	begin
  select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount>0 then
      select hasendwf , userid INTO tmp, tmpid  from SysRemindInfo where userid = userid1 and usertype = usertype1;
      if tmp = '' or tmp is null then
           update SysRemindInfo set hasendwf = to_char(requestid1) 
		   where userid = userid1 and usertype = usertype1;
      else 
           if instr( concat(concat(',',tmp),','), concat(concat(',', to_char(requestid1)),',') ,1,1)=0 then
	              update SysRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1))
				  where userid = userid1 and usertype = usertype1;
           end if;
	  end if;
  else 
  insert into SysRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1));
  end if;  

  recordcount := 0 ;

  select count(*) INTO recordcount  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
  if recordcount>0 then
      select hasendwf , userid INTO tmp, tmpid  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
      if tmp = '' or tmp is null then
           update SysPopRemindInfo set hasendwf = to_char(requestid1) 
		   where userid = userid1 and usertype = usertype1;
      else 
           if instr( concat(concat(',',tmp),','), concat(concat(',', to_char(requestid1)),',') ,1,1)=0 then
	              update SysPopRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1))
				  where userid = userid1 and usertype = usertype1;
           end if;
	  end if;
  else 
  insert into SysPopRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1));
  end if;   
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_IPasstimeNode 
 (
userid1		integer,
usertype1	integer,
haspasstimenode1 integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
tmpid_count integer;
begin
    select  count(userid) INTO tmpid_count  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    if tmpid_count=0 then
        insert into SysPopRemindInfo(userid,usertype,haspasstimenode) values(userid1,usertype1,haspasstimenode1);
    else
        update SysPopRemindInfo set haspasstimenode = haspasstimenode1 where userid = userid1 and usertype = usertype1;
    end if; 
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_DeleteHasendwf
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as

tmp varchar2(255);
tmp_count integer;
begin
    select  count(hasendwf) INTO tmp_count  from SysRemindInfo where userid = userid1 and usertype = usertype1;
    if tmp_count = 1 then
        select  hasendwf INTO tmp  from SysRemindInfo where userid = userid1 and usertype = usertype1;
    end if;

    if tmp is not null  then

        tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');

        if length (tmp) < 2  then
            tmp := '';
        else
           tmp := SUBSTR(tmp,2,length(tmp)-2);
        end if;
        update SysRemindInfo set hasendwf = tmp where userid = userid1 and usertype = usertype1;
    end if;

    tmp_count := 0 ;

    select  count(hasendwf) INTO tmp_count  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    if tmp_count = 1 then
        select  hasendwf INTO tmp  from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    end if;

    if tmp is not null  then

        tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');

        if length (tmp) < 2  then
            tmp := '';
        else
           tmp := SUBSTR(tmp,2,length(tmp)-2);
        end if;
        update SysPopRemindInfo set hasendwf = tmp where userid = userid1 and usertype = usertype1;
    end if;
end;  
/


 CREATE or REPLACE PROCEDURE SysRemindInfo_DeleteHasnewwf 
 (
userid1		integer,
usertype1	integer,
requestid1	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
tmp varchar2(255);
tmp_count integer;
begin
    select  count(hasnewwf) INTO tmp_count from SysRemindInfo where userid = userid1 and usertype = usertype1;
    if(tmp_count=1)then
        select  hasnewwf INTO tmp from SysRemindInfo where userid = userid1 and usertype = usertype1;
    end if;

    if tmp is not null then
        tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');
        if length(tmp) < 2 then
           tmp := null;
        else
           tmp := SUBSTR(tmp,2,length(tmp)-2);
        end if;
        update SysRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1;
    end if; 

    tmp_count := 0 ;

    select  count(hasnewwf) INTO tmp_count from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    if(tmp_count=1)then
        select  hasnewwf INTO tmp from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    end if;

    if tmp is not null then
        tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');
        if length(tmp) < 2 then
           tmp := null;
        else
           tmp := SUBSTR(tmp,2,length(tmp)-2);
        end if;
        update SysPopRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1;
    end if; 
end;
/


CREATE or REPLACE PROCEDURE SysRemindInfo_InserCrmcontact 
 (
userid1		integer,
usertype1	integer,
hascrmcontact1 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
tmpid integer ;
begin
    select count(userid) into tmpid from SysPopRemindInfo where userid = userid1 and usertype = usertype1;
    if tmpid = 0 then
        insert into SysPopRemindInfo(userid,usertype,hascrmcontact) values(userid1,usertype1,hascrmcontact1);
    else
        update SysPopRemindInfo set hascrmcontact = hascrmcontact1 where userid = userid1 and usertype = usertype1;
    end if;
end;
/



INSERT INTO HtmlLabelIndex values(16897,'泛微网站') 
/
INSERT INTO HtmlLabelInfo VALUES(16897,'泛微网站',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16897,'',8) 
/

INSERT INTO HtmlLabelIndex values(16898,'授权用户') 
/
INSERT INTO HtmlLabelInfo VALUES(16898,'授权用户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16898,'',8) 
/

INSERT INTO HtmlLabelIndex values(16899,'版权所有') 
/
INSERT INTO HtmlLabelInfo VALUES(16899,'版权所有',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16899,'',8) 
/

INSERT INTO HtmlLabelIndex values(16900,'关于') 
/
INSERT INTO HtmlLabelInfo VALUES(16900,'关于',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16900,'',8) 
/

/*注：版本更新时需更新该字段为相应的版本*/
UPDATE license set cversion = '2.0'
/


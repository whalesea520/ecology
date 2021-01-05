
 /*以下是杨国生《ecology产品开发资产组不能删除提交测试报告》的脚本*/
 create or replace PROCEDURE CptCapitalAssortment_Delete
 (id_1 	int, 
  flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
)
 AS 
     count_1 integer ; 
	 supassortmentid_1 integer;
begin
	 /*不能有相同的标识*/ 
	 select  capitalcount into count_1  from CptCapitalAssortment where id =  id_1 ;
	 if  count_1 <> 0  then
	     open thecursor for
		select -1 from dual ; 
         return ;
	 end  if;
     
	 select  subassortmentcount into count_1 from CptCapitalAssortment where id =  id_1 ;
	 if  count_1 <> 0 
	 then
	     open thecursor for
		select -1 from dual;
         return ;
	end  if;
    
	 /*一级目录不可删除*/ 
	 select  supassortmentid into supassortmentid_1 from CptCapitalAssortment where id=  id_1;  

	 /* if  supassortmentid = 0 begin select -1 return end */

	 update CptCapitalAssortment set subassortmentcount = subassortmentcount-1 where id=  supassortmentid;   
	 DELETE CptCapitalAssortment WHERE id =  id_1;
end;
/


/*以下是刘煜的《Ecology产品开发-城市维护BUG修改V1.0提交测试报告2003-08-14》的脚本*/

alter table Prj_TaskProcess add dsporder integer
/

alter table SystemSet add defmailserver varchar2(60)
/

alter table SystemSet add defmailfrom varchar2(60)
/

alter table SystemSet add defneedauth smallint
/



/*以下是刘煜的《Ecology产品开发-邮件群发V1.0提交测试报告2003-08-14》的脚本*/

CREATE or replace PROCEDURE HrmCity_Insert 
(cityname_1 	varchar2,
citylongitude_1 number,  
citylatitude_1 number, 
provinceid_1 integer, 
countryid_1 integer, 
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
as 
cityid_1 integer ;
begin 
select ( max(id)+1 ) into cityid_1 from HrmCity ;
insert into HrmCity ( id , cityname, citylongitude, citylatitude, provinceid, countryid )  
VALUES ( cityid_1 , cityname_1, citylongitude_1, citylatitude_1, provinceid_1, countryid_1);
open thecursor for
select cityid_1 from  HrmCity;
end;
/




CREATE or replace PROCEDURE HrmCity_Select
(countryid_1 integer, 
provinceid_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
if countryid_1 = 0 then
open thecursor for
select * from HrmCity order by countryid , provinceid ;
else 
    if provinceid_1= 0 then
    open thecursor for
    select * from HrmCity where countryid = countryid_1 order by countryid , provinceid ;
    else 
    open thecursor for
    select * from HrmCity where countryid = countryid_1 and provinceid = provinceid_1 order by countryid , provinceid ;
    end if;
end if ;
end;
/






 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Insert 
 (prjid1 	integer, 
 taskid1 	integer,  
 wbscoding1 	varchar2, 
 subject1 	varchar2, 
 version1 	smallint, 
 begindate1 	varchar2, 
 enddate1 	varchar2, 
 workday1	number, 
 content1 	varchar2, 
 fixedcost1 number, 
 parentid1 integer,
 parentids1 varchar2, 
 parenthrmids1 varchar2, 
 level_n1 smallint, 
 hrmid1 integer, 	
 prefinish_1 varchar2,
 flag out integer ,
 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  ) 
AS 
 id1 integer;
 maxid1 varchar2(10);
 maxhrmid1 varchar2(255);
 dsporder_9 integer ;
 current_maxid integer ;
begin

	select max(dsporder) into current_maxid from Prj_TaskProcess 
	where prjid = prjid1 and version = version1 and parentid = parentid1 and isdelete != '1' ;
	if current_maxid is null then
	    current_maxid := 0 ;
	end if;
	dsporder_9 := current_maxid + 1 ;

	INSERT INTO Prj_TaskProcess ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,islandmark,prefinish, dsporder)  

	VALUES 
	( prjid1, taskid1 , wbscoding1, subject1 , version1 , begindate1, enddate1, workday1, content1, fixedcost1, parentid1, parentids1, parenthrmids1, level_n1, hrmid1,'0',prefinish_1,dsporder_9); 

	select  max(id) INTO id1 from Prj_TaskProcess;
	 if id1 is null then
		id1 := 0 ;
	 end if;	
	 maxid1 := concat(to_char( id1) , ',');
	 maxhrmid1 := concat(concat('|' , to_char( id1)) , concat(concat( ',' , to_char( hrmid1)) , '|') );
	update Prj_TaskProcess set parentids= concat(parentids1, maxid1), parenthrmids=concat(parenthrmids1 , maxhrmid1)  where id=id1;
end;
/




CREATE or REPLACE PROCEDURE Prj_TaskProcess_DeleteByID 
(id1 varchar2,	 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )  
AS 
dsporder_1 integer ;
prjid_2 integer ;
version_3 integer ; 
parentid_4 integer ; 	
begin
select  dsporder , prjid , version , parentid into dsporder_1, prjid_2, version_3, parentid_4 
from Prj_TaskProcess where ( id	 = id1 ) ;

update Prj_TaskProcess set dsporder = dsporder - 1 
where  prjid = prjid_2 and version = version_3 and parentid = parentid_4 
and isdelete != '1' and dsporder > dsporder_1 ;

update Prj_TaskProcess set isdelete='1' , dsporder = -1 
WHERE ( id	 = id1 or concat(',',parentids) like concat (concat('%,',id1),',%')) ;

update Prj_TaskProcess set childnum = childnum -1 where id = parentid_4 ;

end;
/


/* 对原有系统的项目进行排序处理 */
/* 开始  */
CREATE or REPLACE PROCEDURE PrjDspOrderSet 
AS 
 processid_1 integer ;
 version_2 integer; 
 projid_3 integer;
 parentid_4 integer; 
 dsporderid_5 integer;  
 version_6 integer;
 projid_7 integer;
 parentid_8 integer;

begin
version_6 := -1;
projid_7 := -1;
parentid_8 := -1;

for manager_cursor in (select id,version,prjid,parentid from Prj_TaskProcess where isdelete != '1' order by version , prjid , parentid, id)
loop
    processid_1 := manager_cursor.id;
    version_2 := manager_cursor.version;
    projid_3 := manager_cursor.prjid;
    parentid_4 := manager_cursor.parentid;

    if version_2 != version_6 or projid_3 != projid_7 or parentid_4 != parentid_8 then
        version_6 := version_2;
        projid_7 := projid_3;
        parentid_8 := parentid_4;
        dsporderid_5 := 1;
    else
       dsporderid_5 := dsporderid_5 + 1; 
       update Prj_TaskProcess set dsporder = dsporderid_5 where ( id = processid_1 ) ;
    end if ;
end loop ;

update Prj_TaskProcess set dsporder = -1 where ( isdelete = '1'  ) ;
end;
/

call PrjDspOrderSet() 
/

drop PROCEDURE PrjDspOrderSet 
/


/* 结束 */
CREATE or REPLACE PROCEDURE PrjTaskProcess_UOrder
	(processid_1  integer ,
     upordown  integer ,
   flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )  

AS 
otherprocessid_1 integer ;
version_2 integer ;
projid_3 integer ; 
parentid_4 integer;
dsporderid_5 integer;

begin
select dsporder , version , prjid , parentid  into dsporderid_5 , version_2 , projid_3 ,  parentid_4    
from Prj_TaskProcess where ( id	 = processid_1);

if upordown = 1 then
select  id  into otherprocessid_1  from Prj_TaskProcess 
    where version = version_2 and prjid = projid_3 and parentid = parentid_4 and dsporder = dsporderid_5 - 1;
    update Prj_TaskProcess set dsporder = dsporderid_5 - 1 where id = processid_1;
    update Prj_TaskProcess set dsporder = dsporderid_5 where id = otherprocessid_1;
else 
    select id into otherprocessid_1 from Prj_TaskProcess 
    where version = version_2 and prjid = projid_3 and parentid = parentid_4 and dsporder = dsporderid_5 + 1;
    update Prj_TaskProcess set dsporder = dsporderid_5 + 1 where id = processid_1;
    update Prj_TaskProcess set dsporder = dsporderid_5 where id = otherprocessid_1;
end if;
end;
/



/* 下面对现有项目任务的子任务数量bug作更正：原有系统删除子任务时候，上级任务的子任务数量没有减少1 */

/* 开始  */
CREATE or REPLACE PROCEDURE PrjChildnumChange 
AS 

 parentid_1 integer ; 
 countsbuid integer ;

begin
update Prj_TaskProcess set childnum = 0 where isdelete != '1';

for manager_cursor in( 
select count(id) countsbuid ,parentid from Prj_TaskProcess where isdelete != '1' and parentid != 0 
group by parentid)
loop
    countsbuid :=manager_cursor.countsbuid;
    parentid_1 :=manager_cursor.parentid;
    update Prj_TaskProcess set childnum = countsbuid where ( id = parentid_1 ) ;
end loop;
end;
/


call PrjChildnumChange ()
/

drop PROCEDURE PrjChildnumChange 
/

/* 结束 */



/* 增加群发服务器 */

CREATE OR REPLACE PROCEDURE SystemSet_Update 
    (emailserver_1  varchar2 , 
    debugmode_2   char , 
    logleaveday_3  smallint ,
    defmailuser_4  varchar2 ,
    defmailpassword_5  varchar2 ,
    pop3server_6  varchar2,
    filesystem_7 varchar2,
    filesystembackup_8 varchar2,
    filesystembackuptime_9 integer ,
    needzip_10 char,
    needzipencrypt_11 char,
    defmailserver_12 varchar,
    defmailfrom_13 varchar,
    defneedauth_14 char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
 update SystemSet set 
    emailserver=emailserver_1 , 
    debugmode=debugmode_2,
    logleaveday=logleaveday_3 ,
    defmailuser=defmailuser_4 , 
    defmailpassword=defmailpassword_5 , 
    pop3server=pop3server_6 ,
    filesystem=filesystem_7,
    filesystembackup=filesystembackup_8 ,
    filesystembackuptime=filesystembackuptime_9 , 
    needzip=needzip_10 , 
    needzipencrypt=needzipencrypt_11 ,
    defmailserver=defmailserver_12 ,
    defmailfrom=defmailfrom_13 ,
    defneedauth=defneedauth_14 ;
end;
/





/*以下是刘煜的《Ecology产品开发-文档是否阅读BUG修改V1.0提交测试报告2003-08-14》的脚本*/

CREATE OR REPLACE PROCEDURE docReadTag_AddByUser 
 (docid_1 	integer ,
  userid_2 	integer ,
  userType_3	integer ,
  flag out integer ,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor )  
AS 
 readcount integer;
 begin

 select   count(userid)  into readcount  from docReadTag 
 where docid = docid_1 and userid = userid_2 and userType = userType_3;
if readcount is not null and readcount > 0
then
    update DocReadTag set readcount = readcount+1 
    where docid = docid_1 and userid = userid_2 and userType = userType_3;
else 
    insert into  DocReadTag (docid,userid,readcount,usertype) 
    values(docid_1, userid_2, 1, userType_3);
end if;
end ;
/


delete docReadTag where readcount = 0 
/


CREATE OR REPLACE PROCEDURE docReadTag_SRead 
(	docid_1  integer,
	userid_2 integer,
    usertype_3 integer,
	flag out integer ,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor )  
as
count1 integer ;
count2 integer;
begin
select count(docid)  into  count1  from docReadTag where docid=docid_1 and userid=userid_2 and 
usertype=usertype_3;
select count(id)  into count2   from docdetail where id=docid_1 and doccreaterid=userid_2 and
usertype=to_char(usertype_3);

if count1 is null then
   count1 := 0 ;
end if;
if count2 is null then
count2 := 0 ;
end if;
open thecursor for
select Concat(count1, count2) from  docReadTag;
end;
/


/* 下面的脚本将原来阅读文章的记录从 DocDetailLog 复制到 DocReadTag */
/* 开始 */
CREATE OR REPLACE PROCEDURE  docReadTagInit
AS
resourceid integer ;
docid integer ;
readcount integer;
begin
delete DocReadTag where usertype = 1;
for  resource_cursor  in (select id from hrmresource )
loop
 resourceid := resource_cursor.id;
 for doc_cursor in( select count(docid) readcount , docid from DocDetailLog where operatetype='0' and 
 operateuserid=resourceid group  by docid )
 loop
    readcount := doc_cursor.readcount;
    docid := doc_cursor.docid;
    insert into  DocReadTag (docid,userid,readcount,usertype) 
    values(docid, resourceid, readcount , 1);
 end loop;  
end loop;
end;
/


call docReadTagInit()
/

drop PROCEDURE  docReadTagInit
/



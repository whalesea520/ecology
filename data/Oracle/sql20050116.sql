
/*建立知道订阅表*/
CREATE TABLE DocSubscribe (
	id integer  NOT NULL,
	docId integer NULL  ,
	hrmId integer NULL  ,
    ownerId integer null,
    subscribeDate char(10) NULL ,
    approveDate  char(10) NULL ,
    searchCase     varchar2(500) NULL,
    otherSubscribe  varchar2(500) NULL,
    subscribeDesc  varchar2(500) NULL,
    getBackDesc	   varchar2(500) NULL,
	state char (1)   NULL 
) 
/
create sequence DocSubscribe_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSubscribe_Trigger
before insert on DocSubscribe
for each row
begin
select DocSubscribe_id.nextval into :new.id from dual;
end;
/

/*按ID(订阅表)选择相应的订阅信息*/
CREATE or REPLACE PROCEDURE DocSubscribe_SelectById(
    id_1 integer ,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
    open thecursor for
	select * from DocSubscribe where id =  id_1;
 end;
/

 /*按(文档的ID)选择相应的订阅信息*/

CREATE or REPLACE PROCEDURE DocSubscribe_SelectByDocId(
    Docid_1 integer ,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
AS
begin
open thecursor for
	select * from DocSubscribe where docid =  Docid_1;
end;
/



/*按人员的ID选择相应的订阅信息*/

CREATE or REPLACE PROCEDURE DocSubscribe_SelectByHrmId(
    HrmId_1 integer ,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
    open thecursor for
	select * from DocSubscribe where hrmId =  HrmId_1;
end;
/



/*按文档ID和人员的ID选择相应的订阅信息*/

CREATE or REPLACE PROCEDURE DocSubscribe_SByDIdAndHId(
    Docid_1 integer,
    HrmId_2 integer ,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
    open thecursor for
	select * from DocSubscribe where docid= Docid_1 and hrmId =  HrmId_2;
end;
/



 /*对订阅表进行更新*/
CREATE or REPLACE PROCEDURE DocSubscribe_update(
    id_1 integer ,	
    docId integer ,	
    hrmId integer ,
    ownerId integer,
    subscribeDate char,
    approveDate char,
    searchCase     varchar2 ,
    subscribeDesc  varchar2 ,
    otherSubscribe  varchar2 ,
    getBackDesc	   varchar2,
    state char,
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
	update DocSubscribe set docId=docId,hrmId=hrmId,ownerId=ownerId,subscribeDate=subscribeDate,approveDate=approveDate,state=state,searchCase=searchCase,subscribeDesc=subscribeDesc,getBackDesc=getBackDesc,otherSubscribe=otherSubscribe where id =  id_1;
 end;
/


/*对订阅表进行插入*/

CREATE or REPLACE PROCEDURE DocSubscribe_Insert(
    docId integer ,	
    hrmId integer ,	
    ownerId integer,
    subscribeDate char,
    approveDate char,
    searchCase     varchar2,
    subscribeDesc  varchar2 ,
    getBackDesc	   varchar2 ,
    otherSubscribe  varchar2 ,
    state char,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
	insert into DocSubscribe(docId,hrmId,ownerId,subscribeDate,approveDate,searchCase,subscribeDesc,getBackDesc,state,otherSubscribe) values (docId,hrmId,ownerId,subscribeDate,approveDate,searchCase,subscribeDesc,getBackDesc,state,otherSubscribe);
    open thecursor for
    select greatest(id) from DocSubscribe;
end;
/

 
/*对订阅表按id进行删除*/

CREATE or REPLACE PROCEDURE DocSubscribe_DeleteById(
    id_1 integer ,	
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
	delete DocSubscribe where id =  id_1;
end;    
/

/*只对状态和其它文档订阅做更新*/
CREATE or REPLACE PROCEDURE DocSubscribe_updateSandO(
    id_1 integer ,	
    state_2 char,
    otherSubscribe_3  varchar2,
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
	update DocSubscribe set state = state_2,otherSubscribe=otherSubscribe_3 where id =  id_1;
end;
/



 CREATE or REPLACE PROCEDURE DocSubscribe_UsateByDidSid(
    docid_1 integer,	
    hrmid_2 integer,	
    state_3 char , 
    flag out integer, 
	msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
    AS
    begin
	update DocSubscribe set state = state_3 where docid =  docid_1 and hrmid = hrmid_2;
end;
/



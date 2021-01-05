alter  table docsubscribe add  subscribeType integer
/
alter  table docsubscribe add  ownerType integer
/
update docsubscribe set subscribetype=1 
/


/*对订阅表进行插入*/

create or replace  PROCEDURE DocSubscribe_Insert(
    docId_1 integer ,	
    hrmId_2 integer ,	
    ownerId_3 integer,
    subscribeDate_4 char,
    approveDate_5 char,
    searchCase_6     varchar2 ,
    subscribeDesc_7  varchar2 ,
    getBackDesc_8	   varchar2 ,
    otherSubscribe_9  varchar2 ,
    state_10 char,
    subscribetype_11 integer,
    ownertype_12 integer,	
    flag out 	integer	,
    msg out	varchar2,
    thecursor IN OUT cursor_define.weavercursor
 )
AS
begin
	insert into DocSubscribe(docId,hrmId,ownerId,subscribeDate,approveDate,searchCase,subscribeDesc,getBackDesc,state,otherSubscribe,subscribetype,ownertype) values (docId_1,hrmId_2,ownerId_3,subscribeDate_4,approveDate_5,searchCase_6,subscribeDesc_7,getBackDesc_8,state_10,otherSubscribe_9,subscribetype_11,ownertype_12);
    open thecursor for 
    select max(id) from DocSubscribe;
end ;
/

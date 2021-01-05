alter  table docsubscribe add  subscribeType int
Go
alter  table docsubscribe add  ownerType int
Go

update docsubscribe set subscribetype=1 
Go


/*对订阅表进行插入*/

Alter PROCEDURE DocSubscribe_Insert(
    @docId int ,	
    @hrmId int ,	
    @ownerId int,
    @subscribeDate char(10),
    @approveDate char(10),
    @searchCase     varchar(500) ,
    @subscribeDesc  varchar(500) ,
    @getBackDesc	   varchar(500) ,
    @otherSubscribe  varchar(500) ,
    @state char(1),
    @subscribetype int,
    @ownertype int,	
    @flag integer output , 
    @msg varchar(80) output
    )
    AS
	insert into DocSubscribe(docId,hrmId,ownerId,subscribeDate,approveDate,searchCase,subscribeDesc,getBackDesc,state,otherSubscribe,subscribetype,ownertype) values (@docId,@hrmId,@ownerId,@subscribeDate,@approveDate,@searchCase,@subscribeDesc,@getBackDesc,@state,@otherSubscribe,@subscribetype,@ownertype)
    select max(id) from DocSubscribe
 
GO

CREATE TRIGGER Tri_UMailByHrmResource ON HrmResource
FOR UPDATE
AS
DECLARE 
    @userid int,
    @email varchar(50),
    @countDeleted int,
    @countInserted int
    
SELECT @countDeleted=COUNT(*) FROM DELETED
SELECT @countInserted=COUNT(*) FROM INSERTED

IF @countInserted>0
BEGIN
    SELECT @userid=id,@email=email FROM INSERTED
    UPDATE MailUserAddress SET mailaddress=@email WHERE mailUserDesc=CAST(@userid AS varchar(10)) AND mailUserType='2'
END
GO

CREATE TRIGGER Tri_UMailByCRMContacter ON CRM_CustomerContacter
FOR UPDATE
AS
DECLARE 
    @userid int,
    @email varchar(50),
    @countDeleted int,
    @countInserted int
    
SELECT @countDeleted=COUNT(*) FROM DELETED
SELECT @countInserted=COUNT(*) FROM INSERTED

IF @countInserted>0
BEGIN
    SELECT @userid=id,@email=email FROM INSERTED
    UPDATE MailUserAddress SET mailaddress=@email WHERE mailUserDesc=CAST(@userid AS varchar(10)) AND mailUserType='3'
END
GO
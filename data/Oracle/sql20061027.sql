create or REPLACE TRIGGER Tri_UMailByHrmResource
after update ON HrmResource 
FOR each row

DECLARE 
    userid_1 integer;
    email_1 varchar2(50);
    countDeleted_1 integer;
    countInserted_1 integer; 
 BEGIN   
countDeleted_1 := :old.id ;
countInserted_1 := :new.id ;

IF countInserted_1>0 then
    userid_1 := :new.id ;
    email_1 := :new.email ;
    UPDATE MailUserAddress SET mailaddress=email_1 WHERE mailUserDesc=CAST(userid_1 AS varchar(10)) AND mailUserType='2';
    end if;
END;
/

create or REPLACE TRIGGER Tri_UMailByCRMContacter
after update ON CRM_CustomerContacter 
FOR each row

DECLARE 
    userid_1 integer;
    email_1 varchar2(50);
    countDeleted_1 integer;
    countInserted_1 integer;
BEGIN
    countDeleted_1 := :old.id ;
    countInserted_1 := :new.id ;

IF countInserted_1>0 then

    userid_1 := :new.id ;
    email_1 := :new.email ;
    UPDATE MailUserAddress SET mailaddress=email_1 WHERE mailUserDesc=CAST(userid_1 AS varchar(10)) AND mailUserType='3';
    end if;
END;
/
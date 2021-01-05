CREATE TABLE tempSysPoppupRemindInfo (value varchar2(4000))
/



CREATE OR REPLACE PROCEDURE CreateSysPoppupRemindInfo
(
    initValueParameter IN varchar2,
    outputValueParameter OUT varchar2,
    outputCountParameter OUT integer
)
IS
    initValue varchar2(4000) := initValueParameter;
    outputValue varchar2(4000) := outputValueParameter;
    outputCount integer := outputCountParameter;
    tempSQL varchar2(4000);
    tempValue varchar2(4000);
BEGIN
    DELETE FROM tempSysPoppupRemindInfo;
    
    SELECT REPLACE(initValue, ',', ''' AS STR FROM DUAL UNION SELECT ''') INTO tempSQL FROM DUAL;    
        
    EXECUTE IMMEDIATE('INSERT INTO tempSysPoppupRemindInfo SELECT ''' || tempSQL || ''' FROM DUAL');
    
    DECLARE 
        CURSOR cur IS
               SELECT distinct(value) FROM tempSysPoppupRemindInfo where value IS NOT NULL;
    BEGIN
        OPEN cur;
        FETCH cur INTO tempValue;
        WHILE (cur % FOUND) 
            LOOP
                outputValueParameter := outputValueParameter || tempValue || ',';
                FETCH cur INTO tempValue;
            END LOOP;
        CLOSE cur;
    END;
    
    SELECT COUNT(distinct(value)) INTO outputCountParameter FROM tempSysPoppupRemindInfo where value IS NOT NULL;
END;
/



DECLARE
    userID integer;
    requestIDs varchar2(4000);
    finalRequestIDs varchar2(4000);
    finalCount integer;
    
    CURSOR curMain1 IS
        SELECT userID, requestIDs
        FROM SysPoppupRemindInfo 
        WHERE TYPE = 0
        ORDER BY userID;

BEGIN
    OPEN curMain1;
        
    FETCH curMain1
        INTO userID, requestIDs;
        
    WHILE (curMain1 % FOUND) 
        LOOP                    
            CreateSysPoppupRemindInfo(requestIDs, finalRequestIDs, finalCount);            
            EXECUTE IMMEDIATE('UPDATE SysPoppupRemindInfo SET count = ' || finalCount || ' , requestIDs = ''' || finalRequestIDs || ''' WHERE userID = ' || userID || ' AND type = 0');        
            FETCH curMain1
                  INTO userID, requestIDs;                  
        END LOOP;
    CLOSE curMain1;
END;
/



DECLARE
    userID integer;
    requestIDs varchar2(4000);
    finalRequestIDs varchar2(4000);
    finalCount integer;
    
    CURSOR curMain2 IS
        SELECT userID, requestIDs
        FROM SysPoppupRemindInfo 
        WHERE TYPE = 1
        ORDER BY userID;

BEGIN
    OPEN curMain2;
        
    FETCH curMain2
        INTO userID, requestIDs;
        
    WHILE (curMain2 % FOUND) 
        LOOP                    
            CreateSysPoppupRemindInfo(requestIDs, finalRequestIDs, finalCount);            
            EXECUTE IMMEDIATE('UPDATE SysPoppupRemindInfo SET count = ' || finalCount || ' , requestIDs = ''' || finalRequestIDs || ''' WHERE userID = ' || userID || ' AND type = 1');        
            FETCH curMain2
                  INTO userID, requestIDs;                  
        END LOOP;
    CLOSE curMain2;
END;
/



DROP PROCEDURE CreateSysPoppupRemindInfo
/

DROP TABLE tempSysPoppupRemindInfo
/

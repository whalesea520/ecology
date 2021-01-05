create or replace procedure p_updateReportSqlWHere
is 
tempStr varchar2(4000);
sqlWhere varchar2(4000);
tabTitle varchar2(1000);
inSqlWhere varchar2(4000);
eid  hpElement.id%TYPE;
countNum hpNewsTabInfo.Ordernum%TYPE :=0;
splitlen integer := 3;
split2 varchar(10) := '^,^';
split1 varchar(10) := '_$_';
cursor oldLine is select id,strsqlwhere from hpElement where ebaseid = 'reportForm' and strsqlwhere is not null;
begin
  open oldLine;
  loop
    fetch oldLine into eid,sqlWhere;
    exit when oldLine%notfound;
    WHILE INSTR(sqlWhere,split1)>0
    loop
      tempStr := SUBSTR(sqlWhere,1,INSTR(sqlWhere,split1)-1);
      inSqlWhere := SUBSTR(tempStr,1,INSTR(tempStr,split2)+splitlen-1);
      tempStr :=  SUBSTR(tempStr,INSTR(tempStr,split2)+splitlen);
      tabTitle := nvl(SUBSTR(tempStr,1,INSTR(tempStr,split2)-1),'Tab' || countNum);
      inSqlWhere := inSqlWhere || SUBSTR(tempStr,INSTR(tempStr,split2)+splitlen);
      INSERT INTO hpNewsTabInfo(eid,tabid,tabTitle,sqlWhere,orderNum)  VALUES(eid,countNum,tabTitle,inSqlWhere, countNum);
      sqlWhere:=SUBSTR(sqlWhere,INSTR(sqlWhere,split1)+splitlen);
      countNum := countNum + 1;
    END loop;
    tempStr := sqlWhere; 
    inSqlWhere := SUBSTR(tempStr,1,INSTR(tempStr,split2)+splitlen-1);
    tempStr :=  SUBSTR(tempStr,INSTR(tempStr,split2)+splitlen);
    tabTitle := nvl(SUBSTR(tempStr,1,INSTR(tempStr,split2)-1),'Tab' || countNum);
    inSqlWhere := inSqlWhere || SUBSTR(tempStr,INSTR(tempStr,split2)+splitlen);
    INSERT INTO hpNewsTabInfo(eid,tabid,tabTitle,sqlWhere,orderNum)  VALUES(eid,countNum,tabTitle,inSqlWhere, countNum);
  end loop;
 close oldLine;
 commit;
end;
/
call p_updateReportSqlWHere()
/
/* this sql sentence is modify dongping for TD1329
 * date 2003.11.3
 * this file is contain sql and oracle sentence
 **/




/*需要在oracle数据库中执行的脚本*/


 CREATE OR REPLACE PROCEDURE  SysFavourite_Insert (
     resourceid1 integer,
     Adddate1 char,
     Addtime1 char, 
     Pagename1    varchar2, 
     URL1     varchar2, 
     flag out integer , 
     msg out varchar2, 
     thecursor IN OUT cursor_define.weavercursor)
 AS
 totalcount   integer;
 begin
     select count(*)  INTO totalcount  from sysfavourite where  URL=URL1 and resourceid=resourceid1 ; 

     if totalcount <=0  then
         INSERT INTO SysFavourite ( Resourceid, Adddate, Addtime, Pagename, URL) 
         VALUES ( resourceid1, Adddate1,Addtime1,Pagename1,URL1)  ;
         
         open thecursor for
            select 1 from dual ;
     else
        open thecursor for
            select 0 from dual ;
     end if;
 end;
/


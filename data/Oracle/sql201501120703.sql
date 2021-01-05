CREATE OR REPLACE PROCEDURE Share_forDoc
(
    docid_1 integer ,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
)
AS 
 sharetype_1 integer;
 newsharetype_1 integer;
 sharecontent_1 varchar2(4000);
 sharelevel_1 integer;
 foralluser_1 integer;
 departmentid_1 integer;
 subcompanyid_1 integer;
 userid_1 integer;
 ownerid_1 integer;
 createrid_1 integer;
 crmid_1 integer;
 orgGroupId_1 integer;
 temp_userid_1 integer;
 srcfrom_1 integer;
 opuser_1 integer;
 temp_departmentid_1 integer ;

 roleid_1 integer;
 rolelevel_1 integer;
 rolevalue_1 integer;
 seclevel_1 integer;
 sharesource_1 integer;

 isExistInner_1 integer;
 isExistOuter_1 integer;
  isSysadmin_1 integer;
  hasmanager_1        integer;
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
 downloadlevel_1 integer;
BEGIN
    
    DELETE ShareinnerDoc  WHERE  sourceid=docid_1;
    DELETE ShareouterDoc  WHERE  sourceid=docid_1;

    
    for shareuserid_cursor in(select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel 
    from docshare where docid=docid_1 and docid>0)
    loop
        sharetype_1 := shareuserid_cursor.sharetype;
        seclevel_1 := shareuserid_cursor.seclevel;
        userid_1 := shareuserid_cursor.userid;
        subcompanyid_1 := shareuserid_cursor.subcompanyid;
        departmentid_1 := shareuserid_cursor.departmentid;
        foralluser_1 := shareuserid_cursor.foralluser;
        sharelevel_1 := shareuserid_cursor.sharelevel;
        roleid_1 := shareuserid_cursor.roleid;
        rolelevel_1 := shareuserid_cursor.rolelevel;
        crmid_1 := shareuserid_cursor.crmid;
        orgGroupId_1 := shareuserid_cursor.orgGroupId;
        sharesource_1 := shareuserid_cursor.sharesource;
      downloadlevel_1:= shareuserid_cursor.downloadlevel;
        isExistInner_1:=0;
        isExistOuter_1:=0;
      if downloadlevel_1 is null then
            downloadlevel_1 := 0;
      end if;

        if sharetype_1=1  then  
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;
           
          elsif sharetype_1=2 then 
          begin
                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;  
           
           elsif  sharetype_1=3 then
           begin
                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;  

           elsif  sharetype_1=6 then
           begin
                newsharetype_1 := 6;
                sharecontent_1 := orgGroupId_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 6;
                opuser_1 := orgGroupId_1;

                isExistInner_1 := 1;
           end; 
     
           elsif sharetype_1=5  then
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;
           
           elsif  sharetype_1=80 then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 80;
                opuser_1 := userid_1;
                isExistInner_1 := 1;

        select count(id) into count_1  from docdetail where id = docid_1;
        if count_1 >0 then
        select  ownerid into ownerid_1 from docdetail where id = docid_1;
        select doccreaterid into createrid_1 from docdetail where id = docid_1;
        end if;
        if (ownerid_1 != createrid_1) then
           insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
           values(docid_1,1,ownerid_1,0,sharelevel_1,86,0,0, downloadlevel_1); 
        end if; 
           end; 
                      
          elsif  sharetype_1=81  then
          begin
              
        select  count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
        select count(*)  into hasmanager_1  from hrmresource a,hrmresource b     where a.id=b.managerid and b.id= userid_1;
        if (isSysadmin_1 !=1 and hasmanager_1 = 1)  
        then                
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          srcfrom_1 := 81;
          opuser_1 := userid_1;

          isExistInner_1 := 1;
         end  if;     
       end; 
           elsif  sharetype_1=84 then 
              begin
           
           select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;                   
                  if (isSysadmin_1!=1)   
                  then 
                  newsharetype_1 := 2;
                            
                  SELECT  count(departmentid) into count_3  FROM HrmResource where id=userid_1;
          if count_3 >=1 then
          SELECT departmentid into temp_departmentid_1  FROM HrmResource where id=userid_1;
          end if;
          select  count (subcompanyid1) into count_4  from  HrmDepartment where id = temp_departmentid_1;
          if count_4 >=1 then
                  select  subcompanyid1 into sharecontent_1   from  HrmDepartment where id = temp_departmentid_1;
          end if;
                    seclevel_1 := seclevel_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                  end if;
        end; 
             elsif  sharetype_1=85 then 
              begin
                   
                  
          select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1 != 1)   
                  then 
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResource where id=userid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM HrmResource where id=userid_1;
                   end if;
                 seclevel_1 := seclevel_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                  end if;
        end;  
              
              elsif  sharetype_1=-81 then 
          begin
               newsharetype_1 := 1;    
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; 
               seclevel_1 := 0;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end; 
       elsif  sharetype_1=9 then 
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end; 

        elsif  sharetype_1=-80  then
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end; 
         elsif  sharetype_1<0  then 
          begin
               newsharetype_1 := 10;           
               sharecontent_1:=sharetype_1*-1;

               srcfrom_1 := 10;
               opuser_1 := sharetype_1;

               isExistOuter_1 := 1;
          end; 
      elsif  sharetype_1=4  then 
          begin  
               newsharetype_1:=4;                                   
               
               srcfrom_1:=4;
               opuser_1:=roleid_1;
               
               if newsharetype_1 is null then  newsharetype_1:=0; end if;
               if sharecontent_1 is null then  sharecontent_1:=0; end if;
               if seclevel_1 is null then  seclevel_1:=0;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;
               
               IF rolelevel_1=0 then 
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );     
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
              END;
              elsIF rolelevel_1=1 then                        
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
              END;
              elsIF rolelevel_1=2 then
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
              END;
              end if;
               isExistInner_1:=0;  
            end;   
           end if; 
           
            IF  isExistInner_1=1 then
             BEGIN                 
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                  if sharesource_1 is null then  sharesource_1:=0; end if ;

                                          
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);             
             END; 
             End if;

             IF  isExistOuter_1=1  then
             BEGIN                 
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                 if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);
             END;
             End if;
      end loop;
       EXCEPTION WHEN OTHERS THEN
       BEGIN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            RETURN;
        END;
END;

/

CREATE OR REPLACE PROCEDURE Share_forDoc_init
(
    docid_1 integer
)
AS
 sharetype_1 integer;
 newsharetype_1 integer;
 sharecontent_1 varchar2(4000);
 sharelevel_1 integer;
 foralluser_1 integer;
 departmentid_1 integer;
 subcompanyid_1 integer;
 userid_1 integer;
 ownerid_1 integer;
 createrid_1 integer;
 crmid_1 integer;
 temp_userid_1 integer;
 srcfrom_1 integer;
 opuser_1 integer;
 temp_departmentid_1 integer ;

 roleid_1 integer;
 rolelevel_1 integer;
 rolevalue_1 integer;
 seclevel_1 integer;
 sharesource_1 integer;

 isExistInner_1 integer;
 isExistOuter_1 integer;
  isSysadmin_1 integer;
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
BEGIN


    
    for shareuserid_cursor in(select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,sharesource
    from docshare where docid=docid_1 and docid>0)
    loop
        sharetype_1 := shareuserid_cursor.sharetype;
        seclevel_1 := shareuserid_cursor.seclevel;
        userid_1 := shareuserid_cursor.userid;
        subcompanyid_1 := shareuserid_cursor.subcompanyid;
        departmentid_1 := shareuserid_cursor.departmentid;
        foralluser_1 := shareuserid_cursor.foralluser;
        sharelevel_1 := shareuserid_cursor.sharelevel;
        roleid_1 := shareuserid_cursor.roleid;
        rolelevel_1 := shareuserid_cursor.rolelevel;
        crmid_1 := shareuserid_cursor.crmid;
        sharesource_1 := shareuserid_cursor.sharesource;

        isExistInner_1:=0;
        isExistOuter_1:=0;


        if sharetype_1=1  then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;

          elsif sharetype_1=2 then 
          begin
                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;

           elsif  sharetype_1=3 then
           begin
                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;

           elsif sharetype_1=5  then
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;

           elsif  sharetype_1=80 then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 80;
                opuser_1 := userid_1;
                isExistInner_1 := 1;

        select count(id) into count_1  from docdetail where id = docid_1;
        if count_1 >0 then
        select  ownerid into ownerid_1 from docdetail where id = docid_1;
        select doccreaterid into createrid_1 from docdetail where id = docid_1;
        end if;
        if (ownerid_1 != createrid_1) then
           insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)
           values(docid_1,1,ownerid_1,0,sharelevel_1,86,0,0);
        end if;
           end;

          elsif  sharetype_1=81  then
          begin
              
        select  count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
        if (isSysadmin_1 !=1)
        then
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          srcfrom_1 := 81;
          opuser_1 := userid_1;

          isExistInner_1 := 1;
         end  if;
       end;
           elsif  sharetype_1=84 then 
              begin

           select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1!=1)
                  then
                  newsharetype_1 := 2;

                  SELECT  count(departmentid) into count_3  FROM HrmResource where id=userid_1;
          if count_3 >=1 then
          SELECT departmentid into temp_departmentid_1  FROM HrmResource where id=userid_1;
          end if;
          select  count (subcompanyid1) into count_4  from  HrmDepartment where id = temp_departmentid_1;
          if count_4 >=1 then
                  select  subcompanyid1 into sharecontent_1   from  HrmDepartment where id = temp_departmentid_1;
          end if;
                    seclevel_1 := seclevel_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                  end if;
        end;
             elsif  sharetype_1=85 then 
              begin

                  
          select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1 != 1)
                  then
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResource where id=userid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM HrmResource where id=userid_1;
                   end if;
                 seclevel_1 := seclevel_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                  end if;
        end;

              elsif  sharetype_1=-81 then 
          begin
               newsharetype_1 := 1;
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; 
               seclevel_1 := 0;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end;
       elsif  sharetype_1=9 then 
          begin
               newsharetype_1 := 9  ;
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end;

        elsif  sharetype_1=-80  then
          begin
               newsharetype_1 := 9  ;
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end;
         elsif  sharetype_1<0 and sharetype_1>-80 then 
          begin
               newsharetype_1 := 10;
               sharecontent_1:=sharetype_1*-1;

               srcfrom_1 := 10;
               opuser_1 := sharetype_1;

               isExistOuter_1 := 1;
          end;
      elsif  sharetype_1=4  then
          begin
               newsharetype_1:=4;

               srcfrom_1:=4;
               opuser_1:=roleid_1;

               if newsharetype_1 is null then  newsharetype_1:=0; end if;
               if sharecontent_1 is null then  sharecontent_1:=0; end if;
               if seclevel_1 is null then  seclevel_1:=0;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;

               IF rolelevel_1=0 then 
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
              END;
              elsIF rolelevel_1=1 then
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              elsIF rolelevel_1=2 then
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              end if;
               isExistInner_1:=0;  
            end;
           end if;

            IF  isExistInner_1=1 then
             BEGIN
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                  if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1);
             END;
             End if;

             IF  isExistOuter_1=1  then
             BEGIN
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                 if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1);
             END;
             End if;
      end loop;
       EXCEPTION WHEN OTHERS THEN
       BEGIN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            RETURN;
        END;
END;

/

CREATE OR REPLACE TRIGGER HrmDepartmentTimesTamp_tri AFTER INSERT OR DELETE OR UPDATE ON HrmDepartment FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  elsif :new.id<>:old.id or NVL(:new.departmentname,' ')<>NVL(:old.departmentname,' ') or NVL(:new.supdepid,0)<>NVL(:old.supdepid,0) or NVL(:new.subcompanyid1,0)<>NVL(:old.subcompanyid1,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmDepartment';
  end if;
END;

/

CREATE or REPLACE PROCEDURE CptCapitalAssortment_Insert 
  ( assortmentname_1   varchar2,
    assortmentmark_1  varchar2,
    assortmentremark_1   varchar2, 
   supassortmentid_1   integer, 
   supassortmentstr_1   varchar2,
flag out integer ,
   msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor) 
    AS 
  count_1 integer ;
  count_01 integer;
  begin

    if supassortmentid_1 <>0  then
     

     select  count(capitalcount) INTO count_01  from CptCapitalAssortment      where id = supassortmentid_1 ;
    if count_01>0 then

     select  capitalcount INTO count_1  from CptCapitalAssortment 
     where id = supassortmentid_1 ;
   end if;
   end if;

     if count_1 <> 0 then
    open thecursor for
   select -1 from dual;
     return;
   end if; 


      UPDATE CptCapitalAssortment 
      SET subassortmentcount=subassortmentcount+1 
      WHERE id = supassortmentid_1 ; 
    
    INSERT INTO
 CptCapitalAssortment
 (assortmentname,assortmentmark, assortmentremark, supassortmentid, supassortmentstr, subassortmentcount, capitalcount )
 VALUES (assortmentname_1, assortmentmark_1,assortmentremark_1, supassortmentid_1, supassortmentstr_1, 0, 0);
    open thecursor for

select max(id) from CptCapitalAssortment ;
end;
/

CREATE or REPLACE PROCEDURE CptUseLogOther_Insert 
  (capitalid_1   integer,
   usedate_2   char,
   usedeptid_3   integer,
   useresourceid_4   integer,
   usecount_5   number,
   useaddress_6   varchar2,
   userequest_7   integer,
   maintaincompany_8   varchar2,
   fee_9   number,
   usestatus_10   varchar2,
   remark_11   varchar2,
   costcenterid_1   integer,
   sptcount_1  char,
   flag out integer ,
   msg out varchar2 ,
   thecursor IN OUT cursor_define.weavercursor)

AS 
num_1 integer;
num_count integer;
begin

if sptcount_1 <>'1' then
    select count(capitalnum) INTO num_count  from CptCapital where id = capitalid_1;
    if num_count >0 then

       select capitalnum INTO num_1  from CptCapital where id = capitalid_1;
        if num_1 <usecount_5 then
              open thecursor for
              select -1 from dual;
            return;
        else 
        num_1 := num_1-usecount_5;
        end if;
    end if;
end if;
INSERT INTO CptUseLog 
   ( capitalid,
   usedate,
   usedeptid,
   useresourceid,
   usecount,
   useaddress,
   userequest,
   maintaincompany,
   fee,
   usestatus,
   remark) 
 
VALUES 
  ( capitalid_1,
   usedate_2,
   usedeptid_3,
   useresourceid_4,
   usecount_5,
   useaddress_6,
   userequest_7,
   maintaincompany_8,
   fee_9,
   usestatus_10,
   remark_11) ;

if sptcount_1 ='1' then

  Update CptCapital
  Set 
  location = useaddress_6,
  departmentid = usedeptid_3,
  costcenterid = costcenterid_1,
  resourceid   = useresourceid_4,
  stateid = usestatus_10
  where id = capitalid_1 ;


else 

  Update CptCapital
  Set
  capitalnum = num_1
  where id = capitalid_1;
end if;

open thecursor for
select 1 from dual ;
end ;
/

CREATE or REPLACE PROCEDURE CptUseLogUse_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	number,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	number,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_1   integer,
	 sptcount_1	char,
	 olddeptid integer,
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 number;
 num_count integer;
 begin

if sptcount_1 <> '1' then
    select count(capitalnum) INTO num_count from CptCapital where id = capitalid_1;
  if(num_count > 0) then

    select capitalnum INTO num_1 from CptCapital where id = capitalid_1;
    if num_1 < usecount_5 then
      open thecursor for
    select -1 from dual;
    return;
   else 
     num_1 := num_1-usecount_5;
   end if;
   end if;
end if;

INSERT INTO CptUseLog 
   ( capitalid,
   usedate,
   usedeptid,
   useresourceid,
   usecount,
   useaddress,
   userequest,
   maintaincompany,
   fee,
   usestatus,
   remark,
   olddeptid) 
 
VALUES 
  ( capitalid_1,
   usedate_2,
   usedeptid_3,
   useresourceid_4,
   usecount_5,
   useaddress_6,
   userequest_7,
   maintaincompany_8,
   fee_9,
   '2',
   remark_11,
              0);

if sptcount_1 ='1' then
  Update CptCapital
  Set 
  location = useaddress_6,
  departmentid = usedeptid_3,
  costcenterid = costcenterid_1,
  resourceid   = useresourceid_4,
  stateid = usestatus_10
  where id = capitalid_1 ;

else 
  Update CptCapital
  Set
  capitalnum = num_1
  where id = capitalid_1;
open thecursor for
select 1 from dual;
end if;
end;
/

CREATE OR REPLACE PROCEDURE DocFrontpage_Insert_New(frontpagename_1    varchar2,
                                                frontpagedesc_2    varchar2,
                                                isactive_3         char,
                                                departmentid_4     integer,
                                                linktype_5         varchar2,
                                                hasdocsubject_6    char,
                                                hasfrontpagelist_7 char,
                                                newsperpage_8      smallint,
                                                titlesperpage_9    smallint,
                                                defnewspicid_10    integer,
                                                backgroundpicid_11 integer,
                                                importdocid_12     varchar2,
                                                headerdocid_13     integer,
                                                footerdocid_14     integer,
                                                secopt_15          varchar2,
                                                seclevelopt_16     smallint,
                                                departmentopt_17   integer,
                                                dateopt_18         integer,
                                                languageopt_19     integer,
                                                clauseopt_20       clob,
                                                newsclause_21      clob,
                                                languageid_22      integer,
                                                publishtype_23     integer,
                                                newstypeid_24      integer,
                                                typeordernum_25    integer,
                                                subcompanyid_26    integer,
                                                flag               out integer,
                                                msg                out varchar2,
                                                thecursor          IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO DocFrontpage
    (frontpagename,
     frontpagedesc,
     isactive,
     departmentid,
     linktype,
     hasdocsubject,
     hasfrontpagelist,
     newsperpage,
     titlesperpage,
     defnewspicid,
     backgroundpicid,
     importdocid,
     headerdocid,
     footerdocid,
     secopt,
     seclevelopt,
     departmentopt,
     dateopt,
     languageopt,
     clauseopt,
     newsclause,
     languageid,
     publishtype,
     newstypeid,
     typeordernum,
     subcompanyid)
  VALUES
    (frontpagename_1,
     frontpagedesc_2,
     isactive_3,
     departmentid_4,
     linktype_5,
     hasdocsubject_6,
     hasfrontpagelist_7,
     newsperpage_8,
     titlesperpage_9,
     defnewspicid_10,
     backgroundpicid_11,
     importdocid_12,
     headerdocid_13,
     footerdocid_14,
     secopt_15,
     seclevelopt_16,
     departmentopt_17,
     dateopt_18,
     languageopt_19,
     clauseopt_20,
     newsclause_21,
     languageid_22,
     publishtype_23,
     newstypeid_24,
     typeordernum_25,
     subcompanyid_26);
  open thecursor for
    select max(id) from DocFrontpage;
end;

/

CREATE OR REPLACE PROCEDURE docfrontpage_update_New(id_1               INTEGER,
                                                frontpagename_2    VARCHAR2,
                                                frontpagedesc_3    VARCHAR2,
                                                isactive_4         CHAR,
                                                departmentid_5     INTEGER,
                                                hasdocsubject_7    CHAR,
                                                hasfrontpagelist_8 CHAR,
                                                newsperpage_9      SMALLINT,
                                                titlesperpage_10   SMALLINT,
                                                defnewspicid_11    INTEGER,
                                                backgroundpicid_12 INTEGER,
                                                importdocid_13     VARCHAR2,
                                                headerdocid_14     INTEGER,
                                                footerdocid_15     INTEGER,
                                                secopt_16          VARCHAR2,
                                                seclevelopt_17     SMALLINT,
                                                departmentopt_18   INTEGER,
                                                dateopt_19         INTEGER,
                                                languageopt_20     INTEGER,
                                                clauseopt_21       CLOB,
                                                newsclause_22      CLOB,
                                                languageid_23      INTEGER,
                                                publishtype_24     INTEGER,
                                                newstypeid_25      INTEGER,
                                                typeordernum_26    INTEGER,
                                                checkOutStatus_27  INTEGER,
                                                checkOutUserId_28  INTEGER,
                                                subcompanyid_29   integer,
                                                flag               OUT INTEGER,
                                                msg                OUT VARCHAR2,
                                                thecursor          IN OUT cursor_define.weavercursor) AS
BEGIN
  UPDATE docfrontpage
     SET frontpagename    = frontpagename_2,
         frontpagedesc    = frontpagedesc_3,
         isactive         = isactive_4,
         departmentid     = departmentid_5,
         hasdocsubject    = hasdocsubject_7,
         hasfrontpagelist = hasfrontpagelist_8,
         newsperpage      = newsperpage_9,
         titlesperpage    = titlesperpage_10,
         defnewspicid     = defnewspicid_11,
         backgroundpicid  = backgroundpicid_12,
         importdocid      = importdocid_13,
         headerdocid      = headerdocid_14,
         footerdocid      = footerdocid_15,
         secopt           = secopt_16,
         seclevelopt      = seclevelopt_17,
         departmentopt    = departmentopt_18,
         dateopt          = dateopt_19,
         languageopt      = languageopt_20,
         clauseopt        = clauseopt_21,
         newsclause       = newsclause_22,
         languageid       = languageid_23,
         publishtype      = publishtype_24,
         newstypeid       = newstypeid_25,
         typeordernum     = typeordernum_26,
         checkOutStatus   = checkOutStatus_27,
         checkOutUserId   = checkOutUserId_28,
         subcompanyid     = subcompanyid_29
   WHERE (ID = id_1);
END;

/

CREATE or REPLACE PROCEDURE DocSecCategoryShare_Ins_G(secid_1          integer,
                                                      sharetype_2      integer,
                                                      seclevel_3       smallint,
                                                      rolelevel_4      smallint,
                                                      sharelevel_5     smallint,
                                                      userid_6         integer,
                                                      subcompanyid_7   integer,
                                                      departmentid_8   integer,
                                                      roleid_9         integer,
                                                      foralluser_10    smallint,
                                                      crmid_11         integer,
                                                      orgGroupId_12    integer,
                                                      downloadlevel_13 integer,
                                                      flag             out integer,
                                                      msg              out varchar2,
                                                      thecursor        IN OUT cursor_define.weavercursor) as
begin
  insert into DocSecCategoryShare
    (seccategoryid,
     sharetype,
     seclevel,
     rolelevel,
     sharelevel,
     userid,
     subcompanyid,
     departmentid,
     roleid,
     foralluser,
     crmid,
     orgGroupId,
     downloadlevel)
  values
    (secid_1,
     sharetype_2,
     seclevel_3,
     rolelevel_4,
     sharelevel_5,
     userid_6,
     subcompanyid_7,
     departmentid_8,
     roleid_9,
     foralluser_10,
     crmid_11,
     orgGroupId_12,
     downloadlevel_13);
end;
/

CREATE or REPLACE procedure Doc_GetPermittedCategory(userid_1        integer,
                                                     usertype_1      integer,
                                                     seclevel_1      integer,
                                                     operationcode_1 integer,
                                                     departmentid_1  integer,
                                                     subcompanyid_1  integer,
                                                     roleid_1        varchar2,
                                                     flag            out integer,
                                                     msg             out varchar2,
                                                     thecursor       IN OUT cursor_define.weavercursor) as
  secdirid_1     integer;
  secdirname_1   varchar2(4000);
  subdirid_1     integer;
  subdirid1_1    integer;
  superdirid_1   integer;
  superdirtype_1 integer;
  maindirid_1    integer;
  subdirname_1   varchar2(4000);
  count_1        integer;
  orderid_1      float;
begin
  if usertype_1 = 0 then
    for secdir_cursor in (select id mainid,
                                 categoryname,
                                 subcategoryid,
                                 secorder
                            from DocSecCategory
                           where id in
                                 (select distinct sourceid
                                    from DirAccessControlDetail
                                   where sharelevel = operationcode_1
                                     and ((type = 1 and
                                         content = departmentid_1 and
                                         seclevel <= seclevel_1) or
                                         (type = 2 and
                                         content in
                                         (select *
                                              from TABLE(CAST(SplitStr(roleid_1,
                                                                       ',') AS
                                                              mytable))) and
                                         seclevel <= seclevel_1) or
                                         (type = 3 and
                                         seclevel <= seclevel_1) or
                                         (type = 4 and content = usertype_1 and
                                         seclevel <= seclevel_1) or
                                         (type = 5 and content = userid_1) or
                                         (type = 6 and
                                         content = subcompanyid_1 and
                                         seclevel <= seclevel_1)))) loop
      secdirid_1   := secdir_cursor.mainid;
      secdirname_1 := secdir_cursor.categoryname;
      subdirid_1   := secdir_cursor.subcategoryid;
      orderid_1    := secdir_cursor.secorder;
      insert into temp_4
        (categoryid,
         categorytype,
         superdirid,
         superdirtype,
         categoryname,
         orderid)
      values
        (secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
      if subdirid_1 is null then
        subdirid_1 := -1;
      end if;
      if subdirid_1 = 0 then
        subdirid_1 := -1;
      end if;
      while subdirid_1 <> -1 loop
        select subcategoryid,
               categoryname,
               subcategoryid,
               maincategoryid,
               suborder
          into subdirid1_1,
               subdirname_1,
               superdirid_1,
               maindirid_1,
               orderid_1
          from DocSubCategory
         where id = subdirid_1;
        if superdirid_1 = -1 then
          superdirid_1   := maindirid_1;
          superdirtype_1 := 0;
        else
          superdirtype_1 := 1;
        end if;
        count_1 := 0;
        select count(categoryid)
          into count_1
          from temp_4
         where categoryid = subdirid_1
           and categorytype = 1;
        if count_1 <= 0 then
          insert into temp_4
            (categoryid,
             categorytype,
             superdirid,
             superdirtype,
             categoryname,
             orderid)
          values
            (subdirid_1,
             1,
             superdirid_1,
             superdirtype_1,
             subdirname_1,
             orderid_1);
        end if;
        subdirid_1 := subdirid1_1;
      end loop;
    end loop;
  else
    for secdir_cursor in (select id mainid,
                                 categoryname,
                                 subcategoryid,
                                 secorder
                            from DocSecCategory
                           where id in
                                 (select distinct dirid mainid
                                    from DirAccessControlList
                                   where dirtype = 2
                                     and operationcode = operationcode_1
                                     and ((permissiontype = 3 and
                                         seclevel <= seclevel_1) or
                                         (permissiontype = 4 and
                                         usertype = usertype_1 and
                                         seclevel <= seclevel_1)))) loop
      secdirid_1   := secdir_cursor.mainid;
      secdirname_1 := secdir_cursor.categoryname;
      subdirid_1   := secdir_cursor.subcategoryid;
      orderid_1    := secdir_cursor.secorder;
      insert into temp_4
        (categoryid,
         categorytype,
         superdirid,
         superdirtype,
         categoryname,
         orderid)
      values
        (secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
      if subdirid_1 is null then
        subdirid_1 := -1;
      end if;
      if subdirid_1 = 0 then
        subdirid_1 := -1;
      end if;
      while subdirid_1 <> -1 loop
        select subcategoryid,
               categoryname,
               subcategoryid,
               maincategoryid,
               suborder
          into subdirid1_1,
               subdirname_1,
               superdirid_1,
               maindirid_1,
               orderid_1
          from DocSubCategory
         where id = subdirid_1;
        if superdirid_1 = -1 then
          superdirid_1   := maindirid_1;
          superdirtype_1 := 0;
        else
          superdirtype_1 := 1;
        end if;
        count_1 := 0;
        select count(categoryid)
          into count_1
          from temp_4
         where categoryid = subdirid_1
           and categorytype = 1;
        if count_1 <= 0 then
          insert into temp_4
            (categoryid,
             categorytype,
             superdirid,
             superdirtype,
             categoryname,
             orderid)
          values
            (subdirid_1,
             1,
             superdirid_1,
             superdirtype_1,
             subdirname_1,
             orderid_1);
        end if;
        subdirid_1 := subdirid1_1;
      end loop;
    end loop;
  end if;
  for maindir_cursor in (select id, categoryname, categoryorder
                           from DocMainCategory
                          where id in (select distinct superdirid
                                         from temp_4
                                        where superdirtype = 0)) loop
    subdirid_1   := maindir_cursor.id;
    subdirname_1 := maindir_cursor.categoryname;
    orderid_1    := maindir_cursor.categoryorder;
    insert into temp_4
      (categoryid,
       categorytype,
       superdirid,
       superdirtype,
       categoryname,
       orderid)
    values
      (subdirid_1, 0, -1, -1, subdirname_1, orderid_1);
  end loop;
  open thecursor for
    select * from temp_4 order by orderid, categoryid;
end;
/

CREATE OR REPLACE PROCEDURE Employee_EmaiUpdate(email_1         varchar2,
                                                emailpassword_1 varchar2,
                                                hrmid_1         integer,
                                                flag            out integer,
                                                msg             out varchar2,
                                                thecursor       IN OUT cursor_define.weavercursor) as
  count_1 integer;
begin
  update HrmResource set email = email_1 WHERE id = hrmid_1;
  if emailpassword_1 = 'novalue$1' then
    insert INTO MailPassword
      (resourceid, resourcemail, password)
    values
      (hrmid_1, email_1, emailpassword_1);
  end if;
 update HrmInfoStatus set status = '1' WHERE itemid = 2 AND hrmid = hrmid_1;
end;

/

CREATE or REPLACE PROCEDURE FnaYearsPeriodsList_Close(id_1             integer,
                                                      fnayearperiods_1 char,
                                                      flag             out integer,
                                                      msg              out varchar2,
                                                      thecursor        IN OUT cursor_define.weavercursor) as
  count_1          integer;
  ledgerid_1       integer;
  departmentid_1   integer;
  costcenterid_1   integer;
  trandaccount_1   number(18, 3);
  trancaccount_1   number(18, 3);
  ledgerbalance_1  char;
  subledgercount_1 integer;
  tranremain_1     number(18, 3);
  tmptranperiods_1 char(6);
  tmplegderstr_1   varchar(30);
  budgetmoduleid_1 integer;
  budgetaccount_1  number(18, 3);
  budgetperiods_1  char(6);
  fnayear_1        char(4);
  theperiods_1     integer;
  tranremain_count integer;
  count_01         integer;
begin

  
  select count(id)
    into count_1
    from FnaYearsPeriodsList
   where fnayearperiodsid < fnayearperiods_1
     and isactive = '1'
     and isclose = '0';

  if count_1 <> 0 then
    open thecursor for
      select -1 from dual;
    return;
  end if;

  
  select count(id)
    into count_1
    from FnaTransaction
   where transtatus != '2'
     and tranperiods = fnayearperiods_1;

  if count_1 <> 0 then
    open thecursor for
      select -2 from dual;
    return;
  end if;

  
  select count(id)
    into count_1
    from FnaBudget
   where budgetstatus != '2'
     and budgetperiods = fnayearperiods_1;

  if count_1 <> 0 then
    open thecursor for
      select -2 from dual;
    return;
  end if;

  
  delete FnaAccount where tranperiods = fnayearperiods_1;
  delete FnaAccountDepartment where tranperiods = fnayearperiods_1;
  delete FnaAccountCostcenter where tranperiods = fnayearperiods_1;
  delete FnaBudgetDepartment where budgetperiods = fnayearperiods_1;
  delete FnaBudgetCostcenter where budgetperiods = fnayearperiods_1;

  
  for ledgerid_cursor in (select id from FnaLedger where subledgercount = 0) loop
    ledgerid_1     := ledgerid_cursor.id;
    trandaccount_1 := 0;
    trancaccount_1 := 0;
    tranremain_1   := 0;
  
    select count(id), max(tranperiods)
      into count_1, tmptranperiods_1
      from FnaAccount
     where ledgerid = ledgerid_1;
  
    if count_1 <> 0 then
    
      select count(tranremain)
        into tranremain_count
        from FnaAccount
       where ledgerid = ledgerid_1
         and tranperiods = tmptranperiods_1;
      if tranremain_count > 0 then
      
        select tranremain
          into tranremain_1
          from FnaAccount
         where ledgerid = ledgerid_1
           and tranperiods = tmptranperiods_1;
      
      end if;
    end if;
    select count(ledgerbalance)
      into count_01
      from FnaLedger
     where id = ledgerid_1;
    if count_01 > 0 then
    
      select ledgerbalance
        into ledgerbalance_1
        from FnaLedger
       where id = ledgerid_1;
    end if;
  
    select sum(tranaccount)
      into trandaccount_1
      from FnaAccountList
     where ledgerid = ledgerid_1
       and tranperiods = fnayearperiods_1
       and tranbalance = '1';
  
    select sum(tranaccount)
      into trancaccount_1
      from FnaAccountList
     where ledgerid = ledgerid_1
       and tranperiods = fnayearperiods_1
       and tranbalance = '2';
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    if tranremain_1 is null then
      tranremain_1 := 0;
    end if;
  
    if ledgerbalance_1 = '1' then
      tranremain_1 := tranremain_1 + trandaccount_1 - trancaccount_1;
    else
      tranremain_1 := tranremain_1 - trandaccount_1 + trancaccount_1;
    end if;
  
    insert into FnaAccount
      (ledgerid,
       tranperiods,
       trandaccount,
       trancaccount,
       tranremain,
       tranbalance)
    values
      (ledgerid_1,
       fnayearperiods_1,
       trandaccount_1,
       trancaccount_1,
       tranremain_1,
       ledgerbalance_1);
  end loop;

  

  for departmentid_cursor in (select ledgerid, trandepartmentid
                                from FnaTransaction       t,
                                     FnaTransactionDetail d
                               where t.id = d.tranid
                                 and tranperiods = fnayearperiods_1
                               group by ledgerid, trandepartmentid) loop
    ledgerid_1     := departmentid_cursor.ledgerid;
    departmentid_1 := departmentid_cursor.trandepartmentid;
    trandaccount_1 := 0;
    trancaccount_1 := 0;
    tranremain_1   := 0;
  
    select ledgerbalance
      into ledgerbalance_1
      from FnaLedger
     where id = ledgerid_1;
  
    select sum(trandefaccount)
      into trandaccount_1
      from FnaTransaction t, FnaTransactionDetail d
     where t.id = d.tranid
       and tranperiods = fnayearperiods_1
       and ledgerid = ledgerid_1
       and trandepartmentid = departmentid_1
       and tranbalance = '1';
  
    select sum(trandefaccount)
      into trancaccount_1
      from FnaTransaction t, FnaTransactionDetail d
     where t.id = d.tranid
       and tranperiods = fnayearperiods_1
       and ledgerid = ledgerid_1
       and trandepartmentid = departmentid_1
       and tranbalance = '2';
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    if ledgerbalance_1 = '1' then
      tranremain_1 := trandaccount_1 - trancaccount_1;
    else
      tranremain_1 := trancaccount_1 - trandaccount_1;
    end if;
  
    insert into FnaAccountDepartment
      (ledgerid, departmentid, tranperiods, tranaccount, tranbalance)
    values
      (ledgerid_1,
       departmentid_1,
       fnayearperiods_1,
       tranremain_1,
       ledgerbalance_1);
  end loop;

  

  for costcenterid_cursor in (select ledgerid, trancostercenterid
                                from FnaTransaction       t,
                                     FnaTransactionDetail d
                               where t.id = d.tranid
                                 and tranperiods = fnayearperiods_1
                               group by ledgerid, trancostercenterid) loop
    ledgerid_1     := costcenterid_cursor.ledgerid;
    costcenterid_1 := costcenterid_cursor.trancostercenterid;
    trandaccount_1 := 0;
    trancaccount_1 := 0;
    tranremain_1   := 0;
  
    select ledgerbalance
      into ledgerbalance_1
      from FnaLedger
     where id = ledgerid_1;
  
    select sum(trandefaccount)
      into trandaccount_1
      from FnaTransaction t, FnaTransactionDetail d
     where t.id = d.tranid
       and tranperiods = fnayearperiods_1
       and ledgerid = ledgerid_1
       and trancostercenterid = costcenterid_1
       and tranbalance = '1';
  
    select sum(trandefaccount)
      into trancaccount_1
      from FnaTransaction t, FnaTransactionDetail d
     where t.id = d.tranid
       and tranperiods = fnayearperiods_1
       and ledgerid = ledgerid_1
       and trancostercenterid = costcenterid_1
       and tranbalance = '2';
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    if ledgerbalance_1 = '1' then
      tranremain_1 := trandaccount_1 - trancaccount_1;
    else
      tranremain_1 := trancaccount_1 - trandaccount_1;
    end if;
  
    insert into FnaAccountCostcenter
      (ledgerid, costcenterid, tranperiods, tranaccount, tranbalance)
    values
      (ledgerid_1,
       costcenterid_1,
       fnayearperiods_1,
       tranremain_1,
       ledgerbalance_1);
  end loop;

  
  for departmentbudgetid_cursor in (select ledgerid,
                                           budgetdepartmentid,
                                           budgetmoduleid,
                                           sum(budgetaccount) as budgetaccount
                                      from FnaBudgetList
                                     where budgetperiods = fnayearperiods_1
                                     group by ledgerid,
                                              budgetmoduleid,
                                              budgetdepartmentid) loop
    ledgerid_1       := departmentbudgetid_cursor.ledgerid;
    departmentid_1   := departmentbudgetid_cursor.budgetdepartmentid;
    budgetmoduleid_1 := departmentbudgetid_cursor.budgetmoduleid;
    budgetaccount_1  := departmentbudgetid_cursor.budgetaccount;
  
    insert into FnaBudgetDepartment
      (ledgerid,
       departmentid,
       budgetmoduleid,
       budgetperiods,
       budgetaccount)
    values
      (ledgerid_1,
       departmentid_1,
       budgetmoduleid_1,
       fnayearperiods_1,
       budgetaccount_1);
  end loop;
  

  for costcenterbudgetid_cursor in (select ledgerid,
                                           budgetcostcenterid,
                                           budgetmoduleid,
                                           sum(budgetaccount) as budgetaccount
                                      from FnaBudgetList
                                     where budgetperiods = fnayearperiods_1
                                     group by ledgerid,
                                              budgetmoduleid,
                                              budgetcostcenterid) loop
    ledgerid_1       := costcenterbudgetid_cursor.ledgerid;
    costcenterid_1   := costcenterbudgetid_cursor.budgetcostcenterid;
    budgetmoduleid_1 := costcenterbudgetid_cursor.budgetmoduleid;
    budgetaccount_1  := costcenterbudgetid_cursor.budgetaccount;
  
    insert into FnaBudgetCostcenter
      (ledgerid,
       costcenterid,
       budgetmoduleid,
       budgetperiods,
       budgetaccount)
    values
      (ledgerid_1,
       costcenterid_1,
       budgetmoduleid_1,
       fnayearperiods_1,
       budgetaccount_1);
  end loop;

  
  for ledgeridsup_cursor in (select id
                               from FnaLedger
                              where subledgercount != 0) loop
    ledgerid_1     := ledgeridsup_cursor.id;
    trandaccount_1 := 0;
    trancaccount_1 := 0;
    tranremain_1   := 0;
    tmplegderstr_1 := concat(concat('%', TO_CHAR(ledgerid_1)), '|%');
  
    select count(id), max(tranperiods)
      into count_1, tmptranperiods_1
      from FnaAccount
     where ledgerid = ledgerid_1;
  
    if count_1 <> 0 then
      select tranremain
        into tranremain_1
        from FnaAccount
       where ledgerid = ledgerid_1
         and tranperiods = tmptranperiods_1;
    end if;
  
    select ledgerbalance
      into ledgerbalance_1
      from FnaLedger
     where id = ledgerid_1;
  
    select sum(a.trandaccount), sum(a.trancaccount)
      into trandaccount_1, trancaccount_1
      from FnaAccount a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and b.subledgercount = 0
       and a.tranperiods = fnayearperiods_1;
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    if tranremain_1 is null then
      tranremain_1 := 0;
    end if;
  
    if ledgerbalance_1 = '1' then
      tranremain_1 := tranremain_1 + trandaccount_1 - trancaccount_1;
    else
      tranremain_1 := tranremain_1 - trandaccount_1 + trancaccount_1;
    end if;
  
    insert into FnaAccount
      (ledgerid,
       tranperiods,
       trandaccount,
       trancaccount,
       tranremain,
       tranbalance)
    values
      (ledgerid_1,
       fnayearperiods_1,
       trandaccount_1,
       trancaccount_1,
       tranremain_1,
       ledgerbalance_1);
  end loop;

  

  for ledgerdepartment_cursor in (select a.id            as aid,
                                         b.id            as bid,
                                         a.ledgerbalance as ledgerbalance
                                    from FnaLedger a, HrmDepartment b
                                   where subledgercount != 0) loop
    ledgerid_1      := ledgerdepartment_cursor.aid;
    departmentid_1  := ledgerdepartment_cursor.bid;
    ledgerbalance_1 := ledgerdepartment_cursor.ledgerbalance;
  
    insert into TM_FnaYearsPeriodsListClose1
    values
      (ledgerid_1, departmentid_1, ledgerbalance_1);
  end loop;

  for ledgercostcenter_cursor in (select a.id            as aid,
                                         b.id            as bid,
                                         a.ledgerbalance as ledgerbalance
                                    from FnaLedger a, HrmCostcenter b
                                   where subledgercount != 0) loop
    ledgerid_1      := ledgercostcenter_cursor.aid;
    costcenterid_1  := ledgercostcenter_cursor.bid;
    ledgerbalance_1 := ledgercostcenter_cursor.ledgerbalance;
  
    insert into TM_FnaYearsPeriodsListClose2
    values
      (ledgerid_1, costcenterid_1, ledgerbalance_1);
  end loop;

  
  for departmentsupledger_cursor in (select *
                                       from TM_FnaYearsPeriodsListClose1) loop
    ledgerid_1      := departmentsupledger_cursor.ledgerid;
    departmentid_1  := departmentsupledger_cursor.departmentid;
    ledgerbalance_1 := departmentsupledger_cursor.ledgerbalance;
    trandaccount_1  := 0;
    trancaccount_1  := 0;
    tranremain_1    := 0;
    tmplegderstr_1  := concat(concat('%', TO_CHAR(ledgerid_1)), '|%');
  
    select sum(a.tranaccount)
      into trandaccount_1
      from FnaAccountDepartment a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.departmentid = departmentid
       and a.tranperiods = fnayearperiods_1
       and a.tranbalance = ledgerbalance_1;
  
    select sum(a.tranaccount)
      into trancaccount_1
      from FnaAccountDepartment a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.departmentid = departmentid
       and a.tranperiods = fnayearperiods_1
       and a.tranbalance != ledgerbalance_1;
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    tranremain_1 := trandaccount_1 - trancaccount_1;
  
    if tranremain_1 <> 0 then
      insert into FnaAccountDepartment
        (ledgerid, departmentid, tranperiods, tranaccount, tranbalance)
      values
        (ledgerid_1,
         departmentid_1,
         fnayearperiods_1,
         tranremain_1,
         ledgerbalance_1);
    end if;
  end loop;

  
  for costcentersupledger_cursor in (select *
                                       from TM_FnaYearsPeriodsListClose2) loop
    ledgerid_1      := costcentersupledger_cursor.ledgerid;
    costcenterid_1  := costcentersupledger_cursor.costcenterid;
    ledgerbalance_1 := costcentersupledger_cursor.ledgerbalance;
    trandaccount_1  := 0;
    trancaccount_1  := 0;
    tranremain_1    := 0;
    tmplegderstr_1  := concat(concat('%', TO_CHAR(ledgerid_1)), '|%');
  
    select sum(a.tranaccount)
      into trandaccount_1
      from FnaAccountCostcenter a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.costcenterid = costcenterid_1
       and a.tranperiods = fnayearperiods_1
       and a.tranbalance = ledgerbalance_1;
  
    select sum(a.tranaccount)
      into trancaccount_1
      from FnaAccountCostcenter a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.costcenterid = costcenterid_1
       and a.tranperiods = fnayearperiods_1
       and a.tranbalance != ledgerbalance_1;
  
    if trandaccount_1 is null then
      trandaccount_1 := 0;
    end if;
  
    if trancaccount_1 is null then
      trancaccount_1 := 0;
    end if;
  
    tranremain_1 := trandaccount_1 - trancaccount_1;
  
    if tranremain_1 <> 0 then
      insert into FnaAccountCostcenter
        (ledgerid, costcenterid, tranperiods, tranaccount, tranbalance)
      values
        (ledgerid_1,
         costcenterid_1,
         fnayearperiods_1,
         tranremain_1,
         ledgerbalance_1);
    end if;
  end loop;

  

  fnayear_1    := substr(fnayearperiods_1, 1, 4);
  theperiods_1 := TO_NUMBER(substr(fnayearperiods_1, 1, 2));

  for budgetdepartmentmodule_cursor in (select a.id aid, b.id bid, c.id cid
                                          from FnaLedger       a,
                                               HrmDepartment   b,
                                               FnaBudgetModule c
                                         where subledgercount != 0
                                           and c.fnayear = fnayear_1
                                           and c.periodsidfrom <=
                                               theperiods_1
                                           and c.periodsidto >= theperiods_1) loop
    ledgerid_1       := budgetdepartmentmodule_cursor.aid;
    departmentid_1   := budgetdepartmentmodule_cursor.bid;
    budgetmoduleid_1 := budgetdepartmentmodule_cursor.cid;
  
    insert into TM_FnaYearsPeriodsListClose3
    values
      (ledgerid_1, departmentid_1, budgetmoduleid_1);
  end loop;

  for budgetcostcentermodule_cursor in (select a.id aid, b.id bid, c.id cid
                                          from FnaLedger       a,
                                               HrmCostcenter   b,
                                               FnaBudgetModule c
                                         where subledgercount != 0
                                           and c.fnayear = fnayear_1
                                           and c.periodsidfrom <=
                                               theperiods_1
                                           and c.periodsidto >= theperiods_1) loop
    ledgerid_1       := budgetcostcentermodule_cursor.aid;
    costcenterid_1   := budgetcostcentermodule_cursor.bid;
    budgetmoduleid_1 := budgetcostcentermodule_cursor.cid;
  
    insert into TM_FnaYearsPeriodsListClose4
    values
      (ledgerid_1, costcenterid_1, budgetmoduleid_1);
  end loop;

  
  for departmentsupledgerbudget in (select *
                                      from TM_FnaYearsPeriodsListClose3) loop
    ledgerid_1       := departmentsupledgerbudget.ledgerid;
    departmentid_1   := departmentsupledgerbudget.departmentid;
    budgetmoduleid_1 := departmentsupledgerbudget.budgetmoduleid;
  
    budgetaccount_1 := 0;
    tmplegderstr_1  := concat(concat('%', TO_CHAR(ledgerid_1)), '|%');
  
    select sum(budgetaccount)
      into budgetaccount_1
      from FnaBudgetList a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.budgetdepartmentid = departmentid_1
       and a.budgetperiods = fnayearperiods_1
       and a.budgetmoduleid = budgetmoduleid_1;
  
    if budgetaccount_1 <> 0 then
      insert into FnaBudgetDepartment
        (ledgerid,
         departmentid,
         budgetmoduleid,
         budgetperiods,
         budgetaccount)
      values
        (ledgerid_1,
         departmentid_1,
         budgetmoduleid_1,
         budgetperiods_1,
         budgetaccount_1);
    end if;
  end loop;

  
  for costcentersupledgerbudget in (select *
                                      from TM_FnaYearsPeriodsListClose4) loop
    ledgerid_1       := costcentersupledgerbudget.ledgerid;
    costcenterid_1   := costcentersupledgerbudget.costcenterid;
    budgetmoduleid_1 := costcentersupledgerbudget.budgetmoduleid;
  
    budgetaccount_1 := 0;
    tmplegderstr_1  := concat(concat('%', TO_CHAR(ledgerid_1)), '|%');
  
    select sum(budgetaccount)
      into budgetaccount_1
      from FnaBudgetList a, FnaLedger b
     where a.ledgerid = b.id
       and b.supledgerall like tmplegderstr_1
       and a.budgetcostcenterid = costcenterid_1
       and a.budgetperiods = fnayearperiods_1
       and a.budgetmoduleid = budgetmoduleid_1;
  
    if budgetaccount_1 <> 0 then
      insert into FnaBudgetCostcenter
        (ledgerid,
         costcenterid,
         budgetmoduleid,
         budgetperiods,
         budgetaccount)
      values
        (ledgerid_1,
         costcenterid_1,
         budgetmoduleid_1,
         budgetperiods_1,
         budgetaccount_1);
    end if;
  end loop;

  
  update FnaTransaction
     set transtatus = '3'
   where tranperiods = fnayearperiods_1;

  
  update FnaBudget
     set budgetstatus = '3'
   where budgetperiods = fnayearperiods_1;

  
  UPDATE FnaYearsPeriodsList SET isclose = '1' WHERE (id = id_1);

end;
/
CREATE OR REPLACE PROCEDURE HrmDepartment_Insert(departmentmark_1 varchar2,
                                                 departmentname_2 varchar2,
                                                 supdepid_3       integer,
                                                 allsupdepid_4    varchar2,
                                                 subcompanyid1_5  integer,
                                                 showorder_6      integer,
                                                 coadjutant_7     integer,
                                                 flag             out integer,
                                                 msg              out varchar2,
                                                 thecursor        IN OUT cursor_define.weavercursor) AS
  count0 int;
  count1 int;
begin
  select count(*)
    into count0
    from HrmDepartment
   where subcompanyid1 = subcompanyid1_5
     and departmentmark = departmentmark_1
     and supdepid = supdepid_3;
  select count(*)
    into count1
    from HrmDepartment
   where subcompanyid1 = subcompanyid1_5
     and departmentname = departmentname_2
     and supdepid = supdepid_3;
  if count0 > 0 then
    flag := 2;
    msg  := '该部门简称已经存在，不能保存！';
    return;
  end if;
  if count1 > 0 then
    flag := 3;
    msg  := '该部门全称已经存在，不能保存！';
    return;
  end if;
  INSERT INTO HrmDepartment
    (departmentmark,
     departmentname,
     supdepid,
     allsupdepid,
     subcompanyid1,
     showorder,
     coadjutant)
  VALUES
    (departmentmark_1,
     departmentname_2,
     supdepid_3,
     allsupdepid_4,
     subcompanyid1_5,
     showorder_6,
     coadjutant_7);
  open thecursor for
    select (max(id)) from HrmDepartment;
end;
/
CREATE OR REPLACE PROCEDURE HrmDepartment_Update(id_1             integer,
                                                 departmentmark_2 varchar2,
                                                 departmentname_3 varchar2,
                                                 supdepid_4       integer,
                                                 allsupdepid_5    varchar2,
                                                 subcompanyid1_6  integer,
                                                 showorder_7      integer,
                                                 coadjutant_8     integer,
                                                 flag             out integer,
                                                 msg              out varchar2,
                                                 thecursor        IN OUT cursor_define.weavercursor) AS
  count0 int;
  count1 int;
begin
  select count(*)
    into count0
    from HrmDepartment
   where subcompanyid1 = subcompanyid1_6
     and departmentmark = departmentmark_2
     and id != id_1
     and supdepid = supdepid_4;
  select count(*)
    into count1
    from HrmDepartment
   where subcompanyid1 = subcompanyid1_6
     and departmentname = departmentname_3
     and id != id_1
     and supdepid = supdepid_4;
  if count0 > 0 then
    flag := 2;
    msg  := '该部门简称已经存在，不能保存！';
    return;
  end if;
  if count1 > 0 then
    flag := 3;
    msg  := '该部门全称已经存在，不能保存！';
    return;
  end if;
  UPDATE HrmDepartment
     SET departmentmark = departmentmark_2,
         departmentname = departmentname_3,
         supdepid       = supdepid_4,
         allsupdepid    = allsupdepid_5,
         subcompanyid1  = subcompanyid1_6,
         showorder      = showorder_7,
         coadjutant     = coadjutant_8
   WHERE (id = id_1);
end;
/
create or replace procedure HrmResourceShare(resourceid_1      integer,
                                             departmentid_1    integer,
                                             subcompanyid_1    integer,
                                             managerid_1       integer,
                                             seclevel_1        integer,
                                             managerstr_1      varchar2,
                                             olddepartmentid_1 integer,
                                             oldsubcompanyid_1 integer,
                                             oldmanagerid_1    integer,
                                             oldseclevel_1     integer,
                                             oldmanagerstr_1   varchar2,
                                             flag_1            integer,
                                             flag              out integer,
                                             msg               out varchar2,
                                             thecursor         IN OUT cursor_define.weavercursor) AS
  supresourceid_1        integer;
  docid_1                integer;
  crmid_1                integer;
  prjid_1                integer;
  cptid_1                integer;
  sharelevel_1           integer;
  countrec               integer;
  managerstr_11          varchar2(4000);
  mainid_1               integer;
  subid_1                integer;
  secid_1                integer;
  members_1              varchar2(4000);
  contractid_1           integer;
  contractroleid_1       integer;
  sharelevel_Temp        integer;
  workPlanId_1           integer;
  m_countworkid          integer;
  docid_2                integer;
  sharelevel_2           integer;
  countrec_2             integer;
  managerId_2s_2         varchar2(4000);
  sepindex_2             integer;
  managerId_2            varchar2(4000);
  tempDownOwnerId_2      integer;
  oldsubcompanyid_1_this integer;
begin
  if oldsubcompanyid_1 is null then
    oldsubcompanyid_1_this := 0;
  else
    oldsubcompanyid_1_this := oldsubcompanyid_1;
  end if;
  if (seclevel_1 <> oldseclevel_1) then
    update HrmResource_Trigger
       set seclevel = seclevel_1
     where id = resourceid_1;
  end if;
  if (departmentid_1 <> olddepartmentid_1) then
    update HrmResource_Trigger
       set departmentid = departmentid_1
     where id = resourceid_1;
  end if;
  if (managerstr_1 <> oldmanagerstr_1) then
    update HrmResource_Trigger
       set managerstr = managerstr_1
     where id = resourceid_1;
  end if;
  if (subcompanyid_1 <> oldsubcompanyid_1_this) then
    update HrmResource_Trigger
       set subcompanyid1 = subcompanyid_1
     where id = resourceid_1;
  end if;

  if ((flag_1 = 1 and (departmentid_1 <> olddepartmentid_1 or
     oldsubcompanyid_1_this <> subcompanyid_1 or
     seclevel_1 <> oldseclevel_1)) or flag_1 = 0) then
  
    managerstr_11 := Concat('%,', Concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select id
                                   from CRM_Contract
                                  where (manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))) loop
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 3);
      end if;
    end loop;
  
    for contractid_cursor in (select id
                                from CRM_Contract
                               where manager = resourceid_1) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 2);
    end loop;
  
    for roleids_cursor in (select roleid
                             from SystemRightRoles
                            where rightid = 396) loop
      for rolecontractid_cursor in (select distinct t1.id
                                      from CRM_Contract   t1,
                                           hrmrolemembers t2
                                     where t2.roleid = contractroleid_1
                                       and t2.resourceid = resourceid_1
                                       and (t2.rolelevel = 2 or
                                           (t2.rolelevel = 0 and
                                           t1.department = departmentid_1) or
                                           (t2.rolelevel = 1 and
                                           t1.subcompanyid1 =
                                           subcompanyid_1))) loop
        contractid_1 := rolecontractid_cursor.id;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract values (contractid_1, 2);
        else
          select sharelevel
            into sharelevel_1
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if sharelevel_1 = 1 then
            update ContractShareDetail
               set sharelevel = 2
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
          end if;
        end if;
      end loop;
    end loop;
  
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from Contract_ShareInfo t2
                                    where ((t2.foralluser = 1 and
                                          t2.seclevel <= seclevel_1) or
                                          (t2.userid = resourceid_1) or
                                          (t2.departmentid = departmentid_1 and
                                          t2.seclevel <= seclevel_1))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
  
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from CRM_Contract       t1,
                                          Contract_ShareInfo t2,
                                          HrmRoleMembers     t3
                                    where t1.id = t2.relateditemid
                                      and t3.resourceid = resourceid_1
                                      and t3.roleid = t2.roleid
                                      and t3.rolelevel >= t2.rolelevel
                                      and t2.seclevel <= seclevel_1
                                      and ((t2.rolelevel = 0 and
                                          t1.department = departmentid_1) or
                                          (t2.rolelevel = 1 and
                                          t1.subcompanyid1 =
                                          subcompanyid_1) or
                                          (t3.rolelevel = 2))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
  
    managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select t2.id
                                   from CRM_CustomerInfo t1, CRM_Contract t2
                                  where (t1.manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))
                                    and (t2.crmId = t1.id)) loop
      contractid_1 := subcontractid_cursor.id;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 1);
      end if;
    end loop;
  
    for contractid_cursor in (select t2.id
                                from CRM_CustomerInfo t1, CRM_Contract t2
                               where (t1.manager = resourceid_1)
                                 and (t2.crmId = t1.id)) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 1);
    end loop;
  
    delete from ContractShareDetail
     where userid = resourceid_1
       and usertype = 1;
  
    for allcontractid_cursor in (select * from temptablevaluecontract) loop
      contractid_1 := allcontractid_cursor.contractid;
      sharelevel_1 := allcontractid_cursor.sharelevel;
      insert into ContractShareDetail
        (contractid, userid, usertype, sharelevel)
      values
        (contractid_1, resourceid_1, 1, sharelevel_1);
    end loop;
  
    for creater_cursor in (SELECT id
                             FROM WorkPlan
                            WHERE createrid = resourceid_1) loop
      workPlanId_1 := creater_cursor.id;
      INSERT INTO TmpTableValueWP
        (workPlanId, shareLevel)
      VALUES
        (workPlanId_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for underling_cursor in (SELECT id
                               FROM WorkPlan
                              WHERE (createrid IN
                                    (SELECT DISTINCT id
                                        FROM HrmResource_Trigger
                                       WHERE concat(',', MANAGERSTR) LIKE
                                             managerstr_11))) loop
      workPlanId_1 := underling_cursor.id;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP
          (workPlanId, shareLevel)
        VALUES
          (workPlanId_1, 1);
      end if;
    end loop;
  
  end if;

  if (flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and
     length(managerstr_1) > 1) then
  
    managerId_2 := concat(',', managerstr_1);
    update shareinnerdoc
       set content = managerid_1
     where srcfrom = 81
       and opuser = resourceid_1;
  
    for supuserid_cursor in (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1, CRM_Contract t2
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 3);
      end if;
    end loop;
  
    for supuserid_cursor in (select distinct t1.id id_1, t3.id id_2
                               from HrmResource_Trigger t1,
                                    CRM_CustomerInfo    t2,
                                    CRM_Contract        t3
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1
                                and t2.id = t3.crmId) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 1);
      end if;
    end loop;
  
  end if;
end;
/
CREATE or REPLACE PROCEDURE HrmRightCardInfo_Insert(resourceid_2 integer, 
                                                    carddate_3   char, 
                                                    cardtime_4   char, 
                                                    inorout_5    integer, 
                                                    flag         out integer,
                                                    msg          out varchar2,
                                                    thecursor    IN OUT cursor_define.weavercursor) AS

  cardcount number;
  reccount  integer;

begin

  select count(id)
    into cardcount
    from HrmRightCardInfo
   where carddate = carddate_3
     and resourceid = resourceid_2
     and cardtime = cardtime_4;
  if cardcount = 0 then
    
    INSERT INTO HrmRightCardInfo
      (resourceid, carddate, cardtime, inorout, islegal, workout)
    VALUES
      (resourceid_2, carddate_3, cardtime_4, inorout_5, 0, 0);
  end if;
end;
/
CREATE OR REPLACE procedure HrmRSRPath_SeByURId(userid_1   integer,
                                                rightstr_1 varchar2,
                                                flag       out integer,
                                                msg        out varchar2,
                                                thecursor  IN OUT cursor_define.weavercursor) AS
  tempsubid integer;
  CURSOR c1 is
    select id from temp_HrmRSRPath_02;
begin
  insert into temp_HrmRSRPath_01
    (subcompanyid, rightlevel)
    select subcompanyid, min(rightlevel)
      from SysRoleSubcomRight
     where roleid in
           (select a.roleid
              from HrmRoleMembers a, SystemRightRoles b
             where a.roleid = b.roleid
               and a.resourceid = userid_1
               and b.rightid = (select rightid
                                  from SystemRightDetail
                                 where rightdetail = rightstr_1))
     group by subcompanyid;

  insert into temp_HrmRSRPath_02
    (id)
    select b.subcompanyid
      from hrmsubcompany a, temp_HrmRSRPath_01 b
     where a.id = b.subcompanyid
       and a.supsubcomid != 0
       and a.supsubcomid not in
           (select subcompanyid from temp_HrmRSRPath_01);

  open c1;
  fetch c1
    into tempsubid;
  while c1%found loop
    insert into temp_HrmRSRPath_03
      (id)
      select id
        from table(cast(getSubComParentTree(tempsubid) as tab_tree));
    fetch c1
      into tempsubid;
  end loop;
  close c1;

  open thecursor for
    select subcompanyid, rightlevel
      from temp_HrmRSRPath_01
    union
    select distinct (id) as subcompanyid, -1 as rightlevel
      from temp_HrmRSRPath_03
     where id is not null;

end;
/

CREATE or REPLACE PROCEDURE HrmSearchMould_Update(id_1                  integer,
                                                  userid_2              integer,
                                                  resourceid_3          integer,
                                                  resourcename_4        varchar2,
                                                  jobtitle_5            integer,
                                                  activitydesc_6        varchar2,
                                                  jobgroup_7            integer,
                                                  jobactivity_8         integer,
                                                  costcenter_9          integer,
                                                  competency_10         integer,
                                                  resourcetype_11       char,
                                                  status_12             char,
                                                  subcompany1_13        integer,
                                                  department_14         varchar2,
                                                  location_15           integer,
                                                  manager_16            integer,
                                                  assistant_17          integer,
                                                  roles_18              integer,
                                                  seclevel_19           smallint,
                                                  joblevel_20           smallint,
                                                  workroom_21           varchar2,
                                                  telephone_22          varchar2,
                                                  startdate_23          char,
                                                  enddate_24            char,
                                                  contractdate_25       char,
                                                  birthday_26           char,
                                                  sex_27                char,
                                                  seclevelTo_28         smallint,
                                                  joblevelTo_29         smallint,
                                                  startdateTo_30        char,
                                                  enddateTo_31          char,
                                                  contractdateTo_32     char,
                                                  birthdayTo_33         char,
                                                  age_34                integer,
                                                  ageTo_35              integer,
                                                  resourceidfrom_36     integer,
                                                  resourceidto_37       integer,
                                                  workcode_38           varchar2,
                                                  jobcall_39            integer,
                                                  mobile_40             varchar2,
                                                  mobilecall_41         varchar2,
                                                  fax_42                varchar2,
                                                  email_43              varchar2,
                                                  folk_44               varchar2,
                                                  nativeplace_45        varchar2,
                                                  regresidentplace_46   varchar2,
                                                  maritalstatus_47      char,
                                                  certificatenum_48     varchar2,
                                                  tempresidentnumber_49 varchar2,
                                                  residentplace_50      varchar2,
                                                  homeaddress_51        varchar2,
                                                  healthinfo_52         char,
                                                  heightfrom_53         integer,
                                                  heightto_54           integer,
                                                  weightfrom_55         integer,
                                                  weightto_56           integer,
                                                  educationlevel_57     char,
                                                  degree_58             varchar2,
                                                  usekind_59            integer,
                                                  policy_60             varchar2,
                                                  bememberdatefrom_61   char,
                                                  bememberdateto_62     char,
                                                  bepartydatefrom_63    char,
                                                  bepartydateto_64      char,
                                                  islabouunion_65       char,
                                                  bankid1_66            integer,
                                                  accountid1_67         varchar2,
                                                  accumfundaccount_68   varchar2,
                                                  loginid_69            varchar2,
                                                  systemlanguage_70     integer,
                                                  birthdayyear_71       integer,
                                                  birthdaymonth_72      integer,
                                                  birthdayday_73        integer,
                                                  educationlevelto_74   integer,
                                                  accounttype_75        integer,
                                                  flag                  out integer,
                                                  msg                   out varchar2,
                                                  thecursor             IN OUT cursor_define.weavercursor)

 AS
begin
  UPDATE HrmSearchMould
     SET userid             = userid_2,
         resourceid         = resourceid_3,
         resourcename       = resourcename_4,
         jobtitle           = jobtitle_5,
         activitydesc       = activitydesc_6,
         jobgroup           = jobgroup_7,
         jobactivity        = jobactivity_8,
         costcenter         = costcenter_9,
         competency         = competency_10,
         resourcetype       = resourcetype_11,
         status             = status_12,
         subcompany1        = subcompany1_13,
         department         = department_14,
         location           = location_15,
         manager            = manager_16,
         assistant          = assistant_17,
         roles              = roles_18,
         seclevel           = seclevel_19,
         joblevel           = joblevel_20,
         workroom           = workroom_21,
         telephone          = telephone_22,
         startdate          = startdate_23,
         enddate            = enddate_24,
         contractdate       = contractdate_25,
         birthday           = birthday_26,
         sex                = sex_27,
         seclevelTo         = seclevelTo_28,
         joblevelTo         = joblevelTo_29,
         startdateTo        = startdateTo_30,
         enddateTo          = enddateTo_31,
         contractdateTo     = contractdateTo_32,
         birthdayTo         = birthdayTo_33,
         age                = age_34,
         ageTo              = ageTo_35,
         resourceidfrom     = resourceidfrom_36,
         resourceidto       = resourceidto_37,
         workcode           = workcode_38,
         jobcall            = jobcall_39,
         mobile             = mobile_40,
         mobilecall         = mobilecall_41,
         fax                = fax_42,
         email              = email_43,
         folk               = folk_44,
         nativeplace        = nativeplace_45,
         regresidentplace   = regresidentplace_46,
         maritalstatus      = maritalstatus_47,
         certificatenum     = certificatenum_48,
         tempresidentnumber = tempresidentnumber_49,
         residentplace      = residentplace_50,
         homeaddress        = homeaddress_51,
         healthinfo         = healthinfo_52,
         heightfrom         = heightfrom_53,
         heightto           = heightto_54,
         weightfrom         = weightfrom_55,
         weightto           = weightto_56,
         educationlevel     = educationlevel_57,
         degree             = degree_58,
         usekind            = usekind_59,
         policy             = policy_60,
         bememberdatefrom   = bememberdatefrom_61,
         bememberdateto     = bememberdateto_62,
         bepartydatefrom    = bepartydatefrom_63,
         bepartydateto      = bepartydateto_64,
         islabouunion       = islabouunion_65,
         bankid1            = bankid1_66,
         accountid1         = accountid1_67,
         accumfundaccount   = accumfundaccount_68,
         loginid            = loginid_69,
         systemlanguage     = systemlanguage_70,
         birthdayyear       = birthdayyear_71,
         birthdaymonth      = birthdaymonth_72,
         birthdayday        = birthdayday_73,
         educationlevelto   = educationlevelto_74,
         accounttype        = accounttype_75
  
   WHERE (id = id_1);
end;
/
CREATE OR REPLACE PROCEDURE HrmSubCompany_Update(id_1             integer,
                                                 subcompanyname_2 varchar2,
                                                 subcompanydesc_3 varchar2,
                                                 companyid_4      smallint,
                                                 supsubcomid_5    integer,
                                                 url_6            varchar2,
                                                 showorder_7      integer,
                                                 flag             out integer,
                                                 msg              out varchar2,
                                                 thecursor        IN OUT cursor_define.weavercursor) AS
  count0 integer;
  count1 integer;
begin
  select count(*)
    into count0
    from HrmSubCompany
   where subcompanyname = subcompanyname_2
     and id != id_1
     and supsubcomid = supsubcomid_5;
  select count(*)
    into count1
    from HrmSubCompany
   where subcompanydesc = subcompanydesc_3
     and id != id_1
     and supsubcomid = supsubcomid_5;
  if count0 > 0 then
    flag := 2;
    msg  := '该分部简称已经存在，不能保存！';
    return;
  end if;
  if count1 > 0 then
    flag := 3;
    msg  := '该分部全称已经存在，不能保存！';
    return;
  end if;
  UPDATE HrmSubCompany
     SET subcompanyname = subcompanyname_2,
         subcompanydesc = subcompanydesc_3,
         companyid      = companyid_4,
         supsubcomid    = supsubcomid_5,
         url            = url_6,
         showorder      = showorder_7
   WHERE (id = id_1);
end;
/
CREATE or replace PROCEDURE LeftMenuInfo_DeleteById(id_1      integer,
                                                    flag      out integer,
                                                    msg       out varchar2,
                                                    thecursor IN OUT cursor_define.weavercursor) AS
  menuLevel_1    integer;
  updateId_2     integer;
  updateIndex_3  integer;
  defaultIndex_4 integer;
  parentId_5     integer;
begin
  SELECT menuLevel, parentId, defaultIndex
    into menuLevel_1, parentId_5, defaultIndex_4
    FROM LeftMenuInfo
   WHERE id = id_1;
  DELETE FROM LeftMenuInfo WHERE id = id_1;
  updateIndex_3 := defaultIndex_4;
  
  IF (menuLevel_1 = 1) then
    
    FOR leftMenuInfo_cursor in (SELECT id
                                  FROM LeftMenuInfo
                                 WHERE parentId IS NULL
                                   AND defaultIndex > defaultIndex_4
                                 ORDER BY defaultIndex) loop
      updateId_2 := leftMenuInfo_cursor.id;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex_3
       WHERE id = updateId_2;
      updateIndex_3 := updateIndex_3 + 1;
    END loop;
  ELSE
    
    FOR leftMenuInfo_cursor in (SELECT id
                                  FROM LeftMenuInfo
                                 WHERE parentId = parentId_5
                                   AND defaultIndex > defaultIndex_4
                                 ORDER BY defaultIndex) loop
      updateId_2 := leftMenuInfo_cursor.id;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex_3
       WHERE id = updateId_2;
      updateIndex_3 := updateIndex_3 + 1;
    END loop;
  END if;
end;
/
create or replace procedure LeftMenuInfo_Insert(id_1              integer,
                                                labelId_1         integer,
                                                iconUrl_1         varchar2,
                                                linkAddress_1     varchar2,
                                                menuLevel_1       integer,
                                                parentId_1        integer,
                                                defaultIndex_1    integer,
                                                useCustomName_1   varchar2,
                                                customName_1      varchar2,
                                                relatedModuleId_1 integer,
                                                isCustom_1        varchar2,
                                                flag              out integer,
                                                msg               out varchar2) AS

  updateId    integer;
  updateIndex integer;

  CURSOR leftMenuInfo_cursor1(c_defaultIndex_1 integer) is
    SELECT id
      FROM LeftMenuInfo
     WHERE parentId IS NULL
       AND defaultIndex >= c_defaultIndex_1
     ORDER BY defaultIndex;

  CURSOR leftMenuInfo_cursor2(c_parentId_1     integer,
                              c_defaultIndex_1 integer) is
    SELECT id
      FROM LeftMenuInfo
     WHERE parentId = c_parentId_1
       AND defaultIndex >= c_defaultIndex_1
     ORDER BY defaultIndex;

begin

  
  IF (menuLevel_1 = 1) THEN
  
    updateIndex := defaultIndex_1;
  
    
  
    OPEN leftMenuInfo_cursor1(defaultIndex_1);
  
    LOOP
    
      FETCH leftMenuInfo_cursor1
        INTO updateId;
    
      EXIT WHEN leftMenuInfo_cursor1%NOTFOUND;
    
      updateIndex := updateIndex + 1;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    
    END LOOP;
  
    CLOSE leftMenuInfo_cursor1;
  
    INSERT INTO LeftMenuInfo
      (id,
       labelId,
       iconUrl,
       linkAddress,
       menuLevel,
       parentId,
       defaultIndex,
       useCustomName,
       customName,
       relatedModuleId,
       isCustom)
    VALUES
      (id_1,
       labelId_1,
       NULL,
       NULL,
       menuLevel_1,
       NULL,
       defaultIndex_1,
       useCustomName_1,
       customName_1,
       relatedModuleId_1,
       isCustom_1);
  ELSE
  
    updateIndex := defaultIndex_1;
    
  
    OPEN leftMenuInfo_cursor2(parentId_1, defaultIndex_1);
    LOOP
    
      FETCH leftMenuInfo_cursor2
        INTO updateId;
      EXIT WHEN leftMenuInfo_cursor1%NOTFOUND;
    
      updateIndex := updateIndex + 1;
    
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    END LOOP;
  
    CLOSE leftMenuInfo_cursor2;
  
    INSERT INTO LeftMenuInfo
      (id,
       labelId,
       iconUrl,
       linkAddress,
       menuLevel,
       parentId,
       defaultIndex,
       useCustomName,
       customName,
       relatedModuleId,
       isCustom)
    VALUES
      (id_1,
       labelId_1,
       iconUrl_1,
       linkAddress_1,
       menuLevel_1,
       parentId_1,
       defaultIndex_1,
       useCustomName_1,
       customName_1,
       relatedModuleId_1,
       isCustom_1);
  END IF;

  flag := 1;
  msg  := 'ok';

end;
/
CREATE or replace PROCEDURE LeftMenuInfo_Update(id_1              integer,
                                                oldIndex_1        integer,
                                                labelId_1         integer,
                                                iconUrl_1         varchar2,
                                                linkAddress_1     varchar2,
                                                menuLevel_1       integer,
                                                parentId_1        integer,
                                                defaultIndex_1    integer,
                                                relatedModuleId_1 integer,
                                                flag              out integer,
                                                msg               out varchar2,
                                                thecursor         IN OUT cursor_define.weavercursor) AS
  updateId    integer;
  updateIndex integer;

begin
  
  IF (menuLevel_1 = 1) then
  
    
  
    IF (defaultIndex_1 < oldIndex_1) then
    
      updateIndex := defaultIndex_1;
    
      FOR leftMenuInfo_cursor in (SELECT id
                                    FROM LeftMenuInfo
                                   WHERE parentId IS NULL
                                     AND defaultIndex >= defaultIndex_1
                                     AND defaultIndex < oldIndex_1
                                   ORDER BY defaultIndex) loop
        updateId    := leftMenuInfo_cursor.id;
        updateIndex := updateIndex + 1;
        UPDATE LeftMenuInfo
           SET defaultIndex = updateIndex
         WHERE id = updateId;
      END loop;
      UPDATE LeftMenuInfo
         SET labelId         = labelId_1,
             defaultIndex    = defaultIndex_1,
             relatedModuleId = relatedModuleId_1
       WHERE id = id_1;
    END if;
  
    IF (defaultIndex_1 > oldIndex_1) then
    
      updateIndex := oldIndex_1;
      FOR leftMenuInfo_cursor in (SELECT id
                                    FROM LeftMenuInfo
                                   WHERE parentId IS NULL
                                     AND defaultIndex > oldIndex_1
                                     AND defaultIndex <= defaultIndex_1
                                   ORDER BY defaultIndex) loop
        updateId := leftMenuInfo_cursor.id;
        UPDATE LeftMenuInfo
           SET defaultIndex = updateIndex
         WHERE id = updateId;
        updateIndex := updateIndex + 1;
      END loop;
      UPDATE LeftMenuInfo
         SET labelId         = labelId_1,
             defaultIndex    = defaultIndex_1 - 1,
             relatedModuleId = relatedModuleId_1
       WHERE id = id_1;
    END if;
  ELSE
    
  
    IF (defaultIndex_1 < oldIndex_1) then
    
      updateIndex := defaultIndex_1;
    
      FOR leftMenuInfo_cursor in (SELECT id
                                    FROM LeftMenuInfo
                                   WHERE parentId = parentId_1
                                     AND defaultIndex >= defaultIndex_1
                                     AND defaultIndex < oldIndex_1
                                   ORDER BY defaultIndex) loop
        updateId    := leftMenuInfo_cursor.id;
        updateIndex := updateIndex + 1;
        UPDATE LeftMenuInfo
           SET defaultIndex = updateIndex
         WHERE id = updateId;
      END loop;
      UPDATE LeftMenuInfo
         SET labelId         = labelId_1,
             iconUrl         = iconUrl_1,
             linkAddress     = linkAddress_1,
             parentId        = parentId_1,
             defaultIndex    = defaultIndex_1,
             relatedModuleId = relatedModuleId_1
       WHERE id = id_1;
    END if;
    IF (defaultIndex_1 > oldIndex_1) then
    
      updateIndex := oldIndex_1;
    
      FOR leftMenuInfo_cursor in (SELECT id
                                    FROM LeftMenuInfo
                                   WHERE parentId = parentId_1
                                     AND defaultIndex > oldIndex_1
                                     AND defaultIndex <= defaultIndex_1
                                   ORDER BY defaultIndex) loop
        updateId := leftMenuInfo_cursor.id;
        UPDATE LeftMenuInfo
           SET defaultIndex = updateIndex
         WHERE id = updateId;
        updateIndex := updateIndex + 1;
      END loop;
      UPDATE LeftMenuInfo
         SET labelId         = labelId_1,
             iconUrl         = iconUrl_1,
             linkAddress     = linkAddress_1,
             parentId        = parentId_1,
             defaultIndex    = defaultIndex_1 - 1,
             relatedModuleId = relatedModuleId_1
       WHERE id = id_1;
    END if;
  END if;
end;
/
CREATE or replace PROCEDURE LMInfo_Insert(id_1              integer,
                                          labelId_1         integer,
                                          iconUrl_1         varchar2,
                                          linkAddress_1     varchar2,
                                          menuLevel_1       integer,
                                          parentId_1        integer,
                                          defaultIndex_1    integer,
                                          relatedModuleId_1 integer) AS
  updateId    integer;
  updateIndex integer;
begin
  
  IF (menuLevel_1 = 1) then
    updateIndex := defaultIndex_1;
    
    FOR leftMenuInfo_cursor in (SELECT id
                                  FROM LeftMenuInfo
                                 WHERE parentId IS NULL
                                   AND defaultIndex >= defaultIndex_1
                                 ORDER BY defaultIndex) loop
      updateId    := leftMenuInfo_cursor.id;
      updateIndex := updateIndex + 1;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    END loop;
    INSERT INTO LeftMenuInfo
      (id,
       labelId,
       iconUrl,
       linkAddress,
       menuLevel,
       parentId,
       defaultIndex,
       relatedModuleId)
    VALUES
      (id_1,
       labelId_1,
       NULL,
       NULL,
       menuLevel_1,
       NULL,
       defaultIndex_1,
       relatedModuleId_1);
  ELSE
    updateIndex := defaultIndex_1;
    
    FOR leftMenuInfo_cursor in (SELECT id
                                  FROM LeftMenuInfo
                                 WHERE parentId = parentId_1
                                   AND defaultIndex >= defaultIndex_1
                                 ORDER BY defaultIndex) loop
      updateId    := leftMenuInfo_cursor.id;
      updateIndex := updateIndex + 1;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    END loop;
    INSERT INTO LeftMenuInfo
      (id,
       labelId,
       iconUrl,
       linkAddress,
       menuLevel,
       parentId,
       defaultIndex,
       relatedModuleId)
    VALUES
      (id_1,
       labelId_1,
       iconUrl_1,
       linkAddress_1,
       menuLevel_1,
       parentId_1,
       defaultIndex_1,
       relatedModuleId_1);
  END if;
end;
/
CREATE or REPLACE PROCEDURE MailUser_Insert(mailgroupid_1 integer, 
                                            resourceid_1  integer, 
                                            flag          out integer,
                                            msg           out varchar2,
                                            thecursor     IN OUT cursor_define.weavercursor) as
begin
  INSERT into MailUser
    (mailgroupid, resourceid)
  VALUES
    (mailgroupid_1, resourceid_1);
end;
/
Create OR REPLACE PROCEDURE Workflow_RepDspFld_Insert_New(reportid_1        int,
                                                          dsporder_3        varchar2,
                                                          isstat_4          char,
                                                          dborder_5         char,
                                                          dbordertype_6     char,
                                                          compositororder_7 int,
                                                          fieldidbak_8      int,
                                                          flag              out int,
                                                          msg               out varchar2,
                                                          thecursor         IN OUT cursor_define.weavercursor) AS
BEGIN
  INSERT INTO Workflow_ReportDspField
    (reportid,
     dsporder,
     isstat,
     dborder,
     dbordertype,
     compositororder,
     fieldidbak)
  VALUES
    (reportid_1,
     dsporder_3,
     isstat_4,
     dborder_5,
     dbordertype_6,
     compositororder_7,
     fieldidbak_8);
end;
/
create or replace PROCEDURE WORKFLOW_REQUESTLOG_ProTemp as
begin
  update WORKFLOW_REQUESTLOG set LOGID = rownum;
end;

/
CREATE or REPLACE PROCEDURE workflow_RequestLog_Select(requestid1 integer,
                                                       flag       out integer,
                                                       msg        out varchar2,
                                                       thecursor  IN OUT cursor_define.weavercursor) AS
begin
  open thecursor for
    SELECT t1.*, t2.nodename
      from workflow_requestlog t1, workflow_nodebase t2
     where t1.requestid = requestid1
       and t1.nodeid = t2.id
     order by operatedate desc, operatetime desc;
end;
/
CREATE OR REPLACE PROCEDURE workflow_RequestLog_SNSave(requestid1 integer,
                                                       flag       out integer,
                                                       msg        out varchar2,
                                                       thecursor  IN OUT cursor_define.weavercursor) AS
begin
  open thecursor for
    select t1.*, t2.nodename
      from workflow_requestlog t1, workflow_nodebase t2
     where t1.requestid = requestid1
       and t1.nodeid = t2.id
       and t1.logtype != '1'
     order by operatedate desc, operatetime desc;
end;
/
CREATE OR REPLACE PROCEDURE workflow_RequestLog_SNSRemark(requestid1 integer,
                                                          flag       out integer,
                                                          msg        out varchar2,
                                                          thecursor  IN OUT cursor_define.weavercursor) AS
begin
  open thecursor for
    select t1.*, t2.nodename
      from workflow_requestlog t1, workflow_nodebase t2
     where t1.requestid = requestid1
       and t1.nodeid = t2.id
       and t1.logtype != '1'
       and t1.logtype != '7'
     order by operatedate desc, operatetime desc;
end;
/
CREATE or REPLACE PROCEDURE workflow_requeststatus_Select(userid_1     integer,
                                                          requestid_1  integer,
                                                          workflowid_1 integer,
                                                          flag         out integer,
                                                          msg          out varchar2,
                                                          thecursor    IN OUT cursor_define.weavercursor) AS
  mcount         integer;
  viewnodeidstmp varchar2(4000);
  viewnodeids    varchar2(4000);
begin
  select count(*)
    into mcount
    from workflow_monitor_bound
   where monitorhrmid = userid_1
     and workflowid = workflowid_1;

  if mcount > 0 then
    open thecursor for
      select a.nodeid,
             b.nodename,
             a.userid,
             a.isremark,
             a.usertype,
             a.agentorbyagentid,
             a.agenttype,
             a.receivedate,
             a.receivetime,
             a.operatedate,
             a.operatetime,
             a.viewtype
        from (SELECT distinct requestid,
                              userid,
                              workflow_currentoperator.workflowid,
                              workflowtype,
                              isremark,
                              usertype,
                              workflow_currentoperator.nodeid,
                              agentorbyagentid,
                              agenttype
                              
                             ,
                              receivedate,
                              receivetime,
                              viewtype,
                              iscomplete
                              
                             ,
                              operatedate,
                              operatetime,
                              nodetype
                FROM workflow_currentoperator, workflow_flownode
               where workflow_currentoperator.nodeid =
                     workflow_flownode.nodeid
                 and requestid = requestid_1) a,
             workflow_nodebase b
       where a.nodeid = b.id
         and a.requestid = requestid_1
         and a.agenttype <> 1
       order by a.receivedate, a.receivetime, a.nodetype;
  
  else
  
    viewnodeids := '';
    for c1 in (select b.viewnodeids
                 from (SELECT distinct requestid,
                                       userid,
                                       workflow_currentoperator.workflowid,
                                       workflowtype,
                                       isremark,
                                       usertype,
                                       workflow_currentoperator.nodeid,
                                       agentorbyagentid,
                                       agenttype
                                       
                                      ,
                                       receivedate,
                                       receivetime,
                                       viewtype,
                                       iscomplete
                                       
                                      ,
                                       operatedate,
                                       operatetime,
                                       nodetype
                         FROM workflow_currentoperator, workflow_flownode
                        where workflow_currentoperator.nodeid =
                              workflow_flownode.nodeid
                          and requestid = requestid_1) a,
                      workflow_flownode b
                where a.workflowid = b.workflowid
                  and a.nodeid = b.nodeid
                  and a.requestid = requestid_1
                  and a.userid = userid_1
                  and a.usertype = 0) loop
      viewnodeidstmp := c1.viewnodeids;
      if viewnodeidstmp = '-1' then
        viewnodeids := '-1';
        exit;
      else
        viewnodeids := CONCAT(viewnodeids, viewnodeidstmp);
      end if;
    end loop;
  
    if viewnodeids = '-1' then
      open thecursor for
        select a.nodeid,
               b.nodename,
               a.userid,
               a.isremark,
               a.usertype,
               a.agentorbyagentid,
               a.agenttype,
               a.receivedate,
               a.receivetime,
               a.operatedate,
               a.operatetime,
               a.viewtype
          from (SELECT distinct requestid,
                                userid,
                                workflow_currentoperator.workflowid,
                                workflowtype,
                                isremark,
                                usertype,
                                workflow_currentoperator.nodeid,
                                agentorbyagentid,
                                agenttype
                                
                               ,
                                receivedate,
                                receivetime,
                                viewtype,
                                iscomplete
                                
                               ,
                                operatedate,
                                operatetime,
                                nodetype
                  FROM workflow_currentoperator, workflow_flownode
                 where workflow_currentoperator.nodeid =
                       workflow_flownode.nodeid
                   and requestid = requestid_1) a,
               workflow_nodebase b
         where a.nodeid = b.id
           and a.requestid = requestid_1
           and a.agenttype <> 1
         order by a.receivedate, a.receivetime, a.nodetype;
    else
      viewnodeids := trim(viewnodeids);
      if viewnodeids <> '' then
        viewnodeids := substr(viewnodeids, 1, length(viewnodeids) - 1);
        open thecursor for
          select a.nodeid,
                 b.nodename,
                 a.userid,
                 a.isremark,
                 a.usertype,
                 a.agentorbyagentid,
                 a.agenttype,
                 a.receivedate,
                 a.receivetime,
                 a.operatedate,
                 a.operatetime,
                 a.viewtype
            from (SELECT distinct requestid,
                                  userid,
                                  workflow_currentoperator.workflowid,
                                  workflowtype,
                                  isremark,
                                  usertype,
                                  workflow_currentoperator.nodeid,
                                  agentorbyagentid,
                                  agenttype
                                  
                                 ,
                                  receivedate,
                                  receivetime,
                                  viewtype,
                                  iscomplete
                                  
                                 ,
                                  operatedate,
                                  operatetime,
                                  nodetype
                    FROM workflow_currentoperator, workflow_flownode
                   where workflow_currentoperator.nodeid =
                         workflow_flownode.nodeid
                     and requestid = requestid_1) a,
                 workflow_nodebase b
           where a.nodeid = b.id
             and a.requestid = requestid_1
             and a.agenttype <> 1
           order by a.receivedate, a.receivetime, a.nodetype;
      end if;
    end if;
  end if;
end;
/


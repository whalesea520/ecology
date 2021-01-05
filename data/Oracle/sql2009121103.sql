alter table DocImageFile add hasUsedTemplet char(1) default '0'
/
update DocImageFile set hasUsedTemplet='0'
/

CREATE TABLE HrmOrgGroup (
	id integer  not null,
	orgGroupName varchar2(60) null ,
	orgGroupDesc varchar2(200) null ,
	showOrder number(6,2) null ,
	isDelete char(1)  default '0' null
)
/
create sequence HrmOrgGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmOrgGroup_Tri
before insert on HrmOrgGroup
for each row
begin
select HrmOrgGroup_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmOrgGroupRelated (
	id integer  not null,
	orgGroupId integer null ,
	type integer null ,
	content integer null ,
	secLevelFrom integer null ,
	secLevelTo integer null
)
/
create sequence HrmOrgGroupRelated_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmOrgGroupRelated_Tri
before insert on HrmOrgGroupRelated
for each row
begin
select HrmOrgGroupRelated_id.nextval into :new.id from dual;
end;
/

alter table DocSecCategoryShare add orgGroupId integer default 0
/
alter table DocShare add orgGroupId integer default 0
/
update DocSecCategoryShare set orgGroupId=0
/
update DocShare set orgGroupId=0
/

CREATE or REPLACE PROCEDURE DocSecCategoryShare_Ins_G (
secid_1	integer,
sharetype_2	integer,
seclevel_3	smallint, 
rolelevel_4	smallint, 
sharelevel_5	smallint, 
userid_6	integer, 
subcompanyid_7	integer, 
departmentid_8	integer, 
roleid_9	integer, 
foralluser_10	smallint, 
crmid_11 integer,  
orgGroupId_12 integer,
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into DocSecCategoryShare 
(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId )
values (secid_1,sharetype_2,seclevel_3,rolelevel_4,sharelevel_5,userid_6,subcompanyid_7,departmentid_8,roleid_9,foralluser_10,crmid_11,orgGroupId_12);
end;
/

CREATE or REPLACE PROCEDURE DocShare_IFromDocSecCat_G 
( 
	docid_1    integer,
	sharetype_2	integer,
	seclevel_3	smallint,
	rolelevel_4	smallint,
	sharelevel_5	smallint,
	userid_6	integer,
	subcompanyid_7	integer,
	departmentid_8	integer,
	roleid_9	integer,
	foralluser_10	smallint,
	crmid_11	integer,
	orgGroupId_12	integer,
	flag	out integer,
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor)
as 
begin 
	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,
    subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId)
    values( docid_1, sharetype_2, seclevel_3, rolelevel_4, sharelevel_5, 
    userid_6, subcompanyid_7, departmentid_8, roleid_9, foralluser_10, crmid_11, orgGroupId_12);

open thecursor for 
select max(id) from  DocShare;
end;
/

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
 sharecontent_1 varchar2(10);
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
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
BEGIN
    /*选删除相关数据*/
    DELETE ShareinnerDoc  WHERE  sourceid=docid_1;
    DELETE ShareouterDoc  WHERE  sourceid=docid_1;

    /*再插入相关数据*/
    for shareuserid_cursor in(select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource 
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

        isExistInner_1:=0;
        isExistOuter_1:=0;


        if sharetype_1=1  then /*人力资源*/ 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;
           
          elsif sharetype_1=2 then /*分部*/
          begin
                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;  
           
           elsif  sharetype_1=3 then/*部门*/
           begin
                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;  

           elsif  sharetype_1=6 then/*群组*/
           begin
                newsharetype_1 := 6;
                sharecontent_1 := orgGroupId_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 6;
                opuser_1 := orgGroupId_1;

                isExistInner_1 := 1;
           end; 
	   
           elsif sharetype_1=5  then/*所有人*/
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;
           
           elsif  sharetype_1=80 then /*创建人本身*/
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
                      
          elsif  sharetype_1=81  then/*创建人直接上级*/
          begin
              /*求上级*/
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
			   end	if;	   
		   end; 
           elsif  sharetype_1=84 then /*同分部*/
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
             elsif  sharetype_1=85 then /*同部门*/
              begin
                   
                  /*求部门*/
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
              
              elsif  sharetype_1=-81 then /*客户的经理*/
          begin
               newsharetype_1 := 1;    
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; /*求客户的经理*/
               seclevel_1 := 0;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end; 
       elsif  sharetype_1=9 then /*客户*/
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end; 

        elsif  sharetype_1=-80  then/*客户本人*/
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end; 
         elsif  sharetype_1<0 and sharetype_1>-80 then /*客户类型*/
          begin
               newsharetype_1 := 10;           
               sharecontent_1:=sharetype_1*-1;

               srcfrom_1 := 10;
               opuser_1 := sharetype_1;

               isExistOuter_1 := 1;
          end; 
		  elsif  sharetype_1=4  then/*角色 角色类型的处理比较特殊*/ 
          begin  
               newsharetype_1:=4;                                   
               /*seclevel_1:=0; */
               srcfrom_1:=4;
               opuser_1:=roleid_1;
               
               if newsharetype_1 is null then  newsharetype_1:=0; end if;
               if sharecontent_1 is null then  sharecontent_1:=0; end if;
               if seclevel_1 is null then  seclevel_1:=0;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;
               
               IF rolelevel_1=0 then /*表部门 总部,分部,部门能看*/
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );     
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
              END;
              elsIF rolelevel_1=1 then/*表分部 总部,分部能看*/                        
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              elsIF rolelevel_1=2 then/*表总部 总部能看*/
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              end if;
               isExistInner_1:=0;  /*不需要再在下面插入数据*/
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

                 /*插入数据*/                         
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

                 /*插入数据*/
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

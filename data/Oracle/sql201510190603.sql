CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermission(dirid_1         integer,
                                                       dirtype_1       integer,
                                                       userid_1        integer,
                                                       usertype_1      integer,
                                                       seclevel_1      integer,
                                                       operationcode_1 integer,
                                                       departmentid_1  varchar2,
                                                       subcompanyid_1  varchar2,
						       subcompanyidsub_1  varchar2,
						       departmentidsub_1  varchar2,
                                                       roleid_1        varchar2,
                                                       flag            out integer,
                                                       msg             out varchar2,
                                                       thecursor       IN OUT cursor_define.weavercursor) AS
  count_1   integer;
  result    integer;
  count_num integer;
begin
  result := 0;
  if usertype_1 = 0 then
    select count(sourceid)
      into count_num
      from DirAccessControlDetail
     where sourceid = dirid_1
       and sourcetype = dirtype_1
       and sharelevel = operationcode_1
       and ((type = 1 and includesub=0 and content in
           (select * from TABLE(CAST(SplitStr(departmentid_1, ',') AS mytable))) and 
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1 ) or 
	   (type = 1   and includesub=1 and content in
           (select * from TABLE(CAST(SplitStr(departmentidsub_1, ',') AS mytable))) and 
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1 ) or 
           (type = 2 and
           content in
           (select * from TABLE(CAST(SplitStr(roleid_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (type = 3 and seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (type = 4 and content = usertype_1 and seclevel <= seclevel_1) or
           (type = 5 and content = userid_1) or
           (type = 6 and includesub=0 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1 ) or
	   (type = 6 and includesub=1 and content in (select * from TABLE(CAST(SplitStr(subcompanyidsub_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1 ));
    if (count_num > 0) then
      count_1 := 1;
    else
      count_1 := 0;
    end if;
  else
    select count(mainid)
      into count_1
      from DirAccessControlList
     where dirid = dirid_1
       and dirtype = dirtype_1
       and operationcode = operationcode_1
       and ((permissiontype = 3 and seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (permissiontype = 4 and usertype = usertype_1 and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1));
  end if;
  if (count_1 > 0) then
    result := 1;
  end if;
  open thecursor for
    select result result from dual;
end;
/


CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionBE
(
dirid_1 integer,
dirtype_1 integer,
userid_1 varchar2,
usertype_1 integer,
seclevel_1 integer, 
operationcode_1 integer, 
departmentid_1 varchar2,
subcompanyid_1 varchar2,
subcompanyidsub_1  varchar2,
departmentidsub_1  varchar2,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
count_1 integer;
result integer;
count_num integer;
begin
result := 0;
if usertype_1 = 0 then

  select count (sourceid) into count_num  from DirAccessControlDetail where   sourceid = dirid_1  and  sourcetype=dirtype_1 and  sharelevel=operationcode_1 and ((type=1 and includesub=0 and content in (select * from TABLE(CAST(SplitStr(departmentid_1, ',')AS mytable))) and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or (type=1 and includesub=1 and content in (select * from TABLE(CAST(SplitStr(departmentidsub_1, ',')AS mytable))) and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or (type=3 and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or    (type=4 and content=usertype_1 and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or(type=5 and content in (select * from TABLE(CAST(SplitStr(userid_1, ',')AS mytable))) ) or (type=6 and includesub=0 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',')AS mytable))) and seclevel<=seclevel_1 and seclevelmax >=seclevel_1)  or (type=6 and includesub=1 and content in (select * from TABLE(CAST(SplitStr(subcompanyidsub_1, ',')AS mytable))) and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) );
        if(count_num >0) then
               count_1 := 1 ;
        else count_1 := 0 ;
        end if;    
else 
    select count(mainid) into count_1  from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1 and seclevelmax >=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1 and seclevelmax >=seclevel_1));
end if;
if (count_1 > 0)  then
     result := 1 ;
end if;
open thecursor for
select result result from dual;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx(dirid_1         integer,
                                                         dirtype_1       integer,
                                                         userid_1        integer,
                                                         usertype_1      integer,
                                                         seclevel_1      integer,
                                                         operationcode_1 integer,
                                                         departmentid_1  varchar2,
                                                         subcompanyid_1  varchar2,
							 subcompanyidsub_1  varchar2,
						         departmentidsub_1  varchar2,
                                                         roleid_1        varchar2,
                                                         flag            out integer,
                                                         msg             out varchar2,
                                                         thecursor       IN OUT cursor_define.weavercursor) AS
  result_1    integer;
  mainid_1    integer;
  fatherid_1  integer;
  fatherid1_1 integer;
begin
  Doc_DirAcl_CheckPermissionEx1(dirid_1,
                                dirtype_1,
                                userid_1,
                                usertype_1,
                                seclevel_1,
                                operationcode_1,
                                departmentid_1,
                                subcompanyid_1,
				subcompanyidsub_1,
                                departmentidsub_1,
                                roleid_1,
                                result_1);
  if result_1 <> 1 then
    if dirtype_1 = 1 then
      select subcategoryid
        into fatherid_1
        from DocSubCategory
       where id = dirid_1;
    elsif dirtype_1 = 2 then
      select subcategoryid
        into fatherid_1
        from DocSecCategory
       where id = dirid_1;
      if fatherid_1 is null then
        fatherid_1 := -1;
      end if;
      if fatherid_1 = 0 then
        fatherid_1 := -1;
      end if;
    else
      fatherid_1 := -1;
    end if;
    if dirtype_1 = 1 then
      select maincategoryid
        into mainid_1
        from DocSubCategory
       where id = dirid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    0,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
				    subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
    elsif dirtype_1 = 2 and fatherid_1 <> -1 then
      select maincategoryid
        into mainid_1
        from DocSubCategory
       where id = fatherid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    0,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
				    subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
      while fatherid_1 <> -1 loop
        Doc_DirAcl_CheckPermissionEx1(fatherid_1,
                                      1,
                                      userid_1,
                                      usertype_1,
                                      seclevel_1,
                                      operationcode_1,
                                      departmentid_1,
                                      subcompanyid_1,
				      subcompanyidsub_1,
                                      departmentidsub_1,
                                      roleid_1,
                                      result_1);
        if result_1 <> 1 then
          select subcategoryid
            into fatherid1_1
            from DocSubCategory
           where id = fatherid_1;
          fatherid_1 := fatherid1_1;
        else
          fatherid_1 := -1;
        end if;
      end loop;
    end if;
  end if;
  open thecursor for
    select result_1 result from dual;
end;
/


CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1(dirid_1         integer,
                                                          dirtype_1       integer,
                                                          userid_1        integer,
                                                          usertype_1      integer,
                                                          seclevel_1      integer,
                                                          operationcode_1 integer,
                                                          departmentid_1  varchar2,
                                                          subcompanyid_1  varchar2,
							  subcompanyidsub_1  varchar2,
						          departmentidsub_1  varchar2,
                                                          roleid_1        varchar2,
                                                          haspermission_1 in out integer) AS
  count_1 integer;
  result  integer;
begin
  result := 0;
  if usertype_1 = 0 then
    select count(sourceid)
      into count_1
      from DirAccessControlDetail
     where sharelevel = operationcode_1
       and sourceid = dirid_1
       and sourcetype = dirtype_1
       and ((type = 1  and includesub=0 and content in (select * from TABLE(CAST(SplitStr(departmentid_1, ',') AS mytable)))  and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or 
	   (type = 1  and includesub=1 and content in (select * from TABLE(CAST(SplitStr(departmentidsub_1, ',') AS mytable)))  and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or 
           (type = 2 and
           content in
           (select * from TABLE(CAST(SplitStr(roleid_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (type = 3 and seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (type = 4 and content = usertype_1 and seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (type = 5 and content = userid_1) or
           (type = 6 and includesub=0 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or 
	   (type = 6 and includesub=1 and content in (select * from TABLE(CAST(SplitStr(subcompanyidsub_1, ',') AS mytable))) and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1) );
  else
    select count(mainid)
      into count_1
      from DirAccessControlList
     where dirid = dirid_1
       and dirtype = dirtype_1
       and operationcode = operationcode_1
       and ((permissiontype = 3 and seclevel <= seclevel_1 and seclevelmax >=seclevel_1) or
           (permissiontype = 4 and usertype = usertype_1 and
           seclevel <= seclevel_1 and seclevelmax >=seclevel_1));
  end if;
  if count_1 is not null and count_1 > 0 then
    result := 1;
  end if;
  haspermission_1 := result;
end;
/


CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx2(dirid_1         integer,
                                                          dirtype_1       integer,
                                                          userid_1        integer,
                                                          usertype_1      integer,
                                                          seclevel_1      integer,
                                                          operationcode_1 integer,
                                                          departmentid_1  varchar2,
                                                          subcompanyid_1  varchar2,
							  subcompanyidsub_1  varchar2,
						          departmentidsub_1  varchar2,
                                                          roleid_1        varchar2,
                                                          flag            out integer,
                                                          msg             out varchar2,
                                                          thecursor       IN OUT cursor_define.weavercursor) AS
  result_1    integer;
  mainid_1    integer;
  fatherid_1  integer;
  fatherid1_1 integer;
begin
  Doc_DirAcl_CheckPermissionEx1(dirid_1,
                                dirtype_1,
                                userid_1,
                                usertype_1,
                                seclevel_1,
                                operationcode_1,
                                departmentid_1,
                                subcompanyid_1,
				subcompanyidsub_1,
                                departmentidsub_1,
                                roleid_1,
                                result_1);
  if result_1 <> 1 then
    if dirtype_1 = 1 then
      select parentid
        into fatherid_1
        from DocSecCategory
       where id = dirid_1;
    elsif dirtype_1 = 2 then
      select parentid
        into fatherid_1
        from DocSecCategory
       where id = dirid_1;
      if fatherid_1 is null then
        fatherid_1 := -1;
      end if;
      if fatherid_1 = 0 then
        fatherid_1 := -1;
      end if;
    else
      fatherid_1 := -1;
    end if;
    if dirtype_1 = 1 then
      select parentid into mainid_1 from DocSecCategory where id = dirid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    2,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
				    subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
    elsif dirtype_1 = 2 and fatherid_1 <> -1 then
      select parentid
        into mainid_1
        from DocSecCategory
       where id = fatherid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    2,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
				    subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
      while fatherid_1 <> -1 loop
        Doc_DirAcl_CheckPermissionEx1(fatherid_1,
                                      2,
                                      userid_1,
                                      usertype_1,
                                      seclevel_1,
                                      operationcode_1,
                                      departmentid_1,
                                      subcompanyid_1,
				      subcompanyidsub_1,
                                      departmentidsub_1,
                                      roleid_1,
                                      result_1);
        if result_1 <> 1 then
          select parentid
            into fatherid1_1
            from DocSecCategory
           where id = fatherid_1;
          fatherid_1 := fatherid1_1;
          if fatherid_1 is null then
            fatherid_1 := -1;
          end if;
          if fatherid_1 = 0 then
            fatherid_1 := -1;
          end if;
        else
          fatherid_1 := -1;
        end if;
      end loop;
    end if;
  end if;
  open thecursor for
    select result_1 result from dual;
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
 seclevelmax_1 integer;
 allmanagers_1 integer;
 orgid_1 integer;
 includesub_1 integer;

 sharesource_1 integer;

 isExistInner_1 integer;
 isExistOuter_1 integer;
  isSysadmin_1 integer;
  hasmanager_1  integer;
  hasmanagervir_1  integer;
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
 downloadlevel_1 integer;
BEGIN
    /*选删除相关数据*/
    DELETE ShareinnerDoc  WHERE  sourceid=docid_1;
    DELETE ShareouterDoc  WHERE  sourceid=docid_1;

    /*再插入相关数据*/
    for shareuserid_cursor in(select docid,sharetype,seclevel,seclevelmax,allmanagers,orgid,includesub,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel 
    from docshare where docid=docid_1 and docid>0)
    loop
        sharetype_1 := shareuserid_cursor.sharetype;
        seclevel_1 := shareuserid_cursor.seclevel;
        seclevelmax_1 := shareuserid_cursor.seclevelmax;
        allmanagers_1 := shareuserid_cursor.allmanagers;
        orgid_1 := shareuserid_cursor.orgid;
        includesub_1 := shareuserid_cursor.includesub;
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
        sharecontent_1:=0;
      if downloadlevel_1 is null then
            downloadlevel_1 := 0;
      end if;
      if allmanagers_1 is null then
            allmanagers_1 := 0;
      end if;
      if includesub_1 is null then
            includesub_1 := 0;
      end if;
      if orgid_1 is null then
            orgid_1 := 0;
      end if;

        if sharetype_1=1  then /*人力资源*/ 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
    seclevelmax_1 := 255;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;
           
          elsif sharetype_1=2 then /*分部*/
          begin

                if includesub_1=1 then
	       
                  sharesource_1 := 2;
                end if;


                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
     seclevelmax_1 := seclevelmax_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;  
           
           elsif  sharetype_1=3 then/*部门*/
           begin

                if includesub_1=1 then
	       
                  sharesource_1 := 2;
                end if;


                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1; 
                seclevel_1 := seclevel_1;
     seclevelmax_1 := seclevelmax_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;  

           elsif  sharetype_1=6 then/*群组*/
           begin
                newsharetype_1 := 6;
                sharecontent_1 := orgGroupId_1; 
                seclevel_1 := seclevel_1;
    seclevelmax_1 := seclevelmax_1;
                srcfrom_1 := 6;
                opuser_1 := orgGroupId_1;

                isExistInner_1 := 1;
           end; 
     
           elsif sharetype_1=5  then/*所有人*/
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
    seclevelmax_1 := seclevelmax_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;
           
           elsif  sharetype_1=80 then /*创建人本身*/
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
     seclevelmax_1 := 255;
                srcfrom_1 := 80;
                opuser_1 := userid_1;
                isExistInner_1 := 1;

        select count(id) into count_1  from docdetail where id = docid_1;
        if count_1 >0 then
        select  ownerid into ownerid_1 from docdetail where id = docid_1;
        select doccreaterid into createrid_1 from docdetail where id = docid_1;
        end if;
        if (ownerid_1 != createrid_1) then
           insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
           values(docid_1,1,ownerid_1,0,255,sharelevel_1,86,0,0, downloadlevel_1); 
        end if; 
           end; 
                      
          elsif  sharetype_1=81  then/*创建人直接上级*/
          begin
              /*求上级*/
        select  count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
        select count(*)  into hasmanager_1  from hrmresource a,hrmresource b     where a.id=b.managerid and b.id= userid_1;
        select count(*)  into hasmanagervir_1  from HrmResourceVirtual a,HrmResourceVirtual b     where a.resourceid=b.managerid and b.resourceid= userid_1;
        if  orgid_1= 0
        then 
        if (isSysadmin_1 !=1 and hasmanager_1 = 1 and allmanagers_1=0)  
        then                
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          seclevelmax_1 := 255;
          srcfrom_1 := 81;
          opuser_1 := userid_1;

          isExistInner_1 := 1;
         end  if;
         
       if (isSysadmin_1 !=1 and hasmanager_1 = 1 and allmanagers_1=1 )  
        then                
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerstr into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          seclevelmax_1 := 255;
          srcfrom_1 := 81;
          opuser_1 := userid_1;
          insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
          select docid_1,1,column_value,0,255,sharelevel_1,81,opuser_1,column_value,downloadlevel_1 from TABLE(CAST(SplitStr(sharecontent_1, ',') AS mytable));
          isExistInner_1 := 0;
         end if; 
                    
       elsif  orgid_1<0
        then 
        if (isSysadmin_1 !=1 and allmanagers_1=0 and hasmanagervir_1=1 )  
        then                
          newsharetype_1 :=1;
          SELECT   count(managerid)  into count_2 FROM HrmResourceVirtual where resourceid = userid_1 and virtualtype=orgid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResourceVirtual where resourceid = userid_1 and virtualtype=orgid_1;
          
          seclevel_1 := 0;
          seclevelmax_1 := 255;
          srcfrom_1 := 81;
          opuser_1 := userid_1;
         insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel)
         values(docid_1,1,sharecontent_1,0,255,sharelevel_1,81,opuser_1,sharecontent_1,downloadlevel_1);
          isExistInner_1 := 0;
          end if;
         end if; 
         
         if (isSysadmin_1 !=1 and allmanagers_1=1 and hasmanagervir_1=1 )  
        then                
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM  HrmResourceVirtual where resourceid = userid_1 and virtualtype=orgid_1;
          if count_2 >=1 then
            SELECT  managerstr into sharecontent_1 FROM  HrmResourceVirtual where resourceid = userid_1 and virtualtype=orgid_1;
        
          seclevel_1 := 0;
          seclevelmax_1 := 255;
          srcfrom_1 := 81;
          opuser_1 := userid_1;
          insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
          select docid_1,1,column_value,0,255,seclevel_1,81,opuser_1,column_value,downloadlevel_1 from TABLE(CAST(SplitStr(sharecontent_1, ',') AS mytable));
          isExistInner_1 := 0;
          end if;
         end if; 

    
             
       end if;
       
       end; 
           elsif  sharetype_1=84 then /*同分部*/
              begin
           
           select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1; 
             if orgid_1=0 then                  
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
        seclevelmax_1 := seclevelmax_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                  end if;
              elsif orgid_1<0 then
              
               if (isSysadmin_1!=1)   
                  then 
                  newsharetype_1 := 2;
                  SELECT  count(subcompanyid) into count_4  FROM HrmResourceVirtual  where resourceid=userid_1 and virtualtype=orgid_1;
                if count_4 >=1 then                            
                  select  subcompanyid into sharecontent_1 FROM  HrmResourceVirtual where resourceid=userid_1 and virtualtype=orgid_1;
                
                    seclevel_1 := seclevel_1;
                    seclevelmax_1 := seclevelmax_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                     end if;
                  end if;

              end if;

        end; 
             elsif  sharetype_1=85 then /*同部门*/
              begin
                   
                  /*求部门*/
          select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
            if orgid_1=0 then
                  if (isSysadmin_1 != 1)   
                  then 
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResource where id=userid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM HrmResource where id=userid_1;
                   end if;
                 seclevel_1 := seclevel_1;
           seclevelmax_1 := seclevelmax_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                  end if;
             elsif orgid_1<0 then

              if (isSysadmin_1 != 1)   
                  then 
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResourceVirtual where resourceid=userid_1 and virtualtype=orgid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM  HrmResourceVirtual where resourceid=userid_1 and virtualtype=orgid_1;
                  
                 seclevel_1 := seclevel_1;
                 seclevelmax_1 := seclevelmax_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                   end if;
                  end if;

           end if;

        end;  
              
              elsif  sharetype_1=-81 then /*客户的经理*/
          begin
               newsharetype_1 := 1;    
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; /*求客户的经理*/
               seclevel_1 := 0;
          seclevelmax_1 := 255;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end; 
       elsif  sharetype_1=9 then /*客户*/
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
         seclevelmax_1 := 255;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end; 

        elsif  sharetype_1=-80  then/*客户本人*/
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
         seclevelmax_1 := 255;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end; 
         elsif  sharetype_1<0  then /*客户类型*/
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
          if seclevelmax_1 is null then  seclevelmax_1:=255;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;
               
               IF rolelevel_1=0 then /*表部门 总部,分部,部门能看*/
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );     
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
              END;
              elsIF rolelevel_1=1 then/*表分部 总部,分部能看*/                        
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
              END;
              elsIF rolelevel_1=2 then/*表总部 总部能看*/
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
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
      if seclevelmax_1 is null then  seclevelmax_1:=255; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                  if sharesource_1 is null then  sharesource_1:=0; end if ;

                 /*插入数据*/                         
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);             
             END; 
             End if;

             IF  isExistOuter_1=1  then
             BEGIN                 
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
      if seclevelmax_1 is null then  seclevelmax_1:=255; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                 if sharesource_1 is null then  sharesource_1:=0; end if ;

                 /*插入数据*/
                 insert into ShareouterDoc(sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,seclevelmax_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);
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



create or replace trigger Tri_I_DirAccessControlList
  after insert ON DirAccessControlList
  for each row
declare
     id_1    integer;
  dirid_1         integer;
  dirtype_1      integer;
  seclevel_1     integer;
  seclevelmax_1     integer;
  includesub_1     integer;
  subcompanyid_1      integer;
    departmentid_1      integer;
  userid_1            integer;
  usertype_1        integer;
  rolelevel_1         integer;
  roleid_1             integer;
  permissiontype_1  integer;
  operationcode_1 integer;
 docSecCategoryTemplateId_1 integer;
 sourceid_1           integer;
 type_1        integer;
 content_1        integer;
 sharelevel_1          integer;
 sourcetype_1        integer;
 srcfrom_1           integer;
begin
        id_1:=:new.mainid;
        dirid_1:=:new.dirid;
        dirtype_1:=:new.dirtype;
        seclevel_1:=:new.seclevel;
	seclevelmax_1:=:new.seclevelmax;
	includesub_1:=:new.includesub;
        userid_1:=:new.userid;
        subcompanyid_1:=:new.subcompanyid;
        departmentid_1:=:new.departmentid;
        usertype_1:=:new.usertype;
        roleid_1:=:new.roleid;
        rolelevel_1:=:new.rolelevel;
        operationcode_1:=:new.operationcode;
        permissiontype_1:=:new.permissiontype;
        docSecCategoryTemplateId_1:=:new.DocSecCategoryTemplateId;
        sourceid_1:=dirid_1;
        sourcetype_1:=dirtype_1;
        srcfrom_1:=id_1;

        type_1:=permissiontype_1;
        sharelevel_1:=operationcode_1;
        if permissiontype_1=1 then  
          content_1:=departmentid_1;
        end if;
        if  permissiontype_1=2  then 
          content_1:=  to_number(to_char(roleid_1) || to_char(rolelevel_1));
        end if;
        if  permissiontype_1=3  then 
  begin
          seclevel_1:=seclevel_1;
	  seclevelmax_1:=seclevelmax_1;
    content_1:=0;
    end;
        end if;
        if  permissiontype_1=4  then 
          content_1:=usertype_1;
        end if;
        if  permissiontype_1=5  then 
          begin
          content_1:=userid_1;
          seclevel_1:=0;
	   seclevelmax_1:=255;
          end;
        end if;
        if  permissiontype_1=6  then  
          content_1:=subcompanyid_1;
        end if;
         insert into DirAccessControlDetail
        (
          sourceid,
          type,
          content,
          seclevel,
	  seclevelmax,
          sharelevel,
          sourcetype,
          srcfrom,
	  includesub
         )values(
          sourceid_1,
          type_1,
          content_1,
          seclevel_1,
	  seclevelmax_1,
          sharelevel_1,
          sourcetype_1,
          srcfrom_1,
	  includesub_1
         );
         if rolelevel_1=0 then 
           begin
               content_1:=  to_number(to_char(roleid_1) || to_char(1));
                insert into DirAccessControlDetail
                (
                  sourceid,
                  type,
                  content,
                  seclevel,
                   seclevelmax,
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
		   seclevelmax_1,
                  sharelevel_1,
                  sourcetype_1,
                  srcfrom_1
                 );
                 content_1:=  to_number(to_char(roleid_1) || to_char(2));
                insert into DirAccessControlDetail
                (
                  sourceid,
                  type,
                  content,
                  seclevel,
		  seclevelmax,
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
		   seclevelmax_1,
                  sharelevel_1,
                  sourcetype_1,
                  srcfrom_1
                 );
           end;
         end if;
           if rolelevel_1=1 then 
           begin
               content_1:=  to_number(to_char(roleid_1) || to_char(2));
                insert into DirAccessControlDetail
                (
                  sourceid,
                  type,
                  content,
                  seclevel,
		    seclevelmax,
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
		   seclevelmax_1,
                  sharelevel_1,
                  sourcetype_1,
                  srcfrom_1
                 );
           end;
         end if;
end;
/
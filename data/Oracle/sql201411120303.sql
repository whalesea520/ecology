CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx2(dirid_1         integer,
                                                         dirtype_1       integer,
                                                         userid_1        integer,
                                                         usertype_1      integer,
                                                         seclevel_1      integer,
                                                         operationcode_1 integer,
                                                         departmentid_1  integer,
                                                         subcompanyid_1  integer,
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
      select parentid
        into mainid_1
        from DocSecCategory
       where id = dirid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    2,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
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
                                      roleid_1,
                                      result_1);
        if result_1 <> 1 then
          select parentid
            into fatherid1_1
            from DocSecCategory
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

create or replace procedure Doc_GetPermittedCategory_New
(
userid_1 integer,
usertype_1 integer, 
seclevel_1 integer,
operationcode_1 integer,
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,  
categoryname_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
secdirid_1 integer;
secdirname_1 varchar2(200);
subdirid_1 integer;
subdirid1_1 integer;
superdirid_1 integer;
superdirtype_1 integer;
maindirid_1 integer;
subdirname_1 varchar2(200);
count_1 integer;
orderid_1 float;
begin
if usertype_1 = 0 then
	if categoryname_1 = '' then
		for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))))        
		loop
		    secdirid_1 := secdir_cursor.mainid;
		    secdirname_1 := secdir_cursor.categoryname;
		    subdirid_1 := secdir_cursor.subcategoryid;
		    orderid_1 :=secdir_cursor.secorder;
		    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
		 end loop;
	else
		for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where categoryname like '%'||categoryname_1||'%' and  id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))))        
		loop
		    secdirid_1 := secdir_cursor.mainid;
		    secdirname_1 := secdir_cursor.categoryname;
		    subdirid_1 := secdir_cursor.subcategoryid;
		    orderid_1 :=secdir_cursor.secorder;
		    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
		end loop;
	end if;
else 
	if categoryname_1 = '' then
	    for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))))    
		loop
		    secdirid_1 := secdir_cursor.mainid;
		    secdirname_1 := secdir_cursor.categoryname;
		    subdirid_1 := secdir_cursor.subcategoryid;
		    orderid_1 := secdir_cursor.secorder;
		    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
		end loop;  
	else
		for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where categoryname like '%'||categoryname_1||'%' and   id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))))    
		loop
		    secdirid_1 := secdir_cursor.mainid;
		    secdirname_1 := secdir_cursor.categoryname;
		    subdirid_1 := secdir_cursor.subcategoryid;
		    orderid_1 := secdir_cursor.secorder;
		    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
		end loop;  
	end if;
end if;
open thecursor for 
select * from temp_4 order by orderid,categoryid ;
end;
/

CREATE OR REPLACE PROCEDURE Doc_SecCategory_Insert_New
  (  subcategoryid   integer,
     categoryname   varchar2,
     docmouldid   integer,
     publishable   char,
     replyable   char,
     shareable   char ,
     cusertype   integer,
     cuserseclevel   smallint,
     cdepartmentid1   integer,
     cdepseclevel1   smallint,
     cdepartmentid2   integer,
     cdepseclevel2   smallint,
     croleid1       integer,
     crolelevel1     char ,
     croleid2     integer,
     crolelevel2   char ,
     croleid3     integer,
     crolelevel3   char ,
     hasaccessory     char ,
     accessorynum     smallint,
     hasasset       char ,
     assetlabel     varchar2 ,
     hasitems     char ,
     itemlabel   varchar2 ,
     hashrmres   char ,
     hrmreslabel   varchar2 ,
     hascrm     char ,
     crmlabel     varchar2 ,
     hasproject   char ,
     projectlabel   varchar2 ,
     hasfinance   char ,
     financelabel   varchar2 ,
     approveworkflowid  integer,
     markable  char ,
     markAnonymity char ,
     orderable char ,
     defaultLockedDoc integer,
     allownModiMShareL integer,
     allownModiMShareW integer,
     maxUploadFileSize integer,
     wordmouldid integer,
     isSetShare integer,
     noDownload integer,
     noRepeatedName integer,
     isControledByDir integer,
     pubOperation integer,
     childDocReadRemind integer,
     readOpterCanPrint integer,
     isLogControl char ,
     subcompanyId integer,
     level_1 integer,
     parentid integer,
     secorder float,
     flag   out integer,
     msg  out varchar2,
     thecursor IN OUT cursor_define.weavercursor) as
 dirid integer;
 dirtype integer;
 begin
    if  level_1=1 then
      dirtype := 0;
      insert into DocMainCategory(categoryname,categoryiconid,categoryorder,coder,norepeatedname,subcompanyid) values( categoryname,0, secorder,0, noRepeatedName, subcompanyId);
      select MAX(id) into dirid from DocMainCategory  where categoryname= categoryname;
    else
      if  level_1=2  then
         dirtype := 1;
        insert into DocSubCategory(categoryname,maincategoryid,subcategoryid,suborder,norepeatedname) values( categoryname,(select dirid from DocSecCategory where id= parentid),-1, secorder, noRepeatedName);
          select MAX(id) into dirid from DocSubCategory where categoryname= categoryname;
      end if;
    end if;

  insert into docseccategory(
    subcategoryid,
    categoryname,
    docmouldid,
    publishable,
    replyable,
    shareable,
    cusertype,
    cuserseclevel,
    cdepartmentid1,
    cdepseclevel1,
    cdepartmentid2,
    cdepseclevel2,
    croleid1,
    crolelevel1,
    croleid2,
    crolelevel2,
    croleid3,
    crolelevel3,
    hasaccessory,
    accessorynum,
    hasasset,
    assetlabel,
    hasitems,
    itemlabel,
    hashrmres,
    hrmreslabel,
    hascrm,
    crmlabel,
    hasproject,
    projectlabel,
    hasfinance,
    financelabel,
    approveworkflowid,
    markable,
    markAnonymity,
    orderable,
    defaultLockedDoc,
    allownModiMShareL,
    allownModiMShareW,
    maxUploadFileSize,
    wordmouldid,
    isSetShare,
    nodownload,
    norepeatedname,
    iscontroledbydir,
    puboperation,
    childdocreadremind,
    readoptercanprint,
    isLogControl,
    subcompanyId,
    parentid,
    dirid,
    dirType
    )
  values(
     subcategoryid,
     categoryname,
     docmouldid,
     publishable,
     replyable,
     shareable,
     cusertype,
     cuserseclevel,
     cdepartmentid1,
     cdepseclevel1,
     cdepartmentid2,
     cdepseclevel2,
     croleid1,
     crolelevel1,
     croleid2,
     crolelevel2,
     croleid3,
     crolelevel3,
     hasaccessory,
     accessorynum,
     hasasset,
     assetlabel,
     hasitems,
     itemlabel,
     hashrmres,
     hrmreslabel,
     hascrm,
     crmlabel,
     hasproject,
     projectlabel,
     hasfinance,
     financelabel,
     approveworkflowid,
     markable,
     markAnonymity,
     orderable,
     defaultLockedDoc,
     allownModiMShareL,
     allownModiMShareW,
     maxUploadFileSize,
     wordmouldid,
     isSetShare,
     noDownload,
     noRepeatedName,
     isControledByDir,
     pubOperation,
     childDocReadRemind,
     readOpterCanPrint,
     isLogControl,
     subcompanyId,
     parentid,
     dirid,
     dirtype
    ) ;
  open thecursor for
  select max(id) from docseccategory where categoryname =  categoryname;

  end;
/
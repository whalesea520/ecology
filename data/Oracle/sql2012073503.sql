CREATE OR REPLACE PROCEDURE IDirAccessControlDetailP as
  id_1    integer;
  dirid_1         integer;
  dirtype_1      integer;
  seclevel_1     integer;
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
    DELETE DirAccessControlDetail; 
    for shareuserid_cursor in (select mainid,dirid,
                                    dirtype,
                                    seclevel,
                                    userid,
                                    subcompanyid,
                                    departmentid,
                                    usertype,
                                    roleid,
                                    rolelevel,
                                    operationcode,
                                    permissiontype,
            DocSecCategoryTemplateId
                               from DirAccessControlList
                              where dirtype >0
          and dirid >0 ) loop
        id_1:=shareuserid_cursor.mainid;
        dirid_1:=shareuserid_cursor.dirid;
        dirtype_1:=shareuserid_cursor.dirtype;
        seclevel_1:=shareuserid_cursor.seclevel;
        userid_1:=shareuserid_cursor.userid;
        subcompanyid_1:=shareuserid_cursor.subcompanyid;
        departmentid_1:=shareuserid_cursor.departmentid;
        usertype_1:=shareuserid_cursor.usertype;
        roleid_1:=shareuserid_cursor.roleid;
        rolelevel_1:=shareuserid_cursor.rolelevel;
        operationcode_1:=shareuserid_cursor.operationcode;
        permissiontype_1:=shareuserid_cursor.permissiontype;
        docSecCategoryTemplateId_1:=shareuserid_cursor.DocSecCategoryTemplateId;
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
           content_1:=0;
           seclevel_1:=seclevel_1;
          end;
        end if;
        if  permissiontype_1=4  then 
          content_1:=usertype_1;
        end if;
        if  permissiontype_1=5  then 
          begin
          content_1:=userid_1;
          seclevel_1:=0;
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
          sharelevel,
          sourcetype,
          srcfrom
         )values(
          sourceid_1,
          type_1,
          content_1,
          seclevel_1,
          sharelevel_1,
          sourcetype_1,
          srcfrom_1
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
                  sharelevel,
                  sourcetype,
                  srcfrom

                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
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
                  sharelevel,
                  sourcetype,
                  srcfrom

                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
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
                  sharelevel,
                  sourcetype,
                  srcfrom

                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
                  sharelevel_1,
                  sourcetype_1,
                  srcfrom_1
                 );
           end;
         end if;
      end loop;
end;
/
call IDirAccessControlDetailP()
/
create or replace trigger Tri_I_DirAccessControlList
  after insert ON DirAccessControlList
  for each row
declare
     id_1    integer;
  dirid_1         integer;
  dirtype_1      integer;
  seclevel_1     integer;
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
          sharelevel,
          sourcetype,
          srcfrom
         )values(
          sourceid_1,
          type_1,
          content_1,
          seclevel_1,
          sharelevel_1,
          sourcetype_1,
          srcfrom_1
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
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
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
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
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
                  sharelevel,
                  sourcetype,
                  srcfrom
                 )values(
                  sourceid_1,
                  type_1,
                  content_1,
                  seclevel_1,
                  sharelevel_1,
                  sourcetype_1,
                  srcfrom_1
                 );
           end;
         end if;
end;
/
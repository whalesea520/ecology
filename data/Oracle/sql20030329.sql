  CREATE or replace PROCEDURE LgcAsset_Insert 
  (
assetmark_1 	varchar2, 
barcode_2 	varchar2,
seclevel_3 	smallint,
assetimageid_4 	integer, 
assettypeid_5 	integer,
assetunitid_6 	integer,
replaceassetid_7 	integer,
assetversion_8 	varchar2,
assetattribute_9 	varchar2, 
counttypeid_10 	integer, 
assortmentid_11 	integer,
assortmentstr_12 	varchar2,
relatewfid_1    integer,
assetname_2 	varchar2,
assetcountyid_3 	integer, 
startdate_4 	char,
enddate_5 	char,
departmentid_6 	integer,
resourceid_7 	integer,
assetremark_8 	varchar2,
currencyid_9 	integer, 
salesprice_10  in out	varchar2, 
costprice_11 	 in out       varchar2,
datefield1_12 	char, 
datefield2_13 	char,
datefield3_14 	char, 
datefield4_15 	char, 
datefield5_16 	char, 
numberfield1_17 	float,
numberfield2_18 	float,
numberfield3_19 	float, 
numberfield4_20 	float, 
numberfield5_21 	float, 
textfield1_22 	varchar2,
textfield2_23 	varchar2,
textfield3_24 	varchar2,
textfield4_25 	varchar2,
textfield5_26 	varchar2, 
tinyintfield1_27 	char,
tinyintfield2_28 	char, 
tinyintfield3_29 	char,
tinyintfield4_30 	char,
tinyintfield5_31 	char, 
createrid_32 	integer, 
createdate_33 	char,
 flag	out		integer,
 msg out		varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 

  count_1 integer;
  assetid_1 integer;
 begin
 
 salesprice_10 := to_number(salesprice_10) ;
 costprice_11 := to_number(costprice_11); 
 
  /*
  begin  select count = count(*) from LgcAsset where assetmark = assetmark_1 if count <> 0 begin select -1 return end  end
  */
  INSERT INTO LgcAsset 
  ( assetmark,
  barcode, 
  seclevel, 
  assetimageid,
  assettypeid,
  assetunitid, 
  replaceassetid, 
  assetversion, 
  assetattribute,
  counttypeid, 
  assortmentid, 
  assortmentstr, relatewfid) 
  VALUES  
  ( assetmark_1,
  barcode_2,
  seclevel_3,
  assetimageid_4,
  assettypeid_5, 
  assetunitid_6, 
  replaceassetid_7,
  assetversion_8, 
  assetattribute_9,
  counttypeid_10, 
  assortmentid_11, 
  assortmentstr_12, 
  relatewfid_1) ;
 
  select  max(id) INTO assetid_1  from LgcAsset ;
  INSERT INTO LgcAssetCountry 
  ( assetid, assetname, assetcountyid, startdate, enddate, departmentid, resourceid, assetremark, currencyid, salesprice, costprice, datefield1, datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5, createrid, createdate, lastmoderid, lastmoddate, isdefault) 
  VALUES 
  ( assetid_1,
  assetname_2,
  assetcountyid_3,
  startdate_4, 
  enddate_5,
  departmentid_6,
  resourceid_7, 
  assetremark_8, 
  currencyid_9,
  salesprice_10,
  costprice_11, 
  datefield1_12,
  datefield2_13, 
  datefield3_14, 
  datefield4_15, 
  datefield5_16, 
  numberfield1_17, 
  numberfield2_18,
  numberfield3_19, 
  numberfield4_20,
  numberfield5_21, 
  textfield1_22, 
  textfield2_23, 
  textfield3_24, 
  textfield4_25, 
  textfield5_26, 
  tinyintfield1_27, 
  tinyintfield2_28, 
  tinyintfield3_29,
  tinyintfield4_30,
  tinyintfield5_31, 
  createrid_32, 
  createdate_33, 
  createrid_32, 
  createdate_33, 
  '1');  
  update LgcAssetAssortment 
  set assetcount = assetcount+1 
  where id= assortmentid_11 ;
  open thecursor for
  select max(id) from LgcAsset;
end;
/



CREATE or replace PROCEDURE LgcAsset_Update 
(id_1 	integer,
 assetcountryid_2 in out integer,
 barcode_3 	varchar2,
 seclevel_4 	smallint,
 assetimageid_5 	integer,
 assettypeid_6 	integer,
 assetunitid_7 	integer, 
 replaceassetid_8 	integer,
 assetversion_9 	varchar2,
 assetattribute_10 	varchar2,
 counttypeid_11 	integer,
 assortmentid_12 	integer,
 assortmentstr_13 	varchar2,
 relatewfid_1    integer,
 assetname_2 	varchar2,
 assetcountyid_3 	integer,
 startdate_4 	char,
 enddate_5 	char,
 departmentid_6 	integer,
 resourceid_7 	integer,
 assetremark_8 	varchar2,
 currencyid_9 	integer,
 salesprice_10 in out	varchar2,
 costprice_11 in out	varchar2, 
 datefield1_12 	char,
 datefield2_13 	char,
 datefield3_14 	char,
 datefield4_15 	char,
 datefield5_16 	char,
 numberfield1_17 	float,
 numberfield2_18 	float,
 numberfield3_19 	float,
 numberfield4_20 	float,
 numberfield5_21 	float,
 textfield1_22 	varchar2,
 textfield2_23 	varchar2,
 textfield3_24 	varchar2,
 textfield4_25 	varchar2,
 textfield5_26 	varchar2,
 tinyintfield1_27 	char,
 tinyintfield2_28 	char,
 tinyintfield3_29 	char,
 tinyintfield4_30 	char,
 tinyintfield5_31 	char,
 lastmoderid_32 	integer,
 lastmoddate_33 	char,
 isdefault_1 		char,
 flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
begin
salesprice_10:= to_number(salesprice_10);
costprice_11:= to_number(costprice_11);
UPDATE LgcAsset SET  relatewfid = relatewfid_1, barcode=barcode_3, seclevel=seclevel_4, 
assetimageid=assetimageid_5, assettypeid=assettypeid_6, assetunitid=assetunitid_7,
replaceassetid=replaceassetid_8, assetversion=assetversion_9, assetattribute=assetattribute_10,
counttypeid=counttypeid_11, assortmentid=assortmentid_12, assortmentstr=assortmentstr_13 
WHERE ( id=id_1);

  /*
  if  assetcountryid_2=-1 begin select assetcountryid_2=assetcountyid from LgcAssetCountry where assetid=id_1 and isdefault='1' end
  if  isdefault='1' begin update LgcAssetCountry set isdefault='0' where assetid=id_1 end
  UPDATE LgcAssetCountry SET      assetname	 = assetname_2, assetcountyid = assetcountyid_3, startdate	 = startdate_4, enddate	 = enddate_5, departmentid	 = departmentid_6, resourceid	 = resourceid_7, assetremark	 = assetremark_8, currencyid	 = currencyid_9, salesprice	 = salesprice_10, costprice	 = costprice_11, datefield1	 = datefield1_12, datefield2	 = datefield2_13, datefield3	 = datefield3_14, datefield4	 = datefield4_15, datefield5	 = datefield5_16, numberfield1	 = numberfield1_17, numberfield2	 = numberfield2_18, numberfield3	 = numberfield3_19, numberfield4	 = numberfield4_20, numberfield5	 = numberfield5_21, textfield1	 = textfield1_22, textfield2	 = textfield2_23, textfield3	 = textfield3_24, textfield4	 = textfield4_25, textfield5	 = textfield5_26, tinyintfield1 = tinyintfield1_27, tinyintfield2 = tinyintfield2_28, tinyintfield3 = tinyintfield3_29, tinyintfield4 = tinyintfield4_30, tinyintfield5 = tinyintfield5_31, lastmoderid	 = lastmoderid_32, lastmoddate	 = lastmoddate_33 , isdefault	= isdefault  WHERE ( (assetid = id_1) and (assetcountyid =assetcountryid_2))
  */
end;
/



CREATE or replace PROCEDURE LgcAsset_Delete  (
(id_1 	integer,
 assetcountryid_2 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
  AS  
  isdefault_1 char;
  assortmentid_1 integer;
  /*
  select isdefault= isdefault from LgcAssetCountry where assetid=id_1 and assetcountyid = assetcountryid_2 if isdefault='1' begin select -1 return end
  */
  select aassortmentid INTO ssortmentid_1  from LgcAsset where id=id_1;
  DELETE LgcAsset  WHERE id=id_1; 
  DELETE LgcAssetCountry  WHERE assetid=id_1 ;
  update LgcAssetAssortment 
  set assetcount = assetcount-1 where id= assortmentid_1;
end;
/

insert into SystemRights(id,rightdesc,righttype) values(380,'产品维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(380,7,'产品维护','产品维护')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(380,8,'','')
/

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2080,'产品维护','CrmProduct:Add',380)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (380,8,'1')
/

insert into SystemRightToGroup (groupid,rightid) values (6,380)
/




/* 对于角色表的更新 */
CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
        docid_1	 integer;
	    crmid_1	 integer;
	    prjid_1	 integer;
	    cptid_1	 integer;
        sharelevel_1  integer;
        departmentid_1 integer;
	    subcompanyid_1 integer;
        seclevel_1	 integer;
        countrec      integer;
        countdelete   integer;
        countinsert   integer;
		managerstr_11 varchar2(200); 
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;

if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;



if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */
     

	/* ------- DOC 部分 ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
				end if;
			end if;
        end loop;



	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
			
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			
			else if sharelevel_1 = 2  then
			
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	   


	/* ------- PROJ 部分 ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
             
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	
  



	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2 then 
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
    end if;

    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */
    

	/* ------- DOC 部分 ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;


	/* ------- CRM 部分 ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
	   end loop;

  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	

      

	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;

    end if;
    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */
    

        /* ------- DOC 部分 ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
        
  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
 


	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;    

    end if;


else if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* 自己下级的文档 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
			end if;
		end if;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* 自己下级的项目3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;


 
    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) 
    
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then 
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;

	

    /* 项目成员5 (内部用户) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ; 
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CPT 部分 ------- */


    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;





    /* 自己下级的资产1 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;

 
   
    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;

    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;	

	end if;
end if; /* 结束角色删除或者级别降低的处理 */
end ;
/



/* 人力资源表涉及请求的创建 */
drop TRIGGER Tri_U_workflow_createlist
/

CREATE or REPLACE TRIGGER Tri_U_workflow_createlist 
after insert or update or delete ON  HrmResource
FOR each row
Declare workflowid integer;
	type_1 integer;
 	objid integer;
	level_n integer;
	userid integer;
    olddepartmentid_1 integer;
    departmentid_1 integer;
    oldseclevel_1	 integer;
    seclevel_1	 integer;
    countdelete   integer;
begin
countdelete := :old.id;
olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;




/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if ( countdelete = 0 or departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 )   then  


    delete from workflow_createrlist ;

    for all_cursor IN (select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
	loop
		workflowid := all_cursor.workflowid;
		type_1 := all_cursor.type;
		objid := all_cursor.objid;
		level_n := all_cursor.level_n;
		if type_1=1 then	
			for detail_cursor IN (select id from HrmResource where departmentid = objid and seclevel >= level_n)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;
		if type_1=2 then
			for detail_cursor IN (SELECT resourceid   id FROM HrmRoleMembers where roleid =  objid and rolelevel >=level_n)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;
		if type_1=3 then
		insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,objid,'0');
		end if;
		 if type_1=4 then
		 insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,'-1',level_n) ;
		 end if;
		 if type_1=20 then
			for detail_cursor IN (select id  from CRM_CustomerInfo where  seclevel >= level_n and type = objid	)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		 end if;
		if type_1=21 then
			for detail_cursor IN ( select id  from CRM_CustomerInfo where  seclevel >= level_n and status = objid	)
			loop 
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		end if;

		if type_1=22 then
			for detail_cursor IN (select id  from CRM_CustomerInfo where  seclevel >= level_n and department = objid		)
			loop
			userid :=detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		end if;
		if type_1=25 then
		insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,'-2',level_n) ;
		end if;
		if type_1=30 then
		for detail_cursor IN (select id from HrmResource where subcompanyid1 = objid and seclevel >= level_n)
			loop
			userid :=detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;

	end loop; 
end if;
end ;
/






CREATE TABLE HrmInfoMaintenance(
	id integer  NOT NULL ,
	itemname varchar2(100) null,
	hrmid  integer null
)
/
create sequence HrmInfoMaintenance_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmInfoMaintenance_Trigger
before insert on HrmInfoMaintenance
for each row
begin
select HrmInfoMaintenance_id.nextval into :new.id from dual;
end;
/



CREATE TABLE HrmInfoStatus(
	id integer  NOT NULL ,
	itemid integer null,
	status char(1) default 0,
	hrmid  integer null
)
/
create sequence HrmInfoStatus_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmInfoStatus_Trigger
before insert on HrmInfoStatus
for each row
begin
select HrmInfoStatus_id.nextval into :new.id from dual;
end;
/


/*入职员工资产领用表*/
CREATE TABLE HrmCapitalUse(
	id integer  NOT NULL ,
	capitalid  integer null,
	hrmid integer null,
	cptnum integer null
	)
/
create sequence HrmCapitalUse_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCapitalUse_Trigger
before insert on HrmCapitalUse
for each row
begin
select HrmCapitalUse_id.nextval into :new.id from dual;
end;
/


 CREATE or replace PROCEDURE  Employee_Insert
 (
	id_1      integer,
	name_1		varchar2,
	sex_1		char,
	startdate_1 char,
	departmentid_1 integer,
	joblevel_1	smallint,
	jobtitle_1	smallint,
	managerid_1  integer,
	flag	out		integer,
	msg out		varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
costcenterid_1 integer;
begin
	select id INTO costcenterid_1  from HrmCostcenter WHERE departmentid = departmentid_1;
	insert into  HrmResource
	(id,lastname,sex,startdate,departmentid,joblevel,jobtitle,managerid,costcenterid,titleid)
	values	(id_1,name_1,sex_1,startdate_1,departmentid_1,joblevel_1,jobtitle_1,managerid_1,costcenterid_1,1);
end;
/



CREATE GLOBAL TEMPORARY TABLE temp_Employee_table_01
 (id integer,
 lastname  varchar2(60) ,
 sex  char(1),
 startdate	char(10),
 departmentid	integer,
 joblevel	smallint, 
 managerid integer )
 ON COMMIT DELETE ROWS
/


CREATE or replace PROCEDURE Employee_SByStatus
(
	flag	out		integer,
	msg  out		varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
hrmid_1 integer;
id_1 integer;
lastname_1 varchar2(60);
sex_1 char(1);
startdate_1 char(10);
departmentid_1 integer;
joblevel_1 smallint;
managerid_1 integer;

begin  
for employee_cursor  IN (select distinct  hrmid   from HrmInfoStatus where status ='0') 
loop
hrmid_1 :=employee_cursor.hrmid ;
select id,lastname,sex,startdate,departmentid,joblevel,managerid INTO id_1,
lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1 from HrmResource WHERE id=hrmid_1;
	
	insert INTO temp_Employee_table_01(id,lastname,sex,startdate,departmentid,joblevel,managerid)
	values(id_1,lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1);
end loop;
open thecursor for
	select * from temp_Employee_table_01;
end;
/










CREATE or replace PROCEDURE Employee_SelectByHrmid
(
	hrmid_1    integer,
	flag	out		integer,
	msg out		varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for
select itemid,status from HrmInfoStatus WHERE hrmid=hrmid_1 AND itemid<10  order by itemid;
end;
/


CREATE or replace PROCEDURE Employee_LoginUpdate
	(
	loginid_1 varchar2,
	password_1 varchar2,
	hrmid_1  integer,
	flag	out		integer,
	msg out		varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as

count_1 integer;
begin
/*判断是否有重复登录名*/
select count(*) INTO count_1 from HrmResource where loginid = loginid_1 and id<>hrmid_1;
if count_1<>0 then
    open thecursor for
	select -1 from dual ;
	return ;
else 
	
	if password_1 == 'novalue$1'  then 	
	update HrmResource
	set
	loginid=loginid_1,
	systemlanguage=7,
	countryid=1,
	resourcetype='2',
	seclevel=10
	WHERE id= hrmid_1;	
	else	
	update HrmResource
	set
	loginid=loginid_1,
	password=password_1,
	systemlanguage=7,
	countryid=1,
	resourcetype='2',
	seclevel=10
	WHERE id= hrmid_1;
	end if;
end if;
update HrmInfoStatus
set
status = '1'
WHERE itemid=1 AND hrmid=hrmid_1;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_EmaiUpdate
 (
	email_1 varchar2,
	emailpassword_1 varchar2,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
count_1 integer;
begin
update HrmResource
set
email=email_1
WHERE id=hrmid_1;
if emailpassword_1 = 'novalue$1' then /*如果只是是修改邮箱帐户*/	
	update MailPassword set resourcemail =email_1  WHERE resourceid=hrmid_1;	
else	
		open thecursor for
		select  count(*) INTO count_1 from MailPassword WHERE resourceid=hrmid_1 ;
		if count_1 <> 0  then /*如果是修改帐户或密码*/		
		update MailPassword set resourcemail =email_1,password=emailpassword_1  WHERE resourceid=hrmid_1;	
		else	/*如果原先没有此人的记录，此时为第一次设置*/		
		insert INTO  MailPassword (resourceid,resourcemail,password)
		values(hrmid_1,email_1,emailpassword_1);
		end if;
end if;
update HrmInfoStatus
set 
status = '1'
WHERE itemid=2 AND hrmid=hrmid_1;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_CardUpdate
 (
	textfield_1 varchar2,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmResource
set
textfield1=textfield_1
WHERE id=hrmid_1;
update HrmInfoStatus
set 
status = '1'
WHERE itemid=3 AND hrmid=hrmid_1;
end;
/




 CREATE or REPLACE  PROCEDURE Employee_SeatUpdate
 (
	textfield_1 varchar2,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmResource
set
textfield2=textfield_1
WHERE id=hrmid_1;
update HrmInfoStatus
set 
status = '1'
WHERE itemid=4 AND hrmid=hrmid_1;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_TeleUpdate
 (
	telephone_1 varchar2,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmResource
set
telephone=telephone_1
WHERE id=hrmid_1;
update HrmInfoStatus
set 
status = '1'
WHERE itemid=7 AND hrmid=hrmid_1;
end;
/


 CREATE or REPLACE  PROCEDURE Employee_SelectByID
 (
	hrmid_1    integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
select email,textfield1,textfield2,telephone,tinyintfield1 from HrmResource WHERE id=hrmid_1 ;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_SetAll
 (
	hrmid_1    integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
count_1 integer;
begin
/*判断是否有其它项未设置*/
open thecursor for
select count(*) INTO count_1 from HrmInfoStatus where status=0 AND hrmid=hrmid_1 AND itemid<10 ;
if count_1<>0 then
	open thecursor for
	select -1 from dual ;
	return;
else
update HrmInfoStatus 
set status=1 WHERE itemid=10 AND hrmid=hrmid_1;
end if;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_BusiCardUpdate
 (
	businesscard_1 varchar2,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmResource
set
tinyintfield1 = businesscard_1
WHERE id=hrmid_1;
update HrmInfoStatus
set 
status = '1'
WHERE itemid=9 AND hrmid=hrmid_1;
end;
/



CREATE GLOBAL TEMPORARY TABLE temp_employee_02
 (mark varchar2(60) ,
 name varchar2(60),
 cptnum  integer)
 ON COMMIT DELETE ROWS
/


 CREATE or REPLACE  PROCEDURE Employee_CptSelectByID
 (
	hrmid_1 integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
mark_1 varchar2(60);
name_1 varchar2(60);
cptnum_1 integer;
capitalid_1 integer;
cursor cpt_cursor is
select capitalid,cptnum from HrmCapitalUse WHERE hrmid =hrmid_1;
begin
	OPEN  cpt_cursor ;
	FETCH cpt_cursor into  capitalid_1,cptnum_1;
	while cpt_cursor%found
    loop
	open thecursor for
	select mark,name INTO mark_1,name_1 from CptCapital where id= capitalid_1;
	insert INTO temp_employee_02(mark,name,cptnum) values(mark_1,name_1,cptnum_1);
	FETCH cpt_cursor into  capitalid_1,cptnum_1;
    end loop;
open thecursor for
select * from temp_employee_02;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_CptUpdate
 (
	id_1 integer,
	hrmid_1  integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmInfoStatus
set 
status = '1'
WHERE itemid=id_1 AND hrmid=hrmid_1;
end;
/




/*资产流程新增:资产领用*/
   CREATE or REPLACE  PROCEDURE CptUseLogUse_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	number,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar,
	 remark_11 	varchar2,
	 sptcount_1	char,
	 flag out integer ,
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)

AS 
 num_1 number;
 num_count integer;
begin
/*判断数量是否足够(对于非单独核算的资产*/
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
	 maintaincompany_8,
	 fee_9,
	 '2',
	 remark_11,
              0);
/*单独核算的资产*/
if sptcount_1 = '1' then
	Update CptCapital
	Set 
	departmentid = usedeptid_3,
	resourceid   = useresourceid_4,
	stateid = usestatus_10
	where id = capitalid_1;
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(capitalid_1,useresourceid_4,1);
/*非单独核算的资产*/
else 
	Update CptCapital
	Set
	capitalnum = num_1
	where id = capitalid_1;
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(capitalid_1,useresourceid_4,usecount_5);
	open thecursor for
	select 1 from dual;
	end if;
end;
/

insert into HrmInfoMaintenance (itemname) values ('系统帐户')
/
insert into HrmInfoMaintenance (itemname) values ('邮件帐户')
/
insert into HrmInfoMaintenance (itemname) values ('一卡通')
/
insert into HrmInfoMaintenance (itemname) values ('座位号')
/
insert into HrmInfoMaintenance (itemname) values ('非it资产')
/
insert into HrmInfoMaintenance (itemname) values ('It资产')
/
insert into HrmInfoMaintenance (itemname) values ('分机直线')
/
insert into HrmInfoMaintenance (itemname) values ('办公用品')
/
insert into HrmInfoMaintenance (itemname) values ('名片印制')
/
insert into HrmInfoMaintenance (itemname) values ('任务监控人员')
/




insert into HtmlLabelInfo (indexid,labelname,languageid) values (2224,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2224,'新入职员工',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2224,'新入职员工')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2225,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2225,'入职项目表',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2225,'入职项目表')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2226,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2226,'新入职员工项目设置',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2226,'新入职员工项目设置')
/

alter table Prj_ProjectInfo add members varchar2(3000) null
/
alter table Prj_TaskProcess add  prefinish varchar2(4000) default 0
/
alter table Prj_TaskProcess add taskconfirm char(1) default 0
/
alter table Prj_TaskProcess add islandmark char(1) default 0
/


CREATE TABLE	Task_Log(
	projectid integer null,
	taskid integer null,
	logtype char(2) null,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (8)  NULL ,
	submiter integer null,
	clientip char(15) null,
	submitertype smallint NULL )
/



CREATE TABLE Task_Modify (
	projectid integer NULL ,
	taskid integer NULL ,
	fieldname varchar2 (100)  NULL ,
	modifydate varchar2 (10)  NULL ,
	modifytime varchar2 (8)  NULL ,
	original varchar2 (255)  NULL ,
	modified varchar2 (255)  NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL,
	logtype char(1) null)
/

CREATE or REPLACE PROCEDURE Proj_Members_update
(
	ProjId_1 integer,
	members_1  varchar2,
	flag out 	integer	, msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
 )
as
begin
update Prj_ProjectInfo set
members = members_1 WHERE id= ProjId_1;
end;
/




 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Update 
 (id1	integer,
 wbscoding1 varchar2,
 subject1 	varchar2,
 begindate1 	varchar2, 
 enddate1 	varchar2,
 workday1 number, 
 content1 	varchar2, 
 fixedcost1 number,
 hrmid1 integer, 
 oldhrmid1 integer, 
 finish1 smallint,
 taskconfirm1 char,
 islandmark1 char,
 prefinish_1 varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )  
AS 
currenthrmid1 varchar2(255);
currentoldhrmid1 varchar2(255);
begin
UPDATE Prj_TaskProcess  SET
wbscoding = wbscoding1, 
subject = subject1 ,
begindate = begindate1,
enddate = enddate1 	,
workday = workday1,
content = content1, 
fixedcost = fixedcost1,
hrmid = hrmid, 
finish = finish1 ,
taskconfirm = taskconfirm1,
islandmark = islandmark1,
prefinish = prefinish_1
WHERE ( id	 = id1) ;
if hrmid1 <> oldhrmid1 then

 currenthrmid1 := concat(concat(concat('|' , to_char( id1)) , ',') , concat(to_char( hrmid1) , '|'));
  currentoldhrmid1 :=  concat(concat(concat('|' , to_char( id1)) , ',') , concat(to_char( oldhrmid1) , '|'));
UPDATE Prj_TaskProcess 
set parenthrmids =replace(parenthrmids,currentoldhrmid1,currenthrmid1) where (parenthrmids like
concat(concat('%',currentoldhrmid1),'%'));
end if;
end;
/






CREATE or REPLACE PROCEDURE Prj_TaskProcess_SMAXID
(
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
as
begin
open thecursor for
select max(id)   maxid_1  from Prj_TaskProcess;
end;
/





CREATE or REPLACE PROCEDURE Prj_TaskLog_Insert
(
	projectid_1 integer,
	taskid_1 integer  ,
	logtype_1 char  ,
	submitdate_1 varchar2    ,
	submittime_1 varchar2   ,
	submiter_1 integer  ,
	clientip_1 char  ,
	submitertype_1 smallint  ,
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
as
begin
insert INTO Task_Log (
	projectid ,
	taskid ,
	logtype ,
	submitdate   ,
	submittime  ,
	submiter   ,
	clientip   ,
	submitertype )
	values(
	projectid_1 ,
	taskid_1 ,
	logtype_1 ,
	submitdate_1  ,
	submittime_1  ,
	submiter_1 ,
	clientip_1 ,
	submitertype_1 
	);
end;
/

CREATE or REPLACE PROCEDURE Prj_TaskModify_Insert
(
	projectid_1 integer   ,
	taskid_1 integer    ,
	fieldname_1 varchar2    ,
	modifydate_1 varchar2    ,
	modifytime_1 varchar2    ,
	original_1 varchar2    ,
	modified_1 varchar2    ,
	modifier_1 integer   ,
	clientip_1 char     ,
	submitertype_1 smallint  ,
	logtype_1 char,
	flag out 	integer	, msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
insert INTO Task_Modify(
	projectid  ,
	taskid   ,
	fieldname   ,
	modifydate  ,
	modifytime   ,
	original  ,
	modified   ,
	modifier   ,
	clientip  ,
	submitertype ,
	logtype
	)
	values(
	projectid_1    ,
	taskid_1      ,
	fieldname_1     ,
	modifydate_1     ,
	modifytime_1   ,
	original_1    ,
	modified_1   ,
	modifier_1     ,
	clientip_1     ,
	submitertype_1 ,
	logtype_1
	);
end;
/



 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Insert 
 (prjid1 	integer, 
 taskid1 	integer,  
 wbscoding1 	varchar2, 
 subject1 	varchar2, 
 version1 	smallint, 
 begindate1 	varchar2, 
 enddate1 	varchar2, 
 workday1	number, 
 content1 	varchar2, 
 fixedcost1 number, 
 parentid1 integer,
 parentids1 varchar2, 
 parenthrmids1 varchar2, 
 level_n1 smallint, 
 hrmid1 integer, 	
 prefinish_1 varchar2,
 flag out integer ,
 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  ) 
AS 
 id1 integer;
 maxid1 varchar2(255);
 maxhrmid1 varchar2(255);
begin


INSERT INTO Prj_TaskProcess ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,islandmark,prefinish)  

VALUES 
( prjid1, taskid1 , wbscoding1, subject1 , version1 , begindate1, enddate1, workday1, content1, fixedcost1, parentid1, parentids1, parenthrmids1, level_n1, hrmid1,'0',prefinish_1); 

select  max(id) INTO id1 from Prj_TaskProcess; 
 maxid1 := concat(to_char( id1) , ',');
 maxhrmid1 := concat(concat('|' , to_char( id1)) , concat(concat( ',' , to_char( hrmid1)) , '|') );
update Prj_TaskProcess set parentids= concat(parentids1, maxid1), parenthrmids=concat(parenthrmids1 , maxhrmid1)  where id=id1;
end;
/



CREATE or REPLACE PROCEDURE Task_Log_Select 
 (id 	integer, 
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 open thecursor for
 SELECT * FROM Task_Log WHERE ( projectid	 = id) 
 ORDER BY submitdate DESC, submittime DESC ;
 end;
/

CREATE or REPLACE PROCEDURE Task_Modify_Select 
 (id 	integer, 
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 SELECT * FROM Task_Modify 
 WHERE ( projectid	 = id) ORDER BY modifydate DESC, modifytime DESC ;
end;
/

drop table Prj_ProjectStatus
/

drop sequence Prj_ProjectStatus_id
/

CREATE TABLE Prj_ProjectStatus (
	id integer  NOT NULL ,
	fullname varchar2 (50) NULL ,
	description varchar2(150)  NULL 
)
/
create sequence Prj_ProjectStatus_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ProjectStatus_Trigger
before insert on Prj_ProjectStatus
for each row
begin
select Prj_ProjectStatus_id.nextval into :new.id from dual;
end;
/
insert into Prj_ProjectStatus (fullname,description) values ('正常','正常')
/
insert into Prj_ProjectStatus (fullname,description) values ('延期','延期')
/
insert into Prj_ProjectStatus (fullname,description) values ('完成','完成')
/
insert into Prj_ProjectStatus (fullname,description) values ('冻结','冻结')
/
insert into Prj_ProjectStatus (fullname,description) values ('立项批准','立项批准')
/
insert into Prj_ProjectStatus (fullname,description) values ('待审批','待审批')
/




 CREATE or REPLACE PROCEDURE Prj_TaskProcess_Sum 
 (
 prjid_1 integer,
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 open thecursor for
 SELECT sum(workday) as workday,
 min(begindate) as begindate, 
 max(enddate) as enddate, 
 sum(finish*workday)/sum(workday) as finish,
 sum(fixedcost) as fixedcost
 FROM Prj_TaskProcess
 WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1') ;
end;
/



  CREATE or REPLACE  PROCEDURE Prj_TaskProcess_UpdateParent 
 (parentid_1	integer,
 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 
begindate_1 varchar2(10); 
enddate_1 varchar2(10);
workday_1  number(10,1); 
finish_1 integer ;
fixedcost_1 number(10,2);
begin
select  min(begindate)   , max(enddate)  ,   sum(workday), 
 to_number(sum(workday*finish)/sum(workday)) ,  sum(fixedcost) INTO begindate_1, enddate_1,workday_1,finish_1, fixedcost_1 
from Prj_TaskProcess where parentid=parentid_1;
UPDATE Prj_TaskProcess 
SET  
begindate = begindate_1, 
enddate = enddate_1,
workday = workday_1, 
finish = finish_1  ,
fixedcost = fixedcost_1
WHERE ( id = parentid_1) ;
end;
/


/* 首页定制 */
CREATE TABLE HomePageDesign (
	id integer  NOT NULL ,
	name integer NULL ,
	iframe varchar2(50)  NULL ,	
	height integer NULL ,
	url varchar2(100)  NULL 
)
/
create sequence HomePageDesign_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HomePageDesign_Trigger
before insert on HomePageDesign
for each row
begin
select HomePageDesign_id.nextval into :new.id from dual;
end;
/

CREATE TABLE PersonalHomePageDesign (
	homepageid integer NULL ,
	hrmid integer NULL ,
	orderid integer NULL ,
	ischecked integer NULL 
)
/



ALTER TABLE CRM_CustomerContacter add interest varchar2(100) /* 兴趣 */
/
ALTER TABLE CRM_CustomerContacter add hobby varchar2(100) /* 爱好 */
/
ALTER TABLE CRM_CustomerContacter add managerstr varchar2(100) /* 经理名称 */
/
ALTER TABLE CRM_CustomerContacter add subordinate varchar2(100) /* 下属 */
/
ALTER TABLE CRM_CustomerContacter add strongsuit varchar2(100) /* 专长 */
/
ALTER TABLE CRM_CustomerContacter add age integer /* 年龄 */
/
ALTER TABLE CRM_CustomerContacter add birthday varchar2(10) /* 生日 */
/
ALTER TABLE CRM_CustomerContacter add home varchar2(100) /* 家庭住址 */
/
ALTER TABLE CRM_CustomerContacter add school varchar2(100) /* 毕业学校 */
/
ALTER TABLE CRM_CustomerContacter add speciality varchar2(100) /* 专业 */
/
ALTER TABLE CRM_CustomerContacter add nativeplace varchar2(100) /* 籍贯 */
/
ALTER TABLE CRM_CustomerContacter add experience varchar2(200) /* 经历 */
/


ALTER TABLE CRM_CustomerInfo add introductionDocid integer /* 客户卡片的背景信息 */
/

ALTER TABLE CRM_CustomerInfo add evaluation number(10, 2)  /* 客户卡片的背景信息 */
/


CREATE TABLE CRM_Evaluation (
	id integer  NOT NULL ,
	name varchar2(50)  NULL ,
	proportion integer NULL 
)
/
create sequence CRM_Evaluation_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Evaluation_Trigger
before insert on CRM_Evaluation
for each row
begin
select CRM_Evaluation_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_Evaluation_Level (
	id integer  NOT NULL ,
	name varchar2 (50)  NULL ,
	levelvalue integer NULL 
)
/
create sequence CRM_Evaluation_Level_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Evaluation_Level_Trigger
before insert on CRM_Evaluation_Level
for each row
begin
select CRM_Evaluation_Level_id.nextval into :new.id from dual;
end;
/

 CREATE  TABLE CRM_ContacterLog_Remind (
	id integer  NOT NULL ,
	customerid integer NULL,	
	daytype integer NULL, /* 时间类型 */
	before integer NULL, /* 提前的时间 */
	isremind integer NULL	/* 是否提醒 */
)
/
create sequence CRM_ContacterLog_Remind_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContacterLog_Remind_Trig
before insert on CRM_ContacterLog_Remind
for each row
begin
select CRM_ContacterLog_Remind_id.nextval into :new.id from dual;
end;
/

 CREATE or REPLACE  PROCEDURE PersonalHPDesign_Duplicate
	(hrmid_1 	integer,
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS 

  homepageid_1	integer;
  orderid_1   integer;
begin
   orderid_1 := 0;

for homepageid_cursor IN (select id
from HomePageDesign order by id)
loop
homepageid_1 := homepageid_cursor.id;
orderid_1 := orderid_1 + 1;
INSERT INTO PersonalHomePageDesign 
  values(homepageid_1 , hrmid_1 , orderid_1, 0);
end loop;
open thecursor for
select * from PersonalHomePageDesign where hrmid = hrmid_1 order by orderid;
end;
/




 CREATE or REPLACE PROCEDURE PersonalHPDesign_Update1
	(hrmid_1 	integer,
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS
begin
update PersonalHomePageDesign set orderid=0 , ischecked = 1 where hrmid = hrmid_1;
end;
/

 CREATE or REPLACE PROCEDURE PersonalHPDesign_Update2
	(hrmid_1 	integer,
	 homepageid_1    integer,
	 orderid_1 	integer,
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS
begin
update PersonalHomePageDesign set orderid = orderid_1 , ischecked = 0 where hrmid = hrmid_1 and homepageid = homepageid_1;
end ;
/


 CREATE or REPLACE PROCEDURE CptCapital_SCountByDataType 
(datatype_1 	integer, 
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 open thecursor for
select max(mark) from CptCapital where  datatype =  datatype and isdata='2';
end;
/



  CREATE or REPLACE PROCEDURE CRM_CustomerContacter_Insert 
 (customerid_1 	integer,
 title_2 	integer,
 fullname_3 	varchar2, 
 lastname_4 	varchar2,
 firstname_5 	varchar2,
 jobtitle_6 	varchar2,
 email_7 	varchar2, 
 phoneoffice_8 	varchar2,
 phonehome_9 	varchar2, 
 mobilephone_10 	varchar2, 
 fax_11 	varchar2,
 language_12 	integer,
 manager_13 	integer, 
 main_14 	smallint, 
 picid_15 	integer,
 interest_1	varchar2,
 hobby_1	varchar2,
 managerstr_1	varchar2,
 subordinate_1	varchar2,
 strongsuit_1	varchar2,
 age_1		integer, 
 birthday_1	varchar2,
 home_1	varchar2,
 school_1	varchar2,
 speciality_1	varchar2,
 nativeplace_1	varchar2,
 experience_1	varchar2,
 datefield1_16 	varchar2,
 datefield2_17 	varchar2,
 datefield3_18 	varchar2,
 datefield4_19 	varchar2, 
 datefield5_20 	varchar2, 
 numberfield1_21 	float, 
 numberfield2_22 	float, 
 numberfield3_23 	float, 
 numberfield4_24 	float, 
 numberfield5_25 	float,
 textfield1_26 	varchar2,
 textfield2_27 	varchar2,
 textfield3_28 	varchar2,
 textfield4_29 	varchar2, 
 textfield5_30 	varchar2,
 tinyintfield1_31 	smallint, 
 tinyintfield2_32 	smallint,
 tinyintfield3_33 	smallint, 
 tinyintfield4_34 	smallint,
 tinyintfield5_35 	smallint,
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 INSERT INTO CRM_CustomerContacter
 ( customerid, title,
 fullname, lastname, firstname,
 jobtitle, email, phoneoffice,
 phonehome, mobilephone, fax, language,
 manager, main, picid, datefield1,
 datefield2, datefield3, datefield4,
 datefield5, numberfield1, numberfield2,
numberfield3, numberfield4, numberfield5, 
textfield1, textfield2, textfield3, textfield4, 
textfield5, tinyintfield1, tinyintfield2, tinyintfield3, 
tinyintfield4, tinyintfield5 ,interest ,hobby ,managerstr,subordinate,strongsuit,age,birthday,home,
school,speciality,nativeplace,experience) 
 VALUES 
 ( customerid_1, title_2, fullname_3, lastname_4, 
 firstname_5, jobtitle_6, email_7, phoneoffice_8,
 phonehome_9, mobilephone_10, fax_11, language_12,
 manager_13, main_14, picid_15, datefield1_16, 
 datefield2_17, datefield3_18, datefield4_19,
 datefield5_20, numberfield1_21, numberfield2_22,
 numberfield3_23, numberfield4_24, numberfield5_25, 
 textfield1_26, textfield2_27, textfield3_28, 
 textfield4_29, textfield5_30, tinyintfield1_31,
 tinyintfield2_32, tinyintfield3_33, tinyintfield4_34,
 tinyintfield5_35, interest_1 , hobby_1 , 
 managerstr_1, subordinate_1 , strongsuit_1 ,
 age_1 , birthday_1 , home_1 , school_1 ,
 speciality_1 , nativeplace_1 , experience_1 ) ; 
end;
/


  CREATE or REPLACE PROCEDURE CRM_CustomerContacter_Update 
 (id_1 	integer, 
 title_3 	integer,
 fullname_4 	varchar2,
 lastname_5 	varchar2,
 firstname_6 	varchar2, 
 jobtitle_7 	varchar2, 
 email_8 	varchar2, 
 phoneoffice_9 	varchar2,
 phonehome_10 	varchar2, 
 mobilephone_11 	varchar2,
 fax_12 	varchar2, 
 language_13 	integer, 
 manager_14 	integer, 
 main_15 	smallint, 
 picid_16 	integer, 
 interest_1	varchar2,
 hobby_1	varchar2,
 managerstr_1	varchar2,
 subordinate_1	varchar2,
 strongsuit_1	varchar2,
 age_1		integer, 
 birthday_1	varchar2,
 home_1	varchar2,
 school_1	varchar2,
 speciality_1	varchar2,
 nativeplace_1	varchar2,
 experience_1	varchar2,
 datefield1_17 	varchar2,
 datefield2_18 	varchar2,
 datefield3_19 	varchar2, 
 datefield4_20 	varchar2,
 datefield5_21 	varchar2, 
 numberfield1_22 	float, 
 numberfield2_23 	float,
 numberfield3_24 	float, 
 numberfield4_25 	float, 
 numberfield5_26 	float,
 textfield1_27 	varchar2, 
 textfield2_28 	varchar2, 
 textfield3_29 	varchar2, 
 textfield4_30 	varchar2,
 textfield5_31 	varchar2, 
 tinyintfield1_32 	smallint, 
 tinyintfield2_33 	smallint,
 tinyintfield3_34 	smallint,
 tinyintfield4_35 	smallint, 
 tinyintfield5_36 	smallint, 
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)   
 AS 
 begin
 UPDATE CRM_CustomerContacter  
 SET	 title	 = title_3, 
 fullname	 = fullname_4, 
 lastname	 = lastname_5, 
 firstname	 = firstname_6,
 jobtitle	 = jobtitle_7,
 email	 = email_8, 
 phoneoffice	 = phoneoffice_9, 
 phonehome	 = phonehome_10,
 mobilephone	 = mobilephone_11,
 fax	 = fax_12, 
 language	 = language_13, 
 manager	 = manager_14,
 main	 = main_15, picid	 = picid_16,
 datefield1	 = datefield1_17, 
 datefield2	 = datefield2_18, 
 datefield3	 = datefield3_19,
 datefield4	 = datefield4_20,
 datefield5	 = datefield5_21, 
 numberfield1	 = numberfield1_22,
 numberfield2	 = numberfield2_23,
 numberfield3	 = numberfield3_24,
 numberfield4	 = numberfield4_25,
 numberfield5	 = numberfield5_26,
 textfield1	 = textfield1_27, 
 textfield2	 = textfield2_28, 
 textfield3	 = textfield3_29,
 textfield4	 = textfield4_30,
 textfield5	 = textfield5_31,
 tinyintfield1	 = tinyintfield1_32, 
 tinyintfield2	 = tinyintfield2_33,
 tinyintfield3	 = tinyintfield3_34, 
 tinyintfield4	 = tinyintfield4_35, 
 tinyintfield5	 = tinyintfield5_36, 
 interest	 = interest_1,
 hobby	 = hobby_1,
 managerstr	 = managerstr_1,
 subordinate	 = subordinate_1,
 strongsuit	 = strongsuit_1,
 age	 = age_1,
 birthday	 = birthday_1,
 home	 = home_1,
 school	 = school_1,
 speciality	 = speciality_1,
 nativeplace	 = nativeplace_1,
 experience	 = experience_1
WHERE ( id	 = id_1)  ;
end ;
/


CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Insert 
 (name_1 		varchar2, 
 language_1 	integer,
 engname_1 	varchar2, 
 address1_1 	varchar2, 
 address2_1 	varchar2,
 address3_1 	varchar2,
 zipcode_1 	varchar2,
 city_1	 	integer,
 country_1 	integer,
 province_1 	integer,
 county_1 	varchar2,
 phone_1 	varchar2,
 fax_1	 	varchar2,
 email_1 	varchar2, 
 website_1 	varchar2,
 source_1 	integer, 
 sector_1 	integer,
 size_n_1	 	integer,
 manager_1 	integer,
 agent_1 	integer, 
 parentid_1 	integer,
 department_1 	integer,
 subcompanyid1_1 	integer, 
 fincode_1 	integer, 
 currency_1 	integer,
 contractlevel_1	integer,
 creditlevel_1 	integer,
 creditoffset_1 	varchar2,
 discount_1 	decimal, 
 taxnumber_1 	varchar2,
 bankacount_1 	varchar2,
 invoiceacount_1	integer,
 deliverytype_1 	integer,
 paymentterm_1 	integer,
 paymentway_1 	integer, 
 saleconfirm_1 	integer,
 creditcard_1 	varchar2,
 creditexpire_1 	varchar2,
 documentid_1 	integer,
 seclevel_1 	integer, 
 picid_1 	integer, 
 type_1 		integer, 
 typebegin_1 	varchar2, 
 description_1 	integer,
 status_1 	integer,
 rating_1 	integer, 
 introductionDocid_1 integer, 
 datefield1_1 	varchar2,
 datefield2_1 	varchar2,
 datefield3_1 	varchar2, 
 datefield4_1 	varchar2,
 datefield5_1 	varchar2, 
 numberfield1_1 	float,
 numberfield2_1 	float,
 numberfield3_1 	float, 
 numberfield4_1 	float,
 numberfield5_1 	float,
 textfield1_1 	varchar2,
 textfield2_1 	varchar2,
 textfield3_1 	varchar2,
 textfield4_1 	varchar2, 
 textfield5_1 	varchar2, 
 tinyintfield1_1 smallint,
 tinyintfield2_1 smallint, 
 tinyintfield3_1 smallint,
 tinyintfield4_1 smallint,
 tinyintfield5_1 smallint, 
 createdate_1 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO CRM_CustomerInfo 
 ( name,
 language,
 engname, 
 address1,
 address2, 
 address3,
 zipcode, 
 city,
 country, 
 province,
 county,
 phone, 
 fax, 
 email,
 website,
 source,
 sector,
 size_n,
 manager,
 agent, 
 parentid,
 department,
 subcompanyid1, 
 fincode, 
 currency, 
 contractlevel,
 creditlevel,
 creditoffset, 
 discount,
 taxnumber,
 bankacount, 
 invoiceacount,
 deliverytype,
 paymentterm, 
 paymentway, 
 saleconfirm,
 creditcard, 
 creditexpire,
 documentid, 
 seclevel, 
 picid, 
 type, 
 typebegin,
 description,
 status,
 rating,
 datefield1, 
 datefield2, 
 datefield3,
 datefield4, 
 datefield5, 
 numberfield1,
 numberfield2, 
 numberfield3, 
 numberfield4, 
 numberfield5, 
 textfield1, 
 textfield2, 
 textfield3, 
 textfield4, 
 textfield5, 
 tinyintfield1,
 tinyintfield2, 
 tinyintfield3,
 tinyintfield4,
 tinyintfield5,
 deleted, 
 createdate,
 introductionDocid) 
 VALUES
 ( name_1,
 language_1,
 engname_1,
 address1_1, 
 address2_1, 
 address3_1, 
 zipcode_1,
 city_1, 
 country_1,
 province_1,
 county_1,
 phone_1,
 fax_1, 
 email_1,
 website_1,
 source_1,
 sector_1,
 size_n_1,
 manager_1, 
 agent_1,
 parentid_1,
 department_1,
 subcompanyid1_1, 
 fincode_1,
 currency_1,
 contractlevel_1,
 creditlevel_1, 
 to_number(creditoffset_1),
 discount_1,
 taxnumber_1,
 bankacount_1,
 invoiceacount_1, 
 deliverytype_1,
 paymentterm_1, 
 paymentway_1,
 saleconfirm_1, 
 creditcard_1, 
 creditexpire_1, 
 documentid_1, 
 seclevel_1,
 picid_1, 
 type_1, 
 typebegin_1, 
 description_1, 
 status_1,
 rating_1, 
 datefield1_1, 
 datefield2_1,
 datefield3_1, 
 datefield4_1, 
 datefield5_1,
 numberfield1_1, 
 numberfield2_1, 
 numberfield3_1, 
 numberfield4_1,
 numberfield5_1, 
 textfield1_1,
 textfield2_1,
 textfield3_1,
 textfield4_1, 
 textfield5_1, 
 tinyintfield1_1,
 tinyintfield2_1,
 tinyintfield3_1,
 tinyintfield4_1,
 tinyintfield5_1, 
 0, 
 createdate_1, 
 introductionDocid_1 );
open thecursor for 
select id from(SELECT  id from CRM_CustomerInfo ORDER BY id DESC) where rownum =1;
end;
/



  CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Update 
 (id_1 		integer,
 name_1 		varchar2,
 language_1 	integer, 
 engname_1 	varchar2,
 address1_1 	varchar2,
 address2_1 	varchar2,
 address3_1 	varchar2,
 zipcode_1 	varchar2,
 city_1	 	integer, 
 country_1 	integer,
 province_1 	integer, 
 county_1 	varchar2,
phone_1 	varchar2,
fax_1	 	varchar2,
email_1 	varchar2, 
website_1 	varchar2,
source_1 	integer,
sector_1 	integer,
size_n_1	 	integer,
manager_1 	integer,
agent_1 	integer,
parentid_1 	integer, 
department_1 	integer,
subcompanyid1_1 	integer,
fincode_1 	integer,
currency_1 	integer, 
contractlevel_1	integer,
creditlevel_1 	integer, 
creditoffset_1 	varchar2,
discount_1 	decimal, 
taxnumber_1 	varchar2,
bankacount_1 	varchar2,
invoiceacount_1 integer,
deliverytype_1 	integer,
paymentterm_1 	integer,
paymentway_1 	integer, 
saleconfirm_1 	integer,
creditcard_1 	varchar2,
creditexpire_1 	varchar2, 
documentid_1 	integer, 
seclevel_1 	integer,
picid_1 	integer, 
type_1	 	integer,
typebegin_1 	varchar2,
description_1 	integer, 
status_1 	integer,
rating_1 	integer,
introductionDocid_1 integer, 
datefield1_1 	varchar2, 
datefield2_1 	varchar2,
datefield3_1 	varchar2, 
datefield4_1 	varchar2,
datefield5_1 	varchar2,
numberfield1_1 	float,
numberfield2_1 	float,
numberfield3_1 	float,
numberfield4_1 	float, 
numberfield5_1 	float, 
textfield1_1 	varchar2,
textfield2_1 	varchar2, 
textfield3_1 	varchar2, 
textfield4_1 	varchar2,
textfield5_1 	varchar2,
tinyintfield1_1 	smallint,
tinyintfield2_1 	smallint, 
tinyintfield3_1 	smallint, 
tinyintfield4_1 	smallint, 
tinyintfield5_1 	smallint, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
UPDATE CRM_CustomerInfo  
SET  	
name	 	 = name_1, 
language	 = language_1, 
engname	 = engname_1, 
address1	 = address1_1, 
address2	 = address2_1,
address3	 = address3_1,
zipcode	 = zipcode_1,
city	 = city_1, 
country	 = country_1,
province	 = province_1,
county	 = county_1,
phone	 = phone_1, 
fax	 = fax_1,
email	 = email_1, 
website	 = website_1,
source	 = source_1,
sector	 = sector_1,
size_n	 = size_n_1, 
manager	 = manager_1,
agent	 = agent_1,
parentid	 = parentid_1,
department	 = department_1, 
subcompanyid1	 = subcompanyid1_1, 
fincode	 = fincode_1,
currency	 = currency_1,
contractlevel = contractlevel_1, 
creditlevel	 = creditlevel_1, 
creditoffset	 = to_number(creditoffset),
discount	 = discount_1,
taxnumber	 = taxnumber_1,
bankacount	 = bankacount_1, 
invoiceacount	 = invoiceacount_1,
deliverytype	 = deliverytype_1, 
paymentterm	 = paymentterm_1, 
paymentway	 = paymentway_1, 
saleconfirm	 = saleconfirm_1, 
creditcard	 = creditcard_1, 
creditexpire	 = creditexpire_1,
documentid	 = documentid_1, 
seclevel = seclevel_1, 
picid	 = picid_1,
type	 = type_1, 
typebegin	 = typebegin_1, 
description	 = description_1, 
status	 = status_1, 
rating	 = rating_1,
datefield1	 = datefield1_1,
datefield2	 = datefield2_1, 
datefield3	 = datefield3_1, 
datefield4	 = datefield4_1,
datefield5	 = datefield5_1,
numberfield1	 = numberfield1_1,
numberfield2	 = numberfield2_1,
numberfield3	 = numberfield3_1,
numberfield4	 = numberfield4_1, 
numberfield5	 = numberfield5_1, 
textfield1	 = textfield1_1,
textfield2	 = textfield2_1, 
textfield3	 = textfield3_1,
textfield4	 = textfield4_1,
textfield5	 = textfield5_1,
tinyintfield1	 = tinyintfield1_1,
tinyintfield2	 = tinyintfield2_1, 
tinyintfield3	 = tinyintfield3_1, 
tinyintfield4	 = tinyintfield4_1,
tinyintfield5	 = tinyintfield5_1  , 
introductionDocid = introductionDocid_1  
WHERE ( id	 = id);
end ;
/



 CREATE or REPLACE PROCEDURE CRM_CustomerEvaluationUpdate
	(id_1 	integer ,
	 evaluation_1 	number,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
UPDATE CRM_CustomerInfo SET evaluation = evaluation_1 where id = id_1;
end;
/

 CREATE or REPLACE PROCEDURE CRM_Evaluation_Select
	(
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
SELECT * FROM CRM_Evaluation ;
end;
/

 CREATE or REPLACE PROCEDURE CRM_Evaluation_SelectById
	(id_1 	integer ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
open thecursor for
SELECT * FROM CRM_Evaluation  where id = id_1 	;
end;
/


CREATE or REPLACE PROCEDURE CRM_Evaluation_Insert 
	(name_1 	varchar2,
	 proportion_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 

AS
begin
INSERT INTO CRM_Evaluation 
	 (name,
	 proportion) 
 
VALUES 
	( name_1,
	 proportion_1);
end;
/

CREATE or REPLACE PROCEDURE CRM_Evaluation_Delete
	(id_1 	integer ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
DELETE CRM_Evaluation 
WHERE 
	( id	 = id_1);
end;
/


CREATE or REPLACE  PROCEDURE CRM_Evaluation_Update 
	(id_1 	integer ,
	 name_1 	varchar2,
	 proportion_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_Evaluation SET name = name_1, proportion = proportion_1 where id = id_1;
end;
/






CREATE or REPLACE  PROCEDURE CRM_Evaluation_L_Select
	(
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * FROM CRM_Evaluation_Level ;
end;
/


CREATE or REPLACE PROCEDURE CRM_Evaluation_L_SelectById
	(id_1 	int ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * FROM CRM_Evaluation_Level  where id = id_1; 	
end;
/



CREATE or REPLACE PROCEDURE CRM_Evaluation_L_Insert 
	(name_1 	varchar2,
	 levelvalue_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO CRM_Evaluation_Level 
	 (name,
	 levelvalue) 
 
VALUES 
	( name_1,
	 levelvalue_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_Evaluation_L_Delete
	(id_1 	integer ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE CRM_Evaluation_Level 
WHERE 
	( id	 = id_1);
end ;
/

CREATE or REPLACE PROCEDURE CRM_Evaluation_L_Update 
	(id_1 	integer ,
	 name_1 	varchar2,
	 levelvalue_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_Evaluation_Level SET name = name_1, levelvalue = levelvalue_1 where id = id_1;
end;
/



CREATE or REPLACE PROCEDURE CRM_ContactLog_Unite_Update 
	(id_1 	integer ,
	 id_2 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_ContactLog SET customerid = id_1 where customerid = id_2;
end ;
/


CREATE or REPLACE PROCEDURE CRM_Contacter_Unite_Update 
	(id_1 	integer ,
	 id_2 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
UPDATE CRM_CustomerContacter SET customerid = id_1 , main = '0' where customerid = id_2;
end;
/


CREATE or REPLACE PROCEDURE CRM_ContacterLog_R_Insert
	(customerid_1 	integer,
	 daytype_1	integer,
	 before_1	integer,
	 isremind_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO CRM_ContacterLog_Remind 
	 (customerid,daytype,before,isremind)  
VALUES 
	( customerid_1, daytype_1 , before_1 , isremind_1);
end;
/

CREATE or REPLACE PROCEDURE CRM_ContacterLog_R_Update
	(customerid_1 	integer,
	 daytype_1	integer,
	 before_1	integer,
	 isremind_1	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
begin
UPDATE CRM_ContacterLog_Remind SET daytype = daytype_1 , before = before_1 , isremind = isremind_1 where  customerid = customerid_1;
end;
/



CREATE or REPLACE PROCEDURE CRM_ContacterLog_R_SById
	(customerid_1 	integer ,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_ContacterLog_Remind  where customerid = customerid_1 	;
end;
/


insert into HomePageDesign (name,iframe,height,url) values ('6057','CurrentWorkIframe','200','/system/homepage/HomePageWork.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('2118','WorkFlowIframe','200','/system/homepage/HomePageWorkFlow.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('316','NewsIframe','200','/system/homepage/HomePageNews.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6058','UnderlingWorkIframe','30','/system/homepage/HomePageUnderlingWork.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('2102','MeetingIframe','200','/system/homepage/HomePageMeeting.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6059','CustomerIframe','200','/system/homepage/HomePageCustomer.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('1037','WorkRemindIframe','200','/system/homepage/HomePageWorkRemind.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('1211','ProjectIframe','200','/system/homepage/HomePageProject.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6060','UnderlingCustomerIframe','30','/system/homepage/HomePageUnderlingCustomer.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('1213','MailIframe','30','/system/homepage/HomePageMail.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6061','CustomerContactframe','200','/system/homepage/HomePageCustomerContact.jsp')
/


insert into CRM_Evaluation (name,proportion) values ('公司规模','20')
/
insert into CRM_Evaluation (name,proportion) values ('公司效益','10')
/
insert into CRM_Evaluation (name,proportion) values ('公司人员素质','20')
/
insert into CRM_Evaluation (name,proportion) values ('公司在IT投资的预算','30')
/
insert into CRM_Evaluation (name,proportion) values ('以前上的系统','20')
/

insert into CRM_Evaluation_Level (name,levelvalue) values ('差','1')
/
insert into CRM_Evaluation_Level (name,levelvalue) values ('一般','2')
/
insert into CRM_Evaluation_Level (name,levelvalue) values ('中等','3')
/
insert into CRM_Evaluation_Level (name,levelvalue) values ('良好','4')
/
insert into CRM_Evaluation_Level (name,levelvalue) values ('优秀','5')
/

insert into HtmlLabelIndex (id,indexdesc) values (6057	,'今日工作')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6057,'今日工作',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6057,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6058	,'查看下属的工作安排')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6058,'查看下属的工作安排',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6058,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6059	,'我的客户')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6059,'我的客户',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6059,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6060	,'查看下属的客户')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6060,'查看下属的客户',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6060,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6061	,'客户联系提醒')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6061,'客户联系提醒',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6061,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6062	,'首页定制')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6062,'首页定制',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6062,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6063	,'降级->无效客户')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6063,'降级->无效客户',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6063,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6064	,'降级->基础客户')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6064,'降级->基础客户',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6064,'',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6066	,'兴趣')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6066,'兴趣',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6066,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6067	,'爱好')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6067,'爱好',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6067,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6068	,'专长')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6068,'专长',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6068,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6069	,'背景资料')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6069,'背景资料',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6069,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6070	,'客户价值评估')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6070,'客户价值评估',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6070,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6071	,'权重')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6071,'权重',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6071,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6072	,'打分')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6072,'打分',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6072,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6073	,'客户价值')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6073,'客户价值',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6073,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6074	,'主')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6074,'主',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6074,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6076	,'月')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6076,'月',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6076,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6077	,'提前时间')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6077,'提前时间',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6077,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6078	,'是否提醒')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6078,'是否提醒',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6078,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6079	,'客户关怀')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6079,'客户关怀',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6079,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6080	,'客户投诉')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6080,'客户投诉',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6080,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6081	,'客户建议')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6081,'客户建议',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6081,'',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6082	,'客户联系')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6082,'客户联系',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6082,'',8)
/

/*2003.3.7 by chenyj*/


 CREATE or REPLACE  PROCEDURE HtmlLabelIndex_Select_ByDesc
	(indexdesc_1 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
 open thecursor for
select id from HtmlLabelIndex WHERE ( indexdesc	 = indexdesc_1) ;
end;
/



 CREATE or REPLACE  PROCEDURE WorkFlow_Bill_Delete
	(id_1 	int,	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
DELETE workflow_bill WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_BillField_DelByBill
	(billid_1 integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
DELETE workflow_billfield WHERE ( billid	 = billid_1);
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_BillField_Delete
	(id_1 integer, 	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
begin
DELETE workflow_billfield WHERE ( id	 = id_1);
end;
/



 CREATE or REPLACE   PROCEDURE WorkFlow_Bill_Search
	(labelname_1 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
 open thecursor for
select id from  workflow_bill WHERE ( namelabel	 = (select indexid from HtmlLabelInfo where labelname= labelname_1));
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_Bill_Insert
	(id_1 	integer,
	namelabel_2 integer,
	tablename_3	varchar2,	 
	createpage_4 	varchar2,
	 managepage_5 	varchar2,
	 viewpage_6 	varchar2,
	 detailtablename_7 	varchar2,
	 detailkeyfield_8 	varchar2,
	 flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO workflow_bill 	 ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) 
 VALUES ( id_1, namelabel_2, tablename_3, createpage_4, managepage_5, viewpage_6,	 detailtablename_7, detailkeyfield_8);
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_Bill_Update
	(id_1 	integer,
	namelabel_2 integer,
	tablename_3	varchar2,
	createpage_4 varchar2,
	 managepage_5 	varchar2,
	 viewpage_6 	varchar2,
	 detailtablename_7 	varchar2,
	 detailkeyfield_8 	varchar2, 
	 flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE workflow_bill 
SET  
namelabel = namelabel_2, 
tablename = tablename_3,
createpage = createpage_4, 
managepage = managepage_5, 
viewpage = viewpage_6,
detailtablename = detailtablename_7, 
detailkeyfield	 = detailkeyfield_8 
WHERE 	( id	 = id_1);
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_BillField_Insert
	(billid_2 integer,
	fieldname_3 varchar2,
	fieldlabel_4 integer,
	 fielddbtype_5 varchar2,
	 fieldhtmltype_6 char, 
	 type_7 integer,
	 dsporder_8 	integer,
	 viewtype_9 	integer,	 	
	 flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
INSERT INTO workflow_billfield
	 ( billid, fieldname, fieldlabel, fielddbtype, 
	 fieldhtmltype, type, dsporder, viewtype) 
VALUES 
	( billid_2, fieldname_3, fieldlabel_4, fielddbtype_5,
	 fieldhtmltype_6, type_7, dsporder_8, viewtype_9);
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_BillField_Update
	(id_1 	integer,
	billid_2 integer,
	fieldname_3 varchar2,
	fieldlabel_4 integer,
	fielddbtype_5 varchar2,
	 fieldhtmltype_6 char,
	 type_7 integer,
	 dsporder_8 integer,
	 viewtype_9 integer,
		flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE workflow_billfield 
SET  billid	 = billid_2, fieldname = fieldname_3, fieldlabel	 = fieldlabel_4,
	 fielddbtype	 = fielddbtype_5, fieldhtmltype = fieldhtmltype_6,	 type	 = type_7,
	 dsporder	 = dsporder_8,	 viewtype	 = viewtype_9 

WHERE 	( id	 = id_1);
end;
/



 CREATE or REPLACE  PROCEDURE HtmlLabelInfo_GetIndexId
        (labelname_1 	varchar2 ,
		flag out integer ,
		msg out varchar2,
		thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
 open thecursor for
select indexid from HtmlLabelInfo WHERE 	( labelname	 = labelname_1);
end;
/

/*2003.3.11 by chenyj */

 CREATE or REPLACE  PROCEDURE WorkFlow_Browser_Search
	(labelname_1 	varchar2,
		flag out integer ,
		msg out varchar2,
		thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
 open thecursor for
select id from  workflow_browserurl WHERE ( labelid	 = (select indexid from HtmlLabelInfo where labelname= labelname_1));
end;
/

 CREATE or REPLACE PROCEDURE WorkFlow_BrowserUrl_Insert
	(id_1 	integer,
	 labelid_2 	integer,
	 fielddbtype_3 	varchar2,
	 browserurl_4 	varchar2,
	 tablename_5 	varchar2,
	 columname_6 	varchar2,
	 keycolumname_7 	varchar2,
	 linkurl_8 	varchar2,
		flag out integer ,
		msg out varchar2,
		thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
INSERT INTO workflow_browserurl 
	 (  labelid,
	 fielddbtype,
	 browserurl,
	 tablename,
	 columname,
	 keycolumname,
	 linkurl) 
 
VALUES 
	( labelid_2,
	 fielddbtype_3,
	 browserurl_4,
	 tablename_5,
	 columname_6,
	 keycolumname_7,
	 linkurl_8);
end;
/


 CREATE or REPLACE  PROCEDURE WorkFlow_BrowserUrl_Update
	(id_1 	integer,
	 labelid_2 	integer,
	 fielddbtype_3 	varchar2,
	 browserurl_4 	varchar2,
	 tablename_5 	varchar2,
	 columname_6 	varchar2,
	 keycolumname_7 	varchar2,
	 linkurl_8 	varchar2,
		flag out integer ,
		msg out varchar2,
		thecursor IN OUT cursor_define.weavercursor) 
AS
begin
UPDATE workflow_browserurl 

SET  labelid	 = labelid_2,
	 fielddbtype	 = fielddbtype_3,
	 browserurl	 = browserurl_4,
	 tablename	 = tablename_5,
	 columname	 = columname_6,
	 keycolumname	 = keycolumname_7,
	 linkurl	 = linkurl_8 

WHERE 
	( id	 = id_1);
end;
/

 CREATE or REPLACE PROCEDURE WorkFlow_BrowserUrl_Delete
	(id_1 	integer, 		flag out integer ,
		msg out varchar2,
		thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
DELETE workflow_browserurl 

WHERE 
	( id	 = id_1);
end;
/


/*2003.3.11 by chenyj --end*/

alter table HrmResource add    
  status integer
/
  /*
  0:试用
  1:正式
  2:临时
  3:试用延期
  4:解聘
  5:离职
  6:退休
  7:无效
  */
alter table HrmResource add 
  fax varchar2(60)
/
 alter table HrmResource add 
  islabouunion char(1)
/
alter table HrmResource add 
  weight integer
/
alter table HrmResource add 
  tempresidentnumber varchar2(60)
/
alter table HrmResource add 
  probationenddate char(10)
/


alter table HrmResource drop
 column titleid
/
alter table HrmResource drop
 column firstname
/
alter table HrmResource drop
 column  aliasname
/
alter table HrmResource drop
 column  defaultlanguage
/ 
 alter table HrmResource drop
 column  marrydate
/
 alter table HrmResource drop
 column  countryid
/ 
 alter table HrmResource drop
 column  timezone
/ 
 alter table HrmResource drop
 column  homepostcode
/ 
 alter table HrmResource drop
 column  homephone
/ 
 alter table HrmResource drop
 column  contractdate
/ 
 alter table HrmResource drop
 column  jobgroup
/
 alter table HrmResource drop
 column  jobactivity
/ 
 alter table HrmResource drop
 column subcompanyid2
/ 
 alter table HrmResource drop
 column subcompanyid3
/ 
 alter table HrmResource drop
 column subcompanyid4
/ 
 alter table HrmResource drop
 column purchaselimit
/ 
 alter table HrmResource drop
 column currencyid
/ 
 alter table HrmResource drop
 column bankid2
/ 
 alter table HrmResource drop
 column accountid2
/
 alter table HrmResource drop
 column securityno
/
 alter table HrmResource drop
 column creditcard
/ 
 alter table HrmResource drop
 column expirydate
/ 
 alter table HrmResource drop
 column certificatecategory
/ 
 alter table HrmResource drop
 column bedemocracydate
/ 
 alter table HrmResource drop
 column homepage
/ 
 alter table HrmResource drop
 column train
/ 
 alter table HrmResource drop
 column worktype
/ 
 alter table HrmResource drop
 column contractbegintime
/ 
 alter table HrmResource drop
 column jobright
/ 
 alter table HrmResource drop
 column jobtype
/

create table HrmStatusHistory(
  id integer  NOT NULL,
  resourceid integer null,
  changedate char(10) null,
  changeenddate char(10) null,
  changereason varchar2(4000) null,
  changecontractid integer null,
  oldjobtitleid integer null,
  oldjoblevel integer null,
  newjobtitleid integer null,
  newjoblevel integer null,
  infoman varchar(255) null
)
/
create sequence HrmStatusHistory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmStatusHistory_Trigger
before insert on HrmStatusHistory
for each row
begin
select HrmStatusHistory_id.nextval into :new.id from dual;
end;
/
alter table HrmFamilyInfo drop
  column createid
/
alter table HrmFamilyInfo drop
  column createdate
/ 
  alter table HrmFamilyInfo drop
  column createtime
/ 
  alter table HrmFamilyInfo drop
  column lastmoderid
/
  alter table HrmFamilyInfo drop
  column lastmoddate
/ 
  alter table HrmFamilyInfo drop
  column lastmodtime
/

alter table HrmWorkResume drop
  column companystyle
/
  alter table HrmWorkResume drop
  column createid
/ 
  alter table HrmWorkResume drop
  column createdate
/ 
  alter table HrmWorkResume drop
  column createtime
/ 
  alter table HrmWorkResume drop
  column lastmoderid
/ 
  alter table HrmWorkResume drop
  column lastmoddate
/ 
  alter table HrmWorkResume drop
  column lastmodtime
/

alter table HrmEducationInfo drop
  column createid
/
  alter table HrmEducationInfo drop
  column createdate
/ 
  alter table HrmEducationInfo drop
  column createtime
/ 
  alter table HrmEducationInfo drop
  column lastmoderid
/ 
  alter table HrmEducationInfo drop
  column lastmoddate
/ 
  alter table HrmEducationInfo drop
  column lastmodtime
/

create table HrmTrainBeforeWork(
  id integer  not null,
  resourceid integer null,
  trainname varchar2(60) null,
  trainresource varchar2(60) null,
  trainstartdate char(10) null,
  trainenddate char(10) null,
  trainmemo varchar2(4000) null
)
/
create sequence HrmTrainBeforeWork_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainBeforeWork_Trigger
before insert on HrmTrainBeforeWork
for each row
begin
select HrmTrainBeforeWork_id.nextval into :new.id from dual;
end;
/

create table HrmRewardBeforeWork(
  id integer  not null,
  resourceid integer null,
  rewardname varchar2(200) null,
  rewarddate char(10) null,
  rewardmemo varchar2(4000) null
)
/
create sequence HrmRewardBeforeWork_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRewardBeforeWork_Trigger
before insert on HrmRewardBeforeWork
for each row
begin
select HrmRewardBeforeWork_id.nextval into :new.id from dual;
end;
/

alter table HrmBank drop
  column checkstr
/



alter table HrmSubCompany drop 
  column isdefault
/

alter table HrmDepartment drop
  column countryid
/
  alter table HrmDepartment drop
  column addedtax
/ 
  alter table HrmDepartment drop
  column website
/ 
  alter table HrmDepartment drop
  column startdate
/ 
  alter table HrmDepartment drop
  column enddate
/ 
  alter table HrmDepartment drop
  column currencyid
/ 
  alter table HrmDepartment drop
  column seclevel
/ 
  alter table HrmDepartment drop
  column subcompanyid2
/ 
  alter table HrmDepartment drop
  column subcompanyid3
/
 alter table HrmDepartment drop
  column subcompanyid4
/ 
  alter table HrmDepartment drop
  column createrid
/ 
  alter table HrmDepartment drop
  column createrdate
/ 
  alter table HrmDepartment drop
  column lastmoduserid
/ 
  alter table HrmDepartment drop
  column lastmoddate
/

alter table HrmDepartment add
  supdepid integer
/
  alter table HrmDepartment add
  allsupdepid varchar2(200)
/ 
  alter table HrmDepartment add
  showorder integer
/


 
 alter table HrmCostcenterSubCategory drop
   column isdefault
/

alter table HrmCostcenter drop
  column activable
/
  alter table HrmCostcenter drop
  column ccsubcategory2
/ 
  alter table HrmCostcenter drop
  column ccsubcategory3
/
  alter table HrmCostcenter drop
  column ccsubcategory4
/


alter table HrmJobTitles drop
  column seclevel
/
  alter table HrmJobTitles drop
  column joblevelfrom
/
  alter table HrmJobTitles drop
  column joblevelto
/
  alter table HrmJobTitles drop
  column docid
/ 
  alter table HrmJobTitles drop
  column jobgroupid
/

alter table HrmJobTitles add
  jobdepartmentid integer
/
  alter table HrmJobTitles add
  jobresponsibility varchar2(200)
/
  alter table HrmJobTitles add
  jobcompetency varchar2(200)
/

alter table HrmJobActivities drop
  column docid
/
 alter table HrmJobActivities drop
  column jobactivityremark
/

alter table HrmJobActivities add
  joblevelfrom int
/
  alter table HrmJobActivities add
  joblevelto int
/
 
alter table HrmJobGroups drop
  column docid
/
  alter table HrmJobGroups drop
  column jobgroupmark
/

alter table HrmCompany add
  companydesc varchar2(4000)
/
  alter table HrmCompany add
  companyweb varchar2(2200)
/

alter table HrmUserDefine add
  hasworkcode char(1)
/
  alter table HrmUserDefine add
  hasjobcall char(1)
/
  alter table HrmUserDefine add
  hasmobile char(1)
/
  alter table HrmUserDefine add
  hasmobilecall char(1)
/
  alter table HrmUserDefine add
  hasfax char(1)
/
  alter table HrmUserDefine add
  hasemail char(1)
/
  alter table HrmUserDefine add
  hasfolk char(1)
/
  alter table HrmUserDefine add
  hasregresidentplace char(1)
/
  alter table HrmUserDefine add
  hasnativeplace char(1)
/
  alter table HrmUserDefine add
  hascertificatenum char(1)
/
  alter table HrmUserDefine add
  hasmaritalstatus char(1)
/
  alter table HrmUserDefine add
  haspolicy char(1)
/
  alter table HrmUserDefine add
  hasbememberdate char(1)
/
  alter table HrmUserDefine add
  hasbepartydate char(1)
/
  alter table HrmUserDefine add
  hasislabouunion char(1)
/
  alter table HrmUserDefine add
  haseducationlevel char(1)
/
  alter table HrmUserDefine add
  hasdegree char(1)
/
  alter table HrmUserDefine add
  hashealthinfo char(1)
/
  alter table HrmUserDefine add
  hasheight char(1)
/
  alter table HrmUserDefine add
  hasweight char(1)
/
  alter table HrmUserDefine add
  hasresidentplace char(1)
/
  alter table HrmUserDefine add
  hashomeaddress char(1)
/
  alter table HrmUserDefine add
  hastempresidentnumber char(1)
/
  alter table HrmUserDefine add
  hasusekind char(1)
/
  alter table HrmUserDefine add
  hasbankid1 char(1)
/
  alter table HrmUserDefine add
  hasaccountid1 char(1)
/
  alter table HrmUserDefine add
  hasaccumfundaccount char(1)
/
  alter table HrmUserDefine add
  hasloginid char(1)
/
  alter table HrmUserDefine add
  hassystemlanguage char(1)
/


alter table HrmCertification drop 
  column createid
/
  alter table HrmCertification drop 
  column createdate
/
  alter table HrmCertification drop 
  column createtime
/
  alter table HrmCertification drop 
  column lastmoderid
/
  alter table HrmCertification drop 
  column lastmoddate
/
  alter table HrmCertification drop 
  column lastmodtime
/

alter table HrmSearchMould drop
  column subcompany2
/
  alter table HrmSearchMould drop
  column subcompany3
/
  alter table HrmSearchMould drop
  column subcompany4
/

alter table HrmSearchMould add
 resourceidfrom integer
/
 alter table HrmSearchMould add
 resourceidto integer
/
 alter table HrmSearchMould add
 workcode varchar2(60)
/
 alter table HrmSearchMould add
 jobcall integer
/
 alter table HrmSearchMould add
 mobile varchar2(60)
/
 alter table HrmSearchMould add
 mobilecall varchar2(60)
/
 alter table HrmSearchMould add
 fax varchar2(60)
/
 alter table HrmSearchMould add
 email varchar2(60)
/
 alter table HrmSearchMould add
 folk varchar2(30)
/
 alter table HrmSearchMould add
 nativeplace varchar2(100)
/
 alter table HrmSearchMould add
 regresidentplace varchar2(60)
/
 alter table HrmSearchMould add
 maritalstatus char(1)
/
 alter table HrmSearchMould add
 certificatenum varchar2(60)
/
 alter table HrmSearchMould add
 tempresidentnumber varchar2(60)
/
 alter table HrmSearchMould add
 residentplace varchar2(60)
/
 alter table HrmSearchMould add
 homeaddress varchar2(100)
/
 alter table HrmSearchMould add
 healthinfo char(1)
/
 alter table HrmSearchMould add
 heightfrom integer
/
 alter table HrmSearchMould add
 heightto integer
/
 alter table HrmSearchMould add
 weightfrom integer
/
 alter table HrmSearchMould add
 weightto integer
/
 alter table HrmSearchMould add
 educationlevel char(1)
/
 alter table HrmSearchMould add
 degree varchar2(30)
/
 alter table HrmSearchMould add
 usekind integer
/
 alter table HrmSearchMould add
 policy varchar2(30)
/
 alter table HrmSearchMould add
 bememberdatefrom char(10)
/
 alter table HrmSearchMould add
 bememberdateto char(10)
/
 alter table HrmSearchMould add
 bepartydatefrom char(10)
/
 alter table HrmSearchMould add
 bepartydateto char(10)
/
 alter table HrmSearchMould add
 islabouunion char(1)
/
 alter table HrmSearchMould add
 bankid1 integer
/
 alter table HrmSearchMould add
 accountid1 varchar2(100)
/
 alter table HrmSearchMould add
 accumfundaccount varchar2(30)
/
 alter table HrmSearchMould add
 loginid varchar2(60)
/
 alter table HrmSearchMould add
 systemlanguage integer
/

create table CheckDate
(nowdate char(10) not null  
)
/

INSERT INTO CheckDate (nowdate) VALUES (' ')
/

 CREATE or REPLACE PROCEDURE HrmCompany_Update 
 (id_1 	smallint, 
 companyname_2 	varchar2, 
 companydesc_3 varchar2 ,
 companyweb_4 varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE HrmCompany  SET  companyname = companyname_2 ,companydesc = companydesc_3, companyweb = companyweb_4 WHERE ( id = id_1) ;
end;
/

 CREATE or REPLACE PROCEDURE HrmSubCompany_Insert 
 (subcompanyname_1 	varchar2,
 subcompanydesc_2 	varchar2,
 companyid_3 	smallint, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 begin
 INSERT INTO HrmSubCompany ( subcompanyname, subcompanydesc, companyid) 
 VALUES ( subcompanyname_1, subcompanydesc_2, companyid_3);
open thecursor for
 select (max(id)) from HrmSubCompany ;
end;
/


 CREATE or REPLACE PROCEDURE HrmSubCompany_Update 
 (id_1 	integer,
 subcompanyname_2 	varchar2, 
 subcompanydesc_3 	varchar2, 
 companyid_4 	smallint, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE HrmSubCompany  
 SET  
 subcompanyname	 = subcompanyname_2, 
 subcompanydesc	 = subcompanydesc_3,
 companyid	 = companyid_4  WHERE ( id	 = id_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmDepartment_Update 
 (id_1 integer, 
 departmentmark_2 varchar2,
 departmentname_3 varchar2, 
  supdepid_4 integer,
  allsupdepid_5 varchar2,
   subcompanyid1_6 	integer,
   showorder_7 integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
   AS
begin
   UPDATE HrmDepartment  
   SET  
   departmentmark = departmentmark_2, 
   departmentname	= departmentname_3, 
   supdepid = supdepid_4,
   allsupdepid = allsupdepid_5,
   subcompanyid1 = subcompanyid1_6,  
   showorder = showorder_7
   WHERE ( id	 = id_1); 
end;
/


 CREATE or REPLACE PROCEDURE HrmDepartment_Select 
(
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
open thecursor for
 select * from HrmDepartment order by showorder; 
end;
/


  CREATE or REPLACE PROCEDURE HrmDepartment_Insert 
 (
 departmentmark_1 varchar2,
 departmentname_2 	varchar2,  
  supdepid_3 integer,
  allsupdepid_4 varchar2,
 subcompanyid1_5 integer,
 showorder_6 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS  
 begin
 INSERT INTO HrmDepartment
 ( departmentmark, departmentname, supdepid, allsupdepid, subcompanyid1, showorder) 
 VALUES ( departmentmark_1, departmentname_2, supdepid_3, allsupdepid_4, subcompanyid1_5, showorder_6) ;
open thecursor for
 select (max(id)) from HrmDepartment ;
 end;
/



 CREATE or REPLACE PROCEDURE HrmCostcenter_Insert 
 (costcentermark_1 varchar2, 
  costcentername_2 varchar2, 
  departmentid_4 integer, 
  ccsubcategory1_5 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)   
 AS
 begin
 INSERT INTO HrmCostcenter ( 
  costcentermark, 
  costcentername,  
  departmentid, 
  ccsubcategory1 )
 VALUES ( 
  costcentermark_1, 
  costcentername_2,  
  departmentid_4, 
  ccsubcategory1_5 );
open thecursor for
 select max(id) from HrmCostcenter  ;
 end;
/



 CREATE or REPLACE PROCEDURE HrmCostcenter_Update 
 (
 id_1 integer,
 costcentermark_2 varchar2, 
 costcentername_3 varchar2, 
  departmentid_5 integer,
  ccsubcategory1_6 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
  AS
  begin
  UPDATE HrmCostcenter  
  SET  costcentermark = costcentermark_2, costcentername = costcentername_3, 
  departmentid = departmentid_5, ccsubcategory1 = ccsubcategory1_6  WHERE ( id	 = id_1) ;
end;
/


alter table HrmCostcenterMainCategory add
  ccmaincategorydesc varchar2(4000)
/



  CREATE or REPLACE PROCEDURE HrmCostcenterMainCategory_U 
 (id_1	smallint,
 ccmaincategoryname_2 varchar2, 
 ccmaincategorydesc_3 varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 UPDATE HrmCostcenterMainCategory  
 SET  ccmaincategoryname = ccmaincategoryname_2, ccmaincategorydesc = ccmaincategorydesc_3  
 WHERE ( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE HrmJobGroups_Insert 
 ( jobgroupname_2 	varchar2,  
 jobgroupremark_4 varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
   AS 
   begin
   INSERT INTO HrmJobGroups ( jobgroupname,  jobgroupremark)  
   VALUES ( jobgroupname_2, jobgroupremark_4); 
   open thecursor for
   select max(id) from HrmJobGroups ;
end;
/

 CREATE or REPLACE PROCEDURE HrmJobGroups_Update 
 (id_1 integer, 
 jobgroupname_3 	varchar2, 
 jobgroupremark_5	varchar2,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
  AS 
  begin
  UPDATE HrmJobGroups  
  SET  jobgroupname = jobgroupname_3, jobgroupremark = jobgroupremark_5  
  WHERE ( id	 = id_1) ;
end;
/

 CREATE or REPLACE PROCEDURE HrmJobActivities_Insert 
 (jobactivitymark_1 	varchar2,
 jobactivityname_2 	varchar2,
 joblevelfrom_3	integer, 
  joblevelto_4 	integer, 
  jobgroupid_5 	integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
  AS
  begin
  INSERT INTO HrmJobActivities ( jobactivitymark, jobactivityname, joblevelfrom, joblevelto, jobgroupid) 
  VALUES ( jobactivitymark_1, jobactivityname_2, joblevelfrom_3, joblevelto_4, jobgroupid_5) ;  
 open thecursor for 
 select max(id) from  HrmJobActivities ;
end;
/


 CREATE or REPLACE PROCEDURE HrmJobActivities_Update 
 (id_1	integer, 
 jobactivitymark_2 varchar2, 
 jobactivityname_3 varchar2,
 joblevelfrom_4 integer, 
 joblevelto_5 integer, 
  jobgroupid_6 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
  AS 
  begin
  UPDATE HrmJobActivities  SET  
  jobactivitymark	= jobactivitymark_2, 
  jobactivityname	 = jobactivityname_3,
  joblevelfrom	 = joblevelfrom_4, 
  joblevelto	 = joblevelto_5, 
  jobgroupid	 = jobgroupid_6  
  WHERE ( id	 = id_1) ;
end;
/


  CREATE or REPLACE PROCEDURE HrmJobTitles_Insert 
 (jobtitlemark_1 varchar2,
 jobtitlename_2 varchar2,
 jobdepartmentid_3 integer, 
  jobactivityid_4 integer,
  jobresponsibility_5 	varchar2,
  jobcompetency_6 	varchar2,
  jobtitleremark_7 varchar2,
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  INSERT INTO HrmJobTitles ( jobtitlemark, jobtitlename, jobdepartmentid, 
  jobactivityid, jobresponsibility, jobcompetency, jobtitleremark) 
  VALUES ( jobtitlemark_1, jobtitlename_2, jobdepartmentid_3, jobactivityid_4, jobresponsibility_5,
  jobcompetency_6, jobtitleremark_7);
  open thecursor for
  select max(id) from  HrmJobTitles ;
end;
/



  CREATE or REPLACE PROCEDURE HrmJobTitles_Update 
 (id_1 integer, 
 jobtitlemark_2 	varchar2,
 jobtitlename_3 	varchar2, 
  jobdepartmentid_4 	integer,
  jobactivityid_5 integer,
  jobresponsibility_6	varchar2, 
  jobcompetency_7 varchar2,
  jobtitleremark_8 varchar2,
  flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  UPDATE HrmJobTitles  SET 
  jobtitlemark = jobtitlemark_2, jobtitlename = jobtitlename_3, 
  jobdepartmentid = jobdepartmentid_4, jobactivityid	 = jobactivityid_5, 
  jobresponsibility = jobresponsibility_6, jobcompetency = jobcompetency_7, jobtitleremark	 = jobtitleremark_8
  WHERE ( id	 = id_1);
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Insert
(id_1 integer, 
 workcode_2 varchar2, 
 lastname_3 varchar2,  
 sex_5 char, 
 resoureimageid_6 integer, 
 departmentid_7 integer, 
 costcenterid_8 integer, 
 jobtitle_9 integer, 
 joblevel_10 integer,
 jobactivitydesc_11 varchar2, 
 managerid_12 integer, 
 assistantid_13 integer, 
 status_14 char,
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 INSERT INTO HrmResource 
 (id,
 workcode,
 lastname,
 sex,
 resourceimageid,
 departmentid,
 costcenterid,
 jobtitle,
 joblevel,
 jobactivitydesc,
 managerid,
 assistantid,
 status,
 locationid,
 workroom,
 telephone,
 mobile,
 mobilecall,
 fax
 )
 VALUES
 (id_1, 
  workcode_2, 
  lastname_3, 
  sex_5, 
  resoureimageid_6, 
  departmentid_7, 
  costcenterid_8, 
  jobtitle_9, 
  joblevel_10, 
  jobactivitydesc_11, 
  managerid_12, 
  assistantid_13, 
  status_14, 
  locationid_15,
  workroom_16, 
  telephone_17, 
  mobile_18, 
  mobilecall_19, 
  fax_20
);
end;
/


 CREATE or REPLACE PROCEDURE HrmResourcePersonalInfo_Insert
( id_1 integer, 
  birthday_2 char, 
  folk_3 varchar2, 
  nativeplace_4 varchar2, 
  regresidentplace_5 varchar2, 
  maritalstatus_6 char, 
  policy_7 varchar2,
  bememberdate_8 char, 
  bepartydate_9 char, 
  islabouunion_10 char,
  educationlevel_11 char, 
  degree_12 varchar2, 
  healthinfo_13  char, 
  height_14 integer,
  weight_15 integer, 
  residentplace_16 varchar2, 
  homeaddress_17 varchar2,
  tempresidentnumber_18 varchar2, 
  certificatenum_19 varchar2,
  flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
  UPDATE HrmResource SET 
  birthday = birthday_2,
  folk = folk_3,
  nativeplace = nativeplace_4,
  regresidentplace = regresidentplace_5,
  maritalstatus = maritalstatus_6,
  policy = policy_7,
  bememberdate = bememberdate_8,
  bepartydate = bepartydate_9,
  islabouunion = islabouunion_10,
  educationlevel = educationlevel_11,
  degree = degree_12,
  healthinfo = healthinfo_13,
  height = height_14,
  weight = weight_15,
  residentplace = residentplace_16,
  homeaddress = homeaddress_17,
  tempresidentnumber = tempresidentnumber_18,
  certificatenum = certificatenum_19
WHERE
  id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceWorkInfo_Insert
(id_1 integer,
 usekind_2 integer, 
 startdate_3 char,
 probationenddate_4 char, 
 enddate_5 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
UPDATE HrmResource SET
 usekind = usekind_2,
 startdate = startdate_3,
 probationenddate = probationenddate_4,
 enddate = enddate_5 
WHERE
 id = id_1;
end;
/



 CREATE or REPLACE PROCEDURE HrmResourceFinanceInfo_Insert
(id_1 integer,
 bankid1_2 integer,
 accountid1_3 varchar2,
 accumfundaccount_4 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
UPDATE HrmResource SET
 bankid1 = bankid1_2,
 accountid1 = accountid1_3 ,
 accumfundaccount = accumfundaccount_4
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceSystemInfo_Insert
(id_1 integer,
 loginid_2 varchar2,
 password_3 varchar2,
 systemlanguage_4 integer,
 seclevel_5 integer,
 email_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
UPDATE HrmResource SET
 loginid = loginid_2,
 password = password_3,
 systemlanguage = systemlanguage_4,
 seclevel = seclevel_5,
 email = email_6
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE  PROCEDURE Employee_SelectByHrmid
 (
	hrmid_1    integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 begin
open thecursor for
select itemid,status from HrmInfoStatus WHERE hrmid=hrmid_1 AND itemid<10  order by itemid;
end;
/



 CREATE or REPLACE  PROCEDURE Employee_LoginUpdate
 (
	loginid_1 varchar2,
	password_1 varchar2,
	hrmid_1  integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as

count_1 integer;
begin
/*判断是否有重复登录名*/
select count(*) INTO count_1 from HrmResource where loginid = loginid_1 and id<>hrmid_1;
if count_1<>0 then
	open thecursor for
	select -1 from dual;
	return;
else 
	if password_1 = 'novalue$1'   then 	
	update HrmResource
	set
	loginid=loginid_1,
	systemlanguage=7,	
	resourcetype='2',
	seclevel=10
	WHERE id= hrmid_1	;
	else
	
	update HrmResource
	set
	loginid=loginid_1,
	password=password_1,
	systemlanguage=7,	
	resourcetype='2',
	seclevel=10
	WHERE id= hrmid_1;
	end if;
end if;
update HrmInfoStatus
set
status = '1'
WHERE itemid=1 AND hrmid=hrmid_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Fire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5);
UPDATE HrmResource SET
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Hire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 infoman_5 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 infoman_5);
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Extend
(id_1 integer,
 changedate_2 char,
 changeenddate_3 char,
 changereason_4 char,
 changecontractid_5 integer,
 infoman_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman)
VALUES
(id_1, 
 changedate_2,
 changeenddate_3,
 changereason_4,
 changecontractid_5,
 infoman_6);
UPDATE HrmResource SET
 enddate = changeenddate_3
WHERE
 id = id_1;
end;
/



 CREATE or REPLACE PROCEDURE HrmResource_Redeploy
(id_1 integer,
 changedate_2 char,
 changereason_4 char,
 oldjobtitleid_7 integer,
 oldjoblevel_8 integer,
 newjobtitleid_9 integer,
 newjoblevel_10 integer,
 infoman_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 oldjobtitleid,
 oldjoblevel,
 newjobtitleid,
 newjoblevel,
 infoman)
VALUES
(id_1, 
 changedate_2,
 changereason_4,
 oldjobtitleid_7,
 oldjoblevel_8,
 newjobtitleid_9,
 newjoblevel_10,
 infoman_6);
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Rehire
(id_1 integer,
 changedate_2 char,
 changeenddate_3 char,
 changereason_4 char,
 changecontractid_5 integer,
 infoman_6 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman)
VALUES
(id_1, 
 changedate_2,
 changeenddate_3,
 changereason_4,
 changecontractid_5,
 infoman_6);
UPDATE HrmResource SET
 startdate = changedate_2,
 enddate = changeenddate_3
WHERE
 id = id_1;
end;
/



 CREATE or REPLACE  PROCEDURE HrmFamilyInfo_Insert 
 (resourceid_1 	integer, 
  member_2 	varchar2,
  title_3 	varchar2,
  company_4 	varchar2, 
  jobtitle_5 	varchar2,
  address_6 	varchar2,
   flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  
AS 
begin
INSERT INTO HrmFamilyInfo 
 ( resourceid, 
   member, 
   title, 
   company, 
   jobtitle, 
   address) 
VALUES 
( resourceid_1, 
  member_2, 
  title_3, 
  company_4, 
  jobtitle_5, 
  address_6  ) ;
end;
/


 CREATE or REPLACE  PROCEDURE HrmWorkResume_Insert 
 (resourceid_1 	integer, 
  startdate_2 	char,
  enddate_3 	char,
  company_4 	varchar2,   
  jobtitle_6 	varchar2, 
  workdesc_7 	varchar2, 
  leavereason_8 	varchar2, 
   flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )  
AS 
begin
INSERT INTO HrmWorkResume 
( resourceid, 
  startdate, 
  enddate, 
  company,  
  jobtitle, 
  workdesc, 
  leavereason )  
VALUES 
( resourceid_1, 
  startdate_2, 
  enddate_3, 
  company_4, 
  jobtitle_6, 
  workdesc_7, 
  leavereason_8)  ; 
end;
/









 CREATE or REPLACE  PROCEDURE HrmEducationInfo_Insert 
 (resourceid_1 	integer,
  startdate_2 	char,
  enddate_3 	char, 
  school_4 	varchar2, 
  speciality_5 	varchar2,
  educationlevel_6 	char,
  studydesc_7 	varchar2,
   flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
INSERT INTO HrmEducationInfo 
( resourceid, 
  startdate, 
  enddate, 
  school, 
  speciality, 
  educationlevel, 
  studydesc)
 VALUES 
( resourceid_1, 
  startdate_2,
  enddate_3,
  school_4,
  speciality_5,
  educationlevel_6,
  studydesc_7); 
end;
/




 CREATE or REPLACE  PROCEDURE HrmTrainBeforeWork_Insert 
 (resourceid_1 	integer,
  trainname_2 	varchar2, 
  trainresource_3 	varchar2,
  trainstartdate_4 	char,
  trainenddate_5 	char,  
  trainmemo_6 varchar2,
   flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
INSERT INTO HrmTrainBeforeWork 
( resourceid, 
  trainname,
  trainresource,
  trainstartdate, 
  trainenddate,
  trainmemo)
 VALUES 
( resourceid_1, 
  trainname_2,
  trainresource_3,
  trainstartdate_4,
  trainenddate_5,
  trainmemo_6); 
end;
/


CREATE or REPLACE  PROCEDURE HrmRewardBeforeWork_Insert 
 (resourceid_1 	integer,
  rewardname_2 	varchar2, 
  rewarddate_3 	char,
  rewardmemo_4       varchar2,
   flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
INSERT INTO HrmRewardBeforeWork 
( resourceid, 
  rewardname,
  rewarddate,
  rewardmemo)
 VALUES 
( resourceid_1, 
  rewardname_2,
  rewarddate_3,
  rewardmemo_4); 
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Update
(id_1 integer, 
 workcode_2 varchar2, 
 lastname_3 varchar2, 
 sex_5 char, 
 resoureimageid_6 integer, 
 departmentid_7 integer, 
 costcenterid_8 integer, 
 jobtitle_9 integer, 
 joblevel_10 integer,
 jobactivitydesc_11 varchar2, 
 managerid_12 integer, 
 assistantid_13 integer, 
 status_14 char,
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 UPDATE HrmResource SET
 workcode =   workcode_2,
 lastname =  lastname_3,
 sex =   sex_5, 
 resourceimageid =   resoureimageid_6, 
 departmentid =   departmentid_7, 
 costcenterid =   costcenterid_8, 
 jobtitle =   jobtitle_9, 
 joblevel =   joblevel_10, 
 jobactivitydesc =   jobactivitydesc_11, 
 managerid =   managerid_12, 
 assistantid =   assistantid_13, 
 status =   status_14, 
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20 
 WHERE
 id =  id_1; 
 end;
/


 CREATE or REPLACE PROCEDURE HrmResourceContactInfo_Update
(id_1 integer, 
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS
 begin
 UPDATE HrmResource SET
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20 
 WHERE
 id =  id_1; 
 end;
/


 CREATE or REPLACE PROCEDURE HrmFamilyInfo_Delete
(id_1 integer, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 DELETE HrmFamilyInfo 
 WHERE 
 resourceid = id_1;
end;
/



 CREATE or REPLACE PROCEDURE HrmResource_SelectAll 
 ( flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
  open thecursor for
  select 
  id,
  loginid,
  lastname,  
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  joblevel,
  seclevel from HrmResource ;
  end;
/

alter table HrmStatusHistory add
type_n integer null
/*
1、解聘
2、转正
3、续签
4、调动
5、离职
6、退休
7、反聘
*/
/

 CREATE or REPLACE PROCEDURE HrmResource_UpdateManagerStr
(id_1 integer,
 managerstr_2 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
UPDATE HrmResource SET
  managerstr = managerstr_2
WHERE
  id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Fire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,  
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7 ,
 type_n_8 );
UPDATE HrmResource SET
 status = '4',
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Hire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,  
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman,
 oldjobtitleid,
 type_n  )
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 infoman_5,
 oldjobtitleid_7 ,
 type_n_8   );
update HrmResource set
 status = '1'
where 
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Extend
(id_1 integer,
 changedate_2 char,
 changeenddate_3 char,
 changereason_4 char,
 changecontractid_5 integer,
 infoman_6 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changeenddate_3,
 changereason_4,
 changecontractid_5,
 infoman_6,
 oldjobtitleid_7 ,
 type_n_8);
UPDATE HrmResource SET
 enddate = changeenddate_3
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Redeploy
(id_1 integer,
 changedate_2 char,
 changereason_4 char,
 oldjobtitleid_7 integer,
 oldjoblevel_8 integer,
 newjobtitleid_9 integer,
 newjoblevel_10 integer,
 infoman_6 varchar2,
 type_n_11 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 oldjobtitleid,
 oldjoblevel,
 newjobtitleid,
 newjoblevel,
 infoman,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_4,
 oldjobtitleid_7,
 oldjoblevel_8,
 newjobtitleid_9,
 newjoblevel_10,
 infoman_6,
 type_n_11);
end;
/

 CREATE or REPLACE PROCEDURE HrmResource_Dismiss
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7,
 type_n_8);
UPDATE HrmResource SET
 status = '5',
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Retire
(id_1 integer,
 changedate_2 char,
 changereason_3 char,
 changecontractid_4 integer,
 infoman_5 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(id_1, 
 changedate_2,
 changereason_3,
 changecontractid_4,
 infoman_5,
 oldjobtitleid_7,
 type_n_8);
UPDATE HrmResource SET
 status = '6',
 enddate = changedate_2
WHERE
 id = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResource_Rehire
(id_1 integer,
 changedate_2 char,
 changeenddate_3 char,
 changereason_4 char,
 changecontractid_5 integer,
 infoman_6 varchar2,
 oldjobtitleid_7 integer,
 type_n_8 char,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n
)
VALUES
(id_1, 
 changedate_2,
 changeenddate_3,
 changereason_4,
 changecontractid_5,
 infoman_6,
 oldjobtitleid_7 ,
 type_n_8
 );
UPDATE HrmResource SET
 status = '1',
 startdate = changedate_2,
 enddate = changeenddate_3
WHERE
 id = id_1;
end;
/



 CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Insert
(id_1 integer, 
 workcode_2 varchar2, 
 lastname_3 varchar2,  
 sex_5 char, 
 resoureimageid_6 integer, 
 departmentid_7 integer, 
 costcenterid_8 integer, 
 jobtitle_9 integer, 
 joblevel_10 integer,
 jobactivitydesc_11 varchar2, 
 managerid_12 integer, 
 assistantid_13 integer, 
 status_14 char,
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2,
 jobcall_21 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 INSERT INTO HrmResource 
 (id,
 workcode,
 lastname,
 sex,
 resourceimageid,
 departmentid,
 costcenterid,
 jobtitle,
 joblevel,
 jobactivitydesc,
 managerid,
 assistantid,
 status,
 locationid,
 workroom,
 telephone,
 mobile,
 mobilecall,
 fax,
 jobcall
 )
 VALUES
 (id_1, 
  workcode_2, 
  lastname_3, 
  sex_5, 
  resoureimageid_6, 
  departmentid_7, 
  costcenterid_8, 
  jobtitle_9, 
  joblevel_10, 
  jobactivitydesc_11, 
  managerid_12, 
  assistantid_13, 
  status_14, 
  locationid_15,
  workroom_16, 
  telephone_17, 
  mobile_18, 
  mobilecall_19, 
  fax_20,
  jobcall_21
);
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Update
(id_1 integer, 
 workcode_2 varchar2, 
 lastname_3 varchar2, 
 sex_5 char, 
 resoureimageid_6 integer, 
 departmentid_7 integer, 
 costcenterid_8 integer, 
 jobtitle_9 integer, 
 joblevel_10 integer,
 jobactivitydesc_11 varchar2, 
 managerid_12 integer, 
 assistantid_13 integer, 
 status_14 char,
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 jobcall_21 integer,
 systemlanguage_22 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS
 begin
 UPDATE HrmResource SET
 workcode =   workcode_2,
 lastname =  lastname_3,
 sex =   sex_5, 
 resourceimageid =   resoureimageid_6, 
 departmentid =   departmentid_7, 
 costcenterid =   costcenterid_8, 
 jobtitle =   jobtitle_9, 
 joblevel =   joblevel_10, 
 jobactivitydesc =   jobactivitydesc_11, 
 managerid =   managerid_12, 
 assistantid =   assistantid_13, 
 status =   status_14, 
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20,
 jobcall = jobcall_21,
 systemlanguage = systemlanguage_22
 WHERE
 id =  id_1; 
 end;
/


  CREATE or REPLACE PROCEDURE HrmCertification_Insert 
	(resourceid_1 	integer,
	 datefrom_2 	char,
	 dateto_3 	char,
	 certname_4 	varchar2,
	 awardfrom_5 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO HrmCertification 
	 ( resourceid,
	 datefrom,
	 dateto,
	 certname,
	 awardfrom)	
VALUES 
	( resourceid_1,
	 datefrom_2,
	 dateto_3,
	 certname_4,
	 awardfrom_5);
end;
/


  CREATE or REPLACE PROCEDURE HrmCertification_Update 
	(id_1 	integer,
	 resourceid_2 	integer,
	 datefrom_3 	char,
	 dateto_4 	char,
	 certname_5 	varchar2,
	 awardfrom_6 	varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS
begin
UPDATE HrmCertification 

SET  resourceid	 = resourceid_2,
	 datefrom	 = datefrom_3,
	 dateto	 = dateto_4,
	 certname	 = certname_5,
	 awardfrom	 = awardfrom_6
WHERE 
	( id	 = id_1);

UPDATE HrmResource SET status = 1;
end;
/


 CREATE or REPLACE PROCEDURE HrmResourceContactInfo_Update
(id_1 integer, 
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 systemlanguage_21 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS
 begin
 UPDATE HrmResource SET
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20 ,
 systemlanguage = systemlanguage_21
 WHERE
 id =  id_1 ;
 end;
/


  CREATE or REPLACE PROCEDURE HrmCostcenterSubCategory_D 
 (id_1 integer, 
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
DELETE HrmCostcenterSubCategory  
 WHERE ( id	 = id_1) ;
end;
/


  CREATE or REPLACE PROCEDURE HrmUserDefine_Insert 
 	(userid_1 		integer,
	 hasresourceid_2 	char,
	 hasresourcename_3 	char,
	 hasjobtitle_4 	char,
	 hasactivitydesc_5 	char,
	 hasjobgroup_6 	char,
	 hasjobactivity_7 	char,
	 hascostcenter_8 	char,
	 hascompetency_9 	char,
	 hasresourcetype_10 	char,
	 hasstatus_11 		char,
	 hassubcompany_12 	char,
	 hasdepartment_13 	char,
	 haslocation_14 	char,
	 hasmanager_15 	char,
	 hasassistant_16 	char,
	 hasroles_17 		char,
	 hasseclevel_18 	char,
	 hasjoblevel_19 	char,
	 hasworkroom_20 	char,
	 hastelephone_21 	char,
	 hasstartdate_22 	char,
	 hasenddate_23 	char,
	 hascontractdate_24 	char,
	 hasbirthday_25 	char,
	 hassex_26 		char,
	 projectable_27 	char,
	 crmable_28 		char,
	 itemable_29 		char,
	 docable_30 		char,
	 workflowable_31 	char,
	 subordinateable_32 	char,
	 trainable_33 		char,
	 budgetable_34 	char,
	 fnatranable_35 	char,
	 dspperpage_36 	smallint,
	 hasage_37 		char,
	 hasworkcode_38 	char,
	 hasjobcall_39 	char,
	 hasmobile_40 		char,
	 hasmobilecall_41 	char,
	 hasfax_42 		char,
	 hasemail_43 		char,
	 hasfolk_44 		char,
	 hasregresidentplace_45 char,
	 hasnativeplace_46 	char,
	 hascertificatenum_47 	char,
	 hasmaritalstatus_48 	char,
	 haspolicy_49 		char,
	 hasbememberdate_50 	char,
	 hasbepartydate_51 	char,
	 hasislabouunion_52 	char,
	 haseducationlevel_53 	char,
	 hasdegree_54 		char,
	 hashealthinfo_55 	char,
	 hasheight_56 		char,
	 hasweight_57 		char,
	 hasresidentplace_58 	char,
	 hashomeaddress_59 	char,
	 hastempresidentnumber_60 	char,
	 hasusekind_61 	char,
	 hasbankid1_62 	char,
	 hasaccountid1_63 	char,
	 hasaccumfundaccount_64 char,
	 hasloginid_65 	char,
	 hassystemlanguage_66 	char,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
AS 
recordercount integer;
begin
 Select   count(userid) INTO recordercount from HrmUserDefine 
where userid =  to_number(userid_1);
 if recordercount = 0 then
  INSERT INTO HrmUserDefine
	 (userid,
	 hasresourceid,
	 hasresourcename,
	 hasjobtitle,
	 hasactivitydesc,
	 hasjobgroup,
	 hasjobactivity,
	 hascostcenter,
	 hascompetency,
	 hasresourcetype,
	 hasstatus,
	 hassubcompany,
	 hasdepartment,
	 haslocation,
	 hasmanager,
	 hasassistant,
	 hasroles,
	 hasseclevel,
	 hasjoblevel,
	 hasworkroom,
	 hastelephone,
	 hasstartdate,
	 hasenddate,
	 hascontractdate,
	 hasbirthday,
	 hassex,
	 projectable,
	 crmable,
	 itemable,
	 docable,
	 workflowable,
	 subordinateable,
	 trainable,
	 budgetable,
	 fnatranable,
	 dspperpage,
	 hasage,
	 hasworkcode,
	 hasjobcall,
	 hasmobile,
	 hasmobilecall,
	 hasfax,
	 hasemail,
	 hasfolk,
	 hasregresidentplace,
	 hasnativeplace,
	 hascertificatenum,
	 hasmaritalstatus,
	 haspolicy,
	 hasbememberdate,
	 hasbepartydate,
	 hasislabouunion,
	 haseducationlevel,
	 hasdegree,
	 hashealthinfo,
	 hasheight,
	 hasweight,
	 hasresidentplace,
	 hashomeaddress,
	 hastempresidentnumber,
	 hasusekind,
	 hasbankid1,
	 hasaccountid1,
	 hasaccumfundaccount,
	 hasloginid,
	 hassystemlanguage) 
VALUES 
	(userid_1,
	 hasresourceid_2,
	 hasresourcename_3,
	 hasjobtitle_4,
	 hasactivitydesc_5,
	 hasjobgroup_6,
	 hasjobactivity_7,
	 hascostcenter_8,
	 hascompetency_9,
	 hasresourcetype_10,
	 hasstatus_11,
	 hassubcompany_12,
	 hasdepartment_13,
	 haslocation_14,
	 hasmanager_15,
	 hasassistant_16,
	 hasroles_17,
	 hasseclevel_18,
	 hasjoblevel_19,
	 hasworkroom_20,
	 hastelephone_21,
	 hasstartdate_22,
	 hasenddate_23,
	 hascontractdate_24,
	 hasbirthday_25,
	 hassex_26,
	 projectable_27,
	 crmable_28,
	 itemable_29,
	 docable_30,
	 workflowable_31,
	 subordinateable_32,
	 trainable_33,
	 budgetable_34,
	 fnatranable_35,
	 dspperpage_36,
	 hasage_37,
	 hasworkcode_38,
	 hasjobcall_39,
	 hasmobile_40,
	 hasmobilecall_41,
	 hasfax_42,
	 hasemail_43,
	 hasfolk_44,
	 hasregresidentplace_45,
	 hasnativeplace_46,
	 hascertificatenum_47,
	 hasmaritalstatus_48,
	 haspolicy_49,
	 hasbememberdate_50,
	 hasbepartydate_51,
	 hasislabouunion_52,
	 haseducationlevel_53,
	 hasdegree_54,
	 hashealthinfo_55,
	 hasheight_56,
	 hasweight_57,
	 hasresidentplace_58,
	 hashomeaddress_59,
	 hastempresidentnumber_60,
	 hasusekind_61,
	 hasbankid1_62,
	 hasaccountid1_63,
	 hasaccumfundaccount_64,
	 hasloginid_65,
	 hassystemlanguage_66);
 else 
  UPDATE HrmUserDefine  SET  
	 hasresourceid	 = hasresourceid_2,
	 hasresourcename	 = hasresourcename_3,
	 hasjobtitle		 = hasjobtitle_4,
	 hasactivitydesc	 = hasactivitydesc_5,
	 hasjobgroup		 = hasjobgroup_6,
	 hasjobactivity	 = hasjobactivity_7,
	 hascostcenter	 = hascostcenter_8,
	 hascompetency	 = hascompetency_9,
	 hasresourcetype	 = hasresourcetype_10,
	 hasstatus		 = hasstatus_11,
	 hassubcompany	 = hassubcompany_12,
	 hasdepartment	 = hasdepartment_13,
	 haslocation	 = haslocation_14,
	 hasmanager	 = hasmanager_15,
	 hasassistant	 = hasassistant_16,
	 hasroles	 = hasroles_17,
	 hasseclevel	 = hasseclevel_18,
	 hasjoblevel	 = hasjoblevel_19,
	 hasworkroom	 = hasworkroom_20,
	 hastelephone	 = hastelephone_21,
	 hasstartdate	 = hasstartdate_22,
	 hasenddate	 = hasenddate_23,
	 hascontractdate	 = hascontractdate_24,
	 hasbirthday	 = hasbirthday_25,
	 hassex	 = hassex_26,
	 projectable	 = projectable_27,
	 crmable	 = crmable_28,
	 itemable	 = itemable_29,
	 docable	 = docable_30,
	 workflowable	 = workflowable_31,
	 subordinateable	 = subordinateable_32,
	 trainable	 = trainable_33,
	 budgetable	 = budgetable_34,
	 fnatranable	 = fnatranable_35,
	 dspperpage	 = dspperpage_36,
	 hasage	 = hasage_37,
	 hasworkcode	 = hasworkcode_38,
	 hasjobcall	 = hasjobcall_39,
	 hasmobile	 = hasmobile_40,
	 hasmobilecall	 = hasmobilecall_41,
	 hasfax	 = hasfax_42,
	 hasemail	 = hasemail_43,
	 hasfolk	 = hasfolk_44,
	 hasregresidentplace	 = hasregresidentplace_45,
	 hasnativeplace	 = hasnativeplace_46,
	 hascertificatenum	 = hascertificatenum_47,
	 hasmaritalstatus	 = hasmaritalstatus_48,
	 haspolicy	 = haspolicy_49,
	 hasbememberdate	 = hasbememberdate_50,
	 hasbepartydate	 = hasbepartydate_51,
	 hasislabouunion	 = hasislabouunion_52,
	 haseducationlevel	 = haseducationlevel_53,
	 hasdegree	 = hasdegree_54,
	 hashealthinfo	 = hashealthinfo_55,
	 hasheight	 = hasheight_56,
	 hasweight	 = hasweight_57,
	 hasresidentplace	 = hasresidentplace_58,
	 hashomeaddress	 = hashomeaddress_59,
	 hastempresidentnumber	 = hastempresidentnumber_60,
	 hasusekind	 = hasusekind_61,
	 hasbankid1	 = hasbankid1_62,
	 hasaccountid1	 = hasaccountid1_63,
	 hasaccumfundaccount	 = hasaccumfundaccount_64,
	 hasloginid	 = hasloginid_65,
	 hassystemlanguage	 = hassystemlanguage_66 
WHERE ( userid	 = userid_1);
end if;
end;
/


 CREATE or REPLACE PROCEDURE HrmSearchMould_Insert
	(mouldname_1 	varchar2,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	integer,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS
begin
INSERT INTO HrmSearchMould 
	 ( mouldname,
	 userid,
	 resourceid,
	 resourcename,
	 jobtitle,
	 activitydesc,
	 jobgroup,
	 jobactivity,
	 costcenter,
	 competency,
	 resourcetype,
	 status,
	 subcompany1,
	 department,
	 location,
	 manager,
	 assistant,
	 roles,
	 seclevel,
	 joblevel,
	 workroom,
	 telephone,
	 startdate,
	 enddate,
	 contractdate,
	 birthday,
	 sex,
	 seclevelTo,
	 joblevelTo,
	 startdateTo,
	 enddateTo,
	 contractdateTo,
	 birthdayTo,
	 age,
	 ageTo,
	 resourceidfrom,
	 resourceidto,
	 workcode,
	 jobcall,
	 mobile,
	 mobilecall,
	 fax,
	 email,
	 folk,
	 nativeplace,
	 regresidentplace,
	 maritalstatus,
	 certificatenum,
	 tempresidentnumber,
	 residentplace,
	 homeaddress,
	 healthinfo,
	 heightfrom,
	 heightto,
	 weightfrom,
	 weightto,
	 educationlevel,
	 degree,
	 usekind,
	 policy,
	 bememberdatefrom,
	 bememberdateto,
	 bepartydatefrom,
	 bepartydateto,
	 islabouunion,
	 bankid1,
	 accountid1,
	 accumfundaccount,
	 loginid,
	 systemlanguage) 
 
VALUES 
	( mouldname_1,
	 userid_2,
	 resourceid_3,
	 resourcename_4,
	 jobtitle_5,
	 activitydesc_6,
	 jobgroup_7,
	 jobactivity_8,
	 costcenter_9,
	 competency_10,
	 resourcetype_11,
	 status_12,
	 subcompany1_13,
	 department_14,
	 location_15,
	 manager_16,
	 assistant_17,
	 roles_18,
	 seclevel_19,
	 joblevel_20,
	 workroom_21,
	 telephone_22,
	 startdate_23,
	 enddate_24,
	 contractdate_25,
	 birthday_26,
	 sex_27,
	 seclevelTo_28,
	 joblevelTo_29,
	 startdateTo_30,
	 enddateTo_31,
	 contractdateTo_32,
	 birthdayTo_33,
	 age_34,
	 ageTo_35,
	 resourceidfrom_36,
	 resourceidto_37,
	 workcode_38,
	 jobcall_39,
	 mobile_40,
	 mobilecall_41,
	 fax_42,
	 email_43,
	 folk_44,
	 nativeplace_45,
	 regresidentplace_46,
	 maritalstatus_47,
	 certificatenum_48,
	 tempresidentnumber_49,
	 residentplace_50,
	 homeaddress_51,
	 healthinfo_52,
	 heightfrom_53,
	 heightto_54,
	 weightfrom_55,
	 weightto_56,
	 educationlevel_57,
	 degree_58,
	 usekind_59,
	 policy_60,
	 bememberdatefrom_61,
	 bememberdateto_62,
	 bepartydatefrom_63,
	 bepartydateto_64,
	 islabouunion_65,
	 bankid1_66,
	 accountid1_67,
	 accumfundaccount_68,
	 loginid_69,
	 systemlanguage_70);
open thecursor for 
select max(id) from HrmSearchMould;
end;
/


 CREATE or REPLACE PROCEDURE HrmSearchMould_Update
	(id_1 	integer,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	integer,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE HrmSearchMould 
SET      userid	 = userid_2,
	 resourceid	 = resourceid_3,
	 resourcename	 = resourcename_4,
	 jobtitle	 = jobtitle_5,
	 activitydesc	 = activitydesc_6,
	 jobgroup	 = jobgroup_7,
	 jobactivity	 = jobactivity_8,
	 costcenter	 = costcenter_9,
	 competency	 = competency_10,
	 resourcetype	 = resourcetype_11,
	 status	 = status_12,
	 subcompany1	 = subcompany1_13,
	 department	 = department_14,
	 location	 = location_15,
	 manager	 = manager_16,
	 assistant	 = assistant_17,
	 roles	 = roles_18,
	 seclevel	 = seclevel_19,
	 joblevel	 = joblevel_20,
	 workroom	 = workroom_21,
	 telephone	 = telephone_22,
	 startdate	 = startdate_23,
	 enddate	 = enddate_24,
	 contractdate	 = contractdate_25,
	 birthday	 = birthday_26,
	 sex	 = sex_27,
	 seclevelTo	 = seclevelTo_28,
	 joblevelTo	 = joblevelTo_29,
	 startdateTo	 = startdateTo_30,
	 enddateTo	 = enddateTo_31,
	 contractdateTo	 = contractdateTo_32,
	 birthdayTo	 = birthdayTo_33,
	 age	 = age_34,
	 ageTo	 = ageTo_35,
	 resourceidfrom	 = resourceidfrom_36,
	 resourceidto	 = resourceidto_37,
	 workcode	 = workcode_38,
	 jobcall	 = jobcall_39,
	 mobile	 = mobile_40,
	 mobilecall	 = mobilecall_41,
	 fax	 = fax_42,
	 email	 = email_43,
	 folk	 = folk_44,
	 nativeplace	 = nativeplace_45,
	 regresidentplace	 = regresidentplace_46,
	 maritalstatus	 = maritalstatus_47,
	 certificatenum	 = certificatenum_48,
	 tempresidentnumber	 = tempresidentnumber_49,
	 residentplace	 = residentplace_50,
	 homeaddress	 = homeaddress_51,
	 healthinfo	 = healthinfo_52,
	 heightfrom	 = heightfrom_53,
	 heightto	 = heightto_54,
	 weightfrom	 = weightfrom_55,
	 weightto	 = weightto_56,
	 educationlevel	 = educationlevel_57,
	 degree	 = degree_58,
	 usekind	 = usekind_59,
	 policy	 = policy_60,
	 bememberdatefrom	 = bememberdatefrom_61,
	 bememberdateto	 = bememberdateto_62,
	 bepartydatefrom	 = bepartydatefrom_63,
	 bepartydateto	 = bepartydateto_64,
	 islabouunion	 = islabouunion_65,
	 bankid1	 = bankid1_66,
	 accountid1	 = accountid1_67,
	 accumfundaccount	 = accumfundaccount_68,
	 loginid	 = loginid_69,
	 systemlanguage	 = systemlanguage_70 

WHERE 
	( id	 = id_1);
end;
/


  CREATE or REPLACE PROCEDURE HrmSubCompany_Delete 
 (id_1 	integer, 
flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
  AS
recordercount integer;  
  begin
	Select  count(id) INTO recordercount  from HrmDepartment 
	where subcompanyid1 = to_number(id_1);
	if recordercount = 0 then
	DELETE HrmSubCompany  WHERE ( id	 = id_1);
	else 
	open thecursor for 
	select '20' from dual;
	end if;
  end;
/



 CREATE or REPLACE PROCEDURE HrmResource_DepUpdate
(id_1 integer,
 departmentid_2 integer,
 joblevel_3 integer,
flag out integer ,
 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin
update HrmResource set
  departmentid = departmentid_2,
  joblevel = joblevel_3
where
  id = id_1;
end;
/



insert into CptCapitalModifyField (field,name) values ('50','帐内或帐外')
/


 CREATE or REPLACE  PROCEDURE CptCapital_Update 
	(id_1 	integer,
	 name_3 	varchar2,
	 barcode_4 	varchar2,
	 startdate_1		char,
	 enddate_1		char,
	 seclevel_7 	smallint,
	 resourceid_1	integer,
	 sptcount_1 	char,
	 currencyid_11 	integer,
	 capitalcost_12 	number,
	 startprice_13 	number,
	depreendprice_1 number,
	capitalspec_1		varchar2,			
	capitallevel_1		varchar2,			
	manufacturer_1		varchar2,
	manudate_1		char,			
	 capitaltypeid_14 	integer,
	 capitalgroupid_15 	integer,
	 unitid_16 	integer,
	 replacecapitalid_18 	integer,
	 version_19 	varchar2,
	 location_1      varchar2,
	 remark_21 	varchar,
	 capitalimageid_22 	integer,
	 depremethod1_23 	integer,
	 depremethod2_24 	integer,
	 deprestartdate_1	char,
	 depreenddate_1		char,
	 customerid_27 	integer,
	 attribute_28 	smallint,
	 datefield1_31 	char,
	 datefield2_32 	char,
	 datefield3_33 	char,
	 datefield4_34 	char,
	 datefield5_35 	char,
	 numberfield1_36 	float,
	 numberfield2_37 	float,
	 numberfield3_38 	float,
	 numberfield4_39 	float,
	 numberfield5_40 	float,
	 textfield1_41 	varchar2,
	 textfield2_42 	varchar2,
	 textfield3_43 	varchar2,
	 textfield4_44 	varchar2,
	 textfield5_45 	varchar2,
	 tinyintfield1_46 	char,
	 tinyintfield2_47 	char,
	 tinyintfield3_48 	char,
	 tinyintfield4_49 	char,
	 tinyintfield5_50 	char,
	 lastmoderid_51 	integer,
	 lastmoddate_52 	char,
	 lastmodtime_53 	char,
	 relatewfid_1		integer,
	 alertnum_1         number,
	 fnamark_1			varchar2,
	 isinner_1			char,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS

tempgroupid integer;
begin
/*更新资产组中的资产卡片数量信息*/

select capitalgroupid INTO tempgroupid from CptCapital where id=id_1;
if tempgroupid<>capitalgroupid_15 then

	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=tempgroupid;
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=capitalgroupid_15;
end if;
UPDATE CptCapital 
SET  	 name	 = name_3,
	 barcode	 = barcode_4,
	 startdate = startdate_1,
	 enddate	 = enddate_1,	
	 seclevel	 = seclevel_7,
	 resourceid = resourceid_1,
	 sptcount	= sptcount_1,	
	 currencyid	 = currencyid_11,
	 capitalcost	 = capitalcost_12,
	 startprice	 = startprice_13,
	 depreendprice	= depreendprice_1,
	 capitalspec	= capitalspec_1,
	 capitallevel	= capitallevel_1,
	 manufacturer	= manufacturer_1,
	 manudate      = manudate_1,
	 capitaltypeid	 = capitaltypeid_14,
	 capitalgroupid	 = capitalgroupid_15,
	 unitid	 = unitid_16,
	 replacecapitalid	 = replacecapitalid_18,
	 version	 = version_19,
	 location	  = location_1,
	 remark	 = remark_21,
	 capitalimageid	 = capitalimageid_22,
	 depremethod1	 = depremethod1_23,
	 depremethod2	 = depremethod2_24,
	 deprestartdate= deprestartdate_1,
	 depreenddate  = depreenddate_1,
	 customerid	 = customerid_27,
	 attribute	 = attribute_28,
	 datefield1	 = datefield1_31,
	 datefield2	 = datefield2_32,
	 datefield3	 = datefield3_33,
	 datefield4	 = datefield4_34,
	 datefield5	 = datefield5_35,
	 numberfield1	 = numberfield1_36,
	 numberfield2	 = numberfield2_37,
	 numberfield3	 = numberfield3_38,
	 numberfield4	 = numberfield4_39,
	 numberfield5	 = numberfield5_40,
	 textfield1	 = textfield1_41,
	 textfield2	 = textfield2_42,
	 textfield3	 = textfield3_43,
	 textfield4	 = textfield4_44,
	 textfield5	 = textfield5_45,
	 tinyintfield1	 = tinyintfield1_46,
	 tinyintfield2	 = tinyintfield2_47,
	 tinyintfield3	 = tinyintfield3_48,
	 tinyintfield4	 = tinyintfield4_49,
	 tinyintfield5	 = tinyintfield5_50,
	 lastmoderid	 = lastmoderid_51,
	 lastmoddate	 = lastmoddate_52,
	 lastmodtime	 = lastmodtime_53,
	 relatewfid	= relatewfid_1,
	 alertnum	 = alertnum_1,
	 fnamark	= fnamark_1,
	 isinner	= isinner_1
	 
WHERE 
	( id	 = id_1);
end;
/



/* 客户价值评估维护 */
insert into SystemRights(id,rightdesc,righttype) values(351,'客户价值评估维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(351,7,'客户价值评估维护','客户价值评估维护')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(351,8,'','')
/

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2054,'客户价值项目添加','CRM_EvaluationAdd:Add',351)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2055,'客户价值项目编辑','CRM_EvaluationEdit:Edit',351)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2056,'客户价值项目删除','CRM_EvaluationDelete:Delete',351)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2057,'客户价值项目日志','CRM_Evaluation:Log',351)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (351,8,'1')
/

insert into SystemRightToGroup (groupid,rightid) values (6,351)
/
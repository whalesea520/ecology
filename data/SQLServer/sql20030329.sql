  ALTER PROCEDURE LgcAsset_Insert (@assetmark_1 	[varchar](60), @barcode_2 	[varchar](30), @seclevel_3 	[tinyint], @assetimageid_4 	[int], @assettypeid_5 	[int], @assetunitid_6 	[int], @replaceassetid_7 	[int], @assetversion_8 	[varchar](20), @assetattribute_9 	[varchar](100), @counttypeid_10 	[int], @assortmentid_11 	[int], @assortmentstr_12 	[varchar](200), @relatewfid    int, @assetname_2 	[varchar](60), @assetcountyid_3 	[int], @startdate_4 	[char](10), @enddate_5 	[char](10), @departmentid_6 	[int], @resourceid_7 	[int], @assetremark_8 	[text], @currencyid_9 	[int], @salesprice_10 	varchar(30), @costprice_11 	        varchar(30), @datefield1_12 	[char](10), @datefield2_13 	[char](10), @datefield3_14 	[char](10), @datefield4_15 	[char](10), @datefield5_16 	[char](10), @numberfield1_17 	[float], @numberfield2_18 	[float], @numberfield3_19 	[float], @numberfield4_20 	[float], @numberfield5_21 	[float], @textfield1_22 	[varchar](100), @textfield2_23 	[varchar](100), @textfield3_24 	[varchar](100), @textfield4_25 	[varchar](100), @textfield5_26 	[varchar](100), @tinyintfield1_27 	[char](1), @tinyintfield2_28 	[char](1), @tinyintfield3_29 	[char](1), @tinyintfield4_30 	[char](1), @tinyintfield5_31 	[char](1), @createrid_32 	[int], @createdate_33 	[char](10), @Flag	[int]	output, @msg	[varchar](80)	output)  AS set @salesprice_10 = convert([decimal](18,3) , @salesprice_10) set @costprice_11 = convert([decimal](18,3) , @costprice_11)  declare @count integer  
  /*
  begin  select @count = count(*) from LgcAsset where assetmark = @assetmark_1 if @count <> 0 begin select -1 return end  end
  */
  INSERT INTO [LgcAsset] ( [assetmark], [barcode], [seclevel], [assetimageid], [assettypeid], [assetunitid], [replaceassetid], [assetversion], [assetattribute], [counttypeid], [assortmentid], [assortmentstr], relatewfid)  VALUES ( @assetmark_1, @barcode_2, @seclevel_3, @assetimageid_4, @assettypeid_5, @assetunitid_6, @replaceassetid_7, @assetversion_8, @assetattribute_9, @counttypeid_10, @assortmentid_11, @assortmentstr_12, @relatewfid)  declare @assetid integer  select @assetid = max(id) from LgcAsset  INSERT INTO [LgcAssetCountry] ( [assetid], [assetname], [assetcountyid], [startdate], [enddate], [departmentid], [resourceid], [assetremark], [currencyid], [salesprice], [costprice], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5], [createrid], [createdate], [lastmoderid], [lastmoddate], [isdefault])  VALUES ( @assetid, @assetname_2, @assetcountyid_3, @startdate_4, @enddate_5, @departmentid_6, @resourceid_7, @assetremark_8, @currencyid_9, @salesprice_10, @costprice_11, @datefield1_12, @datefield2_13, @datefield3_14, @datefield4_15, @datefield5_16, @numberfield1_17, @numberfield2_18, @numberfield3_19, @numberfield4_20, @numberfield5_21, @textfield1_22, @textfield2_23, @textfield3_24, @textfield4_25, @textfield5_26, @tinyintfield1_27, @tinyintfield2_28, @tinyintfield3_29, @tinyintfield4_30, @tinyintfield5_31, @createrid_32, @createdate_33, @createrid_32, @createdate_33, '1')  update LgcAssetAssortment set assetcount = assetcount+1 where id= @assortmentid_11 select max(id) from LgcAsset
GO


  ALTER PROCEDURE LgcAsset_Update (@id_1 	[int], @assetcountryid_2 [int], @barcode_3 	[varchar](30), @seclevel_4 	[tinyint], @assetimageid_5 	[int], @assettypeid_6 	[int], @assetunitid_7 	[int], @replaceassetid_8 	[int], @assetversion_9 	[varchar](20), @assetattribute_10 	[varchar](100), @counttypeid_11 	[int], @assortmentid_12 	[int], @assortmentstr_13 	[varchar](200), @relatewfid    int, @assetname_2 	[varchar](60), @assetcountyid_3 	[int], @startdate_4 	[char](10), @enddate_5 	[char](10), @departmentid_6 	[int], @resourceid_7 	[int], @assetremark_8 	[text], @currencyid_9 	[int], @salesprice_10 	varchar(30), @costprice_11 	varchar(30), @datefield1_12 	[char](10), @datefield2_13 	[char](10), @datefield3_14 	[char](10), @datefield4_15 	[char](10), @datefield5_16 	[char](10), @numberfield1_17 	[float], @numberfield2_18 	[float], @numberfield3_19 	[float], @numberfield4_20 	[float], @numberfield5_21 	[float], @textfield1_22 	[varchar](100), @textfield2_23 	[varchar](100), @textfield3_24 	[varchar](100), @textfield4_25 	[varchar](100), @textfield5_26 	[varchar](100), @tinyintfield1_27 	[char](1), @tinyintfield2_28 	[char](1), @tinyintfield3_29 	[char](1), @tinyintfield4_30 	[char](1), @tinyintfield5_31 	[char](1), @lastmoderid_32 	[int], @lastmoddate_33 	[char](10), @isdefault 		[char](1), @Flag	[int]	output, @msg	[varchar](80)	output)  AS set @salesprice_10 = convert([decimal](18,3) , @salesprice_10) set @costprice_11 = convert([decimal](18,3) , @costprice_11)  UPDATE [LgcAsset] SET  	 relatewfid = @relatewfid , [barcode]	 = @barcode_3, [seclevel]	 = @seclevel_4, [assetimageid]	 = @assetimageid_5, [assettypeid]	 = @assettypeid_6, [assetunitid]	 = @assetunitid_7, [replaceassetid]	 = @replaceassetid_8, [assetversion]	 = @assetversion_9, [assetattribute]	 = @assetattribute_10, [counttypeid]	 = @counttypeid_11, [assortmentid]	 = @assortmentid_12, [assortmentstr]	 = @assortmentstr_13  WHERE ( [id]	 = @id_1)  
  /*
  if  @assetcountryid_2=-1 begin select @assetcountryid_2=assetcountyid from LgcAssetCountry where assetid=@id_1 and isdefault='1' end
  if  @isdefault='1' begin update LgcAssetCountry set isdefault='0' where assetid=@id_1 end
  UPDATE [LgcAssetCountry] SET      [assetname]	 = @assetname_2, [assetcountyid] = @assetcountyid_3, [startdate]	 = @startdate_4, [enddate]	 = @enddate_5, [departmentid]	 = @departmentid_6, [resourceid]	 = @resourceid_7, [assetremark]	 = @assetremark_8, [currencyid]	 = @currencyid_9, [salesprice]	 = @salesprice_10, [costprice]	 = @costprice_11, [datefield1]	 = @datefield1_12, [datefield2]	 = @datefield2_13, [datefield3]	 = @datefield3_14, [datefield4]	 = @datefield4_15, [datefield5]	 = @datefield5_16, [numberfield1]	 = @numberfield1_17, [numberfield2]	 = @numberfield2_18, [numberfield3]	 = @numberfield3_19, [numberfield4]	 = @numberfield4_20, [numberfield5]	 = @numberfield5_21, [textfield1]	 = @textfield1_22, [textfield2]	 = @textfield2_23, [textfield3]	 = @textfield3_24, [textfield4]	 = @textfield4_25, [textfield5]	 = @textfield5_26, [tinyintfield1] = @tinyintfield1_27, [tinyintfield2] = @tinyintfield2_28, [tinyintfield3] = @tinyintfield3_29, [tinyintfield4] = @tinyintfield4_30, [tinyintfield5] = @tinyintfield5_31, [lastmoderid]	 = @lastmoderid_32, [lastmoddate]	 = @lastmoddate_33 , [isdefault]	= @isdefault  WHERE ( (assetid = @id_1) and (assetcountyid =@assetcountryid_2))
  */
GO

  ALTER PROCEDURE LgcAsset_Delete (
  @id_1 	[int], @assetcountryid_2 [int], @flag                             integer output, @msg                             varchar(80) output) 
  AS 
  declare 
  @isdefault char(1),
  @assortmentid_1 int
  /*
  select @isdefault= isdefault from LgcAssetCountry where assetid=@id_1 and assetcountyid = @assetcountryid_2 if @isdefault='1' begin select -1 return end
  */
  select @assortmentid_1 = assortmentid from LgcAsset where id=@id_1
  DELETE [LgcAsset]  WHERE id=@id_1 
  DELETE [LgcAssetCountry]  WHERE assetid=@id_1 
  update LgcAssetAssortment set assetcount = assetcount-1 where id= @assortmentid_1
GO

insert into SystemRights(id,rightdesc,righttype) values(380,'产品维护','0')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(380,7,'产品维护','产品维护')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(380,8,'','')
GO

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2080,'产品维护','CrmProduct:Add',380)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (380,8,'1')
GO

insert into SystemRightToGroup (groupid,rightid) values (6,380)
GO



/* 对于角色表的更新 */
ALTER TRIGGER Tri_Update_HrmRoleMembersShare ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
Declare @roleid_1 int,
        @resourceid_1 int,
        @oldrolelevel_1 char(1),
        @rolelevel_1 char(1),
        @docid_1	 int,
	    @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @seclevel_1	 int,
        @countrec      int,
        @countdelete   int,
        @countinsert   int
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */

select @countdelete = count(*) from deleted
select @countinsert = count(*) from inserted
select @oldrolelevel_1 = rolelevel from deleted
if @countinsert > 0 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from inserted
else 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from deleted

if ( @countinsert >0 and ( @countdelete = 0 or @rolelevel_1  > @oldrolelevel_1 ) )     
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* 新的角色级别为总部级 */
    begin 

	/* ------- DOC 部分 ------- */

        declare sharedocid_cursor cursor for
        select distinct docid , sharelevel from DocShare where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor

	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid=@crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


	/* ------- PROJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '1'          /* 新的角色级别为分部级 */
    begin

	/* ------- DOC 部分 ------- */
        declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 , hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor


	/* ------- CRM 部分 ------- */
       declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */
    begin

        /* ------- DOC 部分 ------- */

	declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid= @departmentid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor
	
	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

    end
end
else if ( @countdelete > 0 and ( @countinsert = 0 or @rolelevel_1  < @oldrolelevel_1 ) ) /* 当为删除或者级别降低 */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1 
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor

end        /* 结束角色删除或者级别降低的处理 */
go



/* 人力资源表涉及请求的创建 */
drop TRIGGER Tri_U_workflow_createlist
GO

CREATE TRIGGER [Tri_U_workflow_createlist] on [HrmResource] WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
    @olddepartmentid_1 int,
    @departmentid_1 int,
    @oldseclevel_1	 int,
    @seclevel_1	 int,
    @countdelete   int,
	@all_cursor cursor,
	@detail_cursor cursor

select @countdelete = count(*) from deleted
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted

/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if ( @countdelete = 0 or @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 )     
begin

    delete from workflow_createrlist

    SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

    OPEN @all_cursor 
    FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    WHILE @@FETCH_STATUS = 0 
    begin 
        if @type=1 
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where departmentid = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=2
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            SELECT resourceid as id FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=3
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
        end
        else if @type=4
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
        end
        else if @type=20
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=21
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=22
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=25
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
        end
        else if @type=30
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor
        end
        FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    end 
    CLOSE @all_cursor 
    DEALLOCATE @all_cursor  
end
go

CREATE TABLE HrmInfoMaintenance(
	id int IDENTITY (1, 1) NOT NULL ,
	itemname varchar(12) null,
	hrmid  int null
)
GO

CREATE TABLE HrmInfoStatus(
	id int IDENTITY (1, 1) NOT NULL ,
	itemid int null,
	status char(1) default 0,
	hrmid  int null
)
GO

/*入职员工资产领用表*/
CREATE TABLE HrmCapitalUse(
	id int IDENTITY (1, 1) NOT NULL ,
	capitalid  int null,
	hrmid int null,
	cptnum int null
	)
go

CREATE  PROCEDURE Employee_Insert
	@id_1      int,
	@name_1		varchar(60),
	@sex_1		char(1),
	@startdate_1 char(10),
	@departmentid_1 int,
	@joblevel_1	tinyint,
	@jobtitle_1	tinyint,
	@managerid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@costcenterid_1 int

	select @costcenterid_1 =id from HrmCostcenter WHERE departmentid = @departmentid_1
	insert into  HrmResource
	(id,lastname,sex,startdate,departmentid,joblevel,jobtitle,managerid,costcenterid,titleid)
	values
	(@id_1,@name_1,@sex_1,@startdate_1,@departmentid_1,@joblevel_1,@jobtitle_1,@managerid_1,@costcenterid_1,1)
GO



CREATE  PROCEDURE Employee_SByStatus
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@hrmid_1 int,
@id_1 int,
@lastname_1 varchar(60),
@sex_1 char(1),
@startdate_1 char(10),
@departmentid_1 int,
@joblevel_1 tinyint,
@managerid_1 int

CREATE table #temp(id int, lastname  varchar(60) , sex  char(1), startdate	char(10), departmentid	int, joblevel	tinyint, managerid int )
  
declare employee_cursor cursor for 
select distinct(hrmid) from HrmInfoStatus where status ='0'
open employee_cursor fetch next from employee_cursor into @hrmid_1
	while @@fetch_status=0  
	begin
	select 		 @id_1=id,@lastname_1=lastname,@sex_1=sex,@startdate_1=startdate,@departmentid_1=departmentid,@joblevel_1=joblevel,@managerid_1=managerid from HrmResource WHERE id=@hrmid_1
	insert INTO #temp(id,lastname,sex,startdate,departmentid,joblevel,managerid)
	values(@id_1,@lastname_1,@sex_1,@startdate_1,@departmentid_1,@joblevel_1,@managerid_1)
	fetch next from employee_cursor into @hrmid_1
	end
	close employee_cursor deallocate employee_cursor
	select * from #temp
go






CREATE  PROCEDURE Employee_SelectByHrmid
	@hrmid_1    int,
	@flag		int	output, 
	@msg		varchar(80) output
as
select itemid,status from HrmInfoStatus WHERE hrmid=@hrmid_1 AND itemid<10  order by itemid
go


CREATE  PROCEDURE Employee_LoginUpdate
	@loginid_1 varchar(60),
	@password_1 varchar(100),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@count_1 int

/*判断是否有重复登录名*/
select @count_1=count(*) from HrmResource where loginid = @loginid_1 and id<>@hrmid_1
if @count_1<>0
begin
select -1
return
end
else 
	
	if @password_1 = 'novalue$1'   
	begin
	update HrmResource
	set
	loginid=@loginid_1,
	systemlanguage=7,
	countryid=1,
	resourcetype='2',
	seclevel=10
	WHERE id= @hrmid_1
	end
	else
	begin
	update HrmResource
	set
	loginid=@loginid_1,
	password=@password_1,
	systemlanguage=7,
	countryid=1,
	resourcetype='2',
	seclevel=10
	WHERE id= @hrmid_1
	end
update HrmInfoStatus
set
status = '1'
WHERE itemid=1 AND hrmid=@hrmid_1
go


CREATE  PROCEDURE Employee_EmaiUpdate
	@email_1 varchar(60),
	@emailpassword_1 varchar(40),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@count_1 int
update HrmResource
set
email=@email_1
WHERE id=@hrmid_1
if @emailpassword_1 = 'novalue$1'  /*如果只是是修改邮箱帐户*/
	begin
	update MailPassword set resourcemail =@email_1  WHERE resourceid=@hrmid_1
	end
else
	begin 
		select @count_1=count(*) from MailPassword WHERE resourceid=@hrmid_1 
		if @count_1 <> 0   /*如果是修改帐户或密码*/
		begin
		update MailPassword set resourcemail =@email_1,password=@emailpassword_1  WHERE resourceid=@hrmid_1
		end
		else	/*如果原先没有此人的记录，此时为第一次设置*/
		begin
		insert INTO  MailPassword (resourceid,resourcemail,password)
		values(@hrmid_1,@email_1,@emailpassword_1)
		end
	end
update HrmInfoStatus
set 
status = '1'
WHERE itemid=2 AND hrmid=@hrmid_1
go


CREATE  PROCEDURE Employee_CardUpdate
	@textfield_1 varchar(100),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
update HrmResource
set
textfield1=@textfield_1
WHERE id=@hrmid_1
update HrmInfoStatus
set 
status = '1'
WHERE itemid=3 AND hrmid=@hrmid_1
go


CREATE  PROCEDURE Employee_SeatUpdate
	@textfield_1 varchar(100),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
update HrmResource
set
textfield2=@textfield_1
WHERE id=@hrmid_1
update HrmInfoStatus
set 
status = '1'
WHERE itemid=4 AND hrmid=@hrmid_1
go


CREATE  PROCEDURE Employee_TeleUpdate
	@telephone_1 varchar(60),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
update HrmResource
set
telephone=@telephone_1
WHERE id=@hrmid_1
update HrmInfoStatus
set 
status = '1'
WHERE itemid=7 AND hrmid=@hrmid_1
go




CREATE  PROCEDURE Employee_SelectByID
	@hrmid_1    int,
	@flag		int	output, 
	@msg		varchar(80) output
as
select email,textfield1,textfield2,telephone,tinyintfield1 from HrmResource WHERE id=@hrmid_1 
go


CREATE  PROCEDURE Employee_SetAll
	@hrmid_1    int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@count_1 int
/*判断是否有其它项未设置*/
select @count_1=count(*) from HrmInfoStatus where status=0 AND hrmid=@hrmid_1 AND itemid<10
if @count_1<>0
begin
select -1
return
end
else
begin
update HrmInfoStatus 
set status=1 WHERE itemid=10 AND hrmid=@hrmid_1
end
go


CREATE  PROCEDURE Employee_BusiCardUpdate
	@businesscard_1 varchar(60),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
update HrmResource
set
tinyintfield1 = @businesscard_1
WHERE id=@hrmid_1
update HrmInfoStatus
set 
status = '1'
WHERE itemid=9 AND hrmid=@hrmid_1
go



CREATE  PROCEDURE Employee_CptSelectByID
	@hrmid_1 int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@mark_1 varchar(60),
@name_1 varchar(60),
@cptnum_1 int,
@capitalid_1 int
create table #temp(mark  varchar(60) ,name  varchar(60) ,cptnum int )

declare cpt_cursor cursor for 
select capitalid,cptnum from HrmCapitalUse WHERE hrmid =@hrmid_1
open cpt_cursor fetch next from cpt_cursor into @capitalid_1,@cptnum_1
	while @@fetch_status=0  
	begin
	select @mark_1=mark,@name_1=name from CptCapital where id= @capitalid_1
	insert INTO #temp(mark,name,cptnum) values(@mark_1,@name_1,@cptnum_1)
	fetch next from cpt_cursor into @capitalid_1,@cptnum_1
	end
	close cpt_cursor deallocate cpt_cursor
select * from #temp
go



CREATE  PROCEDURE Employee_CptUpdate
	@id_1 int,
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
update HrmInfoStatus
set 
status = '1'
WHERE itemid=@id_1 AND hrmid=@hrmid_1
go




/*资产流程新增:资产领用*/
 ALTER PROCEDURE CptUseLogUse_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	decimal(18,3),
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @sptcount	[char](1),

	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num decimal(18,3)


/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @maintaincompany_8,
	 @fee_9,
	 '2',
	 @remark_11,
              0)

/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	departmentid = @usedeptid_3,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(@capitalid_1,@useresourceid_4,1)
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
	insert INTO HrmCapitalUse (capitalid,hrmid,cptnum)
	values(@capitalid_1,@useresourceid_4,@usecount_5)
end

select 1
GO

insert into HrmInfoMaintenance (itemname) values ('系统帐户')
GO
insert into HrmInfoMaintenance (itemname) values ('邮件帐户')
GO
insert into HrmInfoMaintenance (itemname) values ('一卡通')
GO
insert into HrmInfoMaintenance (itemname) values ('座位号')
GO
insert into HrmInfoMaintenance (itemname) values ('非it资产')
GO
insert into HrmInfoMaintenance (itemname) values ('It资产')
GO
insert into HrmInfoMaintenance (itemname) values ('分机直线')
GO
insert into HrmInfoMaintenance (itemname) values ('办公用品')
GO
insert into HrmInfoMaintenance (itemname) values ('名片印制')
GO
insert into HrmInfoMaintenance (itemname) values ('任务监控人员')
GO




insert into HtmlLabelInfo (indexid,labelname,languageid) values (2224,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2224,'新入职员工',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2224,'新入职员工')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2225,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2225,'入职项目表',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2225,'入职项目表')
go

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2226,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2226,'新入职员工项目设置',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2226,'新入职员工项目设置')
go

alter table Prj_ProjectInfo add members varchar(3000) null
go
alter table Prj_TaskProcess add  prefinish varchar(4000) default 0
go
alter table Prj_TaskProcess add taskconfirm char(1) default 0
go
alter table Prj_TaskProcess add islandmark char(1) default 0
go



CREATE TABLE	Task_Log(
	projectid int null,
	taskid int null,
	logtype char(2) null,
	submitdate varchar (10)  NULL ,
	submittime varchar (8)  NULL ,
	submiter int null,
	clientip char(15) null,
	submitertype tinyint NULL )
go



CREATE TABLE Task_Modify (
	projectid int NULL ,
	taskid int  NULL ,
	fieldname varchar (100)  NULL ,
	modifydate varchar (10)  NULL ,
	modifytime varchar (8)  NULL ,
	original varchar (255)  NULL ,
	modified varchar (255)  NULL ,
	modifier int NULL ,
	clientip char (15)  NULL ,
	submitertype tinyint NULL,
	logtype char(1) null

)
GO

CREATE PROCEDURE Proj_Members_update
	@ProjId_1 int,
	@members_1  varchar(3000),
	@flag		int	output, 
	@msg		varchar(80) output
as
update Prj_ProjectInfo set
members = @members_1 WHERE id= @ProjId_1
go




alter PROCEDURE Prj_TaskProcess_Update 
 (@id	int,
 @wbscoding varchar(20),
 @subject 	varchar(80) ,
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @workday decimal (10,1), 
 @content 	varchar(255),
 @fixedcost decimal (10,2), 
 @hrmid int, 
 @oldhrmid int, 
 @finish tinyint, 
 @taskconfirm char(1),
 @islandmark char(1),
 @prefinish_1 varchar(4000),
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
UPDATE Prj_TaskProcess  
SET  
wbscoding = @wbscoding, 
subject = @subject ,
begindate = @begindate,
enddate = @enddate 	, 
workday = @workday, 
content = @content,
fixedcost = @fixedcost,
hrmid = @hrmid, 
finish = @finish ,
taskconfirm = @taskconfirm,
islandmark = @islandmark,
prefinish = @prefinish_1
WHERE ( id	 = @id) 
if @hrmid<>@oldhrmid
begin
Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
UPDATE Prj_TaskProcess set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO





CREATE PROCEDURE Prj_TaskProcess_SMAXID
	@flag integer output, 
    @msg varchar(80) output 
as

select max(id) as maxid_1  from Prj_TaskProcess
go





CREATE PROCEDURE Prj_TaskLog_Insert
	@projectid_1 int,
	@taskid_1 int  ,
	@logtype_1 char(2)  ,
	@submitdate_1 varchar (10)    ,
	@submittime_1 varchar (8)    ,
	@submiter_1 int  ,
	@clientip_1 char(15)  ,
	@submitertype_1 tinyint  ,
	@flag integer output, 
    @msg varchar(80) output 
as
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
	@projectid_1 ,
	@taskid_1 ,
	@logtype_1 ,
	@submitdate_1  ,
	@submittime_1  ,
	@submiter_1 ,
	@clientip_1 ,
	@submitertype_1 
	)
GO


CREATE PROCEDURE Prj_TaskModify_Insert
	@projectid_1 int   ,
	@taskid_1 int    ,
	@fieldname_1 varchar (100)    ,
	@modifydate_1 varchar (10)    ,
	@modifytime_1 varchar (8)    ,
	@original_1 varchar (255)    ,
	@modified_1 varchar (255)    ,
	@modifier_1 int   ,
	@clientip_1 char (15)    ,
	@submitertype_1 tinyint  ,
	@logtype_1 char(1),
	@flag integer output, 
    @msg varchar(80) output 
as
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
	@projectid_1    ,
	@taskid_1      ,
	@fieldname_1     ,
	@modifydate_1     ,
	@modifytime_1   ,
	@original_1    ,
	@modified_1   ,
	@modifier_1     ,
	@clientip_1     ,
	@submitertype_1 ,
	@logtype_1
	)
GO


alter PROCEDURE Prj_TaskProcess_Insert 
 (@prjid 	int,
 @taskid 	int, 
 @wbscoding 	varchar(20),
 @subject 	varchar(80) , 
 @version 	tinyint, 
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @workday decimal (10,1), 
 @content 	varchar(255),
 @fixedcost decimal (10,2),
 @parentid int, 
 @parentids varchar (255), 
 @parenthrmids varchar (255), 
 @level_n tinyint,
 @hrmid int,
 @prefinish_1 varchar(4000),
 @flag integer output, @msg varchar(80) output  ) 
AS 
INSERT INTO Prj_TaskProcess 
( prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish
)  
VALUES 
( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate,
@workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1) 
Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
select @id = max(id) from Prj_TaskProcess 
set @maxid = convert(varchar(10), @id) + ','
set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
set @flag = 1 set @msg = 'OK!'

GO


 CREATE PROCEDURE Task_Log_Select 
 (@id 	int, 
 @flag	int	output,
 @msg	varchar(80)	output)
 AS
 SELECT * FROM Task_Log WHERE ( projectid	 = @id) 
 ORDER BY submitdate DESC, submittime DESC 
 GO


  CREATE PROCEDURE Task_Modify_Select 
 (@id 	int, 
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS
 SELECT * FROM Task_Modify 
 WHERE ( projectid	 = @id) ORDER BY modifydate DESC, modifytime DESC 
GO

drop table Prj_ProjectStatus
GO

CREATE TABLE Prj_ProjectStatus (
	id int IDENTITY (1, 1) NOT NULL ,
	fullname varchar (50) NULL ,
	description varchar (150)  NULL 
)
GO
insert into Prj_ProjectStatus (fullname,description) values ('正常','正常')
go
insert into Prj_ProjectStatus (fullname,description) values ('延期','延期')
go
insert into Prj_ProjectStatus (fullname,description) values ('完成','完成')
go
insert into Prj_ProjectStatus (fullname,description) values ('冻结','冻结')
go
insert into Prj_ProjectStatus (fullname,description) values ('立项批准','立项批准')
go
insert into Prj_ProjectStatus (fullname,description) values ('待审批','待审批')
go





 alter PROCEDURE Prj_TaskProcess_Sum 
 (@prjid int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS 
 SELECT sum(workday) as workday,
 min(begindate) as begindate, 
 max(enddate) as enddate, 
 sum(finish*workday)/sum(workday) as finish,
 sum(fixedcost) as fixedcost
 FROM Prj_TaskProcess
 WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') 
GO



 alter PROCEDURE Prj_TaskProcess_UpdateParent 
 (@parentid	int,
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
Declare 
@begindate varchar(10), 
@enddate varchar(10), 
@workday decimal (10,1), 
@finish int ,
@fixedcost_1 decimal(10,2)
select @begindate = min(begindate), @enddate = max(enddate), @workday = sum(workday), 
@finish = convert(int,sum(workday*finish)/sum(workday)) , @fixedcost_1 = sum(fixedcost)
from Prj_TaskProcess
where parentid=@parentid
UPDATE Prj_TaskProcess 
SET  
begindate = @begindate, 
enddate = @enddate,
workday = @workday, 
finish = @finish  ,
fixedcost = @fixedcost_1
WHERE ( id = @parentid) 
GO


/* 首页定制 */
CREATE TABLE [HomePageDesign] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [int] NULL ,
	[iframe] [varchar] (50)  NULL ,	
	[height] [int] NULL ,
	[url] [varchar] (100)  NULL 
)
GO

CREATE TABLE [PersonalHomePageDesign] (
	[homepageid] [int] NULL ,
	[hrmid] [int] NULL ,
	[orderid] [int] NULL ,
	[ischecked] [int] NULL 
)
GO



ALTER TABLE CRM_CustomerContacter add interest varchar(100) /* 兴趣 */
GO
ALTER TABLE CRM_CustomerContacter add hobby varchar(100) /* 爱好 */
GO
ALTER TABLE CRM_CustomerContacter add managerstr varchar(100) /* 经理名称 */
GO
ALTER TABLE CRM_CustomerContacter add subordinate varchar(100) /* 下属 */
GO
ALTER TABLE CRM_CustomerContacter add strongsuit varchar(100) /* 专长 */
GO
ALTER TABLE CRM_CustomerContacter add age int /* 年龄 */
GO
ALTER TABLE CRM_CustomerContacter add birthday varchar(10) /* 生日 */
GO
ALTER TABLE CRM_CustomerContacter add home varchar(100) /* 家庭住址 */
GO
ALTER TABLE CRM_CustomerContacter add school varchar(100) /* 毕业学校 */
GO
ALTER TABLE CRM_CustomerContacter add speciality varchar(100) /* 专业 */
GO
ALTER TABLE CRM_CustomerContacter add nativeplace varchar(100) /* 籍贯 */
GO
ALTER TABLE CRM_CustomerContacter add experience varchar(200) /* 经历 */
GO


ALTER TABLE CRM_CustomerInfo add introductionDocid int /* 客户卡片的背景信息 */
GO

ALTER TABLE CRM_CustomerInfo add evaluation decimal(10, 2)  /* 客户卡片的背景信息 */
GO


CREATE TABLE [CRM_Evaluation] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[proportion] [int] NULL 
)
GO

CREATE TABLE [CRM_Evaluation_Level] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50)  NULL ,
	[levelvalue] [int] NULL 
)
GO

CREATE TABLE [CRM_ContacterLog_Remind] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[customerid] [int] NULL,	
	[daytype] [int] NULL, /* 时间类型 */
	[before] [int] NULL, /* 提前的时间 */
	[isremind] [int] NULL,	/* 是否提醒 */
)
GO

CREATE PROCEDURE PersonalHPDesign_Duplicate
	(@hrmid 	int,
	@flag integer output,
	 @msg varchar(80) output)

AS 
declare
  @homepageid	int,
  @orderid   int
  set @orderid = 0
declare homepageid_cursor cursor for
select id
from HomePageDesign order by id

open homepageid_cursor fetch next from homepageid_cursor into @homepageid 
while @@fetch_status=0 
  begin 
  set @orderid = @orderid + 1
  INSERT INTO PersonalHomePageDesign 
  values(@homepageid , @hrmid , @orderid, 0) fetch next 
  from homepageid_cursor into @homepageid
  end 
close homepageid_cursor deallocate homepageid_cursor  
select * from PersonalHomePageDesign where hrmid = @hrmid order by orderid
GO


CREATE PROCEDURE PersonalHPDesign_Update1
	(@hrmid 	int,
	 @flag integer output,
	 @msg varchar(80) output)

AS
update PersonalHomePageDesign set orderid=0 , ischecked = 1 where hrmid = @hrmid
GO

CREATE PROCEDURE PersonalHPDesign_Update2
	(@hrmid 	int,
	 @homepageid    int,
	 @orderid 	int,
	 @flag integer output,
	 @msg varchar(80) output)

AS
update PersonalHomePageDesign set orderid=@orderid , ischecked = 0 where hrmid = @hrmid and homepageid = @homepageid
GO


ALTER PROCEDURE CptCapital_SCountByDataType 
(@datatype 	int, 
@flag                             integer output, 
@msg                             varchar(80) output )
 AS 
select max(mark) from CptCapital where  datatype =  @datatype and isdata='2'

 if @@error<>0 begin set @flag=1 set @msg='查询资产信息成功' return end else begin set @flag=0 set @msg='查询资产信息失败' return end
GO

 ALTER PROCEDURE CRM_CustomerContacter_Insert 
 (@customerid_1 	[int],
 @title_2 	[int],
 @fullname_3 	[varchar](50), 
 @lastname_4 	[varchar](50),
 @firstname_5 	[varchar](50),
 @jobtitle_6 	[varchar](100),
 @email_7 	[varchar](150), 
 @phoneoffice_8 	[varchar](20),
 @phonehome_9 	[varchar](20), 
 @mobilephone_10 	[varchar](20), 
 @fax_11 	[varchar](20),
 @language_12 	[int],
 @manager_13 	[int], 
 @main_14 	[tinyint], 
 @picid_15 	[int],
 @interest_1	[varchar](100),
 @hobby_1	[varchar](100),
 @managerstr_1	[varchar](100),
 @subordinate_1	[varchar](100),
 @strongsuit_1	[varchar](100),
 @age_1		[int], 
 @birthday_1	[varchar](100),
 @home_1	[varchar](100),
 @school_1	[varchar](100),
 @speciality_1	[varchar](100),
 @nativeplace_1	[varchar](100),
 @experience_1	[varchar](200),
 @datefield1_16 	[varchar](10),
 @datefield2_17 	[varchar](10),
 @datefield3_18 	[varchar](10),
 @datefield4_19 	[varchar](10), 
 @datefield5_20 	[varchar](10), 
 @numberfield1_21 	[float], 
 @numberfield2_22 	[float], 
 @numberfield3_23 	[float], 
 @numberfield4_24 	[float], 
 @numberfield5_25 	[float],
 @textfield1_26 	[varchar](100),
 @textfield2_27 	[varchar](100),
 @textfield3_28 	[varchar](100),
 @textfield4_29 	[varchar](100), 
 @textfield5_30 	[varchar](100),
 @tinyintfield1_31 	[tinyint], 
 @tinyintfield2_32 	[tinyint],
 @tinyintfield3_33 	[tinyint], 
 @tinyintfield4_34 	[tinyint],
 @tinyintfield5_35 	[tinyint],
 @flag	[int]	output,
 @msg	[varchar](80)	output) 
 AS INSERT INTO [CRM_CustomerContacter]
 ( [customerid], [title], [fullname], [lastname], [firstname], [jobtitle], [email], [phoneoffice], [phonehome], [mobilephone], [fax], [language], [manager], [main], [picid], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5] ,interest ,hobby ,managerstr,subordinate,strongsuit,age,birthday,home,school,speciality,nativeplace,experience) 
 VALUES 
 ( @customerid_1, @title_2, @fullname_3, @lastname_4, @firstname_5, @jobtitle_6, @email_7, @phoneoffice_8, @phonehome_9, @mobilephone_10, @fax_11, @language_12, @manager_13, @main_14, @picid_15, @datefield1_16, @datefield2_17, @datefield3_18, @datefield4_19, @datefield5_20, @numberfield1_21, @numberfield2_22, @numberfield3_23, @numberfield4_24, @numberfield5_25, @textfield1_26, @textfield2_27, @textfield3_28, @textfield4_29, @textfield5_30, @tinyintfield1_31, @tinyintfield2_32, @tinyintfield3_33, @tinyintfield4_34, @tinyintfield5_35, @interest_1 , @hobby_1 , @managerstr_1, @subordinate_1 , @strongsuit_1 , @age_1 , @birthday_1 , @home_1 , @school_1 , @speciality_1 , @nativeplace_1 , @experience_1 )  set @flag = 1 set @msg = 'OK!' 
GO


 ALTER PROCEDURE CRM_CustomerContacter_Update 
 (@id_1 	[int], 
 @title_3 	[int],
 @fullname_4 	[varchar](50),
 @lastname_5 	[varchar](50),
 @firstname_6 	[varchar](50), 
 @jobtitle_7 	[varchar](100), 
 @email_8 	[varchar](150), 
 @phoneoffice_9 	[varchar](20),
 @phonehome_10 	[varchar](20), 
 @mobilephone_11 	[varchar](20),
 @fax_12 	[varchar](20), 
 @language_13 	[int], 
 @manager_14 	[int], 
 @main_15 	[tinyint], 
 @picid_16 	[int], 
 @interest_1	[varchar](100),
 @hobby_1	[varchar](100),
 @managerstr_1	[varchar](100),
 @subordinate_1	[varchar](100),
 @strongsuit_1	[varchar](100),
 @age_1		[int], 
 @birthday_1	[varchar](100),
 @home_1	[varchar](100),
 @school_1	[varchar](100),
 @speciality_1	[varchar](100),
 @nativeplace_1	[varchar](100),
 @experience_1	[varchar](200),
 @datefield1_17 	[varchar](10),
 @datefield2_18 	[varchar](10),
 @datefield3_19 	[varchar](10), 
 @datefield4_20 	[varchar](10),
 @datefield5_21 	[varchar](10), 
 @numberfield1_22 	[float], 
 @numberfield2_23 	[float],
 @numberfield3_24 	[float], 
 @numberfield4_25 	[float], 
 @numberfield5_26 	[float],
 @textfield1_27 	[varchar](100), 
 @textfield2_28 	[varchar](100), 
 @textfield3_29 	[varchar](100), 
 @textfield4_30 	[varchar](100),
 @textfield5_31 	[varchar](100), 
 @tinyintfield1_32 	[tinyint], 
 @tinyintfield2_33 	[tinyint],
 @tinyintfield3_34 	[tinyint],
 @tinyintfield4_35 	[tinyint], 
 @tinyintfield5_36 	[tinyint], 
 @flag	[int]	output, 
 @msg	[varchar](80)	output)  
 AS UPDATE [CRM_CustomerContacter]  
 SET	 [title]	 = @title_3, 
 [fullname]	 = @fullname_4, 
 [lastname]	 = @lastname_5, 
 [firstname]	 = @firstname_6,
 [jobtitle]	 = @jobtitle_7,
 [email]	 = @email_8, 
 [phoneoffice]	 = @phoneoffice_9, 
 [phonehome]	 = @phonehome_10,
 [mobilephone]	 = @mobilephone_11,
 [fax]	 = @fax_12, 
 [language]	 = @language_13, 
 [manager]	 = @manager_14,
 [main]	 = @main_15, [picid]	 = @picid_16,
 [datefield1]	 = @datefield1_17, 
 [datefield2]	 = @datefield2_18, 
 [datefield3]	 = @datefield3_19,
 [datefield4]	 = @datefield4_20,
 [datefield5]	 = @datefield5_21, 
 [numberfield1]	 = @numberfield1_22,
 [numberfield2]	 = @numberfield2_23,
 [numberfield3]	 = @numberfield3_24,
 [numberfield4]	 = @numberfield4_25,
 [numberfield5]	 = @numberfield5_26,
 [textfield1]	 = @textfield1_27, 
 [textfield2]	 = @textfield2_28, 
 [textfield3]	 = @textfield3_29,
 [textfield4]	 = @textfield4_30,
 [textfield5]	 = @textfield5_31,
 [tinyintfield1]	 = @tinyintfield1_32, 
 [tinyintfield2]	 = @tinyintfield2_33,
 [tinyintfield3]	 = @tinyintfield3_34, 
 [tinyintfield4]	 = @tinyintfield4_35, 
 [tinyintfield5]	 = @tinyintfield5_36, 
 interest	 = @interest_1,
 hobby	 = @hobby_1,
 managerstr	 = @managerstr_1,
 subordinate	 = @subordinate_1,
 strongsuit	 = @strongsuit_1,
 age	 = @age_1,
 birthday	 = @birthday_1,
 home	 = @home_1,
 school	 = @school_1,
 speciality	 = @speciality_1,
 nativeplace	 = @nativeplace_1,
 experience	 = @experience_1
WHERE ( [id]	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO


ALTER PROCEDURE CRM_CustomerInfo_Insert 
 (@name 		[varchar](50), @language 	[int], @engname 	[varchar](50), @address1 	[varchar](250), @address2 	[varchar](250), @address3 	[varchar](250), @zipcode 	[varchar](10), @city	 	[int], @country 	[int], @province 	[int], @county 	[varchar](50), @phone 	[varchar](50), @fax	 	[varchar](50), @email 	[varchar](150), @website 	[varchar](150), @source 	[int], @sector 	[int], @size_n	 	[int], @manager 	[int], @agent 	[int], @parentid 	[int], @department 	[int], @subcompanyid1 	[int], @fincode 	[int], @currency 	[int], @contractlevel	[int], @creditlevel 	[int], @creditoffset 	[varchar](50), @discount 	[real], @taxnumber 	[varchar](50), @bankacount 	[varchar](50), @invoiceacount	[int], @deliverytype 	[int], @paymentterm 	[int], @paymentway 	[int], @saleconfirm 	[int], @creditcard 	[varchar](50), @creditexpire 	[varchar](10), @documentid 	[int], @seclevel 	[int], @picid 	[int], @type 		[int], @typebegin 	[varchar](10), @description 	[int], @status 	[int], @rating 	[int], @introductionDocid [int],  @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 [tinyint], @tinyintfield2 [tinyint], @tinyintfield3 [tinyint], @tinyintfield4 [tinyint], @tinyintfield5 [tinyint], @createdate 	[varchar](10), @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [CRM_CustomerInfo] ( [name], [language], [engname], [address1], [address2], [address3], [zipcode], [city], [country], [province], [county], [phone], [fax], [email], [website], [source], [sector], [size_n], [manager], [agent], [parentid], [department], [subcompanyid1], [fincode], [currency], [contractlevel], [creditlevel], [creditoffset], [discount], [taxnumber], [bankacount], [invoiceacount], [deliverytype], [paymentterm], [paymentway], [saleconfirm], [creditcard], [creditexpire], [documentid], [seclevel], [picid], [type], [typebegin], [description], [status], [rating], [datefield1], [datefield2], [datefield3], [datefield4], [datefield5], [numberfield1], [numberfield2], [numberfield3], [numberfield4], [numberfield5], [textfield1], [textfield2], [textfield3], [textfield4], [textfield5], [tinyintfield1], [tinyintfield2], [tinyintfield3], [tinyintfield4], [tinyintfield5], [deleted], [createdate],introductionDocid)  VALUES ( @name, @language, @engname, @address1, @address2, @address3, @zipcode, @city, @country, @province, @county, @phone, @fax, @email, @website, @source, @sector, @size_n, @manager, @agent, @parentid, @department, @subcompanyid1, @fincode, @currency, @contractlevel, @creditlevel, convert(money,@creditoffset), @discount, @taxnumber, @bankacount, @invoiceacount, @deliverytype, @paymentterm, @paymentway, @saleconfirm, @creditcard, @creditexpire, @documentid, @seclevel, @picid, @type, @typebegin, @description, @status, @rating, @datefield1, @datefield2, @datefield3, @datefield4, @datefield5, @numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, @textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5, 0, @createdate, @introductionDocid )  SELECT top 1 id from CRM_CustomerInfo ORDER BY id DESC set @flag = 1 set @msg = 'OK!' 


GO


 ALTER PROCEDURE CRM_CustomerInfo_Update 
 (@id 		[int], @name 		[varchar](50), @language 	[int], @engname 	[varchar](50), @address1 	[varchar](250), @address2 	[varchar](250), @address3 	[varchar](250), @zipcode 	[varchar](10), @city	 	[int], @country 	[int], @province 	[int], @county 	[varchar](50), @phone 	[varchar](50), @fax	 	[varchar](50), @email 	[varchar](150), @website 	[varchar](150), @source 	[int], @sector 	[int], @size_n	 	[int], @manager 	[int], @agent 	[int], @parentid 	[int], @department 	[int], @subcompanyid1 	[int], @fincode 	[int], @currency 	[int], @contractlevel	[int], @creditlevel 	[int], @creditoffset 	[varchar](50), @discount 	[real], @taxnumber 	[varchar](50), @bankacount 	[varchar](50), @invoiceacount [int], @deliverytype 	[int], @paymentterm 	[int], @paymentway 	[int], @saleconfirm 	[int], @creditcard 	[varchar](50), @creditexpire 	[varchar](10), @documentid 	[int], @seclevel 	[int], @picid 	[int], @type	 	[int], @typebegin 	[varchar](10), @description 	[int], @status 	[int], @rating 	[int], @introductionDocid [int],  @datefield1 	[varchar](10), @datefield2 	[varchar](10), @datefield3 	[varchar](10), @datefield4 	[varchar](10), @datefield5 	[varchar](10), @numberfield1 	[float], @numberfield2 	[float], @numberfield3 	[float], @numberfield4 	[float], @numberfield5 	[float], @textfield1 	[varchar](100), @textfield2 	[varchar](100), @textfield3 	[varchar](100), @textfield4 	[varchar](100), @textfield5 	[varchar](100), @tinyintfield1 	[tinyint], @tinyintfield2 	[tinyint], @tinyintfield3 	[tinyint], @tinyintfield4 	[tinyint], @tinyintfield5 	[tinyint], @flag	[int]	output, @msg	[varchar](80)	output) AS UPDATE [CRM_CustomerInfo]  SET  	 [name]	 	 = @name, [language]	 = @language, [engname]	 = @engname, [address1]	 = @address1, [address2]	 = @address2, [address3]	 = @address3, [zipcode]	 = @zipcode, [city]	 = @city, [country]	 = @country, [province]	 = @province, [county]	 = @county, [phone]	 = @phone, [fax]	 = @fax, [email]	 = @email, [website]	 = @website, [source]	 = @source, [sector]	 = @sector, [size_n]	 = @size_n, [manager]	 = @manager, [agent]	 = @agent, [parentid]	 = @parentid, [department]	 = @department, [subcompanyid1]	 = @subcompanyid1, [fincode]	 = @fincode, [currency]	 = @currency, [contractlevel] = @contractlevel, [creditlevel]	 = @creditlevel, [creditoffset]	 = convert(money,@creditoffset), [discount]	 = @discount, [taxnumber]	 = @taxnumber, [bankacount]	 = @bankacount, [invoiceacount]	 = @invoiceacount, [deliverytype]	 = @deliverytype, [paymentterm]	 = @paymentterm, [paymentway]	 = @paymentway, [saleconfirm]	 = @saleconfirm, [creditcard]	 = @creditcard, [creditexpire]	 = @creditexpire, [documentid]	 = @documentid, [seclevel] = @seclevel, [picid]	 = @picid, [type]	 = @type, [typebegin]	 = @typebegin, [description]	 = @description, [status]	 = @status, [rating]	 = @rating, [datefield1]	 = @datefield1, [datefield2]	 = @datefield2, [datefield3]	 = @datefield3, [datefield4]	 = @datefield4, [datefield5]	 = @datefield5, [numberfield1]	 = @numberfield1, [numberfield2]	 = @numberfield2, [numberfield3]	 = @numberfield3, [numberfield4]	 = @numberfield4, [numberfield5]	 = @numberfield5, [textfield1]	 = @textfield1, [textfield2]	 = @textfield2, [textfield3]	 = @textfield3, [textfield4]	 = @textfield4, [textfield5]	 = @textfield5, [tinyintfield1]	 = @tinyintfield1, [tinyintfield2]	 = @tinyintfield2, [tinyintfield3]	 = @tinyintfield3, [tinyintfield4]	 = @tinyintfield4, [tinyintfield5]	 = @tinyintfield5  , introductionDocid = @introductionDocid   WHERE ( [id]	 = @id) set @flag = 1 set @msg = 'OK!' 

GO



CREATE PROCEDURE CRM_CustomerEvaluationUpdate
	(@id_1 	[int] ,
	 @evaluation_1 	[decimal](10, 2),
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
UPDATE CRM_CustomerInfo SET evaluation = @evaluation_1 where id = @id_1
GO

CREATE PROCEDURE CRM_Evaluation_Select
	(
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_Evaluation 
GO

CREATE PROCEDURE CRM_Evaluation_SelectById
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_Evaluation  where id = @id_1 	
GO


CREATE PROCEDURE CRM_Evaluation_Insert 
	(@name_1 	[varchar](50),
	 @proportion_1	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CRM_Evaluation] 
	 ([name],
	 [proportion]) 
 
VALUES 
	( @name_1,
	 @proportion_1)
GO

CREATE PROCEDURE CRM_Evaluation_Delete
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [CRM_Evaluation] 
WHERE 
	( [id]	 = @id_1)

GO

CREATE PROCEDURE CRM_Evaluation_Update 
	(@id_1 	[int] ,
	 @name_1 	[varchar](50),
	 @proportion_1	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
UPDATE CRM_Evaluation SET name = @name_1, proportion = @proportion_1 where id = @id_1
GO




CREATE PROCEDURE CRM_Evaluation_L_Select
	(
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_Evaluation_Level 
GO

CREATE PROCEDURE CRM_Evaluation_L_SelectById
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_Evaluation_Level  where id = @id_1 	
GO


CREATE PROCEDURE CRM_Evaluation_L_Insert 
	(@name_1 	[varchar](50),
	 @levelvalue_1	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CRM_Evaluation_Level] 
	 ([name],
	 [levelvalue]) 
 
VALUES 
	( @name_1,
	 @levelvalue_1)
GO

CREATE PROCEDURE CRM_Evaluation_L_Delete
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [CRM_Evaluation_Level] 
WHERE 
	( [id]	 = @id_1)

GO

CREATE PROCEDURE CRM_Evaluation_L_Update 
	(@id_1 	[int] ,
	 @name_1 	[varchar](50),
	 @levelvalue_1	[int],
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
UPDATE CRM_Evaluation_Level SET name = @name_1, levelvalue = @levelvalue_1 where id = @id_1
GO



CREATE PROCEDURE CRM_ContactLog_Unite_Update 
	(@id_1 	[int] ,
	 @id_2 	[varchar](50),
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
UPDATE CRM_ContactLog SET customerid = @id_1 where customerid = @id_2
GO


CREATE PROCEDURE CRM_Contacter_Unite_Update 
	(@id_1 	[int] ,
	 @id_2 	[varchar](50),
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
UPDATE CRM_CustomerContacter SET customerid = @id_1 , main = '0' where customerid = @id_2
GO

CREATE PROCEDURE CRM_ContacterLog_R_Insert
	(@customerid_1 	[int],
	 @daytype_1	[int],
	 @before_1	[int],
	 @isremind_1	[int],
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CRM_ContacterLog_Remind] 
	 ([customerid],[daytype],[before],[isremind])  
VALUES 
	( @customerid_1, @daytype_1 , @before_1 , @isremind_1)
GO

CREATE PROCEDURE CRM_ContacterLog_R_Update
	(@customerid_1 	[int],
	 @daytype_1	[int],
	 @before_1	[int],
	 @isremind_1	[int],
	 @flag integer output,
	 @msg varchar(80) output)
AS
UPDATE CRM_ContacterLog_Remind SET daytype = @daytype_1 , before = @before_1 , isremind = @isremind_1 where  customerid = @customerid_1
GO


CREATE PROCEDURE CRM_ContacterLog_R_SById
	(@customerid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_ContacterLog_Remind  where customerid = @customerid_1 	
GO

insert into HomePageDesign (name,iframe,height,url) values ('6057','CurrentWorkIframe','200','/system/homepage/HomePageWork.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('2118','WorkFlowIframe','200','/system/homepage/HomePageWorkFlow.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('316','NewsIframe','200','/system/homepage/HomePageNews.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6058','UnderlingWorkIframe','30','/system/homepage/HomePageUnderlingWork.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('2102','MeetingIframe','200','/system/homepage/HomePageMeeting.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6059','CustomerIframe','200','/system/homepage/HomePageCustomer.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('1037','WorkRemindIframe','200','/system/homepage/HomePageWorkRemind.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('1211','ProjectIframe','200','/system/homepage/HomePageProject.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6060','UnderlingCustomerIframe','30','/system/homepage/HomePageUnderlingCustomer.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('1213','MailIframe','30','/system/homepage/HomePageMail.jsp')
GO
insert into HomePageDesign (name,iframe,height,url) values ('6061','CustomerContactframe','200','/system/homepage/HomePageCustomerContact.jsp')
GO


insert into CRM_Evaluation (name,proportion) values ('公司规模','20')
GO
insert into CRM_Evaluation (name,proportion) values ('公司效益','10')
GO
insert into CRM_Evaluation (name,proportion) values ('公司人员素质','20')
GO
insert into CRM_Evaluation (name,proportion) values ('公司在IT投资的预算','30')
GO
insert into CRM_Evaluation (name,proportion) values ('以前上的系统','20')
GO

insert into CRM_Evaluation_Level (name,levelvalue) values ('差','1')
GO
insert into CRM_Evaluation_Level (name,levelvalue) values ('一般','2')
GO
insert into CRM_Evaluation_Level (name,levelvalue) values ('中等','3')
GO
insert into CRM_Evaluation_Level (name,levelvalue) values ('良好','4')
GO
insert into CRM_Evaluation_Level (name,levelvalue) values ('优秀','5')
GO

insert into HtmlLabelIndex (id,indexdesc) values (6057	,'今日工作')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6057,'今日工作',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6057,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6058	,'查看下属的工作安排')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6058,'查看下属的工作安排',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6058,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6059	,'我的客户')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6059,'我的客户',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6059,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6060	,'查看下属的客户')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6060,'查看下属的客户',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6060,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6061	,'客户联系提醒')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6061,'客户联系提醒',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6061,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6062	,'首页定制')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6062,'首页定制',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6062,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6063	,'降级->无效客户')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6063,'降级->无效客户',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6063,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6064	,'降级->基础客户')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6064,'降级->基础客户',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6064,'',8)
GO


insert into HtmlLabelIndex (id,indexdesc) values (6066	,'兴趣')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6066,'兴趣',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6066,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6067	,'爱好')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6067,'爱好',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6067,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6068	,'专长')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6068,'专长',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6068,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6069	,'背景资料')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6069,'背景资料',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6069,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6070	,'客户价值评估')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6070,'客户价值评估',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6070,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6071	,'权重')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6071,'权重',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6071,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6072	,'打分')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6072,'打分',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6072,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6073	,'客户价值')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6073,'客户价值',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6073,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6074	,'主')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6074,'主',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6074,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6076	,'月')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6076,'月',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6076,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6077	,'提前时间')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6077,'提前时间',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6077,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6078	,'是否提醒')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6078,'是否提醒',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6078,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6079	,'客户关怀')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6079,'客户关怀',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6079,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6080	,'客户投诉')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6080,'客户投诉',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6080,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6081	,'客户建议')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6081,'客户建议',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6081,'',8)
GO


insert into HtmlLabelIndex (id,indexdesc) values (6082	,'客户联系')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6082,'客户联系',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6082,'',8)
GO

/*2003.3.7 by chenyj*/

CREATE PROCEDURE HtmlLabelIndex_Select_ByDesc
	(@indexdesc_1 	varchar(40), @flag int output, @msg varchar(60) output)
AS select id from HtmlLabelIndex WHERE ( indexdesc	 = @indexdesc_1) 
GO


CREATE PROCEDURE WorkFlow_Bill_Delete
	(@id_1 	int, @flag int output, @msg varchar(60) output)
AS DELETE workflow_bill WHERE ( id	 = @id_1) 
GO

CREATE PROCEDURE WorkFlow_BillField_DelByBill
	(@billid_1 int, @flag int output, @msg varchar(60) output)
AS DELETE workflow_billfield WHERE ( billid	 = @billid_1)
GO

CREATE PROCEDURE WorkFlow_BillField_Delete
	(@id_1 int, @flag int output, @msg varchar(60) output)
AS DELETE workflow_billfield WHERE ( id	 = @id_1)
GO

create  PROCEDURE WorkFlow_Bill_Search
	(@labelname 	varchar(60), @flag integer output ,   @msg varchar(80) output)
AS select id from  workflow_bill WHERE ( namelabel	 = (select indexid from HtmlLabelInfo where labelname= @labelname))
GO

CREATE PROCEDURE WorkFlow_Bill_Insert
	(@id_1 	int, @namelabel_2 int, @tablename_3	varchar(60),	 @createpage_4 	varchar(255),
	 @managepage_5 	varchar(255),	 @viewpage_6 	varchar(255),	 @detailtablename_7 	varchar(60),
	 @detailkeyfield_8 	varchar(60),	 @flag int output,	 @msg varchar(60)  output)
AS INSERT INTO workflow_bill 	 ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) 
 VALUES ( @id_1, @namelabel_2, @tablename_3, @createpage_4, @managepage_5, @viewpage_6,	 @detailtablename_7, @detailkeyfield_8)
GO

CREATE PROCEDURE WorkFlow_Bill_Update
	(@id_1 	int, @namelabel_2 int, @tablename_3	varchar(60), @createpage_4 varchar(255),
	 @managepage_5 	varchar(255),	 @viewpage_6 	varchar(255),	 @detailtablename_7 	varchar(60),
	 @detailkeyfield_8 	varchar(60),    	 @flag int output,	 @msg varchar(60) output )
AS UPDATE workflow_bill 
SET  namelabel = @namelabel_2, tablename = @tablename_3, createpage = @createpage_4, managepage = @managepage_5, 
     viewpage = @viewpage_6, detailtablename = @detailtablename_7, detailkeyfield	 = @detailkeyfield_8 
WHERE 	( id	 = @id_1)
GO

CREATE PROCEDURE WorkFlow_BillField_Insert
	(@billid_2 int,	 @fieldname_3 varchar(60), @fieldlabel_4 int,
	 @fielddbtype_5 varchar(40), @fieldhtmltype_6 char(1), @type_7 int, @dsporder_8 	int,
	 @viewtype_9 	int,	 @flag int output, @msg varchar(60) output )
AS INSERT INTO workflow_billfield
	 ( billid, fieldname, fieldlabel, fielddbtype, 
	 fieldhtmltype, type, dsporder, viewtype) 
VALUES 
	( @billid_2, @fieldname_3, @fieldlabel_4, @fielddbtype_5,
	 @fieldhtmltype_6, @type_7, @dsporder_8, @viewtype_9)
GO

CREATE PROCEDURE WorkFlow_BillField_Update
	(@id_1 	int, @billid_2 int, @fieldname_3 varchar(60), @fieldlabel_4 int, @fielddbtype_5 varchar(40),
	 @fieldhtmltype_6 char(1), @type_7 int, @dsporder_8 int, @viewtype_9 int,
	 @flag int output,	 @msg varchar(60) output )
AS UPDATE workflow_billfield 
SET  billid	 = @billid_2, fieldname = @fieldname_3, fieldlabel	 = @fieldlabel_4,
	 fielddbtype	 = @fielddbtype_5, fieldhtmltype = @fieldhtmltype_6,	 type	 = @type_7,
	 dsporder	 = @dsporder_8,	 viewtype	 = @viewtype_9 

WHERE 	( id	 = @id_1)
GO


CREATE PROCEDURE HtmlLabelInfo_GetIndexId
        (@labelname_1 	varchar )
AS select indexid from HtmlLabelInfo WHERE 	( labelname	 = @labelname_1)
GO

/*2003.3.11 by chenyj */

CREATE  PROCEDURE WorkFlow_Browser_Search
	(@labelname 	varchar(60), @flag integer output ,   @msg varchar(80) output)
AS select id from  workflow_browserurl WHERE ( labelid	 = (select indexid from HtmlLabelInfo where labelname= @labelname))
GO

CREATE PROCEDURE WorkFlow_BrowserUrl_Insert
	(@id_1 	int,
	 @labelid_2 	int,
	 @fielddbtype_3 	varchar(40),
	 @browserurl_4 	varchar(255),
	 @tablename_5 	varchar(50),
	 @columname_6 	varchar(50),
	 @keycolumname_7 	varchar(50),
	 @linkurl_8 	varchar(255),
	 @flag int output,
	 @msg varchar(60) output
)
AS INSERT INTO workflow_browserurl 
	 (  labelid,
	 fielddbtype,
	 browserurl,
	 tablename,
	 columname,
	 keycolumname,
	 linkurl) 
 
VALUES 
	( @labelid_2,
	 @fielddbtype_3,
	 @browserurl_4,
	 @tablename_5,
	 @columname_6,
	 @keycolumname_7,
	 @linkurl_8)
GO


CREATE  PROCEDURE WorkFlow_BrowserUrl_Update
	(@id_1 	int,
	 @labelid_2 	int,
	 @fielddbtype_3 	varchar(40),
	 @browserurl_4 	varchar(255),
	 @tablename_5 	varchar(50),
	 @columname_6 	varchar(50),
	 @keycolumname_7 	varchar(50),
	 @linkurl_8 	varchar(255),
	 @flag int output,
	 @msg varchar(60) output
)

AS UPDATE workflow_browserurl 

SET  labelid	 = @labelid_2,
	 fielddbtype	 = @fielddbtype_3,
	 browserurl	 = @browserurl_4,
	 tablename	 = @tablename_5,
	 columname	 = @columname_6,
	 keycolumname	 = @keycolumname_7,
	 linkurl	 = @linkurl_8 

WHERE 
	( id	 = @id_1)

GO

CREATE PROCEDURE WorkFlow_BrowserUrl_Delete
	(@id_1 	int, @flag int output, @msg varchar(60) output
)

AS DELETE workflow_browserurl 

WHERE 
	( id	 = @id_1)
GO


/*2003.3.11 by chenyj --end*/

alter table HrmResource add    
  status int,
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
  fax varchar(60),
  islabouunion char(1),
  weight int,  
  tempresidentnumber varchar(60),  
  probationenddate char(10)
go


alter table HrmResource drop
 column titleid,
 column firstname,
 column  aliasname,
 column  defaultlanguage,
 column  marrydate,
 column  countryid,
 column  timezone,
 column  homepostcode,
 column  homephone,
 column  contractdate,
 column  jobgroup,
 column  jobactivity,
 column subcompanyid2,
 column subcompanyid3,
 column subcompanyid4,
 column purchaselimit,
 column currencyid,
 column bankid2,
 column accountid2,
 column securityno,
 column creditcard,
 column expirydate,
 column certificatecategory,
 column bedemocracydate,
 column homepage,
 column train,
 column worktype,
 column contractbegintime,
 column jobright, 
 column jobtype
go

create table HrmStatusHistory(
  id int IDENTITY(1,1) NOT NULL,
  resourceid int null,
  changedate char(10) null,
  changeenddate char(10) null,
  changereason text null,
  changecontractid int null,
  oldjobtitleid int null,
  oldjoblevel int null,
  newjobtitleid int null,
  newjoblevel int null,
  infoman varchar(255) null
)
go

alter table HrmFamilyInfo drop
  column createid,
  column createdate,
  column createtime,
  column lastmoderid,
  column lastmoddate,
  column lastmodtime
go

alter table HrmWorkResume drop
  column companystyle,
  column createid,
  column createdate,
  column createtime,
  column lastmoderid,
  column lastmoddate,
  column lastmodtime
go

alter table HrmEducationInfo drop
  column createid,
  column createdate,
  column createtime,
  column lastmoderid,
  column lastmoddate,
  column lastmodtime
go

create table HrmTrainBeforeWork(
  id int identity(1,1) not null,
  resourceid int null,
  trainname varchar(60) null,
  trainresource varchar(60) null,
  trainstartdate char(10) null,
  trainenddate char(10) null,
  trainmemo text null
)
go

create table HrmRewardBeforeWork(
  id int identity(1,1) not null,
  resourceid int null,
  rewardname varchar(200) null,
  rewarddate char(10) null,
  rewardmemo text null
)
go

alter table HrmBank drop
  column checkstr
go


ALTER TABLE HrmSubCompany drop CONSTRAINT DF__HrmSubCom__isdef__46E78A0C   
GO

alter table HrmSubCompany drop 
  column isdefault
go

alter table HrmDepartment drop
  column countryid,
  column addedtax,
  column website,
  column startdate,
  column enddate,
  column currencyid,
  column seclevel,
  column subcompanyid2,
  column subcompanyid3,
  column subcompanyid4,
  column createrid,
  column createrdate,
  column lastmoduserid,
  column lastmoddate
go

alter table HrmDepartment add
  supdepid int,
  allsupdepid varchar(200),
  showorder int
 go

ALTER TABLE HrmCostcenterSubCategory drop CONSTRAINT DF__HrmCostce__isdef__4F7CD00D    
GO
 
 alter table HrmCostcenterSubCategory drop
   column isdefault
go

alter table HrmCostcenter drop
  column activable,
  column ccsubcategory2,
  column ccsubcategory3,
  column ccsubcategory4
go

ALTER TABLE HrmJobTitles drop CONSTRAINT DF__HrmJobTit__joble__628FA481     
GO

ALTER TABLE HrmJobTitles drop CONSTRAINT DF__HrmJobTit__joble__6383C8BA    
GO

alter table HrmJobTitles drop
  column seclevel,
  column joblevelfrom,
  column joblevelto,
  column docid,
  column jobgroupid
go

alter table HrmJobTitles add
  jobdepartmentid int,
  jobresponsibility varchar(200),
  jobcompetency varchar(200)
go

alter table HrmJobActivities drop
  column docid,
  column jobactivityremark
go

alter table HrmJobActivities add
  joblevelfrom int,
  joblevelto int
go

alter table HrmJobGroups drop
  column docid,
  column jobgroupmark
go

alter table HrmCompany add
  companydesc text,
  companyweb varchar(200)
go

alter table HrmUserDefine add
  hasworkcode char(1),
  hasjobcall char(1),
  hasmobile char(1),
  hasmobilecall char(1),
  hasfax char(1),
  hasemail char(1),
  hasfolk char(1),
  hasregresidentplace char(1),
  hasnativeplace char(1),
  hascertificatenum char(1),
  hasmaritalstatus char(1),
  haspolicy char(1),
  hasbememberdate char(1),
  hasbepartydate char(1),
  hasislabouunion char(1),
  haseducationlevel char(1),
  hasdegree char(1),
  hashealthinfo char(1),
  hasheight char(1),
  hasweight char(1),
  hasresidentplace char(1),
  hashomeaddress char(1),
  hastempresidentnumber char(1),
  hasusekind char(1),
  hasbankid1 char(1),
  hasaccountid1 char(1),
  hasaccumfundaccount char(1),
  hasloginid char(1),
  hassystemlanguage char(1)
go


alter table HrmCertification drop 
  column createid,
  column createdate,
  column createtime,
  column lastmoderid,
  column lastmoddate,
  column lastmodtime
go


alter table HrmSearchMould drop
  column subcompany2,
  column subcompany3,
  column subcompany4
go

alter table HrmSearchMould add
 resourceidfrom int,
 resourceidto int,
 workcode varchar(60),
 jobcall int,
 mobile varchar(60),
 mobilecall varchar(60),
 fax varchar(60),
 email varchar(60),
 folk varchar(30),
 nativeplace varchar(100),
 regresidentplace varchar(60),
 maritalstatus char(1),
 certificatenum varchar(60),
 tempresidentnumber varchar(60),
 residentplace varchar(60),
 homeaddress varchar(100),
 healthinfo char(1),
 heightfrom int,
 heightto int,
 weightfrom int,
 weightto int,
 educationlevel char(1),
 degree varchar(30),
 usekind int,
 policy varchar(30),
 bememberdatefrom char(10),
 bememberdateto char(10),
 bepartydatefrom char(10),
 bepartydateto char(10),
 islabouunion char(1),
 bankid1 int,
 accountid1 varchar(100),
 accumfundaccount varchar(30),
 loginid varchar(60),
 systemlanguage int
go

create table CheckDate
(nowdate char(10) not null  
)
go

INSERT INTO CheckDate (nowdate) VALUES ('')
go

ALTER PROCEDURE HrmCompany_Update 
 (@id_1 	[tinyint], @companyname_2 	[varchar](200), @companydesc_3 text , @companyweb_4 varchar (200), @flag integer output, @msg varchar(80) output )  AS UPDATE [HrmCompany]  SET  [companyname] = @companyname_2 ,companydesc = @companydesc_3, companyweb = @companyweb_4 WHERE ( [id] = @id_1) if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

ALTER PROCEDURE HrmSubCompany_Insert 
 (@subcompanyname_1 	[varchar](200), @subcompanydesc_2 	[varchar](200), @companyid_3 	[tinyint], @flag                             integer output, @msg                             varchar(80) output)  AS  INSERT INTO [HrmSubCompany] ( [subcompanyname], [subcompanydesc], [companyid])  VALUES ( @subcompanyname_1, @subcompanydesc_2, @companyid_3) select (max(id)) from [HrmSubCompany] if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

ALTER PROCEDURE HrmSubCompany_Update 
 (@id_1 	[int], @subcompanyname_2 	[varchar](200), @subcompanydesc_3 	[varchar](200), @companyid_4 	[tinyint], @flag                             integer output, @msg                             varchar(80) output)  AS UPDATE [HrmSubCompany]  SET  [subcompanyname]	 = @subcompanyname_2, [subcompanydesc]	 = @subcompanydesc_3, [companyid]	 = @companyid_4  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO

ALTER PROCEDURE HrmDepartment_Update 
 (@id_1 [int], @departmentmark_2 [varchar](60), @departmentname_3 [varchar](200), 
  @supdepid_4 int, @allsupdepid_5 varchar(200),
   @subcompanyid1_6 	[int], @showorder_7 int,
   @flag integer output, @msg varchar(80) output  )  AS
   UPDATE [HrmDepartment]  SET  [departmentmark] = @departmentmark_2, [departmentname]	= @departmentname_3, 
   supdepid = @supdepid_4,allsupdepid = @allsupdepid_5,
   [subcompanyid1] = @subcompanyid1_6,  showorder = @showorder_7
   WHERE ( [id]	 = @id_1) 
   IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

ALTER PROCEDURE HrmDepartment_Select 
 @flag integer output , @msg varchar(80) output AS select * from HrmDepartment order by showorder set  @flag = 0 set  @msg = '操作成功完成' 
GO

 ALTER PROCEDURE HrmDepartment_Insert 
 (@departmentmark_1 [varchar](60), @departmentname_2 	[varchar](200),  
  @supdepid_3 int, @allsupdepid_4 varchar(200),
 @subcompanyid1_5 [int], @showorder_6 int,
 @flag integer output , @msg varchar(80) output )  
 AS  INSERT INTO [HrmDepartment] ( [departmentmark], [departmentname], supdepid, allsupdepid, [subcompanyid1], showorder) 
 VALUES ( @departmentmark_1, @departmentname_2, @supdepid_3, @allsupdepid_4, @subcompanyid1_5, @showorder_6) 
 select (max(id)) from [HrmDepartment] 
 if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

ALTER PROCEDURE HrmCostcenter_Insert 
 (@costcentermark_1 [varchar](60), 
  @costcentername_2 [varchar](200), 
  @departmentid_4 [int], 
  @ccsubcategory1_5 [int], 
  @flag integer output, @msg varchar(80) output )  
 AS INSERT INTO [HrmCostcenter] ( 
  [costcentermark], 
  [costcentername],  
  [departmentid], 
  [ccsubcategory1] )
 VALUES ( 
  @costcentermark_1, 
  @costcentername_2,  
  @departmentid_4, 
  @ccsubcategory1_5 )
 select max(id) from [HrmCostcenter]  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

ALTER PROCEDURE HrmCostcenter_Update 
 (@id_1 [int], @costcentermark_2 [varchar](60), @costcentername_3 [varchar](200), 
  @departmentid_5 [int], @ccsubcategory1_6 	[int],  @flag integer output, @msg varchar(80) output )  
  AS UPDATE [HrmCostcenter]  SET  [costcentermark] = @costcentermark_2, [costcentername] = @costcentername_3, 
  [departmentid] = @departmentid_5, [ccsubcategory1] = @ccsubcategory1_6  WHERE ( [id]	 = @id_1) 
  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

alter table HrmCostcenterMainCategory add
  ccmaincategorydesc text
go

 ALTER PROCEDURE HrmCostcenterMainCategory_U 
 (@id_1	[tinyint], @ccmaincategoryname_2 [varchar](200), @ccmaincategorydesc_3 text,
 @flag integer output, @msg varchar(80) output )  
 AS UPDATE [HrmCostcenterMainCategory]  SET  [ccmaincategoryname] = @ccmaincategoryname_2, ccmaincategorydesc = @ccmaincategorydesc_3  
 WHERE ( [id]	 = @id_1) IF @@error<>0 begin set @flag=1 set @msg='更新储存过程失败' return END ELSE begin set @flag=1 set @msg='更新储存过程失败' return END 
GO

ALTER PROCEDURE HrmJobGroups_Insert 
 ( @jobgroupname_2 	[varchar](200),  @jobgroupremark_4 [text], @flag integer output, @msg varchar(80) output ) 
   AS INSERT INTO [HrmJobGroups] ( [jobgroupname],  [jobgroupremark])  
   VALUES ( @jobgroupname_2, @jobgroupremark_4) select max(id) from [HrmJobGroups] 
   if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

ALTER PROCEDURE HrmJobGroups_Update 
 (@id_1 [int], @jobgroupname_3 	[varchar](200), @jobgroupremark_5	[text],
  @flag integer output, @msg varchar(80) output )  AS 
  UPDATE [HrmJobGroups]  SET  [jobgroupname] = @jobgroupname_3, [jobgroupremark] = @jobgroupremark_5  
  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

ALTER PROCEDURE HrmJobActivities_Insert 
 (@jobactivitymark_1 	[varchar](60), @jobactivityname_2 	[varchar](200), @joblevelfrom_3	[int], 
  @joblevelto_4 	int, @jobgroupid_5 	[int], 
  @flag integer output, @msg varchar(80) output )  
  AS INSERT INTO [HrmJobActivities] ( [jobactivitymark], [jobactivityname], [joblevelfrom], [joblevelto], [jobgroupid]) 
  VALUES ( @jobactivitymark_1, @jobactivityname_2, @joblevelfrom_3, @joblevelto_4, @jobgroupid_5) 
  select max(id) from  [HrmJobActivities] 
  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

ALTER PROCEDURE HrmJobActivities_Update 
 (@id_1	[int], @jobactivitymark_2 [varchar](60), @jobactivityname_3 [varchar](200), @joblevelfrom_4 [int], @joblevelto_5 int, 
  @jobgroupid_6 	[int], @flag integer output, @msg varchar(80) output )  
  AS UPDATE [HrmJobActivities]  SET  [jobactivitymark]	= @jobactivitymark_2, 
  [jobactivityname]	 = @jobactivityname_3, [joblevelfrom]	 = @joblevelfrom_4, 
  [joblevelto]	 = @joblevelto_5, [jobgroupid]	 = @jobgroupid_6  
  WHERE ( [id]	 = @id_1) 
  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 ALTER PROCEDURE HrmJobTitles_Insert 
 (@jobtitlemark_1 [varchar](60), @jobtitlename_2 [varchar](200), @jobdepartmentid_3 int, 
  @jobactivityid_4 int, @jobresponsibility_5 	varchar(200), @jobcompetency_6 	varchar(200),
  @jobtitleremark_7 [text],  @flag integer output, @msg varchar(80) output )  
  AS INSERT INTO [HrmJobTitles] ( [jobtitlemark], [jobtitlename], [jobdepartmentid], 
  [jobactivityid], [jobresponsibility], [jobcompetency], [jobtitleremark]) 
  VALUES ( @jobtitlemark_1, @jobtitlename_2, @jobdepartmentid_3, @jobactivityid_4, @jobresponsibility_5,
  @jobcompetency_6, @jobtitleremark_7)
  select max(id) from  [HrmJobTitles] 
  if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

 ALTER PROCEDURE HrmJobTitles_Update 
 (@id_1 [int], @jobtitlemark_2 	[varchar](60), @jobtitlename_3 	[varchar](200), 
  @jobdepartmentid_4 	int, @jobactivityid_5 int, @jobresponsibility_6	varchar(200), 
  @jobcompetency_7 varchar(200), @jobtitleremark_8 [text],
  @flag integer output, @msg varchar(80) output )  
  AS  UPDATE [HrmJobTitles]  SET  [jobtitlemark] = @jobtitlemark_2, [jobtitlename] = @jobtitlename_3, 
  jobdepartmentid = @jobdepartmentid_4, jobactivityid	 = @jobactivityid_5, 
  jobresponsibility = @jobresponsibility_6, jobcompetency = @jobcompetency_7, [jobtitleremark]	 = @jobtitleremark_8
  WHERE ( [id]	 = @id_1) if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end 
GO

CREATE PROCEDURE HrmResourceBasicInfo_Insert
(@id_1 int, 
 @workcode_2 varchar(60), 
 @lastname_3 varchar(60),  
 @sex_5 char(1), 
 @resoureimageid_6 int, 
 @departmentid_7 int, 
 @costcenterid_8 int, 
 @jobtitle_9 int, 
 @joblevel_10 int,
 @jobactivitydesc_11 varchar(200), 
 @managerid_12 int, 
 @assistantid_13 int, 
 @status_14 char(1),
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60), 
 @flag int output, @msg varchar(60) output)
 AS INSERT INTO HrmResource 
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
 (@id_1, 
  @workcode_2, 
  @lastname_3, 
  @sex_5, 
  @resoureimageid_6, 
  @departmentid_7, 
  @costcenterid_8, 
  @jobtitle_9, 
  @joblevel_10, 
  @jobactivitydesc_11, 
  @managerid_12, 
  @assistantid_13, 
  @status_14, 
  @locationid_15,
  @workroom_16, 
  @telephone_17, 
  @mobile_18, 
  @mobilecall_19, 
  @fax_20
)
 GO

CREATE PROCEDURE HrmResourcePersonalInfo_Insert
( @id_1 int, 
  @birthday_2 char(10), 
  @folk_3 varchar(30), 
  @nativeplace_4 varchar(100), 
  @regresidentplace_5 varchar(60), 
  @maritalstatus_6 char(1), 
  @policy_7 varchar(30),
  @bememberdate_8 char(10), 
  @bepartydate_9 char(10), 
  @islabouunion_10 char(1),
  @educationlevel_11 char(1), 
  @degree_12 varchar(30), 
  @healthinfo_13  char(1), 
  @height_14 int,
  @weight_15 int, 
  @residentplace_16 varchar(60), 
  @homeaddress_17 varchar(100),
  @tempresidentnumber_18 varchar(60), 
  @certificatenum_19 varchar(60),
  @flag int output, @msg varchar(60) output)
  AS UPDATE HrmResource SET 
  birthday = @birthday_2,
  folk = @folk_3,
  nativeplace = @nativeplace_4,
  regresidentplace = @regresidentplace_5,
  maritalstatus = @maritalstatus_6,
  policy = @policy_7,
  bememberdate = @bememberdate_8,
  bepartydate = @bepartydate_9,
  islabouunion = @islabouunion_10,
  educationlevel = @educationlevel_11,
  degree = @degree_12,
  healthinfo = @healthinfo_13,
  height = @height_14,
  weight = @weight_15,
  residentplace = @residentplace_16,
  homeaddress = @homeaddress_17,
  tempresidentnumber = @tempresidentnumber_18,
  certificatenum = @certificatenum_19
WHERE
  id = @id_1
GO

CREATE PROCEDURE HrmResourceWorkInfo_Insert
(@id_1 int,
 @usekind_2 int, 
 @startdate_3 char(10),
 @probationenddate_4 char(10), 
 @enddate_5 char(10),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmResource SET
 usekind = @usekind_2,
 startdate = @startdate_3,
 probationenddate = @probationenddate_4,
 enddate = @enddate_5 
WHERE
 id = @id_1

GO

CREATE PROCEDURE HrmResourceFinanceInfo_Insert
(@id_1 int,
 @bankid1_2 int,
 @accountid1_3 varchar(30),
 @accumfundaccount_4 varchar(30),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmResource SET
 bankid1 = @bankid1_2,
 accountid1 = @accountid1_3 ,
 accumfundaccount = @accumfundaccount_4
WHERE
 id = @id_1
GO

CREATE PROCEDURE HrmResourceSystemInfo_Insert
(@id_1 int,
 @loginid_2 varchar(20),
 @password_3 varchar(60),
 @systemlanguage_4 int,
 @seclevel_5 int,
 @email_6 varchar(60),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmResource SET
 loginid = @loginid_2,
 password = @password_3,
 systemlanguage = @systemlanguage_4,
 seclevel = @seclevel_5,
 email = @email_6
WHERE
 id = @id_1
GO

ALTER  PROCEDURE Employee_SelectByHrmid
	@hrmid_1    int,
	@flag		int	output, 
	@msg		varchar(80) output
as
select itemid,status from HrmInfoStatus WHERE hrmid=@hrmid_1 AND itemid<10  order by itemid
go


alter  PROCEDURE Employee_LoginUpdate
	@loginid_1 varchar(60),
	@password_1 varchar(100),
	@hrmid_1  int,
	@flag		int	output, 
	@msg		varchar(80) output
as
declare
@count_1 int
/*判断是否有重复登录名*/
select @count_1=count(*) from HrmResource where loginid = @loginid_1 and id<>@hrmid_1
if @count_1<>0
begin
select -1
return
end
else 
	if @password_1 = 'novalue$1'   
	begin
	update HrmResource
	set
	loginid=@loginid_1,
	systemlanguage=7,	
	resourcetype='2',
	seclevel=10
	WHERE id= @hrmid_1
	end
	else
	begin
	update HrmResource
	set
	loginid=@loginid_1,
	password=@password_1,
	systemlanguage=7,	
	resourcetype='2',
	seclevel=10
	WHERE id= @hrmid_1
	end
update HrmInfoStatus
set
status = '1'
WHERE itemid=1 AND hrmid=@hrmid_1
go

CREATE PROCEDURE HrmResource_Fire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5)
UPDATE HrmResource SET
 enddate = @changedate_2
WHERE
 id = @id_1
GO

CREATE PROCEDURE HrmResource_Hire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @infoman_5 varchar(255),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @infoman_5)
GO

CREATE PROCEDURE HrmResource_Extend
(@id_1 int,
 @changedate_2 char(10),
 @changeenddate_3 char(10),
 @changereason_4 char(10),
 @changecontractid_5 int,
 @infoman_6 varchar(255),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman)
VALUES
(@id_1, 
 @changedate_2,
 @changeenddate_3,
 @changereason_4,
 @changecontractid_5,
 @infoman_6)
UPDATE HrmResource SET
 enddate = @changeenddate_3
WHERE
 id = @id_1
GO

CREATE PROCEDURE HrmResource_Redeploy
(@id_1 int,
 @changedate_2 char(10),
 @changereason_4 char(10),
 @oldjobtitleid_7 int,
 @oldjoblevel_8 int,
 @newjobtitleid_9 int,
 @newjoblevel_10 int,
 @infoman_6 varchar(255),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 oldjobtitleid,
 oldjoblevel,
 newjobtitleid,
 newjoblevel,
 infoman)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_4,
 @oldjobtitleid_7,
 @oldjoblevel_8,
 @newjobtitleid_9,
 @newjoblevel_10,
 @infoman_6)
go

CREATE PROCEDURE HrmResource_Rehire
(@id_1 int,
 @changedate_2 char(10),
 @changeenddate_3 char(10),
 @changereason_4 char(10),
 @changecontractid_5 int,
 @infoman_6 varchar(255),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman)
VALUES
(@id_1, 
 @changedate_2,
 @changeenddate_3,
 @changereason_4,
 @changecontractid_5,
 @infoman_6)
UPDATE HrmResource SET
 startdate = @changedate_2,
 enddate = @changeenddate_3
WHERE
 id = @id_1
GO

ALTER  PROCEDURE HrmFamilyInfo_Insert 
 (@resourceid_1 	int, 
  @member_2 	varchar(30),
  @title_3 	varchar(30),
  @company_4 	varchar(100), 
  @jobtitle_5 	varchar(100),
  @address_6 	varchar(100),
  @flag integer output, @msg varchar(80) output)  
AS INSERT INTO HrmFamilyInfo 
 ( resourceid, 
   member, 
   title, 
   company, 
   jobtitle, 
   address) 
VALUES 
( @resourceid_1, 
  @member_2, 
  @title_3, 
  @company_4, 
  @jobtitle_5, 
  @address_6  ) 
GO




ALTER  PROCEDURE HrmWorkResume_Insert 
 (@resourceid_1 	int, 
  @startdate_2 	char(10),
  @enddate_3 	char(10),
  @company_4 	varchar(100),   
  @jobtitle_6 	varchar(30), 
  @workdesc_7 	text, 
  @leavereason_8 	varchar(200), 
  @flag integer output, @msg varchar(80) output)  
AS INSERT INTO HrmWorkResume 
( resourceid, 
  startdate, 
  enddate, 
  company,  
  jobtitle, 
  workdesc, 
  leavereason )  
VALUES 
( @resourceid_1, 
  @startdate_2, 
  @enddate_3, 
  @company_4, 
  @jobtitle_6, 
  @workdesc_7, 
  @leavereason_8)   
GO





ALTER  PROCEDURE HrmEducationInfo_Insert 
 (@resourceid_1 	int,
  @startdate_2 	char(10),
  @enddate_3 	char(10), 
  @school_4 	varchar(100), 
  @speciality_5 	varchar(60)
, @educationlevel_6 	char(1),
  @studydesc_7 	text,
  @flag integer output, @msg varchar(80) output) 
AS INSERT INTO HrmEducationInfo 
( resourceid, 
  startdate, 
  enddate, 
  school, 
  speciality, 
  educationlevel, 
  studydesc)
 VALUES 
( @resourceid_1, 
  @startdate_2,
  @enddate_3,
  @school_4,
  @speciality_5,
  @educationlevel_6
, @studydesc_7) 

GO


create  PROCEDURE HrmTrainBeforeWork_Insert 
 (@resourceid_1 	int,
  @trainname_2 	varchar(60), 
  @trainresource_3 	varchar(200),
  @trainstartdate_4 	char(10),
  @trainenddate_5 	char(10),  
  @trainmemo_6 text,
  @flag integer output, @msg varchar(80) output) 
AS INSERT INTO HrmTrainBeforeWork 
( resourceid, 
  trainname,
  trainresource,
  trainstartdate, 
  trainenddate,
  trainmemo)
 VALUES 
( @resourceid_1, 
  @trainname_2,
  @trainresource_3,
  @trainstartdate_4,
  @trainenddate_5,
  @trainmemo_6) 
GO

create  PROCEDURE HrmRewardBeforeWork_Insert 
 (@resourceid_1 	int,
  @rewardname_2 	varchar(60), 
  @rewarddate_3 	char(10),
  @rewardmemo_4         text,
  @flag integer output, @msg varchar(80) output) 
AS INSERT INTO HrmRewardBeforeWork 
( resourceid, 
  rewardname,
  rewarddate,
  rewardmemo)
 VALUES 
( @resourceid_1, 
  @rewardname_2,
  @rewarddate_3,
  @rewardmemo_4) 
GO

CREATE PROCEDURE HrmResourceBasicInfo_Update
(@id_1 int, 
 @workcode_2 varchar(60), 
 @lastname_3 varchar(60), 
 @sex_5 char(1), 
 @resoureimageid_6 int, 
 @departmentid_7 int, 
 @costcenterid_8 int, 
 @jobtitle_9 int, 
 @joblevel_10 int,
 @jobactivitydesc_11 varchar(200), 
 @managerid_12 int, 
 @assistantid_13 int, 
 @status_14 char(1),
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60), 
 @flag int output, @msg varchar(60) output)
 AS UPDATE HrmResource SET
 workcode =   @workcode_2,
 lastname =  @lastname_3,
 sex =   @sex_5, 
 resourceimageid =   @resoureimageid_6, 
 departmentid =   @departmentid_7, 
 costcenterid =   @costcenterid_8, 
 jobtitle =   @jobtitle_9, 
 joblevel =   @joblevel_10, 
 jobactivitydesc =   @jobactivitydesc_11, 
 managerid =   @managerid_12, 
 assistantid =   @assistantid_13, 
 status =   @status_14, 
 locationid =   @locationid_15,
 workroom =   @workroom_16, 
 telephone =   @telephone_17, 
 mobile =   @mobile_18, 
 mobilecall =   @mobilecall_19, 
 fax =   @fax_20 
 WHERE
 id =  @id_1 
 GO

CREATE PROCEDURE HrmResourceContactInfo_Update
(@id_1 int, 
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60), 
 @flag int output, @msg varchar(60) output)
 AS UPDATE HrmResource SET
 locationid =   @locationid_15,
 workroom =   @workroom_16, 
 telephone =   @telephone_17, 
 mobile =   @mobile_18, 
 mobilecall =   @mobilecall_19, 
 fax =   @fax_20 
 WHERE
 id =  @id_1 
 GO

ALTER PROCEDURE HrmFamilyInfo_Delete
(@id_1 int, 
 @flag int output, @msg varchar(60) output)
 AS DELETE HrmFamilyInfo 
 WHERE 
 resourceid = @id_1
 go


alter PROCEDURE HrmResource_SelectAll 
 (@flag integer output, @msg varchar(80) output ) 
  AS select 
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
  seclevel from HrmResource  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO

alter table HrmStatusHistory add
type_n int null
/*
1、解聘
2、转正
3、续签
4、调动
5、离职
6、退休
7、反聘
*/
go

CREATE PROCEDURE HrmResource_UpdateManagerStr
(@id_1 int,
 @managerstr_2 varchar(200),
 @flag int output, @msg varchar(60) output)
AS UPDATE HrmResource SET
  managerstr = @managerstr_2
WHERE
  id = @id_1
GO

alter PROCEDURE HrmResource_Fire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),  
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7 ,
 @type_n_8 )
UPDATE HrmResource SET
 status = '4',
 enddate = @changedate_2
WHERE
 id = @id_1
GO

alter PROCEDURE HrmResource_Hire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),  
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman,
 oldjobtitleid,
 type_n  )
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @infoman_5,
 @oldjobtitleid_7 ,
 @type_n_8   )
update HrmResource set
 status = '1'
where 
 id = @id_1
GO

alter PROCEDURE HrmResource_Extend
(@id_1 int,
 @changedate_2 char(10),
 @changeenddate_3 char(10),
 @changereason_4 char(10),
 @changecontractid_5 int,
 @infoman_6 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1), 
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changeenddate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changeenddate_3,
 @changereason_4,
 @changecontractid_5,
 @infoman_6,
 @oldjobtitleid_7 ,
 @type_n_8)
UPDATE HrmResource SET
 enddate = @changeenddate_3
WHERE
 id = @id_1
GO

alter PROCEDURE HrmResource_Redeploy
(@id_1 int,
 @changedate_2 char(10),
 @changereason_4 char(10),
 @oldjobtitleid_7 int,
 @oldjoblevel_8 int,
 @newjobtitleid_9 int,
 @newjoblevel_10 int,
 @infoman_6 varchar(255),
 @type_n_11 int,
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
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
(@id_1, 
 @changedate_2,
 @changereason_4,
 @oldjobtitleid_7,
 @oldjoblevel_8,
 @newjobtitleid_9,
 @newjoblevel_10,
 @infoman_6,
 @type_n_11)
go

create procedure HrmResource_Dismiss
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1), 
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7,
 @type_n_8)
UPDATE HrmResource SET
 status = '5',
 enddate = @changedate_2
WHERE
 id = @id_1
GO

create PROCEDURE HrmResource_Retire
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @changecontractid_4 int,
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
(resourceid,
 changedate,
 changereason,
 changecontractid,
 infoman,
 oldjobtitleid,
 type_n)
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @changecontractid_4,
 @infoman_5,
 @oldjobtitleid_7,
 @type_n_8)
UPDATE HrmResource SET
 status = '6',
 enddate = @changedate_2
WHERE
 id = @id_1
GO

alter PROCEDURE HrmResource_Rehire
(@id_1 int,
 @changedate_2 char(10),
 @changeenddate_3 char(10),
 @changereason_4 char(10),
 @changecontractid_5 int,
 @infoman_6 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory 
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
(@id_1, 
 @changedate_2,
 @changeenddate_3,
 @changereason_4,
 @changecontractid_5,
 @infoman_6,
 @oldjobtitleid_7 ,
 @type_n_8
 )
UPDATE HrmResource SET
 status = '1',
 startdate = @changedate_2,
 enddate = @changeenddate_3
WHERE
 id = @id_1
GO


alter PROCEDURE HrmResourceBasicInfo_Insert
(@id_1 int, 
 @workcode_2 varchar(60), 
 @lastname_3 varchar(60),  
 @sex_5 char(1), 
 @resoureimageid_6 int, 
 @departmentid_7 int, 
 @costcenterid_8 int, 
 @jobtitle_9 int, 
 @joblevel_10 int,
 @jobactivitydesc_11 varchar(200), 
 @managerid_12 int, 
 @assistantid_13 int, 
 @status_14 char(1),
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60),
 @jobcall_21 int,
 @flag int output, @msg varchar(60) output)
 AS INSERT INTO HrmResource 
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
 (@id_1, 
  @workcode_2, 
  @lastname_3, 
  @sex_5, 
  @resoureimageid_6, 
  @departmentid_7, 
  @costcenterid_8, 
  @jobtitle_9, 
  @joblevel_10, 
  @jobactivitydesc_11, 
  @managerid_12, 
  @assistantid_13, 
  @status_14, 
  @locationid_15,
  @workroom_16, 
  @telephone_17, 
  @mobile_18, 
  @mobilecall_19, 
  @fax_20,
  @jobcall_21
)
 GO

alter PROCEDURE HrmResourceBasicInfo_Update
(@id_1 int, 
 @workcode_2 varchar(60), 
 @lastname_3 varchar(60), 
 @sex_5 char(1), 
 @resoureimageid_6 int, 
 @departmentid_7 int, 
 @costcenterid_8 int, 
 @jobtitle_9 int, 
 @joblevel_10 int,
 @jobactivitydesc_11 varchar(200), 
 @managerid_12 int, 
 @assistantid_13 int, 
 @status_14 char(1),
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60), 
 @jobcall_21 int,
 @systemlanguage_22 int,
 @flag int output, @msg varchar(60) output)
 AS UPDATE HrmResource SET
 workcode =   @workcode_2,
 lastname =  @lastname_3,
 sex =   @sex_5, 
 resourceimageid =   @resoureimageid_6, 
 departmentid =   @departmentid_7, 
 costcenterid =   @costcenterid_8, 
 jobtitle =   @jobtitle_9, 
 joblevel =   @joblevel_10, 
 jobactivitydesc =   @jobactivitydesc_11, 
 managerid =   @managerid_12, 
 assistantid =   @assistantid_13, 
 status =   @status_14, 
 locationid =   @locationid_15,
 workroom =   @workroom_16, 
 telephone =   @telephone_17, 
 mobile =   @mobile_18, 
 mobilecall =   @mobilecall_19, 
 fax =   @fax_20,
 jobcall = @jobcall_21,
 systemlanguage = @systemlanguage_22
 WHERE
 id =  @id_1 
 GO

 alter PROCEDURE HrmCertification_Insert 
	(@resourceid_1 	[int],
	 @datefrom_2 	[char](10),
	 @dateto_3 	[char](10),
	 @certname_4 	[varchar](60),
	 @awardfrom_5 	[varchar](100),
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [HrmCertification] 
	 ( [resourceid],
	 [datefrom],
	 [dateto],
	 [certname],
	 [awardfrom])	
VALUES 
	( @resourceid_1,
	 @datefrom_2,
	 @dateto_3,
	 @certname_4,
	 @awardfrom_5)
GO

 alter PROCEDURE HrmCertification_Update 
	(@id_1 	[int],
	 @resourceid_2 	[int],
	 @datefrom_3 	[char](10),
	 @dateto_4 	[char](10),
	 @certname_5 	[varchar](60),
	 @awardfrom_6 	[varchar](100),
	 @flag integer output,
	 @msg varchar(80) output)

AS UPDATE [HrmCertification] 

SET  [resourceid]	 = @resourceid_2,
	 [datefrom]	 = @datefrom_3,
	 [dateto]	 = @dateto_4,
	 [certname]	 = @certname_5,
	 [awardfrom]	 = @awardfrom_6
WHERE 
	( [id]	 = @id_1)

GO

UPDATE HrmResource SET status = 1
GO

alter PROCEDURE HrmResourceContactInfo_Update
(@id_1 int, 
 @locationid_15 int, 
 @workroom_16 varchar(60), 
 @telephone_17 varchar(60), 
 @mobile_18 varchar(60),
 @mobilecall_19 varchar(30) , 
 @fax_20 varchar(60), 
 @systemlanguage_21 int,
 @flag int output, @msg varchar(60) output)
 AS UPDATE HrmResource SET
 locationid =   @locationid_15,
 workroom =   @workroom_16, 
 telephone =   @telephone_17, 
 mobile =   @mobile_18, 
 mobilecall =   @mobilecall_19, 
 fax =   @fax_20 ,
 systemlanguage = @systemlanguage_21
 WHERE
 id =  @id_1 
 GO

 alter PROCEDURE HrmCostcenterSubCategory_D 
 (@id_1 [int], 
  @flag integer output, @msg varchar(80) output )  
 AS DELETE [HrmCostcenterSubCategory]  
 WHERE ( [id]	 = @id_1) 
GO

 alter PROCEDURE HrmUserDefine_Insert 
 	(@userid_1 		[int],
	 @hasresourceid_2 	[char](1),
	 @hasresourcename_3 	[char](1),
	 @hasjobtitle_4 	[char](1),
	 @hasactivitydesc_5 	[char](1),
	 @hasjobgroup_6 	[char](1),
	 @hasjobactivity_7 	[char](1),
	 @hascostcenter_8 	[char](1),
	 @hascompetency_9 	[char](1),
	 @hasresourcetype_10 	[char](1),
	 @hasstatus_11 		[char](1),
	 @hassubcompany_12 	[char](1),
	 @hasdepartment_13 	[char](1),
	 @haslocation_14 	[char](1),
	 @hasmanager_15 	[char](1),
	 @hasassistant_16 	[char](1),
	 @hasroles_17 		[char](1),
	 @hasseclevel_18 	[char](1),
	 @hasjoblevel_19 	[char](1),
	 @hasworkroom_20 	[char](1),
	 @hastelephone_21 	[char](1),
	 @hasstartdate_22 	[char](1),
	 @hasenddate_23 	[char](1),
	 @hascontractdate_24 	[char](1),
	 @hasbirthday_25 	[char](1),
	 @hassex_26 		[char](1),
	 @projectable_27 	[char](1),
	 @crmable_28 		[char](1),
	 @itemable_29 		[char](1),
	 @docable_30 		[char](1),
	 @workflowable_31 	[char](1),
	 @subordinateable_32 	[char](1),
	 @trainable_33 		[char](1),
	 @budgetable_34 	[char](1),
	 @fnatranable_35 	[char](1),
	 @dspperpage_36 	[tinyint],
	 @hasage_37 		[char](1),
	 @hasworkcode_38 	[char](1),
	 @hasjobcall_39 	[char](1),
	 @hasmobile_40 		[char](1),
	 @hasmobilecall_41 	[char](1),
	 @hasfax_42 		[char](1),
	 @hasemail_43 		[char](1),
	 @hasfolk_44 		[char](1),
	 @hasregresidentplace_45[char](1),
	 @hasnativeplace_46 	[char](1),
	 @hascertificatenum_47 	[char](1),
	 @hasmaritalstatus_48 	[char](1),
	 @haspolicy_49 		[char](1),
	 @hasbememberdate_50 	[char](1),
	 @hasbepartydate_51 	[char](1),
	 @hasislabouunion_52 	[char](1),
	 @haseducationlevel_53 	[char](1),
	 @hasdegree_54 		[char](1),
	 @hashealthinfo_55 	[char](1),
	 @hasheight_56 		[char](1),
	 @hasweight_57 		[char](1),
	 @hasresidentplace_58 	[char](1),
	 @hashomeaddress_59 	[char](1),
	 @hastempresidentnumber_60 	[char](1),
	 @hasusekind_61 	[char](1),
	 @hasbankid1_62 	[char](1),
	 @hasaccountid1_63 	[char](1),
	 @hasaccumfundaccount_64 [char](1),
	 @hasloginid_65 	[char](1),
	 @hassystemlanguage_66 	[char](1),
	 @flag integer output, @msg varchar(80) output )  
AS DECLARE @recordercount integer
 Select @recordercount = count(userid) from HrmUserDefine 
where userid =convert(int, @userid_1)
 if @recordercount = 0
 begin INSERT INTO [HrmUserDefine]
	 ([userid],
	 [hasresourceid],
	 [hasresourcename],
	 [hasjobtitle],
	 [hasactivitydesc],
	 [hasjobgroup],
	 [hasjobactivity],
	 [hascostcenter],
	 [hascompetency],
	 [hasresourcetype],
	 [hasstatus],
	 [hassubcompany],
	 [hasdepartment],
	 [haslocation],
	 [hasmanager],
	 [hasassistant],
	 [hasroles],
	 [hasseclevel],
	 [hasjoblevel],
	 [hasworkroom],
	 [hastelephone],
	 [hasstartdate],
	 [hasenddate],
	 [hascontractdate],
	 [hasbirthday],
	 [hassex],
	 [projectable],
	 [crmable],
	 [itemable],
	 [docable],
	 [workflowable],
	 [subordinateable],
	 [trainable],
	 [budgetable],
	 [fnatranable],
	 [dspperpage],
	 [hasage],
	 [hasworkcode],
	 [hasjobcall],
	 [hasmobile],
	 [hasmobilecall],
	 [hasfax],
	 [hasemail],
	 [hasfolk],
	 [hasregresidentplace],
	 [hasnativeplace],
	 [hascertificatenum],
	 [hasmaritalstatus],
	 [haspolicy],
	 [hasbememberdate],
	 [hasbepartydate],
	 [hasislabouunion],
	 [haseducationlevel],
	 [hasdegree],
	 [hashealthinfo],
	 [hasheight],
	 [hasweight],
	 [hasresidentplace],
	 [hashomeaddress],
	 [hastempresidentnumber],
	 [hasusekind],
	 [hasbankid1],
	 [hasaccountid1],
	 [hasaccumfundaccount],
	 [hasloginid],
	 [hassystemlanguage]) 
VALUES 
	(@userid_1,
	 @hasresourceid_2,
	 @hasresourcename_3,
	 @hasjobtitle_4,
	 @hasactivitydesc_5,
	 @hasjobgroup_6,
	 @hasjobactivity_7,
	 @hascostcenter_8,
	 @hascompetency_9,
	 @hasresourcetype_10,
	 @hasstatus_11,
	 @hassubcompany_12,
	 @hasdepartment_13,
	 @haslocation_14,
	 @hasmanager_15,
	 @hasassistant_16,
	 @hasroles_17,
	 @hasseclevel_18,
	 @hasjoblevel_19,
	 @hasworkroom_20,
	 @hastelephone_21,
	 @hasstartdate_22,
	 @hasenddate_23,
	 @hascontractdate_24,
	 @hasbirthday_25,
	 @hassex_26,
	 @projectable_27,
	 @crmable_28,
	 @itemable_29,
	 @docable_30,
	 @workflowable_31,
	 @subordinateable_32,
	 @trainable_33,
	 @budgetable_34,
	 @fnatranable_35,
	 @dspperpage_36,
	 @hasage_37,
	 @hasworkcode_38,
	 @hasjobcall_39,
	 @hasmobile_40,
	 @hasmobilecall_41,
	 @hasfax_42,
	 @hasemail_43,
	 @hasfolk_44,
	 @hasregresidentplace_45,
	 @hasnativeplace_46,
	 @hascertificatenum_47,
	 @hasmaritalstatus_48,
	 @haspolicy_49,
	 @hasbememberdate_50,
	 @hasbepartydate_51,
	 @hasislabouunion_52,
	 @haseducationlevel_53,
	 @hasdegree_54,
	 @hashealthinfo_55,
	 @hasheight_56,
	 @hasweight_57,
	 @hasresidentplace_58,
	 @hashomeaddress_59,
	 @hastempresidentnumber_60,
	 @hasusekind_61,
	 @hasbankid1_62,
	 @hasaccountid1_63,
	 @hasaccumfundaccount_64,
	 @hasloginid_65,
	 @hassystemlanguage_66)
end else begin UPDATE [HrmUserDefine]  SET  
	 [hasresourceid]	 = @hasresourceid_2,
	 [hasresourcename]	 = @hasresourcename_3,
	 [hasjobtitle]		 = @hasjobtitle_4,
	 [hasactivitydesc]	 = @hasactivitydesc_5,
	 [hasjobgroup]		 = @hasjobgroup_6,
	 [hasjobactivity]	 = @hasjobactivity_7,
	 [hascostcenter]	 = @hascostcenter_8,
	 [hascompetency]	 = @hascompetency_9,
	 [hasresourcetype]	 = @hasresourcetype_10,
	 [hasstatus]		 = @hasstatus_11,
	 [hassubcompany]	 = @hassubcompany_12,
	 [hasdepartment]	 = @hasdepartment_13,
	 [haslocation]	 = @haslocation_14,
	 [hasmanager]	 = @hasmanager_15,
	 [hasassistant]	 = @hasassistant_16,
	 [hasroles]	 = @hasroles_17,
	 [hasseclevel]	 = @hasseclevel_18,
	 [hasjoblevel]	 = @hasjoblevel_19,
	 [hasworkroom]	 = @hasworkroom_20,
	 [hastelephone]	 = @hastelephone_21,
	 [hasstartdate]	 = @hasstartdate_22,
	 [hasenddate]	 = @hasenddate_23,
	 [hascontractdate]	 = @hascontractdate_24,
	 [hasbirthday]	 = @hasbirthday_25,
	 [hassex]	 = @hassex_26,
	 [projectable]	 = @projectable_27,
	 [crmable]	 = @crmable_28,
	 [itemable]	 = @itemable_29,
	 [docable]	 = @docable_30,
	 [workflowable]	 = @workflowable_31,
	 [subordinateable]	 = @subordinateable_32,
	 [trainable]	 = @trainable_33,
	 [budgetable]	 = @budgetable_34,
	 [fnatranable]	 = @fnatranable_35,
	 [dspperpage]	 = @dspperpage_36,
	 [hasage]	 = @hasage_37,
	 [hasworkcode]	 = @hasworkcode_38,
	 [hasjobcall]	 = @hasjobcall_39,
	 [hasmobile]	 = @hasmobile_40,
	 [hasmobilecall]	 = @hasmobilecall_41,
	 [hasfax]	 = @hasfax_42,
	 [hasemail]	 = @hasemail_43,
	 [hasfolk]	 = @hasfolk_44,
	 [hasregresidentplace]	 = @hasregresidentplace_45,
	 [hasnativeplace]	 = @hasnativeplace_46,
	 [hascertificatenum]	 = @hascertificatenum_47,
	 [hasmaritalstatus]	 = @hasmaritalstatus_48,
	 [haspolicy]	 = @haspolicy_49,
	 [hasbememberdate]	 = @hasbememberdate_50,
	 [hasbepartydate]	 = @hasbepartydate_51,
	 [hasislabouunion]	 = @hasislabouunion_52,
	 [haseducationlevel]	 = @haseducationlevel_53,
	 [hasdegree]	 = @hasdegree_54,
	 [hashealthinfo]	 = @hashealthinfo_55,
	 [hasheight]	 = @hasheight_56,
	 [hasweight]	 = @hasweight_57,
	 [hasresidentplace]	 = @hasresidentplace_58,
	 [hashomeaddress]	 = @hashomeaddress_59,
	 [hastempresidentnumber]	 = @hastempresidentnumber_60,
	 [hasusekind]	 = @hasusekind_61,
	 [hasbankid1]	 = @hasbankid1_62,
	 [hasaccountid1]	 = @hasaccountid1_63,
	 [hasaccumfundaccount]	 = @hasaccumfundaccount_64,
	 [hasloginid]	 = @hasloginid_65,
	 [hassystemlanguage]	 = @hassystemlanguage_66 
WHERE ( [userid]	 = @userid_1) end if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end

GO

alter PROCEDURE [HrmSearchMould_Insert]
	(@mouldname_1 	[varchar](200),
	 @userid_2 	[int],
	 @resourceid_3 	[int],
	 @resourcename_4 	[varchar](60),
	 @jobtitle_5 	[int],
	 @activitydesc_6 	[varchar](200),
	 @jobgroup_7 	[int],
	 @jobactivity_8 	[int],
	 @costcenter_9 	[int],
	 @competency_10 	[int],
	 @resourcetype_11 	[char](1),
	 @status_12 	[char](1),
	 @subcompany1_13 	[int],
	 @department_14 	[int],
	 @location_15 	[int],
	 @manager_16 	[int],
	 @assistant_17 	[int],
	 @roles_18 	[int],
	 @seclevel_19 	[tinyint],
	 @joblevel_20 	[tinyint],
	 @workroom_21 	[varchar](60),
	 @telephone_22 	[varchar](60),
	 @startdate_23 	[char](10),
	 @enddate_24 	[char](10),
	 @contractdate_25 	[char](10),
	 @birthday_26 	[char](10),
	 @sex_27 	[char](1),
	 @seclevelTo_28 	[tinyint],
	 @joblevelTo_29 	[tinyint],
	 @startdateTo_30 	[char](10),
	 @enddateTo_31 	[char](10),
	 @contractdateTo_32 	[char](10),
	 @birthdayTo_33 	[char](10),
	 @age_34 	[int],
	 @ageTo_35 	[int],
	 @resourceidfrom_36 	[int],
	 @resourceidto_37 	[int],
	 @workcode_38 	[varchar](60),
	 @jobcall_39 	[int],
	 @mobile_40 	[varchar](60),
	 @mobilecall_41 	[varchar](60),
	 @fax_42 	[varchar](60),
	 @email_43 	[varchar](60),
	 @folk_44 	[varchar](30),
	 @nativeplace_45 	[varchar](100),
	 @regresidentplace_46 	[varchar](60),
	 @maritalstatus_47 	[char](1),
	 @certificatenum_48 	[varchar](60),
	 @tempresidentnumber_49 	[varchar](60),
	 @residentplace_50 	[varchar](60),
	 @homeaddress_51 	[varchar](100),
	 @healthinfo_52 	[char](1),
	 @heightfrom_53 	[int],
	 @heightto_54 	[int],
	 @weightfrom_55 	[int],
	 @weightto_56 	[int],
	 @educationlevel_57 	[char](1),
	 @degree_58 	[varchar](30),
	 @usekind_59 	[int],
	 @policy_60 	[varchar](30),
	 @bememberdatefrom_61 	[char](10),
	 @bememberdateto_62 	[char](10),
	 @bepartydatefrom_63 	[char](10),
	 @bepartydateto_64 	[char](10),
	 @islabouunion_65 	[char](1),
	 @bankid1_66 	[int],
	 @accountid1_67 	[varchar](100),
	 @accumfundaccount_68 	[varchar](30),
	 @loginid_69 	[varchar](60),
	 @systemlanguage_70 	[int],
	 @flag int output, @msg varchar(60) output)

AS INSERT INTO [HrmSearchMould] 
	 ( [mouldname],
	 [userid],
	 [resourceid],
	 [resourcename],
	 [jobtitle],
	 [activitydesc],
	 [jobgroup],
	 [jobactivity],
	 [costcenter],
	 [competency],
	 [resourcetype],
	 [status],
	 [subcompany1],
	 [department],
	 [location],
	 [manager],
	 [assistant],
	 [roles],
	 [seclevel],
	 [joblevel],
	 [workroom],
	 [telephone],
	 [startdate],
	 [enddate],
	 [contractdate],
	 [birthday],
	 [sex],
	 [seclevelTo],
	 [joblevelTo],
	 [startdateTo],
	 [enddateTo],
	 [contractdateTo],
	 [birthdayTo],
	 [age],
	 [ageTo],
	 [resourceidfrom],
	 [resourceidto],
	 [workcode],
	 [jobcall],
	 [mobile],
	 [mobilecall],
	 [fax],
	 [email],
	 [folk],
	 [nativeplace],
	 [regresidentplace],
	 [maritalstatus],
	 [certificatenum],
	 [tempresidentnumber],
	 [residentplace],
	 [homeaddress],
	 [healthinfo],
	 [heightfrom],
	 [heightto],
	 [weightfrom],
	 [weightto],
	 [educationlevel],
	 [degree],
	 [usekind],
	 [policy],
	 [bememberdatefrom],
	 [bememberdateto],
	 [bepartydatefrom],
	 [bepartydateto],
	 [islabouunion],
	 [bankid1],
	 [accountid1],
	 [accumfundaccount],
	 [loginid],
	 [systemlanguage]) 
 
VALUES 
	( @mouldname_1,
	 @userid_2,
	 @resourceid_3,
	 @resourcename_4,
	 @jobtitle_5,
	 @activitydesc_6,
	 @jobgroup_7,
	 @jobactivity_8,
	 @costcenter_9,
	 @competency_10,
	 @resourcetype_11,
	 @status_12,
	 @subcompany1_13,
	 @department_14,
	 @location_15,
	 @manager_16,
	 @assistant_17,
	 @roles_18,
	 @seclevel_19,
	 @joblevel_20,
	 @workroom_21,
	 @telephone_22,
	 @startdate_23,
	 @enddate_24,
	 @contractdate_25,
	 @birthday_26,
	 @sex_27,
	 @seclevelTo_28,
	 @joblevelTo_29,
	 @startdateTo_30,
	 @enddateTo_31,
	 @contractdateTo_32,
	 @birthdayTo_33,
	 @age_34,
	 @ageTo_35,
	 @resourceidfrom_36,
	 @resourceidto_37,
	 @workcode_38,
	 @jobcall_39,
	 @mobile_40,
	 @mobilecall_41,
	 @fax_42,
	 @email_43,
	 @folk_44,
	 @nativeplace_45,
	 @regresidentplace_46,
	 @maritalstatus_47,
	 @certificatenum_48,
	 @tempresidentnumber_49,
	 @residentplace_50,
	 @homeaddress_51,
	 @healthinfo_52,
	 @heightfrom_53,
	 @heightto_54,
	 @weightfrom_55,
	 @weightto_56,
	 @educationlevel_57,
	 @degree_58,
	 @usekind_59,
	 @policy_60,
	 @bememberdatefrom_61,
	 @bememberdateto_62,
	 @bepartydatefrom_63,
	 @bepartydateto_64,
	 @islabouunion_65,
	 @bankid1_66,
	 @accountid1_67,
	 @accumfundaccount_68,
	 @loginid_69,
	 @systemlanguage_70)
select max(id) from [HrmSearchMould] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end
go

alter PROCEDURE [HrmSearchMould_Update]
	(@id_1 	[int],
	 @userid_2 	[int],
	 @resourceid_3 	[int],
	 @resourcename_4 	[varchar](60),
	 @jobtitle_5 	[int],
	 @activitydesc_6 	[varchar](200),
	 @jobgroup_7 	[int],
	 @jobactivity_8 	[int],
	 @costcenter_9 	[int],
	 @competency_10 	[int],
	 @resourcetype_11 	[char](1),
	 @status_12 	[char](1),
	 @subcompany1_13 	[int],
	 @department_14 	[int],
	 @location_15 	[int],
	 @manager_16 	[int],
	 @assistant_17 	[int],
	 @roles_18 	[int],
	 @seclevel_19 	[tinyint],
	 @joblevel_20 	[tinyint],
	 @workroom_21 	[varchar](60),
	 @telephone_22 	[varchar](60),
	 @startdate_23 	[char](10),
	 @enddate_24 	[char](10),
	 @contractdate_25 	[char](10),
	 @birthday_26 	[char](10),
	 @sex_27 	[char](1),
	 @seclevelTo_28 	[tinyint],
	 @joblevelTo_29 	[tinyint],
	 @startdateTo_30 	[char](10),
	 @enddateTo_31 	[char](10),
	 @contractdateTo_32 	[char](10),
	 @birthdayTo_33 	[char](10),
	 @age_34 	[int],
	 @ageTo_35 	[int],
	 @resourceidfrom_36 	[int],
	 @resourceidto_37 	[int],
	 @workcode_38 	[varchar](60),
	 @jobcall_39 	[int],
	 @mobile_40 	[varchar](60),
	 @mobilecall_41 	[varchar](60),
	 @fax_42 	[varchar](60),
	 @email_43 	[varchar](60),
	 @folk_44 	[varchar](30),
	 @nativeplace_45 	[varchar](100),
	 @regresidentplace_46 	[varchar](60),
	 @maritalstatus_47 	[char](1),
	 @certificatenum_48 	[varchar](60),
	 @tempresidentnumber_49 	[varchar](60),
	 @residentplace_50 	[varchar](60),
	 @homeaddress_51 	[varchar](100),
	 @healthinfo_52 	[char](1),
	 @heightfrom_53 	[int],
	 @heightto_54 	[int],
	 @weightfrom_55 	[int],
	 @weightto_56 	[int],
	 @educationlevel_57 	[char](1),
	 @degree_58 	[varchar](30),
	 @usekind_59 	[int],
	 @policy_60 	[varchar](30),
	 @bememberdatefrom_61 	[char](10),
	 @bememberdateto_62 	[char](10),
	 @bepartydatefrom_63 	[char](10),
	 @bepartydateto_64 	[char](10),
	 @islabouunion_65 	[char](1),
	 @bankid1_66 	[int],
	 @accountid1_67 	[varchar](100),
	 @accumfundaccount_68 	[varchar](30),
	 @loginid_69 	[varchar](60),
	 @systemlanguage_70 	[int],
	 @flag int output, @msg varchar(60) output)

AS UPDATE [HrmSearchMould] 

SET      [userid]	 = @userid_2,
	 [resourceid]	 = @resourceid_3,
	 [resourcename]	 = @resourcename_4,
	 [jobtitle]	 = @jobtitle_5,
	 [activitydesc]	 = @activitydesc_6,
	 [jobgroup]	 = @jobgroup_7,
	 [jobactivity]	 = @jobactivity_8,
	 [costcenter]	 = @costcenter_9,
	 [competency]	 = @competency_10,
	 [resourcetype]	 = @resourcetype_11,
	 [status]	 = @status_12,
	 [subcompany1]	 = @subcompany1_13,
	 [department]	 = @department_14,
	 [location]	 = @location_15,
	 [manager]	 = @manager_16,
	 [assistant]	 = @assistant_17,
	 [roles]	 = @roles_18,
	 [seclevel]	 = @seclevel_19,
	 [joblevel]	 = @joblevel_20,
	 [workroom]	 = @workroom_21,
	 [telephone]	 = @telephone_22,
	 [startdate]	 = @startdate_23,
	 [enddate]	 = @enddate_24,
	 [contractdate]	 = @contractdate_25,
	 [birthday]	 = @birthday_26,
	 [sex]	 = @sex_27,
	 [seclevelTo]	 = @seclevelTo_28,
	 [joblevelTo]	 = @joblevelTo_29,
	 [startdateTo]	 = @startdateTo_30,
	 [enddateTo]	 = @enddateTo_31,
	 [contractdateTo]	 = @contractdateTo_32,
	 [birthdayTo]	 = @birthdayTo_33,
	 [age]	 = @age_34,
	 [ageTo]	 = @ageTo_35,
	 [resourceidfrom]	 = @resourceidfrom_36,
	 [resourceidto]	 = @resourceidto_37,
	 [workcode]	 = @workcode_38,
	 [jobcall]	 = @jobcall_39,
	 [mobile]	 = @mobile_40,
	 [mobilecall]	 = @mobilecall_41,
	 [fax]	 = @fax_42,
	 [email]	 = @email_43,
	 [folk]	 = @folk_44,
	 [nativeplace]	 = @nativeplace_45,
	 [regresidentplace]	 = @regresidentplace_46,
	 [maritalstatus]	 = @maritalstatus_47,
	 [certificatenum]	 = @certificatenum_48,
	 [tempresidentnumber]	 = @tempresidentnumber_49,
	 [residentplace]	 = @residentplace_50,
	 [homeaddress]	 = @homeaddress_51,
	 [healthinfo]	 = @healthinfo_52,
	 [heightfrom]	 = @heightfrom_53,
	 [heightto]	 = @heightto_54,
	 [weightfrom]	 = @weightfrom_55,
	 [weightto]	 = @weightto_56,
	 [educationlevel]	 = @educationlevel_57,
	 [degree]	 = @degree_58,
	 [usekind]	 = @usekind_59,
	 [policy]	 = @policy_60,
	 [bememberdatefrom]	 = @bememberdatefrom_61,
	 [bememberdateto]	 = @bememberdateto_62,
	 [bepartydatefrom]	 = @bepartydatefrom_63,
	 [bepartydateto]	 = @bepartydateto_64,
	 [islabouunion]	 = @islabouunion_65,
	 [bankid1]	 = @bankid1_66,
	 [accountid1]	 = @accountid1_67,
	 [accumfundaccount]	 = @accumfundaccount_68,
	 [loginid]	 = @loginid_69,
	 [systemlanguage]	 = @systemlanguage_70 

WHERE 
	( [id]	 = @id_1)
if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end
go

 alter PROCEDURE HrmSubCompany_Delete 
 (@id_1 	[int], 
  @flag     integer output, @msg   varchar(80) output)  
  AS  DECLARE @recordercount integer Select @recordercount = count(id) from HrmDepartment 
  where subcompanyid1 =convert(int, @id_1) if @recordercount = 0 
  begin DELETE [HrmSubCompany]  WHERE ( [id]	 = @id_1) end else begin select '20' end  if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' return end else begin set @flag=0 set @msg='	更新储存过程成功' return end 
GO


create procedure HrmResource_DepUpdate
(@id_1 int,
 @departmentid_2 int,
 @joblevel_3 int,
 @flag int output,@msg varchar(60) output)
as update HrmResource set
  departmentid = @departmentid_2,
  joblevel = @joblevel_3
where
  id = @id_1
go


insert into CptCapitalModifyField (field,name) values ('50','帐内或帐外')
GO


ALTER  PROCEDURE CptCapital_Update 
	(@id_1 	int,
	 @name_3 	varchar(60),
	 @barcode_4 	varchar(30),
	 @startdate		char(10),
	 @enddate		char(10),
	 @seclevel_7 	tinyint,
	 @resourceid	int,
	 @sptcount 	char(1),
	 @currencyid_11 	int,
	 @capitalcost_12 	decimal(18,3),
	 @startprice_13 	decimal(18,3),
	@depreendprice decimal(18,3),
	@capitalspec		varchar(60),			
	@capitallevel		varchar(30),			
	@manufacturer		varchar(100),
	@manudate		char(10),			
	 @capitaltypeid_14 	int,
	 @capitalgroupid_15 	int,
	 @unitid_16 	int,
	 @replacecapitalid_18 	int,
	 @version_19 	varchar(60),
	 @location      varchar(100),
	 @remark_21 	text,
	 @capitalimageid_22 	int,
	 @depremethod1_23 	int,
	 @depremethod2_24 	int,
	 @deprestartdate	char(10),
	 @depreenddate		char(10),
	 @customerid_27 	int,
	 @attribute_28 	tinyint,
	 @datefield1_31 	char(10),
	 @datefield2_32 	char(10),
	 @datefield3_33 	char(10),
	 @datefield4_34 	char(10),
	 @datefield5_35 	char(10),
	 @numberfield1_36 	float,
	 @numberfield2_37 	float,
	 @numberfield3_38 	float,
	 @numberfield4_39 	float,
	 @numberfield5_40 	float,
	 @textfield1_41 	varchar(100),
	 @textfield2_42 	varchar(100),
	 @textfield3_43 	varchar(100),
	 @textfield4_44 	varchar(100),
	 @textfield5_45 	varchar(100),
	 @tinyintfield1_46 	char(1),
	 @tinyintfield2_47 	char(1),
	 @tinyintfield3_48 	char(1),
	 @tinyintfield4_49 	char(1),
	 @tinyintfield5_50 	char(1),
	 @lastmoderid_51 	int,
	 @lastmoddate_52 	char(10),
	 @lastmodtime_53 	char(8),
	 @relatewfid		int,
	 @alertnum          decimal(18,3),
	 @fnamark			varchar(60),
	 @isinner			char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
/*更新资产组中的资产卡片数量信息*/
declare @tempgroupid int
select @tempgroupid=capitalgroupid from CptCapital where id=@id_1
if @tempgroupid<>@capitalgroupid_15
begin
	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=@tempgroupid
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=@capitalgroupid_15
end
UPDATE CptCapital 
SET  	 name	 = @name_3,
	 barcode	 = @barcode_4,
	 startdate = @startdate,
	 enddate	 = @enddate,	
	 seclevel	 = @seclevel_7,
	 resourceid = @resourceid,
	 sptcount	= @sptcount,	
	 currencyid	 = @currencyid_11,
	 capitalcost	 = @capitalcost_12,
	 startprice	 = @startprice_13,
	 depreendprice	= @depreendprice,
	 capitalspec	= @capitalspec,
	 capitallevel	= @capitallevel,
	 manufacturer	= @manufacturer,
	 manudate      = @manudate,
	 capitaltypeid	 = @capitaltypeid_14,
	 capitalgroupid	 = @capitalgroupid_15,
	 unitid	 = @unitid_16,
	 replacecapitalid	 = @replacecapitalid_18,
	 version	 = @version_19,
	 location	  = @location,
	 remark	 = @remark_21,
	 capitalimageid	 = @capitalimageid_22,
	 depremethod1	 = @depremethod1_23,
	 depremethod2	 = @depremethod2_24,
	 deprestartdate= @deprestartdate,
	 depreenddate  = @depreenddate,
	 customerid	 = @customerid_27,
	 attribute	 = @attribute_28,
	 datefield1	 = @datefield1_31,
	 datefield2	 = @datefield2_32,
	 datefield3	 = @datefield3_33,
	 datefield4	 = @datefield4_34,
	 datefield5	 = @datefield5_35,
	 numberfield1	 = @numberfield1_36,
	 numberfield2	 = @numberfield2_37,
	 numberfield3	 = @numberfield3_38,
	 numberfield4	 = @numberfield4_39,
	 numberfield5	 = @numberfield5_40,
	 textfield1	 = @textfield1_41,
	 textfield2	 = @textfield2_42,
	 textfield3	 = @textfield3_43,
	 textfield4	 = @textfield4_44,
	 textfield5	 = @textfield5_45,
	 tinyintfield1	 = @tinyintfield1_46,
	 tinyintfield2	 = @tinyintfield2_47,
	 tinyintfield3	 = @tinyintfield3_48,
	 tinyintfield4	 = @tinyintfield4_49,
	 tinyintfield5	 = @tinyintfield5_50,
	 lastmoderid	 = @lastmoderid_51,
	 lastmoddate	 = @lastmoddate_52,
	 lastmodtime	 = @lastmodtime_53,
	 relatewfid	= @relatewfid,
	 alertnum	 = @alertnum,
	 fnamark	= @fnamark,
	 isinner	= @isinner
	 
WHERE 
	( id	 = @id_1)

GO

/* 客户价值评估维护 */
insert into SystemRights(id,rightdesc,righttype) values(351,'客户价值评估维护','0')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(351,7,'客户价值评估维护','客户价值评估维护')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(351,8,'','')
GO

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2054,'客户价值项目添加','CRM_EvaluationAdd:Add',351)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2055,'客户价值项目编辑','CRM_EvaluationEdit:Edit',351)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2056,'客户价值项目删除','CRM_EvaluationDelete:Delete',351)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2057,'客户价值项目日志','CRM_Evaluation:Log',351)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (351,8,'1')
GO

insert into SystemRightToGroup (groupid,rightid) values (6,351)
GO
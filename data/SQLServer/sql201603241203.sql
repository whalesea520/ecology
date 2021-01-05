Alter PROCEDURE Share_forDoc
(
    @docid int ,
    @flag int output, 
    @msg varchar(4000) output 
)
AS 
declare @sharetype int
declare @newsharetype int
declare @sharecontent varchar(4000)

declare @sharelevel int
declare @foralluser int
declare @departmentid int
declare @subcompanyid int
declare @userid int
declare @ownerid int
declare @createrid int
declare @crmid int
declare @orgGroupId int
declare @temp_userid int
declare @srcfrom int
declare @opuser int
declare @temp_departmentid int 

declare @roleid int
declare @rolelevel int
declare @rolevalue int
declare @seclevel int

declare @seclevelmax int
declare @allmanagers int
declare @orgid int
declare @includesub int

declare @sharesource int
declare @isExistInner int
declare @isExistOuter int

declare @isSysadmin int
declare @hasmanager int
declare @downloadlevel int

declare @joblevel int
declare @jobdepartment int
declare @jobsubcompany int
declare @jobids int

BEGIN
    /*ѡɾ���������*/
    DELETE ShareinnerDoc  WHERE  sourceid=@docid
    DELETE ShareouterDoc  WHERE  sourceid=@docid
    

    /*�ٲ����������*/
    declare docid_cursor cursor for   
    select docid,sharetype,seclevel,seclevelmax,allmanagers,orgid,includesub,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel,joblevel,jobdepartment,jobsubcompany,jobids  
    from docshare where docid=@docid and docid>0

    open docid_cursor fetch next from docid_cursor into @docid,@sharetype,@seclevel,@seclevelmax,@allmanagers,@orgid,@includesub,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel,@joblevel,@jobdepartment,@jobsubcompany,@jobids

     while @@fetch_status=0 
      begin  
           set @isExistInner=0
           set @isExistOuter=0
           if @downloadlevel is null set @downloadlevel=0
	   if @allmanagers is null set @allmanagers=0
	   if @orgid  is null set @orgid =0
	   if @includesub  is null set @includesub =0
           /*�õ�ֵ*/         
            if @sharetype=1   /*������Դ*/ 
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=1
                    set @opuser=@userid

                    set @isExistInner=1
                end

	     else if @sharetype=10   /*�������޹ظ�λ*/ 
                begin
                    set @newsharetype=10
                    set @sharecontent=@jobids
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=10
                    set @opuser=@jobids

                    set @isExistInner=1
                end
	     else if @sharetype=11   /*��������ظ�λ*/ 
                begin
                    set @newsharetype=11
                    set @sharecontent=@jobids
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=11
                    set @opuser=@jobids

                    set @isExistInner=1
                end

            else if  @sharetype=2  /*�ֲ�*/            
                begin
                    if @includesub=1 begin
                    set @sharesource=2
                    end
                    set @newsharetype=2
                    set @sharecontent=@subcompanyid 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=2
                    set @opuser=@subcompanyid
                    set @isExistInner=1
                end  

            else if  @sharetype=3  /*����*/
                begin
                    if @includesub=1 begin
                    set @sharesource=2
                    end
                    set @newsharetype=3
                    set @sharecontent=@departmentid 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=3
                    set @opuser=@departmentid

                    set @isExistInner=1
                end  
           else if  @sharetype=6  /*Ⱥ��*/
                begin
                    set @newsharetype=6
                    set @sharecontent=@orgGroupId
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=6
                    set @opuser=@orgGroupId

                    set @isExistInner=1
                end 
           else if  @sharetype=5  /*������*/
                begin
                    set @newsharetype=5
                    set @sharecontent=1 
                    set @seclevel=@seclevel
                    set @seclevelmax=@seclevelmax
                    set @srcfrom=5
                    set @opuser=0

                    set @isExistInner=1
                end 
           else if  @sharetype=80  /*�����˱���*/
                begin
                    set @newsharetype=1
                    set @sharecontent=@userid 
                    set @seclevel=0
                    set @seclevelmax=255
                    set @srcfrom=80
                    set @opuser=@userid                    
                    set @isExistInner=1
                    
                    /*����ĵ��Ĵ����ߺ��ĵ����������������ͬһ�˵Ļ������ǵ�Ȩ�޽�����һ��*/
				    select @ownerid=ownerid, @createrid=doccreaterid  from docdetail where id=@docid    
				    if (@ownerid!=@createrid) begin
                         insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         values(@docid,1,@ownerid,0,255,@sharelevel,86,0,0,@downloadlevel)  
                    end                    
                end 
          else if  @sharetype=81  /*������ֱ���ϼ�*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid
	          select  @hasmanager=count(*)  from hrmresource a,hrmresource b     where a.id=b.managerid and b.id= @userid
                if @orgid =0
                begin
                  if (@isSysadmin!=1 and @hasmanager=1 and @allmanagers=0)    
                  begin                
	                  set @newsharetype=1
	                  /*���ϼ�*/
	                  SELECT  @sharecontent=managerid FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end

		   if (@isSysadmin!=1 and @hasmanager=1 and @allmanagers=1)    
                  begin                
	                  set @newsharetype=1
	                  /*���ϼ�*/
	                  SELECT  @sharecontent=managerstr FROM HrmResource where id=@userid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid	         
			 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         select @docid,1,Data,0,255,@sharelevel,81,@opuser,Data,@downloadlevel from SplitStr(@sharecontent,',') where Data>0
	                 set @isExistInner=0
                   end

		 end
		else if  @orgid <0
                  begin
                  if (@isSysadmin!=1  and @allmanagers=0)    
                  begin                
	                  set @newsharetype=1
	                  /*���ϼ���ά��֯�е�*/
	                  SELECT  @sharecontent=managerid FROM HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid
	                  insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel)
			  values(@docid,1,@sharecontent,0,255,@sharelevel,81,@opuser,@sharecontent,@downloadlevel)
	                  set @isExistInner=0
                   end

		   if (@isSysadmin!=1  and @allmanagers=1)    
                  begin                
	                  set @newsharetype=1
	                  /*���ϼ�*/
	                  SELECT  @sharecontent=managerstr FROM HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=0
	                  set @seclevelmax=255
	                  set @srcfrom=81
	                  set @opuser=@userid	         
			 insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
                         select @docid,1,Data,0,255,@sharelevel,81,@opuser,Data,@downloadlevel from SplitStr(@sharecontent,',') where Data>0
	                 set @isExistInner=0
                   end

		 end
                 


		  
            end 
         else if  @sharetype=84  /*ͬ�ֲ�*/
              begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid   
		 if @orgid =0
		  begin
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                  /*��ֲ�*/                  
	                  SELECT  @temp_departmentid=departmentid  FROM HrmResource where id=@userid
	                  select @sharecontent=subcompanyid1   from  HrmDepartment where id=@temp_departmentid
	
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
		 end
		 else if @orgid <0 
		 begin
                  if (@isSysadmin!=1)   
                  begin 
	                  set @newsharetype=2
	                  /*��ֲ�*/                  
	               
	                  select @sharecontent=subcompanyid   from  HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=84
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                   end
		 end


              end 
         else if  @sharetype=85  /*ͬ����*/
              begin
	       if @orgid =0
		 begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)    
                  begin 
	                  set @newsharetype=3
	                  /*����*/
	                  SELECT @sharecontent=departmentid  FROM HrmResource where id=@userid
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
                end
		else if @orgid <0
		 begin
                  select @isSysadmin=count(*) from hrmresourcemanager where id=@userid  
                  if (@isSysadmin!=1)    
                  begin 
	                  set @newsharetype=3
	                  /*����*/
	                  SELECT @sharecontent=departmentid  FROM  HrmResourceVirtual where resourceid=@userid and virtualtype=@orgid
	                  set @seclevel=@seclevel
	                  set @seclevelmax=@seclevelmax
	                  set @srcfrom=85
	                  set @opuser=@userid
	
	                  set @isExistInner=1
                  end
                end

              end 

       else if  @sharetype=-81  /*�ͻ��ľ���*/
          begin
              set @newsharetype=1             
              select @sharecontent=manager from CRM_CustomerInfo where id=@userid /*��ͻ��ľ���*/
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=-81
              set @opuser=@userid

              set @isExistInner=1
          end 
       else if  @sharetype=9  /*�ͻ�*/
          begin
              set @newsharetype=9             
              select @sharecontent=@crmid
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=9
              set @opuser=@crmid

              set @isExistOuter=1
          end 

         else if  @sharetype=-80  /*�ͻ�����*/
          begin
              set @newsharetype=9             
              select @sharecontent=@userid
              set @seclevel=0
               set @seclevelmax=255
              set @srcfrom=-80
              set @opuser=@userid

              set @isExistOuter=1
          end 
          else if  @sharetype<0 /*�ͻ�����*/
          begin
              set @newsharetype=10             
              select @sharecontent=STR(@sharetype*-1)
              set @srcfrom=10
              set @opuser=@sharetype

              set @isExistOuter=1
          end 
          else if  @sharetype=4  /*��ɫ ��ɫ���͵Ĵ����Ƚ�����*/
                begin  
                    set @newsharetype=4    
                    set @srcfrom=4
                    set @opuser=@roleid

                     if @docid is null set @docid=0
                     if @newsharetype is null set @newsharetype=0
                     if @sharecontent is null set @sharecontent=0
                     if @seclevel is null set @seclevel=0
                      if @seclevelmax is null set @seclevel=255
                     if @sharelevel is null set @sharelevel=0
                     if @srcfrom is null set @srcfrom=0
                     if @opuser is null set @opuser=0
                     if @sharesource is null set @sharesource=0


                    IF @rolelevel=0 /*������ �ܲ�,�ֲ�,�����ܿ�*/
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(0,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else  IF @rolelevel=1 /*���ֲ� �ܲ�,�ֲ��ܿ�*/                        
                    BEGIN
                     set @sharecontent=CAST(STR(@roleid,9)+STR(1,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                     set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                     insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    else IF @rolelevel=2 /*���ܲ� �ܲ��ܿ�*/
                    BEGIN
                      set @sharecontent=CAST(STR(@roleid,9)+STR(2,1) AS INT) 
                      insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel )     
                    END
                    set @isExistInner=0  /*����Ҫ���������������*/
                end   
         IF  @isExistInner=1
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
               if @seclevelmax is null set @seclevelmax=255
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*��������*/                         
             insert into ShareinnerDoc  (sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel,joblevel,jobdepartment,jobsubcompany ) values       
             (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel,@joblevel,@jobdepartment,@jobsubcompany )             
         END             

         IF  @isExistOuter=1 
         BEGIN
             if @docid is null set @docid=0
             if @newsharetype is null set @newsharetype=0
             if @sharecontent is null set @sharecontent=0
             if @seclevel is null set @seclevel=0
             if @seclevelmax is null set @seclevelmax=255
             if @sharelevel is null set @sharelevel=0
             if @srcfrom is null set @srcfrom=0
             if @opuser is null set @opuser=0
             if @sharesource is null set @sharesource=0

             /*��������*/
             insert into ShareouterDoc(sourceid,type,content,seclevel,seclevelmax,sharelevel,srcfrom,opuser,sharesource,downloadlevel,joblevel,jobdepartment,jobsubcompany) values        
             (@docid,@newsharetype,@sharecontent,@seclevel,@seclevelmax,@sharelevel,@srcfrom,@opuser,@sharesource,@downloadlevel,@joblevel,@jobdepartment,@jobsubcompany )
         END          

        /*������һѭ��*/    
        fetch next from docid_cursor into  @docid,@sharetype,@seclevel,@seclevelmax,@allmanagers,@orgid,@includesub,@userid,@subcompanyid,@departmentid,@foralluser,@sharelevel,@roleid,@rolelevel,@crmid,@orgGroupId,@sharesource,@downloadlevel,@joblevel,@jobdepartment,@jobsubcompany,@jobids
      end 
    close docid_cursor deallocate docid_cursor	
END
GO
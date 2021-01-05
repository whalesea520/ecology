
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rslayout" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="SpopForHomepage" class="weaver.splitepage.operate.SpopForHomepage" scope="page"/>
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<%
	String subid = Util.null2String(request.getParameter("subCompanyId"));
	String method=Util.null2String(request.getParameter("method"));
	String opt=Util.null2String(request.getParameter("opt"));
	String hpid = Util.null2String(request.getParameter("hpid"));
	//int rdiInfoAppointId = Util.getIntValue(request.getParameter("rdiInfoAppoint"),-1);
	

	int subCompanyId = Util.getIntValue(subid);

	/*
	 权限判断
	*/
  		
   boolean canEdit=false;
   boolean isDetachable=hpu.isDetachable(request);
   int operatelevel=0;
   ArrayList shareList = hpu.getShareMaintListByUser(user.getUID()+"");
   String areaResult=Util.null2String(request.getParameter("areaResult"));
   ArrayList resultList=Util.TokenizerString(areaResult,"||");
   if(isDetachable){
	   operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
       if(subCompanyId==-1) operatelevel=2;
   }else{
		if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
   }  
   
   if(operatelevel==0&&("save".equals(method)||"synihp".equals(method)||"savebase".equals(method))){
	   
	   if(shareList.indexOf(request.getParameter("hpid"))!=-1){
			 operatelevel=2;
	   }else{
		   int size = resultList.size(); 
		   for (int i=0;i<resultList.size();i++){
	           String result=(String)resultList.get(i);
	           String[] paras = Util.TokenizerString2(result,"_");
	           //if(shareList.indexOf(paras[0])==-1){
	        	//   resultList.remove(i);
	        	   //i--;
	          // }
	       }
		   if(resultList.size()==size){
			   operatelevel=2;
		   }
	   }
   }
   canEdit=false;
   if(operatelevel==2) canEdit=true;

   boolean canPopEdit=false;
   boolean canPopDel=false;
   boolean canPopSetting=false;
   //System.out.println(canEdit);
   
    String[] isUses =request.getParameterValues("chkUse");
    String[] isLockeds =request.getParameterValues("chkLocked");
    
    int userid = user.getUID();
    String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
    String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
    
    int creatorid=hpu.getHpUserId(hpid,""+subCompanyId,user);
    
    //System.out.println("hpid="+hpid+";subCompanyId="+subCompanyId+";userid="+user.getUID());
    
    int creatortype=hpu.getHpUserType(hpid,""+subCompanyId,user);
    

   if(canEdit){
	    String infoid = Util.null2String(request.getParameter("hpid"));
	    String tempsubid = subCompanyId==0?pc.getSubcompanyid(infoid):""+subCompanyId;
		ArrayList popeList=SpopForHomepage.getModiDefaultPope("".equals(infoid)?"0":infoid,""+user.getUID(),""+tempsubid);
		canPopEdit=true;
		canPopDel="true".equals((String)popeList.get(1))?true:false;
		canPopSetting=true;
   } else {

        if("synihpnormal".equals(method)){
            String strDel1="delete hpElementSettingDetail where hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype+"";
            String strDel2="delete hpLayout where  hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype+"";
       
            rs.executeSql(strDel1);
            rs.executeSql(strDel2);
   
            rs.executeSql("delete hpFieldLength where eid in (select id from  hpElement where hpid="+hpid+")  and  userid="+creatorid+" and usertype="+creatortype+"");
            
        }else{
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
        }
   }

    if("save".equals(method)){
        for (int i=0;i<resultList.size();i++){
            String result=(String)resultList.get(i);
            String[] paras = Util.TokenizerString2(result,"_");
            String sql="update hpinfo set isuse='"+paras[1]+"',islocked='"+paras[2]+"',hplastdate='"+date+"',hplasttime='"+time+"' where id="+paras[0];
            rs.executeSql(sql);
            log.setItem("PortalPage");
        	log.setType("update");
        	log.setSql(sql);
        	log.setDesc("修改门户页面信息");
        	log.setUserid(user.getUID()+"");
        	log.setIp(request.getRemoteAddr());
        	log.setOpdate(TimeUtil.getCurrentDateString());
        	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
        	log.savePortalOperationLog();
        }
        pc.reloadHpCache();

	    response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+subCompanyId);
	} else if("ref".equals(method)){//新建首页

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

		String srchpid = Util.null2String(request.getParameter("srchpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String isuse = Util.null2String(request.getParameter("isuse"));
		String islocked = Util.null2String(request.getParameter("islocked"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String menuStyleid =Util.null2String(request.getParameter("seleMenuStyleid"));
		String bgcolor  = Util.null2String(request.getParameter("bgcolor"));
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		//考虑分权管理员新建的情况
		if("0".equals(hpid) && HrmUserVarify.checkUserRight("homepage:Maint", user)){
			creatorid=subCompanyId;
			creatortype=3;
		}
        //int creatorid=subCompanyId;
        //int creatortype=3;
        isuse = "".equals(isuse)?"0":isuse;
		islocked = "".equals(islocked)?"0":islocked;
		
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,hpcreatorid,menuStyleid,bgcolor,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+","+subCompanyId+",'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+","+userid+",'"+menuStyleid+"','"+bgcolor+"','"+isRedirectUrl+"','"+redirectUrl+"')");
        log.setItem("PortalPage");
    	log.setType("insert");
    	log.setSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,hpcreatorid,menuStyleid,bgcolor,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+","+subCompanyId+",'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+","+userid+",'"+menuStyleid+"','"+bgcolor+"','"+isRedirectUrl+"','"+redirectUrl+"')");
    	log.setDesc("新建门户页面");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
		int maxHpid=hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
        log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
    	log.setDesc("修改门户页面信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
     
        if(pc.isHaveThisHp(""+maxHpid))  
			pc.updateHpCache(""+maxHpid);
        else 
        	pc.addHpCache(""+maxHpid);

		//插入布局信息
		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");

		//先改值
		for(int i=0;i<pageFlagList.size();i++)
		{
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=Util.null2String(request.getParameter("txtArea_"+pageFlag));

			String strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+maxHpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+creatorid+","+creatortype+")";
			//System.out.println("=========="+strSql);
			rslayout.executeSql(strSql);
	        log.setItem("PortalPage");
	    	log.setType("insert");
	    	log.setSql(strSql);
	    	log.setDesc("插入布局信息");
	    	log.setUserid(user.getUID()+"");
	    	log.setIp(request.getRemoteAddr());
	    	log.setOpdate(TimeUtil.getCurrentDateString());
	    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	    	log.savePortalOperationLog();
		}
		//String strSql="insert into hplayout (hpid,layoutbaseid,areaflag,areasize,userid,usertype) " +
        //        "select  "+maxHpid+",layoutbaseid,areaflag,areasize,"+creatorid+"," +
        //        ""+creatortype+" from hplayout where hpid="+srchpid+" " +
        //        "and userid="+srchpCreatorId+" and usertype="+srchpCreatorType;

		//System.out.println(strSql);

        //rs.executeSql(strSql);

        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,sharelevel,seclevelmax) values ("+maxHpid+",6,"+subCompanyId+",0,0,100)";
		rs.executeSql(strShareSql);
        log.setItem("PortalPage");
    	log.setType("insert");
    	log.setSql(strShareSql);
    	log.setDesc("插入共享信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();

		//out.println(maxHpid);
        //response.sendRedirect("HomepageConfig.jsp?hpid="+maxHpid);
		response.sendRedirect("/homepage/maint/HomepagePageEdit.jsp?method=savebase&hpid="+maxHpid+"&subCompanyId="+subCompanyId);


	}
	else if ("saveNew".equals(method))
	{
		String srchpid = Util.null2String(request.getParameter("srchpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String isuse = Util.null2String(request.getParameter("isuse"));
		String islocked = Util.null2String(request.getParameter("islocked"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));	
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String menuStyleid =Util.null2String(request.getParameter("seleMenuStyleid"));
		String bgcolor  = Util.null2String(request.getParameter("bgcolor"));
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		//需要复制的门户模板
		String copyhpid = Util.null2String(request.getParameter("hpid"));
		
        //int creatorid=subCompanyId;
        //int creatortype=3;
        isuse = "".equals(isuse)?"0":isuse;
		islocked = "".equals(islocked)?"0":islocked;
		//前端 disabled ，不能往后台传值
		String layoutid = "";//Util.null2String(request.getParameter("seleLayoutid"));
		String Subcompanyid="";
		rs.execute("select Subcompanyid,layoutid from hpinfo where id="+copyhpid);
		if(rs.next()){
			layoutid = rs.getString("layoutid");
			Subcompanyid = rs.getString("Subcompanyid");
		}
		
	
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,hpcreatorid,menuStyleid,bgcolor,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+","+subCompanyId+",'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+","+userid+",'"+menuStyleid+"','"+bgcolor+"','"+isRedirectUrl+"','"+redirectUrl+"')");
		int maxHpid=hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
        
		//hpec.reloadHpElementCache();
		
        if(pc.isHaveThisHp(""+maxHpid))  
			pc.updateHpCache(""+maxHpid);
        else 
        	pc.addHpCache(""+maxHpid);

		
        String copyusertype="3";
        if(Subcompanyid.equals("-1")){
        	//登录前页面 usertype=0
        	copyusertype="0";
        }
        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,seclevelmax,sharelevel,includeSub) values ("+maxHpid+",6,"+subCompanyId+",0,100,1,1)";
		rs.executeSql(strShareSql);
		
		//以下加载页面元素样式
    	String areaelements="";
    	rs.execute("select areaelements from hplayout where hpid="+copyhpid+" and usertype="+copyusertype);
    	while(rs.next()){
    		areaelements+=rs.getString("areaelements");
    	}
    	if(!areaelements.equals("")){
    		areaelements = areaelements.substring(0,areaelements.length()-1);
    	}
    	
    /*复制 copyhpid 的 元素信息*/	    	
		// 1、 查询出 copyhpid 所有的元素信息
		//System.out.println("select * from hpelement where hpid="+copyhpid+" and id in ("+areaelements+")");
        rs.execute("select * from hpelement where hpid="+copyhpid+" and id in ("+areaelements+")");
        //存储 copyhpid hpelement id 对应的 新 元素id
        Map<String,String> hpelementids = new HashMap<String,String>();
        Map<String,String> hpelementidsno = new HashMap<String,String>();
        String hpelementidstr = "";
        String sql = "";
        String newhpelementid = "";
        while(rs.next()){
        	sql = "insert into hpElement(title,logo,islocked,strsqlwhere,ebaseid,isSysElement,hpid,isFixationRowHeight,background,styleid,marginTop,shareuser,scrolltype,isRemind,fromModule,isuse,newstemplate,marginleft,marginright,marginbottom,height)"+
        	" values('"+rs.getString("title")+"','"+rs.getString("logo")+"','"+rs.getString("islocked")+"','"+rs.getString("strsqlwhere")+"','"+rs.getString("ebaseid")+"','"+rs.getString("isSysElement")+"',"+maxHpid+",'"+rs.getString("isFixationRowHeight")+"','"+rs.getString("background")+"','"+styleid+"',"+rs.getString("marginTop")+",'"+rs.getString("shareuser")+"','"+rs.getString("scrolltype")+"','"+rs.getString("isRemind")+"','"+rs.getString("fromModule")+"','"+rs.getString("isuse")+ "','"+rs.getString("newstemplate")+"','"+rs.getString("marginleft")+"','"+rs.getString("marginright")+"','"+rs.getString("marginbottom")+"','"+rs.getString("height")+"')";
        	//插入操作
        	rslayout.execute(sql);
        	//获取刚插入的id
        	rslayout.executeSql("select max(id) from hpElement");
        	if(rslayout.next()){
        		newhpelementid= rslayout.getString(1);
        	}
        	//存储 映射 关系
        	hpelementids.put(rs.getString("id"),newhpelementid);
        	hpelementidsno.put(newhpelementid, rs.getString("id"));
        	hpelementidstr += rs.getString("id")+",";
        	
        	//更新元素缓存
        	hpec.addHpElementCache(""+newhpelementid);
        }
        //后补 -1
        hpelementidstr += -1;
        
        //System.out.println(hpelementids.toString());
        
   /*复制 copyhpid 的布局信息*/	    	
		// 1、 查询出 copyhpid 所有的布局信息
        rs.execute("select * from hplayout where usertype="+copyusertype+" and  hpid="+copyhpid);
        while(rs.next()){
        	sql = "insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype)" +
        	" values("+maxHpid+",'"+rs.getString("layoutbaseid")+"','"+rs.getString("areaflag")+"','"+rs.getString("areasize")+"','"+getNewHpLayoutAreaElements(hpelementids, rs.getString("areaElements"))+"',"+creatorid+","+creatortype+")";
        	//插入操作
        	rslayout.execute(sql);
        }
        
   /*复制 copyhpid 的hpElementImg信息*/	    	
		// 1、 查询出 copyhpid 所有的hpElementImg信息
        rs.execute("select * from hpElementImg where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpElementImg(imagefileid,eid,filerealpath,miniimgpath,iszip,imgsize)" +
        	" values("+rs.getString("imagefileid")+","+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("filerealpath")+"','"+rs.getString("miniimgpath")+"','"+rs.getString("iszip")+"','"+rs.getString("imgsize")+"')";
        	//插入操作
        	rslayout.execute(sql);
        }
        
        
    /*复制 copyhpid 的 hpElementSetting 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpElementSetting 信息
		
        rs.execute("select * from hpElementSetting where eid in("+hpelementidstr+")");
        //hpElementSetting 表中 id 可以重复
        int hpElementMaxid = getTableMaxid(rs1,"hpElementSetting","id")+1;
        while(rs.next()){
        	sql = "insert into hpElementSetting(id,eid,name,value)" +
        	" values("+hpElementMaxid+","+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("name")+"','"+rs.getString("value")+"')";
        	//插入操作
        	rslayout.execute(sql);
        	hpElementMaxid ++;
        }
        
   /*复制 copyhpid 的 hpElementSettingDetail 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpElementSettingDetail 信息
        rs.execute("select * from hpElementSettingDetail where eid in("+hpelementidstr+") and  usertype = 3 ");
        while(rs.next()){
        	sql = "insert into hpElementSettingDetail(userid,usertype,eid,perpage,linkmode,showfield,sharelevel,hpid,currentTab,isremind)" +
        	" values("+creatorid+","+creatortype+","+hpelementids.get(rs.getString("eid"))+","+rs.getString("perpage")+","+rs.getString("linkmode")+",'"+rs.getString("showfield")+"','"+rs.getString("sharelevel")+"',"+maxHpid+",'"+rs.getString("currentTab")+"','"+rs.getString("isremind")+"')";
        	//插入操作
        	rslayout.execute(sql);
        }    
        
        
   /*复制 copyhpid 的 hpNewsTabInfo 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpNewsTabInfo 信息
        rs.execute("select * from hpNewsTabInfo where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpNewsTabInfo(eid,tabid,tabTitle,sqlWhere)" +
        	" values("+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("tabid")+"','"+rs.getString("tabTitle")+"','"+rs.getString("sqlWhere")+"')";
        	//插入操作
        	rslayout.execute(sql);
        }   
        
  /*复制 copyhpid 的 hpOutDataSettingAddr 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpOutDataSettingAddr 信息
        rs.execute("select * from hpOutDataSettingAddr where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpOutDataSettingAddr(eid,tabid,sourceid,address,pos)" +
        	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+","+rs.getString("sourceid")+",'"+rs.getString("address")+"',"+rs.getString("pos")+")";
        	//插入操作
        	rslayout.execute(sql);
        } 
        
   /*复制 copyhpid 的 hpOutDataSettingDef 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpOutDataSettingDef 信息
        rs.execute("select * from hpOutDataSettingDef where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpOutDataSettingDef(eid,tabid,pattern,source,area,dataKey)" +
        	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+",'"+rs.getString("pattern")+"','"+rs.getString("source")+"','"+rs.getString("area")+"','"+rs.getString("dataKey")+"')";
        	//插入操作
        	rslayout.execute(sql);
        } 
        
        
    /*复制 copyhpid 的 hpOutDataSettingField 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpOutDataSettingField 信息
        rs.execute("select * from hpOutDataSettingField where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpOutDataSettingField(eid,tabid,showfield,showfieldname,isshowname,transql,mainid)" +
        	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+",'"+rs.getString("showfield")+"','"+rs.getString("showfieldname")+"','"+rs.getString("isshowname")+"','"+rs.getString("transql")+"',"+rs.getString("mainid")+")";
        	//插入操作
        	rslayout.execute(sql);
        } 
        
        
        
	/*复制 copyhpid 的 hpOutDataTabSetting 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpOutDataTabSetting 信息
       rs.execute("select * from hpOutDataTabSetting where eid in("+hpelementidstr+")");
       while(rs.next()){
       	sql = "insert into hpOutDataTabSetting(eid,tabid,title,type)" +
       	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+",'"+rs.getString("title")+"','"+rs.getString("type")+"')";
       	//插入操作
       	rslayout.execute(sql);
       } 
       
       
   /*复制 copyhpid 的 hpcurrenttab 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpcurrenttab 信息
       rs.execute("select * from hpcurrenttab where eid in("+hpelementidstr+")");
       while(rs.next()){
       	sql = "insert into hpcurrenttab(userid,usertype,eid,currenttab)" +
       	" values("+creatorid+","+creatortype+","+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("currenttab")+"')";
       	//插入操作
       	rslayout.execute(sql);
       }    
       
       
    /*复制 copyhpid 的 hpcurrentuse 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpcurrentuse 信息
      rs.execute("select * from hpcurrentuse where hpid ="+copyhpid);
      while(rs.next()){
      	sql = "insert into hpcurrentuse(userid,usertype,hpid)" +
      	" values("+creatorid+","+creatortype+","+maxHpid+")";
      	//插入操作
      	rslayout.execute(sql);
      }    
      
      
   /*复制 copyhpid 的 hpsetting_wfcenter 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpsetting_wfcenter 信息
      rs.execute("select * from hpsetting_wfcenter where eid in("+hpelementidstr+")");
      while(rs.next()){
      	sql = "insert into hpsetting_wfcenter(eid,tabid,viewType,typeids,flowids,nodeids,isExclude,tabTitle,showCopy,completeflag)" +
      	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+","+rs.getString("viewType")+",'"+rs.getString("typeids")+"','"+rs.getString("flowids")+"','"+rs.getString("nodeids")+"','"+rs.getString("isExclude")+"','"+rs.getString("tabTitle")+"','"+rs.getString("showCopy")+"',"+rs.getString("completeflag")+")";
      	//插入操作
      	rslayout.execute(sql);
      }    

        /*复制 copyhpid 的 workflowcentersettingdetail 信息*/   
      // 1、 查询出 copyhpid 所有的 hpsetting_wfcenter 信息 
      rs.execute("select * from workflowcentersettingdetail where eid in("+hpelementidstr+")");
      while(rs.next()){
        sql = "insert into workflowcentersettingdetail (eid,tabid,type,content,srcfrom) values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("tabid")+",'"+rs.getString("type")+"','"+rs.getString("content")+"',"+rs.getString("srcfrom")+")";
        //插入操作
        rslayout.execute(sql);
      }           
      
      /*复制 copyhpid 的 picture 信息*/	    	
    		// 1、 查询出 copyhpid 所有的 picture 信息
        rs.execute("select * from picture where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into picture(eid,pictureurl,picturename,picturelink,pictureOrder,picturetype)" +
        	" values("+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("pictureurl")+"','"+rs.getString("picturename")+"','"+rs.getString("picturelink")+"','"+rs.getString("pictureOrder")+"','"+rs.getString("picturetype")+"')";
        	//插入操作
        	rslayout.execute(sql);
        }      
      
    /*复制 copyhpid 的 hpElement_slidesetting 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpElement_slidesetting 信息
    rs.execute("select * from hpElement_slidesetting where eleid in("+hpelementidstr+")");
    while(rs.next()){
    	sql = "insert into hpElement_slidesetting(eleid,displaydesc,imgsrc,imgdesc)" +
    	" values("+hpelementids.get(rs.getString("eleid"))+",'"+rs.getString("displaydesc")+"','"+rs.getString("imgsrc")+"','"+rs.getString("imgdesc")+"')";
    	//插入操作
    	rslayout.execute(sql);
    }      
    /*复制 copyhpid 的 hpsysremind 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpsysremind 信息
	    rs.execute("select * from hpsysremind where eid in("+hpelementidstr+")");
	    while(rs.next()){
	    	sql = "insert into hpsysremind(eid,orderid)" +
	    	" values("+hpelementids.get(rs.getString("eid"))+","+rs.getString("orderid")+")";
	    	//插入操作
	    	rslayout.execute(sql);
	    }  
   
        
        
    /*复制 copyhpid 的 hpFieldLength 信息*/	    	
		// 1、 查询出 copyhpid 所有的 hpFieldLength 信息
        rs.execute("select * from hpFieldLength where eid in("+hpelementidstr+")");
        while(rs.next()){
        	sql = "insert into hpFieldLength(userid,usertype,eid,efieldid,charnum,imgsize,newstemplate,imgtype,imgsrc)" +
        	" values("+creatorid+","+creatortype+","+hpelementids.get(rs.getString("eid"))+","+rs.getString("efieldid")+","+rs.getString("charnum")+",'"+rs.getString("imgsize")+"','"+rs.getString("newstemplate")+"','"+rs.getString("imgtype")+"','"+rs.getString("imgsrc")+"')";
        	//插入操作
        	rslayout.execute(sql);
        }        
    
        
    /*复制 copyhpid 的hpareaelement信息*/	    	
		// 1、 查询出 copyhpid 所有的hpareaelement信息
        rs.execute("select * from hpareaelement where hpid="+copyhpid);
        while(rs.next()){
        	sql = "insert into hpareaelement(hpid,eid,ebaseid,userid,usertype,module,modelastdate,modelasttime,ordernum)" +
        	" values("+maxHpid+","+rs.getString("eid")+",'"+rs.getString("ebaseid")+"',"+userid+","+creatortype+",'"+rs.getString("module")+"','"+rs.getString("modelastdate")+"','"+rs.getString("modelasttime")+"',"+rs.getString("ordernum")+")";
        	//插入操作
        	rslayout.execute(sql);
        }
        
   /*复制 copyhpid 的 slideElement 信息*/	    	
		// 1、 查询出 copyhpid 所有的 slideElement 信息
      rs.execute("select * from slideElement where eid in("+hpelementidstr+")");
      //hpElementSetting 表中 id 可以重复
      int slideElementMaxid = getTableMaxid(rs1,"slideElement","id")+1;
      while(rs.next()){
      	sql = "insert into slideElement(id,eid,title,description,url1,link,url2,url3)" +
      	" values("+slideElementMaxid+","+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("title")+"','"+rs.getString("description")+"','"+rs.getString("url1")+"','"+rs.getString("link")+"','"+rs.getString("url2")+"','"+rs.getString("url3")+"')";
      	//插入操作
      	rslayout.execute(sql);
      	slideElementMaxid++;
      } 
         
   /*复制 copyhpid 的 formmodeelement 信息*/	    	
		// 1、 查询出 copyhpid 所有的 formmodeelement 信息
      rs.execute("select * from formmodeelement where eid in("+hpelementidstr+")");
      while(rs.next()){
      	sql = "insert into formmodeelement(eid,reportid,isshowunread,fields,fieldswidth,disorder,searchtitle,isautoomit,isshowassingle)" +
      	" values("+hpelementids.get(rs.getString("eid"))+",'"+rs.getString("reportid")+"','"+rs.getString("isshowunread")+"','"+rs.getString("fields")+"','"+rs.getString("fieldswidth")+"','"+rs.getString("disorder")+"','"+rs.getString("searchtitle")+"','"+rs.getString("isautoomit")+"','"+rs.getString("isshowassingle")+"')";
      	//插入操作
      	rslayout.execute(sql);
      }
        
		response.sendRedirect("/homepage/maint/HomepagePageEdit.jsp?method=savebase&hpid="+maxHpid+"&subCompanyId="+subCompanyId+"&isfromportal=null&isfromhp=null&isSetting=true&pagetype=");
	}
	else if("savestyleid".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}



		String seleStyleid = Util.null2String(request.getParameter("seleStyleid"));
		String seleMenuStyleid = Util.null2String(request.getParameter("seleMenuStyleid"));
		rs.executeSql("update hpinfo set styleid='"+seleStyleid+"', menustyleid='"+seleMenuStyleid+"',hplastdate='"+date+"',hplasttime='"+time+"' where id="+hpid );
		
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/style/HomepageStyleList.jsp?hpid="+hpid+"&seleStyleid="+seleStyleid);
	}else if("savelayoutid".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}


		String seleLayoutid = Util.null2String(request.getParameter("seleLayoutid"));
		rs.executeSql("update hpinfo set layoutid="+seleLayoutid+" where id="+hpid );
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/layout/HomepageLayoutSele.jsp?hpid="+hpid+"&seleLayoutid="+seleLayoutid);
	}else if("savebase".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

        String onlyOnSave = Util.null2String(request.getParameter("txtOnlyOnSave"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String isuse = Util.null2String(request.getParameter("isuse"));
		String islocked = Util.null2String(request.getParameter("islocked"));
		
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String menuStyleid = Util.null2String(request.getParameter("seleMenuStyleid"));
		String bgcolor = Util.null2String(request.getParameter("bgcolor"));
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		isuse = "".equals(isuse)?"0":isuse;
		islocked = "".equals(islocked)?"0":islocked;
		rs.executeSql("select styleid,layoutid,menustyleid,Subcompanyid from hpinfo where id = "+hpid);
		rs.next();
		String oldstyleid = Util.null2String(rs.getString("styleid"));
		String oldlayoutid = Util.null2String(rs.getString("layoutid"));
		String oldmenuStyleid = Util.null2String(rs.getString("menustyleid"));
		String oldsubCompanyId = Util.null2String(rs.getString("Subcompanyid"));
		
		if(!oldstyleid.equals(styleid)||!oldlayoutid.equals(layoutid)||!oldmenuStyleid.equals(menuStyleid)){
			rs.executeSql("update hpinfo set subCompanyId='"+subCompanyId+"', infoname='"+infoname+"',infodesc='"+infodesc+"',isuse='"+isuse+"',islocked="+islocked+",styleid='"+styleid+"',layoutid='"+layoutid+"', menustyleid='"+menuStyleid+"',hplastdate='"+date+"',hplasttime='"+time+"',bgcolor='"+bgcolor+"' ,isRedirectUrl='"+isRedirectUrl+"' ,redirectUrl='"+redirectUrl+"' where id="+hpid );
		}else{
			rs.executeSql("update hpinfo set subCompanyId='"+subCompanyId+"', infoname='"+infoname+"',infodesc='"+infodesc+"',isuse='"+isuse+"',islocked="+islocked+",hplastdate='"+date+"',hplasttime='"+time+"',bgcolor='"+bgcolor+"',isRedirectUrl='"+isRedirectUrl+"',redirectUrl='"+redirectUrl+"' where id="+hpid );
		}
		if(!oldstyleid.equals(styleid)){
			rs.executeSql("update hpelement set styleid='"+styleid+"' where hpid="+hpid );
		}
		
		//机构转移
		if(!"".equals(oldsubCompanyId) && !oldsubCompanyId.equals(subCompanyId)){
			String strSql1="update hpinfo set subcompanyid="+subCompanyId+",creatortype=3,creatorid="+subCompanyId+",hplastdate='"+date+"',hplasttime='"+time+"' where id="+hpid;
	        String strSql2="update hplayout set usertype=3,userid="+subCompanyId+" where  hpid="+hpid+" and usertype=3 and userid="+oldsubCompanyId;
	        String strSql3="update hpElementSettingDetail set usertype=3,userid="+subCompanyId+" where  hpid="+hpid+" and usertype=3 and userid="+oldsubCompanyId;
	        rs.executeSql(strSql1);
	        rs.executeSql(strSql2);
	        rs.executeSql(strSql3);
		}
		
		
		//System.out.println("update hpelement set styleid='"+styleid+"' where hpid="+hpid );
		hpec.reloadHpElementCache();
		if(pc.isHaveThisHp(hpid))  pc.updateHpCache(hpid);
        else pc.addHpCache(hpid);

		//修改布局信息
		ArrayList dataFlagList=new ArrayList();
		rslayout.executeSql("select areaflag from hplayout where hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype);

		while(rslayout.next()) dataFlagList.add(Util.null2String(rslayout.getString(1)));

		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");

		//先改值
		for(int i=0;i<pageFlagList.size();i++){
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=Util.null2String(request.getParameter("txtArea_"+pageFlag));
			String strSql="";

			if(dataFlagList.contains(pageFlag)) {
                //暂时修改BUG4977
                //strSql="update  hplayout set areasize='"+pageFlagSize+"' where hpid="+hpid+" and areaflag='"+pageFlag+"' and  userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user);
                strSql="update  hplayout set areasize='"+pageFlagSize+"',layoutbaseid='"+layoutid+"' where hpid="+hpid+" and areaflag='"+pageFlag+"'";
                //有flag，但是layoutbaseid不一定相同
            } else {
				strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+creatorid+","+creatortype+")";
			}
			rslayout.executeSql(strSql);
		}
		//再删值

		for(int i=0;i<dataFlagList.size();i++){
			String dataFlag=(String)dataFlagList.get(i);
			String strSql="";

			if(!pageFlagList.contains(dataFlag)) {
				strSql="delete  hplayout  where hpid="+hpid+" and areaflag='"+dataFlag+"' and  userid="+creatorid+" and usertype="+creatortype;
			    rslayout.executeSql(strSql);
            }
			
		}
        if("true".equals(onlyOnSave)){
        	response.sendRedirect("/homepage/maint/HomepagePageEdit.jsp?method=savebase&hpid="+hpid+"&subCompanyId="+subCompanyId);
        } else {
            response.sendRedirect("/homepage/Homepage.jsp?isSetting=true&opt="+opt+"&subCompanyId="+subCompanyId+"&hpid="+hpid);
        }
	}else if("delhp".equals(method)||"suboperdelhp".equals(method)){

		if(!canPopDel) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

		if(hpid.indexOf(",")!=-1)hpid = hpid.substring(0,hpid.length()-1);
		//删除首页信息表
		String strSql="delete hpinfo where id in(" + hpid + ")";
		rs.executeSql(strSql);
		pc.deleteHpCache(hpid);

		//删除首页分部指定表
		//strSql="delete hpsubcompanyappiont where infoid="+hpid;
		//rs.executeSql(strSql);

		//用户选择首页表
		strSql="delete hpuserselect where infoid in(" + hpid + ")";
		rs.executeSql(strSql);

		//布局信息表
		strSql="delete hpLayout where hpid in(" + hpid + ")";
		rs.executeSql(strSql);

		//元素设置明细表
		strSql="delete hpElementSettingDetail where hpid in(" + hpid + ")";
		rs.executeSql(strSql);

		//元素字段字数长度表
	/*	strSql="select id from  hpElement where hpid in(" + hpid + ")";
		rs.executeSql(strSql);
		while(rs.next()){
			String tempEid=Util.null2String(rs.getString(1));
			rs1.executeSql("delete hpFieldLength where eid="+tempEid);
		}*/
		rs.executeSql("delete hpFieldLength where eid in (select id from  hpElement where hpid in(" + hpid + "))");
	
		//元素表
		strSql="delete  hpElement where hpid in(" + hpid + ")";
		rs.executeSql(strSql);
		if("suboperdelhp".equals(method)){
			response.sendRedirect("/homepage/maint/HomepageRight.jsp");
		}else{
			response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+subCompanyId);
		}
	}else if("synihp".equals(method)){
		if(!canPopSetting) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}
		if(creatortype!=3){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
        String strDel1="delete hpElementSettingDetail where hpid="+hpid+" and not (userid="+creatorid+" and usertype="+creatortype+")";
        String strDel2="delete hpLayout where  hpid="+hpid+" and   not (userid="+creatorid+" and usertype="+creatortype+")";
        //out.println(strDel1);
        //out.println(strDel2);
        //System.out.println(strDel1);
        //System.out.println(strDel2);

        rs.executeSql(strDel1);
        rs.executeSql(strDel2);
        /*
        String strDel3="";
        RecordSet rsElement=new RecordSet();
        rsElement.executeSql("select id from hpelement where hpid="+hpid);
        while(rsElement.next()){
          strDel3="delete hpFieldLength where  eid="+rsElement.getString(1)+" and   not (userid="+creatorid+" and usertype="+creatortype+")";
          rs.executeSql(strDel3);
        }
        */
        rs.executeSql("delete hpFieldLength where eid in (select id from  hpElement where hpid="+hpid+")  and   not (userid="+creatorid+" and usertype="+creatortype+")");

    }else if("synihpnormal".equals(method)){
        String strDel1="delete hpElementSettingDetail where hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype+"";
        String strDel2="delete hpLayout where  hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype+"";
        //System.out.println(strDel1);
       // System.out.println(strDel2);

        rs.executeSql(strDel1);
        rs.executeSql(strDel2);
/*
        String strDel3="";
        RecordSet rsElement=new RecordSet();
        rsElement.executeSql("select id from hpelement where hpid="+hpid);
        while(rsElement.next()){
          strDel3="delete hpFieldLength where  eid="+rsElement.getString(1)+" and  userid="+creatorid+" and usertype="+creatortype+"";
          rs.executeSql(strDel3);
        }
       */ 
        rs.executeSql("delete hpFieldLength where eid in (select id from  hpElement where hpid="+hpid+")  and  userid="+creatorid+" and usertype="+creatortype+"");
    	
    } else if("tran".equals(method)){
		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

		String srcSubid = Util.null2String(request.getParameter("srcSubid"));
		String targetSubid = Util.null2String(request.getParameter("targetSubid"));
		String tranHpid = Util.null2String(request.getParameter("tranHpid"));
		String fromSubid = Util.null2String(request.getParameter("fromSubid"));


		String strSql1="update hpinfo set subcompanyid="+targetSubid+",creatortype=3,creatorid="+targetSubid+",hplastdate='"+date+"',hplasttime='"+time+"' where id="+tranHpid;
        String strSql2="update hplayout set usertype=3,userid="+targetSubid+" where  hpid="+tranHpid+" and usertype=3 and userid="+srcSubid;
        String strSql3="update hpElementSettingDetail set usertype=3,userid="+targetSubid+" where  hpid="+tranHpid+" and usertype=3 and userid="+srcSubid;

		


        //out.println(strSql1);
        //out.println(strSql2);

        rs.executeSql(strSql1);
        rs.executeSql(strSql2);
        rs.executeSql(strSql3);
        
        pc.updateHpCache(tranHpid);



		response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+fromSubid);	

	}else if("delMaint".equals(method)){
		String ids = Util.null2String(request.getParameter("ids"));	
		if(!"".equals(ids)) rs.executeSql("delete from ptaccesscontrollist where mainid in("+ids+"0)");
		hpu.intUserMaintHpidList();
	    out.print("SUCCESS");
	}else if("addMaint".equals(method)){
		String subids = Util.null2String(request.getParameter("subids"));
		String depids = Util.null2String(request.getParameter("departmentid"));
		String roleid = Util.null2String(request.getParameter("roleid"));
		String userids = Util.null2String(request.getParameter("userid")); 
		String jobtitle = Util.null2String(request.getParameter("jobtitle"));
		
		String rolelevel = Util.null2String(request.getParameter("rolelevel"));
		String seclevel = Util.null2String(request.getParameter("seclevel"));
		String seclevelMax = Util.null2String(request.getParameter("seclevelMax"));
		String permissiontype = Util.null2String(request.getParameter("permissiontype"));
		
		String jobtitlelevel = Util.null2String(request.getParameter("jobtitlelevel"));
		String jobtitlesharevalue = "";
		if ("2".equals(jobtitlelevel)) {
			jobtitlesharevalue = Util.null2String(request.getParameter("department"));
		} else if ("3".equals(jobtitlelevel)) {
			jobtitlesharevalue = Util.null2String(request.getParameter("subcompany"));
		}
		
		if("6".equals(permissiontype)){//分部 6
			String[] ids = Util.TokenizerStringNew(subids,",");
			for (int i=0;i<ids.length;i++){
				rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=6 and dirid="+hpid+" and subcompanyid="+ids[i]);
				if(rs.next()){
					rs.executeSql("update ptaccesscontrollist set subcompanyid="+ids[i]+",seclevel="+seclevel+",seclevelMax="+seclevelMax+" where permissiontype=6 and dirid="+hpid+" and subcompanyid="+ids[i]);
				}else{
					rs.executeSql("insert into ptaccesscontrollist(dirid,subcompanyid,seclevel,seclevelMax,permissiontype,operationcode,dirtype)"+ 
					" values("+hpid+","+ids[i]+","+seclevel+","+seclevelMax+",6,1,0)");
				}
			}
		}else if("1".equals(permissiontype)){//部门 1
			String[] ids = Util.TokenizerStringNew(depids,",");
			for (int i=0;i<ids.length;i++){
				rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=1 and dirid="+hpid+" and departmentid="+ids[i]);
				if(rs.next()){
					rs.executeSql("update ptaccesscontrollist set seclevel="+seclevel+",seclevelMax="+seclevelMax+" where permissiontype=1 and dirid="+hpid+" and departmentid="+ids[i]);
				}else{
					rs.executeSql("insert into ptaccesscontrollist(dirid,departmentid,seclevel,seclevelMax,permissiontype,operationcode,dirtype)"+ 
					" values("+hpid+","+ids[i]+","+seclevel+","+seclevelMax+",1,1,0)");
				}
			}
		}else if("2".equals(permissiontype)){//角色 2
			rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=2 and dirid="+hpid+" and roleid="+roleid);
			if(rs.next()){
				rs.executeSql("update ptaccesscontrollist set rolelevel="+rolelevel+",seclevel="+seclevel+",seclevelMax="+seclevelMax+" where permissiontype=2 and dirid="+hpid+" and roleid="+roleid);
			}else{
				rs.executeSql("insert into ptaccesscontrollist(dirid,roleid,rolelevel,seclevel,seclevelMax,permissiontype,operationcode,dirtype)"+ 
				" values("+hpid+","+roleid+","+rolelevel+","+seclevel+","+seclevelMax+",2,1,0)");
			}
		}else if("3".equals(permissiontype)){//安全级别 3
			rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=3 and dirid="+hpid);
			if(rs.next()){
				rs.executeSql("update ptaccesscontrollist set seclevel="+seclevel+",seclevelMax="+seclevelMax+" where permissiontype=3 and dirid="+hpid);
			}else{
				rs.executeSql("insert into ptaccesscontrollist(dirid,seclevel,seclevelMax,permissiontype,operationcode,dirtype)"+ 
				" values("+hpid+","+seclevel+","+seclevelMax+",3,1,0)");
			}
		}else if ("5".equals(permissiontype)) {//人员 5       
			String[] ids = Util.TokenizerStringNew(userids,",");
			for (int i=0;i<ids.length;i++){
				rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=5 and dirid="+hpid+" and userid="+ids[i]);
				if(!rs.next()){
					rs.executeSql("insert into ptaccesscontrollist(dirid,userid,permissiontype,operationcode,dirtype)"+ 
					" values("+hpid+","+ids[i]+",5,1,0)");
				}
			}	        
        }else if ("7".equals(permissiontype)) {//岗位 7       
			String[] ids = Util.TokenizerStringNew(jobtitle,",");
			for (int i=0;i<ids.length;i++){
				rs.executeSql("select 1 from ptaccesscontrollist where permissiontype=7 and dirid="+hpid+" and jobtitle='"+ids[i]+ "' and jobtitlelevel='"+jobtitlelevel+"' and jobtitlesharevalue='"+jobtitlesharevalue+"'");
				if(!rs.next()){
					rs.executeSql("insert into ptaccesscontrollist(dirid,jobtitle,jobtitlelevel,jobtitlesharevalue,permissiontype,operationcode,dirtype)"+ 
					" values("+hpid+",'"+ids[i]+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"',7,1,0)");
				}
			}	        
        }
		hpu.intUserMaintHpidList();
        response.sendRedirect("HomepageMaintAddBrowser.jsp?isclose=1&hpid="+hpid);
		return;
	}
	else if("clearElement".equals(method))
	{
		String strUpdateSql="update hplayout set areaElements='' where hpid="+hpid+" and userid="+creatorid+" and usertype="+creatortype;
		//System.out.println(strUpdateSql);
		rs.executeSql(strUpdateSql);
		out.print("OK");
	}
%>


<%!  
// 处理门户复制，布局 元素 id 替换
  String  getNewHpLayoutAreaElements(Map<String,String> hpelementids , String areaElements){
      if(areaElements == null || "".equals(areaElements)) return areaElements;
	  if(hpelementids != null && !hpelementids.isEmpty()){
		  for(Map.Entry<String, String> obj: hpelementids.entrySet()) {
			  
			  //areaElements =  areaElements.replaceAll(obj.getKey()+",",obj.getValue()+",");
			  areaElements = (","+areaElements).replaceAll(","+obj.getKey()+",",","+obj.getValue()+",");
			 if(areaElements.startsWith(",")){
			 	 areaElements = areaElements.replaceFirst(",","");
			 }
		  }
	  }
	  return areaElements;
  }

  int  getTableMaxid(RecordSet rs, String tablename, String columnid){
	    String sql = "select max("+columnid+") maxid from "+tablename;
	    rs.execute(sql);
		int maxid = 1;
		if (rs.next())
		{
			maxid = rs.getInt("maxid");
		}
		
		return maxid;
  }

%>  

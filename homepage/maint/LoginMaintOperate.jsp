
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rslayout" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
	String method = Util.null2String(request.getParameter("method"));
	String opt = Util.null2String(request.getParameter("opt"));
	int creatorid = user.getUID();
	creatorid = 1;//登陆前页面所有设置操作都等同与管理员
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
	/*
	 权限判断
	 */
	if ("save".equals(method))
	{
        String areaResult=Util.null2String(request.getParameter("areaResult"));
        ArrayList resultList=Util.TokenizerString(areaResult,"||");
        
        for (int i=0;i<resultList.size();i++)
        {
            String result=(String)resultList.get(i);
            String[] paras = Util.TokenizerString2(result,"_");
            baseBean.writeLog(paras.length);
            String sql="update hpinfo set isuse='"+paras[1]+"',hplastdate='"+date+"',hplasttime='"+time+"' where id="+paras[0];
            rs.executeSql(sql);
        }
        pc.reloadHpCache();	
        log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql("修改门户首页信息："+areaResult);
    	log.setDesc("修改门户首页信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();

		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if ("ref".equals(method))//新建首页
	{
		
		String srchpid = Util.null2String(request.getParameter("srchpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String isuse = Util.null2String(request.getParameter("isuse"));
		String islocked = Util.null2String(request.getParameter("islocked"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		
		int creatortype = 0;
        //int creatorid=subCompanyId;
        //int creatortype=3;
        isuse = "".equals(isuse)?"0":isuse;
        
		//islocked = "".equals(islocked)?"0":islocked;
		//登录前页面默认锁定，不能更改
		islocked="1";
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+",-1,'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+",'"+isRedirectUrl+"','"+redirectUrl+"')");
        log.setItem("PortalPage");
    	log.setType("insert");
    	log.setSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+",-1,'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+",'"+isRedirectUrl+"','"+redirectUrl+"')");
    	log.setDesc("新建登陆前页面");
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

		//baseBean.writeLog(strSql);

        //rs.executeSql(strSql);

        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,sharelevel) values ("+maxHpid+",6,-1,0,1)";
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
    	response.sendRedirect("/homepage/maint/LoginPageEdit.jsp?method=savebase&hpid="+maxHpid);
		
		

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
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		
		int creatortype = 0;
		//需要复制的门户模板
		String copyhpid = Util.null2String(request.getParameter("hpid"));
		
        //int creatorid=subCompanyId;
        //int creatortype=3;
        isuse = "".equals(isuse)?"0":isuse;
		islocked = "".equals(islocked)?"0":islocked;
		//前端 disabled ，不能往后台传值
		String layoutid = "";//Util.null2String(request.getParameter("seleLayoutid"));
		rs.execute("select layoutid from hpinfo where id="+copyhpid);
		if(rs.next()){
			layoutid = rs.getString("layoutid");
		}
		
	
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,isRedirectUrl,redirectUrl) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+",-1,'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+",'"+isRedirectUrl+"','"+redirectUrl+"')");
		int maxHpid=hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
        
		//hpec.reloadHpElementCache();
		
        if(pc.isHaveThisHp(""+maxHpid))  
			pc.updateHpCache(""+maxHpid);
        else 
        	pc.addHpCache(""+maxHpid);


        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,sharelevel) values ("+maxHpid+",6,-1,0,1)";
		rs.executeSql(strShareSql);
		
    /*复制 copyhpid 的 元素信息*/	    	
		// 1、 查询出 copyhpid 所有的元素信息
		String areaelements="";
    	rs.execute("select areaelements from hplayout where hpid="+copyhpid+" and usertype=0");
    	while(rs.next()){
    		areaelements+=rs.getString("areaelements");
    	}
    	if(!areaelements.equals("")){
    		areaelements = areaelements.substring(0,areaelements.length()-1);
    	}
    	
        rs.execute("select * from hpelement where hpid="+copyhpid+" and id in ("+areaelements+")");
        //存储 copyhpid hpelement id 对应的 新 元素id
        Map<String,String> hpelementids = new HashMap<String,String>();
        Map<String,String> hpelementidsno = new HashMap<String,String>();
        String hpelementidstr = "";
        String sql = "";
        String newhpelementid = "";
        while(rs.next()){
        	sql = "insert into hpElement(title,logo,islocked,strsqlwhere,ebaseid,isSysElement,hpid,isFixationRowHeight,background,styleid,marginTop,shareuser,scrolltype,isRemind,fromModule,isuse)" +
        	" values('"+rs.getString("title")+"','"+rs.getString("logo")+"','"+rs.getString("islocked")+"','"+rs.getString("strsqlwhere")+"','"+rs.getString("ebaseid")+"','"+rs.getString("isSysElement")+"',"+maxHpid+",'"+rs.getString("isFixationRowHeight")+"','"+rs.getString("background")+"','"+styleid+"',"+rs.getString("marginTop")+",'"+rs.getString("shareuser")+"','"+rs.getString("scrolltype")+"','"+rs.getString("isRemind")+"','"+rs.getString("fromModule")+"','"+rs.getString("isuse")+"')";
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
        
        //baseBean.writeLog(hpelementids.toString());
        
   /*复制 copyhpid 的布局信息*/	    	
		// 1、 查询出 copyhpid 所有的布局信息
        rs.execute("select * from hplayout where hpid="+copyhpid);
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
        rs.execute("select * from hpElementSettingDetail where eid in("+hpelementidstr+")");
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
        	" values("+maxHpid+","+rs.getString("eid")+",'"+rs.getString("ebaseid")+"',"+creatorid+","+creatortype+",'"+rs.getString("module")+"','"+rs.getString("modelastdate")+"','"+rs.getString("modelasttime")+"',"+rs.getString("ordernum")+")";
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
		
        
      response.sendRedirect("/homepage/maint/LoginPageEdit.jsp?method=savebase&hpid="+maxHpid);

	}
	else if ("savestyleid".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleStyleid = Util.null2String(request.getParameter("seleStyleid"));
		String Sql = "update hpinfo set styleid='" + seleStyleid + "',hplastdate='"+date+"',hplasttime='"+time+"' where id=" + hpid;
		rs.executeSql(Sql);
		pc.updateHpCache(hpid);
		log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql(Sql);
    	log.setDesc("编辑首页样式信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
		response.sendRedirect("/homepage/style/HomepageStyleList.jsp?hpid=" + hpid + "&seleStyleid=" + seleStyleid);
	}
	else if ("savelayoutid".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleLayoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String Sql="update hpinfo set layoutid=" + seleLayoutid + ",hplastdate='"+date+"',hplasttime='"+time+"' where id=" + hpid;
		rs.executeSql(Sql);
		pc.updateHpCache(hpid);
		log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql(Sql);
    	log.setDesc("编辑首页布局信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
		response.sendRedirect("/homepage/layout/HomepageLayoutSele.jsp?hpid=" + hpid + "&seleLayoutid=" + seleLayoutid);
	}
	else if ("savebase".equals(method))
	{
		String onlyOnSave = Util.null2String(request.getParameter("txtOnlyOnSave"));
		String hpid = Util.null2String(request.getParameter("hpid"));
		String isuse = Util.null2String(request.getParameter("isuse"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String isRedirectUrl  = Util.null2String(request.getParameter("isRedirectUrl"));
		String redirectUrl  = Util.null2String(request.getParameter("redirectUrl"));
		
		isuse = "".equals(isuse)?"0":isuse;

		rs.executeSql("update hpinfo set infoname='"+infoname+"',infodesc='"+infodesc+"',isuse='"+isuse+"',styleid='"+styleid+"',layoutid="+layoutid+",hplastdate='"+date+"',hplasttime='"+time+"',isRedirectUrl='"+isRedirectUrl+"',redirectUrl='"+redirectUrl+"' where id="+hpid );
		if(pc.isHaveThisHp(hpid))  
			pc.updateHpCache(hpid);
        else 
        	pc.addHpCache(hpid);
		
		//修改布局信息
		ArrayList dataFlagList=new ArrayList();
		rslayout.executeSql("select areaflag from hplayout where hpid="+hpid+" and userid="+creatorid+" and usertype=0");

		while(rslayout.next()) 
			dataFlagList.add(Util.null2String(rslayout.getString(1)));

		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");

		//先改值
		for(int i=0;i<pageFlagList.size();i++)
		{
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=Util.null2String(request.getParameter("txtArea_"+pageFlag));
			String strSql="";

			if(dataFlagList.contains(pageFlag)) 
			{
                //暂时修改BUG4977               
                strSql="update  hplayout set areasize='"+pageFlagSize+"',layoutbaseid='"+layoutid+"' where hpid="+hpid+" and areaflag='"+pageFlag+"'";
                //有flag，但是layoutbaseid不一定相同
			}else 
            {
				strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+creatorid+",0)";
			}
			rslayout.executeSql(strSql);
		}
		//再删值

		for(int i=0;i<dataFlagList.size();i++)
		{
			String dataFlag=(String)dataFlagList.get(i);
			String strSql="";

			if(!pageFlagList.contains(dataFlag)) 
			{
				strSql="delete  hplayout  where hpid="+hpid+" and areaflag='"+dataFlag+"' and  userid="+creatorid+" and usertype=0";
			    rslayout.executeSql(strSql);
            }
			
		}
		
		// 菜单样式 变更
		rs.executeSql("update hpelement set styleid='"+styleid+"' where hpid="+hpid );
		log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql("编辑首页信息savebase-hpid:"+hpid);
    	log.setDesc("编辑首页布局信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
        if("true".equals(onlyOnSave))
        {
    		response.sendRedirect("/homepage/maint/LoginPageEdit.jsp?method=savebase&hpid="+hpid);
        } 
        else 
        {
            response.sendRedirect("/homepage/Homepage.jsp?isSetting=true&opt="+opt+"&hpid="+hpid+"&pagetype=loginview");
        }
	}
	else if ("delhp".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		if(hpid.indexOf(",")!=-1)hpid = hpid.substring(0,hpid.length()-1);
		//删除首页信息表
		String strSql = "delete hpinfo where id in(" + hpid + ")";
		rs.executeSql(strSql);
		pc.deleteHpCache(hpid);

		//用户选择首页表
		strSql = "delete hpuserselect where infoid in(" + hpid + ")";
		rs.executeSql(strSql);

		//布局信息表
		strSql = "delete hpLayout where hpid in(" + hpid + ")";
		rs.executeSql(strSql);

		//元素设置明细表
		strSql = "delete hpElementSettingDetail where hpid in(" + hpid + ")";
		rs.executeSql(strSql);

		//元素字段字数长度表
		strSql = "select id from  hpElement where hpid in(" + hpid + ")";
		rs.executeSql(strSql);
		while (rs.next())
		{
			String tempEid = Util.null2String(rs.getString(1));
			rs1.executeSql("delete hpFieldLength where eid=" + tempEid);
		}

		//元素表
		strSql = "delete  hpElement where hpid in(" + hpid + ")";
		rs.executeSql(strSql);
		log.setItem("PortalPage");
    	log.setType("delete");
    	log.setSql("删除首页信息-hpid:"+hpid);
    	log.setDesc("删除首页信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if ("synihp".equals(method))
	{
		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if ("tran".equals(method))
	{
		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if("clearElement".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		String strUpdateSql="update hplayout set areaElements='' where hpid="+hpid+" and userid="+creatorid+" and usertype=0";
		//baseBean.writeLog(strUpdateSql);
		rs.executeSql(strUpdateSql);
		log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql(strUpdateSql);
    	log.setDesc("清除首页所有元素布局信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
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
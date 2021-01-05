
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="wbe" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<jsp:useBean id="eu" class="weaver.page.element.ElementUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="wpc" class="weaver.admincenter.homepage.WeaverPortalContainer" scope="page"/>
<%	
	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String styleid=Util.null2String(request.getParameter("styleid"));
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String layoutflag=Util.null2String(request.getParameter("layoutflag"));
	String addType = Util.null2String(request.getParameter("addType"));
	String fromModule = Util.null2String(request.getParameter("fromModule"));
    boolean isSystemer=false;
	//int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
    if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
    
    ArrayList list = pu.getShareMaintListByUser(user.getUID()+"");
    if(list.indexOf(hpid)!=-1){
    	isSystemer=true;
    }
    //if(opreateLevel>0&&subCompanyId!=-1)  isSystemer=true;
	
	int maxEid=0;
	String managerStr="0";
	if(isSystemer)  managerStr="1";

	//求用户的ID与分部ID
	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid =1;
		usertype=0;
	}else if("0".equals(hpid)&&subCompanyId==0){
		userid =1;
		usertype=0;
	}
	
	if(Util.getIntValue(hpid)<0) {//协同的 userid  和 usertype 为 1  和 0
		userid =1;
		usertype=0;
	}
	//添加元素
	String strSql="insert into hpElement(title,logo,islocked,ebaseid,isSysElement,hpid,styleid,marginTop,shareuser,scrolltype,fromModule,isuse) values('"+(user.getLanguage()==8?wbe.getTitleEN(ebaseid):wbe.getTitle(ebaseid))+"','"+wbe.getElogo(ebaseid)+"','0','"+ebaseid+"','"+managerStr+"',"+hpid+",'"+styleid+"','10','5_1','None','"+fromModule+"',1)";
	rs.executeSql(strSql);

	rs.executeSql("select max(id) from hpElement");
	if(rs.next()){
		maxEid=Util.getIntValue(rs.getString(1));
	}
	hpec.addHpElementCache(""+maxEid);

    String strUpdateSql="";
    if("Portal".equals(fromModule)){
	    if("".equals(addType)){
	    	//先查询是否存在数据
	    	rs.executeSql("select * from hplayout where hpid="+hpid+" and userid="+userid +" and usertype="+usertype);
	    	if(rs.next()){//编辑
			    if (rs.getDBType().equals("sqlserver")){
			        strUpdateSql="update hplayout set areaElements='"+maxEid+",'+areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
			    }else{
			        strUpdateSql="update hplayout set areaElements='"+maxEid+",' || areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
			    }
	    	}else{//新增
	    		//获取 layoutbaseid,areaflag,areasize
	    		rs.execute("select * from hplayout where hpid="+hpid +" and areaflag='"+layoutflag+"' order by id desc");
	    	    if(rs.next()){
	    		    rs.execute("insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+rs.getString("layoutbaseid")+",'"+layoutflag+"','"+rs.getString("areasize")+"','"+maxEid+",',"+userid+","+usertype+")");
	    	    }
	    	}
	    }else{
	    	if (rs.getDBType().equals("sqlserver"))
		        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",'+areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
		    else
		        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",' || areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
	    }
	    baseBean.writeLog(strUpdateSql+" ");
	    rs.executeSql(strUpdateSql);
    }
    String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
    String areaStr = "insert into hpareaelement(hpid,eid,ebaseid,userid,usertype,module,modelastdate,modelasttime,ordernum) values("+hpid+","+maxEid+",'"+ebaseid+"',"+userid+","+usertype+",'"+fromModule+"','"+date+"','"+time+"',0)";

	rs.executeSql(areaStr);
    //添加共享信息
	String strInsertSql = "insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) values("+hpid+","+maxEid+","+userid+","+usertype+","+wbe.getPerpage(ebaseid)+","+wbe.getLinkmode(ebaseid)+",'2')";

	rs.executeSql(strInsertSql);
	 out.println("<style type=\"text/css\">");
	 out.println(pu.getElementCss(hpid,""+maxEid));
	 out.println("</style>");
	 if("Portal".equals(fromModule)){
		 if("".equals(addType)){
			 out.println(eu.getContainer(ebaseid,""+maxEid,hpid,styleid,"0","2",user,subCompanyId,userid,usertype,true));
		 }else{
			 out.println(eu.getContainer(ebaseid,""+maxEid,hpec.getStyleid(""+maxEid),user,true));
		 }
	 }else{
		 out.println(wpc.getElementFrame(ebaseid,""+maxEid,user));
	 }
%>	
    
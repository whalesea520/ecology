
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
	boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
	boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  
	boolean hasRight = false;
	if(HeadMenuhasRight || SubMenuRight)
		hasRight = true;
	if(!hasRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String method = Util.null2String(request.getParameter("method"));	
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();

  	if("menuDrag".equals(method)){
		String moveType = Util.null2String(request.getParameter("moveType"));
		int menuid = Util.getIntValue(Util.null2String(request.getParameter("menuid")),0); // 当前菜单ID
		int targetindex = Util.getIntValue(request.getParameter("targetindex"),0);
		int srcindex = Util.getIntValue(request.getParameter("srcindex"),0);
		int parentid = Util.getIntValue(request.getParameter("parentid"),0);
		String menutype = Util.null2String(request.getParameter("type"));
		StringBuffer sbf = new StringBuffer();
		
		
		
		String strSql="";
		
		
		if(targetindex>=srcindex){
			rs.executeSql("update menucustom set menuindex='"+targetindex+"' where id = '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			sbf.append("update menucustom set menuindex='"+targetindex+"' where id = '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			
			rs.executeSql("update menucustom set menuindex= menuindex-1 where  menuindex <= '"+targetindex+"' and id != '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			sbf.append("update menucustom set menuindex= menuindex-1 where  menuindex <= '"+targetindex+"' and id != '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
		}else if(targetindex<srcindex){
			rs.executeSql("update menucustom set menuindex='"+targetindex+"' where id = '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			sbf.append("update menucustom set menuindex='"+targetindex+"' where id = '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			
			
			rs.executeSql("update menucustom set menuindex= menuindex+1 where  menuindex >= '"+targetindex+"' and id != '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			sbf.append("update menucustom set menuindex= menuindex+1 where  menuindex >= '"+targetindex+"' and id != '"+menuid+"' and menuparentid='"+parentid+"' and menutype='"+menutype+"'");
			
		}
		strSql+=sbf.toString();
		

		log.setItem("PortalMenu");
		log.setType("update");
		log.setSql(strSql);
		log.setDesc("拖动自定义菜单顺序");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		out.print("OK");
	}else if("add".equals(method)){
		String menuname = Util.null2String(request.getParameter("menuname"));	
		String menudesc = Util.null2String(request.getParameter("menudesc"));	
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="";		
		
		long now = System.currentTimeMillis();

		//insert data to menu center
		sql="insert into menucenter(id,menuname,menudesc,menutype,subcompanyid,menucreater,menulastdate,menulasttime) values ('"+now+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+subCompanyId+"','"+user.getUID()+"','"+date+"','"+time+"')";
		rs.executeSql(sql);
		//update menu center cache
		//MenuCenterCominfo.updateCache(""+now);
		MenuCenterCominfo.clearCominfoCache();
		sql="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values (1,'"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+"','','','mainiframe','0','1','"+now+"','','','5','1')";
		//baseBean.writeLog("add menucustom : "+sql);
		rs.executeSql(sql);

		response.sendRedirect("/page/maint/menu/MenuEdit.jsp?closeDialog=close&menutype="+menutype+"&id="+now+"&subCompanyId="+subCompanyId);
	} else if("del".equals(method)){
		String menuid = Util.null2String(request.getParameter("menuid"));	
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="";
		rs.executeSql("delete menucenter where id='"+menuid+"'");
		sql+="delete menucenter where id='"+menuid+"'";
		
		rs.executeSql("delete menucustom where menutype='"+menuid+"'");
		sql+="delete menucustom where menutype='"+menuid+"'";
		
		//MenuCenterCominfo.updateCache(""+menuid);
		MenuCenterCominfo.clearCominfoCache();
		log.setItem("PortalMenu");
		log.setType("delete");
		log.setSql(sql);
		log.setDesc("删除自定义菜单");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		response.sendRedirect("/page/maint/menu/MenuEdit.jsp?closeDialog=close&type=custom&menutype="+menutype+"&subCompanyId="+subCompanyId);
	}else if("edit".equals(method)){
		String menuid = Util.null2String(request.getParameter("menuid"));	
		String menuname = Util.null2String(request.getParameter("menuname"));	
		String menudesc = Util.null2String(request.getParameter("menudesc"));	
		String menutype = Util.null2String(request.getParameter("menutype"));	
		String sql="update menucenter set menuname='"+menuname+"',menudesc='"+menudesc+"',menutype='"+menutype+"',subCompanyId='"+subCompanyId+"',menulastdate='"+date+"',menulasttime='"+time+"' where id='"+menuid+"'";
		//baseBean.writeLog(sql);
		
		log.setItem("PortalMenu");
		log.setType("update");
		log.setSql(sql);
		log.setDesc("修改自定义菜单基本信息");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		
		rs.executeSql(sql);
		MenuCenterCominfo.clearCominfoCache();
		response.sendRedirect("/page/maint/menu/MenuEdit.jsp?type=custom&closeDialog=close&menutype="+menutype+"&subCompanyId="+subCompanyId+"&msg=1");
	}else if("tran".equals(method)){
		String srcSubId = Util.null2String(request.getParameter("srcSubid"));
		String targetSubId = Util.null2String(request.getParameter("targetSubid"));
		String tranMenuId = Util.null2String(request.getParameter("tranMenuId"));
		//String fromSubid = Util.null2String(request.getParameter("fromSubid"));
		String sql= "update menucenter set subCompanyId="+targetSubId+" where id = '"+tranMenuId+"'";
		rs.execute(sql);
		//baseBean.writeLog("update menucenter set subCompanyId="+targetSubId+" where id = '"+tranMenuId+"'");
		//MenuCenterCominfo.updateCache(tranMenuId);
		log.setItem("PortalMenu");
		log.setType("update");
		log.setSql(sql);
		log.setDesc("转移自定义菜单");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		MenuCenterCominfo.clearCominfoCache();
		response.sendRedirect("/page/maint/menu/CustomMenuMaintList.jsp?type=custom&menutype=2&subCompanyId="+srcSubId);
	}else if("checkMenuName".equals(method)){ //菜单名称重复性验证
		String menuname = Util.null2String(request.getParameter("menuname"));
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="select id from menucenter where subcompanyid='"+subCompanyId+"' and menutype='"+menutype+"' and menuname='"+menuname+"'";
		rs.executeSql(sql);
		if(rs.next())
			out.print("true"); //菜单名称重复
		else
			out.print("false");
	}else if("addMenu".equals(method)){
		String id = Util.null2String(request.getParameter("id"));
		String menuid = Util.null2String(request.getParameter("menuid"));
		
		//rs.executeSql("select (select MAX(CAST(id as int))+1 from menucustom where menutype='"+menuid+"')maxid,max(CAST(menuindex as int))+1 menuindex from menucustom where menuparentid="+id+" and menutype='"+menuid+"'");
		rs.executeSql("select MAX(CAST(id as int))+1 maxid from menucustom where menutype='"+menuid+"'");
		rs.next();
		String maxid = rs.getString("maxid");
		rs.executeSql("select max(CAST(menuindex as int))+1 menuindex from menucustom where menuparentid="+id+" and menutype='"+menuid+"'");
		rs.next();
		String menuindex = Util.null2String(rs.getString("menuindex"));
		menuindex = "".equals(menuindex)?"1":menuindex;
		
		String name=Util.null2String(request.getParameter("name"));
		String menuicon=Util.null2String(request.getParameter("menuicon"));
		String menuhref=Util.null2String(request.getParameter("menuhref"));
		String menutarget=Util.null2String(request.getParameter("menutarget"));
		
		String menurighttype = Util.null2String(request.getParameter("menurighttype"));
		String menurightvalue=Util.null2String(request.getParameter("menurightvalue"));
		String sharevalue =Util.null2String(request.getParameter("sharevalue"));
		String sharetype=Util.null2String(request.getParameter("menusharetype"));
		
		int index = menuhref.indexOf("selectedContent");
		int _index = menuhref.indexOf("|");
		int indexStart = index+"selectedContent=".length();
		
		String sqlTemp="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values ("+maxid+",'"+name+"','"+menuicon+"','"+menuhref+"','"+menutarget+"','"+id+"','"+menuindex+"','"+menuid+"','"+menurighttype+"','"+menurightvalue+"','"+sharetype+"','"+sharevalue+"') ";
		//baseBean.writeLog("sqlTemp : "+sqlTemp);
		//out.println(sqlTemp+"<br>");
		if(index!=-1 && _index!=-1){
			rs.executeSql("delete menuResourceNode where contentindex = '"+menuid+(menuindex)+"'");
			
			String tempStr = menuhref.substring(indexStart);
			String[] nodestr = tempStr.split("\\|");
			for(int j=0;j<nodestr.length;j++){
				sqlTemp="insert into menuResourceNode(contentindex,txtNode) values ('"+menuid+(menuindex)+"','"+nodestr[j]+"') ";
				//baseBean.writeLog("********--"+sqlTemp);
				rs.executeSql(sqlTemp);
			}
			
			menuhref = menuhref.substring(0,indexStart)+ "key_"+ menuid+(menuindex);
			sqlTemp="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue,selectnodes) values ("+maxid+",'"+name+"','"+menuicon+"','"+menuhref+"','"+menutarget+"','"+id+"','"+menuindex+"','"+menuid+"','"+menurighttype+"','"+menurightvalue+"','"+sharetype+"','"+sharevalue+"','"+menuid+(menuindex)+"') ";
		}
		log.setItem("PortalMenu");
		log.setType("insert");
		log.setSql("新建自定义菜单");
		log.setDesc("新建自定义菜单");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		rs.executeSql(sqlTemp);
		response.sendRedirect("/page/maint/menu/MenuEditInfo.jsp?closeDialog=close");
	}else if("editMenu".equals(method)){
		String id = Util.null2String(request.getParameter("id"));
		String menuid = Util.null2String(request.getParameter("menuid"));
		
		String name=Util.null2String(request.getParameter("name"));
		String menuicon=Util.null2String(request.getParameter("menuicon"));
		String menuhref=Util.null2String(request.getParameter("menuhref"));
		String menutarget=Util.null2String(request.getParameter("menutarget"));
		
		String menurighttype = Util.null2String(request.getParameter("menurighttype"));
		String menurightvalue=Util.null2String(request.getParameter("menurightvalue"));
		String sharevalue =Util.null2String(request.getParameter("menusharevalue"));
		String sharetype=Util.null2String(request.getParameter("menusharetype"));
		
		String sql = "UPDATE menucustom set menuname='"+name+"',menuicon='"+menuicon+"',menuhref='"+menuhref+"',menutarget='"+menutarget+"',righttype='"+menurighttype+"',rightvalue='"+menurightvalue+"',sharetype='"+sharetype+"',sharevalue='"+sharevalue+"' where id="+id+" and menutype='"+menuid+"'";
		//baseBean.writeLog(sql+"======");
		
		rs.executeSql(sql);
		log.setItem("PortalMenu");
		log.setType("update");
		log.setSql(sql);
		log.setDesc("编辑自定义菜单");
		log.setUserid(user.getUID()+"");
		log.setIp(request.getRemoteAddr());
		log.setOpdate(TimeUtil.getCurrentDateString());
		log.setOptime(TimeUtil.getOnlyCurrentTimeString());
		log.savePortalOperationLog();
		
		response.sendRedirect("/page/maint/menu/MenuEditInfo.jsp?closeDialog=close");
	}else if("delMenu".equals(method)){
		String id = Util.null2String(request.getParameter("id"));
		String menuid = Util.null2String(request.getParameter("menuid"));
		
		rs.executeSql("DELETE from menucustom where id="+id+" and menutype='"+menuid+"'");
		out.print("OK");
	}
%>

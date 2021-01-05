
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) return;

String menuid = Util.null2String(request.getParameter("menuid"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String menutype = Util.null2String(request.getParameter("menutype"));
String operate = Util.null2String(request.getParameter("operate"));

if("addMenu".equals(operate)){
	String pageUrl = Util.null2String(request.getParameter("pageUrl"));
	String menuname = Util.null2String(request.getParameter("menuname"));
	String menudesc = Util.null2String(request.getParameter("menudesc"));
	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
  	long now = System.currentTimeMillis();
	String id=""+now;	
	String strSql="";
	strSql+="INSERT INTO menucenter (id,menuname,menudesc,menutype,menucreater,menulastdate,menulasttime,subcompanyid)"
		+"VALUES('"+id+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+user.getUID()+"','"+date+"','"+time+"','"+subCompanyId+"')";
	rs.executeSql("INSERT INTO menucenter (id,menuname,menudesc,menutype,menucreater,menulastdate,menulasttime,subcompanyid)"
			+"VALUES('"+id+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+user.getUID()+"','"+date+"','"+time+"','"+subCompanyId+"')");
	strSql+="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values (1,'"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+"','','','mainiframe','0','1','"+id+"','','','5','1')";	
	rs.executeSql("insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values (1,'"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+"','','','mainiframe','0','1','"+id+"','','','5','1')");
	if("list".equals(pageUrl))
		pageUrl = "/page/maint/menu/CustomMenuEdit.jsp?closeDialog=close&type=custom&menutype="+menutype;
	else if("edit".equals(pageUrl))
		pageUrl = "/page/maint/menu/CustomMenuEdit.jsp?closeDialog=closeAndEdit&menuid="+id+"&menutype="+menutype+"&subCompanyId="+subCompanyId;
	log.setItem("PortalMenu");
	log.setType("insert");
	log.setSql(strSql);
	log.setDesc("添加自定义菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	response.sendRedirect(pageUrl);
}else if("delMenu".equals(operate)){
	String strSql="";
	strSql+="delete from menucenter where id='"+menuid+"'";
	
	rs.executeSql("delete from menucenter where id='"+menuid+"'");
	
	strSql+="delete menucustom where menutype='"+menuid+"'";

	rs.executeSql("delete menucustom where menutype='"+menuid+"'");
	MenuCenterCominfo.clearCominfoCache();
	log.setItem("PortalMenu");
	log.setType("delete");
	log.setSql(strSql);
	log.setDesc("删除自定义菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	out.print("OK");
}else if("delAllMenu".equals(operate)){
	menuid = menuid.substring(0,menuid.length()-1);
	String[] menuids = menuid.split(",");
	for(int i=0;i<menuids.length;i++){		
		rs.executeSql("delete from menucenter where id='"+menuids[i]+"'");
		rs.executeSql("delete menucustom where menutype='"+menuids[i]+"'");
	}
	
	log.setItem("PortalMenu");
	log.setType("delete");
	log.setSql("批量删除菜单"+menuid);
	log.setDesc("删除自定义菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	MenuCenterCominfo.clearCominfoCache();
	out.print("OK");
}else if("saveNew".equals(operate)){	
	String pageUrl = Util.null2String(request.getParameter("pageUrl"));
	String menuname = Util.null2String(request.getParameter("menuname"));
	String menudesc = Util.null2String(request.getParameter("menudesc"));
	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
  	long now = System.currentTimeMillis();
	String id=""+now;	
	String strSql="";
	rs1.executeSql("INSERT INTO menucenter (id,menuname,menudesc,menutype,menucreater,menulastdate,menulasttime,subcompanyid)"
			+"VALUES('"+id+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+user.getUID()+"','"+date+"','"+time+"','"+subCompanyId+"')");
	
	strSql +="INSERT INTO menucenter (id,menuname,menudesc,menutype,menucreater,menulastdate,menulasttime,subcompanyid)"
		+"VALUES('"+id+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+user.getUID()+"','"+date+"','"+time+"','"+subCompanyId+"')";
	rs1.executeSql("INSERT INTO menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue)"
			+" select id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,'"+id+"',righttype,rightvalue,sharetype,sharevalue from menucustom where menutype='"+menuid+"'");
	strSql +="INSERT INTO menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue)"
		+" select id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,'"+id+"',righttype,rightvalue,sharetype,sharevalue from menucustom where menutype='"+menuid+"'";
	MenuCenterCominfo.clearCominfoCache();
	if("list".equals(pageUrl))
		pageUrl = "/page/maint/menu/CustomMenuEdit.jsp?closeDialog=close&type=custom&menutype="+menutype;
	else if("edit".equals(pageUrl))
		pageUrl = "/page/maint/menu/CustomMenuEdit.jsp?closeDialog=close&operate=saveNew&menuid="+id+"&menutype="+menutype+"&subCompanyId="+subCompanyId;
	log.setItem("PortalMenu");
	log.setType("insert");
	log.setSql(strSql);
	log.setDesc("另存为新建自定义菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	response.sendRedirect(pageUrl);
}
%>

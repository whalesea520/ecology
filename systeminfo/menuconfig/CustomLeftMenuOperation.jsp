
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.CustomLeftMenu" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=0;
userid = user.getUID();

String operationType = Util.null2String(request.getParameter("operationType"));
int currentID = 0;
String sql = "";


//TD3890
//modified by hubo,2006-03-21
currentID = CustomLeftMenu.getLeftMenuCurrentId();



//Add Menu Category
if(operationType.equals("addC")){
	String customMenuCName = Util.null2String(request.getParameter("customMenuCName"));
	int customMenuCViewIndex = Util.getIntValue(request.getParameter("customMenuCViewIndex"),0);
	
	sql = " INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,useCustomName,customName,relatedModuleId,isCustom) " +
		  " VALUES ("+currentID+",null,'/images/folder_wev8.png',null,1,null,"+customMenuCViewIndex+",'1','"+customMenuCName+"',12,'1')";
	rs.executeSql(sql);
	
	sql = " INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) " +
		  " VALUES ("+userid+","+currentID+",'1',"+customMenuCViewIndex+","+userid+",'3','0',0,'1','"+customMenuCName+"')";
	rs.executeSql(sql);

//Add Menu
}else if(operationType.equals("add")){
	int parentID = Util.getIntValue(request.getParameter("parentID"),0);
	String customMenuName = Util.null2String(request.getParameter("customMenuName"));
	String customMenuLink = Util.null2String(request.getParameter("customMenuLink"));
	int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuCViewIndex"),0);
	String targetframe = Util.null2String(request.getParameter("targetframe"));
	sql = " INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,useCustomName,customName,relatedModuleId,isCustom,baseTarget) " +
		  " VALUES ("+currentID+",null,'/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif','"+customMenuLink+"',2,"+parentID+","+customMenuViewIndex+",'1','"+customMenuName+"',12,'1','"+targetframe+"')";
	rs.executeSql(sql);

	sql = " INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) " +
		  " VALUES ("+userid+","+currentID+",'1',"+customMenuViewIndex+","+userid+",'3','0',0,'1','"+customMenuName+"')";
	rs.executeSql(sql);

//Clone Menu
}else if(operationType.equals("clone")){
	int parentID = Util.getIntValue(request.getParameter("parentID"),0);
	String customMenuName = Util.null2String(request.getParameter("customMenuName"));
	String customMenuLink = Util.null2String(request.getParameter("customMenuLink"));
	customMenuLink = Util.replace(customMenuLink,"\\*","&",0);
	int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuViewIndex"),0);
	sql = " INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,useCustomName,customName,relatedModuleId,isCustom) " +
		  " VALUES ("+currentID+",null,'/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif','"+customMenuLink+"',2,"+parentID+","+customMenuViewIndex+",'1','"+customMenuName+"',12,'1')";
	rs.executeSql(sql);

	sql = " INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) " +
		  " VALUES ("+userid+","+currentID+",'1',0"+","+userid+",'3','0',0,'1','"+customMenuName+"')";
	rs.executeSql(sql);

//Edit Menu
}else if(operationType.equals("edit")){
	int menuID = Util.getIntValue(request.getParameter("menuID"),0);
	String customMenuName = Util.null2String(request.getParameter("customMenuName"));
	String customMenuLink = Util.null2String(request.getParameter("customMenuLink"));
	int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuCViewIndex"),0);
	String targetframe = Util.null2String(request.getParameter("targetframe"));
	String sqltemp = "";
	if(Util.null2String(request.getParameter("edit")).equals("sub")) 
		sqltemp=",linkAddress='"+customMenuLink+"'";
	sql = "UPDATE LeftMenuInfo SET customName='"+customMenuName+"'"+sqltemp+" ,baseTarget='"+targetframe+"' WHERE id="+menuID+"";
	rs.executeSql(sql);
	sql = "UPDATE LeftMenuConfig SET viewIndex="+customMenuViewIndex+",customName='"+customMenuName+"' WHERE infoId="+menuID+" AND userId="+userid+"";
	rs.executeSql(sql);

//Delete Menu
}else if(operationType.equals("del")){
	int menuID = Util.getIntValue(request.getParameter("menuID"),0);
	sql = "DELETE FROM LeftMenuConfig WHERE infoId="+menuID+"";
	rs.executeSql(sql);
	sql = "DELETE FROM LeftMenuConfig WHERE infoId IN (SELECT id FROM LeftMenuInfo WHERE parentId="+menuID+")";
	rs.executeSql(sql);
	sql = "DELETE FROM LeftMenuInfo WHERE id="+menuID+" OR parentId="+menuID+"";
	rs.executeSql(sql);
}

response.sendRedirect("LeftMenuConfig.jsp?saved=true");
%>
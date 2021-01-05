
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LeftMenuConfigHandler" class="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" scope="page"/>
<%
int parentID = Util.getIntValue(request.getParameter("id"),-1);

String s = "";
s = parentID==115 ? recursionRemindInfo() : recursion(parentID,user);
%>

<%!
String recursion(int pid,weaver.hrm.User u){
	boolean hasSubMenu = false;
	String temp = "";
	String sql = "SELECT a.* FROM LeftMenuInfo a,LeftMenuConfig b WHERE "+LeftMenuConfigHandler.getConfigWhere(user)+" AND a.id=b.infoid AND a.parentId="+pid+" AND b.visible='1' ORDER BY b.viewIndex";	
	//System.out.println(sql);
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();
	rs.executeSql(sql);
	while(rs.next()){
		if(rs.getInt("relatedModuleId")==11) continue;

		sql = "SELECT id FROM LeftMenuInfo WHERE parentId="+rs.getInt("id")+" ORDER BY defaultIndex";
		rs2.executeSql(sql);
		if(rs2.next()) hasSubMenu=true;
		
		if(rs.getInt("menuLevel")==3){
			temp += rs.getString("useCustomName").equals("1") ? "['<img src=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\">','"+rs.getString("customName")+"','"+rs.getString("linkAddress")+"','mainFrame','"+rs.getString("customName")+"'" : "['<img src=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\">','"+SystemEnv.getHtmlLabelName(rs.getInt("labelid"),u.getLanguage())+"','"+rs.getString("linkAddress")+"','mainFrame','"+SystemEnv.getHtmlLabelName(rs.getInt("labelid"),u.getLanguage())+"'" ;
		}else{
			temp += rs.getString("useCustomName").equals("1") ? "['<img src=\""+rs.getString("iconUrl")+"\">','"+rs.getString("customName")+"','"+rs.getString("linkAddress")+"','mainFrame','"+rs.getString("customName")+"'" : "['<img src=\""+rs.getString("iconUrl")+"\">','"+SystemEnv.getHtmlLabelName(rs.getInt("labelid"),u.getLanguage())+"','"+rs.getString("linkAddress")+"','mainFrame','"+SystemEnv.getHtmlLabelName(rs.getInt("labelid"),u.getLanguage())+"'";
		}
		if(hasSubMenu){
			temp += ","+recursion(rs.getInt("id"),u);
		}
		temp += "],";
	}
	if(temp.endsWith(",")){
		return temp.substring(0,temp.length()-1);
	}else{
		return temp;
	}
}

//for xwj流程提醒信息
String recursionRemindInfo(){
	String temp = "";
	String sql = "select a.type, a.count, a.statistic, b.typedescription, b.link from SysPoppupRemindInfo a, SysPoppupInfo b where a.type = b.type";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	rs.executeSql(sql);
	while(rs.next()){
		if(rs.getString("statistic").equals("y"))
			temp += "['<img src=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\">','"+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"("+rs.getInt("count")+")','"+rs.getString("link")+"','mainFrame','"+rs.getString("typedescription")+"'],";
		else
			temp += "['<img src=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\">','"+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"','"+rs.getString("link")+"','mainFrame','"+rs.getString("typedescription")+"'],";
	}
	if(temp.endsWith(",")){
		return temp.substring(0,temp.length()-1);
	}else{
		return temp;
	}
}
%>
<html>
<link rel="stylesheet" href="/LeftMenu/ThemeXP/theme_wev8.css" type="text/css">
<script language="JavaScript" src="/js/JSCookTree_wev8.js"></script>
<script language="JavaScript" src="/LeftMenu/ThemeXP/theme_wev8.js"></script>
<style>a{text-decoration:none}</style>
<SCRIPT LANGUAGE="JavaScript"><!--
var myMenu =
[
    <%=s%>
];
--></SCRIPT>
<body style="font-family:MS Shell Dlg;font-size:12px;margin:3px 0 0 10px" oncontextmenu="javascript:return false;">
<DIV ID=myMenuID></DIV>
</body>
</html>
<script  language="javascript">
ctDraw('myMenuID', myMenu, ctThemeXP1, 'ThemeXP', 0, 0);
<%if(!s.equals("")){%>
ctExpandTree('myMenuID',1);
<%}%>
</script>


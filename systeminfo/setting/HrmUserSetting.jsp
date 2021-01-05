
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17627,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String id =userSetting.getId(String.valueOf(userid));

HrmUserSettingHandler handler = new HrmUserSettingHandler();
HrmUserSetting setting = handler.getSetting(user.getUID());
boolean rtxload = setting.isRtxOnload();
String isload = "0";
if(rtxload){
	isload = "1";
}

if(id.equals("")){
	RecordSet.execute("insert into HrmUserSetting(resourceid,rtxOnload,isCoworkHead,skin,cutoverWay,transitionTime,transitionWay) values("+userid+","+isload+",1,'','','','')");
	userSetting.removeHrmUserSettingComInfoCache();
	userSetting=new HrmUserSettingComInfo();
	id =userSetting.getId(String.valueOf(userid));
}	


String rtxOnload=userSetting.getRrxOnload(id);
String isCoworkHead=userSetting.getIsCoworkHead(id);
cutoverWay = userSetting.getCutoverWay(id);
transitionTime = userSetting.getTransitionTime(id);
transitionWay = userSetting.getTransitionWays(id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/systeminfo/setting/HrmUserSettingEdit.jsp?id="+id+",_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>'></wea:group>
			  <td><%=SystemEnv.getHtmlLabelName(17628,user.getLanguage())%></td>
			  <td class=Field>
				<input type="checkbox" name=rtxOnload  value="1" <% if(rtxOnload.equals("1")) {%>checked<%}%> disabled>
			  </td>
			
  </body>
</html>

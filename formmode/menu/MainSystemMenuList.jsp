
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
//列表-主菜单
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17597,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

MainMenuHandler mainMenuHandler = new MainMenuHandler();
ArrayList systemLevelMainMenuInfos = mainMenuHandler.getSystemLevelMainMenuInfos(userid);

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

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CustomSetting.jsp,_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;

  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">

		<TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">



		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(17597,user.getLanguage())%></TH><!-- 主菜单 -->
		</TR>

		<TR class=Line>
			<TD colSpan=3></TD>
		</TR>

	

			<%
				for(int i=0;i<systemLevelMainMenuInfos.size();i++){
					MainMenuInfo info = (MainMenuInfo)systemLevelMainMenuInfos.get(i);
					if(info.getId()==1 || info.getId()==10) continue;
					int id = info.getId();
					int labelId = info.getLabelId();

					if((i%2)==1){
					%>
		<TR class=DataDark>
			<TD><a href="MainMenuConfig.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%></a></TD>
		</TR>
			<%
					}
					else {
			%>
		<TR class=DataLight>	
			<TD><a href="MainMenuConfig.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%></a></TD>
		</TR>
			<%
					}
				}
			%>
			
		</TABLE>
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
    
  </body>
</html>

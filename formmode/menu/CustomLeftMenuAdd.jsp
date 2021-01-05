
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
//自定义界面-左侧菜单-自定义菜单
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int menuID = Util.getIntValue(request.getParameter("id"));
int userid=0;
userid=user.getUID();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;//保存
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",LeftMenuConfig.jsp,_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomLeftMenuOperation.jsp">
	<input name="operationType" type="hidden" value="add"/>
	<input name="parentID" type="hidden" value="<%=menuID%>"/>
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
				
				
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="20%">
		<COL width="80%">
		
		<TBODY>
		
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH><!-- 基本信息 -->
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td><!-- 菜单名称 -->
				  <td class=Field><INPUT class=InputStyle maxLength=50  name="customMenuName" value="" onchange="checkinput('customMenuName','Nameimage')">
				  <SPAN id=Nameimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>

				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(81913, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %></td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=200 style="width:80%" name="customMenuLink" value="" onchange="checkinput('customMenuLink','linkImage')">
					<SPAN id=linkImage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
				  </td>
				</tr>

				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td><!-- 排序 -->
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=50  name="customMenuCViewIndex" value="">
					
					
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td><!-- 打开位置 -->
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=20  name="targetframe" value="">  <font color=red>(<%=SystemEnv.getHtmlLabelName(20236,user.getLanguage())%>)</font><!-- 如果需要在新窗口中显示"超级链接"所在网页,请输入任意英文字符串(除mainFrame) -->
					
					
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
		
		</TBODY>
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
    </FORM>


</body>

<script LANGUAGE="JavaScript">

function checkSubmit(){
	if(check_form(frmMain,'customMenuName,customMenuLink')){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		frmMain.submit();
	}
}

function doCheck_form(){
	return check_form(frmMain,'customMenuName');
}

function doCheck_Input(){
	checkinput("customMenuCName","Nameimage");
}

</script>

</html>


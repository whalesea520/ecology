
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LeftMenuConfigHandler" class="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" scope="page"/>
<%
int menuID = Util.getIntValue(request.getParameter("id"));
String edit = Util.null2String(request.getParameter("edit"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
//自定义界面-左侧菜单-自定义菜单分类
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18772,user.getLanguage());
if(edit.equals("sub")){
	//自定义界面-左侧菜单-自定义菜单
	titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
}
String needfav ="1";
String needhelp ="";    


int userid=0;
userid=user.getUID();
String targetFrame="";
String linkAddress="",customName="";
int viewIndex = 0;
String sql = "select a.linkAddress,a.customName,b.viewIndex,a.baseTarget from LeftMenuInfo a,LeftMenuConfig b WHERE a.id="+menuID+" AND a.id=b.infoid AND "+LeftMenuConfigHandler.getConfigWhere(user);
rs.executeSql(sql);
if(rs.next()){
	linkAddress = rs.getString("linkAddress");
	customName = rs.getString("customName");
	viewIndex = rs.getInt("viewIndex");
	targetFrame=rs.getString("baseTarget");
}
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",LeftMenuConfig.jsp,_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomLeftMenuOperation.jsp">
<input name="operationType" type="hidden" value="edit"/>
<input type="hidden" name="menuID" value="<%=menuID%>"/>
<input type="hidden" name="edit" value="<%=edit%>"/>
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
		
<!--================================================================================-->		
<TABLE class=ViewForm>
<COLGROUP>
<COL width="20%">
<COL width="80%">
<TBODY>
<TR class=Title><TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR><!-- 基本信息 -->
<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>			 
<tr>
	<%if(edit.equals("sub")){%>
	<td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td><!-- 菜单名称 -->
	<%}else{%>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
	<%}%>
	<td class=Field>
		<INPUT class=InputStyle maxLength=50 style=""  name="customMenuName" value="<%=customName%>" onchange="checkinput('customMenuName','Nameimage')">
		<SPAN id=Nameimage></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<%if(edit.equals("sub")){%>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(81913, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %></td>
	<td class=Field>
		<INPUT class=InputStyle maxLength=200 style="width:80%"  name="customMenuLink" value="<%=linkAddress%>"  onchange="checkinput('customMenuLink','linkImage')">
		<SPAN id=linkImage></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<%}%>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td><!-- 排序 -->
	<td class=Field><INPUT class=InputStyle maxLength=50  name="customMenuCViewIndex" value="<%=viewIndex%>"></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td><!-- 打开位置 -->
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=20  name="targetframe" value="<%=targetFrame%>"> <font color=red>(<%=SystemEnv.getHtmlLabelName(20236,user.getLanguage())%>)</font><!-- 如果需要在新窗口中显示"超级链接"所在网页,请输入任意英文字符串(除mainFrame) -->
					
					
				  </td>
				</tr>
<TR><TD class=Line colSpan=2></TD></TR>
</TBODY>
</TABLE>
<!--================================================================================-->		
		
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
function deleteMenu(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){//您确定删除此记录吗？
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "CustomLeftMenuOperation.jsp?operationType=del&menuID=<%=menuID%>";
	}	
}

function checkSubmit(){
	if(check_form(frmMain,'customMenuName,customMenuLink')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}

function doCheck_form(){
	if(check_form(frmMain,'customMenuName')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}

function doCheck_Input(){
	checkinput("customMenuCName","Nameimage");
}

</script>

</html>


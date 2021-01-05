
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int infoId = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),0);
String edit = Util.null2String(request.getParameter("edit"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
//左侧菜单维护-自定义菜单分类
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18772,user.getLanguage());
if(edit.equals("sub")){//左侧菜单维护-自定义菜单
	titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
}
String needfav ="1";
String needhelp ="";


int userid=0;
userid=user.getUID();

String linkAddress="",customName="",iconUrl="";
int viewIndex = 0;

LeftMenuConfigHandler configHandler = new LeftMenuConfigHandler();

LeftMenuConfig leftMenuConfig = configHandler.getLeftMenuConfig(resourceId,resourceType,infoId);
String targetFrame="";
if(leftMenuConfig!=null){
	linkAddress = leftMenuConfig.getLeftMenuInfo().getLinkAddress();
	customName = leftMenuConfig.getName(user);
	viewIndex = leftMenuConfig.getViewIndex();
	iconUrl = leftMenuConfig.getLeftMenuInfo().getIconUrl();
	targetFrame= leftMenuConfig.getLeftMenuInfo().getTargetBase();
	if(leftMenuConfig.getLeftMenuInfo().getIsAdvance()==1)//高级模式菜单
		response.sendRedirect("LeftMenuMaintenanceEditAdvanced.jsp?id="+infoId+"&resourceId="+resourceId+"&resourceType="+resourceType+"&edit="+edit+"&sync="+sync);
	
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(this),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LeftMenuMaintenanceOperation.jsp">
<input name="method" type="hidden" value="edit"/>
<input type="hidden" name="infoId" value="<%=infoId%>"/>
<input type="hidden" name="resourceId" value="<%=resourceId%>"/>
<input type="hidden" name="resourceType" value="<%=resourceType%>"/>
<input name="sync" type="hidden" value="<%=sync%>"/>

<%-- 图标 --%>
<INPUT name="customIconUrl" type="hidden" value="<%=iconUrl%>">

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
<TR class=Title><TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR><!--  基本信息  -->
<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>			 
<tr>
	<%if(edit.equals("sub")){%>
	<td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td><!-- 菜单名称 -->
	<%}else{%>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
	<%}%>
	<td class=Field>
		<INPUT class=InputStyle maxLength=50 style="" name="customMenuName" value="<%=customName%>" onchange="checkinput('customMenuName','Nameimage')">
		<SPAN id=Nameimage></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<%if(edit.equals("sub")){%>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(81913, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %></td>
	<td class=Field>
		<INPUT class=InputStyle maxLength=200 style="width:80%" name="customMenuLink" value="<%=linkAddress%>"  onchange="checkinput('customMenuLink','linkImage')">
		<SPAN id=linkImage></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td><!-- 打开位置 -->
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=20  name="targetframe" value="<%=targetFrame%>"> <font color=red>(<%=SystemEnv.getHtmlLabelName(20236,user.getLanguage())%>)</font><!-- 如果需要在新窗口中显示"超级链接"所在网页,请输入任意英文字符串(除mainFrame) -->
					
					
				  </td>
				</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<%}%>

<%-- 
<tr>
  <td><%=SystemEnv.getHtmlLabelName(19063,user.getLanguage())%></td>
  <td class=Field>
	<INPUT class=InputStyle maxLength=200 style="width:80%" name="customIconUrl" value="<%=iconUrl%>"  onchange="checkinput('customIconUrl','iconUrlImage')">
	<SPAN id=iconUrlImage></SPAN>
  </td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
--%>

<tr>
	<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td><!-- 排序 -->
	<td class=Field><INPUT class=InputStyle maxLength=50  name="customMenuViewIndex" value="<%=viewIndex%>"></td>
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
function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){//您确定删除此记录吗？
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

function checkSubmit(obj){
	if(check_form(frmMain,'customMenuName,customMenuLink,customIconUrl')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function doCheck_form(obj){
	if(check_form(frmMain,'customMenuName,customIconUrl')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function onBack(obj){
	location.href="LeftMenuMaintenanceList.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
	obj.disabled=true;
}

</script>

</html>


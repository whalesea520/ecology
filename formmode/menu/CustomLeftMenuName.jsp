
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<%
int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),1);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(resourceType.equalsIgnoreCase("3"))//自定义界面-左侧菜单-自定义名称
	titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
else {//左侧菜单维护-自定义名称
	titlename += SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
}
String needfav ="1";
String needhelp ="";    

LeftMenuConfigHandler configHandler = new LeftMenuConfigHandler();
LeftMenuConfig leftMenuConfig = configHandler.getLeftMenuConfig(resourceId,resourceType,id);
LeftMenuInfo info = leftMenuConfig.getLeftMenuInfo();

int labelId = info.getLabelId();
String infoCustomName = Util.null2String(info.getCustomName());
String isCustomMenu = Util.null2String(info.getIsCustom());

boolean useCustomName = leftMenuConfig.isUseCustomName();
String customName = Util.null2String(leftMenuConfig.getName(user));

if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if("1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if("2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
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

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomLeftMenuNameOperation.jsp" onsubmit='return doCheck_form()'>
		<input type=hidden name=id value=<%=id%>>
		<input type=hidden name=resourceId value=<%=resourceId%>>
		<input type=hidden name=resourceType value=<%=resourceType%>>
		<input type=hidden name=sync value=<%=sync%>>
		
		
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
		<COL width="30%">
		<COL width="*">
		
		<TBODY>
		
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17608,user.getLanguage())%></TH><!-- 菜单名称自定义 -->
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(17609,user.getLanguage())%></td><!-- 菜单系统默认名称 -->
				  <td class=Field>
					<%if(isCustomMenu.equals("2")){%>
					<%=infoCustomName%>
					<%}else if(isCustomMenu.equals("1")){%>
					<%=customName%>
					<%}else{%>
					<%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(17610,user.getLanguage())%></td><!-- 菜单自定义名称 -->
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=50  name="customName"  onchange='doCheck_Input()' value="<%=customName%>">
					<SPAN id=Nameimage><%if(useCustomName&&customName.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
					
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(17611,user.getLanguage())%></td><!-- 是否使用自定义名称 -->
				  <td class=Field>
                  <%if(useCustomName){%>
                    <input type="checkbox" name=useCustom  value="1" onclick='doCheck_Input()' checked>
                  <%}
                    else{%>
					<input type="checkbox" name=useCustom  value="1" onclick='doCheck_Input()'>
                  <%}%>
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

	if(frmMain.useCustom.checked){
		if(check_form(frmMain,'customName')){
			frmMain.submit();
		}
	}
	else{
		frmMain.submit();
	}
}

function doCheck_form(){
	if(frmMain.useCustom.checked){
		return check_form(frmMain,'customName');
	}
	else{
		return true;
	}
}

function doCheck_Input(){
	if(frmMain.useCustom.checked){
		checkinput("customName","Nameimage");
	}
	else{
		document.all("Nameimage").innerHTML='';
	}
}

function onBack(){
<% if(resourceType.equalsIgnoreCase("3")){ %>
	location.href="LeftMenuConfig.jsp";
<% } else { %>
	location.href="LeftMenuMaintenanceList.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
<% } %>
}
</script>

</html>


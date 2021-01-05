
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>  
  <%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
  	String closeDialog = Util.null2String(request.getParameter("closeDialog"));
  	String menustyletype = Util.null2String(request.getParameter("menustyletype"));
%>


<body>
	<div id="divTemplate" title="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%>">
		<form id="menuStyleForm" name="menuStyleForm" method="post" action="StyleOprate.jsp">
		<input type="hidden" id="method" name="method" value="addFromTemplate"/>
		<input type="hidden" id="pageUrl" name="pageUrl"/>
		<table class="ViewForm">
			<tr>
				<td class="FieldTitle"><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></td>
				<td class="Field"><input type="text" id="menustylename" name="menustylename" onchange='checkinput("menustylename","menustylenamespan");this.value=trim(this.value)'/>
				<SPAN id=menustylenamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
                </td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
          	<tr>
				<td class="FieldTitle"><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%></td>
				<td class="Field"><input type="text" id="menustyledesc" name="menustylesesc"/></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
          	<tr>
				<td class="FieldTitle"><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></td>
				<td class="Field">
				<select id="type" name="type" onchange="changestyletype(this.value);">
					<%if("element".equals(menustyletype)) {%>
						<option value="element"><%=SystemEnv.getHtmlLabelName(22913,user.getLanguage())%></option>
					<%}else {%>
						<option value="menuh"><%=SystemEnv.getHtmlLabelName(23013,user.getLanguage())%></option>
						<option value="menuv"><%=SystemEnv.getHtmlLabelName(23014,user.getLanguage())%></option>
					<%} %>						
				</select></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
          	<tr>
				<td class="FieldTitle"><%=SystemEnv.getHtmlLabelName(27825,user.getLanguage())%></td>
				<td class="Field">
				<select id="menustylecite" name="menustylecite">
				<% 
				esc.setTofirstRow();						
				while(esc.next()){//元素样式
					out.println("<option value='"+esc.getId()+"' "+("template".equals(esc.getId())?"selected":"")+">"+Util.toHtml5(esc.getTitle())+"</option>");
				}
				%>
				</select>
				</td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
        </table>
		
	</div>
	<div id="div_Msg" title="<%=SystemEnv.getHtmlLabelName(24860,user.getLanguage())%>">
	</div>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--
	
function onSave(){//保存
	if(check_form(document.menuStyleForm,"menustylename")){
		jQuery("#pageUrl").val("MenuStyleList.jsp");
		document.menuStyleForm.submit();
		enableAllmenu();
	}
}

function saveNew(){//保存并进入详细设置
	if(check_form(document.menuStyleForm,"menustylename")){
		document.menuStyleForm.submit();
		enableAllmenu();
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery(document).ready(function (){
	var closeDialog = "<%=closeDialog%>";
	if(closeDialog=="close"){
		onCancel();
		var parentWin = parent.getParentWindow(window); 
		parentWin.location.reload();
	}
})
//-->
</SCRIPT>
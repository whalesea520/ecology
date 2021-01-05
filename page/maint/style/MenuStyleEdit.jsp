
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<html>
  <head>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	
  </head>  
  <%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
  	String titlename = "";
  	String closeDialog= Util.null2String(request.getParameter("closeDialog"));
  	String type= Util.null2String(request.getParameter("type"));
  	String operate= Util.null2String(request.getParameter("operate"));
  	String styleid= Util.null2String(request.getParameter("styleid"));
  	String navName="";
  	if(type.equals("element")){
  		navName = SystemEnv.getHtmlLabelName(22913,user.getLanguage());
  	}else{
  		navName = SystemEnv.getHtmlLabelName(22916,user.getLanguage());
  	}
%>


<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=navName%>"/> 
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="saveAndEdit();">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd();">
						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			
			
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:saveAndEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div id="divTemplate" title="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%>">
		<form id="menuStyleForm" name="menuStyleForm" method="post" action="StyleOprate.jsp">
		<input type="hidden" id="method" name="method" value="addFromTemplate"/>
		<input type="hidden" id="operate" name="operate" value="saveNew"/>
		<input type="hidden" id="pageUrl" name="pageUrl"/>
		<%if("saveNew".equals(operate)&&!"".equals(styleid)){ %>
			<input type="hidden" id="type" name="type" value="<%=type %>"/>
			<input type="hidden" id="styleid" name="styleid" value="<%=styleid %>"/>
		<%}else if("element".equals(type)){ %>
			<input type="hidden" id="type" name="type" value="<%=type %>"/>
		<%} %>
		
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="menustylenamespan" required="true" >
         <input type="text" id="menustylename" name="menustylename" onchange='checkinput("menustylename","menustylenamespan")'/>
        
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%></wea:item>
      <wea:item>
         <input type="text" id="menustyledesc" name="menustyledesc"/>
      </wea:item>
      <%if(!"element".equals(type)&&!"saveNew".equals(operate)) {%>
      <wea:item><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></wea:item>
      <wea:item>
        <select id="type" name="type" onchange="changestyletype(this.value);">
			<option value="menuh" <%="menuh".equals(type)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23013,user.getLanguage())%></option>
			<option value="menuv" <%="menuv".equals(type)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23014,user.getLanguage())%></option>
		</select>
      </wea:item>
      <%} 
      if("".equals(operate)){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(27825,user.getLanguage())%></wea:item>
      <wea:item>
	  	<select id="menustylecite" name="menustylecite">
	  	<%
	  	    rs.execute("select * from hpMenuStyle where menustyletype='"+type+"'");
					while (rs.next())
					{
						String tempStyleid = rs.getString("styleid");
						String tempStylename = Util.toHtml5(rs.getString("menustylename"));
						
					%>
					<option value="<%=tempStyleid%>" ><%=tempStylename%></option>
					<%
						}
					%>
		
		</select>
	  </wea:item>
      <%} %>
     </wea:group>
</wea:layout>		
		
	</div>
	<div id="div_Msg" title="<%=SystemEnv.getHtmlLabelName(24860,user.getLanguage())%>">
	</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
</html>
<!--For zDialog-->
<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT LANGUAGE="JavaScript">
<!--
var operate="<%=operate%>";
var type = "<%=type%>";
	function changestyletype(type){
		jQuery("#menustylecite").empty();
		jQuery.post("MenuStyleOprate.jsp?operate=changetype&type="+type,function(data){
			$("#menustylecite").append(data);			 
		});
	}
	
	function onAdd(){
		if(check_form(document.menuStyleForm,'menustylename')){
			if(operate=="saveNew")menuStyleForm.action="/page/maint/style/MenuStyleOprate.jsp";
			jQuery("#pageUrl").val("/page/maint/style/MenuStyleEdit.jsp");
			menuStyleForm.submit();
		}
	}

	function saveAndEdit(){
		if(check_form(document.menuStyleForm,'menustylename')){
			jQuery("#pageUrl").val("/page/maint/style/MenuStyleEdit.jsp");
			if(operate=="saveNew")menuStyleForm.action="/page/maint/style/MenuStyleOprate.jsp";				
			menuStyleForm.submit();
		}
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
	
	function onEdit(styleid){
		var type = "<%=type%>";
		var url="/page/maint/style/";
		if("element"==type){		
			url+="ElementStyleEdit.jsp";
		} else if("menuh"==type){
			url+="MenuStyleEditH.jsp";
		} else if("menuv"==type){
			url+="MenuStyleEditV.jsp";
		}
		url+="?type="+type+"&styleid="+styleid;
		var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>";
		showDialog(title,url,800,500,true);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
	$(document).ready(function(){	
		resizeDialog(document);
		var closeDialog = "<%=closeDialog%>";
		if(closeDialog=="close"){
			if("<%=operate%>"=="saveNew")
				onEdit("<%=styleid%>");
			var parentWin = parent.getParentWindow(window); 
			parentWin.location.reload();
			onCancel();
			
		}
	});
//-->
</SCRIPT>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
String theme =Util.null2o(request.getParameter("theme"));	
String message = Util.null2String(request.getParameter("message"));
String closeDialog = Util.null2String(request.getParameter("closeDialog"));

String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onAdd(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32935,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

</head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32935,user.getLanguage()) %>" class="e8_btn_top" onclick="dosubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="/weaver/weaver.page.maint.theme.CheckThemeTemplateServlet">
	<input type="hidden"   name="theme" value="<%=theme %>">	
	<div class="zDialog_div_content">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
      <wea:item><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></wea:item>
      <wea:item>
        <wea:required id="themespan" required="true">
         <input type="file"  class="inputstyle" name="theme" id="theme" style="width:95%" onchange="checkinput('theme','themespan')">
         </wea:required>
      </wea:item>
     </wea:group>
</wea:layout>		
	</div>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	

</body>
</html>
<script>
	var parentWin = null;
	var dialog = null;
	try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
	}catch(e){}
	function dosubmit(){
		if(check_form(frmAdd,'theme')){
			if(checkFileName()){
				frmAdd.submit();
			}
		}
	}
	
	function onCancel(){
		dialog.close();
	}

	$(document).ready(function(){
		if('<%=message%>'=='ERROR'){
			alert("<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
			//window.location.href = "LayoutList.jsp"
		}
		if("<%=closeDialog%>"=="close"){	
					
			top.getDialog(parent).currentWindow.document.location.reload();
		
			onCancel();
		}
	});
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("theme").value;
		if(fileName!=''){
			fileName=fileName.toLowerCase();   
			var lens=fileName.length;   
			var extname=fileName.substring(lens-4,lens);   
			if(extname!=".zip")   
			{   
			  alert("<%=SystemEnv.getHtmlLabelName(23942,user.getLanguage())%>");  
			  return false;
			} 
			if(/.*[\u4e00-\u9fa5]+.*$/.test(fileName.substr(fileName.lastIndexOf('\\')+1))){
		    	 alert("<%=SystemEnv.getHtmlLabelName(23984,user.getLanguage())%>");  
		    	return false;
		    }
		    
		    return true; 
	    }else{
	    	return true;
	    } 
	}
</script>


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
String type =Util.null2o(request.getParameter("type"));
String message =Util.null2o(request.getParameter("message"));	
String closeDialog = Util.null2String(request.getParameter("closeDialog"));

String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());
String navName="";
if(type.equals("element")){
	navName =  SystemEnv.getHtmlLabelName(22913,user.getLanguage());
}else{
	navName = SystemEnv.getHtmlLabelName(22916,user.getLanguage());
}

%>
<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

</head>

<body  id="myBody">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=navName %>"/> 
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="dosubmit()">						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="/weaver/weaver.page.style.StyleImpServlet">
	<input type="hidden"   name="type" value="<%=type %>"/>	
	<div class="zDialog_div_content">
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.xml)<!--文件--></wea:item>
      <wea:item>
        <wea:required id="stylefilespan" required="true">
         <input type="file"  class="inputstyle" name="stylefile" id="stylefile" style="width:95%" onchange="checkinput('stylefile','stylefilespan')">
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
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

</body>
</html>
<script>
	function dosubmit(){
		if(check_form(frmAdd,'stylefile')){
			if(checkFileName()){
				frmAdd.submit();
			}
		}
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}

	$(document).ready(function(){
		if('<%=message%>'=='ERROR'){
			alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>")
			//window.location.href = "LayoutList.jsp"
		}
		if("<%=closeDialog%>"=="close"){			
			var parentWin = parent.getParentWindow(window);
			parentWin.location.reload();
			onCancel();
		}
	});
	
	//判断文件后缀名是否为.xml文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("stylefile").value;
		if(fileName!=''){
			fileName=fileName.toLowerCase();   
			var lens=fileName.length;   
			var extname=fileName.substring(lens-4,lens);   
			if(extname!=".xml")   
			{   
			  top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84145,user.getLanguage())%>");  
			  return false;
			} 
			if(/.*[\u4e00-\u9fa5]+.*$/.test(fileName.substr(fileName.lastIndexOf('\\')+1))){
		    	Dialog.alert("<%=SystemEnv.getHtmlLabelName(23984,user.getLanguage())%>");  
		    	return false;
		    }
		    
		    return true; 
	    }else{
	    	return true;
	    } 
	}
</script>

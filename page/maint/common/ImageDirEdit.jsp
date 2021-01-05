
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30986,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<html>
<head>
<script src="/js/weaver_wev8.js" type="text/javascript"></script>
<script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body  id="myBody">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32467,user.getLanguage())%>"/>
</jsp:include>	

<% 
	//文件夹处理
	String file = Util.null2String(request.getParameter("file"));
	String currentDir = Util.null2String(request.getParameter("currentDir"));
	String method = Util.null2String(request.getParameter("method"));
	//图片重命名
	String imgname = Util.null2String(request.getParameter("imgname"));
	//处理状态
	String closeDialog = Util.null2String(request.getParameter("closeDialog"));
	String status = Util.null2String(request.getParameter("status"));
	String imgtype = "";
	String showname = file;
	String dirname = Util.null2String(request.getParameter("dirname"));
	if(!"".equals(imgname)){
		showname = imgname;
	}else if(!"".equals(dirname)){
		showname = dirname;
	}
	if(showname.indexOf(".")!=-1){
		imgtype=showname.substring(showname.lastIndexOf(".")+1);
		showname = showname.substring(0,showname.lastIndexOf("."));
	}
%>
	<form id="dirFrom" name="dirFrom" action="/weaver/weaver.page.maint.common.CustomResourceServlet" method="post">
	        <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="dosubmit();" />
				&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
			
		</tr>
	</table>
		<input type = hidden  id = "method" name ="method" value = "<%=method %>">
		<input type = hidden  id = "currentDir" name ="currentDir" value = "<%=currentDir %>">
	<div class="zDialog_div_content">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></wea:item>
     <wea:item>
     	<input id="dirname" name="dirname" type=text maxlength='100' size="60" value="<%=showname %>" onChange="checkinput('dirname','dirnameSpan')"> 
		<span id=dirnameSpan name=dirnameSpan><%="".equals(showname)?"<IMG src='/images/BacoError_wev8.gif' align=absMiddle>":"" %></span>
		<span id="dir_status"></span>
	</wea:item>
	</wea:group>
</wea:layout>

	</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onCancel();">
<!--		    	<span class="e8_sep_line">|</span>-->
<!--		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">-->
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
</body>
<script type="text/javascript">
	/**
	 * 判断文件名是否合法
	 * @param {} name
	 * @return {Boolean}
	 */
	function checkFileName(name,type) {
	    if(name.indexOf(' ')!=-1) {
	        alert("<%=SystemEnv.getHtmlLabelName(84079,user.getLanguage())%>");
	        return false;
	    }
	   	if(type=='dir'){
	   		if(name.length>100){
	   			alert();
	   		}
		    if(!name.toLowerCase().match(/^[a-z0-9A-Z_\-]{1,256}$/)) {
		        alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
		        return false;
		    }
	   	}else{
	   		 if(!name.toLowerCase().match(/^[a-z0-9A-Z_\-]{1,256}$/)) {
		       alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
		        return false;
		    }
	   	}
		return true;
	}
	
function dosubmit(){
    //附件上传
	var imgtype= "<%=imgtype%>";
	var dname = jQuery("#dirname").val();
    if(check_form(document.dirFrom,'dirname')&&checkFileName(dname,(imgtype!=""?'':'dir'))){
    	if(imgtype!=""&&dname.indexOf(imgtype)>0){
    		alert("<%=SystemEnv.getHtmlLabelName(129597,user.getLanguage())%>");
    		return;
    	}
    	//if(imgtype!=""&&dname.substring(0,dname.indexOf(imgtype)-1)==""){
		if(dname.indexOf(".")>=0){
			alert("<%=SystemEnv.getHtmlLabelName(84083,user.getLanguage())%>");
			return ;
		}
        if(imgtype!=""&&dname==""){
    		alert("<%=SystemEnv.getHtmlLabelName(84085,user.getLanguage())%>");
    		return;
    	}
    	dirFrom.submit();
    }
}

function onCancel(){
	var dialog = top.getDialog(window);
	try{
		dialog.close();
	}catch(e){}
}

jQuery(document).ready(function (){
	var closeDialog = "<%=closeDialog%>";
	var status = "<%=status%>";
	var file = "<%=file%>";

	if(status!=""&&status=="ERROR")
		jQuery("#dir_status").html("<%=SystemEnv.getHtmlLabelName(84086,user.getLanguage())%>");
	if(closeDialog=="close"){
		var parentWin = parent.getParentWindow(window);
		var topURL = top.getDialog(window).URL;
		var dir = topURL.substring(topURL.indexOf("currentDir=")+11,topURL.indexOf("&imgname="));
		dir = dir.substring(0,dir.indexOf("/"));
		if("image"!=dir){
			dir += "/";
		}
		var url = "/page/maint/common/CustomResourceList.jsp?dir="+dir+"&isDialog=";
		if(file!=""){
			 url = "/page/maint/common/CustomResourceLeft.jsp?date="+new Date().getTime();
			
		}
		parentWin.location.href=url;
		onCancel();
	}
	document.onkeydown = function(e){
		var ev = document.all ? window.event : e;
		if(ev.keyCode==13) {
			return false;
		}
	}
})
</script>
</HTML>

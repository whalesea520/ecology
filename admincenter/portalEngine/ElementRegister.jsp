
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String titlename  = "";
%>
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>
  <body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<FORM id="frmMain" name="frmMain" action="/admincenter/portalEngine/ElementRegisterUpload.jsp" enctype="multipart/form-data" method="post">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+",javascript:doElReg();',_self} " ;
	RCMenuHeight += RCMenuHeightStep ;	
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%>" class="e8_btn_top"
						onclick="doElReg()" />
				&nbsp;&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv"></div>

	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33833,user.getLanguage())%>' ><!-- 填写注册信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33837,user.getLanguage())%></wea:item><!-- 元素文件包 -->
			<wea:item>
        		<input class=InputStyle type=file size=50 name="filename" id="filename" />
			</wea:item>
	    </wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15736,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 注意事项 -->
			<wea:item>
				<p>1、<%=SystemEnv.getHtmlLabelName(33834,user.getLanguage())%></p><!-- 上传的元素文件包扩展名必须为.zip -->
				<p>2、<%=SystemEnv.getHtmlLabelName(33835,user.getLanguage())%></p><!-- 元素名称不得与元素库中已有元素名称相同 -->
				<p>3、<%=SystemEnv.getHtmlLabelName(33836,user.getLanguage())%></p><!-- 可用范围必须至少选择一个 -->
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>	
  </body>
</html>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onSearch});	
	jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	jQuery("#tabDiv").remove();
});

function doElReg(){
	var filename = jQuery("#filename").val();
	
	if(filename==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33837,18019", user.getLanguage())%>");
		return;
	}else{
		try{
			var filenameArray = filename.split(".");
			var _str = filenameArray[filenameArray.length-1];
			if(_str.toUpperCase()!="ZIP"){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33834", user.getLanguage())%>");
				return;
			}
		}catch(e){}
	}

	frmMain.submit();
}
	
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String target = Util.null2String(request.getParameter("target"));

String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>

<%
	//查询版本设置表
	
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="SocialManagerOperation.jsp" name="weaver">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="当前版本信息">
		<wea:item>当前版本号</wea:item>
		<wea:item>
				<span id="curVersionNum_span">3.7.1</span>
		</wea:item>
		<wea:item>当前客户端访问URL</wea:item>
		<wea:item>
				<span id="curOAURL_span">http://www.e-cology.com.cn/</span>
		</wea:item>
	</wea:group>
	<wea:group context="发布新版本">
		<wea:item>版本号</wea:item>
		<wea:item>
				<input name="newVersionNum" id="newVersionNum" value="" maxlength="50" style="width :180px" onchange="checkint('newVersionNum');checkinput('newVersionNum', 'newVersionNum_span')"  class="InputStyle">
				<span id="newVersionNum_span"></span>
				<span style="color: red">该项不填写程序将自动从文件名解析，请不要修改客户端包的文件名</span>
		</wea:item>
		<wea:item>客户文件</wea:item>
		<wea:item>
				<input name="crmDoc" id="crmDoc" type="file" value="" maxlength="50" style="width :480px" class="InputStyle">
				<br><input type="submit" class="InputStyle" value="发布" style="width: 60px;background:#30b5ff;color:#FFF;">
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">

	function saveInfo(){
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		jQuery.post("SocialManagerOperation.jsp?method=basesetting1",{'settings': JSON.stringify(jQuery("form").serializeArray())},function(isSuccess){
		 	if(jQuery.trim(isSuccess) == 1){
		 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 	}
		 	refreshCurPage();
		 });
	}
	
	function validateValue(obj) {
		if(parseInt($(obj).val()) > 500){
			$(obj).val('');
		}
	}
	
	function refreshCurPage(){
		window.location.href=window.location.href;
	}
</script>


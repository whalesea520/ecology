<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%@page import="weaver.general.*"%>
<html>
<%
String titlename  = "";
%>
<head>
<title>KB问题对应接口</title>
<script type="text/javascript" src="/js/jquery_wev8.js"></script>
<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
});
function execute() {
	$.ajax({
		url : "executeOperation.jsp",
		type : "post",
		dataType : "json",
		success:function(data) {
			var res = data.status;
			if(res == "success") {
				top.Dialog.alert("执行完成。");
			} else {
				var errormsg = data.errormsg;
				top.Dialog.alert(errormsg+" 执行失败。执行中止。");
			}
			window.location.reload();
		}
	});
}
function edit() {
	window.location.href="edit.jsp";
}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="KB问题对应接口" />
</jsp:include>
<%
OrderProperties prop = new OrderProperties();
String propfile = GCONST.getRootPath()+"WEB-INF"+File.separator+"prop"+File.separator+"SolveKBQuestion.properties";
List<String> classes = new ArrayList<String>();

prop.load(propfile);

String execStatus = Util.null2String(prop.getProperty("execStatus"));
String status = "";
if("1".equals(execStatus)) {
	status = "已执行";
} else {
	status = "未执行";
	RCMenu += "{"+"开始执行"+",javascript:execute(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+"编辑"+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body style="height:100%;width:100%;">

<form>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="编辑" class="e8_btn_top" onclick="edit()"/>
			<%if(!"1".equals(execStatus)) { %>
			<input type="button" value="开始执行" class="e8_btn_top" onclick="execute()"/>
			<%} %>
		</td>
	</tr>
</table>
<wea:layout>
	<wea:group context="执行状态">
	<wea:item>执行状态</wea:item>
	<wea:item><%=status %><span style="color:red">(*如果状态为“已执行”，想再次执行，请点击“编辑”进行设置)</span></wea:item>
	</wea:group>
	<wea:group context="执行类">
<%
List<String> keys = prop.getKeys();
int no = 1;
for(int i= 0; i < keys.size(); i++) {
	String key = keys.get(i);
	String val = Util.null2String(prop.getProperty(key));
	if("".equals(val)||"execStatus".equals(key)) {
		continue;
	}
%>
	<wea:item><%=(no++) %></wea:item>
	<wea:item><%=val %></wea:item>
<%} %>	  	  
	</wea:group>

</wea:layout>
</form>
</body>
</html>
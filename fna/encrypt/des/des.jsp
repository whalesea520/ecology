<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.workflow.request.RequestManager"%>
<%@page import="weaver.soa.workflow.request.RequestInfo"%>
<%@page import="weaver.soa.workflow.request.RequestService"%>
<%@page import="weaver.cpt.job.CptLowInventoryRemindJob"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.systeminfo.language.LanguageComInfo"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>

<%@ page import="weaver.general.Util" %>
<% 
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<HTML><HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script language="javascript" src="/fna/js/e8Common_wev8.js?r=7"></script>
	<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
	
	<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
	
	<script type="text/javascript">
	function getResult(){
		//待加密字符串
		var str = document.getElementById("str").value;
		//第一个参数必须；第二个、第三个参数可选
		var key1 = "<%=Des.KEY1 %>";  
		var key2 = "<%=Des.KEY2 %>";
		var key3 = "<%=Des.KEY3 %>";
		//加密方法		
		var  enResult = strEnc(str,key1,key2,key3);			
		//解密方法
		var deResult = strDec(enResult,key1,key2,key3);
		//展示结果
		document.getElementById("enStr").innerText = enResult; 
		document.getElementById("dnStr").innerText = deResult; 
	}
	</script>
</head>

<BODY>
	加密前文字：<br />
	<textarea id="str" rows="50" cols="200"></textarea><br />
	<input type="button" value="获取加密结果与解密结果" onclick="getResult()" /><br />
	密文：
	<div id="enStr"></div>
	解密后明文：
	<div id="dnStr"></div>
</BODY>
</HTML>
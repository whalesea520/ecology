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
		//�������ַ���
		var str = document.getElementById("str").value;
		//��һ���������룻�ڶ�����������������ѡ
		var key1 = "<%=Des.KEY1 %>";  
		var key2 = "<%=Des.KEY2 %>";
		var key3 = "<%=Des.KEY3 %>";
		//���ܷ���		
		var  enResult = strEnc(str,key1,key2,key3);			
		//���ܷ���
		var deResult = strDec(enResult,key1,key2,key3);
		//չʾ���
		document.getElementById("enStr").innerText = enResult; 
		document.getElementById("dnStr").innerText = deResult; 
	}
	</script>
</head>

<BODY>
	����ǰ���֣�<br />
	<textarea id="str" rows="50" cols="200"></textarea><br />
	<input type="button" value="��ȡ���ܽ������ܽ��" onclick="getResult()" /><br />
	���ģ�
	<div id="enStr"></div>
	���ܺ����ģ�
	<div id="dnStr"></div>
</BODY>
</HTML>
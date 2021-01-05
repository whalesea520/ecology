<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
	               
String needfav ="1";
String needhelp ="";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>



<BODY id="flowbody" ><%--Modified by xwj for td3247 20051201--%>
<%@ include file="RequestTopTitle.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82821,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(103,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doEdit()">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<br/>

	<div id="advancedSearchDiv">
		<wea:layout type="3col" attributes="{'expandAllGroup':'true'}">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(28610, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	 <input type="text" style='width:200px' onkeypress="EnterPress()" id="requestid" name="requestid"  />
		    	</wea:item>
		    </wea:group>
		   </wea:layout>
		</div>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+",javascript:doEdit();,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script>
	function doEdit(){
		var requestid = jQuery('#requestid').val();
		openFullWindowHaveBarForWFList('/workflow/request/EditFormIframe.jsp?requestid='+requestid,requestid);
	}

	function EnterPress(e){ 
		var e = e || window.event; 
		if(e.keyCode == 13){ 
			doEdit();
		} 
	} 

			
</script>

</BODY>

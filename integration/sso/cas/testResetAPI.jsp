<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.interfaces.sso.cas.CASRestAPI" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<SCRIPT language="javascript" src="../../../js/weaver_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">

</head>
<%
	if(!HrmUserVarify.checkUserRight("CAS:ALL",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String appuname = Util.null2String(request.getParameter("appuname"));
	String apppwd = Util.null2String(request.getParameter("apppwd"));
	
	//System.out.println(">>>>>"+appuname);//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
	//System.out.println(">>>>>"+apppwd);//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
	
	String ticket = "";
	String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
	if(appuname != "" && apppwd != ""){
		ticket = Util.null2String(new CASRestAPI().getInstance().getTicket(appuname, apppwd));
		//System.out.println(ticket);//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
	}
%>
<script language=javascript>
	<%
	if(appuname != "" && apppwd != ""){
		if(ticket!=""){ %>
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32297 ,user.getLanguage())%>!');
		<%}else{%>
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32296 ,user.getLanguage())%>!');
		<%}
	}%>
</script>
</head>
<BODY scroll="no">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25496,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit()"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM id=weaver name=frmMain action="testResetAPI.jsp" method=post >
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(128656 ,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(2072 ,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<wea:required id="appunamespan" required="true" value="<%=appuname %>">
		  		<input class="inputstyle" type="text" style='width:280px!important;' id="appuname" value="<%=appuname %>" name="appuname" onChange="checkinput('appuname','appunamespan');" onblur="isExist(this.value)">
		  	</wea:required>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(409 ,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<wea:required id="apppwdspan" required="true" value="<%=apppwd %>">
		  		<input class="inputstyle" type="password" style='width:280px!important;' id="apppwd" value="<%=apppwd %>" name="apppwd" onChange="checkinput('apppwd','apppwdspan');" onblur="isExist(this.value)">
		  	</wea:required>
		  </wea:item>
		</wea:group>
	</wea:layout>
	</FORM>
<script language="javascript">
	jQuery(document).ready(function () {
		$("#topTitle").topMenuTitle();
	});
	function onSubmit(){
		var checkvalue = "appuname,apppwd";
	    if(check_form(frmMain,checkvalue)){
			    frmMain.submit();
	    }
	}
</script>

</body>
</html>
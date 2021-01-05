
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(32189 ,user.getLanguage());
String needhelp ="";

if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:blogExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="searchexport" style="display:none"></iframe>

<HTML>
<head>
<script type="text/javascript">


function blogExport(){
	if(check_form(weaver,"fromdate,enddate")){
	
		if($G("fromdate").value>$G("enddate").value) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>") ;
		}else if($G("department").value==""&&$G("subdepartment").value==""&&$G("userid").value==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>");
		}else{
			var info = $("#weaver").serialize();
			$("#searchexport").attr("src","blogExportOperation.jsp?"+info);
		}
	}
}


</script>

</head>
  
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32189,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="blogExport()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name="weaver" action="blogExport.jsp" method=post>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32189,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
        <wea:item>
        	<brow:browser viewType="0" name="department" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="80%" ></brow:browser> 
        </wea:item>
       
        <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
        <wea:item>
        	<brow:browser viewType="0" name="subdepartment" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=164" width="80%" ></brow:browser> 
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></wea:item>
        <wea:item>
        	<brow:browser viewType="0" name="userid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="80%" ></brow:browser> 
        </wea:item>
         
        <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
        <wea:item>
			  <BUTTON type="button" class=calendar id=SelectDate onclick=onShowDate(fromdatespan,fromdate)></BUTTON>&nbsp;
			  <SPAN id=fromdatespan >
			  	<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
			  </SPAN>
			  <input type="hidden" name="fromdate" id="fromdate" >
			  －<BUTTON type="button" class=calendar id=SelectDate onclick=onShowDate(enddatespan,enddate)></BUTTON>&nbsp;
			  <SPAN id=enddatespan >
			  	<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
			  </SPAN>
			  <input type="hidden" name="enddate" id="enddate" >
		  </wea:item>
		
		</wea:group>
	</wea:layout>
</FORM>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>

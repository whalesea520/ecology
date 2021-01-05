<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
<FORM id=frmain name=frmain method=post target="mainFrame">
    <tr class=Header> 
      <th height = 30><%=SystemEnv.getHtmlLabelName(6060,user.getLanguage())%> >>&nbsp;&nbsp;&nbsp;
	  <%=SystemEnv.getHtmlLabelName(15089,user.getLanguage())%>：
	  <BUTTON class=Browser id=SelectResourceid onClick="onShowHrmID(Resourceidspan,AccountManager)"></BUTTON>
		  <span id=Resourceidspan></span> 
          <INPUT class=saveHistory type=hidden name="AccountManager">	  
	  </th>
    </tr>
</FORM>
</table>
<script language=vbs>
sub onShowHrmID(getSpan,getInput)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?underling=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	getSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	getInput.value=id(0)
	frmain.action="/CRM/search/SearchOperation.jsp"
	frmain.submit()
	else 
	getSpan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	getInput.value=""
	end if
	end if
end sub
</script>
</body>
</html>
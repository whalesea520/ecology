<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16641,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2212">
<base target="mainFrame">
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">

</head>

<body>
<table width="146" border="0" cellspacing="0" cellpadding="0" height="100%" >
  <tr> 
    <td width="146" background="/images_frame/left_bg1_wev8.gif" valign="top"><BR> 
	<BR> <BR> <BR>

	
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr > 
          <td width="22" height="27" ><img src="/images_frame/icon_home_wev8.gif"></td>
          <td width="75" align="center"><a 
		  <%if(!logintype.equals("2")){%>
				href="/system/HomePage.jsp" 
		  <%}else{%>
				href="/docs/news/NewsDsp.jsp"
		  <%}%>
		  class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%></a></td>
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>

	<%if(logintype.equals("2")){%>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
		<tr > 
		  <td width="22" height="27" ><img src="/images_frame/icon_resource_wev8.gif"></td>
		  <td width="75" align="center"><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=user.getUID()%>" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(16650,user.getLanguage())%></a></td>
		  <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
		</tr>
		</table>
	<%}%>

      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">

        <tr> 
          <td width="22" height="27"><img src="/images_frame/icon_request_wev8.gif"></td>
          <td width="75" align="center"><a href="/workflow/request/RequestView.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>

      </table>


      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><a href="/workflow/request/RequestType.jsp?needPopupNewPage=true"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>" src="/images_frame/icon_request1_wev8.gif" border="0"></a></td>
          <td width="75" align="center"><a href="/workflow/request/MyRequestView.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></a></td>
          
          <td ><a href="/workflow/search/WFSearch.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
        </tr>

      </table>
<%if(!logintype.equals("2")){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><a href="/hrm/resource/HrmResourceAdd.jsp"   target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>" src="/images_frame/icon_resource_wev8.gif" border="0"></a></td>
          <td width="75" align="center"><a href="/hrm/search/HrmMyResource.jsp" class="zlm"   target="mainFrame"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></td>
          
          <td ><a href="/hrm/search/HrmResourceSearch.jsp"   target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
        </tr>

      </table>
<%}%>
<%if( software.equals("ALL") || software.equals("CRM") ){%>
	<%if(Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2") ){%>	
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
			<tr> 
			  <td width="22" height="27"><a href="/CRM/data/AddCustomerExist.jsp"   target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>" src="/images_frame/icon_account_wev8.gif" border="0"></a></td>
			  <td width="75" align="center"><a href="/CRM/search/CRMCategory.jsp" class="zlm"   target="mainFrame"><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></a></td>
			  
			  <td ><a href="/CRM/search/SearchSimple.jsp"   target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
			</tr>

		  </table>
	<%}%>
<%}%>
<%if( software.equals("ALL") || software.equals("CRM") ){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><%if(!logintype.equals("2")){%><a href="/proj/data/AddProject.jsp"  target="mainFrame"><%}%><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>" src="/images_frame/icon_project_wev8.gif" border="0"><%if(!logintype.equals("2")){%></a><%}%></td>
          <td width="75" align="center"><%if(!logintype.equals("2")){%><a href="/proj/search/ProjCategory.jsp" class="zlm"  target="mainFrame"><%}else{%><a href="/proj/search/SearchOperation.jsp" class="zlm"  target="mainFrame"><%}%><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></a></td>
          
          <td ><a href="/proj/search/Search.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
        </tr>
      </table>
<%}%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><a href="/docs/docs/DocList.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>" src="/images_frame/icon_document_wev8.gif" border="0"></a></td>
          <td width="75" align="center"><a href="/docs/search/DocView.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></a></td>
          
          <td ><a href="/docs/search/DocSearch.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
        </tr>

      </table>
<%if(software.equals("ALL") || software.equals("HRM") ){%>
	<%if(!logintype.equals("2")){%>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
			<tr> 
			  <td width="22" height="27"><a href="/cpt/capital/CptCapitalAdd.jsp"   target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>" src="/images_frame/icon_item_wev8.gif" border="0"></a></td>
			  <td width="75" align="center"><a href="/cpt/search/CptMyCapital.jsp?addorsub=3" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1209,user.getLanguage())%></a></td>
			  
			  <td ><a href="/cpt/search/CptSearch.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
			</tr>

		  </table>
	<%}%>
<%}%>
<%if(!software.equals("ALL")){%>
	<%if(!logintype.equals("2")){%>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
			<tr> 
			  <td width="22" height="27"><img src="/images_frame/icon_reportforms_wev8.gif" border="0"></td>
			  <td width="75" align="center"><a href="/report/Report.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(6015,user.getLanguage())%></a></td>
			  
			  <td ><img src="/images_frame/search_dot1_wev8.gif" border="0"></td>
			</tr>

		  </table>
	<%}%>
<%}%>
<%if(!logintype.equals("2")){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><img src="/images_frame/icon_plant_wev8.gif" border="0"></td>
          <td width="75" align="center"><a href="/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/search_dot1_wev8.gif" border="0"></td>
        </tr>
      </table>
<%}%>

<%if(!logintype.equals("2")){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><a href="/meeting/data/AddMeeting.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>" src="/images_frame/icon_meeting_wev8.gif" border="0"></a></td>
          <td width="75" align="center"><a href="/meeting/search/MeetingCategory.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(2102,user.getLanguage())%></a></td>
          
          <td ><a href="/meeting/search/Search.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></a></td>
        </tr>

      </table>
<%}%>

<%if(!logintype.equals("2")){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><img src="/images_frame/icon_email_wev8.gif" border="0"></td>
          <td width="75" align="center"><a href="/email/WeavermailLogin.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%></a></td>
          <!--td width="75"><a href="http://www.d-long.com:7500" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%></a></td !-->
          
          <td ><img src="/images_frame/search_dot1_wev8.gif" border="0"></td>
        </tr>

      </table>
<%}%>
<%if(!software.equals("ALL")){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="22" height="27"><img alt="<%=SystemEnv.getHtmlLabelName(16686,user.getLanguage())%>" src="/images_frame/icon_item_wev8.gif" border="0"></td>
          <td width="75" align="center"><a href="/system/maintenance.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(16686,user.getLanguage())%></a></td>
          
          <td ><img alt="<%=SystemEnv.getHtmlLabelName(16686,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"></td>
        </tr>

      </table>
<%}%>

      <BR>
      <table cellspacing=0 border=0 cellpadding=0 width=100%>
        <tbody> 
        <tr> 
          <td width=82 height=22></td>
          <td width=17><a href="/docs/search/DocSearchTemp.jsp?docstatus=1&list=all"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(1214,user.getLanguage())%>" src="/images_frame/icon_recent_wev8.gif" border=0></a></td>
          
          <td width=17><a href="/docs/search/DocSummary.jsp"  target="mainFrame"><img alt="<%=SystemEnv.getHtmlLabelName(1215,user.getLanguage())%>" src="/images_frame/icon_category_wev8.gif" border=0></a></td>
          <td width=22></td>
        </tr>
        </tbody> 
      </table>
	  <table cellspacing=0 border=0 cellpadding=0 width=100%>
        <tbody> 
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
        <tr> 
	    <td width="100">
	    </td>
		</tr>
        </tbody> 
		</table>
	  <br>
    </td>

  </tr>
 
</table>
</body>
</html>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
DocRpManage.setOptional("doctypelist") ;
DocRpManage.getRpResult("","") ;
%>
<TABLE class=ViewForm width=65%>
  <TBODY>
  <TR class=Title>
    <TH width="20%"><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    <TD width="5%"><B><IMG src="/images/BacoCheck_wev8.gif"></B></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%></TD>
    <TD width="5%"><b><img src="/images/guide_wev8.gif" width="13" height="13"></b></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%></TD>
    <TD width="5%"><B><IMG src="/images/BacoCross_wev8.gif"></B></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%></TD>
  <TR class=Spacing>
    <TD class=Line1 colSpan=7></TD></TR></TBODY></TABLE>
<TABLE class=ListStyle>
  <TBODY>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
    <TD align=middle><%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></TD>
	<TD align=middle><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></TD>
  </TR>
  <%    while(DocRpManage.next())  { 
		  int id = DocRpManage.getDocTypeID();
		  String typename = DocRpManage.getTypeName();
		  String hasitems = DocRpManage.getHasItems();
		  String hasitemmaincategory = DocRpManage.getHasItemMainCategory();
		  String hashrmres = DocRpManage.getHasHrmRes();
		  String hascrm = DocRpManage.getHasCrm();
		  String hasproject = DocRpManage.getHasProject();
		  String hasfinance = DocRpManage.getHasFinance();
		  String hasaccessory = DocRpManage.getHasAccessory();
	%>
  <TR class=DataLight>
    <TD><A 
      href="/docs/type/DocTypeEdit.jsp?id=<%=id%>"><%=typename%></A></TD>
    <TD align=middle><%if(hasitems.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hasitems.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hasitemmaincategory.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hasitemmaincategory.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hashrmres.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hashrmres.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hascrm.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hascrm.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hasproject.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hasproject.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hasfinance.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else if(hasfinance.equals("1")){%> <img src="/images/guide_wev8.gif" width="13" height="13">
					<%} else {%><IMG src="/images/BacoCheck_wev8.gif"> <%}%>
	</TD>
	<TD align=middle><%if(hasaccessory.equals("0")){%><IMG src="/images/BacoCross_wev8.gif">
					<%} else {%> <img src="/images/guide_wev8.gif" width="13" height="13"> <%}%>
	</TD></tr>
	<%} DocRpManage.closeStatement();%>
    </TBODY></TABLE><BR></BODY></HTML>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<%
int docid = Util.getIntValue(Util.null2o(request.getParameter("docid")));


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19461,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<BODY>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="doc"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19461,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
	 String tabletype="none";
String sqlWhere = "maindoc = " + docid + " and (isHistory<>'1'or isHistory is null or isHistory='') and docstatus in (1,2,5)  and id<> "+docid;
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_DOCREADLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCREADLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocDetail\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col pkey=\"currsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_blank\" width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"docSubject\"  orderkey=\"docSubject\"/>"+
			 "<col pkey=\"fromdir\" width=\"30%\"  column=\"seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\" text=\""+SystemEnv.getHtmlLabelName(16398,user.getLanguage())+"\"/>"+
			 "<col pkey=\"username\" width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2094,user.getLanguage())+"\" column=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>"+
			 "<col pkey=\"currmodifydate\" width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"docLastModDate\"/>"+
	   "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCREADLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>     
</BODY></HTML>

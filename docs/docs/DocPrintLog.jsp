
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%



int perpage=Util.getPerpageLog();
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21533,user.getLanguage());
String needfav ="1";
String needhelp ="";
int docId = Util.getIntValue(request.getParameter("docid"),0);

String sqlWhere = " where printDocId="+docId;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
        <%
                String backfields = "id,printUserId,printDocId,printDate,printTime,printNum,clientAddress";
                String fromSql  = " from DocPrintLog";
                String orderby = "printDate,printTime" ;
                String tableString = "";
                tableString =" <table instanceid=\"docPrintLogTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                             "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                             "			<head>"+
                             "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"printUserId\"   transmethod=\"weaver.splitepage.transform.SptmForDoc.getHrmname\" />"+
                             "				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"printDocId\"   transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\" />"+
                             "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"printDate\"  />"+
                             "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\" column=\"printTime\"  />"+
                             "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(20219,user.getLanguage())+"\" column=\"printNum\" />"+
                             "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage())+"\" column=\"clientAddress\" />"+
                             "			</head>"+
                             "</table>";
             %>
             <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

    </BODY></HTML>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

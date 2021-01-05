<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "客户信息";
String needfav ="1";
String needhelp ="";

String hrmid_1 = Util.null2String(request.getParameter("hrmid_1"));
String hrmid_2 = Util.null2String(request.getParameter("hrmid_2"));
String hrmid_3 = Util.null2String(request.getParameter("hrmid_3"));
String hrmid_4 = Util.null2String(request.getParameter("hrmid_4"));
String status = "";
String hrmid = "";

if(!"".equals(hrmid_1)) {
   status = "1";
   hrmid = hrmid_1;
}
if(!"".equals(hrmid_2)) {
   status = "2";
   hrmid = hrmid_2;
}
if(!"".equals(hrmid_3)) {
   status = "3";
   hrmid = hrmid_3;
}
if(!"".equals(hrmid_4)) {
   status = "4";
   hrmid = hrmid_4;
}

String whereclause = " where status="+status+" and manager="+hrmid;
if("4".equals(status)) {
   String datestr = TimeUtil.getCurrentDateString();
   String sqlwhere = " and createdate like '%"+datestr.substring(0,7)+"%'";
   whereclause = " where id in (select distinct crmid from WorkPlan where crmid in (select id from CRM_CustomerInfo where manager = "+hrmid+") "+sqlwhere+") and manager="+hrmid;
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
		<br>
		<%
		String language = String.valueOf(user.getLanguage());
		String backFields = " name,id ";
		String sqlFrom = " CRM_CustomerInfo ";
		
		//out.println(backFields + sqlFrom + whereclause);
		String tableString=""+
			  "<table  pagesize=\"20\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"20%\" text=\"客户名称\" column=\"name\" orderkey=\"name\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" href=\"/CRM/data/ViewCustomer.jsp\"  target=\"_fullwindow\"/>"+
					  "<col width=\"10%\" text=\"联系人\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.crm.SptmForCrmModiRecord.getContacteranme\" />"+
					  "<col width=\"70%\" text=\"联系内容\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.crm.SptmForCrmModiRecord.getContacterContent\" />"+
			  "</head>"+
			  "</table>";
		%>
		<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
		</form>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>
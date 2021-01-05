<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(585,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<%
String customerid=Util.null2String(request.getParameter("customerid"));
String customername=CustomerInfoComInfo.getCustomerInfoname(customerid);

RecordSet.executeProc("CRM_LedgerInfo_SelectAll",customerid);
int totalledger=RecordSet.getCounts();
boolean canadd=HrmUserVarify.checkUserRight("CustomerLedgerAdd:Add", user);
%>
<div style="display:none">
<%if(totalledger<2&&canadd){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnNew type="button" accesskey="N" id=myfun1  onclick="location='CustomerLedgerAdd.jsp?customerid=<%=customerid%>'">
<U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<%}%>
</div>
<table class=ListStyle cellspacing=1>
  <colgroup>
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <tr class=header><th colspan=5><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></th></tr>
<TR class=Line><TD colSpan=5></TD></TR>
<%if(totalledger==0){%>
  <tr class=Title><td colspan=5><%=customername%><%=SystemEnv.getHtmlLabelName(1269,user.getLanguage())%></td></tr>
<%} else {%>
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1266,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1267,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%>1</td>
  <td><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%>2</td>
  <tr>
<%
	boolean islight=true;
	while(RecordSet.next()){
		String customercode=RecordSet.getString("customercode");
		String tradetype=RecordSet.getString("tradetype");
		String ledger1=RecordSet.getString("ledger1");
		String ledger2=RecordSet.getString("ledger2");
		
		String tradetypename="";
		if(tradetype.equals("1"))	tradetypename=SystemEnv.getHtmlLabelName(745,user.getLanguage());
		if(tradetype.equals("2"))	tradetypename=SystemEnv.getHtmlLabelName(746,user.getLanguage());
		String ledgername1=LedgerComInfo.getLedgermark(ledger1)+"-"+LedgerComInfo.getLedgername(ledger1);
		String ledgername2=LedgerComInfo.getLedgermark(ledger2)+"-"+LedgerComInfo.getLedgername(ledger2);
%>
	<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	  <td><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid%>"><%=Util.toScreen(customername,user.getLanguage())%></a></td>
	  <td><a href="CustomerLedgerEdit.jsp?customerid=<%=customerid%>&tradetype=<%=tradetype%>"><%=Util.toScreen(customercode,user.getLanguage())%></a></td>
	  <td><%=tradetypename%></td>
	  <td><%=Util.toScreen(ledgername1,user.getLanguage())%></td>
	  <td><%=Util.toScreen(ledgername2,user.getLanguage())%></td>
	</tr>
<%
	islight=!islight;
	}
}
%>
</table>
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
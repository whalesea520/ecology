<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FnaAutoLedger" class="weaver.fna.maintenance.FnaAutoLedger" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String customerid=Util.fromScreen(request.getParameter("customerid"),user.getLanguage());
String customercode=Util.fromScreen(request.getParameter("customercode"),user.getLanguage());
String tradetype=Util.fromScreen(request.getParameter("tradetype"),user.getLanguage());
String status="";
String ledger1="";
String ledger2="";

char flag = Util.getSeparator() ;
String Procpara="";

String customername=CustomerInfoComInfo.getCustomerInfoname(customerid);

if(operation.equals("add")){
	RecordSet.executeProc("CRM_LedgerInfo_SelectAll",customerid);
	int totalledger=RecordSet.getCounts();
	boolean canadd=HrmUserVarify.checkUserRight("CustomerLedgerAdd:Add", user);
	if(totalledger>=2||!canadd){
		response.sendRedirect("/notice/noright.jsp");
	    	return;
	}
	RecordSet.executeProc("CRM_LedgerInfo_Select",customerid+flag+tradetype);
	if(RecordSet.next()){
		status="1";
	}
	else{
		FnaAutoLedger.InsertCrmLedger(customername , tradetype , customercode) ;
		status = "" + FnaAutoLedger.getStatus() ;
		ledger1= "" + FnaAutoLedger.getLedgerid1() ;
		ledger2= "" + FnaAutoLedger.getLedgerid2() ;
	}
	if(status.equals("0")){
		Procpara=customerid+flag+customercode+flag+tradetype+flag+ledger1+flag+ledger2;
		RecordSet.executeProc("CRM_LedgerInfo_Insert",Procpara);
		response.sendRedirect("CustomerLedgerList.jsp?customerid="+customerid);	
		return;
	}
}
if(operation.equals("save")){
	String oldcode="";
	String oldtradetype="";
	RecordSet.executeProc("CRM_LedgerInfo_Select",customerid+flag+tradetype);
	if(RecordSet.next()){
		oldcode=RecordSet.getString("customercode");
		oldtradetype=RecordSet.getString("tradetype");
	}
	boolean canedit=HrmUserVarify.checkUserRight("CustomerLedgerEdit:Edit", user);
	if(!oldtradetype.equals(tradetype)||!canedit){
		response.sendRedirect("/notice/noright.jsp");
	    	return;
	}
	if(oldcode.equals(customercode)){
		response.sendRedirect("CustomerLedgerList.jsp?customerid="+customerid);	
		return;
	}
	FnaAutoLedger.UpdateCrmLedger(oldcode , customercode , tradetype) ;
	status = "" + FnaAutoLedger.getStatus() ;
	if(status.equals("0")){
		Procpara=customerid+flag+customercode+flag+tradetype;
		RecordSet.executeProc("CRM_LedgerInfo_Update",Procpara);
		response.sendRedirect("CustomerLedgerList.jsp?customerid="+customerid);	
		return;
	}
}
if(operation.equals("delete")){
	String oldcode="";
	String oldtradetype="";
	RecordSet.executeProc("CRM_LedgerInfo_Select",customerid+flag+tradetype);
	if(RecordSet.next()){
		oldcode=RecordSet.getString("customercode");
		oldtradetype=RecordSet.getString("tradetype");
	}
	boolean canedit=HrmUserVarify.checkUserRight("CustomerLedgerEdit:Edit", user);
	if(!canedit){
		response.sendRedirect("/notice/noright.jsp");
	    	return;
	}
	FnaAutoLedger.DeleteCrmLedger(oldcode , oldtradetype) ;
	status = "" + FnaAutoLedger.getStatus() ;
	if(status.equals("0")){
		Procpara=customerid+flag+oldtradetype;
		RecordSet.executeProc("CRM_LedgerInfo_Delete",Procpara);
		response.sendRedirect("CustomerLedgerList.jsp?customerid="+customerid);	
		return;
	}
}
String statusdesc="";
if(status.equals("1"))	statusdesc="Same RecordInfo exist, can not insert or update";
if(status.equals("2"))	statusdesc="tradeinfo exist can not edit or delete";
if(status.equals("-1"))	statusdesc="system error";
%>
<font color=red><%=Util.toScreen(statusdesc,user.getLanguage())%>
</font><input type=button name=button2 value="back" onClick="javascript:history.go(-1)">
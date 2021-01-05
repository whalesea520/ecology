<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addledger")){
     
  	String ledgermark = Util.fromScreen(request.getParameter("ledgermark"),user.getLanguage());
	String ledgername = Util.fromScreen(request.getParameter("ledgername"),user.getLanguage());
	String ledgertype = Util.null2String(request.getParameter("ledgertype"));
	String ledgergroup = Util.null2String(request.getParameter("ledgergroup"));
	String ledgerbalance = Util.null2String(request.getParameter("ledgerbalance"));
	String autosubledger = Util.null2String(request.getParameter("autosubledger"));
	String ledgercurrency = Util.null2String(request.getParameter("ledgercurrency"));
	String supledgerid = Util.null2String(request.getParameter("supledgerid"));
	String categoryid = Util.null2String(request.getParameter("categoryid"));
	String supledgerstr = Util.null2String(request.getParameter("supledgerstr"));


	String para = ledgermark + separator + ledgername + separator + ledgertype + separator + ledgergroup
				   + separator + ledgerbalance + separator + autosubledger + separator + ledgercurrency
				   + separator + supledgerid + separator + categoryid + separator + supledgerstr;
	
	RecordSet.executeProc("FnaLedger_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("FnaLedger.jsp?msgid=24");
		return ;
	}

	if(id == -2 || id == -3)  {
		if(supledgerid.equals("0"))
			response.sendRedirect("FnaLedgerAdd.jsp?msgid=12&paraid=category_"+categoryid);
		else 
			response.sendRedirect("FnaLedgerAdd.jsp?msgid=12&paraid=ledger_"+supledgerid+"_"+categoryid);
		return ;
	}

	if(id == -4)  {
		response.sendRedirect("FnaLedger.jsp?msgid=27");
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(ledgermark +"-"+ledgername);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaLedger_Insert,"+para);
	SysMaintenanceLog.setOperateItem("36");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	LedgerComInfo.removeLedgerCache() ;

	response.sendRedirect("FnaLedger.jsp");  
 }
else if(operation.equals("editledger")){
  	int id = Util.getIntValue(request.getParameter("ledgerid"));
	String ledgermark = Util.fromScreen(request.getParameter("ledgermark"),user.getLanguage());
	String ledgername = Util.fromScreen(request.getParameter("ledgername"),user.getLanguage());
	String ledgertype = Util.null2String(request.getParameter("ledgertype"));
	String ledgergroup = Util.null2String(request.getParameter("ledgergroup"));
	String ledgerbalance = Util.null2String(request.getParameter("ledgerbalance"));
	String autosubledger = Util.null2String(request.getParameter("autosubledger"));
	String ledgercurrency = Util.null2String(request.getParameter("ledgercurrency"));
	String initaccount = Util.null2String(request.getParameter("initaccount"));
	String doinit = Util.null2String(request.getParameter("doinit"));
	String categoryid = Util.null2String(request.getParameter("categoryid"));

	String para = ""+id + separator + ledgermark + separator + ledgername + separator + ledgertype +
				  separator + ledgergroup + separator + ledgerbalance + separator + autosubledger + separator + ledgercurrency + separator + initaccount + separator + doinit;
	
	RecordSet.executeProc("FnaLedger_Update",para);

	if(RecordSet.next()) {
		response.sendRedirect("FnaLedgerEdit.jsp?paraid=ledger_"+id+"_"+categoryid+"&msgid=13");
		return ;
	}
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(ledgermark +"-"+ledgername);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaLedger_Update,"+para);
    SysMaintenanceLog.setOperateItem("36");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	LedgerComInfo.removeLedgerCache() ;

	response.sendRedirect("FnaLedger.jsp");
 }
 else if(operation.equals("deleteledger")){
  	int id = Util.getIntValue(request.getParameter("ledgerid"));
	String ledgermark = Util.fromScreen(request.getParameter("ledgermark"),user.getLanguage());
	String ledgername = Util.fromScreen(request.getParameter("ledgername"),user.getLanguage());
	String supledgerid = Util.null2String(request.getParameter("supledgerid"));
	String categoryid = Util.null2String(request.getParameter("categoryid"));
	String para = ""+ id + separator + supledgerid ;
	RecordSet.executeProc("FnaLedger_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("20")){
		response.sendRedirect("FnaLedgerEdit.jsp?paraid=ledger_"+id+"_"+categoryid+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ledgermark +"-"+ledgername);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("FnaLedger_Delete,"+para);
      SysMaintenanceLog.setOperateItem("36");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	LedgerComInfo.removeLedgerCache() ;

	response.sendRedirect("FnaLedger.jsp");
 }
%>

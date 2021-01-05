<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator();
String procedurepara="";

int id=Util.getIntValue(request.getParameter("id"),0);
String bankname=Util.fromScreen(request.getParameter("bankname"),user.getLanguage());
String bankdesc=Util.fromScreen(request.getParameter("bankdesc"),user.getLanguage());
String checkstr=Util.fromScreen(request.getParameter("checkstr"),user.getLanguage());

if(opera.equals("insert")){
	if(!HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=bankname + separator + bankdesc;
	RecordSet.executeProc("HrmBank_Insert",procedurepara);
	RecordSet.next();
	id=RecordSet.getInt(1);
	log.resetParameter();
	log.setRelatedId(id);
    log.setRelatedName(bankname);
    log.setOperateType("1");
    log.setOperateDesc("");
    log.setOperateItem("33");
    log.setOperateUserid(user.getUID());
    log.setClientAddress(request.getRemoteAddr());
    log.setSysLogInfo();
    BankComInfo.removeBankCache();
	response.sendRedirect("HrmBankAdd.jsp?isclose=1&id="+id);
}

if(opera.equals("save")){
	if(!HrmUserVarify.checkUserRight("HrmBankEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=id+"" + separator + bankname + separator + bankdesc;
	RecordSet.executeProc("HrmBank_Update",procedurepara);
	
	log.resetParameter();
	log.setRelatedId(id);
    log.setRelatedName(bankname);
    log.setOperateType("2");
    log.setOperateDesc("");
    log.setOperateItem("33");
    log.setOperateUserid(user.getUID());
    log.setClientAddress(request.getRemoteAddr());
    log.setSysLogInfo();
    BankComInfo.removeBankCache();
	response.sendRedirect("HrmBankEdit.jsp?isclose=1&id="+id);
}

if(opera.equals("delete")){
	if(!HrmUserVarify.checkUserRight("HrmBankEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    RecordSet.executeSql("Select count(id) from hrmresource where bankid1 = " + id );
	RecordSet.last();
    int resourcebankcount = Util.getIntValue(RecordSet.getString(1) , 0) ;
    if( resourcebankcount > 0 ) {
        response.sendRedirect("HrmBankEdit.jsp?id="+id+"&message=fail");
        return ;
    }
    bankname = BankComInfo.getBankname(""+id);
	procedurepara=id+"";
	RecordSet.executeProc("HrmBank_Delete",procedurepara);
	log.resetParameter();
	log.setRelatedId(id);
    log.setRelatedName(bankname);
    log.setOperateType("3");
    log.setOperateDesc("");
    log.setOperateItem("33");
    log.setOperateUserid(user.getUID());
    log.setClientAddress(request.getRemoteAddr());
    log.setSysLogInfo();
    BankComInfo.removeBankCache();
	response.sendRedirect("HrmBankList.jsp");
}
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addcurrencies")|| operation.equals("nextcurrencies")){
  	String currencyname = Util.fromScreen(request.getParameter("currencyname"),user.getLanguage()).toUpperCase();
	String currencydesc = Util.fromScreen(request.getParameter("currencydesc"),user.getLanguage());
	String activable = Util.null2String(request.getParameter("activable"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	if(activable.equals("")) activable ="0" ;
	if(isdefault.equals("")) isdefault ="0" ;
	//名称重复判断 added by wcd 2014-07-02
	String checkSql = "select count(id) from FnaCurrency where currencyname ='"+currencyname+"'";
	RecordSet.executeSql(checkSql);
	if(RecordSet.next()){
		if(RecordSet.getInt(1)>0){
			out.println("<script>");
			out.println("window.top.Dialog.alert('"+SystemEnv.getErrorMsgName(33,user.getLanguage())+"');");
			out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrenciesAdd&isdialog=1';");
			out.println("</script>");
			return;
		}
	}

	String para = currencyname + separator + currencydesc + separator + activable + separator + isdefault ;

	RecordSet.executeProc("FnaCurrency_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1) {
		response.sendRedirect("FnaCurrenciesAdd.jsp?msgid=12");
		return ;
	}
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(currencyname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaCurrency_Insert,"+para);
	SysMaintenanceLog.setOperateItem("39");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CurrencyComInfo.removeCurrencyCache();
	response.sendRedirect("FnaCurrenciesAdd.jsp?id="+id+"&isclose="+(operation.equals("nextcurrencies") ? 2 : 1));
 }
else if(operation.equals("editcurrencies")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String currencyname = Util.fromScreen(request.getParameter("currencyname"), user.getLanguage()).toUpperCase();
	String currencydesc = Util.fromScreen(request.getParameter("currencydesc"),user.getLanguage());
	String activable = Util.null2String(request.getParameter("activable"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	String isdefaultold = Util.null2String(request.getParameter("isdefaultold"));
	//名称重复判断 added by wcd 2014-07-02
	String checkSql = "select count(id) from FnaCurrency where currencyname ='"+currencyname+"' and id != "+id;
	RecordSet.executeSql(checkSql);
	if(RecordSet.next()){
		if(RecordSet.getInt(1)>0){
			out.println("<script>");
			out.println("alert('"+SystemEnv.getErrorMsgName(33,user.getLanguage())+"');");
			out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrenciesEdit&id="+id+"&isdialog=1';");
			out.println("</script>");
			return;
		}
	}
	
	if(activable.equals("")) activable ="0" ;
	if(isdefaultold.equals("1")) isdefault ="1" ;
	String para = ""+id + separator + currencyname + separator + currencydesc +  separator + activable +  separator + isdefault;
	RecordSet.executeProc("FnaCurrency_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaCurrency_Update,"+para);
    SysMaintenanceLog.setOperateItem("39");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("/fna/maintenance/FnaCurrenciesEdit.jsp?id="+id+"&isclose=1");
 }else if(operation.equals("deletecurrencies")){
	int id = Util.getIntValue(request.getParameter("id"));
	RecordSet.executeProc("FnaCurrency_SelectByID",String.valueOf(id));
	RecordSet.next();
	String currencyname = Util.toScreen(RecordSet.getString("currencyname"),user.getLanguage());
	
	RecordSet.executeSql("delete from FnaCurrency where id = "+id);
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("FnaCurrency_Delete");
    SysMaintenanceLog.setOperateItem("39");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("FnaCurrencies.jsp");
 }
 else if(operation.equals("addcurrencyexchange")){
	String defcurrencyid = Util.null2String(request.getParameter("defcurrencyid"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));
	String fnayearperiodsid = fnayear + Util.add0(Util.getIntValue(periodsid),2);
	String avgexchangerate = Util.null2String(request.getParameter("avgexchangerate"));
	String endexchangerage = Util.null2String(request.getParameter("endexchangerage"));

	String para = defcurrencyid + separator + thecurrencyid +  separator + fnayear 
				   + separator + periodsid +  separator + fnayearperiodsid  
				   + separator + avgexchangerate +  separator + endexchangerage ;

	RecordSet.executeProc("FnaCurrencyExchange_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1) {
		response.sendRedirect("FnaCurrencyExchangeAdd.jsp?id="+thecurrencyid+"&msgid=12");
		return ;
	}
	if(id == -2) {
		response.sendRedirect("FnaCurrencyExchangeAdd.jsp?id="+thecurrencyid+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Insert,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("FnaCurrencyExchangeAdd.jsp?isdialog=1&isclose=1&id="+thecurrencyid);
 }

 else if(operation.equals("editcurrencyexchange")){
	int id = Util.getIntValue(request.getParameter("id"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));
	String avgexchangerate = Util.null2String(request.getParameter("avgexchangerate"));
	String endexchangerage = Util.null2String(request.getParameter("endexchangerage"));

	String para = ""+id + separator + avgexchangerate +  separator + endexchangerage 
				   + separator + fnayear +  separator + periodsid ;  

	RecordSet.executeProc("FnaCurrencyExchange_Update",para);
	if(RecordSet.next()) {
		response.sendRedirect("FnaCurrencyExchangeEdit.jsp?id="+id+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Update,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("FnaCurrenciesView.jsp?isclose=1&id="+thecurrencyid);
 }
 
 else if(operation.equals("deletecurrencyexchange")){
	int id = Util.getIntValue(request.getParameter("id"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));
	
	RecordSet.executeSql("select fnayear,periodsid from FnaCurrencyExchange where id="+id);
	if(RecordSet.next()){
		fnayear = Util.null2String(RecordSet.getString("fnayear"));
		periodsid = Util.null2String(RecordSet.getString("periodsid"));
	}

	String para = ""+ id + separator + fnayear +  separator + periodsid ;  

	RecordSet.executeProc("FnaCurrencyExchange_Delete",para);
	if(RecordSet.next()) {
		response.sendRedirect("FnaCurrencyExchangeEdit.jsp?id="+id+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Delete,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("FnaCurrenciesView.jsp?id="+thecurrencyid);
 }

%>
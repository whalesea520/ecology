<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="IndicatorComInfo" class="weaver.fna.maintenance.IndicatorComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("FnaIndicatorEdit:Edit", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;


if(operation.equals("addindicator")){
     
  	String indicatorname = Util.fromScreen(request.getParameter("indicatorname"),user.getLanguage());
	String indicatordesc = Util.fromScreen(request.getParameter("indicatordesc"),user.getLanguage());
	String indicatortype = Util.null2String(request.getParameter("indicatortype"));
	String indicatorbalance = Util.null2String(request.getParameter("indicatorbalance"));
	String haspercent = Util.null2String(request.getParameter("haspercent"));
	String indicatoridfirst = Util.null2String(request.getParameter("indicatoridfirst"));
	String indicatoridlast = Util.null2String(request.getParameter("indicatoridlast"));
	if(indicatortype.equals("2") && haspercent.equals("")) haspercent ="0" ;
	

	String para = indicatorname + separator + indicatordesc + separator + indicatortype + separator + indicatorbalance + separator + haspercent + separator + indicatoridfirst + separator + indicatoridlast;
	
	RecordSet.executeProc("FnaIndicator_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(indicatorname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaIndicator_Insert,"+para);
	SysMaintenanceLog.setOperateItem("42");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	IndicatorComInfo.removeIndicatorCache();
	response.sendRedirect("FnaIndicator.jsp");
 }
else if(operation.equals("editindicator")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String indicatorname = Util.fromScreen(request.getParameter("indicatorname"),user.getLanguage());
	String indicatordesc = Util.fromScreen(request.getParameter("indicatordesc"),user.getLanguage());
	String indicatortype = Util.null2String(request.getParameter("indicatortype"));
	String indicatorbalance = Util.null2String(request.getParameter("indicatorbalance"));
	String haspercent = Util.null2String(request.getParameter("haspercent"));
	String indicatoridfirst = Util.null2String(request.getParameter("indicatoridfirst"));
	String indicatoridlast = Util.null2String(request.getParameter("indicatoridlast"));
	if(indicatortype.equals("2") && haspercent.equals("")) haspercent ="0" ;

	
	String para = ""+id + separator + indicatorname + separator + indicatordesc + separator +  indicatorbalance + separator + haspercent + separator + indicatoridfirst + separator + indicatoridlast;
	
	RecordSet.executeProc("FnaIndicator_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(indicatorname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaIndicator_Update,"+para);
    SysMaintenanceLog.setOperateItem("42");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	IndicatorComInfo.removeIndicatorCache();
 	response.sendRedirect("FnaIndicator.jsp");
 }
 else if(operation.equals("deleteindicator")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String indicatorname = Util.fromScreen(request.getParameter("oldindicatorname"),user.getLanguage());
	String indicatortype = Util.null2String(request.getParameter("indicatortype"));
	String para = ""+id + separator + indicatortype ;

	RecordSet.executeProc("FnaIndicator_Delete",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(indicatorname);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("FnaIndicator_Delete,"+para);
    SysMaintenanceLog.setOperateItem("42");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	IndicatorComInfo.removeIndicatorCache();
 	response.sendRedirect("FnaIndicator.jsp");
 }
 else if(operation.equals("addledger")){
	String ledgerid = Util.null2String(request.getParameter("ledgerid"));
	String indicatorid = Util.null2String(request.getParameter("indicatorid"));
	String para = indicatorid + separator + ledgerid ;

	RecordSet.executeProc("FnaIndicatordetail_Insert",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(indicatorid));
    SysMaintenanceLog.setRelatedName(Util.null2String(IndicatorComInfo.getIndicatorname(indicatorid)));
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaIndicatordetail_Insert,"+para);
    SysMaintenanceLog.setOperateItem("42");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("FnaIndicatorEdit.jsp?id="+indicatorid);
 }
 else if(operation.equals("deleteledger")){
	String id = Util.null2String(request.getParameter("id"));
	String indicatorid = Util.null2String(request.getParameter("indicatorid"));

	RecordSet.executeProc("FnaIndicatordetail_Delete",id);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(indicatorid));
    SysMaintenanceLog.setRelatedName(Util.null2String(IndicatorComInfo.getIndicatorname(indicatorid)));
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaIndicatordetail_Delete,"+id);
    SysMaintenanceLog.setOperateItem("42");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("FnaIndicatorEdit.jsp?id="+indicatorid);
 }

%>

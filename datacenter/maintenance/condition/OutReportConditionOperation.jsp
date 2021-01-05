<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ConditionComInfo" class="weaver.datacenter.ConditionComInfo" scope="page" />


<%
String operation = Util.null2String(request.getParameter("operation"));
String conditionid = Util.null2String(request.getParameter("conditionid"));
String conditionname = Util.fromScreen(request.getParameter("conditionname"),user.getLanguage());
String conditiondesc = Util.fromScreen(request.getParameter("conditiondesc"),user.getLanguage());
String conditionitemfieldname = Util.null2String(request.getParameter("conditionitemfieldname"));
String conditiontype = Util.null2String(request.getParameter("conditiontype"));

int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);


if(operation.equals("add")){
	
    char separator = Util.getSeparator() ;

	String para = conditionname + separator + conditiondesc
		+ separator + conditionitemfieldname + separator + conditiontype  ;

	RecordSet.executeProc("T_Condition_Insert",para);
	
    ConditionComInfo.removeConditionCache() ;
 	response.sendRedirect("OutReportCondition.jsp");
 }
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;

    String para = conditionid + separator + conditionname
		+ separator + conditiondesc + separator + conditionitemfieldname + separator + conditiontype ;

	RecordSet.executeProc("T_Condition_Update",para);
	
    
    if(totaldetail !=0) {
        RecordSet.executeProc("T_ConditionDetail_Delete",conditionid);

        for( int i =0 ; i< totaldetail ; i++) {
            String conditiondsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
            String conditionendsp = Util.fromScreen(request.getParameter("itemendsp"+i),user.getLanguage());
            String conditionvalue = Util.fromScreen(request.getParameter("conditionvalue"+i),user.getLanguage());
//            String conditiondsp = conditionvalue ;

            if(!conditionvalue.equals("") && !conditiondsp.equals("")) {
                para = conditionid + separator + conditiondsp + separator + conditionvalue + separator + conditionendsp ;
                RecordSet.executeProc("T_ConditionDetail_Insert",para);
            }
        }
    }

    ConditionComInfo.removeConditionCache() ;

 	response.sendRedirect("OutReportCondition.jsp");

 }
 else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
	String para = ""+conditionid;
	RecordSet.executeProc("T_Condition_Delete",para);
    RecordSet.executeProc("T_ConditionDetail_Delete",para);

    ConditionComInfo.removeConditionCache() ;
	response.sendRedirect("OutReportCondition.jsp");
 }
%>

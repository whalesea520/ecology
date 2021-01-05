<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FnaDptToKingdeeComInfo" class="weaver.fna.maintenance.FnaDptToKingdeeComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if (!HrmUserVarify.checkUserRight("FnaBudget:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String procedurepara="";
char separator = Util.getSeparator();
RecordSet.executeProc("FnaDptToKingdee_Delete",""); 

while(DepartmentComInfo.next()) {
    String departmentid = DepartmentComInfo.getDepartmentid() ;
    String Kingdeecode=Util.null2String(request.getParameter(departmentid));

    procedurepara= departmentid + separator + Kingdeecode;
    
    RecordSet.executeProc("FnaDptToKingdee_Insert",procedurepara) ;

}

FnaDptToKingdeeComInfo.removeCurrencyCache() ;

response.sendRedirect("/fna/FnaMaintenance.jsp");
%>
 

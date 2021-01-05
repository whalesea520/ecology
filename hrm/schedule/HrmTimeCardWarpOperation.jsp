<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmTimeCardInit" class="weaver.hrm.schedule.HrmTimeCardInit" scope="page"/>

<%
String opera = Util.null2String(request.getParameter("operation")) ; 
char separator = Util.getSeparator() ;
String procedurepara="";
String id = Util.null2String(request.getParameter("id")) ; // 记录id
String fromdate = Util.null2String(request.getParameter("fromdate")) ; // 从
String todate = Util.null2String(request.getParameter("todate")) ; // 到
String resourceidpar = Util.null2String(request.getParameter("resourceid"));
String departmentidpar = Util.null2String(request.getParameter("departmentid"));
String startdate = Util.null2String(request.getParameter("startdate")) ; // 从
String enddate = Util.null2String(request.getParameter("enddate")) ; // 到
String isself = Util.null2String(request.getParameter("isself")) ; 

if( opera.equals("delete")) {  // 删除
    RecordSet.executeProc("HrmRightCardInfo_Delete" , id) ; 
    if(RecordSet.next()) {
        String resourceid = Util.null2String(RecordSet.getString(1)) ;
        String carddate = Util.null2String(RecordSet.getString(2)) ;
        if(!resourceid.equals("") && !carddate.equals("")) {
            HrmTimeCardInit.initTimecardInfo(resourceid,carddate,carddate) ;
        }
    }
}
else if( opera.equals("workout")) {        // 转入加班
    RecordSet.executeProc("HrmRightCardInfo_AddWork" , id) ; 
    if(RecordSet.next()) {
        String resourceid = Util.null2String(RecordSet.getString(1)) ;
        String carddate = Util.null2String(RecordSet.getString(2)) ;
        if(!resourceid.equals("") && !carddate.equals("")) {
            HrmTimeCardInit.initTimecardInfo(resourceid,carddate,carddate) ;
        }
    }
}
else if( opera.equals("recreate")) {        // 重新生成该时间内的偏差
    RecordSet.executeSql(" update HrmRightCardInfo set islegal = 0 where carddate>='" + fromdate + 
                      "' and carddate<='" + enddate + "' and islegal = 2 ") ;
    HrmTimeCardInit.initTimecardInfo(startdate,enddate) ;
}


response.sendRedirect("HrmTimeCardWarpList.jsp?fromdate="+fromdate+"&todate="+todate+"&isself="+isself+"&resourceid="+resourceidpar+"&departmentid="+departmentidpar);

%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String src=Util.fromScreen(request.getParameter("src"),user.getLanguage());
String operate=Util.fromScreen(request.getParameter("operate"),user.getLanguage());
String[] requestids =request.getParameterValues("select_request");
if(src.equals("namecard")){
    if(!HrmUserVarify.checkUserRight("MonthFeeNamecard:Input", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String crmid=Util.fromScreen(request.getParameter("crmid"),user.getLanguage());
    String serialnum=Util.fromScreen(request.getParameter("serialnum"),user.getLanguage());
    if(operate.equals("save")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("feeamount_"+tmprequestid),user.getLanguage());
            String sql="update bill_namecard set amountpercase="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    if(operate.equals("change")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("changeamount_"+tmprequestid),user.getLanguage());
            String sql="update bill_namecard set amountpercase="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    response.sendRedirect("/workflow/monthfee/MonthFeeNamecard.jsp?crmid="+crmid+"&serialnum="+serialnum);
}
if(src.equals("plane")){
    if(!HrmUserVarify.checkUserRight("MonthFeePlane:Input", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String crmid=Util.fromScreen(request.getParameter("crmid"),user.getLanguage());
    String serialnum=Util.fromScreen(request.getParameter("serialnum"),user.getLanguage());
    String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
    String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
    if(operate.equals("save")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("feeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    if(operate.equals("change")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("changeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    response.sendRedirect("/workflow/monthfee/MonthFeePlane.jsp?crmid="+crmid+"&serialnum="+serialnum+"&resourceid="+resourceid+"&departmentid="+departmentid);
}
if(src.equals("snkd")){
    if(!HrmUserVarify.checkUserRight("MonthFeeSNKD:Input", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String crmid=Util.fromScreen(request.getParameter("crmid"),user.getLanguage());
    String serialnum=Util.fromScreen(request.getParameter("serialnum"),user.getLanguage());
    String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
    String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
    if(operate.equals("save")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("feeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    if(operate.equals("change")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("changeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    response.sendRedirect("/workflow/monthfee/MonthFeeSNKD.jsp?crmid="+crmid+"&serialnum="+serialnum+"&resourceid="+resourceid+"&departmentid="+departmentid);
}
if(src.equals("ems")){
    if(!HrmUserVarify.checkUserRight("MonthFeeEMS:Input", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String emstype=Util.fromScreen(request.getParameter("emstype"),user.getLanguage());
    String serialnum=Util.fromScreen(request.getParameter("serialnum"),user.getLanguage());
    String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
    String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
    if(operate.equals("save")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("feeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    if(operate.equals("change")){
        for(int i=0;i<requestids.length;i++){
            String tmprequestid=requestids[i];
            String tmpamount=Util.fromScreen(request.getParameter("changeamount_"+tmprequestid),user.getLanguage());
            String sql="update workflow_form set amount="+tmpamount+" where requestid="+tmprequestid;
            RecordSet.executeSql(sql);
        }
    }
    response.sendRedirect("/workflow/monthfee/MonthFeeEMS.jsp?emstype="+emstype+"&serialnum="+serialnum+"&resourceid="+resourceid+"&departmentid="+departmentid);
}
%>

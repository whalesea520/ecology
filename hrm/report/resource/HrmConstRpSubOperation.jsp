<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
    int scopeId = Util.getIntValue(request.getParameter("scopeid"),0);
    int userId = Util.getIntValue(request.getParameter("userid"),0);
    String[] fieldLabel = request.getParameterValues("fieldlabel");
    String[] fieldName = request.getParameterValues("fieldname");
    String[] fieldOrder = request.getParameterValues("fieldorder");

    String insertSql = "insert into HrmRpSubDefine(scopeid,resourceid,colname,showorder,header) values(";
    if(fieldLabel != null && fieldName != null && fieldOrder != null){
        rs.executeSql("delete from HrmRpSubDefine where scopeid="+scopeId+" and resourceid="+userId);
        for(int i=0; i<fieldLabel.length; i++){
            if(!fieldOrder[i].equals("0")&&!fieldOrder[i].equals("")){
                rs.executeSql(insertSql + scopeId + "," + userId + ",'" + fieldName[i] + "'," + fieldOrder[i] + ",'" + fieldLabel[i] + "')");
                //System.out.println(insertSql + scopeId + "," + userId + ",'" + fieldName[i] + "'," + fieldOrder[i] + ",'" + fieldLabel[i] + "')");
            }
        }
    }

    response.sendRedirect("/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid="+scopeId);

%>
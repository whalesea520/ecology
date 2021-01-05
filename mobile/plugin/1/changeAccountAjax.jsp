
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.util.Vector"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
FileUpload fu = new FileUpload(request);
JSONArray jsonArr = new JSONArray();
//用户id
String userIds = Util.null2String(fu.getParameter("userIds"));
if(!"".equals(userIds)){
    String[] useridarray = userIds.split(",");

    StringBuffer sql = new StringBuffer();

    sql = new StringBuffer();
    sql.append(" select t1.id, t2.jobtitlename, t3.departmentmark ");
    sql.append(" from hrmresource t1 ");
    sql.append(" inner join hrmjobtitles t2 ");
    sql.append(" on t1.jobtitle = t2.id ");
    sql.append(" inner join hrmdepartment t3 ");
    sql.append(" on t1.departmentid = t3.id ");
    sql.append(" where 1 = 1 and ( ");
    Vector<String> useridList = new Vector<String>();
    int i = 0;
    while(i < useridarray.length){
        if(i > 0){
            sql.append(" or ");
        }
        sql.append(" t1.id = ? ");
        useridList.add(useridarray[i]);
        i++;
    }
    sql.append(" ) ");
    rs.executeQuery(sql.toString(),useridarray);

    while(rs.next()) {
        JSONObject tmp = new JSONObject();
        String id = rs.getString("id");
        String jobtitlename = rs.getString("jobtitlename");
        String departmentmark = rs.getString("departmentmark");
        tmp.put("id",id);  
        tmp.put("jobtitlename",jobtitlename);    
        tmp.put("departmentmark",departmentmark);  
        jsonArr.add(tmp);
    }
}
out.println(jsonArr.toString());
%>
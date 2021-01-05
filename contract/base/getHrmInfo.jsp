<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    String usrid = request.getParameter("userid");
    String sql = "select r.lastname as name,r.sex,r.status,r.mobile,r.telephone,r.email,r.managerid,"+
                 " t.jobtitlename,u.subcompanyname,d.departmentname,r2.lastname as managername from hrmresource r"+
                 " left join hrmresource r2 on r.managerid = r2.id "+
                 " left join HrmJobTitles t on r.jobtitle = t.id "+
                 " left join hrmdepartment d on r.departmentid = d.id "+
                 " left join hrmsubcompany u on r.subcompanyid1 = u.id where r.id = "+usrid;
    rs.executeSql(sql);
    String[] str = rs.getColumnName();  
    int columnCount = str.length; 
    JSONArray array = new JSONArray(); 
        // 遍历RecordSet中的每条数据  
         while (rs.next()) {  
             JSONObject jsonObj = new JSONObject();  
             // 遍历每一列  
             for (int i = 0; i < columnCount; i++) {     
                 String columnName =str[i];  
                 String value = rs.getString(columnName);  
                 jsonObj.put(columnName.toLowerCase(), value); 
             }   
             if("1".equals(rs.getString("sex"))){
                 jsonObj.put("sex","男");
             }else{
                 jsonObj.put("sex","女");
             }
             array.put(jsonObj);   
         }  
          
       out.print(array.toString());  
%>




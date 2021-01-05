<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%

//HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
//out.print(hrmOrg.getTreeData("source"));

User usr = HrmUserVarify.getUser (request , response) ;
JSONArray array = new JSONArray(); 
String sql ="with subqry(id,supdepid,departmentname) as ("
	+ " select id,supdepid,departmentname from HrmDepartment where id = 1"
	+ " union all"
	+ " select d.id,d.supdepid,d.departmentname from HrmDepartment d,subqry "
	+ " where d.supdepid = subqry.id)" + "select * from subqry";
rs.executeSql(sql);
// 获取列数  
   String[] str = rs.getColumnName();  
   int columnCount = str.length;  
   // 遍历RecordSet中的每条数据  
    while (rs.next()) {  
        JSONObject jsonObj = new JSONObject();  
         
        // 遍历每一列  
        for (int i = 0; i < columnCount; i++) {  	
            String columnName =str[i];  
            String value = rs.getString(columnName);  
            if("departmentname".equals(columnName)){
            	columnName = "label";
            }
            jsonObj.put(columnName.toLowerCase(), value); 
        }   
        array.put(jsonObj);   
    }  
    
  out.print(array.toString());  
%>


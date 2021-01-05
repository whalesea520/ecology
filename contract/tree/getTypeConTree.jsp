<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	//查询类型树
	User usr = HrmUserVarify.getUser(request, response);
	String sex = usr.getSex();
	JSONArray array = new JSONArray();
	String sql = "select id,pid,name,sequence from uf_t_cons_type";
	rs.executeSql(sql);
	// 获取列数  
	String[] str = rs.getColumnName();
	int columnCount = str == null ? 0 : str.length;
	// 遍历RecordSet中的每条数据  
	while (rs.next()) {
		JSONObject jsonObj = new JSONObject();
		
		for (int i = 0; i < columnCount; i++) {
			String columnName = str[i].toLowerCase();
			String value = rs.getString(columnName);
			if ("name".equals(columnName)) {
				columnName = "label";
			}
			if(rs.getInt("id") != 11){
			    jsonObj.put(columnName, value);
			}
			
		}
		
		array.put(jsonObj);
		}
	out.print(array.toString());
%>


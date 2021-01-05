<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="java.sql.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="java.util.Hashtable"%>
<jsp:useBean id="automaticconnect" class="weaver.workflow.automatic.automaticconnect" scope="page" />
<%
out.clear();
response.setContentType("text/xml;charset=UTF-8");
String sqlcontent = Util.null2String(request.getParameter("sql"));
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String isFormMode = Util.null2String(request.getParameter("isFormMode"));
boolean isCanUse = false;
User user = HrmUserVarify.getUser (request , response) ;
JSONObject jsonObject = new JSONObject();
if(user==null){
	if("1".equals(isFormMode)){
		jsonObject.put("isCanUse",isCanUse);
		jsonObject.put("errormsg","-101");
		response.getWriter().write(jsonObject.toString());
	}
	return;
}
boolean userRight = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
if (!userRight && !HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	if("1".equals(isFormMode)){
		jsonObject.put("isCanUse",isCanUse);
		jsonObject.put("errormsg","-102");
		response.getWriter().write(jsonObject.toString());
	}
	return;
}

String errormsg = "";
try{
	ConnStatement statement = null;
	int index = sqlcontent.indexOf("doFieldSQL(\"");
	if(index > -1){
		sqlcontent = sqlcontent.substring(index+12);
		index = sqlcontent.lastIndexOf("\")");
		if(index > -1){
			sqlcontent = sqlcontent.substring(0, index);
		}
	}
	
	sqlcontent = sqlcontent.trim();
	if(!"".equals(sqlcontent) && !sqlcontent.toLowerCase().startsWith("select")){
		if("1".equals(isFormMode)){
			jsonObject.put("isCanUse",isCanUse);
			jsonObject.put("errormsg","");
			response.getWriter().write(jsonObject.toString());
		}
		return;
	}
	sqlcontent = sqlcontent.replaceAll("\\'\\$([0-9]*)\\$\\'", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$([0-9]*)\\$", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$(-[0-9]*)\\$", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$([currentdate]*)\\$", "1970-01-01");
	sqlcontent = sqlcontent.replaceAll("\\$([billid|currentuser|currentdept|wfcreater|wfcredept|id|requestid]*)\\$", "0");
	if(!"".equals(sqlcontent)){
		if("".equals(datasourceid) || "null".equals(datasourceid)){
			try{
				statement = new ConnStatement();
				statement.setStatementSql(sqlcontent);
				statement.executeQuery();
				isCanUse = true;
			}catch(Exception e){
				errormsg = e.getMessage();
				isCanUse = false;
			}finally{
				try{
					statement.close();
					statement = null;
				}catch(Exception e){
					errormsg = e.getMessage();
					//极有可能出错，出错时不做任何处理
				}
			}
		}else{//数据源
			Connection conn = null;
			Statement stmt = null;
			try{
				conn = automaticconnect.getConnection("datasource."+datasourceid);//获得外部连接
				stmt = conn.createStatement();
				stmt.executeQuery(sqlcontent);
				isCanUse = true;
			}catch(Exception e){
				errormsg = e.getMessage();
				isCanUse = false;
			}finally{
				try{
					stmt.close();
					conn.close();
				}catch(Exception e){
					errormsg = e.getMessage();
				}
			}
		}
	}else{
		isCanUse = true;
	}
}catch(Exception e){
	errormsg = e.getMessage();
	isCanUse = false;
}
if(isCanUse){
	errormsg = "";
}else{
	if(errormsg.equals("null")){
		errormsg = "";
	}
}
if("1".equals(isFormMode)){
	jsonObject.put("isCanUse",isCanUse);
	jsonObject.put("errormsg",errormsg);
	response.getWriter().write(jsonObject.toString());
	return;
}
%>
<information>
<iscanuse><%=isCanUse%></iscanuse>
</information>
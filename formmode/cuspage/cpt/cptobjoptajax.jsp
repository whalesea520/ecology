<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);
StringBuffer result = new StringBuffer("{");

if(user == null){
	result.append("\"info\":{\"success\":false,\"msg\":\"user error!\"}");
}else{
	
	String operatorId=""+user.getUID();
	String modeid=Util.null2String(request.getParameter("modeid"));
	String modename=""+Cpt4modeUtil.getModename(modeid);
	String type=Util.null2String(request.getParameter("type"));
	String poststr=Util.null2String(request.getParameter("poststr"));
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int currentnodetype=Util.getIntValue(request.getParameter("currentnodetype"),0);
	int formid=Util.getIntValue(request.getParameter("formid"),0);
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);
	
	
	String msg="";
	HashMap tmpMap=new HashMap<String,String>();
	if(!"".equals(poststr)){
		if(poststr.startsWith(",")){
			poststr=poststr.substring(1);
		}
		if(poststr.endsWith(",")){
			poststr=poststr.substring(0,poststr.length()-1);
		}
		
		if("del".equals(type)){
			if("zcz".equalsIgnoreCase(modename) ){//资产组
				String sql="delete uf_cptassortment where id in("+poststr+")";
				rs.executeSql(sql);
			}else if("zclx".equalsIgnoreCase(modename)){//资产类型
				String sql="delete uf_cptcapitaltype where id in("+poststr+")";
				rs.executeSql(sql);
			}else if("jldw".equalsIgnoreCase(modename)){//计量单位
				String sql="delete uf_LgcAssetUnit where id in("+poststr+")";
				rs.executeSql(sql);
			}else if("zczl".equalsIgnoreCase(modename)){//资产资料
				String sql="delete uf_cptcapital where id in("+poststr+")";
				rs.executeSql(sql);
			}
		}
		
	}
		
	result.append("\"msg\":\""+msg+"\",");
	
	result.append("\"info\":{\"success\":true,\"msg\":\"\"}");
	
}
result.append("}");

%>
<%=result.toString() %>

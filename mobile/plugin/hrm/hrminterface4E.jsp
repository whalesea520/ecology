<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.tools.HrmResourceMobileTools"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<jsp:useBean id="HrmInterface" class="weaver.hrm.tools.HrmInterface" scope="page" />
<%
Log log = LogFactory.getLog(page.getClass());
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
log.info("Follow is the QueryString:\t" + request.getQueryString());

User user = HrmUserVarify.getUser(request , response) ;
FileUpload fu = new FileUpload(request);
Map<String,String> result = new HashMap<String,String>();
if(user==null) {
	//未登录或登录超时
	result.put("error", "005");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}

String type = Util.null2String(fu.getParameter("type"));
if(type.equals("getOrgInfo")){//我们泛微的分支机构分布
	out.println(HrmInterface.getOrgInfo());
}else if(type.equals("getAllResourceNum")){//公司目前有多少人
	out.println(HrmInterface.getAllResourceNum());
}else if(type.equals("getResourceEnter")){//有多少新员工入职
	String createdatefrom = Util.null2String(fu.getParameter("createdatefrom"));
	String createdateto = Util.null2String(fu.getParameter("createdateto"));
	out.println(HrmInterface.getResourceEnter(createdatefrom,createdateto));
}
%>
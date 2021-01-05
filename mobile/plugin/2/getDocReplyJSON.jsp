<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />
<jsp:useBean id="docReplyServiceForMobile" class="weaver.docs.webservices.reply.DocReplyServiceForMobile" scope="page" />
<%
BaseBean bb = new BaseBean();
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");
bb.writeLog("getDocReplyJSON.jsp","userid:"+user.getUID());
String documentid = Util.null2String(request.getParameter("documentid"));
bb.writeLog("getDocReplyJSON.jsp","documentid:"+documentid);
if(true)
{
    String result = docReplyServiceForMobile.getDocReply(documentid,user);
    bb.writeLog("getDocReplyJSON.jsp","result:"+result);
    out.println(result); 
}
else
{
    org.json.JSONArray ja = DocServiceForMobile.getDocReply(documentid,user);
    out.println(ja); 
}
%>
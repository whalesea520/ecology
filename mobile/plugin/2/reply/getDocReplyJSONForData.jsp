<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="docReplyServiceForMobile" class="weaver.docs.webservices.reply.DocReplyServiceForMobile" scope="page" />
<%
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
String documentid = Util.null2String(request.getParameter("documentid"));
String operation = Util.null2String(request.getParameter("operation"));
if(operation.equals("doc"))
{
    String json = docReplyServiceForMobile.getDocInfo(documentid,user);
    out.println(json);
}
else if(operation.equals("reply"))
{
    int lastReplyid = Util.getIntValue(request.getParameter("lastReplyid"),0);
    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10);
    int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
    String json = docReplyServiceForMobile.getDocReply(documentid,user,lastReplyid,pageSize,childrenSize);
    out.println(json);
}
else if(operation.equals("moreReply"))
{
    int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
    String replymainid = Util.null2String(request.getParameter("replymainid"));
    String lastReplyid = Util.null2String(request.getParameter("lastReplyid"));
     String json = docReplyServiceForMobile.getResidueReplysForReply(lastReplyid,replymainid,documentid,user,childrenSize);
    out.println(json);
}
%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.reply.BelongUtils" %>
<jsp:useBean id="drm" class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<jsp:useBean id="docReplyServiceForMobile" class="weaver.docs.webservices.reply.DocReplyServiceForMobile" scope="page" />
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("result", "200001");
	result.put("error", "未登录或登录超");
			
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");
//操作方式  saveReply：回复  delReply：删除回复  praise：点赞  unpraise：取消点赞
String operation = Util.null2String(request.getParameter("operation"));
if(!operation.equals("saveReply")
	&&!operation.equals("delReply")
	&&!operation.equals("praise")
	&&!operation.equals("unpraise")
	){
	Map result = new HashMap();
	//operation参数未设置正确
	result.put("result", "200002");
	result.put("error", "operation参数未设置正确");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;

}

String docid = Util.null2String(request.getParameter("documentid"));
User userbelong = BelongUtils.getBelongUser(user,docid,request,response);
int replyid = Util.getIntValue(request.getParameter("replyid"));
int replytype = Util.getIntValue(request.getParameter("replytype"));
Map result =null;
if(operation.equals("saveReply")){
	result = docReplyServiceForMobile.saveReply(request,userbelong);
	
	if(result.get("replytype").equals("0"))
    {
	    JSONObject jo = JSONObject.fromObject(result);
	    out.println(jo);
    }
    else
    {
        String lastReplyid = Util.null2String(request.getParameter("lastReplyid"));
        String currdocid = Util.null2String(request.getParameter("docid"));
        String jsonData =  docReplyServiceForMobile.getResidueReplysForReply(lastReplyid,result.get("replymainid").toString(),currdocid,user,5);
        out.println(jsonData);
    }
	
	
}else if(operation.equals("delReply")){
	result = docReplyServiceForMobile.delDocReply(replyid,user,docid);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(operation.equals("praise")){
	result = docReplyServiceForMobile.praise(replyid,replytype,user,docid);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(operation.equals("unpraise")){
	result = docReplyServiceForMobile.unPraise(replyid,replytype,user,docid);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>
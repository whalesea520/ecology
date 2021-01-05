<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.docs.reply.DocReplyModel" %>
<%@ page import="weaver.docs.docs.reply.DocReplyManager" %>
<%@ page import="weaver.docs.docs.reply.BelongUtils" %>
<jsp:useBean id="saveDocReply" class="weaver.docs.docs.reply.SaveDocReplyManager" scope="page" />
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	// 文档ID
    String docid = Util.null2String(request.getParameter("docid"));
    String optype = Util.null2String(request.getParameter("optype"));
	user = BelongUtils.getBelongUser(user,docid,request,response);
	if(optype.equals("reply"))
	{
	    DocReplyModel docReplyModel = saveDocReply.saveDocReply(request,user,false);
	    if(docReplyModel.getRtype().equals("0"))
	    {
	        JSONObject jsonObject = JSONObject.fromObject(docReplyModel);
			out.println(jsonObject.toString());
	    }
	    else
	    {
	        String lastReplyid = Util.null2String(request.getParameter("lastReplyid"));
	        DocReplyManager docReplyManager = new DocReplyManager();
	        List<DocReplyModel> jsonList = docReplyManager.getResidueReplysForReply(lastReplyid,docReplyModel.getReplymainid(),docReplyModel.getDocid(),user.getUID()+"",false);
	        String jsonData = JSONArray.fromObject(jsonList).toString();
	        out.println(jsonData);
	    }
	}
	else if(optype.equals("edit"))
	{
	    DocReplyModel DocReplyModel = saveDocReply.updateReplyContent(request,user,false);
	    JSONObject jsonObject = JSONObject.fromObject(DocReplyModel);
		out.println(jsonObject.toString());
	}
%>
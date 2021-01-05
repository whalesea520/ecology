
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />
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
//操作方式  deletedoc：删除文档  addshare：新增共享  docollect：收藏  undocollect：取消收藏  createdoc：取消收藏
String operation = Util.null2String(request.getParameter("operation"));
if(!operation.equals("addshare")
	&&!operation.equals("deletedoc")
	&&!operation.equals("docollect")
	&&!operation.equals("undocollect")
	&&!operation.equals("createdoc")
	){
	Map result = new HashMap();
	//operation参数未设置正确
	result.put("result", "200002");
	result.put("error", "operation参数未设置正确");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;

}


String newdocreply = Util.null2String(request.getParameter("newdocreply"));

String documentid = Util.null2String(request.getParameter("documentid"));

String shareuserids = Util.null2String(request.getParameter("shareuserids"));

int replyid = Util.getIntValue(request.getParameter("replyid"));

int replytype = Util.getIntValue(request.getParameter("replytype"));

Map result =null;
if(operation.equals("addshare")){
	result = DocServiceForMobile.addShare(documentid,shareuserids,user);
}else if(operation.equals("deletedoc")){
	result = DocServiceForMobile.deleteDoc(documentid,user);
}else if(operation.equals("docollect")){
	result = DocServiceForMobile.doCollect(documentid,user);
}else if(operation.equals("undocollect")){
	result = DocServiceForMobile.undoCollect(documentid,user);
}else if(operation.equals("createdoc")){
    if(newdocreply.equals("1"))
    {
        result = docReplyServiceForMobile.saveReply(request,user);
    }
    else
    {
        result = DocServiceForMobile.createDoc(request,user);
    }
}else if(operation.equals("saveReply")){
	result = docReplyServiceForMobile.saveReply(request,user);
}


JSONObject jo = JSONObject.fromObject(result);

out.println(jo);
%>
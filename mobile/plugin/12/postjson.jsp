
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.net.URLDecoder,java.text.SimpleDateFormat" %>
<%@page import="weaver.workflow.request.WorkflowSpeechAppend"%>
<%@ page import="weaver.mobile.plugin.ecology.service.EMessageService" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "remote server session time out");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
//String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String func = Util.null2String(fu.getParameter("func"));
String msg = Util.null2String(fu.getParameter("msg"));
int detailid = Util.getIntValue(fu.getParameter("detailid"));
String msgType = Util.null2String(fu.getParameter("msgType"));
String fileContent = Util.null2String(fu.getParameter("fileContent"));
String fileName = Util.null2String(fu.getParameter("fileName"));
String tag = Util.null2String(fu.getParameter("tag"));
String roomid = Util.null2String(fu.getParameter("roomid"));
String fileType = Util.null2String(fu.getParameter("fileType"));

Map result = new HashMap();

if("sendmsg".equals(func)) {
	if("image".equals(msgType) || "voice".equals(msgType)) {
		msgType = msgType + "/" + fileName;
		msg = URLDecoder.decode(fileContent);
	}
	result = EMessageService.getInstance().sendMessage(user, detailid, msg, msgType);
} else if("docupload".equals(func)){
	int docid = WorkflowSpeechAppend.uploadAppend(URLDecoder.decode(fileContent),fileType,fileName);
	SimpleDateFormat dateformat1=new SimpleDateFormat("yyyy-MM-dd");
	String datestr=dateformat1.format(new Date());
	if(docid>0){
		String sql = "insert into ofmucroomfiles(roomid,imagefileid,loginid,createtime) values ('"+roomid+"','"+docid+"','"+user.getLoginid().toLowerCase()+"','"+datestr+"')";
		rs.executeSql(sql);
	}
	result.put("docid", docid);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}else{
	result.put("result", "-1");
	result.put("error", "invoke method func error("+func+")");
}
result.put("tag", tag);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>
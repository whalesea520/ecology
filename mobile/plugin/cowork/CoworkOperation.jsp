<%@page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.hrm.*" %>

<jsp:useBean id="CoworkService" class="weaver.mobile.plugin.ecology.service.CoworkService" scope="page" />
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

request.setCharacterEncoding("UTF-8");

FileUpload fu=new FileUpload(request);
int coworkid = Util.getIntValue(fu.getParameter("coworkid"));
String operation = Util.null2String(fu.getParameter("operation"));
int replayid = Util.getIntValue(fu.getParameter("replayid"), 0);
int pageIndex = Util.getIntValue(fu.getParameter("pageindex"), 1);
int pageSize = Util.getIntValue(fu.getParameter("pagesize"), 10);
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));

String remark = Util.null2String(fu.getParameter("remark"));
//对换行符特殊处理
remark = Util.replaceString(remark, "%3Cbr%3E%E2%80%8B", "<br/>");
remark = Util.replaceString(remark, "%E2%80%8B", "");  // 转码之后的字符，会多出来一个此无法展示的字符，转移后展示为:?
remark = URLDecoder.decode(remark,"utf-8");

String keyword = Util.null2String(fu.getParameter("keyword"));
keyword = URLDecoder.decode(keyword, "utf-8");

int labelid = Util.getIntValue(fu.getParameter("labelid"), 0);

Map result = new HashMap();

if("getCoworkDetail".equals(operation)) {
	result = CoworkService.getCoworkDtl(coworkid, pageIndex, pageSize, user);
} else if("saveCowork".equals(operation))	{
	String replyType = Util.null2String(fu.getParameter("replyType"));
	String topdiscussid = Util.null2String(fu.getParameter("topdiscussid"));
	String isAnonymous = Util.null2String(fu.getParameter("isAnonymous"));
	String isApproval = Util.null2String(fu.getParameter("isApproval"));
	Map params=new HashMap();
	params.put("replyType",replyType);
	params.put("topdiscussid",topdiscussid);
	params.put("isAnonymous",isAnonymous);
	params.put("isApproval",isApproval);
	result = CoworkService.submitCowork(user, remark, coworkid, replayid,params);
} else if("getCoworkList".equals(operation)) {
	List conditions = new ArrayList();
	conditions.add(""+labelid);
	
	if(keyword!=null && !"".equals(keyword)) {
		conditions.add(" (name like '%"+keyword+"%') ");
	}
	
	result = CoworkService.getCoworkList(conditions, pageIndex, pageSize, user);
	
} else if("important".equals(operation)) {
	result = CoworkService.markCoworkItemAsType(coworkid, "important", user);
} else if("normal".equals(operation)) {
	result = CoworkService.markCoworkItemAsType(coworkid, "normal", user);
}

JSONObject json = JSONObject.fromObject(result);
out.print(json.toString());

%>
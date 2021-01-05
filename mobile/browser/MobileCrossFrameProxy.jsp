<%@page language="java" contentType="text/plain; charset=UTF-8" %>
<%@page import="java.util.*" %>
<%@page import="weaver.general.*" %>
<%
String method = Util.null2String(request.getParameter("method"));
String flag = Util.null2String(request.getParameter("flag"));

StaticObj staticobj = StaticObj.getInstance();

Map data = (Map) (staticobj.getRecordFromObj("cn.com.weaver.mobile.config.proxy", flag));
if(data==null) data = new HashMap();

if(method==null||"".equals(method)) return;
if(flag==null||"".equals(flag)) return;

if("returnAddUser".equals(method)) {
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String seclevel = Util.null2String(request.getParameter("seclevel"));
	String rolelevel = Util.null2String(request.getParameter("rolelevel"));
	String relatedshareids = Util.null2String(request.getParameter("relatedshareids"));
	String click = Util.null2String(request.getParameter("click"));
	
	String callback = Util.null2String(request.getParameter("callback"));
	
	data.put("sharetype",sharetype);
	data.put("seclevel",seclevel);
	data.put("rolelevel",rolelevel);
	data.put("relatedshareids",relatedshareids);
	data.put("click",click);
	
	staticobj.putRecordToObj("cn.com.weaver.mobile.config.proxy", flag, data);
	
	out.println(callback+";");
	
} else if("getAddUser".equals(method)) {
	String callback = "";
	if(data.size()>0) {
		String sharetype = Util.null2String((String)data.get("sharetype"));
		String seclevel = Util.null2String((String)data.get("seclevel"));
		String rolelevel = Util.null2String((String)data.get("rolelevel"));
		String relatedshareids = Util.null2String((String)data.get("relatedshareids"));
		String click = Util.null2String((String)data.get("click"));
		
		callback = "cancel()";
		if(click!=null&&"ok".equals(click)) callback = "ok()";
		
		out.println("document.getElementById(\"returnsharetype\").value=\""+sharetype+"\";");
		out.println("document.getElementById(\"returnseclevel\").value=\""+seclevel+"\";");
		out.println("document.getElementById(\"returnrolelevel\").value=\""+rolelevel+"\";");
		out.println("document.getElementById(\"returnrelatedshareids\").value=\""+relatedshareids+"\";");
	} else {
		callback = "checkProxy()";
	}
	out.println(callback+";");
	
} else if("clearAddUser".equals(method)) {
	
	String callback = Util.null2String(request.getParameter("callback"));
	
	staticobj.removeRecordFromObj("cn.com.weaver.mobile.config.proxy", flag);
	
	out.println(callback+";");

} else if("returnAddConfig".equals(method)) {
	String returnvalueinput = Util.null2String(request.getParameter("returnvalueinput"));
	String returnvalue = Util.null2String(request.getParameter("returnvalue"));
	String click = Util.null2String(request.getParameter("click"));
	
	String callback = Util.null2String(request.getParameter("callback"));
	
	data.put("returnvalueinput",returnvalueinput);
	data.put("returnvalue",returnvalue);
	data.put("click",click);
	
	staticobj.putRecordToObj("cn.com.weaver.mobile.config.proxy", flag, data);
	
	out.println(callback+";");
		
} else if("getAddConfig".equals(method)) {
	String callback = "";
	if(data.size()>0) {
		String returnvalueinput = Util.null2String((String)data.get("returnvalueinput"));
		String returnvalue = Util.null2String((String)data.get("returnvalue"));
		String click = Util.null2String((String)data.get("click"));
		
		callback = "clearProxy()";
		
		if(click!=null&&"ok".equals(click))
			out.println("document.getElementById(\""+returnvalueinput+"\").value=\""+returnvalue+"\";");
	} else {
		callback = "checkProxy()";
	}
	out.println(callback+";");
	
} else if("clearAddConfig".equals(method)) {
	
	String callback = Util.null2String(request.getParameter("callback"));
	
	staticobj.removeRecordFromObj("cn.com.weaver.mobile.config.proxy", flag);
	
	out.println(callback+";");
		
}
%>
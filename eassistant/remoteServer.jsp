<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONObject,java.util.*,weaver.eassistant.*,weaver.eassistant.interfaces.*,weaver.eassistant.interfaces.impl.*"%>
<%
	String ip = request.getRemoteAddr();
	List<String> allowIps = new ArrayList<String>();
	allowIps.add("127.0.0.1");
	allowIps.add("10.28.34.0");
	allowIps.add("118.178.232.11");
	allowIps.add("10.168.227.145");
	allowIps.add("121.41.105.211");
	allowIps.add("10.168.228.161");
	allowIps.add("121.41.105.177");
	//out.println(ip);
	if(!allowIps.contains(ip)){
		new weaver.general.BaseBean().writeLog("客户端IP"+ip+"禁止访问此接口！");
		response.sendError(403);
		return;
	}
	EAssistant eass = new EAssistantImpl();
	String  text = request.getParameter("text");
	String words = request.getParameter("words");
	String creator = request.getParameter("creator");
//System.out.println(text+"--->"+words+"---->"+creator);
	if(text==null||words==null||creator==null){
		JSONObject result = new JSONObject();
		result.put("message","data error!");
		out.println(result.toString());
	}else{
		Map<String,String> result = eass.getEAssistantResult(text,words,creator);
		/*JSONObject result = new JSONObject();
		result.put("text",text);
		result.put("words",words);
		result.put("creator",creator);
		out.println(result.toString());*/
		out.println(JSONObject.fromObject(result).toString());
	}
%>
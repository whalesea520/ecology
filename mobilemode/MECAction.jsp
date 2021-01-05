<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.mobile.plugin.Resource"%>
<%@page import="com.weaver.formmodel.mobile.plugin.Plugin"%>
<%@page import="com.weaver.formmodel.mobile.plugin.PluginCenter"%>
<%@page import="java.lang.reflect.Method"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.*"%>
<%@page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@page import="com.weaver.formmodel.mobile.mec.handler.AbstractMECHandler"%>
<%
String action = Util.null2String(request.getParameter("action"));
if(action.equals("getMecHtml")){
	String mec_id = Util.null2String(request.getParameter("mec_id"));
	
	AbstractMECHandler mecHandler = MECManager.getMecHandler(mec_id, request, response);
	if(mecHandler == null){
		return;
	}
	mecHandler.setLoadType("1");
	String viewHtml = mecHandler.getViewHtml();
	String jsScript = mecHandler.getJSScript();
	String result = viewHtml + "\n" + jsScript;
	out.print(result);
}else if(action.equals("getMecData")){
	String mec_id = Util.null2String(request.getParameter("mec_id"));
	AbstractMECHandler mecHandler = MECManager.getMecHandler(mec_id, request, response);
	if(mecHandler == null){
		return;
	}
	Object data = mecHandler.getData();
	out.print(data.toString());
}else if(action.startsWith("method:")){
	String methodName = action.substring("method:".length()).trim();
	if(methodName.equals("")){
		return;
	}
	
	String mec_id = Util.null2String(request.getParameter("mec_id"));
	AbstractMECHandler mecHandler = MECManager.getMecHandler(mec_id, request, response);
	if(mecHandler == null){
		return;
	}
	try{
		Class cl = mecHandler.getClass();
		Method method = cl.getDeclaredMethod(methodName);
		Object result = method.invoke(mecHandler);
		out.print(result.toString());
	}catch(Exception ex){
		ex.printStackTrace();
		return;
	}
}else if(action.equals("getDesignJS")){
	response.setContentType("application/x-javascript");
	//long a = System.currentTimeMillis();
	String content = PluginCenter.getInstance().getDesignJSContent();
	//System.out.println("1:" + (System.currentTimeMillis()-a));
	out.print(content);
}else if(action.equals("getDesignCss")){
	response.setContentType("text/css");
	//long a = System.currentTimeMillis();
	String content = PluginCenter.getInstance().getDesignCssContent();
	//System.out.println("2:" + (System.currentTimeMillis()-a));
	out.print(content);
}else if(action.equals("getDesignResource")){
	String mec_type = Util.null2String(request.getParameter("mec_type"));
	JSONArray jsonArray = new JSONArray();
	Plugin plugin = PluginCenter.getInstance().getPluginById(mec_type);
	List<Resource> resources = plugin.getDesignReourrces();
	for(Resource resource : resources){
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("type", resource.getType());
		jsonObject.put("path", resource.getPath());
		jsonObject.put("content", resource.getContent());
		jsonArray.add(jsonObject);
	}
	
	Collections.sort(jsonArray, new Comparator<JSONObject>(){
		public int compare(JSONObject o1, JSONObject o2) {
			String type = Util.null2String(o1.get("type"));
			String type2 = Util.null2String(o2.get("type"));
			return type.compareTo(type2);
		}
		
	});
	
	out.print(jsonArray.toString());
}
out.flush();
%>

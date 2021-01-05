
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

boolean reload=Boolean.valueOf(Util.null2String(fu.getParameter("reload")));

List auths = new ArrayList();

String auth = Util.null2String(fu.getParameter("auth"));
JSONObject jo = JSONObject.fromObject(auth);
if(jo.containsKey("auths")) {
	
	JSONArray ja = jo.getJSONArray("auths");

	for(int i=0;ja!=null&&i<ja.size();i++) {
		
		JSONObject jao = ja.getJSONObject(i);
		
		Map map = new HashMap();
		
		String id="";
		if(jao.containsKey("id"))
			id = jao.getString("id");
		
		String type="";
		if(jao.containsKey("type"))
			type = jao.getString("type");
		
		String typename="";
		if(jao.containsKey("typename"))
			typename = jao.getString("typename");
		
		String seclevel="";
		if(jao.containsKey("seclevel"))
			seclevel = jao.getString("seclevel");

		String value="";
		if(jao.containsKey("value"))
			value = jao.getString("value");

		String valuename="";
		if(jao.containsKey("valuename"))
			valuename = jao.getString("valuename");

		String groupid="";
		if(jao.containsKey("groupid"))
			groupid = jao.getString("groupid");

		map.put("id", id);
		map.put("type", type);
		map.put("typename", typename);
		map.put("seclevel", seclevel);
		map.put("value", value);
		map.put("valuename", valuename);
		map.put("groupid", groupid);
		
		auths.add(map);
	}
}

Map result = new HashMap();

int count = ps.getMobileUserCount(auths, reload);

result.put("count", count+"");

JSONObject jsObject = JSONObject.fromObject(result);
out.println(jsObject);
%>
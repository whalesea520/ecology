
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
	response.setContentType("application/json;charset=UTF-8");

	FileUpload fu = new FileUpload(request); 

	String loginId = Util.null2String(fu.getParameter("loginid"));
	String password = Util.null2String(fu.getParameter("password"));
	String loginTokenFromThird = Util.null2String(fu.getParameter("loginTokenFromThird"));
	String secrect = Util.null2String(fu.getParameter("secrect"));
	String dynapass = Util.null2String(fu.getParameter("dynapass"));
	String tokenpass = Util.null2String(fu.getParameter("tokenpass"));
	String language = Util.null2String(fu.getParameter("language"));
	String ipaddress = Util.null2String(fu.getParameter("ipaddress"));
	int policy = Util.getIntValue(Util.null2String(fu.getParameter("policy")),0);
	String auth = Util.null2String(fu.getParameter("auth"));
	
	List auths = new ArrayList();
	
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
	
	Map result = ps.login(loginId, password,secrect, loginTokenFromThird,dynapass, tokenpass, language, ipaddress, policy, auths);

	RecordSet rs = new RecordSet();
	rs.executeSql("select name,propvalue from mobileProperty where name='hrmorgbtnshow' or name='allPeopleshow' or name='sameDepartment' or name='commonGroup' or name='groupChat' or name='mysubordinateshow'");
	while(rs.next()){
		String name = rs.getString("name");
		String propValue = rs.getString("propValue");
		if(name.equals("hrmorgbtnshow")){
			result.put("hrmorgbtnshow", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("allPeopleshow")){
			result.put("allPeopleshow", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("mysubordinateshow")){
			result.put("mysubordinateshow", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("sameDepartment")){
			result.put("sameDepartment", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("commonGroup")){
			result.put("commonGroup", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("groupChat")){
			result.put("groupChat", Util.getIntValue(propValue, 0)+"");
		}
	}
	if(result!=null) {
		JSONObject jro = JSONObject.fromObject(result);
		out.println(jro);
	}
%>

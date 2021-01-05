
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*"%>
<%@ page import="weaver.general.*,weaver.mobile.plugin.ecology.service.*" %>
<%@ page import="weaver.file.*,weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="AuthService" class="weaver.mobile.plugin.ecology.service.AuthService" scope="page" />
<%
	response.setContentType("application/json;charset=UTF-8");

	FileUpload fu = new FileUpload(request); 

	String identifier = Util.null2String(fu.getParameter("identifier"));
	String language = Util.null2String(fu.getParameter("language"));
	String ipaddress = Util.null2String(fu.getParameter("ipaddress"));

	String loginid = Util.null2String(fu.getParameter("loginid"));
	String password = Util.null2String(fu.getParameter("password"));
	
	String verifyurl =  Util.null2String(fu.getParameter("verifyurl"));
	String verifyid =  Util.null2String(fu.getParameter("verifyid"));
	
	String auth = Util.null2String(fu.getParameter("auth"));
	
	Map result = new HashMap();
	if(StringUtils.isNotEmpty(identifier)) {
		result = ps.login(identifier, language, ipaddress);
	}
	
	if(StringUtils.isNotEmpty(loginid) && StringUtils.isNotEmpty(password)) {
		if(ps.verify(loginid, password)) {
    		result.put("message", "1");
		}
	}
	
	if(result.get("message")!=null&&"1".equals(result.get("message"))&&StringUtils.isNotEmpty(verifyurl)&&StringUtils.isNotEmpty(verifyid)) {
		if(!AuthService.verifyQuickLogin(verifyurl, verifyid)) {
			result.remove("sessionkey");
			result.put("message", "17");
		}
	}
	
	if("1".equals(result.get("message"))&&!"".equals(auth)) {
		JSONObject jo = JSONObject.fromObject(auth);
		if(jo.containsKey("auths")) {
			List auths = new ArrayList();
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
			
			List userGroupidList=AuthService.checkMobileUserRight(identifier, auths); //返回用户具有权限访问的用户组id
			HrmResourceService hrs = new HrmResourceService();
			try {
			HrmUserSettingComInfo userSetting = new HrmUserSettingComInfo();
					 String belongtoshow = userSetting.getBelongtoshowByUserId(identifier);
					 if("1".equals(belongtoshow)){
						 List<String> relatives = hrs.getRelativeUser(Integer.parseInt(identifier));   
						 for(String relid:relatives){
							 List userGroupidListtemp=AuthService.checkMobileUserRight(relid, auths); 
							 userGroupidList.addAll(userGroupidListtemp);
						 }
					 }
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			result.put("groups", userGroupidList);//将用户组放入结果集中
		}
	}
	
	if(result!=null) {
		JSONObject jro = JSONObject.fromObject(result);
		out.println(jro);
	}
%>

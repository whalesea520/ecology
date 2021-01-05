
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@page import="weaver.conn.*"%>
<%@page import="weaver.login.LoginRemindService"%>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>

<%
	out.clearBuffer();
	FileUpload fu = new FileUpload(request); 
	String type = Util.null2String(fu.getParameter("type"));
	String mobile = Util.null2String(fu.getParameter("mobile"));
	String email = Util.null2String(fu.getParameter("email"));
	String telephone = Util.null2String(fu.getParameter("telephone"));
	
	Map result = new HashMap();
	try {
		if("mobile".equalsIgnoreCase(type)) {
			User user = HrmUserVarify.getUser (request , response) ;
			if(user==null) {
				//Map result = new HashMap();
				//未登录或登录超时
				result.put("error", "005");
		
				JSONObject jo = JSONObject.fromObject(result);
				out.println(jo);
		
				return;
			}
			if("".equalsIgnoreCase(mobile)){
				mobile = null;
			}
			String sqlWhere = "set MOBILE ="+mobile;
			
			if(!"".equalsIgnoreCase(sqlWhere)){
				RecordSet rs = new RecordSet();
				String sql = "update HrmResource "+sqlWhere+" where id=" + user.getUID();
				rs.executeSql(sql);
				weaver.hrm.resource.ResourceComInfo info = new weaver.hrm.resource.ResourceComInfo();
				info.updateResourceInfoCache(user.getUID()+"");
			}
		} else if ("telephone".equalsIgnoreCase(type)){
			User user = HrmUserVarify.getUser (request , response) ;
			if(user==null) {
				//Map result = new HashMap();
				//未登录或登录超时
				result.put("error", "005");
		
				JSONObject jo = JSONObject.fromObject(result);
				out.println(jo);
				return;
			}

			String sqlWhere = "set TELEPHONE ='"+telephone+"'";
			
			if(!"".equalsIgnoreCase(sqlWhere)){
				RecordSet rs = new RecordSet();
				String sql = "update HrmResource "+sqlWhere+" where id=" + user.getUID();
				rs.executeSql(sql);
				weaver.hrm.resource.ResourceComInfo info = new weaver.hrm.resource.ResourceComInfo();
				info.updateResourceInfoCache(user.getUID()+"");
			}
		} else if ("email".equalsIgnoreCase(type)){
			User user = HrmUserVarify.getUser (request , response) ;
			if(user==null) {
				//Map result = new HashMap();
				//未登录或登录超时
				result.put("error", "005");
		
				JSONObject jo = JSONObject.fromObject(result);
				out.println(jo);
				return;
			}

			String sqlWhere = "set EMAIL ='"+email+"'";

			if(!"".equalsIgnoreCase(sqlWhere)){
				RecordSet rs = new RecordSet();
				String sql = "update HrmResource "+sqlWhere+" where id=" + user.getUID();
				rs.executeSql(sql);
				weaver.hrm.resource.ResourceComInfo info = new weaver.hrm.resource.ResourceComInfo();
				info.updateResourceInfoCache(user.getUID()+"");
			}
		} else if ("status".equalsIgnoreCase(type)){
			LoginRemindService loginRemind = new LoginRemindService();
			String loginId = Util.null2String(fu.getParameter("loginId"));
			org.json.JSONObject json = loginRemind.getPassChangedReminder(loginId);
			new weaver.general.BaseBean().writeLog("resultA:"+json.toString());
			String code = json.getString("resultMsg");
			result.put("code",code);
			if("22".equalsIgnoreCase(code)){
				result.put("days",json.getInt("passwdelse"));
			}
		} else if ("getUserid".equalsIgnoreCase(type)){
			String loginId = Util.null2String(fu.getParameter("loginId"));
			HrmResourceService hr = new HrmResourceService();
			int userid = hr.getUserId(loginId);
			result.put("userid",userid);
		}

		result.put("status","1");
	} catch (Exception e) {
		new weaver.general.BaseBean().writeLog("resultA:"+e.toString());
		result.put("status","0");
	}
	
	if(result!=null) {
		JSONObject jro = JSONObject.fromObject(result);
		out.println(jro);
	}
%>

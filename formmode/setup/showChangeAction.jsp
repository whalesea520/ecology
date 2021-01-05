
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.dao.BaseDao"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/formmode/pub_init.jsp"%>
<%
response.reset();
out.clear();
String action = Util.null2String(request.getParameter("action"));
RecordSet rs = new RecordSet();
if(action.equalsIgnoreCase("saveForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		String data = Util.null2String(request.getParameter("data"));
		rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		data = URLDecoder.decode(data, "UTF-8");
		JSONArray dataArr = JSONArray.fromObject(data);
		for(int i = 0; i < dataArr.size(); i++){
			JSONObject jsonObject = (JSONObject)dataArr.get(i);
			int field_opt = Util.getIntValue(Util.null2String(jsonObject.get("field_opt")), 0);
			int field_opt2 = Util.getIntValue(Util.null2String(jsonObject.get("field_opt2")), 0);
			String field_optvalue =Util.null2String(jsonObject.get("field_optvalue"));
			String field_optvalue2 =Util.null2String(jsonObject.get("field_optvalue2"));
			String field_showvalue =Util.null2String(jsonObject.get("field_showvalue"));
			String field_backvalue =Util.null2String(jsonObject.get("field_backvalue"));
			String field_fontvalue =Util.null2String(jsonObject.get("field_fontvalue"));
			
			/* rs.executeSql("insert into customfieldshowchange(customid,fieldid,fieldopt,fieldopt2,fieldoptvalue,fieldoptvalue2,fieldshowvalue,fieldbackvalue,fieldfontvalue)"+
				" values("+customid+","+fieldid+","+field_opt+","+field_opt2+",'"+field_optvalue+"','"+field_optvalue2+"','"+field_showvalue+"','"+field_backvalue+"','"+field_fontvalue+"')"); */
			String sql = "insert into customfieldshowchange(customid,fieldid,fieldopt,fieldopt2,fieldoptvalue,fieldoptvalue2,fieldshowvalue,fieldbackvalue,fieldfontvalue)"
				+" values(?,?,?,?,?,?,?,?,?)";
			Object[] params = new Object[9];
			params[0] = customid;
			params[1] = fieldid;
			params[2] = field_opt;
			params[3] = field_opt2;
			params[4] = field_optvalue;
			params[5] = field_optvalue2;
			params[6] = field_showvalue;
			params[7] = field_backvalue;
			params[8] = field_fontvalue;
			rs.executeUpdate(sql, params);
		}
		if(dataArr.size()>0){
			out.print("1");
		}else{
			out.print("0");
		}
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("error");		
	}
}else if(action.equalsIgnoreCase("clearForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		String data = Util.null2String(request.getParameter("data"));
		//rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		out.print("0");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("error");	
	}
}
out.flush();
out.close();
%>
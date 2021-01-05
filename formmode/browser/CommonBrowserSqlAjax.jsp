<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.browser.FormModeBrowserSqlwhere"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String _fieldid = Util.null2String(request.getParameter("fieldid"));
	int fieldid = -1;
	if(_fieldid.indexOf("_")>-1){
		fieldid = Util.getIntValue(_fieldid.split("_")[0]);
	}else{
		fieldid = Util.getIntValue(_fieldid, -1);
	}
	
	RecordSet rs = new RecordSet();
	rs.executeSql("select expendattr from ModeFormFieldExtend where fieldid="+fieldid);
	Map<String,Map<String,String>> expendMap= new HashMap();
	if(rs.next()){
		String expendattr = rs.getString(1);
		expendattr = expendattr.replace("&lt;","<");
		expendattr = expendattr.replace("&gt;",">");
		FormModeBrowserSqlwhere fbs = new FormModeBrowserSqlwhere();
		expendMap = fbs.get(expendattr, _fieldid);
		//out.print(jsonObject.toString());
	}
	JSONObject jsonObject = JSONObject.fromObject(expendMap);
    jsonObject.put("formmodefieldid",fieldid);
	//out.flush();
	//out.close();
%>
<%=jsonObject.toString() %>
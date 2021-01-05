<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ExcelLayoutManager" class="weaver.workflow.exceldesign.ExcelLayoutManager" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
int formid = Util.getIntValue(request.getParameter("formid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
String selIds = Util.null2String(request.getParameter("systemIds"));
//String selfieldid = Util.null2String(request.getParameter("selfieldid"));
//System.err.println(selfieldid+"  |  "+selIds);
String search_fieldname = "";
if("src".equalsIgnoreCase(src))
	search_fieldname = Util.null2String(request.getParameter("search_fieldname"));

ArrayList<Map<String,String>> textfield = ExcelLayoutManager.getTextFieldList(formid, isbill, user.getLanguage(), search_fieldname);
JSONArray jsonArr = new JSONArray();
if("src".equalsIgnoreCase(src)){
	for(Map<String,String> map: textfield){
		String fieldid = map.get("fieldid");
		String fieldname = map.get("fieldname");
		if((","+selIds+",").indexOf(","+fieldid+",") == -1){
			JSONObject tmp = new JSONObject();
			tmp.put("id", fieldid);
			if("sys".equals(map.get("fieldtype")))
				tmp.put("name", "<span class=\"fieldname\">"+fieldname+"</span></br>"+SystemEnv.getHtmlLabelName(468, user.getLanguage())+"");
			else
				tmp.put("name", "<span class=\"fieldname\">"+fieldname+"</span></br>"+SystemEnv.getHtmlLabelName(19532, user.getLanguage())+"");
			jsonArr.add(tmp);
		}
	}
}else if("dest".equalsIgnoreCase(src)){
	String[] selIdArr = selIds.split(",");
	for(String selid: selIdArr){
		for(Map<String,String> map: textfield){
			String fieldid = map.get("fieldid");
			String fieldname = map.get("fieldname");
			if(selid.equals(fieldid)){
				JSONObject tmp = new JSONObject();
				tmp.put("id", fieldid);
				if("sys".equals(map.get("fieldtype")))
					tmp.put("name", "<span class=\"fieldname\">"+fieldname+"</span></br>"+SystemEnv.getHtmlLabelName(468, user.getLanguage())+"");
				else
					tmp.put("name", "<span class=\"fieldname\">"+fieldname+"</span></br>"+SystemEnv.getHtmlLabelName(19532, user.getLanguage())+"");
				jsonArr.add(tmp);
				break;
			}
		}
	}
}
JSONObject json = new JSONObject();
json.put("currentPage", 1);
json.put("totalPage", 1);
json.put("mapList", jsonArr.toString());
out.println(json.toString());
%>
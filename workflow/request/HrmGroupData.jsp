<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.browserData.FieldBrowser"%>
<%@page import="weaver.general.browserData.CategoryBrowser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>

<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.hrm.group.HrmGroupTreeComInfo"%>
<%@page import="net.sf.json.JSONObject"%>

<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String result = ""; 
int isgetallres = Util.getIntValue(Util.null2String(request.getParameter("isgetallres")), 0);

HrmGroupTreeComInfo hrmgrpcominfo = new HrmGroupTreeComInfo();

if (isgetallres == 1) {
    String[] allresourceArray = hrmgrpcominfo.getResourceAll(user);
    Map<String, String> allresmap = new HashMap<String, String>();
    //allresmap.put("type", "9");
    //allresmap.put("typename", ""+SystemEnv.getHtmlLabelName(1340,user.getLanguage()));

    if (allresourceArray != null && allresourceArray.length > 0) {
        allresmap.put("ids", allresourceArray[0]);
        if (allresourceArray[0] != null) {
            allresmap.put("count", allresourceArray[0].split(",").length + "");
        }
    }
    
    result = JSONObject.fromObject(allresmap).toString();
} else {
	List<Map<String, String>> grouplist = hrmgrpcominfo.getHrmGroup(user);
	if (grouplist != null && grouplist.size() > 0) {
	    result = JSONArray.fromObject(grouplist).toString();
	}else{
		Map<String, String> allresmap = new HashMap<String, String>();
		allresmap.put("count","1");
	    result = JSONObject.fromObject(allresmap).toString();
	}
}
out.print(result);
%>
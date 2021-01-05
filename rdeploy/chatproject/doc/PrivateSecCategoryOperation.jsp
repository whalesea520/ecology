<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.rdeploy.doc.PrivateFolderCacheManager" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryid = Util.null2String(request.getParameter("categoryid"));
	String message = "";
	RecordSet rs = new RecordSet();
	int cateint = Integer.parseInt(categoryid);
    String checksql = "select id from docdetail where docVestIn = 1 and seccategory=" + cateint*-1;
    rs.executeSql(checksql);
    if (rs.next()) {
        message = "87";
    } else {
        rs.executeSql("select id from DocPrivateSecCategory where parentid = " + categoryid);
        if (rs.next()) {
            message = "87";
        }
    }
    Map<String,String> result = new HashMap<String,String>();
    if(message.isEmpty())
    {
       boolean flag =  rs.executeSql("delete DocPrivateSecCategory where id = " + categoryid);
       if(flag)
       {
           PrivateFolderCacheManager.clearAll();
       }
        result.put("error", flag ? "-1" : "1");
    }
    else
    {
    	result.put("error", "87");
    }
    JSONObject jsonObject = JSONObject.fromObject(result);
    out.println(jsonObject.toString());
    
%>
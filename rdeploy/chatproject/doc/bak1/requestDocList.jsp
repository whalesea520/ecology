<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.json.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String doctitle = Util.null2String(request.getParameter("doctitle"));
	String createrid = Util.null2String(request.getParameter("createrid"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String seccategory = Util.null2String(request.getParameter("seccategory"));
	String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
	String createdateto = Util.null2String(request.getParameter("createdateto"));
	String searchtype = Util.null2String(request.getParameter("searchtype"));
	
	int pageNo = Util.getIntValue(request.getParameter("pageNo"));
	int pageSize = Util.getIntValue(request.getParameter("pageSize"));
	
	Map<String,String> params = new HashMap<String,String>();
	params.put("doctitle",doctitle);
	params.put("createrid",createrid);
	params.put("departmentid",departmentid);
	params.put("seccategory",seccategory);
	params.put("createdatefrom",createdatefrom);
	params.put("createdateto",createdateto);
	params.put("searchtype",searchtype);
	int docCount = multiAclManager.getCount(user,params);
	String docs = multiAclManager.getDocListStr(user,params,pageNo,pageSize,docCount);
	JSONObject obj = new JSONObject();
	obj.put("docList",docs);
	obj.put("docCount",docCount);
	out.println(obj.toString());
%>

<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="cptgroup" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.print("[]");
}
int userid=user.getUID();

String urlType=Util.null2String(request.getParameter("urlType"));
//System.out.println("urltype:"+urlType);


JSONArray arr=new JSONArray();
JSONObject obj=new JSONObject();

String sql="select companyname,companyid,archivenum from CPCOMPANYINFO where isdel='T' and  businesstype != 8  order by  archivenum ,companyid ";
rs.executeSql(sql);

while(rs.next()){
	obj=new JSONObject();
	String id=Util.null2String( rs.getString("companyid"));
	String companyname=Util.null2String( rs.getString("companyname"));
	String archivenum=Util.null2String( rs.getString("archivenum"));
	
	JSONObject attr=new JSONObject();
	attr.put("groupid", id);
	
	JSONObject numbers=new JSONObject();
	
	obj.put("id",id);
	obj.put("name","["+archivenum+"]"+companyname );
	obj.put("pid", "0");
	obj.put("attr", attr);
	obj.put("numbers", numbers);
	obj.put("submenus", new JSONArray());
	obj.put("hasChildren", false);
		
	arr.add(obj);
}


//System.out.println("arr:======="+arr.toString());

out.print(arr.toString());
%>



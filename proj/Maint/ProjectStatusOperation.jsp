<%@page import="java.util.UUID"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
JSONObject jsonInfo=new JSONObject();
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
double dsporder = Util.getDoubleValue(request.getParameter("dsporder"),0.0);

if (method.equals("add"))
{
	//char flag=2;
	//RecordSet.executeProc("Prj_ProjectStatus_Insert",type+flag+desc);
	int labelid=LabelUtil.getLabelId(type, user.getLanguage());
	String guid1=UUID.randomUUID().toString();
	String sql="insert into Prj_ProjectStatus(guid1,fullname,description,summary,dsporder) values('"+guid1+"','"+labelid+"','"+type+"','"+desc+"','"+dsporder+"')";
	RecordSet.executeSql(sql);
	ProjectStatusComInfo.removeProjectStatusCache();
	RecordSet.executeSql("select id from workflow_browdef_fieldconf where fieldtype in(8,135) and fieldname='status'");
	while(RecordSet.next()){
		int configid=RecordSet.getInt("id");
		RecordSet2.executeSql("insert into workflow_browdef_selitemconf(configid,browsertype,namelabel,value,showorder) select "+configid+",0,fullname,id,dsporder from Prj_ProjectStatus where guid1='"+guid1+"' ");
	}
	
	
	out.print(jsonInfo.toString());
}
else if (method.equals("edit"))
{
	//char flag=2;
	//RecordSet.executeProc("Prj_ProjectStatus_Update",id+flag+type+flag+desc);
	int labelid=LabelUtil.getLabelId(type, user.getLanguage());
	String sql="update Prj_ProjectStatus set fullname='"+labelid+"',description='"+type+"',summary='"+desc+"',dsporder='"+dsporder+"'  where id="+id;
	RecordSet.executeSql(sql);
	ProjectStatusComInfo.removeProjectStatusCache();
	RecordSet.executeSql("update workflow_browdef_selitemconf set namelabel='"+labelid+"',showorder='"+dsporder+"'  where configid in(select id from workflow_browdef_fieldconf where fieldtype in(8,135) and fieldname='status') and value='"+id+"' ");
	
	out.print(jsonInfo.toString());
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("Prj_ProjectStatus_Delete",id);
	ProjectStatusComInfo.removeProjectStatusCache();
	RecordSet.executeSql("delete workflow_browdef_selitemconf where configid in(select id from workflow_browdef_fieldconf where fieldtype in(8,135) and fieldname='status') and value='"+id+"' ");
	
	out.print(jsonInfo.toString());
}else if (method.equals("batchdelete")){
	
	JSONArray referencedArr = new JSONArray() ;
	
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);
		
	    /**RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where issystem!='1' and status = "+id1);
	    if (RecordSet.next()) {
	        if (!RecordSet.getString(1).equals("0")){
	        	referencedArr.put(ProjectStatusComInfo.getProjectStatusdesc(""+id1));
	        	continue;
	        }
	    }**/
	    
		RecordSet.executeProc("Prj_ProjectStatus_Delete",id1);
		RecordSet.executeSql("delete workflow_browdef_selitemconf where configid in(select id from workflow_browdef_fieldconf where fieldtype in(8,135) and fieldname='status') and value='"+id1+"' ");
		
	}
	
	ProjectStatusComInfo.removeProjectStatusCache();
	if(referencedArr.length()>0){
		jsonInfo.put("referenced", referencedArr);
	}
	
	out.print(jsonInfo.toString());
    
}
else
{
	//response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
//response.sendRedirect("/proj/Maint/ListProjectStatus.jsp");
%>
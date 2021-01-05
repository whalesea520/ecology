<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
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
String worktypecode = Util.null2String(request.getParameter("txtWorktypecode"));
String dsporder = ""+Util.getDoubleValue(request.getParameter("dsporder"),0);
if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_WorkType_Insert",type+flag+desc+flag+worktypecode+flag+dsporder);

	WorkTypeComInfo.removeWorkTypeCache();
	out.print(jsonInfo.toString());
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_WorkType_Update",id+flag+type+flag+desc+flag+worktypecode+flag+dsporder);

	WorkTypeComInfo.removeWorkTypeCache();
	out.print(jsonInfo.toString());
}
else if (method.equals("delete"))
{
    //modify by dongping for TD698
    //在项目库里查一下此工作类型是否被引用,如果被引用就不能删除此工作类型	
	String referenced = "" ;
    RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where worktype = "+id);
    if (RecordSet.next()) {
        if (!RecordSet.getString(1).equals("0"))
            referenced = "yes" ;
    }
    
    if (referenced.equals("yes")) {
       //response.sendRedirect("/proj/Maint/EditWorkType.jsp?id="+id+"&referenced="+referenced); 
       //return ;
	} else {
	    RecordSet.executeProc("Prj_WorkType_Delete",id);
	}
	
	WorkTypeComInfo.removeWorkTypeCache();
	out.print(jsonInfo.toString());
}else if (method.equals("batchdelete")){
	JSONArray referencedArr = new JSONArray() ;
	
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);
		
		
	    RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where worktype = "+id1);
	    if (RecordSet.next()) {
	        if (!RecordSet.getString(1).equals("0")){
	        	referencedArr.put(WorkTypeComInfo.getWorkTypename(""+id1));
	        	continue;
	        }
	    }
	    
		RecordSet.executeProc("Prj_WorkType_Delete",id1);
		
	}
	
	WorkTypeComInfo.removeWorkTypeCache();
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
//response.sendRedirect("/proj/Maint/ListWorkType.jsp");
%>
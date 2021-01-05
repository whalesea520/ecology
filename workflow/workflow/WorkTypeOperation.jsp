
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%

	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String dialog = Util.null2String(request.getParameter("dialog"));
String typeids = Util.null2String(request.getParameter("typeids"));
int dsporder = Util.getIntValue(request.getParameter("dsporder"),0);

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("workflow_wftype_Insert",type+flag+desc+flag+dsporder);
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("workflow_wftype_Update",""+id+flag+type+flag+desc+flag+dsporder);
	
}
else if (method.equals("delete"))
{
	String sql = "delete from workflow_type where id = "+id;
	RecordSet.executeSql(sql);
	
}
else if (method.equals("deles"))
{
	String sql = "delete from workflow_type where id in("+typeids.substring(0,typeids.length()-1)+")";
	RecordSet.executeSql(sql);
	
}else if(method.equals("valRepeat")){   //验证类型名称是否重复
	String sql = "select id  from workflow_type where typename='"+type+"'";
	RecordSet.executeSql(sql);
	boolean isExist=false;
	if(id!=null){
		while(RecordSet.next()){
			if(!id.equals(""+RecordSet.getInt("id"))){
				isExist=true;
			}
		}
	}else{	
		if(RecordSet.next())
			isExist=true;
	}
	
	if(isExist)
		out.print("<script>parent.typeExist();</script>");  //类型名称已存在
	else
		out.print("<script>parent.submitForm();</script>"); //类型名称不存在 提交form
}

if(!method.equals("valRepeat")){
	  WorkTypeComInfo.removeWorkTypeCache();
	  if("1".equals(dialog)){
	  	if(method.equals("add"))
	  		response.sendRedirect("AddWorkType.jsp?isclose=1");
	  	else
	  		response.sendRedirect("EditWorkType.jsp?isclose=1&id="+id);
	  }else{
	  	response.sendRedirect("ListWorkTypeTab.jsp");
	  }
	  
	}
%>
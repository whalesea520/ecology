
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page" />
<jsp:useBean id="Calculate" class="weaver.cpt.maintenance.Calculate" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id = Util.getIntValue(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String timelimit = Util.fromScreen(request.getParameter("timelimit"),user.getLanguage());
String startunit = Util.fromScreen(request.getParameter("startunit"),user.getLanguage());
String endunit = Util.fromScreen(request.getParameter("endunit"),user.getLanguage());
String deprefunc = Util.fromScreen(request.getParameter("deprefunc"),user.getLanguage());

//判断折旧表达式是否有效
String tempval = "";
if((operation.equals("add"))||(operation.equals("edit"))){
	StringBuffer strBuf = new StringBuffer(deprefunc);
	for(int i=0;i<strBuf.length();i++){
		if((strBuf.charAt(i)=='t')&&(i!=strBuf.length()-1)){
			if(strBuf.charAt(i+1)=='t'){
				if(id<0){
					response.sendRedirect("CptDepreMethod1Add.jsp?wrongfunc=-1");
				}
				else{
					response.sendRedirect("CptDepreMethod1Edit.jsp?id="+id+"&wrongfunc=-1");
				}
			}
		}
	}
	for(int i=0;i<11;i++){
		tempval = ""+i*0.1;
		for(int j=0;j<strBuf.length();j++){
			if(strBuf.charAt(j)=='t'){
				strBuf.replace(j,j+1,"("+tempval+")");
			}
		}
		double retval = Calculate.calculate(strBuf.toString());
		out.print("::"+strBuf.toString());
		out.print("$"+retval+"$\n");
		if (retval<0){
			if(id<0){
			response.sendRedirect("CptDepreMethod1Add.jsp?wrongfunc=-1");
			}
			else{
			response.sendRedirect("CptDepreMethod1Edit.jsp?id="+id+"&wrongfunc=-1");
			}
 		}
		Calculate.clearAll();
		strBuf.replace(0,strBuf.length(),deprefunc);
	}

}


if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("CptDepreMethod1Add:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = "";
	para = name;
	para += separator + description;
	para += separator + "1";
	para += separator + timelimit;
	para += separator + startunit;
	para += separator + endunit;
	para += separator + deprefunc;
	RecordSet.executeProc("CptDepreMethod1_Insert",para);
	int tempid=0;
	
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+tempid);
	}
     
	DepreMethodComInfo.removeDepreMethodCache();
 	response.sendRedirect("CptDepreMethod.jsp");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("CptDepreMethodEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;

  	String para = ""+id;
	para += separator + name;
	para += separator + description;
	para += separator + "1";
	para += separator + timelimit;
	para += separator + startunit;
	para += separator + endunit;
	para += separator + deprefunc;	
	
	RecordSet.executeProc("CptDepreMethod1_Update",para);
	
      DepreMethodComInfo.removeDepreMethodCache();
	  response.sendRedirect("CptDepreMethod.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CptDepreMethodEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
	String para = ""+id;
	RecordSet.executeProc("CptDepreMethod1_Delete",para);
	
	DepreMethodComInfo.removeDepreMethodCache();
 	response.sendRedirect("CptDepreMethod.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.GCONST"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="FileSecurityTool" class="weaver.hrm.common.FileSecurityTool" scope="page" ></jsp:useBean>
<%
/*已在外部控制
if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}*/

  String importStatus=(String)session.getAttribute("importStatus");
 
 //设置读取下标，避免重复读取
 int index=Integer.parseInt(request.getParameter("index"));
 if("importing".equals(importStatus)||"over".equals(importStatus)){
   List resultList=(List)session.getAttribute("resultList");
     if(resultList!=null){
       for(;index<resultList.size();index++){
       	String flag = ((String)resultList.get(index)).split("\\|")[0];
       	String result = ((String)resultList.get(index)).split("\\|")[1];
       %>
       <TR class=DataLight>
		   	<TD width="10%" style="color: <%=flag.equals("true")?"":"red" %>;"><%=flag.equals("true")?"成功":"失败"%></TD>
		    <TD width="55%"><%=result %></TD>
       </TR>
    <%}
		} 
    if("over".equals(importStatus)){
 	   String logFile=(String)session.getAttribute("logFile");
 	   if(logFile!= null && logFile.indexOf(GCONST.getRootPath().replace("\\","/")) > -1){
 	   		logFile = logFile.substring(GCONST.getRootPath().replace("\\","/").length());
 	   }
		 out.println("<script>callback('ok','"+FileSecurityTool.put(logFile)+"');</script>"); 
		 session.removeAttribute("importFlag");
		 session.removeAttribute("resultList");
		 session.removeAttribute("logFile");
   }
    out.println("<script>changeIndex("+index+");</script>"); 
	}
%>
      
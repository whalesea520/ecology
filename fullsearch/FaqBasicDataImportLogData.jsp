<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%

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
		   	<TD width="10%" style="color: <%=flag.equals("true")?"":"red" %>;"><%=flag.equals("true")?SystemEnv.getHtmlLabelName(84565,user.getLanguage()):SystemEnv.getHtmlLabelName(84566,user.getLanguage())%></TD> 
		    <TD width="55%"><%=result %></TD>
       </TR>
    <%}
		} 
    if("over".equals(importStatus)){
 	   String logFile=(String)session.getAttribute("logFile");
		 out.println("<script>callback('ok','"+logFile+"');</script>"); 
		 session.removeAttribute("importFlag");
		 session.removeAttribute("resultList");
		 session.removeAttribute("logFile");
   }
    out.println("<script>changeIndex("+index+");</script>"); 
	}
%>
      
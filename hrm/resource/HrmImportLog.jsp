<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.join.hrm.in.ImportLog"%>
<jsp:useBean id="FileSecurityTool" class="weaver.hrm.common.FileSecurityTool" scope="page" ></jsp:useBean>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

   //importStatus 导入状态 在hrmImportProcess.jsp中设置
   String importStatus=(String)session.getAttribute("importStatus");
   
   String keyField=(String)session.getAttribute("keyField");
   
   //设置读取下标，避免重复读取
   int index=Integer.parseInt(request.getParameter("index"));
   if("importing".equals(importStatus)||"over".equals(importStatus)){
	   List  resultList=(List)session.getAttribute("resultList");
       if(resultList!=null){
   %>
      <%
         ImportLog log;
         for(;index<resultList.size();index++){
        	 log=(ImportLog)resultList.get(index);
      %>
	       		<TR class=DataLight>
			        <TD width="10%">
			        <%               //只需要关键字段列
			                         if(keyField.equals("workcode"))
			                        	 out.print(log.getWorkCode());
			                         else if(keyField.equals("loginid"))
			                        	 out.print(log.getLoginid());
			                         else if(keyField.equals("lastname"))
			                        	 out.print(log.getLastname()); 
			        %>
			        </TD>
			        <TD width="55%" style="word-break:break-all;"><%=log.getDepartment()%></TD>
					<TD width="10%"><%if(log.getOperation().equals("创建")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%><%}%></TD>
					<TD width="25%" <%if(log.getStatus().equals("失败")) out.print("style='color: red'");else out.print("style='color: blue'");%>>
					<%if(log.getStatus().equals("失败")){%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%><%}%><br>
					<%if(!log.getReason().equals("")) out.print(log.getReason());%>
					</TD>
               </TR>
      <%
      }
         if("over".equals(importStatus)){
	 	     String logFile=(String)session.getAttribute("logFile");
			 out.println("<script>callback('ok','"+FileSecurityTool.put(logFile)+"');</script>"); 
			 session.removeAttribute("importFlag");
			 session.removeAttribute("resultList");
			 session.removeAttribute("logFile");
	   }
      out.println("<script>changeIndex("+index+");</script>"); 
       }
   }
   
   else if("error".equals(importStatus)){
	   List errorInfo=(List)session.getAttribute("errorInfo");
       if(errorInfo!=null&&!errorInfo.isEmpty()){
      %>
  <!-- 错误提示 -->
  <table class=viewform >
    <tbody> 
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%></td>
      <td style="color: red">
      <%
      //输出错误提示 
        for(int i=0;i<errorInfo.size();i++){
        	String msg=(String)errorInfo.get(i);
        	out.print(msg+"<br>");
        }
      %>
      </td>
    </tr> 
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
    </tbody> 
  </table>
  <%
     out.println("<script>callback('error')</script>"); 
     session.removeAttribute("errorInfo");
    }
   } 
  %>

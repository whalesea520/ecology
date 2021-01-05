<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.join.hrm.in.ImportLog"%>
<jsp:useBean id="FileSecurityTool" class="weaver.hrm.common.FileSecurityTool" scope="page" ></jsp:useBean>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	//if (!HrmUserVarify.checkUserRight("Matrix:Maint",
	//		user)) {
	//	response.sendRedirect("/notice/noright.jsp");
	//	return;
	//}
%>
<%
   StaticObj staticObj=StaticObj.getInstance();

   //importStatus 导入状态 在hrmImportProcess.jsp中设置
   String importStatus=(String)staticObj.getObject("matrixImportStatus");
   
   //设置读取下标，避免重复读取
   int index=Integer.parseInt(request.getParameter("index"));
   if("importing".equals(importStatus)||"over".equals(importStatus)){
	   List  resultList=(List)staticObj.getObject("matrix_resultList");
       if(resultList!=null){
   %>
      <%
         for(;index<resultList.size();index++){
        	Map log=(Map)resultList.get(index);
      %>
	       		<TR class=DataLight>
					<TD width="25%" <%if(log.get("status").equals("error")) out.print("style='color: red'");else out.print("style='color: blue'");%>>
						<%=log.get("status").equals("error")?SystemEnv.getHtmlLabelName(498, user.getLanguage()):SystemEnv.getHtmlLabelName(25008, user.getLanguage())%><br>
					</TD>
			        <TD width="75%">
			        	<%=log.get("msg") %>
			        </TD>
               </TR>
      <%
      }
     }
   }
         if("over".equals(importStatus)){
	 	     String logFile=(String)staticObj.getObject("matrixLogFile");
			 out.println("<script>callback('ok','"+FileSecurityTool.put(logFile)+"');</script>"); 
			 staticObj.removeObject("matrixImportStatus");
			 staticObj.removeObject("matrix_resultList");
			 staticObj.removeObject("matrixLogFile");
	  	 }
         else if("error".equals(importStatus)){
		   List errorInfo=(List)staticObj.getObject("matrix_errorInfo");
	       if(errorInfo!=null&&!errorInfo.isEmpty()){
	    %>
  <!-- 错误提示 -->
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td width="25%"><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%></td>
      <td style="color: red;" width="75%">
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
  <%
     out.println("<script>callback('error')</script>"); 
     staticObj.removeObject("matrix_errorInfo");
    }
   } %>

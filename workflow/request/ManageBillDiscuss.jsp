

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillDiscussOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

    <%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>
	 <%if(!nodetype.equals("0")&&userid==creater){%>
		  <TABLE class="viewform" cellpadding="0" cellspacing="0" border="1">
		  <COLGROUP> 
		  <COL width="20%"> 
		  <COL width="80%"> 
		  <td><%=SystemEnv.getHtmlLabelName(16310,user.getLanguage())%></td>
		  <%
		  String endFieldName = "" ;
		  for(int i=0;i<fieldids.size();i++){         // 循环开始
			  endFieldName = (String)fieldnames.get(i) ;
			  if (endFieldName.equals("isend")) {endFieldName = "field" + (String)fieldids.get(i) ;
			  break;
			  }
			  
		  }
		  %>
		  <td class=field><input type=checkbox name="isend" value='1' onclick='isEndCheck("<%=endFieldName%>")' >
		  </td>
		  </table>
	  <%}%>
	<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
	
	<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
    <input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

</form>
<script language="">
function isEndCheck(endFieldName)
{ 
  if (document.all("isend").checked)
	  document.all(endFieldName).value = "1" ;
  else
	  document.all(endFieldName).value = "0" ;
}
</script>
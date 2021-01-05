
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<!-- 明细样式 -->
<link href="/css/ecology8/workflowdetail_wev8.css" type="text/css" rel="stylesheet">
<form name="frmmain" method="post" action="BillWeekWorkinfoOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="canactive" value="<%=canactive%>" />
                <jsp:param name="deleted" value="<%=deleted%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="logintype" value="<%=user.getLogintype()%>" />
                <jsp:param name="userid" value="<%=user.getUID()%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
            </jsp:include>
	<table class="viewform" style="width:100%">
    <colgroup> <col width="20%"> <col width="80%"> 
	
	 <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(20561,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">

      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 >
	      <COLGROUP> 
	      <COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
		  <%int userids=user.getUID();
		     String resourceidown="0";
			rs.execute("select resourceid from bill_workinfo where requestid="+requestid);
			if (rs.next())
			{
			resourceidown=rs.getString(1);
			}
			
		  if (rs.getDBType().equals("oracle"))
		  {
		   rs.execute("select * from bill_weekinfodetail where  type=3 and infoid=(select id from (select  b.* from bill_workinfo b,bill_weekinfodetail a where a.infoid=b.id and a.type=3 and b.resourceid="+resourceidown+" and requestid<"+requestid+"  order by requestid desc) where rownum=1 ) order by id");
		  }
		  else
		  {
		  rs.execute("select * from bill_weekinfodetail where type=3 and infoid=(select  top 1 b.id  from bill_weekinfodetail a,bill_workinfo b where a.type=3 and a.infoid=b.id and   b.resourceid="+resourceidown+" and requestid<"+requestid+" order by requestid desc) order by id");
		  }
		  boolean islights=true;
		  while (rs.next())
		  {
		  
			String curworknameold=rs.getString("workname");
    		String curdateold=rs.getString("forecastdate");
    		String curworkdescold=rs.getString("workdesc");
			%>
		  <tr class="wfdetailrowblock">
		
		  <td> <%=Util.toScreenToEdit(curworknameold,user.getLanguage())%></td>
		  <td><%=Util.toScreenToEdit(curdateold,user.getLanguage())%></td>
		   <td><%=Util.toScreenToEdit(curworkdescold,user.getLanguage())%></td>
		  </tr>
<%
    		islights=!islights;
    	
    	}
	
%>
	
	    </table>
	   </td></tr></table></td></tr>
  	   <tr><td height=15></td></tr>
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15493,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 完成事项 -->

	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16280,user.getLanguage())%></td>
	      </tr>
		 
<%	boolean islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    <tr class="Title">
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 未完成事项 -->
   
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16281,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15497,user.getLanguage())%></td>
	      </tr>	  
<%	islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15498,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 下周计划事项 -->

	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=4 id="oTable3">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr> 	 
<%	islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"3");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curdate=RecordSet.getString("forecastdate");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curdate,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
      </td>
    </tr>  
  </table>
  <br>
  <br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

</body>
</html>

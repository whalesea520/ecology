<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
//Param


String id = request.getParameter("id");
String sqlstr = "select a.* from HrmPerformanceGoalStd a  left join HrmPerformanceGoal b on a.goalId=b.id where b.id="+id ;
RecordSet.executeSql(sqlstr);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="myGoalBrowserForPlan.jsp" method=post>
		
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->

<tr width="100%">
<td width="60%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0">
		<TR class=DataHeader>
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	  <TH width=60%><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></TH>
   
	  <TR class=Line><Th colspan="3" ></Th></TR>

		<tr>
		<td colspan="2" width="100%">
			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="40%">
			<COL width="60%">
			
				<%
				int i=0;
				int totalline=1;
				while (RecordSet.next()){
					
					String requestids = RecordSet.getString("id");
					String requestnames = Util.toScreen(RecordSet.getString("stdName"),user.getLanguage());
				    String point= RecordSet.getString("point");
					if(i==0){
						i=1;
				%>
					<TR class=DataLight onclick="javascript:btnok_click(<%=point%>,'<%=requestnames%>')">
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark onclick="javascript:btnok_click(<%=point%>,'<%=requestnames%>')">
					<%
					}
					%>
		            <TD><%=requestnames%></TD>
					<TD><%=point%></TD>
				</TR>
				<%}%>
		</table>
					
			</div>
		</td>
	</tr>
	</TABLE>
</td>

</tr>

	</FORM>

		</td>
		</tr>
		</TABLE>
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>
<script type="text/javascript">
function btnclear_onclick(){
     window.parent.returnValue =new Array("","");
     window.parent.close();
}


function btnok_click(a,b){ 
	 window.parent.returnValue =new Array(a,b);
     window.parent.close();
}
</script>
<script language="javascript" for="BrowseTable" event="onmouseover">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		trObj.className ="Selected";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		trObj.className = "Selected";
	}
</script>

<script language="javascript" for="BrowseTable" event="onmouseout">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		if(trObj.rowIndex%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		if(trObj%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}
</script>



<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="job" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />

<html>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%

int tuserid = user.getUID();
RecordSet rs  = new RecordSet();

String sql = "select belongto from Hrmresource where  id='"+tuserid+"' ";
rs.execute(sql);
rs.next();
String tm = rs.getString("belongto");
if(tm.equals("")||tm.equals("0")||tm.equals("-1")){

}else{
	tuserid = rs.getInt("belongto");
}
sql =" select id,lastname,departmentid,jobtitle  from Hrmresource where id ='"+tuserid+"' or   belongto = '"+tuserid+"' and status<>'5' order by id ";

//out.println("select id,lastname,departmentid  from Hrmresource where id ='"+userid+"' or   belongto = '"+userid+"' order by id ");

rs.execute(sql);

String workflow = (String)valueList.get(nameList.indexOf("workflow"));
String workplan = (String)valueList.get(nameList.indexOf("workplan"));
String meeting = (String)valueList.get(nameList.indexOf("meeting"));
String mail = (String)valueList.get(nameList.indexOf("mail"));

String imgSymbol="";
if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";


%>

<table id="_contenttable_<%=eid%>" class="Econtent elementdatatable" width=100%>
<%
while(rs.next()){
	int size=1;
	%>
		<tr>
			<TD width="8"><%=imgSymbol%></TD>
			<td style="" width="*" >
				<a href="javascript:openhrm(<%=rs.getString("id") %>)" onclick="pointerXY(event);" ><font class=font style="cursor: pointer;" ><%=dci.getDepartmentname(rs.getString("departmentid"))+"/"+job.getJobTitlesname(rs.getString("jobtitle"))%></font></a>
			</td>
			
			<%
			if(workflow.equals("1")){
				%>
				<td width="80px;">
				<%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%>&nbsp;(<span style="color:red;margin-left:4px" url="/page/element/jobsinfo/wfinfo.jsp?userid=<%=rs.getString("id")%>" class="info">?</span>)
				</td>
				<%
				size++;
			}
			if(meeting.equals("1")){
				%>
				<td width="80px;">
				<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>&nbsp;(<span style="color:red;margin-left:4px" url="/page/element/jobsinfo/meetinginfo.jsp?userid=<%=rs.getString("id")%>" class="info">?</span>)
				</td>
				<%
				size++;
			}
			if(workplan.equals("1")){
				%>
				<td width="80px;">
				<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>&nbsp;(<span style="color:red;margin-left:4px" url="/page/element/jobsinfo/workplaninfo.jsp?userid=<%=rs.getString("id")%>" class="info">?</span>)
				</td>
				<%
				size++;
			}
			if(mail.equals("1")){
				%>
				<td width="80px;">
				<%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>&nbsp;(<span style="color:red;margin-left:4px" url="/page/element/jobsinfo/mailinfo.jsp?userid=<%=rs.getString("id")%>" class="info">?</span>)
				</td>
				<%
				size++;
			}
			%>
				
			
			
		</tr>
		 <TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=<%=size+1%>></td></TR>
	<%
}

%>
<table>
<script type="text/javascript">
	$(".info").each(function(){
		$(this).load($(this).attr("url")+"&t="+new Date().getTime())
	});
</script>

<style type="text/css">
	tr{
		height:20px;
	}
</style>
</body>
</html>


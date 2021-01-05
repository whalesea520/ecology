
<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.hrm.*,weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response);
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-disposition","attachment;filename="+new String(SystemEnv.getHtmlLabelName(25106,user.getLanguage()).getBytes("gb2312"), "ISO8859-1" )+".xls");

if(user == null)  return ;
String sqlwhere = Util.null2String(request.getParameter("s"));
int iStatus = -1;
int labelId = -1;
//System.out.println(sqlwhere);

rs.executeSql("SELECT t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.manager,t1.department,t1.status FROM Prj_ProjectInfo t1 "+sqlwhere+" ORDER BY t1.id DESC");
%>
<html>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title></title>
<head>
<style>
<!--
td,div{font-size:12px}
.thead{font-weight:bold;background:silver}
/*
table.tbl{background-color:;width:100%;border-collapse:collapse;border:1px solid #000}
table.tbl td{background-color:#FFF;padding:4px;border:1px solid #000}
.title{font-weight:bold;font-size:20px;text-align:center;margin:10px 0 10px 0}
br{mso-data-placement:same-cell;}
*/
-->
</style>
</head>
<body>
<table border="1">
<tr>
<td class="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
<td class="thead"><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></td>
</tr>
<%
while(rs.next()){
	iStatus = Util.getIntValue(rs.getString("status"));
%>
<tr>
<td><%=rs.getString("name")%></td>
<td style="vnd.ms-excel.numberformat:@"><%=rs.getString("procode") %></td>
<td><%=ProjectTypeComInfo.getProjectTypename(rs.getString("prjtype"))%></td>
<td><%=WorkTypeComInfo.getWorkTypename(rs.getString("worktype"))%></td>
<td><%=ResourceComInfo.getResourcename(rs.getString("manager"))%></td>
<td><%=DepartmentComInfo.getDepartmentname(rs.getString("department"))%></td>
<td><%switch(iStatus){
	case 0: labelId=220;	break;
	case 1: labelId=225;	break;
	case 2: labelId=2244;	break;
	case 3: labelId=555;	break;
	case 4: labelId=1232;	break;
	case 5: labelId=2243;	break;
	case 6: labelId=2242;	break;
	case 7: labelId=1010;	break;
}
if(labelId!=-1){
	out.print(SystemEnv.getHtmlLabelName(labelId, user.getLanguage()));
}%></td>
</tr>
<%}%>
</table>

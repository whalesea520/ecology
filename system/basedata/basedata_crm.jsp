<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String crmname=Util.fromScreen(request.getParameter("crmname"),user.getLanguage());
String managerid=Util.fromScreen(request.getParameter("managerid"),user.getLanguage());
String typeid=Util.fromScreen(request.getParameter("typeid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
if(departmentid.equals("0"))    departmentid="";
if(typeid.equals("0"))    typeid="";
%>
<BODY>
<DIV class=HdrProps align=center>
 <font size=4><b> 
<br><%=SystemEnv.getHtmlLabelName(15055,user.getLanguage())%><br></b></font>
</DIV>
<form action="basedata_crm.jsp" method="post" name="frmmain">
<div><button class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button></div>
<table class=form>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></td>
    <td width="35%" class=field>
    <INPUT class=saveHistory type=text name=crmname style="width:80%" value=<%=crmname%>>
    </td>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></td>
    <td width="35%" class=field><BUTTON class=Browser onClick="onShowType()"></BUTTON> 
    <span id=typespan><%=CustomerTypeComInfo.getCustomerTypename(typeid)%></span> 
    <INPUT class=saveHistory type=hidden name=typeid value=<%=typeid%>>
    </td>
  </tr>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td width="35%" class=field><BUTTON class=Browser onClick="onShowManager()"></BUTTON> 
    <span id=managerspan><%=ResourceComInfo.getResourcename(managerid)%></span> 
    <INPUT class=saveHistory type=hidden name=managerid value=<%=managerid%>>
    </td>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td width="15%" class=field><BUTTON class=Browser onClick="onShowDepartment()"></BUTTON> 
    <span id=departmentspan><%=DepartmentComInfo.getDepartmentname(departmentid)%></span> 
    <INPUT class=saveHistory type=hidden name=departmentid value=<%=departmentid%>>
    </td>
  </tr>
</table>
</form>
<script language=vbs>
sub onShowManager()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	managerspan.innerHtml = id(1)
	frmmain.managerid.value=id(0)
	else 
	managerspan.innerHtml = ""
	frmmain.managerid.value=""
	end if
	end if
end sub
sub onShowType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	typespan.innerHtml = id(1)
	frmmain.typeid.value=id(0)
	else 
	typespan.innerHtml = ""
	frmmain.typeid.value=""
	end if
	end if
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	departmentspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else 
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
</script>
<TABLE class=ListShort border=1>
  <COLGROUP>
  <COL width="40%"><COL width="20%"><COL width="20%"><COL width="20%">
  <TBODY>
  <TR class=separator>
    <TD class=Sep1 colSpan=4 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
<%
boolean islight=true ;
String sql = "select t1.*,t2.fullname from crm_customerinfo t1, crm_customertype t2 "+
            " where t1.deleted=0  and t1.type=t2.id ";
if(!crmname.equals("")) 
    sql+=" and t1.name like '%"+Util.fromScreen2(crmname,7)+"%'" ;
if(!departmentid.equals(""))
    sql+= " and t1.department="+departmentid ;
if(!managerid.equals(""))
    sql+= " and t1.manager="+managerid ;
if(!typeid.equals(""))
    sql+= " and t2.id="+typeid ;
sql+=" order by t1.id";
RecordSet.executeSql(sql);
while(RecordSet.next()){
%>
  <tr <%if(islight){%>class=datalight <%} else {%> class=datadark <%}%>> 
    <TD><%=RecordSet.getString("name")%></TD>
    <TD><%=RecordSet.getString("fullname")%></TD>
    <TD><a href="basedata_hrm?resourceid=<%=RecordSet.getString("manager")%>"><%=ResourceComInfo.getResourcename(RecordSet.getString("manager"))%></a></TD>
    <TD><%=DepartmentComInfo.getDepartmentname(RecordSet.getString("department"))%></TD>
  </TR>
<%
        islight=!islight ; 
    }
%>  
    </tbody>
    </table>
</BODY></HTML>

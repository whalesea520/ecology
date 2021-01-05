<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmSubCompanyAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmSubCompany:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+11+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="HrmDepartment.jsp" method=post>

<TABLE class=ListStyle cellspacing=1 >
 <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="20%">
  <COL width="30%">
 <TBODY>
   <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
   </TR>
   </TR>
   <TR class=header>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>    
    <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>    
  </TR>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
int line = 0;
while(SubCompanyComInfo.next()){    
  if(line%2 == 0){  
%>  
    <tr class=datalight>
<%
  }else{
%>  
   <tr class=datadark>  
<%
  }
%>
      <td class=Field>
      <a href="/hrm/company/HrmSubCompanyEdit.jsp?id=<%=SubCompanyComInfo.getSubCompanyid()%>">
        <%=SubCompanyComInfo.getSubCompanyname()%>
      </a>
      </td>
      <td class=Field>
        <%=SubCompanyComInfo.getSubCompanydesc()%>
      </td>      
      <td class=Field>
       <a href="/hrm/company/HrmDepartment.jsp?companyid=<%=companyid%>&subcompanyid=<%=SubCompanyComInfo.getSubCompanyid()%>">  <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>  </a>
      </td>  
    </tr>
<%
line++;
}
%>
 </tbody>
</table>
</form>

</BODY>
</HTML>

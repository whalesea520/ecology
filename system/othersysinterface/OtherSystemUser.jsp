
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>
<%
boolean canIn = false;
int hrmid = user.getUID();
String sqlrole = "select distinct(roleid) from hrmRoleMembers where resourceid = "+hrmid;
rs.executeSql(sqlrole);
while(rs.next()){
    if(rs.getString("roleid").equals("2")){
        canIn = true;
    }
}
if(!canIn){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(7181,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<DIV class=HdrProps></DIV>
<FORM name=frmmain action="OtherSystemUserOperation.jsp" method=post>
<%
String errmsg = Util.null2String(request.getParameter("errmsg"));
if(errmsg.equals("1")){
%>
    <DIV>
    <font color=red size=2>
    <%=SystemEnv.getHtmlLabelName(15094,user.getLanguage())%>！！！
    </div>
<%
}
%>
<DIV>
<BUTTON class=btnSave accessKey=A type=button onclick="location.href='OtherSystemUserAdd.jsp'"><U>A</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
  
<!--<BUTTON class=BtnLog id=button2 accessKey=L name=button2 onclick="location.href='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=84'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>-->
</DIV>

<TABLE class=ListShort>
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <TBODY>
<!--  
  <TR class=Section>
    <TH colSpan=5>外部系统用户</TH></TR>
-->    
  <TR class=separator>
    <TD class=Sep1 colSpan=6 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15095,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15096,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
    <td></td>
  </TR>
 
<% 
String sql = "select * from ycuser"; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
    String	id=rs.getString("id"); 
    String  loginid = rs.getString("loginid");
    String  password = rs.getString("password");
    try{ 
        if(needchange ==0){ 
        needchange = 1; 
    %> 
      <TR class=datalight> 
    <% 
    }else{ needchange=0; 
    %>
      <TR class=datadark> 
    <%
    } 
    %> 
       <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=id%>"><%=ResourceComInfo.getResourcename(id)%></a>
       </TD> 
       <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(id)%>"><%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(id))%>
       </TD> 
       <TD><%=ResourceComInfo.getLoginID(id)%>
       </TD> 
       <td><%=loginid%>
       </td> 
        <td><%=password%>
       </td> 
       <TD><a href="OtherSystemUserEdit.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
       </TD>   
      </TR>
    <% 
    }catch(Exception e){ 
        //System.out.println(e.toString()); 
		rs.writeLog(e);
    } 
} 
%>
</TBODY></TABLE>
   </tr>
</table>
</form>
<script language=javascript>
  function edit(){
  }  
  
</script> 

</BODY>
</HTML>

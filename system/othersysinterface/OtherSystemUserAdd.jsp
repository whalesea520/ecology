
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
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
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));

String loginid = Util.null2String(request.getParameter("loginid"));
String password = Util.null2String(request.getParameter("password"));

String sql = "select * from ycuser where id ="+id;
rs.executeSql(sql); 
while(rs.next()){
    loginid = Util.null2String(rs.getString("loginid"));  
    password = Util.null2String(rs.getString("password"));  
}

boolean canAdd = HrmUserVarify.checkUserRight("HrmOtherSysUserAdd:Add", user);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(7181,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM  name=frmMain action="OtherSystemUserOperation.jsp" method=post >
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
<DIV class=HdrProps></DIV>
<%
if(canAdd){
%>
    <BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}
%>

<BUTTON class=btnNew accessKey=B type=button onclick="location.href='OtherSystemUser.jsp'"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(731,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
             <BUTTON class=Browser onclick="onShowResourceID()"></BUTTON> 
              <SPAN id=idspan><%if(!id.equals("")){%><%=ResourceComInfo.getResourcename(id)%><%}else{%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN> 
              <INPUT type=hidden name=id value="<%=id%>" onChange='checkinput("id","idspan")'>            
          </td>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>            
              <%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(id))%>            
          </TD>
        </TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15095,user.getLanguage())%></td>
          <td class=Field >            
            <%=ResourceComInfo.getLoginID(id)%>
          </td>
        </tr>  
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15096,user.getLanguage())%></td>
          <td class=Field>            
            <input type=text name=loginid value="<%=loginid%>" onChange='checkinput("loginid","loginidspan")'>            
            <span id=loginidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
          </td>
        </tr>              
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
          <td class=Field>            
            <input type=text name=password value="<%=password%>" onChange='checkinput("password","passwordspan")'>            
            <span id=passwordspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
          </td>
        </tr>              
 </TBODY>
 </TABLE>
<input type="hidden" name=operation value="add">
 </form>
 <script language=vbs>  
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")	
	if id(0)<> "" then
	idspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"	
	frmMain.id.value=id(0)
	else 
	idspan.innerHtml = ""
	frmMain.id.value=""	
	end if
	frmMain.action="OtherSystemUserAdd.jsp"
	frmMain.submit()
end sub

</script>
 <script language=javascript>
 function doSave() {
     if(check_form(document.frmMain,"id,loginid,password"))
     {	
        document.frmMain.submit();
     }  
}
 
</script>

</BODY></HTML>

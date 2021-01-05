<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int depid = Util.getIntValue(request.getParameter("depid"),0);
int subccid = Util.getIntValue(request.getParameter("subccid"),0);

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(425,user.getLanguage())+SystemEnv.getHtmlLabelName(426,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action="CcOperation.jsp" method=post >
<TABLE class=viewForm width="100%" border=0>
  <COLGROUP>
  <COL width="30%">
  <COL width=70%>
  <TBODY>
  <TR>
    <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></B></TD>
  </TR>
  <TR>
    <TD class=line1 colSpan=2></TD></TR>
  
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=FIELD id=Code>
      <input class=inputstyle   name=costcentermark onchange='checkinput("costcentermark","costcentermarkimage")'>
      <SPAN id=costcentermarkimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
    </TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD class=FIELD>
      <input class=inputstyle  name=costcentername onchange='checkinput("costcentername","costcenternameimage")'>
      <SPAN id=costcenternameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
   </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
   <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
    <TD class=FIELD>
<%
  if(depid==0){
%>     
              <BUTTON class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON> 
              <SPAN id=departmentspan>                
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
<%
}else{
%>    
               <%=DepartmentComInfo.getDepartmentname(""+depid)%>
<%
}
%>           
              </SPAN> 
      <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=depid%>">       

   </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
   <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15769,user.getLanguage())%></TD>
    <TD class=FIELD>
<!--      <BUTTON class=Browser id=SelectSubcc onclick="onShowSubcc()"></BUTTON> 
              <SPAN id=subccspan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN> 
      <input class=inputstyle id=subccid type=hidden name=subccid value="<%=subccid%>"> 
      <input class=inputstyle maxLength=50 size=50 name=ccsubcategory1 >      
-->
      <select class=inputstyle name=ccsubcategory1 value="<%=subccid%>">
<%
String sql = "select * from HrmCostcenterSubCategory where ccmaincategoryid = 1";
rs.executeSql(sql);
while(rs.next()){
%>      
        <option value=<%=rs.getString("id")%><%if(rs.getInt("id")==subccid){%> selected<%}%> ><%=rs.getString("ccsubcategoryname")%></option>
<%
   }
%>
      </select>
   </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
  </TABLE>
   <input class=inputstyle type=hidden name=operation value="add">
   
  </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 if(check_form(frmMain,'costcentermark,costcentername')){
 frmMain.submit();
 }
}
</script>

  <script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmMain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.departmentid.value=""
	end if
	end if
end sub

sub onShowSubcc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubCostcenterBrowser.jsp")
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmMain.subccid.value then
		issame = true 
	end if
	subccspan.innerHtml = id(1)
	frmMain.subccid.value=id(0)
	else
	subccspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.subccid.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>
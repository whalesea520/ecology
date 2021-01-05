<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(15513,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("HrmdsporderEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
//条件
String departmentidselect=Util.fromScreen(request.getParameter("departmentidselect"),user.getLanguage());
String subcompanyid1select=Util.fromScreen(request.getParameter("subcompanyid1select"),user.getLanguage());
if(!departmentidselect.equals("")){
	departmentidselect = departmentidselect;
}else{
	departmentidselect ="";
}
if(!subcompanyid1select.equals("")){
	subcompanyid1select = subcompanyid1select;
}else{
	subcompanyid1select ="";
}
String sql="select lastname,dsporder,subcompanyid1,departmentid from hrmresource where id="+id;
RecordSet.executeSql(sql);
RecordSet.next();
String lastname=RecordSet.getString("lastname") ;
String departmentid=Util.fromScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;
String subcompanyid1 = Util.fromScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;

String dsporder=RecordSet.getString("dsporder") ;
if(dsporder.equals("")) dsporder=id ;
%>
<form name="frmmain" method=post action="HrmdsporderOperation.jsp">
 <input type="hidden" name="method" value="Edit">
<input class=inputstyle name="id" type=hidden value="<%=id%>">
<table class=Viewform>
  <TR class=Spacing style="height:1px"><TD class=Line1 colSpan=2 ></TD></TR>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
    <td width="85%" class=field><%=Util.toScreen(lastname,user.getLanguage())%></td>
  </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
    <td width="85%" class=field><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid1),user.getLanguage())%></td>
  </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td width="85%" class=field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
    <td width="85%" class=field><input maxLength=7 class=inputstyle name="dsporder" size=7 value="<%=dsporder%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'></td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData(obj) {
 obj.disabled = true ;
 frmmain.submit();
}
</script>

</BODY>
</HTML>

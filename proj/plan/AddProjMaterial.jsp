
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<%
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
RecordSet.executeProc("Prj_TaskInfo_SelectByID",taskrecordid);
if(RecordSet.next()){
}
String ProjID = RecordSet.getString("prjid");
RecordSet2.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet2.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet2.first();

/*权限－begin*/
String Creater = Util.toScreen(RecordSet.getString("creater"),user.getLanguage());
String CreateDate = RecordSet2.getString("createdate");
String manager = RecordSet2.getString("manager");
String department = RecordSet2.getString("department");
String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
 if(HrmUserVarify.checkUserRight("ViewProject:View",user,department) || HrmUserVarify.checkUserRight("EditProject:Edit",user,department)) {
	 canview=true;
	 canedit=true;
	 isrole=true;
 }
 if(useridcheck.equals(Creater)){
	 canview=true;
	 canedit=true;
 }
  if(useridcheck.equals(manager)){
	 canview=true;
	 canedit=true;
	 ismanager=true;
 }
AllManagers.getAll(manager);
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		canview=true;
		canedit=true;
		ismanagers=true;
	}
}

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdPRJ_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1327,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver action="ProjMaterialOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1327,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=10 name="material" onChange="checkinput('material','materialspan')"> <span 
            id=materialspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> </TD>
        </TR>  <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=6 name="unit" > <span 
            id=unitspan></span> </TD>
        </TR><TR class=spacing>
          <TD class=line colSpan=2></TD></TR>

	 <TR>
	 <TD><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TD>
	  <TD class=Field><INPUT class=inputstyle maxLength=10 size=10 name="cost" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("cost")'> <span 
		id=costspan></span> </TD>
	 </TR><TR class=spacing>
          <TD class=line colSpan=2></TD></TR>

	 <TR>
	 <TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
	  <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="quantity" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("quantity")'><SPAN id=quantityimage></SPAN></TD>
	 </TR><TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        
  </TBODY>
</TABLE>
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

</form>
<script language=vbs>
sub onShowrelateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Prjrelateidspan.innerHtml = "<A href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.relateid.value=id(0)
	else 
	Prjrelateidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.relateid.value=""
	end if
	end if
end sub
</script>
 <script language="javascript">
function submitData()
{if (check_form(weaver,'material'))
		weaver.submit();
}
</script>
</html>
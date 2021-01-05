
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Prj_PlanInfo_SelectByID",id);
String prjid = "";
String subject = "";
String begindate = "";
String enddate = "";
String begintime = "";
String endtime = "";
String resourceid = "";
String content = "";
String budgetmoney = "";
String docid = "";
String plansort = "";
String plantype = "";
String validate="";
if(RecordSet.next()){
	 prjid = Util.toScreen(RecordSet.getString("prjid"),user.getLanguage());
	 subject = Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
	 begindate = Util.toScreen(RecordSet.getString("begindate"),user.getLanguage());
	 enddate = Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
	 begintime = Util.toScreen(RecordSet.getString("begintime"),user.getLanguage());
	 endtime = Util.toScreen(RecordSet.getString("endtime"),user.getLanguage());
	 resourceid = Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage());
	 content = Util.toScreen(RecordSet.getString("content"),user.getLanguage());
	 budgetmoney = Util.toScreen(RecordSet.getString("budgetmoney"),user.getLanguage());
	 docid = Util.toScreen(RecordSet.getString("docid"),user.getLanguage());
	 plansort = Util.toScreen(RecordSet.getString("plansort"),user.getLanguage());
	 plantype = Util.toScreen(RecordSet.getString("plantype"),user.getLanguage());
	 validate=Util.toScreen(RecordSet.getString("validate_n"),user.getLanguage());
}

if(plantype.equals("")) plantype = "0";
if(plansort.equals("")) plansort = "0";
if(validate.equals("")) validate = "0";

%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(407,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% if(HrmUserVarify.checkUserRight("EditPlan:Edit",user)) {
%><%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%
	if(validate.equals("1")){
	%>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2245,user.getLanguage())+",/proj/plan/PlanOperation.jsp?id="+id+"&method=validate&validate=0,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}%>
	<%
	if(validate.equals("0")){
	%>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",/proj/plan/PlanOperation.jsp?id="+id+"&method=validate&validate=1,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}
}%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="/proj/plan/EditPlan.jsp?id=<%=id%>" method=post>
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
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	<COL width="15%">
  	<COL width="35%">
  	<COL width="15%">
  	<COL width="35%">
        <TBODY>
        
        <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
          <tr>
          <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
          <td class=field colspan=3>
          <A href="/proj/data/ViewProject.jsp?ProjID=<%=prjid%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(prjid),user.getLanguage())%></a>
          </td>
          </tr>
		  <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
          <TD class=Field>
          <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
           </TD>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><%=subject%></TD>
         </TR> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>                
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(842,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(PlanTypeComInfo.getPlanTypename(plantype),user.getLanguage())%>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(843,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(PlanSortComInfo.getPlanSortname(plansort),user.getLanguage())%>
         </TD>
        </TR><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
              <SPAN id=begindatespan ><%=begindate%></SPAN> 
          </td>
        <td><%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
           <TD class=Field><%=begintime%></TD>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
              <SPAN id=enddatespan ><%=enddate%></SPAN> 
          </td>
        <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
           <TD class=Field><%=endtime%></TD>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field>
         <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
         </td>
         <td><%=SystemEnv.getHtmlLabelName(845,user.getLanguage())%></td>
           <TD class=Field><%=budgetmoney%></TD>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4 class=field>
         <%=content%>
         </td>
         </tr><TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
         </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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

</FORM>
</BODY>
</HTML>

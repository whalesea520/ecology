
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ProcessingTypeComInfo" class="weaver.proj.Maint.ProcessingTypeComInfo" scope="page" />
<jsp:useBean id="PlanInfoComInfo" class="weaver.proj.Maint.PlanInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
	
%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(665,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% if(HrmUserVarify.checkUserRight("AddProcessing:Add",user)) {

%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/proj/process/AddProcessing.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post>
  <input type="hidden" name="ProjID" value="<%=ProjID%>">

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
 
<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="20%">
  <TBODY>
          <tr>
          <%
          char flag=2;
       RecordSet.executeProc("Prj_Processing_SelectAll",ProjID+flag+"0%");
    int needchange = 0;
      while(RecordSet.next()){
      	String listspace = "";
      	String parentids = RecordSet.getString("parentids");
      	int curpos = parentids.indexOf(",");
      	curpos = parentids.indexOf(",",curpos+1);
      	while(curpos!=-1){
      		listspace +="&nbsp&nbsp";
      		curpos = parentids.indexOf(",",curpos+1);
      	}
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
  %>
    <TD><%=listspace%>
    <%
    if(!listspace.equals("")){
    %>
    <img border=0 src="/images/ArrowRightBlue_wev8.gif"></img>
    <%}%>    
    <a href="Dspprocessing.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("title")%></a></TD>
    <TD><%=ProcessingTypeComInfo.getProcessingTypename(RecordSet.getString("type"))%></TD>
    <TD><A href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("submiter")%>"><%=ResourceComInfo.getResourcename(RecordSet.getString("submiter"))%></a></TD>
    <td><a href="/proj/plan/DspPlan.jsp?id=<%=RecordSet.getString("planid")%>"><%=PlanInfoComInfo.getPlanInfoSubject(RecordSet.getString("planid"))%></a>
    </td>
    <TD><%=RecordSet.getString("submitdate")%>&nbsp<%=RecordSet.getString("submittime")%></td>
  </TR>
<%
      }catch(Exception e){
        //System.out.println(e.toString());
      }
    }
%>  
         
          
    </TR></TBODY></TABLE>
	
</FORM> 
</BODY>
</HTML>

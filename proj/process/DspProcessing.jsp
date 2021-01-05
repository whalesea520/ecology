
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ProcessingTypeComInfo" class="weaver.proj.Maint.ProcessingTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PlanInfoComInfo" class="weaver.proj.Maint.PlanInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Prj_Processing_SelectByID",id);

String prjid="";
String planid="";
String title="";
String content="";
String type="";
String docid="";
String parentids="";
String submitdate="";
String submittime="";
String submiter	="";
String updatedate="";
String updatetime="";
String updater="";
String isprocessed="";
String processdate="";
String processtime="";
String processor="";

if(RecordSet.next()){
	 prjid=Util.toScreen(RecordSet.getString("prjid"),user.getLanguage());
	 planid=Util.toScreen(RecordSet.getString("planid"),user.getLanguage());
	 title=Util.toScreen(RecordSet.getString("title"),user.getLanguage());
	 content=Util.toScreen(RecordSet.getString("content"),user.getLanguage());
	 type=Util.toScreen(RecordSet.getString("type"),user.getLanguage());
	 docid=Util.toScreen(RecordSet.getString("docid"),user.getLanguage());
	 parentids=Util.toScreen(RecordSet.getString("parentids"),user.getLanguage());
	 submitdate=Util.toScreen(RecordSet.getString("submitdate"),user.getLanguage());
	 submittime=Util.toScreen(RecordSet.getString("submittime"),user.getLanguage());
	 submiter=Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	 updatedate=Util.toScreen(RecordSet.getString("updatedate"),user.getLanguage());
	 updatetime=Util.toScreen(RecordSet.getString("updatetime"),user.getLanguage());
	 updater=Util.toScreen(RecordSet.getString("updater"),user.getLanguage());
	 isprocessed=Util.toScreen(RecordSet.getString("isprocessed"),user.getLanguage());
	 processdate=Util.toScreen(RecordSet.getString("processdate"),user.getLanguage());
	 processtime=Util.toScreen(RecordSet.getString("processtime"),user.getLanguage());
	 processor=Util.toScreen(RecordSet.getString("processor"),user.getLanguage());
}
%>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(665,user.getLanguage());
titlename = titlename + "<B>" +SystemEnv.getHtmlLabelName(125,user.getLanguage()) +":</B><A href=/hrm/resource/HrmResource.jsp?id=";
titlename = titlename + submiter +">"+Util.toScreen(ResourceComInfo.getResourcename(submiter),user.getLanguage());
titlename = titlename + "</a>&nbsp"+submitdate+"&nbsp"+submittime;
if(!updater.equals("")){
titlename = titlename + "<B>" +SystemEnv.getHtmlLabelName(103,user.getLanguage())+"</B><A href=/hrm/resource/HrmResource.jsp?id=";
titlename = titlename +updater+ Util.toScreen(ResourceComInfo.getResourcename(updater),user.getLanguage()) ;
titlename = titlename + "</a>&nbsp"+updatedate+"&nbsp"+updatetime;}

if(isprocessed.equals("1")){
titlename = titlename + "<B>" +SystemEnv.getHtmlLabelName(251,user.getLanguage())+"</B><A href=/hrm/resource/HrmResource.jsp?id=";
titlename = titlename +processor + Util.toScreen(ResourceComInfo.getResourcename(processor),user.getLanguage());
titlename = titlename + "</a>&nbsp"+processdate+"&nbsp"+processtime;}

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
 if(HrmUserVarify.checkUserRight("EditProcessing:Edit",user)) {

if(!isprocessed.equals("1")){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",EditProcessing.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}
}
 if(HrmUserVarify.checkUserRight("AddProcessing:Add",user)) {
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+",AddProcessing.jsp?ProjID="+prjid+"&planid="+planid+"&parentids="+parentids+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="/proj/process/ProcessingOperation.jsp" method=post>

  <input type="hidden" name="method" value="archive">
  <input type="hidden" name="id" value="<%=id%>">
  <input type="hidden" name="prjid" value="<%=prjid%>">
  
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
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/proj/plan/DspPlan.jsp?id=<%=planid%>"><%=PlanInfoComInfo.getPlanInfoSubject(planid)%></a>
            </TD>
         
          <TD><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TD>
          <TD class=Field>
          <%=ProcessingTypeComInfo.getProcessingTypename(RecordSet.getString("type"))%>
          </TD></tr>
		   <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <tr>
           <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field colspan=3><%=title%></TD>
         </TR>    <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>       
         <tr>
         <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field colspan=3>
         <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
         </td>
         </tr>   <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <TR>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr>   <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4 class=field><%=content%>
         </tr>   <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
         </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
    
    <TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="20%">
  <TBODY>
   
        <TR class=spacing>
          <TD class=line1 colSpan=5></TD></TR>
          <tr>
          <%
           String subparentids="";
          int tmppos = parentids.indexOf(",");
          tmppos = parentids.indexOf(",",tmppos+1);
          if(tmppos==-1)
          	 subparentids = parentids;
          else
          	subparentids = parentids.substring(0,tmppos);
          
          char flag=2;
       RecordSet.executeProc("Prj_Processing_SelectAll",prjid+flag+"0%");
    int needchange = 0;
      while(RecordSet.next()){
      	String listspace = "";
      	String parentids1 = RecordSet.getString("parentids");
      	if(parentids1.indexOf(subparentids)==-1) continue;
      	int curpos = parentids1.indexOf(",");
      	curpos = parentids1.indexOf(",",curpos+1);
      	while(curpos!=-1){
      		listspace +="&nbsp&nbsp";
      		curpos = parentids1.indexOf(",",curpos+1);
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
    <%
    if(!parentids.equals(parentids1)){
    %>  
    <a href="Dspprocessing.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("title")%></a>
    <%}else{%>
    <%=RecordSet.getString("title")%>
    <%}%>
    </TD>
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

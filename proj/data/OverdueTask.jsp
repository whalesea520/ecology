
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.proj.Maint.*"%>

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<%
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16412,user.getLanguage());
    String needfav ="1";
    String needhelp ="";

    ProjectTaskList approval = new ProjectTaskList(user);

    String sqlStr = "Select * From Prj_TaskProcess t1, Prj_ProjectInfo t2 Where t1.isdelete =0 and t1.hrmid="+user.getUID()+" and (t1.enddate<'"+CurrentDate+"' and t1.enddate <>'-') and (t1.Finish < 100 or (t1.Finish = 100 and t1.Status <>"+ProjectTask.APPROVED+")) and t2.id = t1.prjid and t2.status not in (0,6,7)";

    //out.println("sqlStr ="+sqlStr);
    approval.setSqlStr(sqlStr);

    ArrayList approvalList = approval.getTaskApproveList();


%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>





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


<TABLE class=liststyle cellspacing=1  >
	 <colgroup>
	  <col width="20%">
	  <col width="20%">
	  <col width="10%">
	  <col width="15%">
	  <col width="15%">
	  <col width="10%">
	  <col width="10%">
	</colgroup>
<TBODY>
	    <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
          <th nowrap><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>
          <th nowrap><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>

	    </TR>
         <TR class=Line><TD colspan="7" style="padding:0;"></TD></TR>
     </TBODY>
</TABLE>

<TABLE class=liststyle cellspacing=1 >
  <colgroup>
	  <col width="20%">
	  <col width="20%">
	  <col width="10%">
	  <col width="15%">
	  <col width="15%">
	  <col width="10%">
	  <col width="10%">
  </colgroup>
<TBODY>

   <%/*##################显示任务列表开始##########################*/%>
   <%for(int i=0;i<approvalList.size();i++){
              Project prj = (Project) approvalList.get(i);
              int prjid = prj.getProjectID();
              String projectName =   ProjectInfoComInfo.getProjectInfoname(""+prjid);
              ArrayList taskList = prj.getTaskList();

   %>
          <TR class="DataOutline">
              <TD colspan="7">
                      <a href="/proj/data/ViewProject.jsp?ProjID=<%=prjid%>" target=_fullwindow><%=projectName%></a>
              </TD>
          </TR>
          <%for(int j=0;j<taskList.size();j++){
                    ProjectTask task = (ProjectTask) taskList.get(j);

          %>
                <TR class="<%=(j%2==0?"DataLight":"DataDark")%>">
                     <TD></TD>
                     <TD><a href="/proj/process/ViewTask.jsp?taskrecordid=<%=task.getTaskID()%>" target=_fullwindow><%=task.getSubject()%><a></TD>
                     <TD><%=ResourceComInfo.getResourcename(""+task.getHrmID())%></TD>
                     <TD><%=task.getBeginDate()%></TD>
                     <TD><%=task.getEndDate()%></TD>
                      <TD><%=task.getFinish()%>%</TD>
                     <TD>
                     <%
                            switch(task.getStatus()){
                                case ProjectTask.APPROVED:  /*正常*/
                                    out.println("<a href=\"/proj/process/ProjectTaskApprovalDetail.jsp?TaskID="+task.getTaskID()+"\" target=_fullwindow>"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</a>");
                                    break;
                                case ProjectTask.ADD_UNAPPROVED: /*增加，待审批*/
                                    out.println("<a href=\"/proj/process/ProjectTaskApprovalDetail.jsp?TaskID="+task.getTaskID()+"\" target=_fullwindow>"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(456,user.getLanguage())+")");
                                    break;
                                case ProjectTask.MODIFY_UNAPPROVED: /*修改，待审批*/
                                    out.println("<a href=\"/proj/process/ProjectTaskApprovalDetail.jsp?TaskID="+task.getTaskID()+"\" target=_fullwindow>"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(103,user.getLanguage())+")");
                                    break;
                                case ProjectTask.DELETE_UNAPPROVED: /*删除，待审批*/
                                    out.println("<a href=\"/proj/process/ProjectTaskApprovalDetail.jsp?TaskID="+task.getTaskID()+"\" target=_fullwindow>"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(91,user.getLanguage())+")");
                                    break;
                            }
                      %>
                     </TD>

                </TR>
          <%}%>
   <%}%>
	<TR style="height:1px;">
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
         <TD style="padding:0"></TD>
    </TR>
	<%/*################显示任务列表结束####################*/%>
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





<script language=vbs>
sub getProj(prjid)
	returndate =  window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ProjNotice.jsp?ProjID="&prjid)


end sub


</script>

<script language=javascript >
function rankclick(targetId)
{

		var objSrcElement = window.event.srcElement;
    if (document.all(targetId)==null) {

           objSrcElement.src = "/images/project_rank1_wev8.gif";

	} else {
         var targetElement = document.all(targetId);

          if (targetElement.style.display == "none")
		{
             objSrcElement.src = "/images/project_rank1_wev8.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2_wev8.gif";
             targetElement.style.display = "none";
		}
	}

}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

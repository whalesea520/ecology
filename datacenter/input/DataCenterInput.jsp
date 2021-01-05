<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

String logintype = "2" ;
String resourceid= ""+user.getUID();
int usertype= 1;
String seclevel = user.getSeclevel();
session.removeAttribute("RequestViewResource") ;
char flag = Util.getSeparator();


String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("数据中心",7,"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform width="100%">
        <TBODY> 
        <TR class=title> 
          <TH>报表输入</TH>
        </TR>
 <tr class=spacing><td class=line1></td></tr>
		<%
        char separator = Util.getSeparator() ;
		String userid = ""+user.getUID() ;
        /*
		String contacterid = "" + Util.getIntValue(user.getTitle(), 0) ;
        Calendar today = Calendar.getInstance();
        String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
		RecordSet.executeProc("T_InputReport_SelectByContacterid",contacterid + separator + currentdate);
		while(RecordSet.next()) {
			String inprepid =  Util.null2String(RecordSet.getString("inprepid")) ;
			String inprepname = Util.toScreen(RecordSet.getString("inprepname"),user.getLanguage()) ;
		*/
		this.rs=RecordSet;
		List list1=this.getAllInputReport(userid);
		int sizes=list1.size();
		Map m0=null;
		for(int i=0;i<sizes;i++){
			m0=(Map)list1.get(i);
		%>
        <tr class=spacing> 
          <td><a href="/datacenter/input/InputReportDate.jsp?inprepid=<%=m0.get("inprepId")%>">
			<%=Util.toScreen(m0.get("inprepName").toString(),user.getLanguage())%>
			</a></td>
        </tr>
		<%}%>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
      <TABLE class=viewform width="100%">
        <TBODY> 
        <TR class=title> 
          <TH>报表管理</TH>
        </TR>
 <tr class=spacing><td class=line1></td></tr>
        <tr class=spacing> 
          <td><a 
            href="/datacenter/maintenance/user/reportstatus/ReportConfirm.jsp">报表输入确认</a></td>
        </tr>
        <tr class=spacing> 
          <td><a 
            href="/datacenter/maintenance/user/reportstatus/ReportStatus.jsp">报表状态</a></td>
        </tr>
        <tr class=spacing> 
          <td height="8"></td>
        </tr>
        </TBODY> 
      </TABLE>
      <table class=viewform width="100%">
        <tbody> 
        <tr class=title> 
          <th>报表查看</th>
        </tr>
     <tr class=spacing><td class=line1></td></tr>
        <%
		String para = userid + separator + "2" ;
		
		if(HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) 
			RecordSet.executeProc("T_OutReport_SelectAll","0");
		else
			RecordSet.executeProc("T_OutReport_SelectByUserid",para);
			
		while(RecordSet.next()) {
			String outrepid =  Util.null2String(RecordSet.getString("outrepid")) ;
			String outrepname = Util.toScreen(RecordSet.getString("outrepname"),user.getLanguage()) ;
		%>
        <tr class=spacing> 
          <td><a 
            href="/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>"><%=outrepname%></a></td>
        </tr>
        <%}%>
        </tbody> 
      </table>
      <br>
      <table class=viewform>
          <tr class=title><th>新建讨论</th></tr>
         <tr class=spacing><td class=line1></td></tr>
          <tr><td><UL>
        <%	
            ArrayList NewWorkflows = new ArrayList();
            String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
            String sql = "select workflowid from ShareInnerWfCreate t1 where " + wfcrtSqlWhere;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
                NewWorkflows.add(RecordSet.getString("workflowid"));
            }
           
            while(WorkflowComInfo.next()){
                String wfname=WorkflowComInfo.getWorkflowname();
                String wfid = WorkflowComInfo.getWorkflowid();
	 	
	 	        if(NewWorkflows.indexOf(wfid)==-1) continue;
	    %>
		<li><a href="javascript:onNewRequest(<%=wfid%>);">
		<%=Util.toScreen(wfname,user.getLanguage())%></a></li>
	    <%
            }
            WorkflowComInfo.setTofirstRow();
	    %>
         </ul>
         </td>
         </tr>
       </table>
       <br>
    <%
        ArrayList wftypes=new ArrayList();
        ArrayList wftypecounts=new ArrayList();
        ArrayList workflows=new ArrayList();
        ArrayList workflowcounts=new ArrayList();
        int totalcount=0;
        
        RecordSet.executeProc("workflow_requestbase_SWftype",resourceid+flag+usertype+flag+"0");
        while(RecordSet.next()){
            wftypes.add(RecordSet.getString("workflowtype"));
            wftypecounts.add(RecordSet.getString("typecount"));
        }
        RecordSet.executeProc("workflow_requestbase_SelectWf",resourceid+flag+usertype+flag+"0");
        while(RecordSet.next()){
            workflows.add(RecordSet.getString("workflowid"));
            workflowcounts.add(RecordSet.getString("workflowcount"));
        }
        for(int i=0;i<wftypes.size();i++){
            totalcount+=Util.getIntValue((String)wftypecounts.get(i),0);
        }
    %>
    <br>
    <table class="viewform">
    <colgroup><col width="49%"><col width=10><col width="49%">
    <tr>
    <td valign=top>
      <table class="viewform">
      <tr class="Title">
              <th><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%>:<%=totalcount%></th>
            </tr>
      <tr class="Spacing"><td class="Line1"></td></tr>
      <tr><td>
      <UL>
    <%	
        String typeid="";
        String typecount="";
        String typename="";
        String workflowid="";
        String workflowcount="";
        String workflowname="";
        for(int i=0;i<wftypes.size();i++){
            typeid=(String)wftypes.get(i);
            typecount=(String)wftypecounts.get(i);
            typename=WorkTypeComInfo.getWorkTypename(typeid);
            %>
        <LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&wftype=<%=typeid%>&complete=0">
            <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=Util.toScreen(typecount,user.getLanguage())%>)</b>
            <UL>
            <%
            if(typeid.equals("24")) continue;
            for(int j=0;j<workflows.size();j++){
                workflowid=(String)workflows.get(j);
                String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
                if(!curtypeid.equals(typeid))	continue;
                workflowcount=(String)workflowcounts.get(j);
                workflowname=WorkflowComInfo.getWorkflowname(workflowid);
                %>
            <LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywfid&workflowid=<%=workflowid%>&complete=0">
                <%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=Util.toScreen(workflowcount,user.getLanguage())%>)
                <%
            }
            %>
        </UL>
            <%
        }
    %>
       </UL></td></tr></table>
        <br>
    <%
        wftypes.clear();
        wftypecounts.clear();
        workflows.clear();
        workflowcounts.clear();
        totalcount=0;
        
        RecordSet.executeProc("workflow_requestbase_SWftype",resourceid+flag+usertype+flag+"1");
        while(RecordSet.next()){
            wftypes.add(RecordSet.getString("workflowtype"));
            wftypecounts.add(RecordSet.getString("typecount"));
        }
        RecordSet.executeProc("workflow_requestbase_SelectWf",resourceid+flag+usertype+flag+"1");
        while(RecordSet.next()){
            workflows.add(RecordSet.getString("workflowid"));
            workflowcounts.add(RecordSet.getString("workflowcount"));
        }
        
        for(int i=0;i<wftypes.size();i++){
            totalcount+=Util.getIntValue((String)wftypecounts.get(i),0);
        }
    %>
      <table class="viewform">
      <tr class="Title"><th><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>:<%=totalcount%></th></tr>
      <tr class="Spacing"><td class="Line1"></td></tr>
      <tr><td><UL>
    <%	
        for(int i=0;i<wftypes.size();i++){
            typeid=(String)wftypes.get(i);
            typecount=(String)wftypecounts.get(i);
            typename=WorkTypeComInfo.getWorkTypename(typeid);
            %>
        <LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&wftype=<%=typeid%>&complete=1">
            <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=Util.toScreen(typecount,user.getLanguage())%>)</b>
            <UL>
            <%
            if(typeid.equals("24")) continue;
            for(int j=0;j<workflows.size();j++){
                workflowid=(String)workflows.get(j);
                String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
                if(!curtypeid.equals(typeid))	continue;
                workflowcount=(String)workflowcounts.get(j);
                workflowname=WorkflowComInfo.getWorkflowname(workflowid);
                %>
            <LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywfid&workflowid=<%=workflowid%>&complete=1">
                <%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=Util.toScreen(workflowcount,user.getLanguage())%>)
                <%
            }
            %>
        </UL>
            <%
        }
    %>
      </UL></td></tr></table>
    <br>
      <%
            wftypes.clear();
            wftypecounts.clear();
            workflows.clear();
            workflowcounts.clear();
            totalcount=0;

            ArrayList endwftypes=new ArrayList();
            ArrayList endwftypecounts=new ArrayList();
            ArrayList endworkflows=new ArrayList();
            ArrayList endworkflowcounts=new ArrayList();
            int endtotalcount=0;

            // 刘煜为性能优化做的修改， 只是选择一次，然后在根据currentnodetype 和类型进行挑选
            
            RecordSet.executeProc("workflow_currentoperator_SWf",resourceid+flag+usertype);
            while(RecordSet.next()){
                int theworkflowcount = Util.getIntValue(RecordSet.getString(1),0) ;
                String theworkflowid = Util.null2String(RecordSet.getString(2)) ;
                String thecurrenttype = Util.null2String(RecordSet.getString(3)) ;

                if(!thecurrenttype.equals("3")) {       // 未完成
                    String curtypeid=WorkflowComInfo.getWorkflowtype(theworkflowid);

                    int wrkindex = workflows.indexOf(theworkflowid) ;
                    if(wrkindex != -1) {
                        workflowcounts.set(wrkindex,""+(Util.getIntValue((String)workflowcounts.get(wrkindex),0)+theworkflowcount)) ;
                    }
                    else {
                        workflows.add(theworkflowid) ;
                        workflowcounts.add(""+theworkflowcount) ;
                    }

                    int wrktypeindex = wftypes.indexOf(curtypeid) ;
                    if(wrktypeindex != -1) {
                        wftypecounts.set(wrktypeindex,""+(Util.getIntValue((String)wftypecounts.get(wrktypeindex),0)+theworkflowcount)) ;
                    }
                    else {
                        wftypes.add(curtypeid) ;
                        wftypecounts.add(""+theworkflowcount) ;
                    }

                    totalcount += theworkflowcount ;
                }
                else {          // 已经结束的 , 只用一种 currenttype
                    String curtypeid=WorkflowComInfo.getWorkflowtype(theworkflowid);

                    endworkflows.add(theworkflowid) ;
                    endworkflowcounts.add(""+theworkflowcount) ;

                    int wrktypeindex = endwftypes.indexOf(curtypeid) ;
                    if(wrktypeindex != -1) {
                        endwftypecounts.set(wrktypeindex,""+(Util.getIntValue((String)endwftypecounts.get(wrktypeindex),0)+theworkflowcount)) ;
                    }
                    else {
                        endwftypes.add(curtypeid) ;
                        endwftypecounts.add(""+theworkflowcount) ;
                    }

                    endtotalcount += theworkflowcount ;
                }
            }
      %>
      <table class=viewform>
          <tr class=title><th>待处理讨论:<%=totalcount%></th></tr>
         <tr class=spacing><td class=line1></td></tr>
          <tr><td><UL>
        <%	
            
            for(int i=0;i<wftypes.size();i++){
                typeid=(String)wftypes.get(i);
                typecount=(String)wftypecounts.get(i);
                typename=WorkTypeComInfo.getWorkTypename(typeid);
                %>
            <LI><a href="/workflow/search/WFSearchTemp.jsp?method=reqeustbywftype&wftype=<%=typeid%>&complete=0">
                <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=Util.toScreen(typecount,user.getLanguage())%>)</b>
                <UL>
                <%
                for(int j=0;j<workflows.size();j++){
                    workflowid=(String)workflows.get(j);
                    String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
                    if(!curtypeid.equals(typeid))	continue;
                    workflowcount=(String)workflowcounts.get(j);
                    workflowname=WorkflowComInfo.getWorkflowname(workflowid);
                %>
                    <LI><a href="/workflow/search/WFSearchTemp.jsp?method=reqeustbywfid&workflowid=<%=workflowid%>&complete=0"><%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=Util.toScreen(workflowcount,user.getLanguage())%>)
                <% 
                    workflows.remove(j) ;
                    workflowcounts.remove(j) ;
                    j-- ;
                } 
                %>
            </UL>
                <%
            }
        %>
         </UL>
         </td>
         </tr>
       </table>
       <br>
    <%
        wftypes = endwftypes ;
        wftypecounts = endwftypecounts ;
        workflows = endworkflows ;
        workflowcounts = endworkflowcounts ;
        totalcount = endtotalcount ;
    %>
    <table class=viewform>
      <tr class=title><th>已结束讨论:<%=totalcount%></th></tr>
      <tr class=spacing><td class=line1></td></tr>
      <tr><td><UL>
    <%	
        for(int i=0;i<wftypes.size();i++){
            typeid=(String)wftypes.get(i);
            typecount=(String)wftypecounts.get(i);
            typename=WorkTypeComInfo.getWorkTypename(typeid);
            %>
        <LI><a href="/workflow/search/WFSearchTemp.jsp?method=reqeustbywftype&wftype=<%=typeid%>&complete=1">
            <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=Util.toScreen(typecount,user.getLanguage())%>)</b>
            <UL>
            <%
            for(int j=0;j<workflows.size();j++){
                workflowid=(String)workflows.get(j);
                String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
                if(!curtypeid.equals(typeid))	continue;
                workflowcount=(String)workflowcounts.get(j);
                workflowname=WorkflowComInfo.getWorkflowname(workflowid);
                %>
            <LI><a href="/workflow/search/WFSearchTemp.jsp?method=reqeustbywfid&workflowid=<%=workflowid%>&complete=1">
                <%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=Util.toScreen(workflowcount,user.getLanguage())%>)
            <% 
                workflows.remove(j) ;
                workflowcounts.remove(j) ;
                j-- ;
            } 
            %>
        </UL>
            <%
        }
    %>
      </UL></td></tr>
     </table>
    </TD></TR></TBODY></TABLE>
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
function onNewRequest(wfid){
	window.location.href = "/workflow/request/AddRequest.jsp?workflowid="+wfid;
}
</script>	

</BODY></HTML>

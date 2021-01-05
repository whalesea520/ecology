
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
	int type=Util.getIntValue(request.getParameter("type"),0);
	String fromid=Util.null2String(request.getParameter("fromid"));
	int resourceallnum=Util.getIntValue(request.getParameter("resourceallnum"),0);
	String resourceidstr=Util.null2String(request.getParameter("resourceidstr"));
	int docallnum=Util.getIntValue(request.getParameter("docallnum"),0);
	String docidstr=Util.null2String(request.getParameter("docidstr"));
	int crmallnum=Util.getIntValue(request.getParameter("crmallnum"),0);
	String crmidstr=Util.null2String(request.getParameter("crmidstr"));
	int projectallnum=Util.getIntValue(request.getParameter("projectallnum"),0);
	String projectidstr=Util.null2String(request.getParameter("projectidstr"));
	int eventAllNum=Util.getIntValue(request.getParameter("eventAllNum"),0);  //apollo
	String eventIDStr=Util.null2String(request.getParameter("eventIDStr"));//apollo
	int coworkAllNum=Util.getIntValue(request.getParameter("coworkAllNum"),0);
	String coworkIDStr=Util.null2String(request.getParameter("coworkIDStr"));
	/* 2014-7-31 start */
	int pendingEventAllNum=Util.getIntValue(request.getParameter("pendingEventAllNum"), 0);
	String pendingEventIDStr=Util.null2String(request.getParameter("pendingEventIDStr"));
	/* 2014-7-31 end */
	ArrayList resourceids=new ArrayList();
	ArrayList docids=new ArrayList();
	ArrayList crmids=new ArrayList();
	ArrayList projectids=new ArrayList();
	ArrayList eventIDs=new ArrayList();//apollo
	ArrayList coworkIDs=new ArrayList();
	/* 2014-7-31 start */
	ArrayList pendingEventIDs = new ArrayList();
	/* 2014-7-31 end */

	int i=0;
	int j=0;
%>
<% if(type==3) { %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<table class=viewform>
<colgroup>
<col width=10px>
<col width="49%">
<col width=10px>
<col width="49%">
<TBODY>
<TR CLASS=title><TD COLSPAN=4>
<B><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>
(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=resourceallnum%>)</B></TD></TR>
<TR CLASS=spacing style="height: 1px"><TD CLASS=line1 COLSPAN=4></TD></TR>
<tr>
<%
	String managerid="";
	String resourceid="";
	String resourcename="";
	String jobtitle="";
	String jobtitlename="";
	String checked="";
	//by Charoes Huang
	String status ="";
	String id ="";

	resourceids=Util.TokenizerString(resourceidstr,",");
	i=0;
	while(ResourceComInfo.next()){
		managerid=ResourceComInfo.getManagerID();
		id = ResourceComInfo.getResourceid();
		status = ResourceComInfo.getStatus(id);
		if(fromid.equals(managerid) && (status.equals("0")||status.equals("1")||status.equals("2")||status.equals("3"))){
			resourceid=ResourceComInfo.getResourceid();
			resourcename=ResourceComInfo.getResourcename();
			jobtitle=ResourceComInfo.getJobTitle();
			jobtitlename=JobTitlesComInfo.getJobTitlesname(jobtitle);
			i++;
			checked="";
			for(j=0;j<resourceids.size();j++){
                if(((String)resourceids.get(j)).equals(resourceid))
                    checked="checked";
			}
			%>
			<TD><INPUT TYPE=CheckBox VALUE="<%=resourceid%>" NAME=ids <%=checked%>></TD>
			<td class=field><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target=_blank>
			<%=Util.toScreen(resourcename,user.getLanguage())%> , <%=Util.toScreen(jobtitlename,user.getLanguage())%></a></td>
			<%
			if((i%2)==0&&i<resourceallnum){	%>  </tr><tr>   <%}
			if((i==resourceallnum)){
				if((i%2)==0){  %>   </tr>	<%}
				if((i%2)==1){  %>   <td>&nbsp;</td><td>&nbsp;</td></tr><%}
			}
		}
	}
%>
</tbody>
</table>
<%}%>

<% if(type==4) {%>
<table class=viewform>
<colgroup>
<col width=10px>
<col width="49%">
<col width=10px>
<col width="49%">
<TBODY>
<TR CLASS=title><TD COLSPAN=4>
<B><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>
(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=docallnum%>)</B></TD></TR>
<TR CLASS=spacing style="height: 1px"><TD CLASS=line1 COLSPAN=4></TD></TR>
<tr>
<%
	String ownerid="";
	String docid="";
	String docname="";
	String checked="";
	docids=Util.TokenizerString(docidstr,",");
	i=0;

	//update by alan on 2009-08-17 for td:11539
    String sql="select id,docsubject,doccreaterid,ownerid,usertype , replydocid from DocDetail where maincategory!=0  and subcategory!=0 and seccategory!=0 and ";
	sql += "id IN (select max(id) from DocDetail where ownerid="+fromid+" and (ishistory is null or ishistory = 0) group by parentids)";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
	  	ownerid=RecordSet.getString("ownerid");
			docid=RecordSet.getString("id");
			docname=RecordSet.getString("docsubject");
			i++;
			checked="";
			for(j=0;j<docids.size();j++){
        if(((String)docids.get(j)).equals(docid))
            checked="checked";

			}
			%>
			<TD><INPUT TYPE=CheckBox VALUE="<%=docid%>" NAME=ids <%=checked%>></TD>
			<td class=field><a href="/docs/docs/DocDsp.jsp?id=<%=docid%>"  target=_blank><%=Util.toScreen(docname,user.getLanguage())%></a></td>
			<%
			if((i%2)==0&&i<docallnum){	%>  </tr><tr>   <%}
			if((i==docallnum)){
				if((i%2)==0){  %>   </tr>	<%}
				if((i%2)==1){  %>   <td>&nbsp;</td><td>&nbsp;</td></tr><%}
			}

	}
%>
</tbody>
</table>
<%}%>

<% if(type==1) { %>
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<%
String crmtype=Util.null2String(request.getParameter("crmtype"));
String crmstatus=Util.null2String(request.getParameter("crmstatus"));
%>
<table class=viewform>
  <tr class=title><th colspan=3><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></th></tr>
  <TR CLASS=spacing style="height: 1px"><TD CLASS=line1 COLSPAN=3></TD></TR>
  <tr>
     <td width="20%"><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%>
         <select name="crmtype" size=1 >
         <option value="">&nbsp;</option>
         <%
         String curtype="";
         String curtypename="";
         String selected="";
         while(CustomerTypeComInfo.next()) {
         	curtype=CustomerTypeComInfo.getCustomerTypeid();
         	curtypename=CustomerTypeComInfo.getCustomerTypename();
         	if(curtype.equals(crmtype))	selected="selected";
         	else	selected="";
         	%>
         <option value="<%=curtype%>" <%=selected%>><%=Util.toScreen(curtypename,user.getLanguage())%></option>
         <%}
         CustomerTypeComInfo.setTofirstRow();
         %>
         </select>
     </td>
     <td width="20%"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%>
         <select name="crmstatus" size=1 >
         <option value="">&nbsp;</option>
         <%
         String curstatus="";
         String curstatusname="";
         selected="";
         while(CustomerStatusComInfo.next()) {
         	curstatus=CustomerStatusComInfo.getCustomerStatusid();
         	curstatusname=CustomerStatusComInfo.getCustomerStatusname();
         	if(curstatus.equals(crmstatus))	selected="selected";
         	else	selected="";
         	%>
         <option value="<%=curstatus%>" <%=selected%>><%=Util.toScreen(curstatusname,user.getLanguage())%></option>
         <%}
         CustomerStatusComInfo.setTofirstRow();
         %>
         </select>
     </td>
     <td width="60%">　</td>
  </tr>
  </tbody>
</table>
<table class=viewform>
<colgroup>
<col width=10px>
<col width="49%">
<col width=10px>
<col width="49%">
<TBODY>
<TR CLASS=title><TD COLSPAN=4>
<B><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>
(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=crmallnum%>)</B></TD></TR>
<TR CLASS=spacing><TD CLASS=Sep2 COLSPAN=4></TD></TR>
<tr>
<%
	String managerid="";
	String crmid="";
	String crmname="";
	String checked="";
	crmids=Util.TokenizerString(crmidstr,",");
	i=0;
     String sql="select id,name,language,manager,type,status , seclevel FROM CRM_CustomerInfo where (deleted is null or deleted<>1) and manager="+fromid;
    if(!crmtype.equals(""))
        sql+=" and type="+crmtype;
    if(!crmstatus.equals(""))
        sql+=" and status="+crmstatus;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
			crmid=RecordSet.getString("id");
			curtype=RecordSet.getString("type");
			curtypename=CustomerTypeComInfo.getCustomerTypename(curtype);
			crmname=RecordSet.getString("name");
			i++;
			checked="";
			for(j=0;j<crmids.size();j++){
				if(((String)crmids.get(j)).equals(crmid))
					checked="checked";
			}
			%>
			<TD><INPUT TYPE=CheckBox VALUE="<%=crmid%>" NAME=ids <%=checked%>></TD>
			<td class=field><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>" target=_blank>
			<%=Util.toScreen(crmname,user.getLanguage())%> , <%=Util.toScreen(curtypename,user.getLanguage())%></a></td>
			<%
			if((i%2)==0){	%>  </tr><tr>   <%}

	}
if((i%2)==0){	%></tr><%}
if((i%2)==1){	%><td>&nbsp;</td><td>&nbsp;</td></tr><%}
%>
</tbody>
</table>
<%}%>

<% if(type==2) { %>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page"/>
<%
String projecttype=Util.null2String(request.getParameter("projecttype"));
String projectstatus=Util.null2String(request.getParameter("projectstatus"));
String worktype=Util.null2String(request.getParameter("worktype"));
%>
<table class=viewform>
  <tr class=Section><th colspan=4><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></th></tr>
  <TR CLASS=Separator><TD CLASS=Sep2 COLSPAN=4></TD></TR>
  <tr>
     <td width="20%"><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%>
         <select name="projecttype" size=1 >
         <option value="">&nbsp;</option>
         <%
         String curtype="";
         String curtypename="";
         String selected="";
         while(ProjectTypeComInfo.next()) {
         	curtype=ProjectTypeComInfo.getProjectTypeid();
         	curtypename=ProjectTypeComInfo.getProjectTypename();
         	if(curtype.equals(projecttype))	selected="selected";
         	else	selected="";
         	%>
         <option value="<%=curtype%>" <%=selected%>><%=Util.toScreen(curtypename,user.getLanguage())%></option>
         <%}
         ProjectTypeComInfo.setTofirstRow();
         %>
         </select>
     </td>
     <td width="20%"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%>
         <select name="worktype" size=1 >
         <option value="">&nbsp;</option>
         <%
         curtype="";
         curtypename="";
         selected="";
         while(WorkTypeComInfo.next()) {
         	curtype=WorkTypeComInfo.getWorkTypeid();
         	curtypename=WorkTypeComInfo.getWorkTypename();
         	if(curtype.equals(worktype))	selected="selected";
         	else	selected="";
         	%>
         <option value="<%=curtype%>" <%=selected%>><%=Util.toScreen(curtypename,user.getLanguage())%></option>
         <%}
         WorkTypeComInfo.setTofirstRow();
         %>
         </select>
     </td>
     <td width="20%"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%>
         <select name="projectstatus" size=1 >
         <option value="">&nbsp;</option>
         <%
         String curstatus="";
         String curstatusname="";
         selected="";
         while(ProjectStatusComInfo.next()) {
         	curstatus=ProjectStatusComInfo.getProjectStatusid();
         	curstatusname=ProjectStatusComInfo.getProjectStatusname();
         	String _name = SystemEnv.getHtmlLabelName(Integer.valueOf(curstatusname).intValue(),user.getLanguage());
         	if(curstatus.equals(projectstatus))	selected="selected";
         	else	selected="";
         	%>
         <option value="<%=curstatus%>" <%=selected%>><%=_name%></option>
         <%}
         ProjectStatusComInfo.setTofirstRow();
         %>
         </select>
     </td>
     <td width="40%">　</td>
  </tr>
  </tbody>
</table>
<table class=viewform>
<colgroup>
<col width=10px>
<col width="49%">
<col width=10px>
<col width="49%">
<TBODY>
<TR CLASS=title><TD COLSPAN=4>
<B><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>
(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=projectallnum%>)</B></TD></TR>
<TR CLASS=spacing><TD CLASS=Sep2 COLSPAN=4></TD></TR>
<tr>
<%
	String managerid="";
	String projectid="";
	String projectname="";
	String checked="";
	projectids=Util.TokenizerString(projectidstr,",");
	i=0;
	while(ProjectInfoComInfo.next()){
		if(!projecttype.equals("")){
			if(!projecttype.equals(ProjectInfoComInfo.getProjectInfoprjtype()))
			continue;
		}
		if(!worktype.equals("")){
			if(!worktype.equals(ProjectInfoComInfo.getProjectInfoworktype()))
			continue;
		}
		if(!projectstatus.equals("")){
			if(!projectstatus.equals(ProjectInfoComInfo.getProjectInfostatus()))
			continue;
		}
		managerid=ProjectInfoComInfo.getProjectInfomanager();
		if(fromid.equals(managerid)){
			projectid=ProjectInfoComInfo.getProjectInfoid();
			curtype=ProjectInfoComInfo.getProjectInfoprjtype();
			curtypename=ProjectTypeComInfo.getProjectTypename(curtype);
			projectname=ProjectInfoComInfo.getProjectInfoname();
			i++;
			checked="";
			for(j=0;j<projectids.size();j++){
				if(((String)projectids.get(j)).equals(projectid))
					checked="checked";
			}
			%>
			<TD><INPUT TYPE=CheckBox VALUE="<%=projectid%>" NAME=ids <%=checked%>></TD>
			<td class=field><a href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>"  target=_blank>
			<%=Util.toScreen(projectname,user.getLanguage())%> , <%=Util.toScreen(curtypename,user.getLanguage())%></a></td>
			<%
			if((i%2)==0){	%>  </tr><tr>   <%}
		}
	}
if((i%2)==0){	%></tr><%}
if((i%2)==1){	%><td>&nbsp;</td><td>&nbsp;</td></tr><%}
%>
</tbody>
</table>
<%}%>

<% 
  if(type==5)
  {
%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<table class=viewform>
  <colgroup>
    <col width=10px>
    <col width="49%">
    <col width=10px>
    <col width="49%">
  <TBODY>
  <TR CLASS=title>
    <TD COLSPAN=4>
      <B><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=eventAllNum%>)</B>
    </TD>
  </TR>
  <TR CLASS=spacing>
    <TD CLASS=Sep2 COLSPAN=4></TD>
  </TR>
  <tr>
  <%
    eventIDs = Util.TokenizerString(eventIDStr, ",");
    i=0;
    
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    if(logintype.equals("2"))
    {
      usertype= 1;
    }

    
    StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("SELECT DISTINCT a.workflowId, a.requestId, a.requestName, a.creater, a.createDate, a.createTime");
	stringBuffer.append(" FROM Workflow_RequestBase a, Workflow_CurrentOperator b");
	stringBuffer.append(" WHERE a.requestId = b.requestId");
	stringBuffer.append(" AND b.isRemark in ('2', '4')");
	stringBuffer.append(" AND isLastTimes = 1");
	stringBuffer.append(" AND userId = ");
	stringBuffer.append(fromid);
	stringBuffer.append(" AND userType = ");	
	stringBuffer.append(usertype);
	stringBuffer.append(" AND (b.isComplete = 1 OR (b.agenttype<>1");
	stringBuffer.append("  OR (b.agenttype=1 AND NOT EXISTS(");
	stringBuffer.append("   SELECT 1 FROM workflow_currentoperator b2 WHERE b2.userid=b.agentorbyagentid AND b2.agenttype=2 AND b2.agentorbyagentid=b.userid AND b2.isremark='0'");
	stringBuffer.append(" ))))");
	stringBuffer.append(" ORDER BY createDate DESC , createTime DESC");
                        
    RecordSet.executeSql(stringBuffer.toString());
    
    while(RecordSet.next())
    {   
        String eventID = "";
        String eventName = "";
        String checked="";
        
        String theworkflowid = Util.null2String(RecordSet.getString("workflowId"));
        String isValid = WorkflowComInfo.getIsValid(theworkflowid);
        if("1".equals(isValid) || "3".equals(isValid))
        {
            eventID = Util.null2String(RecordSet.getString("requestId"));
            eventName = Util.null2String(RecordSet.getString("requestName"));
            checked="";
            i++;
            
            for(j=0;j<eventIDs.size();j++)
            {
                if(((String)eventIDs.get(j)).equals(eventID))
                {
                    checked="checked";
                }
            }            
  %>
    <TD><INPUT TYPE=CheckBox VALUE="<%=eventID%>" NAME=ids <%=checked%>></TD>
    <td class=field>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=eventID%>" target=_blank>
        <%=Util.toScreen(eventName,user.getLanguage())%>
      </a>
    </td>
    <%  
        }
        if((i%2)==0)
        {
    %>
  </tr>
  <tr>
  <%
        }
      }

      if((i%2)==0)
      {
  %>
  </tr>
  <%
      }
      if((i%2)==1)
      {
  %>
  <td>&nbsp;</td><td>&nbsp;</td></tr>
  <%
      }
  %>
</tbody>
</table>
<%
    }
%>
<% 
  if(type==6)
  {
%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<table class=viewform>
  <colgroup>
    <col width=10px>
    <col width="49%">
    <col width=10px>
    <col width="49%">
  <TBODY>
  <TR CLASS=title>
    <TD COLSPAN=4>
      <B><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=coworkAllNum%>)</B>
    </TD>
  </TR>
  <TR CLASS=spacing>
    <TD CLASS=Sep2 COLSPAN=4></TD>
  </TR>
  <tr>
  <%
    coworkIDs = Util.TokenizerString(coworkIDStr, ",");
    i=0;
    
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    if(logintype.equals("2"))
    {
      usertype= 1;
    }
                        
    RecordSet.executeSql("select * from cowork_items where coworkmanager="+fromid);
    
    while(RecordSet.next()){   
        i++;
        String coworkID = Util.null2String(RecordSet.getString("id"));
        String coworkName = Util.null2String(RecordSet.getString("name"));
        String checked="";
            
            for(j=0;j<coworkIDs.size();j++){
                if(((String)coworkIDs.get(j)).equals(coworkID))
                {
                    checked="checked";
                }
            }            
  %>
    <TD><INPUT TYPE=CheckBox VALUE="<%=coworkID%>" NAME=ids <%=checked%>></TD>
    <td class=field>
      <a href="/cowork/ViewCoWork.jsp?id=<%=coworkID%>" target=_blank>
        <%=Util.toScreen(coworkName,user.getLanguage())%>
      </a>
    </td>
    <% 
        if((i%2)==0)
        {
    %>
  </tr>
  <tr>
  <%
        }
      }

      if((i%2)==0)
      {
  %>
  </tr>
  <%
      }
      if((i%2)==1)
      {
  %>
  <td>&nbsp;</td><td>&nbsp;</td></tr>
  <%
      }
  %>
</tbody>
</table>
<%
    }
%>
<% 
  if(type==7)
  {
%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<table class=viewform>
  <colgroup>
    <col width=10px>
    <col width="49%">
    <col width=10px>
    <col width="49%">
  <TBODY>
  <TR CLASS=title>
    <TD COLSPAN=4>
      <B><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(fromid),user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:<%=pendingEventAllNum%>)</B>
    </TD>
  </TR>
  <TR CLASS=spacing>
    <TD CLASS=Sep2 COLSPAN=4></TD>
  </TR>
  <tr>
  <%
  	pendingEventIDs = Util.TokenizerString(pendingEventIDStr, ",");
    i=0;
    
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    if(logintype.equals("2"))
    {
      usertype= 1;
    }

    
    StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("SELECT DISTINCT a.workflowId, a.requestId, a.requestName, a.creater, a.createDate, a.createTime");
	stringBuffer.append(" FROM Workflow_RequestBase a, Workflow_CurrentOperator b");
	stringBuffer.append(" WHERE a.requestId = b.requestId");
	stringBuffer.append(" AND b.isRemark in ('0','1','5','8','9','7')");
	stringBuffer.append(" AND isLastTimes = 1");
	stringBuffer.append(" AND userId = ");
	stringBuffer.append(fromid);
	stringBuffer.append(" AND userType = ");	
	stringBuffer.append(usertype);
	stringBuffer.append(" ORDER BY createDate DESC , createTime DESC");
                        
    RecordSet.executeSql(stringBuffer.toString());
    
    while(RecordSet.next())
    {   
        String pendingEventID = "";
        String pendingEventName = "";
        String checked="";
        
        String theworkflowid = Util.null2String(RecordSet.getString("workflowId"));
        String isValid = WorkflowComInfo.getIsValid(theworkflowid);
        if("1".equals(isValid) || "3".equals(isValid))
        {
        	pendingEventID = Util.null2String(RecordSet.getString("requestId"));
        	pendingEventName = Util.null2String(RecordSet.getString("requestName"));
            checked="";
            i++;
            
            for(j=0;j<pendingEventIDs.size();j++)
            {
                if(((String)pendingEventIDs.get(j)).equals(pendingEventID))
                {
                    checked="checked";
                }
            }            
  %>
    <TD><INPUT TYPE=CheckBox VALUE="<%=pendingEventID%>" NAME=ids <%=checked%>></TD>
    <td class=field>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=pendingEventID%>" target=_blank>
        <%=Util.toScreen(pendingEventName,user.getLanguage())%>
      </a>
    </td>
    <%  
        }
        if((i%2)==0)
        {
    %>
  </tr>
  <tr>
  <%
        }
      }

      if((i%2)==0)
      {
  %>
  </tr>
  <%
      }
      if((i%2)==1)
      {
  %>
  <td>&nbsp;</td><td>&nbsp;</td></tr>
  <%
      }
  %>
</tbody>
</table>
<%
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}
%>


<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18463,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();

String agentid = Util.fromScreen(request.getParameter("agentid"),user.getLanguage());

String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);

int beagenterId=0;
int agenterId=0;
int isCreateAgenter=0;
int workflowid = 0;
int ispending = 0;
String beginDate="";
String beginTime="";
String endDate="";
String endTime="";
String agentType="1";
  rs.executeSql("select * from Workflow_Agent where agentId = " + agentid);
  if(rs.next()){
    workflowid = rs.getInt("workflowid");
    agenterId=rs.getInt("agenterId");
    ispending = Util.getIntValue(rs.getString("ispending"), 0);
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");
    beagenterId = rs.getInt("beagenterId");
    agentType= rs.getString("agenttype");
  }


%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if (haveAgentAllRight||(""+beagenterId).equals(String.valueOf(user.getUID()))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="frmmain" action="/workflow/request/wfAgentOperatorNew.jsp" method="post">
<input type="hidden" value="edit" name="method">
<input type="hidden" value="<%=workflowid%>" name="beagentwfid">
<input type="hidden" value="<%=agentid%>" name="agentid">
  <TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>   

  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD>
    <TD class="Field">
       <%=WorkflowComInfo.getWorkflowname(""+workflowid)%>
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

      <!--被代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
    <TD class="Field">
      <SPAN id="beagenterspan"><A href="javaScript:openhrm(<%=beagenterId%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(beagenterId)).toString()),user.getLanguage())%></A></SPAN>
              <INPUT type="hidden" name="beagenterId" value="<%=beagenterId%>">
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TD>
    <TD class="Field">
      <SPAN id="Agenterspan"><%if(agenterId==0){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
      <A href="javaScript:openhrm(<%=agenterId%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(agenterId)).toString()),user.getLanguage())%></A></SPAN> 
      <INPUT type="hidden" name="agenterId"  id ="agenterId" value=<%=agenterId%>>
 
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--开始时间-->
  <TR>          
  <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">
   
      <button type=button  class="Calendar" id="SelectBeginDate" onclick="onshowAgentBDate()"></BUTTON> 
      <SPAN id="begindatespan"><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type=button  class="Clock" id="SelectBeginTime" onclick="onshowAgentTime('begintimespan','beginTime')"></BUTTON>
      <SPAN id="begintimespan"><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN></TD>
  
       <INPUT type="hidden" name="beginDate" value=<%=beginDate%>>
       <INPUT type="hidden" name="beginTime" value=<%=beginTime%>>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--结束时间-->
  <TR>    <TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">

      <button type=button  class="Calendar" id="SelectEndDate" onclick="onshowAgentEDate()"></BUTTON> 
      <SPAN id="enddatespan"><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type=button  class="Clock" id="SelectEndTime" onclick="onshowAgentTime('endtimespan', 'endTime')"></BUTTON>
      <SPAN id="endtimespan"><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN> </TD>
    
       <INPUT type="hidden" name="endDate" value=<%=endDate%>>
       <INPUT type="hidden" name="endTime" value=<%=endTime%>>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR> 
   
    <!--是否为可创建代理-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></TD>
    <TD class="Field">
        <INPUT class=InputStyle type=checkbox value=1 name='isCreateAgenterShow' value=1 disabled=true <%if(isCreateAgenter==1 ){%>checked><%}else{%>><%}%>
        <INPUT type="hidden" name="isCreateAgenter" value=<%=isCreateAgenter%>>
  </TR>
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <!--是否处理待办事宜-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></TD>
    <TD class="Field">
		<INPUT id="ispending" name="ispending" class="InputStyle" type="checkbox" value="1" disabled <%if(ispending==1){out.print("checked");}%> >
		<INPUT id="isPendThing" name="isPendThing" type="hidden" value="<%=ispending%>" >
   </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15591,user.getLanguage())%></TD>
    <TD class="Field">
          <%
       if(
      "1".equals(agentType)
      && 
      (endDate == null || "".equals(endDate) || endDate.compareTo(currentDate)>0 || 
          ((endDate.compareTo(currentDate)==0 &&  ("".equals(endTime) || endTime == null)) ||
          (endDate.compareTo(currentDate)==0 &&  endTime.compareTo(currentTime)>0)))
      &&
      (beginDate == null || "".equals(beginDate) || beginDate.compareTo(currentDate)<0 || 
         ((beginDate.compareTo(currentDate)==0 &&  ("".equals(beginTime) || beginTime == null)) ||
         (beginDate.compareTo(currentDate)==0 &&  beginTime.compareTo(currentTime)<0)))
      
      )
      
      {%>
     	<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
      <%}%>
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  </TBODY>
  </TABLE>

</form>

</body>

<script language="VBS">
sub onShowHrm(spanname,inputename)
  id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
  if (Not IsEmpty(id)) then
  if id(0)<> "" then
    spanname.innerHTML= "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
    inputename.value=id(0)
  else 
    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    inputename.value=""
  end if
  end if
end sub
</script>

<script language="JavaScript">
function goBack() {
	document.location.href="/workflow/request/wfAgentList.jsp?agentid=<%=agenterId%>&beagentid=<%=beagenterId%>&agenttype=<%=agentType%>"
}
function doSave(obj){
	//加入提交前的时间判断
	var beginDateTime = document.frmmain.beginDate.value+' '+document.frmmain.beginTime.value;
	var endDateTime = document.frmmain.endDate.value+' '+document.frmmain.endTime.value;
	if(beginDateTime.valueOf()>endDateTime.valueOf()) {
		alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
		return;
	}
   if(document.frmmain.beagenterId.value==0){
       alert("<%=SystemEnv.getHtmlNoteName(81,user.getLanguage())%>");
   }
   else if(document.frmmain.agenterId.value==0){
       alert("<%=SystemEnv.getHtmlNoteName(82,user.getLanguage())%>");
   }
   else if(document.frmmain.beagenterId.value==document.frmmain.agenterId.value){
        alert("<%=SystemEnv.getHtmlNoteName(83,user.getLanguage())%>");
   }
   else{
       window.document.frmmain.submit();
       obj.disabled = true;
   }
 
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>

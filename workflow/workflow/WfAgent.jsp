<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(60,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17564,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();

String workflowid = Util.fromScreen(request.getParameter("workflowid"),user.getLanguage());
String workflowname=WorkflowComInfo.getWorkflowname(workflowid);

boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}
boolean haveAgentSelfRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:Self", user)){
  haveAgentSelfRight=true;
}

int beagenterId=0;
int agenterId=0;
String beginDate="";
String beginTime="";
String endDate="";
String endTime="";
int isCreateAgenter=0;
int rowsum=0;

if(!haveAgentAllRight){
  beagenterId=userid;
  rs.executeSql("select * from Workflow_Agent where workflowid="+workflowid+ " and beagenterId="+beagenterId);
  if(rs.next()){
    agenterId=rs.getInt("agenterId");
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");
  }
}
%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(haveAgentAllRight){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSaveWithAllRight(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else if(haveAgentSelfRight){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSaveWithSelfRight(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="frmmain" action="/workflow/workflow/WfAgentOperation.jsp" method="post">
  <input type="hidden" value="<%=haveAgentAllRight%>" name="haveAgentAllRight">
  <input type="hidden" value="<%=workflowid%>" name="workflowid">
  <input type="hidden" value="add" name="method">
  <TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>   

  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD>
    <TD class="Field"><%=workflowname%></TD>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR>

    <!--被代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
    <TD class="Field">
    <%if (haveAgentAllRight) {%>
    <BUTTON class="Browser" id="SelectBeagenter" onclick="onShowHrm(beagenterspan,beagenterId)"></BUTTON> 
      <SPAN id="beagenterspan"><%if(beagenterId==0){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
      <A href="javaScript:openhrm(<%=beagenterId%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(beagenterId)).toString()),user.getLanguage())%></A></SPAN> 
      <INPUT type="hidden" name="beagenterId"  id ="beagenterId" value=<%=beagenterId%>>
  <%} else {%>  
      <SPAN id="agentidspan"><A href="javaScript:openhrm(<%=beagenterId%>);" onclick='pointerXY(event);'>
      <%=user.getUsername()%></A></SPAN>
              <INPUT type="hidden" name="beagenterId" value="<%=beagenterId%>">
  <%}%>
      </TD>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR>

    <!--代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TD>
    <TD class="Field">
      <%if (haveAgentAllRight || haveAgentSelfRight) {%>
    <BUTTON class="Browser" id="SelectAgenter" onclick="onShowHrm(Agenterspan,agenterId)"></BUTTON> 
      <SPAN id="Agenterspan"><%if(agenterId==0){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
      <A href="javaScript:openhrm(<%=agenterId%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(agenterId)).toString()),user.getLanguage())%></A></SPAN> 
      <INPUT type="hidden" name="agenterId"  id ="agenterId" value=<%=agenterId%>>
  <%} else {%>  
      <SPAN id="Agenterspan"><A href="javaScript:openhrm(<%=agenterId%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(agenterId)).toString()),user.getLanguage())%></A></SPAN>
  <%}%>
      </TD>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR>

    <!--开始时间-->
  <TR>          
  <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">
      <%if (haveAgentAllRight || haveAgentSelfRight) {%>
      <BUTTON class="Calendar" id="SelectBeginDate" onclick="onShowDate(begindatespan,beginDate)"></BUTTON> 
      <SPAN id="begindatespan"><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <BUTTON class="Clock" id="SelectBeginTime" onclick="onShowTime(begintimespan,beginTime)"></BUTTON>
      <SPAN id="begintimespan"><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN></TD>
       <%} else {%> 
            <SPAN id="begindatespan"><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
            <SPAN id="begintimespan"><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN>
       <%}%>
       <INPUT type="hidden" name="beginDate" value=<%=beginDate%>>
       <INPUT type="hidden" name="beginTime" value=<%=beginTime%>>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR>

    <!--结束时间-->
  <TR>    <TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">
      <%if (haveAgentAllRight || haveAgentSelfRight) {%>
      <BUTTON class="Calendar" id="SelectEndDate" onclick="onShowDate(enddatespan,endDate)"></BUTTON> 
      <SPAN id="enddatespan"><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <BUTTON class="Clock" id="SelectEndTime" onclick="onShowTime(endtimespan,endTime)"></BUTTON>
      <SPAN id="endtimespan"><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN> </TD>
       <%} else {%> 
           <SPAN id="enddatespan"><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN>
           <SPAN id="endtimespan"><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN> 
       <%}%>
       <INPUT type="hidden" name="endDate" value=<%=endDate%>>
       <INPUT type="hidden" name="endTime" value=<%=endTime%>>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR> 

    <!--是否为可创建代理-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></TD>
    <TD class="Field">
      <%if (haveAgentAllRight || haveAgentSelfRight) {%>
        <INPUT class=InputStyle type=checkbox value=1 name='isCreateAgenter' value=1 <%if(isCreateAgenter==1 ){%>checked><%}else{%>><%}%>
  <%} else {%>  
        <INPUT class=InputStyle type=checkbox value=1 name='isCreateAgenter' value=1 disabled=true <%if(isCreateAgenter==1 ){%>checked><%}else{%>><%}%>
  <%}%>
      </TD>
  </TR>
  <TR><TD class="Line" colSpan="2"></TD></TR>

  </TBODY>
  </TABLE>

<!-- 明细列表 -->
<%
if(haveAgentAllRight){
%>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>

<TABLE class=ListStyle cellspacing=1 id="oTable">
 <COLGROUP>
  <COL width="8%">
  <COL width="16%">
  <COL width="16%">
  <COL width="22%">
  <COL width="22%">
  <COL width="16%">
 <TBODY>
   <TR class=Header>
    <TH colSpan=6><%=SystemEnv.getHtmlLabelName(17564,user.getLanguage())%></TH>
   </TR>
   <TR class=header>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TD>    
    <TD class=Field><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>   
    <TD class=Field><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>   
    <TD class=Field><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></TD>        
  </TR>
  <TR class=Line><TD colspan="6" ></TD></TR> 
<%
  int colorcount=0;
  rs.executeSql("select * from Workflow_Agent where workflowid="+workflowid);
  while(rs.next()){
    beagenterId=rs.getInt("beagenterId");
    agenterId=rs.getInt("agenterId");
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");

    if(colorcount==0){
            colorcount=1;
    %>
    <TR class=DataLight>
    <%
        }else{
            colorcount=0;
    %>
    <TR class=DataDark>
  <%
  }
  %>
<td height="23"><input type='checkbox' name='check_agent' value="<%=beagenterId%>" >
<input type="hidden" name="agent_<%=rowsum%>_beagenterId" value="<%=beagenterId%>">
<input type="hidden" name="agent_<%=rowsum%>_agenterId" value="<%=agenterId%>">
<input type="hidden" name="agent_<%=rowsum%>_beginDate" value="<%=beginDate%>">
<input type="hidden" name="agent_<%=rowsum%>_beginTime" value="<%=beginTime%>">
<input type="hidden" name="agent_<%=rowsum%>_endDate" value="<%=endDate%>">
<input type="hidden" name="agent_<%=rowsum%>_endTime" value="<%=endTime%>">
<input type="hidden" name="agent_<%=rowsum%>_isCreateAgenter" value="<%=isCreateAgenter%>">

</td>
<td height="23">
    <A href="javaScript:openhrm(<%=beagenterId%>);" onclick='pointerXY(event);'>
    <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(beagenterId)).toString()),user.getLanguage())%></A>
</td>
<td height="23">
    <A href="javaScript:openhrm(<%=agenterId%>);" onclick='pointerXY(event);'>
    <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(agenterId)).toString()),user.getLanguage())%></A>
</td>
<td height="23">
    <SPAN ><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
    <SPAN ><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN>
</td>
<td height="23">
    <SPAN ><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN>
    <SPAN ><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN> 
</td>
<td height="23">
    <%if(isCreateAgenter==1){%><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%><%}%>
</td>
</TR>

<%
    rowsum += 1;
  }
}





%>
<input type="hidden" name="rowsum" value=<%=rowsum%>>
 </tbody>
</table>


</FORM>
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

sub onShowDate(spanname1,inputename1)
  returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
  spanname1.innerHTML= returndate
  inputename1.value=returndate
  dim mvar
  if(frmmain.beginDate.value<>"" and frmmain.endDate.value<>"" and (frmmain.endDate.value<frmmain.beginDate.value or (frmmain.endDate.value=frmmain.beginDate.value and frmmain.beginTime.value<>"" and frmmain.endTime.value<>"" and frmmain.endTime.value<frmmain.beginTime.value))) then
    mvar=MsgBox("开始日期、时间不能小于结束日期、时间！",48,"流程代理") 
    spanname1.innerHTML= ""
    inputename1.value=""
  end if
end sub

sub onShowTime(spanname2,inputename2)
  returntime = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
  spanname2.innerHTML = returntime
  inputename2.value=returntime
  if(frmmain.beginDate.value<>"" and frmmain.endDate.value<>"" and frmmain.endDate.value=frmmain.beginDate.value and frmmain.beginTime.value<>"" and frmmain.endTime.value<>"" and frmmain.endTime.value<frmmain.beginTime.value) then
    mvar=MsgBox("开始日期、时间不能小于结束日期、时间！",48,"流程代理") 
    spanname2.innerHTML= ""
    inputename2.value=""
  end if
end sub
</script>

<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script language="JavaScript">
var rowColor="" ;
var rowindex = <%=rowsum%>;

function addRow(){    
   if(document.frmmain.beagenterId.value==0 || document.frmmain.agenterId.value==0){
       alert("<%=SystemEnv.getHtmlLabelName(129503, user.getLanguage())%>");
   }else if(document.frmmain.beagenterId.value==document.frmmain.agenterId.value){
        alert("<%=SystemEnv.getHtmlLabelName(129504, user.getLanguage())%>");
   }else {
      var hasexist="false"
      for(i=0; i<rowindex; i++){
        var isexist="false";
        len = frmmain.elements.length;
        for (k = len-1; k >= 0; k--) {
            elem = document.forms[0].elements[k];
            if (elem.name == 'agent_'+i+'_beagenterId')
            isexist="true";
        }
        if(isexist=="true" && document.frmmain.beagenterId.value==document.all('agent_'+i+'_beagenterId').value){
          hasexist="true"
        }
      }
      
      if(hasexist=="false"){
        rowColor = getRowBg();

        oRow = oTable.insertRow();
        for(j=0; j<6; j++) {
          oCell = oRow.insertCell();
          oCell.style.height=18;
          oCell.style.background= rowColor;
          switch(j) {
            case 0:
              var oDiv = document.createElement("div");
              var sHtml = "<input type='checkbox' name='check_agent' value='0'>";
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              break;
            case 1:
              var oDiv = document.createElement("div");
              var sHtml=document.all("beagenterspan").innerHTML;
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              var rowvalue1 = document.frmmain.beagenterId.value ;
              var oDiv1 = document.createElement("div");
              var sHtml1 = "<input type='hidden' name='agent_"+rowindex+"_beagenterId'  value='"+rowvalue1+"'>";
              oDiv1.innerHTML = sHtml1;
              oCell.appendChild(oDiv1);
              break;
            case 2:
              var oDiv = document.createElement("div");
              var sHtml=document.all("Agenterspan").innerHTML;
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              var rowvalue2 = document.frmmain.agenterId.value ;
              var oDiv2 = document.createElement("div");
              var sHtml2 = "<input type='hidden' name='agent_"+rowindex+"_agenterId'  value='"+rowvalue2+"'>";
              oDiv2.innerHTML = sHtml2;
              oCell.appendChild(oDiv2);
              break;
            case 3:
              var oDiv = document.createElement("div");
              var sHtml =document.frmmain.beginDate.value+"  "+document.frmmain.beginTime.value;
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              var rowvalue3 = document.frmmain.beginDate.value ;
              var oDiv3 = document.createElement("div");
              var sHtml3 = "<input type='hidden' name='agent_"+rowindex+"_beginDate'  value='"+rowvalue3+"'>";
              oDiv3.innerHTML = sHtml3;
              oCell.appendChild(oDiv3);
              var rowvalue4 = document.frmmain.beginTime.value ;
              var oDiv4 = document.createElement("div");
              var sHtml4 = "<input type='hidden' name='agent_"+rowindex+"_beginTime'  value='"+rowvalue4+"'>";
              oDiv4.innerHTML = sHtml4;
              oCell.appendChild(oDiv4);
              break;
            case 4:
              var oDiv = document.createElement("div");
              var sHtml =document.frmmain.endDate.value+"  "+document.frmmain.endTime.value;
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              var rowvalue5 = document.frmmain.endDate.value ;
              var oDiv5 = document.createElement("div");
              var sHtml5 = "<input type='hidden' name='agent_"+rowindex+"_endDate'  value='"+rowvalue5+"'>";
              oDiv5.innerHTML = sHtml5;
              oCell.appendChild(oDiv5);
              var rowvalue6 = document.frmmain.endTime.value ;
              var oDiv6 = document.createElement("div");
              var sHtml6 = "<input type='hidden' name='agent_"+rowindex+"_endTime'  value='"+rowvalue6+"'>";
              oDiv6.innerHTML = sHtml6;
              oCell.appendChild(oDiv6);
              break;
            case 5:
              var oDiv = document.createElement("div");
              var sHtml;
              if(document.frmmain.isCreateAgenter.checked==true)
                sHtml='<%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%>'
              else
                sHtml='<%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%>'
              oDiv.innerHTML = sHtml;
              oCell.appendChild(oDiv);
              var oDiv7 = document.createElement("div");
              var sHtml7;
              if(document.frmmain.isCreateAgenter.checked==true)
                sHtml7 = "<input type='hidden' name='agent_"+rowindex+"_isCreateAgenter'  value='1'>";
              else
                sHtml7 = "<input type='hidden' name='agent_"+rowindex+"_isCreateAgenter'  value='0'>";
              oDiv7.innerHTML = sHtml7;
              oCell.appendChild(oDiv7);
              break;
          }
        }
        rowindex = rowindex +1;
        document.all("rowsum").value=rowindex;
        return;
      }else{
        alert("<%=SystemEnv.getHtmlLabelName(129505, user.getLanguage())%>");
      }
   }
}

function deleteRow()
{
  len = document.forms[0].elements.length;
  var i=0;
  var rowsum1 = 0;
  for(i=len-1; i >= 0;i--) {
    if (document.forms[0].elements[i].name=='check_agent')
      rowsum1 += 1;
  }
  for(i=len-1; i >= 0;i--) {
    if (document.forms[0].elements[i].name=='check_agent'){
      if(document.forms[0].elements[i].checked==true) {
        oTable.deleteRow(rowsum1+2);
        rowindex = rowindex -1;
      }
      rowsum1 -=1;
    }
  }
}

function dodelete(){
  document.all("method").value="delete";
  window.document.frmmain.submit();
}
function doSaveWithAllRight(){
  document.all("method").value="add";
  window.document.frmmain.submit();
}
function doSaveWithSelfRight(){
  document.all("method").value="add";
   if(document.frmmain.beagenterId.value==0 || document.frmmain.agenterId.value==0){
       alert("<%=SystemEnv.getHtmlLabelName(129503, user.getLanguage())%>");
   }else if(document.frmmain.beagenterId.value==document.frmmain.agenterId.value){
        alert("<%=SystemEnv.getHtmlLabelName(129504, user.getLanguage())%>");
   }else{
       window.document.frmmain.submit();
   }
}
function goBack() {
	document.location.href="/workflow/workflow/WfAgentList.jsp"
}
</script>
</html>

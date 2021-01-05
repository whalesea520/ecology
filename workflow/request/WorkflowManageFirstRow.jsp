
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

int isremark = Util.getIntValue(Util.null2String(request.getParameter("isremark")),0);
int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
String nodetype = Util.null2String(request.getParameter("nodetype"));
String isaffirmancebody = Util.null2String(request.getParameter("isaffirmancebody"));
String reEditbody = Util.null2String(request.getParameter("reEditbody"));
String requestid = Util.null2String(request.getParameter("requestid"));
String requestname = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestname"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
int rqMessageType = Util.getIntValue(Util.null2String(request.getParameter("rqMessageType")),0);
int wfMessageType = Util.getIntValue(Util.null2String(request.getParameter("wfMessageType")),0);
String isEdit_ = Util.null2String(request.getParameter("isEdit_"));

boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒
if(isremark==1||isremark==8||isremark==9||isremark==7) editflag = false;//被转发人或被抄送人不能编辑

String requestlevel_disabled="disabled";
WFNodeFieldMainManager.resetParameter();
WFNodeFieldMainManager.setNodeid(nodeid);
WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
WFNodeFieldMainManager.selectWfNodeField();
if(WFNodeFieldMainManager.getIsedit().equals("1")||"0".equals(nodetype))
	requestlevel_disabled="";
WFNodeFieldMainManager.closeStatement();
	
String messageType_disabled="disabled";
WFNodeFieldMainManager.resetParameter();
WFNodeFieldMainManager.setNodeid(nodeid);
WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
WFNodeFieldMainManager.selectWfNodeField();
if(WFNodeFieldMainManager.getIsedit().equals("1")||"0".equals(nodetype))
	messageType_disabled="";

if(editflag&&"0".equals(nodetype)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
  <TR>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=fieldvalueClass>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
				<%if(requestlevel_disabled.equals("")){%>
        <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
        <%}else{%>
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
        <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
        <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
        <%}%>
      </TD>
  </TR>
  <TR style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>

<%
      if (wfMessageType==1) {
%>
                  <TR>
                    <TD class="fieldnameClass" > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                    <TD class=fieldvalueClass>
                          <span id=messageTypeSpan></span>
                          <%if(messageType_disabled.equals("")){%>
                          <input type=radio value="0" name="messageType" <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                          <input type=radio value="1" name="messageType" <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                          <input type=radio value="2" name="messageType" <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                          <%}else{%>
                          <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
                          <%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
                          <%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
                          <input type=hidden name=messageType value="<%=rqMessageType%>">
                          <%}%>
                        </td>
                  </TR>  	   	
                  <TR  style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
      <%}%>
<%}else if(editflag&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
  <TR>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=fieldvalueClass>
        <%if("1".equals(isEdit_)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
        <%}else{%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
        <%}%>
				<%if(requestlevel_disabled.equals("")){%>
        <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
        <%}else{%>
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
        <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
        <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
        <%}%>
      </TD>
  </TR>
  <TR style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>

<%
      if (wfMessageType==1) {
%>
                  <TR>
                    <TD class="fieldnameClass" > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                    <TD class=fieldvalueClass>
                          <span id=messageTypeSpan></span>
                          <%if(messageType_disabled.equals("")){%>
                          <input type=radio value="0" name="messageType" <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                          <input type=radio value="1" name="messageType" <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                          <input type=radio value="2" name="messageType" <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                          <%}else{%>
                          <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
                          <%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
                          <%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
                          <input type=hidden name=messageType value="<%=rqMessageType%>">
                          <%}%>
                        </td>
                  </TR>
                  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
      <%}%>
<%}else{%>
  <tr>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <TD class=fieldvalueClass>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <input type=hidden name=requestlevel value="<%=requestlevel%>">
       <input type=hidden name=messageType value="<%=rqMessageType%>">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      &nbsp;&nbsp;&nbsp;&nbsp;
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      </td>
  </tr>  	   	<tr  style="height:1px;">
    <td class="Line1" colSpan=2></td>
  </tr>
  <!--第一行结束 -->
<%}
WFNodeFieldMainManager.closeStatement();
%>
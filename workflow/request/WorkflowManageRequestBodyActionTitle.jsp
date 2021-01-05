
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.workflow.request.WFFreeFlowManager"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	boolean editflag = Util.null2String(request.getParameter("editflag")).equals("true");
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String isaffirmancebody = Util.null2String(request.getParameter("isaffirmancebody"));
	String reEditbody = Util.null2String(request.getParameter("reEditbody"));
	String requestlevel_disabled = Util.null2String(request.getParameter("requestlevel_disabled"));
	String RequestName_Size = Util.null2String(request.getParameter("RequestName_Size"));
	String RequestName_MaxLength = Util.null2String(request.getParameter("RequestName_MaxLength"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
	int wfMessageType = Util.getIntValue(request.getParameter("wfMessageType"),-1);
	String messageType_disabled = Util.null2String(request.getParameter("messageType_disabled"));
	int rqMessageType = Util.getIntValue(request.getParameter("rqMessageType"),-1);
	//微信提醒(QC:98106)
	String chatsType_disabled = Util.null2String(request.getParameter("chatsType_disabled"));
	int rqchatsType = Util.getIntValue(request.getParameter("rqchatsType"),-1);
	int wfChatsType = Util.getIntValue(request.getParameter("wfChatsType"),-1);
	//微信提醒(QC:98106)
	String isEdit_ = Util.null2String(request.getParameter("isEdit_"));
	String requestid = Util.null2String(request.getParameter("requestid"));
  String nodeid = Util.null2String(request.getParameter("nodeid"));
	int userid=user.getUID();
	String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));

  //当自由流程设置当前节点的表单不可以编辑时，则全部表单字段都禁止编辑
if( !WFFreeFlowManager.allowFormEdit(requestid, nodeid) ){
    isEdit_ = "0";
}
%>

  <%if(editflag&&"0".equals(nodetype)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <td class=fieldvalueClass>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestName_Size%> maxlength=<%=RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
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
      <TD class="Line2" colSpan=2></TD>
    </TR>

  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD  class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=fieldvalueClass>
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
        <!-- 微信提醒(QC:98106 -->
         <%
        if (wfChatsType==1) {
  %>
                    <TR>
                      <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></TD>
                      <td class=fieldvalueClass>
                            <span id=chatsTypeSpan></span>
                            <%if(chatsType_disabled.equals("")){%>
                            <input type=radio value="0" name="chatsType" <%if(rqchatsType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
                            <input type=radio value="1" name="chatsType" <%if(rqchatsType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
                             <%}else{%>
                            <%if(rqchatsType==0){%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%><%}%>
                            <%if(rqchatsType==1){%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%><%}%>
                             <input type=hidden name=chatsType value="<%=rqchatsType%>">
                            <%}%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>  
        <!-- 微信提醒(QC:98106 -->
  <%}else if(editflag&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <TD class=fieldvalueClass>
          <%if("1".equals(isEdit_)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestName_Size%> maxlength=<%=RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
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
                      <td class=fieldvalueClass>
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
        <!-- 微信提醒(QC:98106) -->
        <%
        if (wfChatsType==1) {
  %>
                    <TR>
                      <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></TD>
                      <td class="fieldvalueClass">
                            <span id=chatsTypeSpan></span>
                            <%if(chatsType_disabled.equals("")){%>
                            <input type=radio value="0" name="chatsType" <%if(rqchatsType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
                            <input type=radio value="1" name="chatsType" <%if(rqchatsType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
                             <%}else{%>
                            <%if(rqchatsType==0){%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%><%}%>
                            <%if(rqchatsType==1){%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%><%}%>
                             <input type=hidden name=chatsType value="<%=rqchatsType%>">
                            <%}%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>
        <!-- 微信提醒(QC:98106) -->
  <%}else{%>
    <tr>
      <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=fieldvalueClass>
         <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
         <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
         <input type=hidden name=requestlevel value="<%=requestlevel%>">
       <input type=hidden name=messageType value="<%=rqMessageType%>"> 
       <input type=hidden name=chatsType value="<%=rqchatsType%>"><!-- 微信提醒(QC:98106) -->
        &nbsp;&nbsp;&nbsp;&nbsp;
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <!-- 微信提醒(QC:98106) -->
        <%if (wfMessageType==1) {
          if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
          <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
          <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}}%>
       &nbsp;&nbsp;&nbsp;&nbsp;
        <%if (wfChatsType==1){
          if(rqchatsType==0){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
          <%} else if(rqchatsType==1){%><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
          <%}  }%>
          <!-- 微信提醒(QC:98106) -->
        </td>
    </tr>  	   	<tr style="height:1px;">
      <td class="Line1" colSpan=2></td>
    </tr>
    <!--第一行结束 -->
  <%}%>
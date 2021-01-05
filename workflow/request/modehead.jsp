
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%
int userid = user.getUID();
String logintype = user.getLogintype();
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String topage = Util.null2String(request.getParameter("topage"));
String needcheck = Util.null2String(request.getParameter("needcheck"));
int messageType = Util.getIntValue(request.getParameter("messageType"));
int chatsType = Util.getIntValue(request.getParameter("chatsType")); //微信提醒QC:(98106)
int defaultName = Util.getIntValue(request.getParameter("defaultName"));
String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType"));
String chatsAlertType = Util.null2String(request.getParameter("chatsAlertType")); //微信提醒QC:(98106)
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
String currentdate = Util.null2String(request.getParameter("currentdate"));
String workflowname = Util.null2String((String)session.getAttribute(userid+"_"+workflowid+"workflowname"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
int formid = Util.getIntValue(request.getParameter("formid"));
//tagtag资产借用,送修,归还
if(formid==220||formid==222||formid==224){
	session.setAttribute("cpt_sysformid", ""+formid);
}else{
	session.removeAttribute("cpt_sysformid");
}
String beagenter=""+user.getUID();
//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+userid),0);
if(body_isagent==1){
    beagenter=""+Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+userid),0);
}
if(body_isagent==1) {
		username=ResourceComInfo.getLastname(beagenter);
  }

   weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
   String txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+beagenter,""+username,logintype);
  
  
String operationpage = "" ;
if(isbill==1) {
	RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
	if(RecordSet.next()){
		operationpage = Util.null2String(RecordSet.getString("operationpage"));
	}
}
if( operationpage.equals("") ){
	operationpage = "RequestOperation.jsp" ;
}
boolean hasRequestname = false;
boolean hasRequestlevel = false;
boolean hasMessage = false;
boolean hasChats = false;//微信提醒QC(98106);
//boolean hasSign = false;
RecordSet.executeSql("select fieldid from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid in(-1,-2,-3,-5)");//微信提醒QC(98106) 增加fieldid in (-5);
while(RecordSet.next()){
    int tmpfieldid = RecordSet.getInt("fieldid");
    if (tmpfieldid == -1) {
        hasRequestname = true;
    } else if (tmpfieldid == -2) {
        hasRequestlevel = true;
    } else if (tmpfieldid == -3) {
        hasMessage = true;
    //微信提醒START:QC(98106);
    } else if (tmpfieldid == -5) {
        hasChats = true;
    }
  	//微信提醒END:QC(98106);
}
%>
<form name="frmmain" method="post" action="<%=operationpage%>" enctype="multipart/form-data">
                <TABLE class="ViewForm" id="t_header">
                  <COLGROUP>
                  <COL width="20%">
                  <COL width="80%">
                  <%if(!hasRequestname||!hasRequestlevel){%>
                  
                  <TR>
                  	<%if(!hasRequestname){%>
                    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,Languageid)%></TD>
                    <td class=fieldvalueClass>
                      <%if(defaultName==1){%>
                       <%--xwj for td1806 on 2005-05-09--%>
                        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( txtuseruse,Languageid )%>" >
                        <span id=requestnamespan></span>
                      <%}else{%>
                        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
                        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
                      <%}
                      }
                      if(!hasRequestlevel){%>
                      <%if(hasRequestname){%>
                    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(15534,Languageid)%></TD>
                    <td class=fieldvalueClass>
                    <%}%>
                      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,Languageid)%>
                      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,Languageid)%>
                      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,Languageid)%>
                      <%}%>
                    </TD>
                  </TR>
                  <%}%>
                <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <%
                    if(messageType == 1&&!hasMessage){
                  %>
                  <TR>
                    <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,Languageid)%></TD>
                    <td class=fieldvalueClass>
                          <span id=messageTypeSpan></span>
                          <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,Languageid)%>
                          <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,Languageid)%>
                          <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,Languageid)%>
                        </td>
                  </TR>  	   	
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <%}%>
                  <!-- 微信提醒START(QC:98106)  -->
                  <%
                    if(chatsType == 1&&!hasChats){
                  %>
                  <TR>
                    <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,Languageid)%></TD>
                    <td class="fieldvalueClass">
                          <span id=chatsTypeSpan></span>
                          <input type=radio value="0" name="chatsType" <% if(chatsAlertType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,Languageid)%>
                          <input type=radio value="1" name="chatsType" <% if(chatsAlertType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,Languageid)%>
                          </td>
                  </TR>  	   	
                  <TR><TD class=Line colSpan=2></TD></TR>
                  <%}%>
                  <!-- 微信提醒END(QC:98106)  -->
                </table>
                <input type=hidden name="workflowid" value="<%=workflowid%>">
                <input type=hidden name="workflowtype" value="<%=workflowtype%>">
                <input type=hidden name="nodeid" value="<%=nodeid%>">
                <input type=hidden name="nodetype" value="0">
                <input type=hidden name="src">
                <input type=hidden name="iscreate" value="1"> 
                <input type=hidden name ="topage" value="<%=topage%>">
                <input type=hidden name ="method">
                <input type=hidden name ="needcheck" value="<%=needcheck%>">
                <input type=hidden name ="inputcheck" value="">

				<input type=hidden name ="requestid" value="-1">
				<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
				<input type=hidden name="needoutprint" value="">
				<iframe name="delzw" width=0 height=0 style="border:none;"></iframe>

    <%if(isbill==1 && formid==7){%>
    <div id="t_headother">
			    <table class="ListStyle" cellspacing='1' border='0'>
			      <tbody>
			      <TR class="header">
			          <TH><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
			      </TR>
			      <%
			      RecordSet.executeSql("select sum(amount) as sumamount from fnaloaninfo where organizationtype=3 and organizationid="+userid);
			      RecordSet.next();
			      double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
			      %>
			      <tr class="datalight">
			        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%><%=loanamount%></td>
			      </tr>
			      </tbody>
			    </table>
    </div>
    <%}%>
    <%if(isbill==1 && formid==158){%>
    <div id="t_headother">

    <table class="ListStyle" cellspacing='1' border='0'>
      <TR class="header">
          <TH><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
      </TR>
      <%
        RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+userid);
        RecordSet.next();
        double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
        //获取明细表设置
                WFNodeDtlFieldManager.resetParameter();
                WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
                WFNodeDtlFieldManager.setGroupid(0);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtledit = WFNodeDtlFieldManager.getIsedit();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
      %>
      <tr class="datalight">
        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%><%=loanamount%></td>
      </tr>
    </table>
    </div>
    <%}%>
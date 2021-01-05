
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"/>
<% 
boolean canedit = HrmUserVarify.checkUserRight("CRM_ContractTypeAdd:Add",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int msgid = Util.getIntValue(request.getParameter("msgid"), -1);
	String id = Util.null2String(request.getParameter("id"));
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	String name="";
	String contractdesc="";
	String workflowid="";
	if(!isclose.equals("1"))
	{
		RecordSet.executeProc("CRM_ContractType_SelectById",id);
		if(RecordSet.next()){
 			name=Util.null2String(RecordSet.getString("name"));
 			contractdesc=Util.null2String(RecordSet.getString("contractdesc"));
 			workflowid = Util.null2String(RecordSet.getString("workflowid"));
		}
		if(RecordSet.getFlag()!=1)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		if(RecordSet.getCounts()<=0)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "CRMContractTypeListInner.jsp";
	parentWin.closeDialog();
}

jQuery(function(){
	checkinput("name","nameimage");
});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit) 
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())
				+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())
				+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (canedit){  
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(6083,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if (canedit){  %>
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<wea:layout>
	<wea:group context="" attributes="{groupDisplay:none,itemAreaDisplay:none}">
		<%if (msgid != -1) {%>
		<wea:item><FONT color="red" size="2"><%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%></FONT></wea:item>
		<%}%>
	</wea:group>
</wea:layout>

<FORM id=weaver action="/CRM/Maint/CRMContractTypeOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">

<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true" value="">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")' >
				<%}else {%><%=name%><%}%>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=45 name="contractdesc" value="<%=contractdesc%>"><%}else {%><%=contractdesc%><%}%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></wea:item>
		<wea:item>
			<%if (canedit) {
				String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid=49");
				%>
   				<span>
    				<brow:browser viewType="0" name="workflowid" 
            			browserOnClick="" browserUrl="<%=browserUrl%>"
            			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            			completeUrl="" width="267px"
            			browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid),user.getLanguage()) %>' browserValue='<%=Util.null2String(workflowid) %>' >
    				</brow:browser>
   				</span>
       		<%}else{ %>
       			<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid),user.getLanguage()) %>
       		<%} %>
		</wea:item>
	</wea:group>
</wea:layout>


</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>

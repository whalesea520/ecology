
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkflowBillComInfo" class="weaver.workflow.workflow.WorkflowBillComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<% 
String isclosed = Util.null2String(request.getParameter("isclosed"),"0");
String isclosedToDetails = Util.null2String(request.getParameter("isclosedToDetails"),"0");
String id = Util.null2String(request.getParameter("id"),"0");
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script>
	<%if ("1".equals(isclosed)){%>
		window.parent.closeWinAFrsh();
	<%}%>
	<%if ("1".equals(isclosedToDetails)){%>
		window.parent.location = "/cpt/car/UseCarWorkflowSetAddTab.jsp?id=<%=id%>";
	<%}%>
</script>
</head>

<%
String dialog=Util.null2String(request.getParameter("dialog"),"0");
String isclose = Util.null2String(request.getParameter("isclose"));
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String workflowid = "";
String formid = "";
String typeid = "";
String isuse = "1";
RecordSet.executeSql("select workflowid,formid,typeid,isuse from carbasic where id="+id);
if (RecordSet.next()) {
	workflowid = RecordSet.getString("workflowid");
	formid = RecordSet.getString("formid");
	typeid = RecordSet.getString("typeid");
	isuse = RecordSet.getString("isuse");
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:onSubmit(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<%
				if ("".equals(id.trim())) { //保存并进入详细设置
			%>
			<span title="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:onSubmitToDetails(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>"/> <!-- 保存并进入详细设置 -->
			</span>
			<%  } %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<form name=frmmain action="UseCarWorkflowSetOperation.jsp">
<input type="hidden" name=operation value=add>
<input type="hidden" name=id value=<%=id %>>
<input type="hidden" name=dialog value=<%=dialog%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%><!-- 流程名称 -->
		</wea:item>
		<wea:item>
			<%
				if (!"".equals(id.trim())) {
			%>
					<input type="hidden" name="workflowid" id="workflowid" value="<%=workflowid%>"/>
					<span name="workflowname" id="workflowname"><%=WorkflowComInfo.getWorkflowname(workflowid)%></span>
			<%
				} else {
			%>
					<brow:browser viewType="0" name="workflowid" browserValue='<%=String.valueOf(workflowid)%>' 
					 	browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid<0") %>'
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px" onPropertyChange="updateBrowserSpan()"
						browserDialogWidth="510px"
						_callback="changeFormId" 
						browserSpanValue='<%=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid))%>'>
		</brow:browser>
			<%  } %>
			
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%><!-- 表单 -->
		</wea:item>
		<wea:item>
			<div id="formiddiv">
				<input type="hidden" name="formid" id="formid" value="<%=formid%>"/>
				<input type="hidden" name="typeid" id="typeid" value="<%=typeid%>"/>
				<span name="formname" id="formname"><%=Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(WorkflowBillComInfo.getNamelabel(formid)),user.getLanguage())) %></span>
			</div>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 -->
		</wea:item>
		<wea:item>
			<input class="inputStyle" type="checkbox" name="isuse" tzCheckbox="true" value="1" <%if ("1".equals(isuse)) out.println("checked");%>>
		</wea:item>
	</wea:group>
</wea:layout>
<%if ("1".equals(dialog)) {%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
<%}%>
</form>
<script language="javascript">
function onSubmit()
{
    if(check_form($GetEle("frmmain"),'workflowid,formid')){
	    $GetEle("frmmain").submit();
    }
}
function onSubmitToDetails()
{
    if(check_form($GetEle("frmmain"),'workflowid,formid')){
    	$GetEle("frmmain").operation.value="createToDetails2";
	    $GetEle("frmmain").submit();
    }
}
function changeFormId(e,json) {
	if(json){
		var id = json.id;
		$.ajax({
		   type: "POST",
		   url: "/cpt/car/UseCarWorkflowSetOperation.jsp",
		   data: "operation=getForminfo&workflowid="+id,
		   success: function(data){
			   if (data&&data.trim()!="") {
				   var dataJson = JSON.parse(data);
			       document.getElementById("formid").value=dataJson.formid;
			       document.getElementById("formname").innerText=dataJson.formname;
			       
			       document.getElementById("typeid").value=dataJson.workflowtype;
			   } else if (data&&data.trim()!="1") {
				   alert("<%=SystemEnv.getHtmlLabelName(128243, user.getLanguage())%>");
				   
				   document.getElementById("workflowid").value="";
			       document.getElementById("workflowidspan").innerText="";
			       
			       document.getElementById("formid").value="";
			       document.getElementById("formname").innerText="";
			       
			       document.getElementById("typeid").value="";
			   } else {
				   document.getElementById("formid").value="";
			       document.getElementById("formname").innerText="";
			       
			       document.getElementById("typeid").value="";
			   }
		   },
		   error:function(error){ 
		   }
		});
	}
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
function updateBrowserSpan(){
	if(event.propertyName=='value'){
		var title = $("#workflowidspan").find("a").text();
		$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
	}
}
</script>
</BODY></HTML>

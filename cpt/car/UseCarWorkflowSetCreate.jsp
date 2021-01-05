
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
String isclosed = Util.null2String(request.getParameter("isclosed"),"0");
String isclosedToDetails = Util.null2String(request.getParameter("isclosedToDetails"),"0");
String workflowid = Util.null2String(request.getParameter("workflowid"));
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
		window.parent.location = "/workflow/workflow/addwf.jsp?ajax=1&src=editwf&wfid=<%=workflowid%>&isTemplate=0";
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
			<span title="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存并进入详细设置 -->
				<input class="e8_btn_top middle" onclick="javascript:onSubmitToDetails(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<form name=frmmain action="UseCarWorkflowSetOperation.jsp">
<input type="hidden" name=operation value=create>
<input type="hidden" name=dialog value=<%=dialog%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%><!-- 流程名称 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=30 name="workflowname" onchange='checkinput("workflowname","workflownameimage")'>
    		<SPAN id=workflownameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%><!-- 流程类型 -->
		</wea:item>
		<wea:item>
			<select class=inputstyle style="width:228px;" name=typeid>
		    <%
		    RecordSet.executeSql("select id,typename from workflow_type order by dsporder asc,id asc");
		    while(RecordSet.next()){
			%>
				<option value="<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%></option>
			<%}%>
		    </select>  		
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%><!-- 表单 -->
		</wea:item>
		<wea:item>
			<div>
				<select name="wftype" onchange="changeformspan(this.value);">
					<option value="0"><%=SystemEnv.getHtmlLabelName(82450,user.getLanguage())%><!-- 卡片生成表单 --></option>
					<option value="1"><%=SystemEnv.getHtmlLabelName(125026,user.getLanguage())%><!-- 自定义表单 --></option>
				</select>
			</div>
			<div id="formspan" style="margin-top:5px;display:none;">
				<%   String bname = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
					String formidTempTitle = SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage());
				%>
					 <brow:browser viewType="0" name="formid" browserValue='' 
		  		 		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp?isReport=1"
								hasInput='true' isSingle="true" hasBrowser = "true" isMustInput="2"  tempTitle='<%=formidTempTitle%>'
								completeUrl="/data.jsp?isvirtualform=1&type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="228px"
								browserDialogWidth="510px"
								browserSpanValue='<%=bname %>'
								></brow:browser>
							<!-- 如果没有表单请点击表单字段新建 -->
				&nbsp;<div style="width:156px;position:relative;float:left;margin-top:4px;margin-left:2px;"><font color="red"><%=SystemEnv.getHtmlLabelName(18720,user.getLanguage())%><a id="toNewForm" href="#" onclick="toformtab('')"><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></a><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></font></div>
			</div>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 -->
		</wea:item>
		<wea:item>
			<input class="inputStyle" type="checkbox" name="isuse" tzCheckbox="true" value="1" <%if (1==1) out.println("checked");%>>
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
	var wftype = $GetEle("frmmain").wftype.value;
	if (wftype=="1") {
		if(check_form($GetEle("frmmain"),'workflowname,formId')){
		    $GetEle("frmmain").submit();
	    }
	} else {
		if(check_form($GetEle("frmmain"),'workflowname')){
		    $GetEle("frmmain").submit();
	    }
	}
    
}
function onSubmitToDetails()
{
	var wftype = $GetEle("frmmain").wftype.value;
	if (wftype=="1") {
		if(check_form($GetEle("frmmain"),'workflowname,formId')){
			$GetEle("frmmain").operation.value="createToDetails";
		    $GetEle("frmmain").submit();
	    }
	} else {
		if(check_form($GetEle("frmmain"),'workflowname')){
			$GetEle("frmmain").operation.value="createToDetails";
		    $GetEle("frmmain").submit();
	    }
	}
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
function toformtab(formid,isvirtualform){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
	diag_vote.Width = 1000;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	
	diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1";
	diag_vote.isIframe=false;
	diag_vote.show();
}
function changeformspan(value) {
	if (value=="0") {
		document.getElementById("formspan").style.display="none";
	} else if (value=="1") {
		document.getElementById("formspan").style.display="";
	}
}
</script>
</BODY></HTML>

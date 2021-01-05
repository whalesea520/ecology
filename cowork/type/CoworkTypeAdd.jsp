
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%

if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=user.getUID();
String logintype = user.getLogintype();
String hrmid = Util.null2String(request.getParameter("hrmid"));
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(83209,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="TypeOperation.jsp" method=post>
<input type=hidden name=operation value="add">
<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname onchange='checkinput("name","nameimage")' style="width: 150px;">
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
		<wea:item>
		<select name=departmentid id=dpid>
			<%while(CoMainTypeComInfo.next()){%>
				<option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>"><%=CoMainTypeComInfo.getCoMainTypename()%></option>
			<%}%>
		</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31449,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isApproval" id="isApproval"  value="1">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isAnonymous" id="isAnonymous" value="1">
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	
function doSubmit() {
		var coworkname = $("#coworkname").val();		
		var isAnonymous=$("#isAnonymous").attr("checked")?"1":"0";
		var isApproval=$("#isApproval").attr("checked")?"1":"0";
		$.post("/cowork/type/CoworkTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val()),departmentid:$("#dpid").val()},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,'name,departmentid')){
					 $.post("TypeOperation.jsp",
					 	{"operation":"add","name":$("#coworkname").val(),departmentid:$("#dpid").val(),isAnonymous:isAnonymous,isApproval:isApproval},function(){
						 parent.getParentWindow(window).callback();	
					 })
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}
function back()
{
	window.history.back(-1);
}

jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
});
</script>
</BODY></HTML>


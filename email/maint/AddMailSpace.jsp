
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String showTop = Util.null2String(request.getParameter("showTop"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<script language="javascript">
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

function saveInfo(){
	
	var type = jQuery("#type").val();
	var fields="beginLevel,endLevel,totalspace";
	if(1 == type){
		fields='resource,totalspace';
	}else if(2 == type){
		fields+="subcompany,"+fields;
	}else if(3 == type){
		fields+="department,"+fields;
	}
	
	if(check_form(weaver,fields)){
			jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
			 	parentWin.closeDialog();
			});
	}
}

 
function onChangeSharetype(obj){

 	var objval=obj.value;
 	$(".contentSpan").hide();
 	$("#contentSpan_"+objval).show();
 	if(parseInt(objval)>1)
	  	showEle("showlevel","true");
	else
		hideEle("showlevel","true");  
}

function init(){
	hideEle("showlevel","true");
}

jQuery(function(){
	init();
	checkinput("beginLevel","beginLevelimage");
	checkinput("endLevel","endLevelimage");
	checkinput("totalspace","totalspaceimage");
});
</script>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(34246,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="saveInfo()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="method" value = "addMailSpace">

<div class="zDialog_div_content" style="height:200px;">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="type" id="type"  style="width: 100px;" onchange="onChangeSharetype(this)">
					  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></option>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %></option>
					  <option value="3"><%=SystemEnv.getHtmlLabelName(27511,user.getLanguage()) %></option>
					  <option value="4"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage()) %></option>
				</SELECT>
			</span>
			
		</wea:item>
		
		
		<wea:item>内容</wea:item>
		<wea:item>
		
			<span id="contentSpan_1" class="contentSpan">
				<brow:browser viewType="0" name="resource" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="80%" ></brow:browser> 
			</span>
			
			<span id="contentSpan_2" class="contentSpan" style="display: none;">
				<brow:browser viewType="0" name="subcompany" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" width="80%" ></brow:browser> 
			</span>
			
			<span id="contentSpan_3" class="contentSpan" style="display: none;">
				<brow:browser viewType="0" name="department" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=57" width="80%" ></brow:browser> 
			</span>
			
			<span id="contentSpan_4" class="contentSpan" style="display: none;">
				<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage()) %>
			</span>
			
		 </wea:item>
		
		<wea:item attributes="{'samePair':'showlevel'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showlevel'}">
			<wea:required id="beginLevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name="beginLevel" onKeyPress="ItemCount_KeyPress()"  
					onchange='checknumber("beginLevel");checkinput("beginLevel","beginLevelimage")'style="width: 50px;" value="0">
			</wea:required>
			 -- <wea:required id="endLevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name="endLevel" onKeyPress="ItemCount_KeyPress()" 
					onchange='checknumber("endLevel");checkinput("endLevel","endLevelimage")' style="width: 50px;" value="100">
			</wea:required>
		 </wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(34163,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="totalspaceimage" required="true">
				<INPUT class="InputStyle" maxLength=10 size=5 name="totalspace" onKeyPress="ItemCount_KeyPress()" 
					onchange='checknumber("totalspace");checkinput("totalspace","totalspaceimage")' value="100" style="width: 150px;">
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>

</div>

</form>

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
</body>

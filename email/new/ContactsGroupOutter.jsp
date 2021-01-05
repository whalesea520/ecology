
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(433,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<html>
<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="background-color: #F8F8F8;">
		
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(81313,user.getLanguage())+SystemEnv.getHtmlLabelName(633,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" type="button"  onclick="doSubmit()" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:195px;">
<form method="post" id="weaver" name="weaver"  action="/email/new/MailAddAjax.jsp">
	
	<wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(81303,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
				<wea:required id="srznameimage" required="true">
					<input style="width:90%"  type="text" name="srzname" id="srzname"
						 onchange='checkinput("srzname","srznameimage")'>
				</wea:required>
			</wea:item>
			
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(81313,user.getLanguage())+SystemEnv.getHtmlLabelName(431,user.getLanguage()) %>
			</wea:item>
			<wea:item attributes="{'id':'srzulid'}">
				
			</wea:item>
		</wea:group>
		
	</wea:layout>		
</form>
</div>
			
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
</body>
</html>

<script type="text/javascript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

jQuery(document).ready(function(){
	 $("#srzulid").html("");
	 $(parentWin.document.getElementById("toDiv")).find(".mailAdItem").each(function(){
		var temp_title=$(this).attr("title");
		$(this).find("span").each(function(){
			var li = $("<li class='m-2  li_decimal w-240' _value='"+temp_title+"' title='"+$(this).text()+"'></li>")
			li.append( "<input type='checkbox' checked='true' />&nbsp;&nbsp;");
			li.append($("<span class='overText w-200'></span>").text($(this).text()));
			$("#srzulid").append(li);
		});
	});
	 
});

function doSubmit() {
	if(check_form(weaver,"srzname")){
		var srzname=$("#srzname").val();
		var srzids="";
		
		$("#srzulid>li").each(function(){
			var _checked_ = $(this).find("[type=checkbox]").attr("checked");
			if(_checked_) {
				srzids+=$(this).attr("_value")+"@;";
			}
		});
		
		var o4params = {
			method:"haved",
			srzname:encodeURI(srzname),
			srzids:srzids
		}
		$.post("/email/new/EmailcontactAjax.jsp",o4params,function(data){
			if(data==0){//组名重复
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>!");
			}else if(data==1){//操作成功
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage()) %>!");
					parentWin.refreshTree("outter");
			}else{//操作失败
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
			}
		});
	}
}
</script>
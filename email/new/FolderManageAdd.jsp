
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	String id = Util.null2String(request.getParameter("id"));
	String foldername = Util.null2String(request.getParameter("foldername"));
	String mailsId = Util.null2String(request.getParameter("mailsId"));
	if(!"".equals(foldername)){
		foldername = URLDecoder.decode(foldername,"UTF-8");
	}
	
%>
<script type="text/javascript">
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	jQuery(function(){
		checkinput("foldername","foldernameSpan");
		if("<%=id%>"==""){
			jQuery("#method").val("add");
		}else{
			jQuery("#method").val("edit");
		}
		
		if("<%=mailsId%>"!=""){
			jQuery("#method").val("addandmt");
		}
	});
	
function doSubmit(){
	if(check_form(weaver,"foldername")){
		$.post("/email/new/FolderManageOperation.jsp",jQuery("form").serialize(),function(data){
			if(data!='repeat'){
				parentWin.closeDialogcreateLabel();
			}else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26603,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			}
		});
	}
}

</script>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18473,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="weaver" action="/email/new/FolderManageOperation.jsp" method="post">
<input type="hidden" id="method" name="method">
<input type="hidden" id="editfolderid" name="editfolderid" value="<%=id %>">
<input type="hidden" id="mailsId" name="mailsId" value="<%=mailsId %>">
<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(81318,user.getLanguage()) %> </wea:item>
		<wea:item>
			<wea:required id="foldernameSpan" required="true">
				<input type="text" style="width: 70%" name="foldername" id="foldername" value="<%=foldername %>"
					 onchange='checkinput("foldername","foldernameSpan")'>
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
</html>





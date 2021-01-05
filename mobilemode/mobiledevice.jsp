
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobiledeviceManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.Mobiledevice"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
MobiledeviceManager mobiledeviceManager=MobiledeviceManager.getInstance();
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
int refresh=Util.getIntValue(Util.null2String(request.getParameter("refresh")));
Mobiledevice mobiledevice=mobiledeviceManager.getMobiledevice(id);

%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>
	*{
		font: 12px Microsoft YaHei;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: hidden;
	}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: middle;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 5px 5px 10px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #aaa;
	}
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	top.closeTopDialog();
}
</script>
<script>
function onSave(){
	enableAllmenu();
	$(".loading").show(); 
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobiledeviceAction", "action=save");
	document.frmMain.submit();
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobiledeviceAction", "action=delete"); 
		document.frmMain.submit();
	}
}
</script>
</HEAD>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(id > 0) {
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} ";
    	RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="frmMain" name="frmMain" method="post" target="_self"  enctype="multipart/form-data">
<input type="hidden" id="id" name="id" value="<%=id%>"/>
<table class="e8_tblForm">
	<tr>
		<td class="e8_tblForm_label" width="20%">设备名称</td>
		<td class="e8_tblForm_field"><input type="text" style="width:83%;" id="devicename" name="devicename" value="<%=Util.null2String(mobiledevice.getDevicename())%>"/></td>
	</tr>
	<tr>
		<td class="e8_tblForm_label">图标</td>
		<td class="e8_tblForm_field">
			<INPUT type="file" name="picpath" id="picpath" value="<%=Util.null2String(mobiledevice.getPicpath())%>" maxlength="40" >
            <SPAN>
             <%
             if(mobiledevice.getPicpath() != null){
            	 %>
            	 <img alt="" src="<%=mobiledevice.getPicpath() %>" height="30" width="30">
            	 <%
             }
             %>
           </SPAN>
        </td>
	</tr>
	<tr>
		<td class="e8_tblForm_label">宽度</td>
		<td class="e8_tblForm_field"><input type="text" style="width:83%;" id="width" name="width" value="<%=Util.null2String(mobiledevice.getWidth())%>"/></td>
	</tr>
	<tr>
		<td class="e8_tblForm_label">高度</td>
		<td class="e8_tblForm_field"><input type="text" style="width:83%;" id="height" name="height" value="<%=Util.null2String(mobiledevice.getHeight())%>"/></td>
	</tr>
</table>
</form>
 </body>
</html>
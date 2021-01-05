
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">

</head>

<%
String supName =  Util.null2String(request.getParameter("supName"));
String departmentname = Util.null2String(request.getParameter("departmentname"));
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
String id = Util.null2String(request.getParameter("id"));
String supdepid = Util.null2String(request.getParameter("supdepid"));
String type = Util.null2String(request.getParameter("type"));
String method = Util.null2String(request.getParameter("method"));
String msg = Util.null2String(request.getParameter("msg"));

String from = Util.null2String(request.getParameter("from"));


%>

<BODY>
 <%
if(!msg.equals("")){
    if(msg.equals("1")){
        msg= SystemEnv.getHtmlLabelName(125233 ,user.getLanguage());
    }else if(msg.equals("2")){
        msg= SystemEnv.getHtmlLabelName(125234 ,user.getLanguage());
    }else if(msg.equals("3")){
        msg= SystemEnv.getHtmlLabelName(125235 ,user.getLanguage());
    }
     if("1".equals(from))   {
         %>
         <script type="text/javascript">
         jQuery(document).ready(function(){
         	window.parent.Dialog.alert('<%=msg%>');
         	jQuery("#departmentname").val(window.parent.getdepName());
         	jQuery("#displaysupName").html(window.parent.getSupdepName());
         });
         </script>      
         
<%}else{%>
<script type="text/javascript">
jQuery(document).ready(function(){
	window.parent.Dialog.alert('<%=msg%>');
	jQuery("#departmentname").val(window.parent.leftmenuframe.getdepName());
	jQuery("#displaysupName").html(window.parent.leftmenuframe.getSupdepName());
});
</script>
<%}}%>
<FORM id=weaver name=frmMain action="RdDeptOperation.jsp" method=post>
<input type=hidden id="operation" name=operation value="<%=method %>">
<input type=hidden id="subcompanyid1" name=subcompanyid1 value="<%=subcompanyid1 %>">
<input type=hidden id="supdepid" name=supdepid value="<%=supdepid %>">
<input type=hidden id="from" name=from value="<%=from %>">
<input type=hidden id="id" name=id value="<%=id %>">
<div style="padding-top: 20px;">
<table width="100%" height="100%">
 <tr>
   <td style="padding: 22px 0px 5px 35px;font-size: 13px; "  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
   <td style="padding-top: 20px;">
	<INPUT class=rdeploycommoninputclass type=text maxLength=20 size=30 name=departmentname id="departmentname" style="width: 222px;height: 30px;" value="<%=departmentname %>" onchange=''>
   </td>
 </tr>
 <tr>
   <td style="padding: 22px 0px 5px 60px;font-size: 13px; "  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125236,user.getLanguage())%></td>
   <td style="padding: 18px 0 0 3px;">
	<span id="displaysupName" style="color: #546168;"><%=supName %></span>
   </td>
 </tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
 
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	


jQuery(document).ready(function(){
   var depName = jQuery("#departmentname").val().trim();
	if(depName != ""){
		jQuery("#nameimage").html("");
	}
});

function doSubmit() {
   var depName = jQuery("#departmentname").val().trim();
   if(depName==""){
   		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125237,user.getLanguage())%>");
   		return;
   }
    parentWin.setdepName(depName);
	frmMain.submit();
}

function back()
{
	window.history.back(-1);
}

</script>




</BODY></HTML>


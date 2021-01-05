<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
</head>

<%

String success = Util.null2String(request.getParameter("success"));
String managerName = user.getUsername();
%>
 <%
if(!success.equals("")){
        
%>
<script type="text/javascript">
jQuery(document).ready(function(){
	window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125221,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
	jQuery("#departmentname").val(parent.getParentWindow(window).leftmenuframe.getdepName());
	jQuery("#displaysupName").html(parent.getParentWindow(window).leftmenuframe.getSupdepName());
});
</script>
<%}%>
<BODY>

<FORM id=weaver name=frmMain action="RdResourceOperation.jsp" method=post>
<input type=hidden id="method" name=method value="add">
<input type=hidden id="operate" name=operate value="1">
<input type=hidden id="managerName" name=managerName value="<%=managerName %>">
<div style="padding-top: 45px;">
<table width="100%" height="100%">
 <tr>
   <td style="padding: 22px 0px 5px 60px;font-size: 13px;width:25% "  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
   <td style="padding-top: 18px;">
	<INPUT class=rdeploycommoninputclass   type=text maxLength=20 size=30 name=name id="name" style="width: 222px;height: 30px;" onchange=''>
   </td>
 </tr>
 <tr>
   <td style="padding: 22px 0px 5px 60px;font-size: 13px;width:25% "  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125213,user.getLanguage())%></td>
   <td style="padding-top: 18px;">
	<INPUT class=rdeploycommoninputclass   type=text maxLength=20 size=30 style="width: 222px;height: 30px;"  name=mobilephone id="mobilephone" onchange=''>
   </td>
 </tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit(1)">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit(2)">
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
});

function doSubmit(operate) {
	
	var name = $("#name").val().trim();
	var mobilephone = $("#mobilephone").val().trim();
	
	if(name == ""){
		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125311,user.getLanguage())%>");
		return;
	}
	if(mobilephone == ""){
		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125312,user.getLanguage())%>");
		return;
	}
    var myreg = /^1\d{10}$/g; 
    if(!myreg.test(mobilephone)) 
     { 
       window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125253,user.getLanguage())%>'); 
       return; 
     } 
     $("#operate").val(operate);
	$.ajax({
		 data:{"nameStr":name,"mobile":mobilephone},
		 type: "post",
		 cache:false,
		 url:"checkdatas.jsp",
		 dataType: 'json',
		 success:function(data){
		 	 if(data.mobileExist == "1"){
		 	 	 window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125267,user.getLanguage())%>');
		 	 	 return;
		 	 }
			 if(data.success == "0"){
				   $("#dosubmit").attr('disabled',"true");
				   frmMain.submit();
			 }else{
			 	 window.parent.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21445,user.getLanguage())%>!",function(){
			 	 	 frmMain.submit();
			 	 });
			 }
		}	
   });
}


function back()
{
	window.history.back(-1);
}

</script>




</BODY></HTML>


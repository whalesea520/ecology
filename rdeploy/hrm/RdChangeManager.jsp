
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
</style>
</head>

<%
String ids= Util.null2String(request.getParameter("ids"));


%>

<BODY>
<FORM id=weaver name=frmMain action="RdResourceOperation.jsp" method=post>
<input type=hidden id="method" name=method value="editManager">
<input type=hidden id="ids" name=ids value="<%=ids %>">
<div style="padding-top: 65px;height: 100px;">
<table>
  <tr>
   <td style="padding: 0 10px 0 30px;font-size: 13px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></td>
   <td>
   <div style="width: 280px;height:39px;position: absolute;margin-left: 2px;"></div>
	<brow:browser viewType="0" name="managerid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="javascript:" width="270px"></brow:browser>
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
   var managerid = jQuery("#managerid").val();
   if(managerid==""){
   		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125232,user.getLanguage())%>");
   		return;
   }
	frmMain.submit();
}

function back()
{
	window.history.back(-1);
}

</script>




</BODY></HTML>


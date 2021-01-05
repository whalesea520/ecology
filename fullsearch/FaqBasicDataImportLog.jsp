<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17887, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
#myloading{
    position:absolute;
    left:35%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	var parentWin = parent.getParentWindow(window);
	var dialog = parent.getDialog(parent);
	var index = 0;
	var timeId;
	jQuery(document).ready(function(){
		timeId=window.setInterval(getData,2000); //定时读取
		function getData(){
			jQuery.get("FaqBasicDataImportLogData.jsp?index="+index,function(data){
		   jQuery(".ListStyle").children("TBODY").append(data);
			});
		}	
		jQuery(".e8_sep_line").hide();
	})
		
	function changeIndex(resultIndex){
	  index=resultIndex;
	}
		
	function callback(message,logFile){
		window.clearInterval(timeId);
		$("#myloading").css("display","none");
  	if(message=='ok'){
  		jQuery("#logFile").val(logFile);
  		parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(24645, user.getLanguage())%>');
  		dialog.Title='<%=SystemEnv.getHtmlLabelName(24645, user.getLanguage())%>';
    	if(logFile!='null'){
    		jQuery(".e8_sep_line").show();
    	}
   	}
	}
	
	</script>
</HEAD>
<div class="zDialog_div_content">
<body>
<input id="logFile" name="logFile" type="hidden" value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<TABLE id="messageTable" class=ListStyle cellspacing=1>
	<TBODY>
		<TR class=HeaderForXtalbe>
	 		<th width="30%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	 		<th width="70%"><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></th> 
	 	</TR>
	</TBODY>
</TABLE>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<div id="myloading">	
	<span  id="loading-msg"><img src="/images/loading2_wev8.gif"><%=SystemEnv.getHtmlLabelName(20904, user.getLanguage())%></span>
</div>
<iframe id="downLoad" src="" style="display: none;"></iframe>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</body>
</html>
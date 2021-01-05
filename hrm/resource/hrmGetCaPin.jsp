
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String titlename = "" ;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
			var parentWin = parent.getParentWindow(window);
			var dialog = parent.getDialog(this);

		</script>
	</head>
	<BODY>
	  <div class="zDialog_div_content">
		 <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			  	<wea:item><%="UKEY"%></wea:item>
			  	<wea:item>
			  		<input class=inputstyle type="password" size=50 id="pinId" >
				</wea:item>
			</wea:group>
		 </wea:layout>
	  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" class="e8_btn_cancel" onclick="checkCa();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);

			jQuery.getScript('/wui/common/js/cacheck.js?t='+new Date().getTime(),function(){
				try{
					SafeEngineCtlObj.plugin = window.top ;
					SafeEngineCtlObj.checkBorser() ;
				}catch(e){
					alert(e);
				}
			});
		});

		function checkCa(){
			var pin = $.trim($('#pinId').val());
			if(!pin){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())+"UKEY"%>");
				return  ;
			}
			dialog.callbackfun(pin);

			dialog.closeByHand();
		}


	</script>
	</BODY>
</HTML>

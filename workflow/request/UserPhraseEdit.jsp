
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<!DOCTYPE html>
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = $label(16579,user.getLanguage());
	String addfrom = Util.null2String(request.getParameter("addfrom"));
	String id = request.getParameter("id");
	String operation = "add";
	String phraseShort = "";
	String phraseDesc = "";
	
	if(id != null){
		operation = "edit";
		RecordSet.executeSql("select id,hrmId,phraseShort,"
							+"phraseDesc from sysPhrase where id=" + id);
		
		if( RecordSet.next() ){
			phraseShort = RecordSet.getString("phraseShort");
			phraseDesc = RecordSet.getString("phraseDesc");
		}
	}
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+$label(86,user.getLanguage())+",javascript:pager.doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="../../js/weaver_wev8.js"></script>
		<!-- 
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script> -->
		<!--引入ueditor相关文件-->
		<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
		<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
		<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
		<!--添加插件-->
		<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
		
		<!-- word转html插件 -->
		<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
		
		<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
		<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
		<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
		<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
		<!-- ckeditor的一些方法在uk中的实现 -->
		<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
		
		<script>
			jQuery(document).ready(function(){
				jQuery(".e8tips").wTooltip({html:true});
				pager.init();
			});
			
			var pager = {
				init : function(){
					var ue = UEUtil.initParse("phraseDesc",null,150);
					CkeditorExt.checkText("phraseDescspan","phraseDesc");
					pager.bind();
					setTimeout("jQuery('#cke_phraseDesc').css('margin-right','30px')", 100);
					if( jQuery('#phraseId').val() != 'null'){
						jQuery('#phraseShortspan').css('display', 'none');
					}
				},
				
				bind : function(){
					jQuery('#zd_btn_cancle').click(function(){
						pager.close();
					});
				},
				
				doSave : function(){ 
					CkeditorExt.updateContent('phraseDesc');
					var elements = ['phraseShort', 'phraseDesc' ];
					var phraseShort = jQuery('#phraseShort').val()
					var phraseDesc = CkeditorExt.getHtml("phraseDesc");
					//var _data = "operation="+jQuery('#operation').val()+"&phraseId="+jQuery('#phraseId').val()+"&phraseShort="+phraseShort+"&phraseDesc="+phraseDesc;
					var _data = {operation: jQuery('#operation').val(), phraseId : jQuery('#phraseId').val(), phraseShort : phraseShort, phraseDesc : phraseDesc };
					//_data = _data.replace(/&quot;/g,"");
					//_data = _data.replace(/&#39;/g,"");
					if(check_form(weaver, elements.join(',')) ){
						jQuery.post(
							'/workflow/sysPhrase/PhraseOperate.jsp',
							_data,
							function(data){
								var sourceWindow = parent.getDialog(window).currentWindow;
								<%if("1".equals(addfrom)){%>
									var returnjson = {id:phraseShort,name:phraseDesc};
									parent.getDialog(window).close(returnjson);
									//dialog.callback(returnjson);
								<%}else{%>
									sourceWindow.location.reload();
									parent.getDialog(window).close();
								<%}%>
								
							}
						);
					} 
				},
				
				close : function(){
					parent.getDialog(window).close();
				}
			};
		
		</script>
	</head>
 
<body scroll="no">

<div class="zDialog_div_content">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="<%= $label(22409,user.getLanguage())%>"/>
	</jsp:include>

	<form id="weaver" action="/workflow/sysPhrase/PhraseOperate.jsp" method="post" style="width:100%;">
	  	<input type="hidden" id='operation' name="operation" value="<%=operation %>">
	  	<input type="hidden" id='phraseId' name="phraseId" value="<%=id %>">
	  	
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			    	<input id="btnSave" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"  class="e8_btn_top" onclick="pager.doSave()"/>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>  
		
		<div style="overflow: hidden;">
		<wea:layout type="twoCol">
		    <wea:group context='<%= $label(33396,user.getLanguage())%>'>
		    	<wea:item><%= $label(18774,user.getLanguage())%></wea:item>
			    <wea:item>
			    		<input id="phraseShort" name="phraseShort" value="<%=phraseShort %>" 
			    			class="Inputstyle" maxLength="50" size="50"
			    			onchange='checkinput("phraseShort","phraseShortspan")'/>
			    		<span id='phraseShortspan'>
			            	<img src="/images/BacoError_wev8.gif" align='absMiddle'/>
		            	</span>
		            	&nbsp;&nbsp;
						<span class='e8tips' title='<%=$label(20246,user.getLanguage())%>30(<%=$label(20247,user.getLanguage())%>)'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>
			    </wea:item>
		    	<wea:item attributes="{'colspan':2}"><%= $label(18775,user.getLanguage())%></wea:item>
		    	<wea:item attributes="{'colspan':2}">
		    		<div style='display:inline-block;height:auto;'>
	    				<textarea id="phraseDesc" viewtype="1" name="phraseDesc" class="Inputstyle" style="height:240px;border: 1px #e7e7e7 solid;"><%=phraseDesc%></textarea>
	    				<span id='phraseDescspan'>
			            	<img src="/images/BacoError_wev8.gif" align='absMiddle'/>
		            	</span>
		            	&nbsp;&nbsp;
						<span class='e8tips' title='<%=$label(20246,user.getLanguage())%>1000(<%=$label(20247,user.getLanguage())%>)'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>
    				</div>
		    	</wea:item>
		    </wea:group>
		</wea:layout>	
		</div>
	</form>
	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=$label(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	
</body>
</html>

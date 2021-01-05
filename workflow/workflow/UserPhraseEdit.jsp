
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
	
	String id = request.getParameter("id");
	String pdid = request.getParameter("pdid");
	String operation = "officaladd";
	String phraseShort = "";
	String phraseDesc = "";
	String sortorder = "0.0";
	
	if(id != null){
		operation = "officaledit";
		RecordSet.executeSql("select id,pd_id,phraseShort,sortorder,"
							+"phraseDesc from workflow_processinst where id=" + id);
		
		if( RecordSet.next() ){
			phraseShort = RecordSet.getString("phraseShort");
			phraseDesc = RecordSet.getString("phraseDesc");
			sortorder = RecordSet.getString("sortorder");
		}
	}
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
		<style type="text/css">
			span.cke_skin_kama{
				border:1px solid #D3D3D3!important;
				display:inline-block;
			}
		</style>
		<script>
		
			jQuery(document).ready(function(){
				pager.init();
			});
			
			var pager = {
				init : function(){
					CkeditorExt.initEditor("weaver","phraseDesc","<%=user.getLanguage()%>",CkeditorExt.NO_IMAGE,150);
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
                    var pname = window.encodeURI(jQuery('#phraseShort').val());
                    var pdesc = window.encodeURI(jQuery('#phraseDesc').val());
					
					if(check_form(weaver, elements.join(',')) ){
						jQuery.post(
							'/workflow/sysPhrase/PhraseOperate.jsp',
							{
								'operation' : jQuery('#operation').val(),
								'phraseId' : jQuery('#phraseId').val(),
								'phraseShort' : pname,
								'phraseDesc' : pdesc,
								'sortorder': jQuery("#sortorder").val(),
								"pdid":"<%=pdid%>"
							},
							function(data){
								var sourceWindow = parent.getDialog(window).currentWindow;
								try{
									sourceWindow._table.reLoad();
								}catch(e){}
								
								parent.getDialog(window).close();
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


	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="offical"/>
	   <jsp:param name="navName" value="<%= $label(22409,user.getLanguage())%>"/>
	</jsp:include>
<div class="zDialog_div_content">
	<form id="weaver" action="/workflow/sysPhrase/PhraseOperate.jsp" method="post" style="width:100%;">
	  	<input type="hidden" id='operation' name="operation" value="<%=operation %>">
	  	<input type="hidden" id='phraseId' name="phraseId" value="<%=id %>">
	  	
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			    	<input id="btnSave" type="button" value="<%= $label(86,user.getLanguage())%>"  class="e8_btn_top" onclick="pager.doSave()"/>
					<span title="<%= $label(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>  
		
		
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
			    </wea:item>
		    	<wea:item attributes="{'colspan':'full'}"><%= $label(18775,user.getLanguage())%></wea:item>
		    	<wea:item attributes="{'colspan':'full'}">
		    		<div style='display:inline-block;'>
	    				<textarea id="phraseDesc" name="phraseDesc" class="Inputstyle"><%=phraseDesc %></textarea>
	    				<span id='phraseDescspan'>
			            	<img src="/images/BacoError_wev8.gif" align='absMiddle'/>
		            	</span>
    				</div>
		    	</wea:item>
		    	<wea:item><%= $label(15513,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<input type="text" name="sortorder" id="sortorder" value="<%=sortorder %>" style="width:50px;"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>	
				
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
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
	
</body>
</html>

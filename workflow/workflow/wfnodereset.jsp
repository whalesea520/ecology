
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String nodename = Util.null2String(request.getParameter("nodename"));
int status = Util.getIntValue(request.getParameter("status"),-1);

%>

<html>
  <head>
	<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
	<script type="text/javascript">
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
	
		function savenodeInfo(){
			var nodename = jQuery('#nodename').val();
			var nodetype = jQuery('#nodetype').val();
			if(<%=status%> === 0){
				if(nodename == null || nodename == ""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83869,126206",user.getLanguage())%>");
					return;
				}
				
				parentWin.checkNodeNameAndnodeType(<%=nodeid%>,nodename);
			}else{
				parentWin.reductionnode(<%=nodeid%>,nodename,nodetype);
			}
			dialog.close();
		}
	</script>
	<style type="text/css">
		*{font-size:12px;}
		.contenttable{
			margin: auto;  
			overflow: auto;  
			border:0px;
			cellspacing:0px;
			cellpadding:0px;
			padding-top:80px;
		}
		.td2{width:220px;}
	</style>
	
  </head>
  
  <body style="overflow:hidden;margin:0px;">
      <div class="zDialog_div_content" id="zDialog_div_content" style="height:255px;">
          <table  class="contenttable">
          		<tr>
          			<td rowspan="3" class="td1"><img id="Icon_undefined" src="/wui/theme/ecology8/skins/default/rightbox/icon_alert_wev8.png" style="margin-right:15px;margin-top:-40px;" width="26" height="26" align="absmiddle"></td>
          			<%if(0 == status){ %>
          			<td class="td2"><%=SystemEnv.getHtmlLabelName(127042,user.getLanguage()) %></td>
          			<%}else{%>
          			<td class="td2"><%=SystemEnv.getHtmlLabelName(127043,user.getLanguage()) %></td>
          			<%} %>
          		</tr>
          		<tr><td colspan="2" style="height:10px;"></td></tr>
                <tr style="padding-top:20px;">
                	<td class="td3">
                	<%if(0 == status){ %>
                	<input type="text" value="<%=nodename %>" name="nodename" id="nodename" style="width:220px;">
               		<%}else{%>
               		<input type="hidden" value="<%=nodename %>" name="nodename" id="nodename" style="width:220px;">
               		<select id="nodetype" style="width:220px;">
             			<option value="1"><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong></option>
						<option value="2"><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong></option>
						<option value="3"><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong></option>
               		</select>
               		<%} %>
               		</td>
                </tr>
          </table>
      </div>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
          <table width="100%">
		      <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(127031,user.getLanguage())%>" onclick="savenodeInfo()" class="zd_btn_submit" id="btnok">
		          <span class="e8_rightBorder">|</span>
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();"/>
		      </td></tr>
		  </table>
	  </div>
  </body>
</html>

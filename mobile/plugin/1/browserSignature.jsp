<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<style type="text/css">
		/**控制alert弹出框的的宽度 */
		.asyncbox_table{
			font-size: 12px!important;
		}
	
		/**控制alert弹出框的的宽度 */
		#asyncbox_alert_content {
			height:auto!important;
			min-height:10px!important;
		}
		
		/**控制alert弹出框的的宽度*/
		#asyncbox_alert{
			min-width: 220px!important;
			max-width: 280px!important;
		}
		
		/**控制页面上按钮的显示样式*/
		.operationBt {
			height: 24px;
			margin-left: 8px;
			margin-right: 8px;
			margin-top: 8px;
			margin-bottom: 8px;
			line-height: 22px;
			font-size: 14px;
			padding-left: 10px;
			padding-right: 10px;
			color: #fff;
			text-align: center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
			border-radius: 5px;
			border: 1px solid #0084CB;
			background: #0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background: -webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB) );
			overflow: hidden;
			width: 28px;
			display: inline-block;
		}
	</style>
<%
	response.setContentType("text/html;charset=UTF-8");
	String userId = Util.null2String(request.getParameter("userid"));
	User user = HrmUserVarify.getUser (request , response) ;
	List lstSigns = weaver.docs.docs.SignatureManager.getSignatureList(userId);
	
	if(lstSigns == null || lstSigns.size() == 0){
%>
	<script type="text/javascript">
		jQuery(function(){
    		parent.setMarkPath(-1);
    		parent.closeSignatureDialog();
		});
	</script>
<%  return; } %>
	<script type="text/javascript">
		function ajaxinit(){
		    var ajax=false;
		    try {
		        ajax = new ActiveXObject("Msxml2.XMLHTTP");
		    } catch (e) {
		        try {
		            ajax = new ActiveXObject("Microsoft.XMLHTTP");
		        } catch (E) {
		            ajax = false;
		        }
		    }
		    if (!ajax && typeof XMLHttpRequest!='undefined') {
		    ajax = new XMLHttpRequest();
		    }
		    return ajax;
		}
		
		function selectSignature(){
			var markNameId = document.getElementById("markName").value;
			if(markNameId == ""){
				alert("<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30490, user.getLanguage())%>!");
				return false;
			}
			
			//去掉密码验证功能，直接设值。
       		parent.setMarkPath(markNameId);
       		parent.closeSignatureDialog();
		}
		
		function clearSignature(){
       		parent.setMarkPath("");
       		parent.closeSignatureDialog();
		}
	</script>
  </head>
  
  <body>
  	   <form id="eletricSignature" name="eletricSignature" method="post">
   		<table style="align:center;width:100%;">
			<colgroup>
				<col width="50%">
				<col width="50%">
			</colgroup>
   			<tr>
   				<td style="text-align:left; font-size:12px; color:#666666;width:50%;">
   					<%=SystemEnv.getHtmlLabelName(18694, user.getLanguage())%>:</td>
   				<td style="text-align:left; font-size:12px; color:#666666;width:50%;">
   				<%--  改变下拉别表时候清空密码框  --%>
   					<select id="markName" name="markName" style="width:100%;height:25px;float:left;" >
   						<% for(int i = 0; i<lstSigns.size() ; i++){  %>
    						<option value="<%=((String[])lstSigns.get(i))[0]%>"><%=((String[])lstSigns.get(i))[1]%></option>
    					<% } %>
   					</select>
   				</td>
   			</tr>
<%--  		屏蔽签章密码功能。
			<tr><td colspan="2" style="height:5px;border-top:1px solid #CFD3D8;width:100%;"></td></tr>
   			<tr>
   				<td style="text-align:left; font-size:12px; color:#666666;width:50%;">
   					<%=SystemEnv.getHtmlLabelName(28232,user.getLanguage())%>:</td>
   				<td style="text-align:left; font-size:12px; color:#666666;width:50%;">
   					<input style="width:100%;height:25px;float:left;" type="password" id="markPwd" name="markPwd"/>
   				</td>
   			</tr>  --%>  
   			<tr><td colspan="2" style="height:5px;border-top:1px solid #CFD3D8;width:100%;"></td></tr>
   			<tr>
   				<td colspan="2" align="center">
   					<%-- 确定 --%>
   					<div class="operationBt" style="text-align:center;" onclick="selectSignature();"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></div>
   					<%-- 清除 --%>
   					<div class="operationBt" style="text-align:center;" onclick="clearSignature();"><%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></div>
   					<%-- 取消 --%>
   					<div class="operationBt" style="text-align:center;" onclick="parent.closeSignatureDialog();"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></div>
   				</td>
   			</tr>
   		</table>
  	  </form>
  </body>
</html>

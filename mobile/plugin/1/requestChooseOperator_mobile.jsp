<!-- 此页面已弃用 liuzy -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
%>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/1/js/jquery-1.6.2.min_wev8.js'></script>
	<!--弹出框-->
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<style type="text/css">
		.floatleft{float:left}
		.topdiv{margin:12px 10px 30px 10px;}
		.bottomdiv{width:150px; height:30px; margin-bottom:15px;}
		td{border-bottom:1px solid #F3F2F2;}
		.operBtn{
			width:50px; margin-left:18px; height:26px; line-height:26px;
			overflow:hidden; font-size:14px; text-align:center; color:#fff;
			border:1px solid #0084CB;
			border-radius:5px; -moz-border-radius:5px; -webkit-border-radius:5px; 
			background:#0084CB;
			background:-moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
		}
		.chooseBtn{
			width:35px; height:32px; 
			background-image:url('/images/search_icon_wev8.png'); background-repeat:no-repeat;
		}
		.ismand{font-size:20pt; color:red;}
	</style>
	<script type="text/javascript" src="/mobile/plugin/1/js/view/1_wev8.js"></script>
	<script type="text/javascript">
		jQuery("document").ready(function(){
			dynamicHeight_exceptionPage("180px");
		});
	
		function dynamicHeight_exceptionPage(hgt){
			jQuery("#"+parent.getDialogId_ChooseOperator(), parent.window.document).css("height", hgt);
			jQuery("iframe#"+parent.getDialogId_ChooseOperator()+"_content", parent.window.document).css("height", hgt);
			jQuery(document.body).css("height", parseInt(hgt.replace("px",""))-20);
		}
	
		function chooseOperator(){
			var url = "/mobile/plugin/browser.jsp";
			var data = "&returnIdField=exceptionoperators&returnShowField=exceptionoperators_span&method=listUser&isMuti=1";
			showDialog2(url, data);
		}
		
		function doSumbit(){
			parent.closeChooseDialog_confirm(jQuery("#relationship").val(), jQuery("#exceptionoperators").val());
		}
		
		function doClose(){
			parent.closeChooseDialog_cancel();
		}
		
		//以下1_wev8.js方法
		function openDialog_ChooseOperator(){
			var url = "/mobile/plugin/1/requestChooseOperator_mobile.jsp";
			var top = ($( window ).height()-400)/2;
			var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
			$.open({
				id : "eh_chooseOperator",
				url : url,
				data: "r=" + (new Date()).getTime(),
				title : "请选择",
				width : width,
				height : 180,
				scrolling:'yes',
				top: top,
				callback : function(action, returnValue){
				}
			}); 
			$.reload('eh_chooseOperator', url + "?r=" + (new Date()).getTime());
		}
		
		function getDialogId_ChooseOperator() {
			return "eh_chooseOperator";
		}
		
		function closeChooseDialog_confirm(eh_relationship, eh_operators){
			$.close("eh_chooseOperator");
			dosubback_chooseOperator(true, eh_relationship, eh_operators);
		}
		
		function closeChooseDialog_cancel(){
			$.close("eh_chooseOperator");
			dosubback_chooseOperator(false);
		}
		
		function dosubback_chooseOperator(state, eh_relationship, eh_operators){
			if(state){
				jQuery("form#workflowfrm").append('<input type="hidden" name="eh_setoperator" value="y" />');
				jQuery("form#workflowfrm").append('<input type="hidden" name="eh_relationship" value="'+eh_relationship+'" />');
				jQuery("form#workflowfrm").append('<input type="hidden" name="eh_operators" value="'+eh_operators+'" />');
			}else{
				jQuery("form#workflowfrm").append('<input type="hidden" name="eh_setoperator" value="n" />');
			}
			dosubback();
		}
	</script>
</head>
<body style="overflow-x:hidden">
<div class="topdiv">
	<table style="width:100%;">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(21790, user.getLanguage()) %></td>
			<td>
				<select id="relationship">
					<option value="0"><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage()) %></option>
					<option value="1"><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage()) %></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage()) %></option>
				</select>
			</td>
		</tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(124955, user.getLanguage()) %></td>
			<td>
				<div>
					<table>
						<tr>
							<td style="width:10%" onclick="javascript:chooseOperator();"><div class="chooseBtn floatleft" ></div></td>
							<td style="width:90%" id="exceptionoperators_span"></td>
							<td><span id="exceptionoperators_ismandspan" class="ismand">!</span><input type="hidden" id="exceptionoperators" name="operators" /></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
</div>
<center>
<div class="bottomdiv">
	<div class="operBtn floatleft" onclick="javascript:doSumbit();"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %></div>
	<div class="operBtn floatleft" onclick="javascript:doClose();"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %></div>
</div>
</center>
</body>
</html>
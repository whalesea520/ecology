<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.scriptlib.FParam"%>
<%@page import="com.weaver.formmodel.mobile.scriptlib.Function"%>
<%@page import="com.weaver.formmodel.mobile.scriptlib.ScriptLibHandler"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
	String fid = Util.null2String(request.getParameter("fid"));
	Function function = ScriptLibHandler.getInstance().getFunById(fid);
	
%>
<html>
<head>
<title></title>
<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
<style type="text/css">
*{
	font-family: 'Microsoft YaHei', Arial;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px 10px 20px 10px;
	overflow: hidden;
	
}
body{
	padding-top: 10px;
}
.mainTable{
	width: 100%;
	border-collapse: collapse;
}
.mainTable td{
	border-bottom: 1px dotted #ccc;
	padding: 5px 2px;
	vertical-align: top;
	color: #666;
}
.mainTable td.label{
	font-weight: bold;
	text-align: right;
	color: #333;
}
.mainTable td .content div{
	line-height: 20px;
}
.mainTable tr.noborder td{
	border-bottom: none;
}
.p_table{
	width: 100%;
	border-collapse: collapse;
}
.p_table td{
	padding: 0px;
	padding-bottom: 10px;
	border-bottom: none;
	padding-right: 5px;
}
.p_table tr:last-child td{
	padding-bottom: 5px;
}
.p_table td.p_required{
	color: #bbb;
}
.p_table td.p_type{
	color: #bbb;
}
.resurnContent{
	line-height: 20px;
	margin-top: -2px;
}
textarea.codeContainer{
	width: 99%;height: 280px;border: none;font-size: 12px;font-family: 'Microsoft YaHei', Arial;color:#666;line-height:23px;
	margin-top: -5px;
	resize: none;
	overflow-y: auto;
	overflow-x: hidden;
}
.p_explain{
    max-width: 370px;
}
</style>

<script>
$(function(){
	$("textarea.codeContainer").niceScroll({
		cursorcolor:"#aaa",
		cursorwidth:3,
		horizrailenabled: false
	});
});
</script>
</head>
<body>
	<table class="mainTable">
		<colgroup>
			<col width="45px"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="label"><%=SystemEnv.getHtmlNoteName(4981,user.getLanguage())%><!-- 签名：--></td>
			<td><%=function.getSign() %></td>
		</tr>
		<tr>
			<td class="label"><%=SystemEnv.getHtmlNoteName(4982,user.getLanguage())%><!-- 描述：--></td>
			<td>
				<div class="content">
					<%=Util.formatMultiLang(function.getDesc()) %>
				</div>
			</td>
		</tr>
		<tr>
			<td class="label"><%=SystemEnv.getHtmlNoteName(4983,user.getLanguage())%><!-- 参数：--></td>
			<td>
				<table class="p_table">
					<%
						List<FParam> params = function.getParams();
						if(params.size() == 0){
						%>
							<tr>
								<td colspan="4"><%=SystemEnv.getHtmlNoteName(4984,user.getLanguage())%><!-- 无参数 --></td>
							</tr>
						<%	
						}else{
							for(int i = 0; i < params.size(); i++){
								FParam fParam = params.get(i);
							%>
							<tr>
								<td class="p_name">
									<%=fParam.getName() %>
								</td>
								<td class="p_required"><%=fParam.getRequired().equalsIgnoreCase("true") ? "["+SystemEnv.getHtmlLabelName(383237,user.getLanguage()).trim()+"]" : "["+SystemEnv.getHtmlLabelName(383238,user.getLanguage()).trim()+"]" %><!-- 必需 可选 --></div>
								<td class="p_type">(<%=fParam.getType() %>)</td>
								<td class="p_explain"><%=Util.formatMultiLang(fParam.getExplain()) %></td>
							</tr>
							<%	
							}
						}
					%>
				</table>
			</td>
		</tr>
		<tr>
			<td class="label"><%=SystemEnv.getHtmlLabelName(383240,user.getLanguage())%><!-- 返回： --></td>
			<td>
				<div class="resurnContent">
					<%
						String returnV = Util.formatMultiLang(function.getReturnV());
						if(returnV.trim().equals("")){
							returnV = SystemEnv.getHtmlLabelName(383241,user.getLanguage());
						}
					%>
					<%=returnV %>
				</div>
			</td>
		<tr class="noborder">
			<td class="label"><%=SystemEnv.getHtmlLabelName(127578,user.getLanguage())%><!-- 示例： --></td>
			<td>
				<div style="overflow: hidden;">
					<textarea readonly="readonly" class="codeContainer"><%=Util.formatMultiLang(function.getExample()) %></textarea>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>

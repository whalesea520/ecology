
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%@ page import="weaver.servicefiles.DataSourceXML"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String type = Util.null2String(request.getParameter("remindtype"));
if(type.equals("")){
	type = "1";
}
String sql = Util.null2String(request.getParameter("remindsql"));

String datasource = Util.null2String(request.getParameter("reminddatasource"));

String javafilename = Util.null2String(request.getParameter("remindjavafilename"));

DataSourceXML dataSourceXML = new DataSourceXML();
List pointArrayList = dataSourceXML.getPointArrayList();
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	
	<style>
	*{
		font-family: 'Microsoft YaHei', Arial;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: hidden;
	}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 9px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #999;
		font-size: 10px;
	}
	.cbboxContainer{
		margin: 0px 0px 0px -3px;
		padding: 3px 0px;
		float:left;
	}
	.cbselContainer{
		margin: 0px 0px 0px -3px;
		padding: 3px 13px 0px 0px;
		float:right;
	}
	.cbboxEntry{
		display: inline-block;position: relative;padding-right: 20px;
	}
	.cbboxLabel{
		color: #999;font-size: 11px;position: absolute;top:3px;left:18px;
	}
	.cbselEntry{
		display: inline-block;position: relative;
	}
	.cbselLabel{
		color: #999;font-size: 11px;
	}
	.cbselObj{
		width: 80px;
	}
	.valueContent{
		display: none;
	}
	.codeEditFlag{
		padding-left:20px;
		padding-right: 10px;
		height: 16px;
		background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
		cursor: pointer;
		margin-left: 2px;
		margin-top: 2px;
		position: relative;
	}
	.codeDelFlag {
		position: absolute;
		top: 2px;
		right: 2px;
		width: 9px;
		height: 9px;
		background: transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
		cursor: pointer;
	}
	</style>
<script type="text/javascript">
$(function() {
	var type = <%=type%>;
	$("#valueDiv_"+type).show();
	if (type == 1) $("#dataSourceDiv").css("display","");
	if (type == 2) $("#dataSourceDiv").css("display","none");
	var cbObj = $("input[type='checkbox'][name='type'][value='<%=type%>']")[0];
	try{
		changeCheckboxStatus(cbObj, true);
	}catch(e){}
	
	$(".codeDelFlag").click(function(e){
		if(confirm("<%=SystemEnv.getHtmlLabelName(127514,user.getLanguage())%>")){   //确定删除吗？
			$("#javafilename_span").html("");
			$("#javafilename").val("");
			$(".codeDelFlag").hide();
		}
		e.stopPropagation(); 
	});
});

function fiexdUndefinedVal(v, defV){
	if(typeof(v) == "undefined" || v == null){
		if(defV){
			return defV;
		}else{
			return "";
		}
	}
	return v;
}

function changeSCT(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='type']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if (objV == 1) $("#dataSourceDiv").css("display","");
		if (objV == 2) $("#dataSourceDiv").css("display","none");
		$(".valueContent").hide();
		$("#valueDiv_"+objV).show();
	},100);
}

function openCodeEdit(type){
	top.openCodeEdit({
		"type" : type,
		"filename" : $("#javafilename").val()
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span").html(fName);
			$("#javafilename").val(fName);
			$(".codeDelFlag").show();
		}
	});
}

function onSave(){
	if(top && top.callTopDlgHookFn){
		var result = {
			"remindtype" : $("input[type='checkbox'][name='type']:checked").val(),
			"remindsql" : $("#sql").val(),
			"reminddatasource" : $("#dataSource").val(),
			"remindjavafilename" : $("#javafilename").val()
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onClose(){
	if(top && top.closeTopDialog){
		top.closeTopDialog();
	}else{
		window.close();
	}
}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83446,user.getLanguage())+",javascript:onSave(),_top} " ;  //确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32694,user.getLanguage())+",javascript:onClose(),_top} " ; //取消
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table class="e8_tblForm" style="margin-top: -3px;" style="display: none;">
	<tr>
		<td class="e8_tblForm_label" colspan="2">
			<div class="cbboxContainer">
				<span class="cbboxEntry">
					<input type="checkbox" name="type" value="1" onclick="changeSCT(this);"/><span class="cbboxLabel">sql</span>
				</span>
				<span class="cbboxEntry">
					<input type="checkbox" name="type" value="2" onclick="changeSCT(this);"/><span class="cbboxLabel">java</span>
				</span>
			</div>
			<div id="dataSourceDiv" class="cbselContainer">
				<span class="cbselEntry">
					<span class="cbselLabel"><%=SystemEnv.getHtmlLabelName(127575,user.getLanguage())%><!-- 数据源： --></span>
					<select id="dataSource" class="cbselObj">
						<option value="">(local)</option>
						<% 
							for (int i = 0 ; pointArrayList != null && i < pointArrayList.size() ; i++) { 
								String pointid = Util.null2String(pointArrayList.get(i));
						%>
								<option value="<%=pointid%>" <%if(datasource.equals(pointid)){%>selected<%}%>><%=pointid%></option>
						<%  } %>
					</select>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td class="e8_tblForm_label" width="50">
			<%=SystemEnv.getHtmlLabelName(127576,user.getLanguage())%><!-- 取值： -->
		</td>
		<td class="e8_tblForm_field" style="height:208px; vertical-align: top;">
			<div id="valueDiv_1" class="valueContent">
				<textarea id="sql" name="sql" style="width:95%;height:95px;"><%=sql %></textarea>
				<div class="e8_label_desc"><label style="font-size: 11px;"><%=SystemEnv.getHtmlLabelName(127577,user.getLanguage())%><!-- 可使用变量： --></label><br/>
				<%=SystemEnv.getHtmlLabelName(24533,user.getLanguage())%><!-- 用户 -->:{curruser},<%=SystemEnv.getHtmlLabelName(126029,user.getLanguage())%><!-- 部门 -->:{currdept},<%=SystemEnv.getHtmlLabelName(31131,user.getLanguage())%><!-- 日期 -->:{currdate},<%=SystemEnv.getHtmlLabelName(25130,user.getLanguage())%><!-- 时间 -->:{currtime},<br/>
				<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分部 -->:{currdeptsub},<%=SystemEnv.getHtmlLabelName(82281,user.getLanguage())%><!-- 日期时间 -->:{currdatetime}<br/>
				<label style="font-size: 11px;"><%=SystemEnv.getHtmlLabelName(127578,user.getLanguage())%><!-- 示例： --></label><br/>
				select count(1) as nums from tablename where col1 = '{curruser}' and col2 = '{currdate}'
				</div>
			</div>
			<div id="valueDiv_2" class="valueContent">
				<span class="codeEditFlag" onclick="openCodeEdit(4);">
					<span id="javafilename_span"><%=javafilename %></span>
					<div class="codeDelFlag" <%if(javafilename.equals("")){%>style="display: none;"<%}%>></div>
				</span>
				<input type="hidden" id="javafilename" name="javafilename" value="<%=javafilename %>"/>
			</div>
		</td>
	</tr>
</table>
</body>
</html>

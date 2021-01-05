<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppField"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppFieldManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
int sourceV = Util.getIntValue(Util.null2String(request.getParameter("sourceV")));
JSONArray asArr;
String advancedSearchContent = Util.null2String(request.getParameter("advancedSearchContent"));
if(advancedSearchContent.trim().equals("")){
	asArr = new JSONArray();
}else{
	asArr = JSONArray.fromObject(advancedSearchContent);
}

MobileAppUIManager mobileAppUIManager = MobileAppUIManager.getInstance();
AppFormUI formui = (AppFormUI)mobileAppUIManager.getById(sourceV);
int formid = formui.getFormId();
List<AppField> fieldlist = MobileAppFieldManager.getInstance().getAppFieldList(formid, 7);

JSONArray fieldArr = new JSONArray();
for(AppField appField : fieldlist) {
	JSONObject fieldObj = new JSONObject();
	if(appField.getHtmlType() != 6 && appField.getHtmlType() != 7){//option选项过滤掉附件和特殊字段
		fieldObj.put("id", appField.getFieldid());
		fieldObj.put("name", appField.getFieldName());
		fieldObj.put("desc", appField.getFieldDesc());
		fieldArr.add(fieldObj);
	}
}
%>
<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<style type="text/css">
*{
	font-family: 'Microsoft Yahei', Arial;
}
body{
	padding: 2px 5px 0px 5px;
}
.e8_zDialog_bottom{
	position: absolute;
	left: 0px;
	bottom: 0px;
	width: 100%;
}
#searchTableWrap{
	max-height: 300px;
	min-height: 35px;
	overflow-x: hidden;
	overflow-y: auto;
}
.searchTable{
	width: 100%;
	border-collapse: collapse;
	table-layout: fixed;
}
.searchTable thead td{
	color: #A4A9AE;
	border-bottom: 1px solid #DFDFDF;
	font-weight: bold;
	font-size: 13px;
	padding: 8px 3px 8px 3px;
}
.searchTable tbody td{
	border-bottom: 1px solid rgb(233, 236, 243);
	padding: 10px 3px;
}
.searchTable tbody td.bemove{
	background: url("/mobilemode/images/tr_move2_wev8.png") no-repeat center;
	cursor: move;
}
.searchTable tbody tr:last-child td{
	border-bottom:none;
}
.fieldSel{
	border: 1px solid #E3E3E3;
	vertical-align: middle;
	width: 120px;
	height: 26px;
	line-height: 26px;
}
.shownameText{
	border: 1px solid #E3E3E3;
	width: 145px;
	height: 24px;
	padding: 0px;
}
.delBtn{
	width: 25px;
	height: 25px;
	background: url("/mobilemode/images/del-3.png");
	cursor: pointer;
}
.delBtn:HOVER{
	background-image: url("/mobilemode/images/del-3-hover.png");
}
#addSearch{
	border: 2px dotted rgb(223, 223, 223);
	height: 43px;
	line-height: 43px;
	text-align: right;
	cursor: pointer;
	background: #f9f9f9;
}
#addSearch div{
	color: rgb(185, 185, 185);
	float: right;
	height: 100%;
	background: url("/mobilemode/images/plus-small.png") no-repeat;
	background-position: 0px center;
	padding-left: 20px;
	font-size: 14px;
	margin-right: 13px;
}
#addSearch:HOVER div{
	background-image: url("/mobilemode/images/plus-small-hover.png");
	color: rgb(0, 144, 255);
}
.errstatus1{
	background-color: #4572a7;
}
.errstatus2{
	background-color: #aa4643;
}
.errstatus3{
	background-color: #89a54e;
}
.errstatus4{
	background-color: #80699b;
}
.errstatus5{
	background-color: #92a8cd;
}
.errstatus6{
	background-color: #db843d;
}
.errstatus7{
	background-color: #a47d7c;
}
.errstatus8{
	background-color: #fedd74;
}
.errstatus9{
	background-color: #82d8ef;
}
.errstatus10{
	background-color: #f76864;
}
.errstatus11{
	background-color: #80bd91;
}
.errstatus12{
	background-color: #fd9fc1;
}
.errstatus13{
	background-color: #bc6666;
}
.errstatus14{
	background-color: #cbab4f;
}
.errstatus15{
	background-color: #76a871;
}
</style>

<script type="text/javascript">
	var fieldArr = <%=fieldArr.toString()%>;
	var asArr = <%=asArr.toString()%>;
	
	window.onload = function(){
		
		for(var i = 0; i < asArr.length; i++){
			addRow(asArr[i]["field"], asArr[i]["showname"]);
		}
		
		$("#searchTableWrap > .searchTable > tbody").sortable({
			revert: false,
			axis: "y",
			items: "tr",
			handle: ".bemove"
		});
	};
	
	function addRow(field, showname){
	
		var $rowContainer = $("#searchTableWrap > .searchTable > tbody");
		
		var $row = $("<tr></tr>");
		
		var html = "<td class=\"bemove\" width=\"30px\"></td>";
			html += "<td width=\"140px\">";
				html += "<select class=\"fieldSel\">";
				for(var i = 0; i < fieldArr.length; i++){
					html += "<option value=\""+fieldArr[i]["name"]+"\">"+fieldArr[i]["desc"]+"</option>";
				}
				html += "</select>";
			html += "</td>";
			html += "<td width=\"160px\">";
				html += "<input type=\"text\" data-multi=false class=\"shownameText\"/>";
			html += "</td>";
			html += "<td width=\"60px\">";
				html += "<div class=\"delBtn\"></div>";
			html += "</td>";
			
		$row.html(html);
		$rowContainer.append($row);
		
		$(".shownameText", $row).focus(function(){
			if(this.value == ""){
				this.value = $(".fieldSel", $row).find("option:selected").text();
			}
		}).val(showname);
		$(".fieldSel", $row).change(function(){
			var $shownameText = $(".shownameText", $row);
			var $multi__clone = $(".multi__clone", $row);
			$shownameText.val($(this).find("option:selected").text());
			$multi__clone.val($(this).find("option:selected").text());
		}).val(field);
		
		$(".delBtn", $row).click(function(){
			$row.remove();
		});
		
		MLanguage({
			container: $row
    	});
	}
	
	function afterAddRow(){
		$("#searchTableWrap > .searchTable > tbody > tr").last().find(".fieldSel").trigger("change");
		$("#searchTableWrap").scrollTop(3000);
	}
	
	function onClose(){
		top.closeTopDialog();
	}
	
	function onOK(){
		var $selectField = $("select[class='fieldSel']");
		$selectField.each(function(j){
			$(this).parent("td").parent("tr").attr("class", "");
		});
		var num = 0;
		var flag = false;
		for(var i = 0; i < fieldArr.length; i++){
			var optionValue = fieldArr[i]["name"];
			var count = 0;
			$selectField.each(function(j){
				if($(this).find("option:selected").val() == optionValue){
					$(this).parent("td").parent("tr").addClass("tempstatus")
					count++;
				}
			});
			if(count > 1){
				flag = true;
				num++;
				$(".tempstatus").addClass("errstatus" + num);
			}
			$(".tempstatus").removeClass("tempstatus");
		}
		if(flag == true){
			alert("<%=SystemEnv.getHtmlLabelName(127601,user.getLanguage())%>");  //查询条件不能重复添加！
			return;
		}
		
		var advancedSearchContent = [];
		$("#searchTableWrap > .searchTable > tbody > tr").each(function(i){
			var $row = $(this);
			var obj = {};
			obj["field"] = $(".fieldSel", $row).val();
			obj["showname"] = MLanguage.getValue($(".shownameText", $row)) || $(".shownameText", $row).val();
			advancedSearchContent.push(obj);
		});
		
		if(top && top.callTopDlgHookFn){
			var result = {
				"advancedSearchContent" : $.isEmptyObject(advancedSearchContent) ? "" : JSON.stringify(advancedSearchContent)
			};
			top.callTopDlgHookFn(result);
		}
		
		onClose();
	}
</script>

</head>
  
<body>
	<div id="searchTableWrap">
	<table class="searchTable">
		<thead>
			<tr>
				<td width="30px"></td>
				<td width="140px"><%=SystemEnv.getHtmlLabelName(83842,user.getLanguage())%><!-- 字段 --></td>
				<td width="160px"><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%><!-- 显示名称 --></td>
				<td width="60px"><%=SystemEnv.getHtmlLabelName(126032,user.getLanguage())%><!-- 操作 --></td>
			</tr>
		</thead>
		<tbody>
			<!-- 
			<tr>
				<td class="bemove"></td>
				<td>
					<select class="fieldSel">
						<option value="aaa">aaa</option>
						<option value="aaa">bbb</option>
						<option value="aaa">ccc</option>
					</select>
				</td>
				<td>
					<input type="text" class="shownameText"/>
				</td>
				<td>
					<div class="delBtn"></div>
				</td>
			</tr>
			<tr>
				<td class="bemove"></td>
				<td>
					<select class="fieldSel">
						<option value="aaa">aaa</option>
						<option value="aaa">bbb</option>
						<option value="aaa">ccc</option>
					</select>
				</td>
				<td>
					<input type="text" class="shownameText"/>
				</td>
				<td>
					<div class="delBtn"></div>
				</td>
			</tr>
			<tr>
				<td class="bemove"></td>
				<td>
					<select class="fieldSel">
						<option value="aaa">aaa</option>
						<option value="aaa">bbb</option>
						<option value="aaa">ccc</option>
					</select>
				</td>
				<td>
					<input type="text" class="shownameText"/>
				</td>
				<td>
					<div class="delBtn"></div>
				</td>
			</tr>
			 -->
		</tbody>
	</table>
	</div>
	
	<div id="addSearch" onclick="addRow();afterAddRow();">
		<div><%=SystemEnv.getHtmlLabelName(127602,user.getLanguage())%><!-- 添加查询 --></div>
	</div>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>

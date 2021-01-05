<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.company.CompanyComInfo" %>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%
	//判断编码
	if(WxInterfaceInit.isIsutf8()){
		response.setContentType("text/html;charset=UTF-8");
	}
	String fieldId = Util.null2String((String)request.getParameter("fieldId"));	//字段id
	String fieldSpanId = Util.null2String((String)request.getParameter("fieldSpanId"));	//字段显示区域id
	String selectedIds = Util.null2String((String)request.getParameter("selectedIds"));	//选中的id，逗号分隔，如：1,2,3
	int browserType = Util.getIntValue(request.getParameter("browserType"),1);	//1.多选  2.单选
	int selectType = Util.getIntValue(request.getParameter("selectType"),1);	//1.选部门  2.分部
	String showType = "2";//2.组织架构
	String showTypeName = "选择部门";
	if(selectType==2){
		showTypeName = "选择分部";
	}
	String showTypeClassName = "org";
	
	JSONArray selectedArr = new JSONArray();
	if(!selectedIds.trim().equals("")){
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo sci = new SubCompanyComInfo();
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				String name = "";
				if(selectType==1){
					name = departmentComInfo.getDepartmentname(selectedId);//名称
				}else{
					name = sci.getSubCompanyname(selectedId);
				}
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));//名称
				selectedArr.add(selectedObj);
			}
		}
	}
	CompanyComInfo companyComInfo = new CompanyComInfo();
	String companyname = FormatMultiLang.formatByUserid(companyComInfo.getCompanyname("1"),user.getUID()+"");	//公司名称
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">

<script type="text/javascript">
var _browserType = "<%=browserType%>";
var _selectType = "<%=selectType%>";
var _selected_arr = <%=selectedArr%>;
var _fieldId = "<%=fieldId%>";
var _fieldSpanId = "<%=fieldSpanId%>";
var showTypeName = "<%=showTypeName%>";
var _callbackOk = "onDepartBrowserOk";
var _callbackBack = "onDepartBrowserBack";
</script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/zepto.min_wev8.js?2"></script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/fastclick.min_wev8.js?2"></script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/jquery.sortable.min.js?2"></script>
<link type="text/css" rel="stylesheet" href="/mobile/plugin/plus/browser/css/departBrowser_wev8.css" />
<script type="text/javascript">
var ifInit = false;
function resetBrowser(obj){
	_fieldId = obj["fieldId"] || "";
	_fieldSpanId = obj["fieldSpanId"] || "";
	_browserType = obj["browserType"] || "1";
	_selectType = obj["selectType"] || "1";
	showTypeName = "选择部门";
    if(_selectType==2){
        showTypeName = "选择分部";        
    }
    $(".header-center").html(showTypeName);
	_callbackOk = obj["callbackOk"]||"onDepartBrowserOk";
	_callbackBack = obj["callbackBack"]||"onDepartBrowserBack";
	var selectedIds = obj["selectedIds"] || "";
	
	clearSelectedArr();	//清空已选
	delCheckedAllOnPage();	//清空页面已选
	refreshSelectedNum();	//刷新已选个数
	$("#page-center").removeClass("selected-result-open");	//控制不让结果页面显示
	if($(".company-data").next("ul").length>0){
		$(".company-data").next("ul").remove();
	}
	ifInit = false;
	$(".company-data").removeClass("opened");
	$(".company-data").addClass("closed");
	$(".company-data").click();//触发顶级分部展示
	//异步加载已选
	if(selectedIds != ""){
		var $treeLoading = $("<div class=\"tree-loading\"></div>");
		$treeLoading.insertAfter($(".company-data"));
		$.ajax({
			url:"/mobile/plugin/plus/browser/departBrowserAction.jsp",
			data:{"action":"getSelectedDatas","selectedIds":selectedIds,"selectType":_selectType},
			dataType:"json",
			success:function(data){
				if(data.status == 0){
					var datas = data.datas;
					for(var i = 0; i < datas.length; i++){
						var selectedData = datas[i];
						checkedOnPage(selectedData.id);
						addInSelectedArr(selectedData);
					}
					refreshSelectedNum();
				}else{
					alert(data.msg);
				}
			},
			complete:function(){
				$treeLoading.remove();
			}
		});
	}
}
$(document).ready(function(){
	refreshSelectedNum();

	$(".one-tree-data[data-haschild='1']").live("click",function(){
		if(ifInit&&$(this).hasClass("company-data")){
			return;
		}
		if($(this).hasClass("company-data")){
			ifInit = true;
		}
		var expanding = $(this).attr("expanding");
		if(expanding == "1"){
			return;
		}
		$(this).attr("expanding", "1");
		var $treePage = $(this).siblings(".tree-page");
		if($(this).hasClass("closed")){
			$(this).removeClass("closed");
			$(this).addClass("opened");
			if($treePage.length > 0){
				$treePage.show();
			}else{
				//从服务端加载
				var $treeLoading = $("<div class=\"tree-loading\"></div>");
				$treeLoading.insertAfter($(this));
				var dataType = $(this).attr("data-type");
				var dataId = $(this).attr("data-id");
				var oneTreeData = $(this);
				$.ajax({
					url:"/mobile/plugin/plus/browser/departBrowserAction.jsp",
					data:{"action":"getTreeData","type":dataType,"pid":dataId,"selectType":_selectType},
					dataType:"json",
					success:function(data){
						if(data.status == 0){
							getHtml(data.datas,oneTreeData);
						}else{
							alert(data.msg);
						}
					},
					complete:function(){
						$treeLoading.remove();
					}
				});
			}
		}else if($(this).hasClass("opened")){
			$treePage.hide();
			$(this).removeClass("opened");
			$(this).addClass("closed");
		}
		$(this).removeAttr("expanding");
	});
	$(".checkLi").live("click",function(e){
		//增加点击的时候判断当前节点是否有下级 有下级做展开动作不触发勾选动作
		var target=e.target;
		var checkdiv = $(this).find(".checkdiv").first();
		var checkdiv_id = checkdiv.attr("id");
		if($(this).find(".one-tree-data[data-haschild='1']").length>0&&$(target).attr("id")!=checkdiv_id){
			return;
		}
		var data = $.parseJSON($(this).attr("data"));
		if(_browserType == "2"){//单选
			delCheckedAllOnPage();
			checkdiv.addClass("checked").removeClass("unchecked");
			clearSelectedArr();
			addInSelectedArr(data);
		}else{//多选
			if(checkdiv.hasClass("checked")){
				checkdiv.removeClass("checked").addClass("unchecked");
				removeFromSelectedArr(data.id);
			}else{
				checkdiv.addClass("checked").removeClass("unchecked");
				addInSelectedArr(data);
			}
		}
		refreshSelectedNum();
	});
	$("#choosedResult").click(function(){
		buildSelectedResultPage();
		initSelectedResultPageEvt();
		$("#page-center").addClass("selected-result-open");
	});
	$("#okResult").click(doRightMenuConfig);
	$("#backResult").click(doLeftMenuConfig);
	$("#nav-header .header-left").click(doLeftMenuConfig);
	$("#nav-header .header-right").click(doRightMenuConfig);
	$("#clearResult").click(function(e){
		//删除数据
		clearSelectedArr();
		//刷新底部选中个数
		refreshSelectedNum();
		//取消页面数据的选中状态
		delCheckedAllOnPage();
		//页面上删除
		var $oneData = $("#result-data .one-data");
		$oneData.addClass("deleted");
		setTimeout(function(){
			$oneData.remove();
		},500);
	});
});
function getHtml(datas, $obj){
	var $treePage = $("<ul class=\"tree-page\"></ul>");
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//id
		var name = data["name"];	//名称
		var type = data["type"];	//类型
		var hasChild = data["hasChild"];	//是否有子节点
		var hasChildFlag = hasChild ? "1" : "0"; 
		var cssStr = hasChild ? "closed" : "";
		var $li = $("<li></li>");
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "unchecked" : "checked";
		if((_selectType==1&&type==3)||(_selectType==2&&type==2)){
			$li.addClass("checkLi");
			$li.append("<div id='checkdiv_"+id+"' onclick='' class='checkdiv "+checkedStr+"'></div>");
			cssStr = cssStr+" hasChildChkDiv";
		}
		$li.append("<div class=\"one-tree-data "+cssStr+"\" onclick='' data-id=\""+id+"\" data-type=\""+type+"\" data-haschild=\""+hasChildFlag+"\">"+name+"</div>");
		$li.attr("data", JSON.stringify(data));
		$treePage.append($li);
	}
	$treePage.insertAfter($obj);
}
function indexOfSelectedArr(id){
	var index = -1;
	for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		if(selectedData["id"] == id){
			index = i;
			break;
		}
	}
	return index;
}
function addInSelectedArr(data){
	if(indexOfSelectedArr(data.id) == -1){
		_selected_arr.push(data);
	}
}
function removeFromSelectedArr(id){
	var index = indexOfSelectedArr(id);
	if(index != -1){
		_selected_arr.splice(index, 1);
	}	
}
function updateSelectedArrSort(){
	var _new_selected_arr = new Array();
	$("#result-data li.one-data").each(function(){
		var hrmId = $(this).attr("hrmId");
		var index = indexOfSelectedArr(hrmId);
		if(index != -1){
			var data = _selected_arr[index];
			_new_selected_arr.push(data);
		}
	});
	
	if(_new_selected_arr.length == _selected_arr.length){
		_selected_arr = _new_selected_arr;
	}
}
function clearSelectedArr(){
	_selected_arr = [];
}
function checkedOnPage(id){
	$("#checkdiv_"+id).addClass("checked").removeClass("unchecked");
}
function delCheckedOnPage(id){
	$("#checkdiv_"+id).addClass("unchecked").removeClass("checked");
}
function delCheckedAllOnPage(){
	$(".checkdiv").removeClass("checked").addClass("unchecked");
}
function refreshSelectedNum(){
	$("#selectedNum").html(_selected_arr.length);
}

function buildSelectedResultPage(){
	var $resultData = $("#result-data");
	$resultData.children("ul").remove();
	var $dataUL = $("<ul></ul>");
	$resultData.append($dataUL);
	for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		var id = selectedData["id"];//人员id
		var lastname = selectedData["name"];	//姓名
		$dataUL.append("<li class=\"one-data\" hrmId=\""+id+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-lastname\">"+lastname+"</div>"+
								"<div class=\"data-move\"></div>"+
							"</div>"+
							"<div class=\"delete-data\" hrmId=\""+id+"\">删除</div>"+
						"</li>");
	}
}
function initSelectedResultPageEvt(){
	var $resultData = $("#result-data");
	
	$(".data-delete", $resultData).click(function(e){
		$(this).parent().parent().addClass("beDelete");
		e.stopPropagation();
	});
	$("li.one-data", $resultData).click(function(e){
		if($(this).hasClass("beDelete")){
			$(this).removeClass("beDelete");
			e.stopPropagation();
		}
	});	
	$(".delete-data", $resultData).click(function(e){
		//删除数据
		var hrmId = $(this).attr("hrmId");
		removeFromSelectedArr(hrmId);
		//刷新底部选中个数
		refreshSelectedNum();
		//取消页面数据的选中状态
		delCheckedOnPage(hrmId);
		//页面上删除
		var $oneData = $(this).parent();
		$oneData.addClass("deleted");
		setTimeout(function(){
			$oneData.remove();
		},500);
		e.stopPropagation();
	});
	
	new Sortable($("ul", $resultData)[0], {
		animation: 150,
		handle: ".data-move",
		draggable: ".one-data",
		onUpdate: function (evt){
			var item = evt.item;
			updateSelectedArrSort();
		}
	});
}

function doLeftMenuConfig(){
	var $pageCenter = $("#page-center");
	if($pageCenter.hasClass("selected-result-open")){
		$pageCenter.removeClass("selected-result-open");	
	}else{
		try{
			var browserWin = parent._BrowserWindow;
			if(browserWin){
				//browserWin.onDepartBrowserBack();
				eval('browserWin.'+_callbackBack+'()');
			}else{
				eval('parent.'+_callbackBack+'()');
			}
		}catch(e){
			
		}
	}
}
function doRightMenuConfig(){
	var idValue = "";
	var nameValue = "";
    for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		idValue += selectedData["id"] + ",";
		nameValue += selectedData["name"] + ",";
	}
	if(idValue != ""){
		idValue = idValue.substring(0, idValue.length-1);
	}
	if(nameValue != ""){
		nameValue = nameValue.substring(0, nameValue.length-1);
	}
	var result = {
		"fieldId" : _fieldId,
		"fieldSpanId" : _fieldSpanId,
		"idValue" : idValue,
		"nameValue" : nameValue
	};
	//alert(result.idValue+"--"+result.nameValue);
	try{
		var browserWin = parent._BrowserWindow;
		if(browserWin){
			//browserWin.onDepartBrowserBack();
			eval('browserWin.'+_callbackOk+'(result)');
		}else{
			eval('parent.'+_callbackOk+'(result)');
		}
	}catch(e){
		
	}
	
	return "1";
}
</script>
</head>
<body class="_emobile">
<div id="page">
	<div id="page-title">
		<div id="nav-header">
			<div class="header-left"></div>
			<div class="header-center"><%=showTypeName%></div>
			<div class="header-right"></div>
		</div>
	</div>
	<div id="page-center">
		<div id="center-content" class="<%=showTypeClassName%>">
			<div id="center-content-inner">
				<div id="tree-org-container" class="data-container org-container">
					<ul class="tree-page root-tree-page">
						<li>
							<div class="one-tree-data company-data closed" data-id="1" data-type="1" data-haschild="1"><%=companyname%></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
		<div id="center-footer">
			<div id="choosedResult">
				已选(<span id="selectedNum">0</span>)
			</div>
			
			<div id="okResult">
				确&nbsp;定
			</div>
		</div>
		<div id="selected-result-page">
			<div id="result-center">
				<div id="result-center-inner">
					<div id="result-hrm-container">
						<div id="result-hrm-content">
							<div id="result-data"></div>
						</div>
					</div>
				</div>
			</div>
			<div id="result-footer">
				<div id="backResult">
					返&nbsp;回
				</div>
				<div id="clearResult">
					清&nbsp;空
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%
	//�жϱ���
	if(WxInterfaceInit.isIsutf8()){
		response.setContentType("text/html;charset=UTF-8");
	}
	String fieldId = Util.null2String(request.getParameter("fieldId"));	//�ֶ�id
	String fieldSpanId = Util.null2String(request.getParameter("fieldSpanId"));	//�ֶ���ʾ����id
	String selectedIds = Util.null2String(request.getParameter("selectedIds"));	//ѡ�е�id�����ŷָ����磺1,2,3
	String setting = Util.null2String(request.getParameter("setting"));	//ģ��������ѡ�������ID
	String listtypes = Util.null2String(request.getParameter("listtypes"));	//�������������ǵ����ͼ���
	int browserType = Util.getIntValue(request.getParameter("browserType"),1);	//1.��ѡ  2.��ѡ
	String showTypeClassName = "org";
	
	JSONArray selectedArr = new JSONArray();
	if(!selectedIds.trim().equals("")){
		RecordSet rs = new RecordSet();
		rs.executeSql("select id,workflowname from workflow_base where id in ("+selectedIds+") order by workflowname");
		while(rs.next()){
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", rs.getString("id"));	//id
			selectedObj.put("name", rs.getString("workflowname"));//����
			selectedArr.add(selectedObj);
		}
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">

<script type="text/javascript">
var _browserType = "<%=browserType%>";
var _selected_arr = <%=selectedArr%>;
var _fieldId = "<%=fieldId%>";
var _fieldSpanId = "<%=fieldSpanId%>";
var _setting = "<%=setting%>";
var _listtypes = "<%=listtypes%>";
var _callbackOk = "onWFOk";
var _callbackBack = "onWFBack";
var _operatetype = "0";
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
	_setting = obj["setting"] || "";
	_listtypes = obj["listtypes"] || "";
	_callbackOk = obj["callbackOk"]||"onWFOk";
	_callbackBack = obj["callbackBack"]||"onWFBack";
	_operatetype = obj["operatetype"] || "0";
	var selectedIds = obj["selectedIds"] || "";
	
	clearSelectedArr();	//�����ѡ
	delCheckedAllOnPage();	//���ҳ����ѡ
	refreshSelectedNum();	//ˢ����ѡ����
	$("#page-center").removeClass("selected-result-open");	//���Ʋ��ý��ҳ����ʾ
	if($(".company-data").next("ul").length>0){
		$(".company-data").next("ul").remove();
	}
	ifInit = false;
	$(".company-data").removeClass("opened");
	$(".company-data").addClass("closed");
	$(".company-data").click();//���������ֲ�չʾ
	//�첽������ѡ
	if(selectedIds != ""){
		var $treeLoading = $("<div class=\"tree-loading\"></div>");
		$treeLoading.insertAfter($(".company-data"));
		$.ajax({
			url:"/mobile/plugin/plus/browser/wfBrowserAction.jsp",
			data:{"action":"getSelectedDatas","selectedIds":selectedIds},
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
				//�ӷ���˼���
				var $treeLoading = $("<div class=\"tree-loading\"></div>");
				$treeLoading.insertAfter($(this));
				var dataType = $(this).attr("data-type");
				var dataId = $(this).attr("data-id");
				var oneTreeData = $(this);
				$.ajax({
					url:"/mobile/plugin/plus/browser/wfBrowserAction.jsp",
					data:{"action":"getTreeData","type":dataType,"pid":dataId,"setting":_setting,"listtypes":_listtypes},
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
		//���ӵ����ʱ���жϵ�ǰ�ڵ��Ƿ����¼� ���¼���չ��������������ѡ����
		var target=e.target;
		var checkdiv = $(this).find(".checkdiv").first();
		var checkdiv_id = checkdiv.attr("id");
		if($(this).find(".one-tree-data[data-haschild='1']").length>0&&$(target).attr("id")!=checkdiv_id){
			return;
		}
		var data = $.parseJSON($(this).attr("data"));
		if(_browserType == "2"){//��ѡ
			delCheckedAllOnPage();
			checkdiv.addClass("checked").removeClass("unchecked");
			clearSelectedArr();
			addInSelectedArr(data);
		}else{//��ѡ
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
		//ɾ������
		clearSelectedArr();
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		delCheckedAllOnPage();
		//ҳ����ɾ��
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
		var name = data["name"];	//����
		var type = data["type"];	//����
		var hasChild = data["hasChild"];	//�Ƿ����ӽڵ�
		var hasChildFlag = hasChild ? "1" : "0"; 
		var cssStr = hasChild ? "closed" : "";
		var $li = $("<li></li>");
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "unchecked" : "checked";
		if(type==3){
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
		var id = selectedData["id"];//��Աid
		var lastname = selectedData["name"];	//����
		$dataUL.append("<li class=\"one-data\" hrmId=\""+id+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-lastname\">"+lastname+"</div>"+
								"<div class=\"data-move\"></div>"+
							"</div>"+
							"<div class=\"delete-data\" hrmId=\""+id+"\">ɾ��</div>"+
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
		//ɾ������
		var hrmId = $(this).attr("hrmId");
		removeFromSelectedArr(hrmId);
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		delCheckedOnPage(hrmId);
		//ҳ����ɾ��
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
		"nameValue" : nameValue,
		"operatetype":_operatetype
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
			<div class="header-center">������</div>
			<div class="header-right"></div>
		</div>
	</div>
	<div id="page-center">
		<div id="center-content" class="<%=showTypeClassName%>">
			<div id="center-content-inner">
				<div id="tree-org-container" class="data-container org-container">
					<ul class="tree-page root-tree-page">
						<li>
							<div class="one-tree-data company-data closed" data-id="1" data-type="1" data-haschild="1">��������</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
		<div id="center-footer">
			<div id="choosedResult">
				��ѡ(<span id="selectedNum">0</span>)
			</div>
			
			<div id="okResult">
				ȷ&nbsp;��
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
					��&nbsp;��
				</div>
				<div id="clearResult">
					��&nbsp;��
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
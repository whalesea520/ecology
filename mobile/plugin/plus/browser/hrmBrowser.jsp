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
<%@ page import="weaver.wxinterface.WxModuleInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="weaver.file.Prop" %>
<%
	if(user.getLanguage()==8){
		request.getRequestDispatcher("/mobile/plugin/plus/browser/hrmBrowser_en.jsp?"+request.getQueryString()).forward(request, response);
		return;
	}
	//�����ճ̵�ѡ��ҳ��ǿ��ʹ��UTF-8��ʽ���� zhw 20160426����
	int ifutf8 = Util.getIntValue(request.getParameter("ifutf8"),0);
	//�жϱ���
	if(WxInterfaceInit.isIsutf8()){
		response.setContentType("text/html;charset=UTF-8");
	}
	boolean isNoHeader = Util.null2String((String)request.getParameter("noHeader")).equals("1");	//�Ƿ񲻰���ͷ��
	String fieldId = Util.null2String((String)request.getParameter("fieldId"));	//�ֶ�id
	String fieldSpanId = Util.null2String((String)request.getParameter("fieldSpanId"));	//�ֶ���ʾ����id
	String selectedIds = Util.null2String((String)request.getParameter("selectedIds"));	//ѡ�е�id�����ŷָ����磺1,2,3
	String browserType = Util.null2String((String)request.getParameter("browserType"));	//1.��ѡ  2.��ѡ
	if("".equals(browserType)) browserType = "1";
	String showType = Util.null2String((String)request.getParameter("showType"));	//1.������ ��2.��֯�ܹ���3�������� 4�����ϵ��,5ͬ����
	if("".equals(showType)) {
		if(WxModuleInit.ifLastContract){
			showType = "4";
		}else{
			showType = "1";
		}
	}
	String showTypeName = "������";
	String showTypeClassName = "hrm";
	if(showType.equals("1")){
		showTypeName = "������";
		showTypeClassName = "hrm";
	}else if(showType.equals("2")){
		showTypeName = "��֯�ܹ�";
		showTypeClassName = "org";
	}else if(showType.equals("3")){
		showTypeName = "������";
		showTypeClassName = "group";
	}else if(showType.equals("4")){
		showTypeName = "������";
		showTypeClassName = "lasthrm";
	}else if(showType.equals("5")){
		showTypeName = "ͬ����";
		showTypeClassName = "dept";
	}
	
	JSONArray selectedArr = new JSONArray();
	if(!selectedIds.trim().equals("")){
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				
				String lastname = resourceComInfo.getLastname(selectedId);	//����
				String subCompanyID = resourceComInfo.getSubCompanyID(selectedId);	//�ֲ�id
				String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//�ֲ�����
				
				String departmentID = resourceComInfo.getDepartmentID(selectedId);	//����id
				String departmentName = departmentComInfo.getDepartmentname(departmentID);	//��������
				
				String jobTitle = resourceComInfo.getJobTitle(selectedId);	//��λid
				String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//��λ����
				
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("lastname", FormatMultiLang.formatByUserid(lastname,user.getUID()+""));	//����
				selectedObj.put("subCompanyName", FormatMultiLang.formatByUserid(subCompanyName,user.getUID()+""));	//�ֲ�����
				selectedObj.put("departmentName", FormatMultiLang.formatByUserid(departmentName,user.getUID()+""));	//��������
				selectedObj.put("jobTitlesName", FormatMultiLang.formatByUserid(jobTitlesName,user.getUID()+""));	//��λ����
				selectedArr.add(selectedObj);
			}
		}
	}
	
	CompanyComInfo companyComInfo = new CompanyComInfo();
	String companyname = FormatMultiLang.formatByUserid(companyComInfo.getCompanyname("1"),user.getUID()+"");	//��˾����
	
	//�𺣻����������ο��� ������֯�ṹѡ�� zhw 20161222
	int ifShowDept = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifshowdept"),1);//1��ʾ 0����ʾ
	//Bվ ֻ��ʾ������
	int ifOnlyShowAllUser = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifOnlyShowAllUser"),0);//0��ʾȫ�� 1ֻ��ʾ������
	int ifBsite = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifBsite"),0);//�Ƿ���Bվ�ͻ�
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
var _ifOnlyShowAllUser = "<%=ifOnlyShowAllUser%>";
var _ifBsite = "<%=ifBsite%>";

var showTypeName = "<%=showTypeName%>";
var _showSubUser = "0";//�Ƿ�ֻ��ʾ���� 0�� 1��
var _showDept = "0";//�Ƿ�ֻ��ʾͬ����
var _deptids = "";//ֻ��ʾ��Щ���ŵ���Ա
var _issubcompany = "0";//0��ʾȫ��,1ֻ��ʾ���ֲ���
var oldShowSubUser = _showSubUser;
var oldShowDept = _showDept;
var oldIssubcompany = _issubcompany;
//20180212 zhw �й������ͻ�ת�����ѡ�˷�Χ����
var _towernodeid = "";
var oldTowernodeid = "";
var _toweroperatetype = "";
var _isRunInEmobile = (top && typeof(top.isRunInEmobile) == "function") ? top.isRunInEmobile() : false;
var _callbackOk = "onBrowserOk";
var _callbackBack = "onBrowserBack";
</script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/zepto.min_wev8.js?2"></script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/fastclick.min_wev8.js?2"></script>
<script type="text/javascript" src="/mobile/plugin/plus/browser/js/jquery.sortable.min.js?2"></script>
<link type="text/css" rel="stylesheet" href="/mobile/plugin/plus/browser/css/hrmBrowser_wev8.css?9" />
<script type="text/javascript">
$.fn.cssCheckBox = function () {
	if(_browserType == "2"){	//��ѡ
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
				deCheckedAllOnPage();
				
				var $valueHolder = $(".valueHolder", this);
				var hrm_data = $.parseJSON($valueHolder.attr("hrm_data"));
				var id = hrm_data["id"];
				
				checkedOnPage(id);
					
				clearSelectedArr();
				addInSelectedArr(hrm_data);
				refreshSelectedNum();
			});
		});
	}else{	//��ѡ
		$(".valueHolder", $(this)).each(function () {
			if (this.checked) {
				$(this).parent().addClass("checked");
			}
			
			$(this).parent().unbind("click");
			$(this).parent().click(function(){
				var $valueHolder = $(".valueHolder", this);
				
				var hrm_data = $.parseJSON($valueHolder.attr("hrm_data"));
				var id = hrm_data["id"];
				if($(this).hasClass("checked")){
					deCheckedOnPage(id);
					removeFromSelectedArr(hrm_data);
			    }else{
			    	checkedOnPage(id);
					addInSelectedArr(hrm_data);
			    }
			    
			    refreshSelectedNum();
			});
		});
	}
};



function resetBrowser(obj){
	_fieldId = obj["fieldId"] || "";
	_fieldSpanId = obj["fieldSpanId"] || "";
	_browserType = obj["browserType"] || "1";
	_showSubUser = obj["showSubUser"] ||"0";
	_showDept = obj["showDept"] ||"0";
	_deptids = obj["deptids"] ||"";
	_issubcompany = obj["issubcompany"] ||"0";
	_towernodeid = obj["towernodeid"]||"";
	_toweroperatetype = obj["toweroperatetype"]||"";
	_callbackOk = obj["callbackOk"]||"onBrowserOk";
	_callbackBack = obj["callbackBack"]||"onBrowserBack";
	var selectedIds = obj["selectedIds"] || "";
	if(_showSubUser!=oldShowSubUser){
		oldShowSubUser = _showSubUser;
		searchListData();
	}
	if(_issubcompany!=oldIssubcompany){
		oldIssubcompany = _issubcompany;
		searchListData();
	}
	if(_deptids!=""){
		searchListData();
	}
	if(_towernodeid!=""||_towernodeid!=oldTowernodeid){
		oldTowernodeid = _towernodeid;
		searchListData();
	}
	//��ʾ���� ���ֲ� ������ ���ݲ���ID��ѯ
	if(_showSubUser==1||_issubcompany==1||_showDept==1||_deptids!=""||_ifOnlyShowAllUser==1||_towernodeid!=""){
		$("#page-control").hide();
		$("#control-lasthrm").hide();
		$("#control-hrm").hide();
		$("#control-dept").hide();
		$("#control-org").hide();
		$("#control-group").hide();
		if(_showSubUser==1||_issubcompany==1||_deptids!=""||_ifOnlyShowAllUser==1||_towernodeid!=""){
			if(_showSubUser==1){
				$("#nav-header .header-center").html("�ҵ�����");
			}else if(_issubcompany==1){
				$("#nav-header .header-center").html("���ֲ�");
			}else if(_deptids!=""||_ifOnlyShowAllUser==1||_towernodeid!=""){
				$("#nav-header .header-center").html("������");
			}
			if(!$("#center-content").hasClass("hrm")){
				$("#center-content")[0].className="hrm";
			}
			if(!$("#page-control").hasClass("hrm")){
				$("#page-control")[0].className="hrm";
				if(_showSubUser==1||_deptids!=""||_ifOnlyShowAllUser==1||_towernodeid!=""){
					$(".control-text",$("#page-control")).html("������");
					showTypeName = "������";
				}else{
					$(".control-text",$("#page-control")).html("���ֲ�");
				}
			}
		}else{
			$("#nav-header .header-center").html("ͬ����");
			if(!$("#center-content").hasClass("dept")){
				$("#center-content")[0].className="dept";
			}
		}
	}else{
		$("#page-control").show();
		$("#control-lasthrm").show();
		$("#control-dept").show();
		$("#control-hrm").show();
		$("#control-org").show();
		$("#control-group").show();
		$("#nav-header .header-center").html(showTypeName);
	}
	$("#list-hrm-content > .group-wrap").hide();
	setTimeout(function(){
		$("#list-hrm-content > .group-wrap").show();
	}, 0);
	
	clearSelectedArr();	//�����ѡ
	deCheckedAllOnPage();	//���ҳ����ѡ
	refreshSelectedNum();	//ˢ����ѡ����
	$(document.body).cssCheckBox();	//���½����¼���
	$("#page-center").removeClass("selected-result-open");	//���Ʋ��ý��ҳ����ʾ
	
	//�첽������ѡ
	if(selectedIds != ""){
		var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getSelectedDatas&selectedIds=" + selectedIds;
		//window.prompt("",url);
		$.get(url, null, function(responseText){
			var data;
			if($.isPlainObject(responseText)){
				data = responseText;
			}else{
				data = $.parseJSON(responseText);
			}
			var status = data["status"];
			if(status == "1"){
				var datas = data["datas"];
				for(var i = 0; i < datas.length; i++){
					var selectedData = datas[i];
					checkedOnPage(selectedData.id);
					addInSelectedArr(selectedData);
				}
				refreshSelectedNum();
			}
		});
	}
}
	
$(document).ready(function(){
	FastClick.attach(document.body);
	
	if(_isRunInEmobile){
		$(document.body).addClass("_emobile");
	}
	
	refreshSelectedNum();
	
	<%if(WxModuleInit.ifLastContract){%>
	//��ʼ��������ϵ��
	initLastHrm();
	<%} %>
	//��ʼ��ͬ����
	initDept();
	
	initSearch();
	
	initPageControl();
	
	initHeader();
	
	searchListData();
	
	initGroupData();
	
	$("#list-loadMore").click(function(){
		var $this = $(this);
		$this.addClass("click");
		setTimeout(function(){
			$this.removeClass("click");
			searchListDataMore();
		},300);
	});
	
	var $rootTreePage = $("#tree-org-container .root-tree-page");
	bindTreeEvt($rootTreePage);
	var $rootTreeData = $rootTreePage.children("li").children(".one-tree-data");
	$rootTreeData.trigger("click");
	
	$("#result-hrm-content").click(function(e){
		$("li.beDelete", this).removeClass("beDelete");
	});	
	$("#clearResult").click(function(e){
		//ɾ������
		clearSelectedArr();
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		deCheckedAllOnPage();
		
		//ҳ����ɾ��
		var $oneData = $("#result-data .one-data");
		$oneData.addClass("deleted");
		setTimeout(function(){
			$oneData.remove();
		},500);
	});
	
	initSelectedResultSearch();
});

var prevSearchKey = "";
function initSearch(){
	var $searchKey = $("#search-key");
	var $srarchInner = $("#list-hrm-srarch .srarch-inner");
	$(".search-holder", $srarchInner).click(function(){
		searchListData();
	});
	/*
	$searchKey.blur(function(){
		if(this.value == ""){
			$srarchInner.removeClass("searching");
		}
	}); 
	
	$searchKey.bind("input", function(){
		var currSearchKey = this.value;
		if(currSearchKey != prevSearchKey){
			prevSearchKey = currSearchKey;
			searchListData();
		}
		
	});*/
}

function clearSearch(){
	var $searchKey = $("#search-key");
	var v = $searchKey.val();
	if(v != ""){
		$searchKey.val("");
		$searchKey.trigger("blur");
		$searchKey.trigger("input");
	}
	
}

function initGroupData(){
	var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getGroupData";
	$.get(url,null, function(responseText){
		var data;
		if($.isPlainObject(responseText)){
			data = responseText;
		}else{
			data = $.parseJSON(responseText);
		}
		var status = data["status"];
		if(status == "1"){
			var datas = data["datas"];
			var temp = "";
			if(datas.length>0){
				for(var i = 0; i < datas.length; i++){
					var data = datas[i];
					var id = data["id"];
					var name = data["name"];
					temp+="<div class='group'><div class='group-title2 closed' groupid='"+id+"'>"+name+"</div></div>";
				}
			}else{
				temp="<div style='width:100%;height:30px;line-height:30px;font-weight: bold;text-align:center;color:#999;margin-top:10px;'>������س���������</div>";
			}
			$("#group_group_wrap").html(temp);
			bindGroupEvt();
		}else{
			var errMsg = data["errMsg"];
			$("#list-group-content > .group-wrap").append("��������ʱ���ִ���" + errMsg);
		}
	});
}

function bindGroupEvt(){
	$(".group-title2", $("#group_group_wrap")).click(function(){
		var ul = $(this).parent().find(".group-data");
		if($(this).hasClass("closed")){
			$(this).removeClass("closed");
			$(this).addClass("opened");
			if(ul.length>0){
				ul.show();
			}else{
				var obj = $(this);
				var groupid = $(this).attr("groupid");
				var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getGroupMembers";
				$.get(url,{"groupid":groupid}, function(responseText){
					var data;
					if($.isPlainObject(responseText)){
						data = responseText;
					}else{
						data = $.parseJSON(responseText);
					}
					var status = data["status"];
					if(status == "1"){
						var datas = data["datas"];
						var $ul = $("<ul class=\"group-data muti\"></ul>");
						for(var i = 0; i < datas.length; i++){
							var data = datas[i];
							var id = data["id"];	//��Աid
							var lastname = data["lastname"];	//����
							var departmentName = data["departmentName"];	//��������
							var jobTitlesName = data["jobTitlesName"];	//��λ����
							var subCompanyName = data["subCompanyName"]	//�ֲ�����
							var messagerurl = data["messagerurl"]	//ͷ��
							var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
							var $li =$("<li class=\"one-data\"></li>");
							$li.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
											"<div class=\"data-inner\">"+
												"<div class=\"data-avatar\">"+
													"<div>"+(messagerurl!=""?"<img src=\""+messagerurl+"\" style=\"width:100%;height:100%;\" />":"")+"</div>"+
												"</div>"+
												"<div class=\"data-part1\">"+
													"<div class=\"data-lastname\">"+lastname+"</div>"+
													"<div class=\"data-subCompany\">"+subCompanyName+"</div>"+
												"</div>"+
												"<div class=\"data-part2\">"+
													"<div class=\"data-jobTitle\">"+jobTitlesName+"</div>"+
													"<div class=\"data-department\">"+departmentName+"</div>"+
												"</div>"+
											"</div>");
							$ul.append($li);
							$(".valueHolder", $li).attr("hrm_data", JSON.stringify(data));
							$li.cssCheckBox();
						}
						obj.after($ul);
					}else{
						var errMsg = data["errMsg"];
						obj.append("��������ʱ���ִ���" + errMsg);
					}
				});
			}
		}else{
			$(this).removeClass("opened");
			$(this).addClass("closed");
			if(ul.length>0){
				ul.hide();
			}
		}
	});
}

var currPgNo = 1;
var pageSize = 50;
var pageCount = 0;

function doSearch(){
	$("#list-loadMore").hide();
	$("#list-loading").show();
	var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getListData&pageNo="+currPgNo;
	var $searchKey = $("#search-key");
	var searchKey = encodeURIComponent($searchKey.val());
	//var searchKey = $searchKey.val();
	$.get(url, {"searchKey":searchKey, "pageSize":pageSize,"showSubUser":_showSubUser,"issubcompany":_issubcompany,"deptids":_deptids,"towernodeid":_towernodeid,"toweroperatetype":_toweroperatetype}, 
			function(responseText){
		$("#list-loading").hide();
		var data;
		if($.isPlainObject(responseText)){
			data = responseText;
		}else{
			data = $.parseJSON(responseText);
		}
		var status = data["status"];
		if(status == "1"){
			var totalRecordCount = data["totalSize"];
			var datas = data["datas"];
			fillListDatasToPage(datas,0);
			pageCount = (totalRecordCount % pageSize) == 0 ? parseInt(totalRecordCount / pageSize) : (parseInt(totalRecordCount / pageSize) + 1);
			if(currPgNo >= pageCount){
				$("#list-loadMore").hide();
			}else{
				$("#list-loadMore").show();
			}
		}else{
			var errMsg = data["errMsg"];
			$("#list-hrm-content > .group-wrap").append("��������ʱ���ִ���" + errMsg);
		}
	});
}


function initLastHrm(){
	var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp";
	$.get(url,{"action":"getLastHrmData"}, function(responseText){
		$("#list-loading").hide();
		var data;
		if($.isPlainObject(responseText)){
			data = responseText;
		}else{
			data = $.parseJSON(responseText);
		}
		var status = data["status"];
		if(status == "1"){
			var datas = data["datas"];
			if(datas.length>0){
				fillListDatasToPage(datas,1);
			}else{
				$("#list-lasthrm-content > .group-wrap").append("<div style='width:100%;height:30px;line-height:30px;font-weight: bold;text-align:center;color:#999;margin-top:10px;'>������س���������</div>");
				$("#control-hrm").click();
			}
		}else{
			var errMsg = data["errMsg"];
			$("#list-lasthrm-content > .group-wrap").append("��������ʱ���ִ���" + errMsg);
		}
	});
}

function initDept(){
	var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp";
	$.get(url,{"action":"getDeptData"}, function(responseText){
		$("#list-loading").hide();
		var data;
		if($.isPlainObject(responseText)){
			data = responseText;
		}else{
			data = $.parseJSON(responseText);
		}
		var status = data["status"];
		if(status == "1"){
			var datas = data["datas"];
			fillListDatasToPage(datas,2);
		}else{
			var errMsg = data["errMsg"];
			$("#list-dept-content > .group-wrap").append("��������ʱ���ִ���" + errMsg);
		}
	});
}

function searchListData(){
	$("#list-hrm-content > .group-wrap").find("*").remove();
	currPgNo = 1;
	doSearch();
}

function searchListDataMore(){
	currPgNo++;
	doSearch();
}

function fillListDatasToPage(datas,type){
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//��Աid
		var lastname = data["lastname"];	//����
		//var lastname_py = data["lastname_py"];	//ƴ��
		var departmentName = data["departmentName"];	//��������
		var jobTitlesName = data["jobTitlesName"];	//��λ����
		var subCompanyName = data["subCompanyName"]	//�ֲ�����
		var messagerurl = data["messagerurl"]	//ͷ��
		var field27 = data["field27"]	//ͷ��
		
		var $group = $("#list-hrm-content > .group-wrap > .group");
		if(type==1){
			$group = $("#list-lasthrm-content > .group-wrap > .group");
		}else if(type==2){
			$group = $("#list-dept-content > .group-wrap > .group");
		}
		if($group.length == 0){
			$group = $("<div class=\"group\"></div>");
			//$group.append("<div class=\"group-title\">"+lastname_py+"</div>");
			$group.append("<ul class=\"group-data muti\"></ul>");
			if(type==1){
				$("#list-lasthrm-content > .group-wrap").append($group);
			}else if(type==2){
				$("#list-dept-content > .group-wrap").append($group);
			}else{
				$("#list-hrm-content > .group-wrap").append($group);
			}
		}
		
		var $groupData = $group.children(".group-data");
		
		var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
		var $oneData = $("<li class=\"one-data\"></li>");
		if(_ifBsite==1){
			$oneData.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
					"<div class=\"data-inner\" style='height:55px;padding-left:43px;'>"+
						"<div class=\"data-avatar\">"+
							"<div>"+(messagerurl!=""?"<img src=\""+messagerurl+"\" style=\"width:100%;height:100%;\" />":"")+"</div>"+
						"</div>"+
						"<div class=\"data-part1\" style='width:100%;'>"+
							"<div class=\"data-lastname\" style='height:55px;line-height:55px;margin-top:0;'>"+lastname+"("+field27+")</div>"+
						"</div>"+
					"</div>");
		}else{
			$oneData.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
					"<div class=\"data-inner\">"+
						"<div class=\"data-avatar\">"+
							"<div>"+(messagerurl!=""?"<img src=\""+messagerurl+"\" style=\"width:100%;height:100%;\" />":"")+"</div>"+
						"</div>"+
						"<div class=\"data-part1\">"+
							"<div class=\"data-lastname\">"+lastname+"</div>"+
							"<div class=\"data-subCompany\">"+subCompanyName+"</div>"+
						"</div>"+
						"<div class=\"data-part2\">"+
							"<div class=\"data-jobTitle\">"+jobTitlesName+"</div>"+
							"<div class=\"data-department\">"+departmentName+"</div>"+
						"</div>"+
					"</div>");
		}
		$groupData.append($oneData);
		
		$(".valueHolder", $oneData).attr("hrm_data", JSON.stringify(data));
		
		$oneData.cssCheckBox();
	}
}

function initPageControl(){
	var $page = $("#page-center");
	var $centerContent = $("#center-content");
	var $pageControl = $("#page-control");
	
	$("#page-control").click(function(){
		if(_showSubUser!="1"){
			$page.toggleClass("control-open");
		}
	});
	
	$("#page-mask").click(function(){
		$page.removeClass("control-open");
	});
	
	$("#control-dept").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("dept")){
			$pageControl[0].className = "dept";
			showTypeName = "ͬ����";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("dept")){
			$centerContent[0].className = "dept";
		}
	});
	
	$("#control-hrm").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("hrm")){
			$pageControl[0].className = "hrm";
			showTypeName = "������";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("hrm")){
			$centerContent[0].className = "hrm";
		}
	});
	
	$("#control-lasthrm").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("lasthrm")){
			$pageControl[0].className = "lasthrm";
			showTypeName = "������";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("lasthrm")){
			$centerContent[0].className = "lasthrm";
		}
	});
	
	$("#control-org").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("org")){
			$pageControl[0].className = "org";
			showTypeName = "��֯�ܹ�";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("org")){
			$centerContent[0].className = "org";
		}
	});
	
	$("#control-group").click(function(){
		$page.removeClass("control-open");
		if(!$pageControl.hasClass("group")){
			$pageControl[0].className = "group";
			showTypeName = "������";
			$(".control-text", $pageControl).html(showTypeName);
			changeHeaderTitle();
		}
		
		if(!$centerContent.hasClass("group")){
			$centerContent[0].className = "group";
		}
	});
	
	$("#choosedResult").click(function(){
		resetSelectedResultSearch();
		buildSelectedResultPage();
		initSelectedResultPageEvt();
		$page.addClass("selected-result-open");
	});
}

function changeHeaderTitle(){
	$("#nav-header .header-center").html(showTypeName);
	try{
		if(typeof(top.changeMiddlePageName) == "function"){
			top.changeMiddlePageName();
		}
	}catch(e){
		
	}
}
function refreshSelectedNum(){
	$("#selectedNum").html(_selected_arr.length);
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

function removeFromSelectedArr(data){
	removeFromSelectedArrById(data.id);
}

function removeFromSelectedArrById(id){
	var index = indexOfSelectedArr(id);
	if(index != -1){
		_selected_arr.splice(index, 1);
	}	
}

function clearSelectedArr(){
	_selected_arr = [];
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

function checkedOnPage(id){
	var $valueHolder = $(".valueHolder[hrmId='"+id+"']");
	$valueHolder.attr("checked", "checked");
	$valueHolder.parent().addClass("checked");
}

function deCheckedOnPage(id){
	var $valueHolder = $(".valueHolder[hrmId='"+id+"']");
	$valueHolder.removeAttr("checked");
	$valueHolder.parent().removeClass("checked");
}

function deCheckedAllOnPage(){
	var $valueHolder = $(".valueHolder");
	$valueHolder.removeAttr("checked");
	$valueHolder.parent().removeClass("checked");
}

function initHeader(){
	$("#nav-header .header-left").click(doLeftMenuConfig);
	$("#nav-header .header-right").click(doRightMenuConfig);
	
	$("#backResult").click(doLeftMenuConfig);
	$("#okResult").click(doRightMenuConfig);
}
function buildSelectedResultPage(){
	var $resultData = $("#result-data");
	$resultData.children("ul").remove();
	var $dataUL = $("<ul></ul>");
	$resultData.append($dataUL);
	
	for(var i = 0; i < _selected_arr.length; i++){
		var selectedData = _selected_arr[i];
		var id = selectedData["id"];	//��Աid
		var lastname = selectedData["lastname"];	//����
		var departmentName = selectedData["departmentName"];	//��������
		var jobTitlesName = selectedData["jobTitlesName"];	//��λ����
		var subCompanyName = selectedData["subCompanyName"]	//�ֲ�����
		
		$dataUL.append("<li class=\"one-data\" hrmId=\""+id+"\">"+
							"<div class=\"data-inner\">"+
								"<div class=\"data-delete\"></div>"+
								"<div class=\"data-part1\">"+
									"<div class=\"data-lastname\">"+lastname+"</div>"+
									"<div class=\"data-subCompany\">"+subCompanyName+"</div>"+
								"</div>"+
								"<div class=\"data-part2\">"+
									"<div class=\"data-jobTitle\">"+jobTitlesName+"</div>"+
									"<div class=\"data-department\">"+departmentName+"</div>"+
								"</div>"+
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
		removeFromSelectedArrById(hrmId);
		//ˢ�µײ�ѡ�и���
		refreshSelectedNum();
		//ȡ��ҳ�����ݵ�ѡ��״̬
		deCheckedOnPage(hrmId);
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

var prevSearchKey2 = "";
function initSelectedResultSearch(){
	var $searchKey = $("#result-search-key");
	var $srarchInner = $("#result-hrm-srarch .srarch-inner");
	$(".search-holder", $srarchInner).click(function(){
		$srarchInner.addClass("searching");
		$searchKey[0].focus();
	});
	
	$searchKey.blur(function(){
		if(this.value == ""){
			$srarchInner.removeClass("searching");
		}
	});
	
	$searchKey.bind("input", function(){
		var currSearchKey = this.value;
		if(currSearchKey != prevSearchKey2){
			prevSearchKey2 = currSearchKey;
			searchSelectedResult();
		}
	});
}

function searchSelectedResult(){
	var $oneData = $("#result-data li.one-data");
	var searchKeyVal = $("#result-search-key").val();
	if(searchKeyVal == ""){
		$oneData.show();
	}else{
		$oneData.each(function(){
			var datalastname = $(".data-lastname", this).text();
			if(datalastname.indexOf(searchKeyVal) != -1){
				$(this).show();
			}else{
				$(this).hide();
			}
		});
	}
}

function resetSelectedResultSearch(){
	var $searchKey = $("#result-search-key");
	$searchKey.val("");
	$searchKey.trigger("blur");
}

function bindTreeEvt($wrap){
	$(".one-tree-data[data-haschild='1']", $wrap).click(function(){
		var $oneTreeData = $(this);
		var expanding = $oneTreeData.attr("expanding");
		if(expanding == "1"){
			return;
		}
		$oneTreeData.attr("expanding", "1");
		
		var $treePage = $oneTreeData.siblings(".tree-page");
		
		if($oneTreeData.hasClass("closed")){
			$oneTreeData.removeClass("closed");
			$oneTreeData.addClass("opened");
			
			if($treePage.length > 0){
				$treePage.show();
				$oneTreeData.removeAttr("expanding");
			}else{
				//�ӷ���˼���
				var $treeLoading = $("<div class=\"tree-loading\"></div>");
				$treeLoading.insertAfter($oneTreeData);
				
				var dataType = $oneTreeData.attr("data-type");
				var dataId = $oneTreeData.attr("data-id");
				
				var url = "/mobile/plugin/plus/browser/hrmBrowserAction.jsp?action=getTreeData&type="+dataType+"&pid="+dataId;
								
				$.get(url, null, function(responseText){
					$treeLoading.remove();
					
					var data;
					if($.isPlainObject(responseText)){
						data = responseText;
					}else{
						data = $.parseJSON(responseText);
					}
					var status = data["status"];
					if(status == "1"){
						var datas = data["datas"];
						fillTreeDatasToPage(datas, $oneTreeData);
					}else{
						var errMsg = data["errMsg"];
						alert("��������ʱ���ִ���" + errMsg);
						
						$oneTreeData.removeClass("opened");
						$oneTreeData.addClass("closed");
					}
					
					$oneTreeData.removeAttr("expanding");
				});
			}
		}else if($oneTreeData.hasClass("opened")){
			$treePage.hide();
			$oneTreeData.removeClass("opened");
			$oneTreeData.addClass("closed");
			$oneTreeData.removeAttr("expanding");
		}
	});
}

function fillTreeDatasToPage(datas, $obj){
	var $treePage = $("<ul class=\"tree-page\"></ul>");
	for(var i = 0; i < datas.length; i++){
		var data = datas[i];
		var id = data["id"];	//id
		var name = data["name"];	//����
		var type = data["type"];	//����
		var messagerurl = data["messagerurl"]	//ͷ��
		
		var $li;
		if(type == "4"){	//��Ա
			$li = $("<li class=\"hrm\"></li>");
			var checkedStr = (indexOfSelectedArr(id) == -1) ? "" : "checked=\"checked\"";
			$li.append("<input type=\"checkbox\" class=\"valueHolder\" name=\"checkbox_hrm\" hrmId=\""+id+"\" value=\""+id+"\" "+checkedStr+"/>"+
					   "<div class=\"one-tree-data\">"+
							"<div class=\"data-avatar\">"+
								"<div>"+(messagerurl!=""?"<img src=\""+messagerurl+"\" style=\"width:100%;height:100%;\" />":"")+"</div>"+
							"</div>"+
							"<div class=\"data-name\">"+
								name+
							"</div>"+
						"</div>");
			$treePage.append($li);
			$(".valueHolder", $li).attr("hrm_data", JSON.stringify(data));
			$li.cssCheckBox();
		}else{
			var hasChild = data["hasChild"];	//�Ƿ����ӽڵ�
			var hasChildFlag = hasChild ? "1" : "0"; 
			var cssStr = hasChild ? "closed" : "";
		
			$li = $("<li></li>");
			$li.append("<div class=\"one-tree-data "+cssStr+"\" data-id=\""+id+"\" data-type=\""+type+"\" data-haschild=\""+hasChildFlag+"\">"+name+"</div>");
			$treePage.append($li);
		}
		
	}
	$treePage.insertAfter($obj);
	
	bindTreeEvt($treePage);
}
function keyDown(e) {
	var ev= window.event||e;
	if (ev.keyCode == 13){
		searchListData();
	}
}
/***�����ƶ���ģ��ͷ��***/
function hasOperationConfig(){
	return "true,,false,true,/downloadpic.do?url=/mobile/plugin/plus/browser/images/ok.png?css={width:36px;height:36px;top:7px;}";
}
function toDoMiddlePageName(){
	return showTypeName;
}
function doLeftMenuConfig(){
	var $pageCenter = $("#page-center");
	if($pageCenter.hasClass("selected-result-open")){
		$pageCenter.removeClass("selected-result-open");	
	}else{
		//backpage
		try{
			var browserWin = parent._BrowserWindow;
			if(browserWin){
				//browserWin.onBrowserBack();
				eval('browserWin.'+_callbackBack+'()');
			}else{
				//parent.onBrowserBack();
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
		nameValue += selectedData["lastname"] + ",";
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
	try{
		var browserWin = parent._BrowserWindow;
		if(browserWin){
			//browserWin.onBrowserOk(result);
			eval('browserWin.'+_callbackOk+'(result)');
		}else{
			//parent.onBrowserOk(result);
			eval('parent.'+_callbackOk+'(result)');
		}
	}catch(e){
		
	}
	return "1";
}
/******/
</script>
<% if(isNoHeader){ %>
<style type="text/css">
#page-center{
	top: 0px;
}
</style>
<% } %>
</head>
<body class="_emobile">
<div id="page">
	<% if(!isNoHeader){ %>
	<div id="page-title">
		<div id="nav-header">
			<div class="header-left"></div>
			<div class="header-center"><%=showTypeName%></div>
			<div class="header-right"></div>
		</div>
	</div>
	<% } %>
	
	<div id="page-center">
		
		<div id="center-content" class="<%=showTypeClassName%>">
			<div id="center-content-inner">
				<div id="list-dept-container" class="data-container dept-container">
					<div id="list-dept-content" class="hrmitem">
						<div class="group-wrap"></div>
					</div>
				</div>
				<div id="list-hrm-container" class="data-container hrm-container">
					<div id="list-hrm-srarch">
						<div class="srarch-inner">
							<div class="search-holder"></div>
							<form action="javascript:searchListData();">
							<input type="search" id="search-key" placeholder="����������������ƴ���ֻ��������"/>
							</form>
						</div>
					</div>
					
					<div id="list-hrm-content">
						<div class="group-wrap">
						</div>
						<div id="list-loadMore">���ظ���</div>
						<div id="list-loading">
						</div>
					</div>
				</div>
				<%if(WxModuleInit.ifLastContract){ %>
				<div id="list-lasthrm-container" class="data-container lasthrm-container">
					<div id="list-lasthrm-content" class="hrmitem">
						<div class="group-wrap"></div>
					</div>
				</div>
				<%} %>
				<div id="list-group-container" class="data-container group-container">
					<div id="list-group-content" class="hrmitem">
						<div class="group-wrap" id="group_group_wrap"></div>
					</div>
				</div>
				
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
				��ѡ(<span id="selectedNum">0</span>)
			</div>
			
			<div id="okResult">
				ȷ&nbsp;��
			</div>
		</div>
		
		<div id="page-control" class="<%=showTypeClassName%>">
			<div class="control-icon">
			
			</div>
			<div class="control-text">
				<%=showTypeName%>
			</div>
		</div>
		<%if(WxModuleInit.ifLastContract){ %>
		<style>
			#control-lasthrm{
				position:absolute;
			    left: 0px;
			    bottom: 0px;
			    width: 66px;
			    height: 66px;
			    background: url("/mobile/plugin/plus/browser/images/p5.png") no-repeat;
			    background-size: 100% 100%;
			    z-index: 101;
			    transition:All 0.15s ease-in-out;
				-webkit-transition:All 0.15s ease-in-out;
			}
			#control-lasthrm .icon{
				background-image: url("/mobile/plugin/plus/browser/images/p5-4.png");
			}
			.control-open #control-lasthrm{
				transform:translate(100px,-100px);
				-webkit-transform:translate(100px,-100px);
			}
			#page-control.lasthrm .control-icon{
				background-image: url("/mobile/plugin/plus/browser/images/big4.png");
			}
			#page-control.lasthrm .control-text{
				padding-left:15px;
			}
		</style>
		<div id="control-lasthrm" class="control-part">
			<div class="icon"></div>
			<div class="text">
				������
			</div>
		</div>
		<%} %>
		<div id="control-dept" class="control-part">
			<div class="icon"></div>
			<div class="text">ͬ����</div>
		</div>
		<div id="control-hrm" class="control-part">
			<div class="icon"></div>
			<div class="text">������</div>
		</div>
		<%if(ifShowDept==1){ %>
		<div id="control-org" class="control-part">
			<div class="icon"></div>
			<div class="text">��֯�ܹ�</div>
		</div>
		<%} %>
		<div id="control-group" class="control-part">
			<div class="icon"></div>
			<div class="text">������</div>
		</div>
		
		<div id="page-mask">
			
		</div>
		
		<div id="selected-result-page">
			<div id="result-center">
				<div id="result-center-inner">
					
					<div id="result-hrm-container">
						<div id="result-hrm-srarch">
							<div class="srarch-inner">
								<div class="search-holder"></div>
								<input type="search" id="result-search-key" />
							</div>
						</div>
						
						<div id="result-hrm-content">
							<div id="result-data">
							</div>
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
<%@page import="weaver.formmode.IgnoreCaseHashMap"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.data.model.EntityInfo"%>
<%@page import="com.weaver.formmodel.data.manager.EntityInfoManager"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/mobilemode/init.jsp"%>
<%
CustomSearchService customSearchService=new CustomSearchService();
MobileAppUIManager mobileAppUIManager=MobileAppUIManager.getInstance();
String modelid=Util.null2String(request.getParameter("modelid"));
String appid=Util.null2String(request.getParameter("appid"));
String refresh = Util.null2o(request.getParameter("refresh"));
int homepageLayout = Util.getIntValue(Util.null2String(request.getParameter("homepageLayout")));//用于选中是自定义页面布局还是模块布局
int listLayout = Util.getIntValue(Util.null2String(request.getParameter("listLayout")));//用于选中是自定义查询还是模块查询
if(StringHelper.isEmpty(modelid)){
	out.print("<strong>"+SystemEnv.getHtmlLabelName(127512,user.getLanguage())+"</strong>");  //请选择模块！
	return;
}
EntityInfo entityInfo=EntityInfoManager.getInstance().getEntityInfo(NumberHelper.getIntegerValue(modelid));
String modename=StringHelper.null2String(entityInfo.getModename());

//获取表单建模模块对应查询报表
List<Map<String,Object>> list=customSearchService.getCustomSearchByModeid(Util.getIntValue(modelid));
List<AppFormUI> appFormUIs=mobileAppUIManager.getDefaultAppUIListByApp(Util.getIntValue(appid),Util.getIntValue(modelid));
List<String> customSearchIds=new ArrayList<String>();
//手机新建布局是否存在
int addExist=0;
//手机编辑布局是否存在
int editExist=0;
//手机显示布局是否存在
int showExist=0;

for(AppFormUI appFormUI:appFormUIs){
	String sourceid=Util.null2String(appFormUI.getSourceid());
	int uiType=appFormUI.getUiType();
	if(uiType==3){
		customSearchIds.add(sourceid);
	}else if(uiType==2){
		editExist=1;
	}else if(uiType==1){
		showExist=1;
	}else if(uiType==0){
		addExist=1;
	}
}

List<AppHomepage> appHomepages = MobileAppHomepageManager.getInstance().getAppHomepagesByAppidAndModelid(Util.getIntValue(appid),Util.getIntValue(modelid));
List<String> homepageSearchIds=new ArrayList<String>();
List<String> homepageLayoutIds=new ArrayList<String>();
int addExist_homepage = 0;
int editExist_homepage = 0;
int showExist_homepage = 0;
for(AppHomepage appHomepage : appHomepages){
	String sourceid=Util.null2String(appHomepage.getSourceid());
	int uiType = Util.getIntValue(appHomepage.getUitype());
	int isdefault = Util.getIntValue(Util.null2String(appHomepage.getIsdefault()), 0);
	int layoutid = Util.getIntValue(Util.null2String(appHomepage.getLayoutid()), 0);
	if(uiType == 3){
		homepageSearchIds.add(sourceid);
	}else{
		if(isdefault == 1){
			if(uiType==2){
				editExist_homepage = 1;
			}else if(uiType==1){
				showExist_homepage = 1;
			}else if(uiType==0){
				addExist_homepage = 1;
			}
		}else{
			homepageLayoutIds.add(String.valueOf(layoutid));
		}
	}
}

List<Map<String,Object>> layoutList = new ArrayList<Map<String,Object>>();
String sql = "select * from modehtmllayout where isdefault=0 and modeid=" + modelid;
rs.executeSql(sql);
while(rs.next()){
	Map<String,Object> layoutMap = new IgnoreCaseHashMap<String, Object>();
	String layoutName = Util.null2String(rs.getString("layoutname"));
	int type = Util.getIntValue(rs.getString("type"), -1);
	if(type > 2 || type <= -1) continue;
	String layoutType = (type == 0 ? "显示布局" : (type == 1 ? "新建布局" : "编辑布局"));
	String iconSrc = (type == 0 ? "/mobilemode/images/circle_view_wev8.png" : (type == 1 ? "/mobilemode/images/circle_add_wev8.png" : "/mobilemode/images/circle_edit_wev8.png"));
	String typeid = Util.null2String(rs.getString("id")) + ":" + (type == 0 ? 1 : (type == 1 ? 0 : type));
	String id = Util.null2String(rs.getString("id"));
	String version = Util.null2String(rs.getString("version"));
	layoutMap.put("layoutName", layoutName);
	layoutMap.put("type", type);
	layoutMap.put("layoutType", layoutType);
	layoutMap.put("iconSrc", iconSrc);
	layoutMap.put("typeid", typeid);
	layoutMap.put("id", id);
	layoutMap.put("version", version);
	layoutList.add(layoutMap);
}
%>
<html>
<head>
	<title></title>
	<style>
*{
	font: 12px Microsoft YaHei;
	color: #333;
}
html {overflow-x:hidden;}
body{
	height:100%;
	padding: 17px 8px 0px 8px;
}
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
ul{
	list-style: none;
	margin: 0;
	padding: 5px 0 0;

}
ul li{
	position: relative;
	min-height: 46px;
	border:1px solid #fff;
	margin-bottom: 5px;
	padding: 5px 0 0px 5px;
	background-color:#f9f9f9;
}

ul li:hover{
	background-color:#f5f5f5;
	cursor: pointer;
}

.checked{
	width: 18px;
	height: 18px;
	position: absolute;
	right:0px;
	bottom: 0px; 
	display: none;
}
.checked:before{
	content: ".";
	position: absolute;
	right: -3px;
	transform: rotate(-135deg);
	-ms-transform: rotate(-135deg);
    -webkit-transform: rotate(-135deg);
    top: 0px;
    width: 0px;
    height: 0px;
    border-bottom: 14px solid transparent;
    border-top: 14px solid transparent;
    border-right: 14px solid #269195;
    border-radius:48px;
    font-size: 0px;
    line-height: 0px;
    z-index: 1;
}
.checked:after{
	content: "√";
	position: absolute;
    right: 1px;
    top: 4px;
    color: #fff;
    font-size: 10px;
    transform: rotate(5deg);
	-ms-transform: rotate(5deg);
    -webkit-transform: rotate(5deg);
    z-index: 1;
}
.li_sel{
	border: 1px solid #2690e3;
    background-color:#f5f5f5;
}

.li_sel .checked{
	display: block;
}

.e8_layoutType{
	border-bottom: 1px solid #ccc;
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 0px !important;
}
.e8_layoutType td{
	font-size: 12px;
	font-weight: bold;
	padding: 0;
}
.e8_layoutType td.e8_layoutTypeCheckbox{
	text-align:right;font-weight:normal;color::#333;
}
.e8_layoutIcon{
	float:left;width:50px;
}
.e8_layoutTitle{
	font-size: 16px;
	padding-right: 10px;
	margin-left:50px;
	margin-right: 54px;
}
.e8_layoutDesc{
	font-size: 11px;
	color: #aaa;
	line-height: 12px;
	margin-bottom:5px;
}
.jNiceCheckbox{
	margin-bottom: -2px;
}
.layoutTypeWrap, .otherLayoutTypeWrap, .listTypeWrap{
	overflow: hidden;
	margin-bottom: 10px;
	padding-left: 8px !important;
}
.layoutTypeWrap > div, .otherLayoutTypeWrap > div, .listTypeWrap > div{
	float: left;
	margin-right: 10px;
	margin-bottom: 0px;
	padding: 3px 0px;
	cursor: pointer;
}
.layoutTypeWrap > div.selected, .listTypeWrap > div.selectedList, .otherLayoutTypeWrap > div.selected{
	color: #017afd;
	border-bottom: 1px solid #0d93f6;
}
.layoutContentWrap, .listContentWrap{
	display: none;
}
.layoutContentWrap.selected, .listContentWrap.selectedList{
	display: block;
}
ul#homepageLayout li:not(.otherLayout_homepage):before{
	content: ".";
	position: absolute;
	right: -4px;
	transform: rotate(135deg);
	-ms-transform: rotate(135deg);
    -webkit-transform: rotate(135deg);
    top: -16px;
    width: 0px;
    height: 0px;
    border-bottom: 24px solid transparent;
    border-top: 24px solid transparent;
    border-right: 24px solid #2690e3;
    font-size: 0px;
    line-height: 0px;
    z-index: 1;
}
ul#homepageLayout li:not(.otherLayout_homepage):after{
	content: "<%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%>";
	transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    -webkit-transform: rotate(45deg);
    position: absolute;
    right: -2px;
    top: 4px;
    color: #fff;
    font-size: 10px;
    z-index: 1;
}

ul#homepageLayout li.otherLayout_homepage .e8_layoutversion{
	font-size: 12px;
    color: #ffffff;
    border-radius: 20px;
    background-color: #2690FA;
    padding: 0px 4px;
    position: absolute;
    right: 3px;
    top: 8px;
}

ul#homepageLayout li.otherLayout_homepage .e8_layoutversion.new{
    background-color: #2690FA;
}

ul#homepageLayout li.otherLayout_homepage .e8_layoutversion.old{
    background-color: #808080;
}

	</style>
	<script>
	if('<%=refresh%>'=='1'){
		top.callTopDlgHookFn();
	}
	var customSearchIds=<%=customSearchIds.toString()%>;
	var addCustomSearchIds=new Array();
	var delCustomSearchIds=new Array();
	
	var homepageSearchIds=<%=homepageSearchIds.toString()%>;
	var addHomepageSearchIds=new Array();
	var delHomepageSearchIds=new Array();
	
	var addOtherLayoutIds=new Array();
	var delOtherLayoutIds=new Array();
	
	$(document).ready(function(){
		$(".loading").hide();
		$(".addLayout_homepage").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#addLayout_homepage").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#addLayout_homepage").val(0);
			}
		});
		$(".editLayout_homepage").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#editLayout_homepage").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#editLayout_homepage").val(0);
			}
		});
		$(".showLayout_homepage").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#showLayout_homepage").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#showLayout_homepage").val(0);
			}
		});
		
		$(".addLayout").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#addLayout").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#addLayout").val(0);
			}
		});
		$(".editLayout").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#editLayout").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#editLayout").val(0);
			}
		});
		$(".showLayout").click(function(){
			if(!$(this).hasClass("li_sel")){
				$(this).addClass("li_sel");
				$("#showLayout").val(1);
			}else{
				$(this).removeClass("li_sel");
				$("#showLayout").val(0);
			}
		});
		//布局列表点击事件
		$(".custsearch").click(function(){
			var obj=$(this);
			var customsearchid=obj.attr("id");
			var isexist=obj.attr("isexist");
			if(isexist=="true"){
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					var index=delCustomSearchIds.indexOf(customsearchid);
					if(index>-1){
						delCustomSearchIds.splice(index,1);
					}
				}else{
					$(this).removeClass("li_sel");
					delCustomSearchIds.push(customsearchid);
				}
				$("#delCustomSearchIds").val(delCustomSearchIds.toString());
			}else{
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					addCustomSearchIds.push(customsearchid);
				}else{
					$(this).removeClass("li_sel");
					var index=addCustomSearchIds.indexOf(customsearchid);
					if(index>-1){
						addCustomSearchIds.splice(index,1);
					}
				}
				$("#addCustomSearchIds").val(addCustomSearchIds.toString());
			}
			
		});
		//自定义页面列表点击事件
		$(".pagesearch").click(function(){
			var obj=$(this);
			var customsearchid=obj.attr("id");
			var isexist=obj.attr("isexist");
			if(isexist=="true"){
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					var index=delHomepageSearchIds.indexOf(customsearchid);
					if(index>-1){
						delHomepageSearchIds.splice(index,1);
					}
				}else{
					$(this).removeClass("li_sel");
					delHomepageSearchIds.push(customsearchid);
				}
				$("#delHomepageSearchIds").val(delHomepageSearchIds.toString());
			}else{
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					addHomepageSearchIds.push(customsearchid);
				}else{
					$(this).removeClass("li_sel");
					var index=addHomepageSearchIds.indexOf(customsearchid);
					if(index>-1){
						addHomepageSearchIds.splice(index,1);
					}
				}
				$("#addHomepageSearchIds").val(addHomepageSearchIds.toString());
			}
			
		});
		//其他布局列表点击事件
		$(".otherLayout_homepage").click(function(){
			var obj=$(this);
			var layoutid=obj.attr("id");
			var isexist=obj.attr("isexist");
			if(isexist=="true"){
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					var index=delOtherLayoutIds.indexOf(layoutid);
					if(index>-1){
						delOtherLayoutIds.splice(index,1);
					}
				}else{
					$(this).removeClass("li_sel");
					delOtherLayoutIds.push(layoutid);
				}
				$("#delOtherLayoutIds").val(delOtherLayoutIds.toString());
			}else{
				if(!$(this).hasClass("li_sel")){
					$(this).addClass("li_sel");
					addOtherLayoutIds.push(layoutid);
				}else{
					$(this).removeClass("li_sel");
					var index=addOtherLayoutIds.indexOf(layoutid);
					if(index>-1){
						addOtherLayoutIds.splice(index,1);
					}
				}
				$("#addOtherLayoutIds").val(addOtherLayoutIds.toString());
			}
		});
		
		//布局tab显示隐藏控制
		$("#layoutTypeWrap > div").click(function(){
			if(!$(this).hasClass("selected")){
				changeCheckboxStatus($("input[type='checkbox'][name='laycheck']")[0], false);
				$(this).siblings("div").removeClass("selected");
				$(this).addClass("selected");
				var tHref = $(this).attr("href");
				$(tHref).siblings(".selected").removeClass("selected");
				$(tHref).addClass("selected");
			}
			var homepageLayout = $(this).attr("href") == "#homepageLayout";
			$("#selectedHomepageLayout").val(homepageLayout ? "0" : "1");
			$("#listTypeWrap > div").eq(homepageLayout ? 0 : 1).trigger("click");
		});
		//查询列表tab显示隱藏控制
		$("#listTypeWrap > div").click(function(){
			if(!$(this).hasClass("selectedList")){
				changeCheckboxStatus($("input[type='checkbox'][name='seacheck']")[0], false);
				$(this).siblings("div").removeClass("selectedList");
				$(this).addClass("selectedList");
				var tHref = $(this).attr("href");
				$(tHref).siblings(".selectedList").removeClass("selectedList");
				$(tHref).addClass("selectedList");
			}
			$("#selectedListLayout").val($(this).attr("href") == "#homepageSearch" ? "0" : "1");
		});
		
		$(document.body).height($(window).height()-18);
	});
	
	
	function initFormUI(){
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=initFormUI");
		document.frmMain.submit();
	}
	//布局全选操作
	function layoutcheck(obj){
		var targetHref = $("#layoutTypeWrap > div.selected").attr("href");
		
		if(obj.checked){
			//自定义页面布局
			if(targetHref == "#homepageLayout"){
				if(!$(".addLayout_homepage").hasClass("li_sel")){
					$(".addLayout_homepage").addClass("li_sel");
					$("#addLayout_homepage").val(1);
				}
				if(!$(".editLayout_homepage").hasClass("li_sel")){
					$(".editLayout_homepage").addClass("li_sel");
					$("#editLayout_homepage").val(1);
				}
				if(!$(".showLayout_homepage").hasClass("li_sel")){
					$(".showLayout_homepage").addClass("li_sel");
					$("#showLayout_homepage").val(1);
				}
				$("li.otherLayout_homepage").each(function(i){
					var obj=$(this);
					var layoutid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							var index=delOtherLayoutIds.indexOf(layoutid);
							if(index>-1){
								delOtherLayoutIds.splice(index,1);
							}
						}
						$("#delOtherLayoutIds").val(delOtherLayoutIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							addOtherLayoutIds.push(layoutid);
						}
						$("#addOtherLayoutIds").val(addOtherLayoutIds.toString());
					}
				});
			}else{//布局
				if(!$(".addLayout").hasClass("li_sel")){
					$(".addLayout").addClass("li_sel");
					$("#addLayout").val(1);
				}
				if(!$(".editLayout").hasClass("li_sel")){
					$(".editLayout").addClass("li_sel");
					$("#editLayout").val(1);
				}
				if(!$(".showLayout").hasClass("li_sel")){
					$(".showLayout").addClass("li_sel");
					$("#showLayout").val(1);
				}
			}
		}else{
			if(targetHref == "#homepageLayout"){//自定义页面布局
				if($(".addLayout_homepage").hasClass("li_sel")){
					$(".addLayout_homepage").removeClass("li_sel");
					$("#addLayout_homepage").val(0);
				}
				if($(".editLayout_homepage").hasClass("li_sel")){
					$(".editLayout_homepage").removeClass("li_sel");
					$("#editLayout_homepage").val(0);
				}
				if($(".showLayout_homepage").hasClass("li_sel")){
					$(".showLayout_homepage").removeClass("li_sel");
					$("#showLayout_homepage").val(0);
				}
				$("li.otherLayout_homepage").each(function(i){
					var obj=$(this);
					var layoutid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							delOtherLayoutIds.push(layoutid);
						}
						$("#delOtherLayoutIds").val(delOtherLayoutIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							var index=addOtherLayoutIds.indexOf(layoutid);
							if(index>-1){
								addOtherLayoutIds.splice(index,1);
							}
						}
						$("#addOtherLayoutIds").val(addOtherLayoutIds.toString());
					}
				});
			}else{//布局
				if($(".addLayout").hasClass("li_sel")){
					$(".addLayout").removeClass("li_sel");
					$("#addLayout").val(0);
				}
				if($(".editLayout").hasClass("li_sel")){
					$(".editLayout").removeClass("li_sel");
					$("#editLayout").val(0);
				}
				if($(".showLayout").hasClass("li_sel")){
					$(".showLayout").removeClass("li_sel");
					$("#showLayout").val(0);
				}
			}
		}
		$(".e8_otherLayoutType input[name='laycheck']").click();
	}
	//查询列表全选操作
	function searchcheck(obj){
		var targetHref = $("#listTypeWrap > div.selectedList").attr("href");
		if(obj.checked){
			if(targetHref == "#homepageSearch"){
				$("#homepageSearch>li").each(function(i){
					var obj=$(this);
					var homepagesearchid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							var index=delCustomSearchIds.indexOf(homepagesearchid);
							if(index>-1){
								delHomepageSearchIds.splice(index,1);
							}
						}
						$("#delHomepageSearchIds").val(delHomepageSearchIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							addHomepageSearchIds.push(homepagesearchid);
						}
						$("#addHomepageSearchIds").val(addHomepageSearchIds.toString());
					}
				});
			}else{
				$("#search>li").each(function(i){
					var obj=$(this);
					var customsearchid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							var index=delCustomSearchIds.indexOf(customsearchid);
							if(index>-1){
								delCustomSearchIds.splice(index,1);
							}
						}
						$("#delCustomSearchIds").val(delCustomSearchIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							$(this).addClass("li_sel");
							addCustomSearchIds.push(customsearchid);
						}
						$("#addCustomSearchIds").val(addCustomSearchIds.toString());
					}
				});
			}
			
		}else{
			if(targetHref == "#homepageSearch"){
				$("#homepageSearch").find("li").each(function(i){
					var obj=$(this);
					var homepagesearchid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							delHomepageSearchIds.push(homepagesearchid);
						}
						$("#delHomepageSearchIds").val(delHomepageSearchIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							var index=addHomepageSearchIds.indexOf(homepagesearchid);
							if(index>-1){
								addHomepageSearchIds.splice(index,1);
							}
						}
						$("#addHomepageSearchIds").val(addHomepageSearchIds.toString());
					}
				});
			}else{
				$("#search").find("li").each(function(i){
					var obj=$(this);
					var customsearchid=obj.attr("id");
					var isexist=obj.attr("isexist");
					if(isexist=="true"){
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							delCustomSearchIds.push(customsearchid);
						}
						$("#delCustomSearchIds").val(delCustomSearchIds.toString());
					}else{
						if(!$(this).hasClass("li_sel")){
							
						}else{
							$(this).removeClass("li_sel");
							var index=addCustomSearchIds.indexOf(customsearchid);
							if(index>-1){
								addCustomSearchIds.splice(index,1);
							}
						}
						$("#addCustomSearchIds").val(addCustomSearchIds.toString());
					}
				});
			}
		}
	}
	
	</script>
	
</head>
  
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+",javascript:initFormUI(),_top} " ;  //初始化
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(23278, user.getLanguage())%></span>
</div>
<FORM id=weaver name=frmMain method=post target="_self" >
<input type="hidden" id="modelid" name="modelid" value="<%=modelid%>">
<input type="hidden" id="appid" name="appid" value="<%=appid%>">
<input type="hidden" id="addCustomSearchIds" name="addCustomSearchIds" value="">
<input type="hidden" id="delCustomSearchIds" name="delCustomSearchIds" value="">
<input type="hidden" id="addHomepageSearchIds" name="addHomepageSearchIds" value="">
<input type="hidden" id="delHomepageSearchIds" name="delHomepageSearchIds" value="">
<input type="hidden" id="addLayout_homepage" name="addLayout_homepage" value="<%=addExist_homepage%>">
<input type="hidden" id="editLayout_homepage" name="editLayout_homepage" value="<%=editExist_homepage%>">
<input type="hidden" id="showLayout_homepage" name="showLayout_homepage" value="<%=showExist_homepage%>">
<input type="hidden" id="addLayout" name="addLayout" value="<%=addExist%>">
<input type="hidden" id="editLayout" name="editLayout" value="<%=editExist%>">
<input type="hidden" id="showLayout" name="showLayout" value="<%=showExist%>">
<input type="hidden" id="selectedHomepageLayout" name="selectedHomepageLayout" value="<%=homepageLayout%>">
<input type="hidden" id="selectedListLayout" name="selectedListLayout" value="<%=listLayout%>">
<!-- 非默认布局 -->
<input type="hidden" id="addOtherLayoutIds" name="addOtherLayoutIds" value="">
<input type="hidden" id="delOtherLayoutIds" name="delOtherLayoutIds" value="">
<table class="e8_layoutType">
<tr>
	<td id="layoutTypeWrap" class="layoutTypeWrap"><div class="<%if(homepageLayout != 1){%>selected<%}%>" href="#homepageLayout"><%=SystemEnv.getHtmlLabelName(127513,user.getLanguage())%><!-- 自定义页面布局 --></div><!-- <div href="#modelLayout" class="<%if(homepageLayout == 1){%>selected<%}%>"><%=SystemEnv.getHtmlLabelName(127514,user.getLanguage())%> --><!-- 模块布局 --><!-- </div> --></td>
	<td class="e8_layoutTypeCheckbox"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 --><input type="checkbox" name="laycheck" onclick="layoutcheck(this)"/></td></tr>
</table>
<ul id="homepageLayout" class="layoutContentWrap <%if(homepageLayout != 1){%>selected<%}%>">
	<li class="addLayout_homepage <%if(addExist_homepage == 1){%>li_sel<%}%>">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_add_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82135,user.getLanguage())%><!-- 新建布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
	<li class="editLayout_homepage <%if(editExist_homepage == 1){%>li_sel<%}%>">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_edit_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
	<li class="showLayout_homepage <%if(showExist_homepage == 1){%>li_sel<%}%>" style="margin-right:0;">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_view_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
	<%if(layoutList.size() > 0){ %>
	<%
		for(Map map : layoutList){
			String layoutName = Util.null2String(map.get("layoutName"));
			String layoutType = Util.null2String(map.get("layoutType"));
			String iconSrc = Util.null2String(map.get("iconSrc"));
			String typeid = Util.null2String(map.get("typeid"));
			String id = Util.null2String(map.get("id"));
			int version = Util.getIntValue(Util.null2String(map.get("version")));
			String label = version == 2 ? "excel布局" : "html布局";
			String flag = version == 2 ? "new" : "old";
			boolean isexist=homepageLayoutIds.contains(id);
	%>
	<li class="otherLayout_homepage <%if(isexist){%>li_sel<%}%>"  id="<%=typeid%>" isexist="<%=isexist%>">
		<div class="e8_layoutIcon"><img src="<%=iconSrc%>"/></div>
		<div class="e8_layoutTitle"><%=layoutName %><div class="e8_layoutversion <%=flag%>"><%=label %></div><div class="e8_layoutDesc"><%=layoutType %></div></div>
		<div class="checked"></div>
	</li>
	<%} %>
<%} %>
</ul>
<ul id="modelLayout" class="layoutContentWrap <%if(homepageLayout == 1){%>selected<%}%>">
	<li class="addLayout <%if(addExist==1){%>li_sel<%}%>">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_add_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82135,user.getLanguage())%><!-- 新建布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
	<li class="editLayout <%if(editExist==1){%>li_sel<%}%>">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_edit_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
	<li class="showLayout <%if(showExist==1){%>li_sel<%}%>" style="margin-right:0;">
		<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_view_wev8.png"/></div>
		<div class="e8_layoutTitle"><%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 --><div class="e8_layoutDesc"><%=modename%></div></div>
		<div class="checked"></div>
	</li>
</ul>

<table class="e8_layoutType">
<tr>
	<td id="listTypeWrap" class="listTypeWrap"><div class="<%if(listLayout != 1){%>selectedList<%}%>" href="#homepageSearch"><%=SystemEnv.getHtmlLabelName(127515,user.getLanguage())%><!-- 自定义页面查询 --></div><!-- <div href="#search" class="<%if(listLayout == 1){%>selectedList<%}%>"><%=SystemEnv.getHtmlLabelName(127516,user.getLanguage())%> --><!-- 模块查询 --><!-- </div> --></td>
	<td class="e8_layoutTypeCheckbox"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 --><input type="checkbox" name="seacheck" onclick="searchcheck(this)"/></td></tr>
</table>
<ul id="homepageSearch" class="listContentWrap <%if(listLayout != 1){%>selectedList<%}%>">
<%
for(Map map:list){
	String id=Util.null2String(map.get("id"));
	String modeid=Util.null2String(map.get("modeid"));
	String customname=Util.null2String(map.get("customname"));
	boolean isexist=homepageSearchIds.contains(id);
%>
<li class="pagesearch <%if(isexist){%>li_sel<%}%>" id="<%=id%>" isexist="<%=isexist%>">
	<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_list_wev8.png"/></div>
	<div class="e8_layoutTitle"><%=customname%><div class="e8_layoutDesc"><%=modename%></div></div>
	<div class="checked"></div>
</li>
<%}%>
</ul>
<ul id="search" class="listContentWrap <%if(listLayout == 1){%>selectedList<%}%>">
<%
for(Map map:list){
	String id=Util.null2String(map.get("id"));
	String modeid=Util.null2String(map.get("modeid"));
	String customname=Util.null2String(map.get("customname"));
	boolean isexist=customSearchIds.contains(id);
%>
<li class="custsearch <%if(isexist){%>li_sel<%}%>" id="<%=id%>" isexist="<%=isexist%>">
	<div class="e8_layoutIcon"><img src="/mobilemode/images/circle_list_wev8.png"/></div>
	<div class="e8_layoutTitle"><%=customname%><div class="e8_layoutDesc"><%=modename%></div></div>
	<div class="checked"></div>
</li>
<%}%>
</ul>
</FORM>
</body>
</html>

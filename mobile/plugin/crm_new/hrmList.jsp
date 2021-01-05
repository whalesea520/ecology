<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%
String flag = Util.null2String(request.getParameter("flag"), "default");
String isMilt = Util.null2String(request.getParameter("isMilt"), "0");	//是否多选  1.多选, 0单选
String callback = Util.null2String(request.getParameter("callback"));
String callbackData = Util.null2String(request.getParameter("callbackData"));
String selectedIds = Util.null2String(request.getParameter("selectedIds"));
String selectedNames = Util.null2String(request.getParameter("selectedNames"));
%>
<html>
<head>
<title></title>
</head>
<body>
<div id="m_hrm_list" class="page out">
	<style type="text/css">
		#m_hrm_list .m_hrm_search{height:40px;background-color: #c7c7ce;box-sizing:border-box;position: relative;}
		#m_hrm_list .m_hrm_search > div{border: 0;padding-left: 0px;position: absolute;top: 6px;bottom: 6px;left: 8px;right: 8px;overflow: hidden;background-color: #fff;border-radius: 5px;}
		#m_hrm_list .m_hrm_search input{border:none;height: 28px;width:100%;padding: 0px;font-size: 14px;line-height: 24px;text-align: center;box-sizing:border-box;background-image: url("/mobile/plugin/crm_new/images/search.png");background-repeat: no-repeat;background-position: 22% center;background-size: 16px 16px;}
		#m_hrm_list .m_hrm_search .searching input{background-position: 7px; center;padding-left: 30px;text-align: left;}
		#m_hrm_list .m_hrm_search .del{width:30px;height: 28px;position: absolute;top: 0px;right:0px;cursor: pointer;display: none;}
		
		#m_hrm_list .hrm_list{list-style: none;margin: 0px;padding: 0px;background: #fff;}
		#m_hrm_list .hrm_list li{padding-left: 35px;background-image: url("/mobile/plugin/crm_new/images/hrm/UnCheck.png");background-size: 20px 20px;background-repeat: no-repeat;background-position: 8px center;}
		#m_hrm_list .hrm_list li.checked {background-image: url("/mobile/plugin/crm_new/images/hrm/Check.png");}
		#m_hrm_list .hrm_list li .data-inner{border-bottom: 1px solid #d4d4d4;overflow: hidden;position: relative;display: block;height: 55px;}
		#m_hrm_list .hrm_list li .data-inner div{text-overflow: ellipsis;overflow:hidden; white-space:nowrap;}
		#m_hrm_list .hrm_list li .data-avatar{width: 35px;height: 35px;position: absolute;z-index: 3;top: 10px;left: 0px;background-color: #6495e6;border-radius:2.25em;font-size:12px;line-height: 35px;color: #fff;text-align: center;}
		#m_hrm_list .hrm_list li .data-part{padding-left: 168px;position: absolute;top:0px;left:0px;right: 0px;height: 55px;z-index: 2;background-color: #fff; -webkit-transition: -webkit-transform 0.3s;transition: transform 0.3s;}
		#m_hrm_list .hrm_list li .data-part:active{background-color: #eee;}
		#m_hrm_list .hrm_list li .data-part1{height: 55px;width: 105px;position: absolute;top: 0px;left: 50px;}
		#m_hrm_list .hrm_list li .data-part2{height: 55px;width: 100%;}
		#m_hrm_list .hrm_list li .data-part1 .data-lastname{color: #000;font-size: 16px;height: 30px;line-height: 30px;margin-top: 4px;}
		#m_hrm_list .hrm_list li .data-part1 .data-subCompany{color: #b2b2b2;font-size: 12px;}
		#m_hrm_list .hrm_list li .data-part2 .data-jobTitle{color: #828282;font-size: 15px;height: 30px;line-height: 30px;margin-top: 4px;}
		#m_hrm_list .hrm_list li .data-part2 .data-department{color: #b2b2b2;font-size: 12px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">人员</div>
		<div class="right okBtn"></div>
	</div>
	<div class="content">
		<div class="m_hrm_search">
			<div>
				<input type="text" placeholder="请输入姓名/首字母/手机号"/>
			</div>
		</div>
		<ul class="hrm_list" data-isMilt="<%=isMilt%>" data-value="<%=selectedIds %>" data-name="<%=selectedNames%>"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无联系记录</div>
		<div class="load_more">加载更多</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildMHrmListPage : function(flag, callback, callbackData){
			var that = this;
			var $m_hrm_list = $("#m_hrm_list");
			var $searchT = $(".m_hrm_search input[type='text']", $m_hrm_list);
			$searchT.focus(function(){
				$(this).parent().addClass("searching");	
			});
			$searchT.blur(function(){
				if(this.value == ""){
					$(this).parent().removeClass("searching");
				}
			});
			
			var _timestamp = null;
			$searchT.on("input", function(){
				var v = this.value;
				var $hrm_list = $(".hrm_list", $m_hrm_list);
				if(v == ""){
					$(this).parent().removeClass("hasContent");
				}else{
					$(this).parent().addClass("hasContent");
				}
				
				that.refreshMHrmList(flag);
			});
			
			$(".load_more", $m_hrm_list).click(function(){
				that.loadMHrmList(flag);
			});
			
			$(".header .okBtn", $m_hrm_list).click(function(){
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						var $list = $(".hrm_list", $m_hrm_list);
						var value = $list.attr("data-value");
						var name = $list.attr("data-name");
						if(value != ""){
							value = value.substring(0, value.length - 1);
						}
						if(name != ""){
							name = name.substring(0, name.length - 1);
						}
						
						callbackFn.call(that, value, name, callbackData);
					}
				}
				history.go(-1);
			});
			
			that.refreshMHrmList(flag);
		},
		mHrmListPageSize : 20,
		resetMHrmListPageNo : function(flag){
			var that = this;
			eval("that.mHrmListPageNo_" + flag + " = 0;");
		},
		refreshMHrmList : function(flag){
			var that = this;
			that.resetMHrmListPageNo(flag);
			that.loadMHrmList(flag);
		},
		loadMHrmList : function(flag){
			var that = this;
			eval("that.mHrmListPageNo_" + flag + "++;");
			eval("var pageNo = that.mHrmListPageNo_" + flag + ";");
			
			var $m_hrm_list = $("#m_hrm_list");
			var v = $(".m_hrm_search input[type='text']", $m_hrm_list).val();
			
			var $list = $(".hrm_list", $m_hrm_list);
			
			var $loading = $(".crm_loading", $m_hrm_list);
			$loading.show();
			var $load_more = $(".load_more", $m_hrm_list);
			$load_more.hide();
			var $no_data = $(".no_data", $m_hrm_list);
			$no_data.hide();
			
			var timestamp = (new Date()).valueOf();
			_timestamp = timestamp;
			that.ajax("/mobile/plugin/crm_new/hrmAction.jsp?action=getListData&pageNo="+pageNo+"&pageSize="+that.mHrmListPageSize+"&searchKey=" + v + "&type=",function(result) {
				if(timestamp != _timestamp){
					return;
				}
				
				$loading.hide();
				
				if(pageNo == 1){
					$list.find("*").remove();
				}
				
				var datas = result["datas"];
				var html = "";
				for(var i = 0; i < datas.length; i++){
					var da = datas[i];
					var checkedCls = "";
					if($list.attr("data-value").indexOf(da["id"] + ",") != -1){
						checkedCls = "checked";
					}
					var $dataLi = $("<li class=\"one-data "+checkedCls+"\" data-value=\""+da["id"]+"\" data-name=\""+da["lastname"]+"\">"
										+ "<div class=\"data-inner\">"
											+ "<div class=\"data-avatar\">"
											+ da["shortname"]
											+ "</div>"
											+ "<a href=\"javascript:void(0);\" class=\"data-part\">"
												+ "<div class=\"data-part1\">"
													+ "<div class=\"data-lastname\">"+da["lastname"]+"</div>"
													+ "<div class=\"data-subCompany\">"+da["subCompanyName"]+"</div>"
												+ "</div>"
												+ "<div class=\"data-part2\">"
													+ "<div class=\"data-jobTitle\">"+da["jobTitlesName"]+"</div>"
													+ "<div class=\"data-department\">"+da["departmentName"]+"</div>"
												+ "</div>"
											+ "</a>"
										+ "</div>"
									+ "</li>");
					$dataLi.click(function(){
						var value = $(this).attr("data-value");
						var name = $(this).attr("data-name");
						
						var pValue = $(this).parent().attr("data-value");
						var pName = $(this).parent().attr("data-name");
						
						var isMilt = $(this).parent().attr("data-isMilt");
						if($(this).hasClass("checked")){
							$(this).removeClass("checked");
							pValue = pValue.replace(value + "," , "");
							pName = pName.replace(name + "," , "");
						}else{
							if(isMilt != "1"){	//单选
								$(this).siblings("li.checked").removeClass("checked");
								pValue = "";
								pName = "";
							}
							pValue = pValue + value + ",";
							pName = pName + name + ",";
							$(this).addClass("checked");
						}
						
						$(this).parent().attr("data-value", pValue);
						$(this).parent().attr("data-name", pName);
					});
					$list.append($dataLi);
				}
				
				
				var totalSize = result["totalSize"];
				if(totalSize <= 0){
					$no_data.show();
				}
				var totalPageCount;
				if(totalSize % that.mHrmListPageSize == 0){
					totalPageCount = totalSize / that.mHrmListPageSize;
				}else{
					totalPageCount = parseInt(totalSize / that.mHrmListPageSize) + 1;
				}
				if(pageNo >= totalPageCount){
					$load_more.hide();
				}else{
					$load_more.show();
				}
			});
		}
	});
	CRM.buildMHrmListPage("<%=flag%>", "<%=callback%>", "<%=callbackData%>");
	</script>
</div>
	
</body>
</html>

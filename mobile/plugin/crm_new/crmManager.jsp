<!DOCTYPE html>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String userid = String.valueOf(user.getUID());
String lastname = user.getLastname();
String hasChild = "0";
ResourceComInfo comInfo = new ResourceComInfo();
while(comInfo.next()){
	String status = comInfo.getStatus();	//状态
	if(!status.equals("0") && !status.equals("1") && !status.equals("2") && !status.equals("3")){continue;}	//过滤掉状态异常的人员
	
	String managerid = comInfo.getManagerID();
	if(userid.equals(managerid)){
		hasChild = "1";
		break;
	}
}
%>
<html>
<head>
<title>客户经理</title>
</head>
<body>
<div id="crm_manager" class="page out">
	<style type="text/css">
		#crm_manager ul{list-style: none;margin: 0px;padding: 0px;}
		#crm_manager .tree-page li{padding-left: 30px;position: relative;}
		#crm_manager .tree-page li a{display: block;height: 35px;line-height: 35px;border-bottom: 1px dashed #f4f4f4;font-size: 15px;}
		#crm_manager .tree-page li .tree-flag{position: absolute;top: 0px;left: 0px;height: 35px;width: 30px;background-position: center center;background-repeat: no-repeat;}
		#crm_manager .tree-page li .tree-flag.closed{background-image: url("/mobile/plugin/crm_new/images/tree/jia.png");}
		#crm_manager .tree-page li .tree-flag.opened{background-image: url("/mobile/plugin/crm_new/images/tree/jian.png");}
		#crm_manager .tree-page li .tree-loading{height: 30px;background: url("/mobile/plugin/crm_new/images/tree/mobile_loading_wev8.gif") no-repeat;background-position: 20px center;}
		#crm_manager .root-tree-page{padding: 5px 0px 0px 6px;}
		#crm_manager .root-tree-page.no-child{padding-left: 0px;}
		#crm_manager .root-tree-page.no-child li{padding-left:0px;}
		#crm_manager .root-tree-page.no-child li > a{padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户经理</div>
	</div>
	<div class="content">
		<div class="controlTitle">我和下属</div>
		<ul class="tree-page root-tree-page<%if(hasChild.equals("0")){%> no-child<%}%>">
			<li class="">
				<a href="javascript:CRM.setCrmSearchValue('<%=userid%>', '<%=lastname%>', 'manager', true);"><%=lastname %></a>
				<%if(hasChild.equals("1")){ %>
				<div class="tree-flag closed" data-haschild="1" data-id="<%=userid%>"></div>
				<%} %>
			</li>
		</ul>
	</div>
	
	<script type="text/javascript">
	$.extend(CRM, {
		bindTreeEvt : function($wrap, triggerFlag){
			var that = this;
			var $tf = $(".tree-flag[data-haschild='1']", $wrap);
			$tf.click(function(){
				var $treeFlag = $(this);
				var expanding = $treeFlag.attr("expanding");
				if(expanding == "1"){
					return;
				}
				$treeFlag.attr("expanding", "1");
				
				var $treePage = $treeFlag.siblings(".tree-page");
				
				if($treeFlag.hasClass("closed")){
					$treeFlag.removeClass("closed");
					$treeFlag.addClass("opened");
					
					if($treePage.length > 0){
						$treePage.show();
						$treeFlag.removeAttr("expanding");
					}else{
						//从服务端加载
						var $treeLoading = $("<div class=\"tree-loading\"></div>");
						$treeLoading.insertAfter($treeFlag);
						
						var dataId = $treeFlag.attr("data-id");
						
						var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getUnder&pid="+dataId;
						$.get(url, null, function(responseText){
							$treeLoading.remove();
							
							var data = $.parseJSON(responseText);
							var status = data["status"];
							if(status == "1"){
								var datas = data["datas"];
								that.fillTreeDatasToPage(datas, $treeFlag);
							}else{
								var errMsg = data["errMsg"];
								alert("加载数据时出现错误：" + errMsg);
								
								$treeFlag.removeClass("opened");
								$treeFlag.addClass("closed");
							}
							
							$treeFlag.removeAttr("expanding");
						});
					}
				}else if($treeFlag.hasClass("opened")){
					$treePage.hide();
					$treeFlag.removeClass("opened");
					$treeFlag.addClass("closed");
					$treeFlag.removeAttr("expanding");
				}
				
			});
			if(triggerFlag == true){
				$tf.triggerHandler("click");
			}
		},
		fillTreeDatasToPage : function(datas, $obj){
			var that = this;
			var $treePage = $("<ul class=\"tree-page\"></ul>");
			for(var i = 0; i < datas.length; i++){
				var data = datas[i];
				var id = data["id"];	//id
				var name = data["name"];	//名称
				var hasChild = data["hasChild"];	//是否有子节点
			
				var $li = $("<li></li>");
				$li.append("<a href=\"javascript:CRM.setCrmSearchValue('"+id+"', '"+name+"', 'manager', true);\">"+name+"</a>");
				if(hasChild == "1"){
					$li.append("<div class=\"tree-flag closed\" data-id=\""+id+"\" data-haschild=\""+hasChild+"\"></div>");
				}
				$treePage.append($li);
				
			}
			$treePage.insertAfter($obj);
			
			that.bindTreeEvt($treePage);
		}
	});
	
	CRM.bindTreeEvt($("#crm_manager .root-tree-page"), true);
	
	</script>
</div>
</body>
</html>

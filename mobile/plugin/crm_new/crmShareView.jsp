<!DOCTYPE html>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String id = Util.null2String(request.getParameter("id"));
CrmShareBase crmShareBase = new CrmShareBase();
int sharelevel = crmShareBase.getRightLevelForCRM(""+user.getUID(), id);
boolean canedit=false;
if(sharelevel == 2 || sharelevel == 3 || sharelevel == 4){
	canedit = true;
}
%>
<html>
<head>
<title>查看共享</title>
</head>
<body>
<div id="crm_shareView" class="page out">
	<style type="text/css">
		#crm_shareView ul.list li img{width:40px;height:40px;border-radius: 40px;float: left;margin:0 15px 0 0;}
		#crm_shareView ul.list li div.icon{width:40px;height:40px;border-radius: 40px;background-color: #ddd;color:#777;font-size:12px !important;line-height: 40px;text-align: center;float: left;margin:0 15px 0 0;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">共享信息</div>
		<%if(canedit){ %>
		<a class="right addBtn" href="/mobile/plugin/crm_new/newCrmShare.jsp" data-formdata="id=<%=id%>"></a>
		<%} %>
	</div>
	<div class="content">
		<ul class="list"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无共享信息</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildShareViewPage : function(id){
			var that = this;
			that.refreshShareViewList(id);
		},
		refreshShareViewList : function(id){
			var that = this;
			var $crm_shareView = $("#crm_shareView");
			
			var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getCrmShare&id="+id;
			var $loading = $(".crm_loading", $crm_shareView);
			$loading.show();
			var $no_data = $(".no_data", $crm_shareView);
			$no_data.hide();
			that.ajax(url, function(result){
				$loading.hide();
				
				var $list = $(".list", $crm_shareView);
				$list.find("*").remove();
				var datas = result["datas"];
				var html = "";
				for(var i = 0; i < datas.length; i++){
					var d = datas[i];
					var isImg = d["isImg"];
					var flag = d["flag"];
					var ht = "";
					if(isImg == "1"){
						ht = "<img src=\""+flag+"\"/>";
					}else{
						ht = "<div class=\"icon\">"+flag+"</div>";
					}
					
					
					html += "<li>"
								+ ht
								+ "<div class=\"title\">"+d["title"]+"</div>"
								+ "<div>共享类型："+d["shareTypeName"]+"</div>"
							+"</li>";
				}
				$list.append(html);
				
				var totalSize = result["totalSize"];
				if(totalSize <= 0){
					$no_data.show();
				}
			});
		}
	});
	CRM.buildShareViewPage("<%=id%>");
	</script>
</div>
</body>
</html>

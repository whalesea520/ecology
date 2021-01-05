<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String callback = Util.null2String(request.getParameter("callback"));
String title="";
String fieldname = "";
%>
<html>
<head>
<title>客户名称</title>
</head>
<body>
<div id="crmSell_khmc" class="page out">
	<style type="text/css">
		#crmSell_khmc ul.list{padding:0px;}
		#crmSell_khmc ul.list li{padding:0px;font-size: 14px;}
		#crmSell_khmc ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户名称</div>
	</div>
	<div class="content">
		<div class="controlTitle"><%=title%></div>
		<ul class="list">
			<%
			String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
			String backfields = "t1.id , t1.name , t1.manager , t1.status ,t1.type";
			String fromSql =" CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid ";
			String sqlwhere=" t1.deleted<>1 and t1.id = t2.relateditemid ";
			String sql = "select "+backfields+" from "+fromSql+" where "+sqlwhere+" order by t1.id desc";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
			String id = RecordSet.getString("id");
			String name = RecordSet.getString("name");%>
			<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmSellkhmcPage : function(callback){
			var that = this;
			var $crmSell_khmc = $("#crmSell_khmc");
			
			$(".list > li > a", $crmSell_khmc).click(function(){
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						var value = $(this).attr("data-value");
						var text = $(this).attr("data-text");
						callbackFn.call(that, value, text);
					}
				}
				history.go(-1);
			});
		}
	});
	CRM.buildCrmSellkhmcPage("<%=callback%>");
	</script>
</div>
</body>
</html>

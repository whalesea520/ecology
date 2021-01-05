<!DOCTYPE html>
<%@page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.crm.Maint.SectorInfoComInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.conn.RecordSet" %>
<%
	String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
	<title>客户</title>
</head>
<body>
<div id="crm_customer" class="page out">
	<style type="text/css">
		#crm_customer ul.list {
			padding: 0px;
		}

		#crm_customer ul.list li {
			padding: 0px;
			font-size: 14px;
		}

		#crm_customer ul.list li > a {
			height: 36px;
			line-height: 36px;
			padding-left: 15px;
		}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户</div>
	</div>
	<div class="content">
		<%--<div class="controlTitle">客户名称</div>--%>
		<div class="listSearch">
			<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn" onclick="renderCustomerList()"/>
			<input type="search" id="customerName" placeholder="Search..."/>
		</div>
		<ul class="list" id="customerListContainer">

		</ul>
	</div>
	<script type="text/javascript">
        $("#customerName").keyup(function(event){
            if(event.keyCode == 13){
                renderCustomerList();
            }
        });
        function customerCallBack(obj){
            var callback = "<%=callback%>";
            if(callback){
                var callbackFn = eval(callback);
                if(typeof(callbackFn) == "function"){
                    var value = $(obj).attr("data-value");
                    var text = $(obj).attr("data-text");
                    callbackFn.call(this,value, text,"customerid",true);
                }
            }
        }
		function renderCustomerList() {
		    var customerName = $("#customerName").val();
            CRM.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getCustomerListForBrowser&customerName="+customerName, function(result){
                var datas = result["datas"];
                var html = "";
                for(var i = 0; i < datas.length; i++){
                    var d = datas[i];
                    html += "<li><a href=\"javascript:void(0);\" data-value=\""+d["id"]+"\" data-text=\""+d["name"]+"\" onclick=\"customerCallBack(this)\">"+d["name"]+"</a></li>";
                }
                $("#customerListContainer").html(html);
            });
        }
        renderCustomerList();
	</script>
</div>
</body>
</html>

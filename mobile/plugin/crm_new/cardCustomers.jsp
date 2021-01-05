<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String customername = Util.null2String(request.getParameter("customername"));
String sep = Util.null2String(request.getParameter("sep"));
%>

<html>
  <head>
    <title>客户列表</title>
    <style type="text/css">
    .cardlist{padding-left: 0; list-style: none; margin: 0;}
    .cardlist li{padding: 0px; font-size: 14px;border-bottom: 1px solid #f4f4f4;position: relative;}
    .cardlist li>a{font-family: Arial; color: #333; -webkit-appearance: none;height: 36px; line-height: 36px; padding-left: 15px;display: block;ransition: transform 0.3s;    text-decoration: none;}
    </style>
  </head>
  
  <body>
  	<div id="crm_cardcustomers" class="page out">
  		<div class="header" data-role="header">
			<div class="left" onclick="javascript:history.go(-1);">匹配到以下客户</div>
		</div>
		
		<div class="content">
			<div class="listSearch">
				<form disabledentersubmit="" action="">
				<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn">
				<input type="search" placeholder="Search..." id="cardsearch">
				</form>
			</div>
			<ul class="cardlist" id="cardlist">
			</ul>
		</div>
  	</div>
  	
  	<script type="text/javascript">
  		$(function(){
  			getCustomerList('<%=customername%>','<%=sep%>');
  			$("#cardsearch").val('<%=customername%>');
  			$(".btn").click(function(){
				$(".cardlist").empty();
				var name = $("#cardsearch").val();
				getCustomerList(name,'<%=sep%>');
			});
			$("#cardsearch").keyup(function(event){
                if(event.keyCode == 13){
                    $(".cardlist").empty();
                    var name = $("#cardsearch").val();
                    getCustomerList(name,'<%=sep%>');
                }
            });
  		})
  	
  		function getCustomerList(name,sep){
			var html = "";
			$.ajax({
			    url: '/mobile/plugin/crm_new/crmAction.jsp?action=getCustomerList&rd='+Math.random()+'&searchKey='+encodeURI(name)+'&pageSize='+20+'&sep='+sep,
			    type: 'POST',
			    data: '{}',
			    dataType:"json",
			    success:function(data){
			    	if(data.status==1){
			    		var datas = data.datas;
			    		if(datas.length>0){
			    			for(var key in datas){
			    				html+="<li><a href=\"javascript:;\" onclick=\"choose(this);history.go(-1);\" value=\""+datas[key].id+"\">"+datas[key].name+"</a></li>";
			    			}
			    		}else{
			    			html+= "<li><div style=\"color:#ccc;font-size: 14px;text-align: center;padding:10px 0px;\">没有数据显示</div></li>";
			    		}
			    		$("#cardlist").append(html);
			    	}else{
			    		alert(data.errMsg);
			    	}
			    }
			})
		}
  	</script>
	</body>
</html>

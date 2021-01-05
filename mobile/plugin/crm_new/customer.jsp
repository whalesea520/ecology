<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String id = Util.null2String(request.getParameter("id"));
CrmShareBase crmShareBase = new CrmShareBase();
//判断是否有查看该客户权限
int sharelevel = crmShareBase.getRightLevelForCRM("" + user.getUID(), id);
if(sharelevel < 1){
	out.println("您没有权限查看该客户");
	return;
}
boolean canEdit = false;
if(sharelevel > 1) canEdit = true;
%>
<html>
<head>
<title>客户明细</title>
</head>
<body>
<div id="crm_cust" class="page out">
	<div class="common_msg">修改成功</div>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
		<div class="right addBtn"></div>
	</div>
	<div class="pop_menu">
		<div class="arrow"></div>
		<ul>
    		<li class="m1"><a href="/mobile/plugin/crm_new/newContactRecord.jsp" data-formdata="id=<%=id%>">新建联系记录</a></li>
    		<li class="m2"><a href="/mobile/plugin/crm_new/crmShareView.jsp" data-formdata="id=<%=id%>">查看共享</a></li>
			<%if(canEdit){%>
    		<li class="m3"><a href="/mobile/plugin/crm_new/crmContactsAdd.jsp" data-formdata="id=<%=id%>">新建联系人</a></li>
    		<%} %>
			<li class="m4"><a href="/mobile/plugin/crm_new/signInout.jsp" data-formdata="id=<%=id%>">签到/签退</a></li>
    	</ul>
	</div>
	<div class="content">
		<label>
			<div>客户经理：</div>
			<div data-field="manager"></div>
		</label>
		<label>
			<div>地址：</div>
			<div class="more" data-field="address"></div>
		</label>	
		<label>
			<div>状态, 级别：</div>
			<div data-field="status_rating"></div>
		</label>
		<label>
			<div>规模, 行业：</div>
			<div data-field="size_n_sector"></div>
		</label>
		<label>
			<div>商机：</div>
			<div class="more" data-field="sellChance"></div>
		</label>
		<label>
			<div>联系人：</div>
			<div class="more" data-field="contacter"></div>
		</label>	
		<div class="title">联系记录</div>
		<ul class="list record"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无联系记录</div>
		<div class="load_more">加载更多</div>
	</div>
	
	<script type="text/javascript">
	
	CRM.buildCustomerPage("<%=id%>", <%=canEdit%>);
	//上传的图片点击放大
	function imgChange_old(obj,imgid) {
		if($(obj).width()==40 && $(obj).height()==40){
			$(obj).css("width","100%");
			$(obj).css("height","100%");
		}else{
			$(obj).css("width","40");
			$(obj).css("height","40");
		}
	}
	function imgChange(obj,imgid) {
	   var allimg = $(obj).attr("_val");
	   var _url = "/mobile/plugin/crm_new/displayPicOnMobile.jsp?imgSrc="+allimg+"&imgSrcActive="+imgid+"";
	   window.open(_url,"_blank");
	}
	function fileDownload(obj) {
	   var val = $(obj).attr("_val");
	   var fid=val.split('-')[0];
	   var fname=val.split('-')[1];
       window.open("/download.do?download=1&fileid="+fid+"&filename="+fname,"_blank");
    }
	
	</script>
</div>
</body>
</html>

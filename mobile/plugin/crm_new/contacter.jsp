<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = MobileUserInit.getUser(request, response);
	if(user == null){
		out.println("无用户，请登录");
		return;
	}
	String id = Util.null2String(request.getParameter("id"));
	rs.executeProc("CRM_CustomerContacter_SByID", id);
	if (rs.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();
	String customerid = rs.getString(2);
	String mobilephone = Util.null2String(rs.getString("mobilephone"));
	String email = Util.null2String(rs.getString("email"));
	CrmShareBase crmShareBase = new CrmShareBase();
	//判断是否有查看该客户权限
	int sharelevel = crmShareBase.getRightLevelForCRM("" + user.getUID(), customerid);
	if(sharelevel < 1){
		out.println("您没有权限查看该客户联系人");
		return;
	}
	boolean canEdit = false;
	if(sharelevel > 1) canEdit = true;
%>
<html>
<head>
	<title>客户联系人查看</title>
</head>
<body>
<div id="crm_contacter_detail" class="page out">
	<div class="form_msg"></div>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
		<%if(canEdit){%><div class="right addBtn"></div><%} %>
	</div>
	<div class="pop_menu">
		<div class="arrow"></div>
		<ul>
			<%if(canEdit){%>
			<li class="m1"><a href="/mobile/plugin/crm_new/contacterEdit.jsp" data-formdata="id=<%=id%>" data-reload="true">名片编辑</a></li>
			<li class="m2"><a onclick="CRM.deleteContacter()">名片删除</a></li>
			<%} %>
		</ul>
	</div>
	<div class="content">
		<div>
			<div data-field="cardImg"></div>
			<div data-field="cardText" style="text-align:center;width:100%;height:auto;background: #0070c1;">
				<div style="padding-top:10px;">
				<div class="crm_contacter_detail_lastname">
					<span class="crm_contacter_detail_lastname_font" data-field="cardLastName">

					</span>
				</div>
				</div>
				<div style="color:white;margin-top:5px;" data-field="cardTitle"></div>
				<div style="color:white;margin-top:5px;height: 30px;" data-field="cardCompany"></div>
			</div>
		</div>
		<%--<label></label>--%>
		<label>
			<div>称呼：</div>
			<div data-field="title"></div>
		</label>
		<%--<label>--%>
			<%--<div>职务：</div>--%>
			<%--<div data-field="jobtitle"></div>--%>
		<%--</label>--%>
		<%--<label>--%>
			<%--<div>部门：</div>--%>
			<%--<div data-field="department"></div>--%>
		<%--</label>--%>
		<label>
			<div>手机号码：</div>
			<div data-field="mobilephone"></div>
		</label>
		<label>
			<div>办公电话：</div>
			<div data-field="phoneoffice"></div>
		</label>
		<label>
			<div>工作邮箱：</div>
			<div data-field="email"></div>
		</label>
		<label>
			<div>公司：</div>
			<div data-field="customerName"></div>
		</label>
		<label>
			<div>公司地址：</div>
			<div class="more" data-field="customerAddress"></div>
		</label>
		<div class="title">联系记录</div>
		<ul class="list record"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无联系记录</div>
		<div class="load_more">加载更多</div>
	</div>

	<script type="text/javascript">

        $.extend(CRM, {
			deleteContacter: function () {
                var that = this;
			    if(confirm("确定删除吗？")){
                    that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=deleteContacter&id=<%=id%>&customerid=<%=customerid%>", function(result){
                        that.refreshCrmList();
                        history.go(-1);
                    });
				}
            }
        });
        CRM.buildContacterPage("<%=id%>", <%=canEdit%>,"<%=customerid%>");
	</script>
</div>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String exe = Util.null2String(request.getParameter("exe"));
	int i=0;
	if(!exe.equals("")){
		//设置所有成功状态客户的默认共享
		String customerid = "";
		rs.executeSql("select id from CRM_CustomerInfo where (deleted=0 or deleted is null) and status in (5,6,8)");
		while(rs.next()){
			customerid = Util.null2String(rs.getString(1));
			CrmShareBase.resetStatusShare(customerid);
			if(exe.equals("2")) CustomerInfoComInfo.updateCustomerInfoCache(customerid);
			i++;
		}
	}
%>
成功重置 <%=i %> 个成功客户的“成功客户管理员角色”默认共享<%if(exe.equals("2")){ %>及缓存<%} %>！



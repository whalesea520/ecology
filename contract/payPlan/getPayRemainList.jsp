<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" id="contractPay"
	class="weaver.contractn.ContractPay" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User usr = HrmUserVarify.getUser(request, response);
	int author = usr.getUID();

	String sql = "select * from hrmrolemembers m LEFT JOIN hrmroles r on m.roleid = r.id where r.rolesname = 'contract_remin_pay' and m.resourceid = "
			+ author;
	rs.executeSql(sql);
	//如果设置了当前登录人员为提醒人员
	if (rs.getCounts() > 0) {
		out.print(contractPay.getPayReminList());
	}
%>




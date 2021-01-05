
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmUserVarify" class="weaver.hrm.HrmUserVarify" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String customerids = Util.null2String(request.getParameter("customerids"));

//获取选中客户的邮箱地址
if("getEmail".equals(method)){
	
	if("".equals(customerids)){
		out.println("");
		return;
	}
	customerids = customerids.substring(0,customerids.length()-1);
	String emails = "";
	rs.execute("select * from CRM_CustomerInfo where email is not null and email !='' and id in ("+customerids+")");
	while(rs.next()){
		emails += rs.getString("email")+",";
	}
	emails =emails.length()>0?emails.substring(0,emails.length()-1):"";
	out.println(emails);
}

//删除选中的客户信息
if("delete".equals(method)){
	User user = new User();
	user.setUid(Util.getIntValue(request.getParameter("userid").trim()));
	user.setLogintype(request.getParameter("logintype").trim());
	user.setLoginid(request.getParameter("loginid").trim());
	String ismanage = Util.null2String(request.getParameter("ismanage"));
	if(customerids.endsWith(","))customerids = customerids.substring(0, customerids.length()-1);
	if("1".equals(ismanage)) {
		if(!HrmUserVarify.checkUserRight("EditCustomer:Delete",user)) { 
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
		
	
	
	if(!"".equals(customerids)) {
	    rs.executeSql("update CRM_CustomerInfo set deleted='1' where id in( "+customerids+")");
	    rs.executeSql("delete from CRM_Contract where crmId in( "+customerids+")");
	    rs.executeSql("update CRM_ShareInfo SET deleted = 1 WHERE relateditemid in ( "+customerids+" )");
	    
	    String[] arr = customerids.split(",");
	    for(int i=0 ; i< arr.length; i++ ) {
	        String Tcrmid=arr[i];
	        CustomerInfoComInfo.deleteCustomerInfoCache(Tcrmid);
	        SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(Tcrmid));
			SysMaintenanceLog.setRelatedName(CustomerInfoComInfo.getCustomerInfoname(Tcrmid));
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("update CRM_CustomerInfo set deleted='1' where id ="+Tcrmid);
			SysMaintenanceLog.setOperateItem("99");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
	    }
	}
}
%>

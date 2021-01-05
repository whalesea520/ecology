
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
//判断是否有批量转移权限
if(!HrmUserVarify.checkUserRight("CRM_BatchTransfer:Operate", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String customerids = Util.null2String(request.getParameter("customerids"));
String toid = Util.null2String(request.getParameter("hrmId"));
String fromid = user.getUID()+"";
int count = 0;
if(!toid.equals("") && !fromid.equals(toid)){
	String departmentId = ResourceComInfo.getDepartmentID(toid);
	String subcompanyid1 = DepartmentComInfo.getSubcompanyid1(departmentId);
	List customerIdList = Util.TokenizerString(customerids,",");
	String customerId = ""; 
	char separator = Util.getSeparator() ;
	String para = "";
	String fieldName = SystemEnv.getHtmlLabelName(144,user.getLanguage());
	String CurrentDate = TimeUtil.getCurrentDateString();
	String CurrentTime = TimeUtil.getOnlyCurrentTimeString();
	String ClientIP = request.getRemoteAddr();
	for(int i=0;i<customerIdList.size();i++){
		customerId = (String)customerIdList.get(i);
		//判断客户经理是否当前用户
		if(fromid.equals(CustomerInfoComInfo.getCustomerInfomanager(customerId))){
			//修改客户经理
			para = fromid + separator + toid + separator + customerId;
			boolean updateSuccess = RecordSet.executeProc("HrmRightTransfer_CRM",para);
			
			if (updateSuccess) {
				//修改客户部门及分部
				RecordSet.executeSql("update CRM_CustomerInfo set department = "+departmentId+",set subcompanyid1="+subcompanyid1+" where id = "+customerId);
				//更新缓存
				CustomerInfoComInfo.updateCustomerInfoCache(customerId);
				//添加修改日志
				para = customerId+separator+"1"+separator+"0"+separator+"0"
				 	+ separator+fieldName+separator+CurrentDate+separator+CurrentTime+separator+fromid+separator+toid
				 	+ separator+fromid+separator+user.getLogintype()+separator+ClientIP;
				RecordSet.executeProc("CRM_Modify_Insert",para);
				
				para = customerId;
				para += separator+"m";
				para += separator+"";
				para += separator+"";
				para += separator+CurrentDate;
				para += separator+CurrentTime;
				para += separator+fromid;
				para += separator+user.getLogintype();
				para += separator+ClientIP;
				RecordSet.executeProc("CRM_Log_Insert",para);
				
				//添加客户的默认共享
			    CrmShareBase.setCRM_WPShare_newCRMManager(customerId);
				
			    count++;
			}
		}
	}
}
response.sendRedirect("TransferMutiCustomerList.jsp?isstart=1&count="+count+"&toid="+toid);
%>

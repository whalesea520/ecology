<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String CustomerID = Util.fromScreen(request.getParameter("CustomerID"),user.getLanguage());
String intentId = Util.fromScreen(request.getParameter("intentId"),user.getLanguage());
String bizTypeId = Util.fromScreen(request.getParameter("bizTypeId"),user.getLanguage());
String expectMoney = Util.getDoubleValue(request.getParameter("expectMoney"),0.00)+"";
String deputizeBrandId = Util.fromScreen(request.getParameter("deputizeBrandId"),user.getLanguage());
String deputizeBrandOther = Util.fromScreen(request.getParameter("deputizeBrandOther"),user.getLanguage());
String projectDemand = Util.convertInput2DB(request.getParameter("projectDemand"));
String projectBudget = Util.getDoubleValue(request.getParameter("projectBudget"),0.00)+"";
String projectPhaseId = Util.getIntValue(request.getParameter("projectPhaseId"),0)+"";
String exploiterId = Util.fromScreen(request.getParameter("exploiterId"),user.getLanguage());
String keyContact = Util.fromScreen(request.getParameter("keyContact"),user.getLanguage());
if(keyContact.equals("on")){
	keyContact = "1";
}else{
	keyContact = "0";
}
//System.out.println("intentId:"+intentId+"-----");
if(operation.equals("edit")){
	
	/*权限判断－－Begin*/
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
	
	String useridcheck=""+user.getUID();
	boolean canedit=false;
	boolean advanceEdit=false;//是否可编辑【开拓人员】字段
	
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;
	
	//开拓人员本人可编辑【开拓人员】字段
	if(exploiterId.equals(useridcheck)){
		canedit=true;
		advanceEdit = true ;
	}
	//如果属于总部级的CRM管理员角色，则能编辑全部。
	String leftjointable = "";
	RecordSet2.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = "+useridcheck);
	if(RecordSet2.next()){
		canedit=true;
		advanceEdit = true ;
	}
	
	if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
		canedit=false;
	}
	
	/*权限判断－－End*/
	if(!canedit && !advanceEdit) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	rs.executeSql("select id from CRM_CustomerChannelInfo where customerId="+CustomerID);
	if(rs.next()){
		String id = rs.getString("id");
		rs.executeSql("update CRM_CustomerChannelInfo set intentId="+intentId+",bizTypeId="+bizTypeId+",expectMoney="+expectMoney
				+",deputizeBrandId="+deputizeBrandId+",deputizeBrandOther='"+deputizeBrandOther+"',projectDemand='"+projectDemand+"',projectBudget="
				+projectBudget+",projectPhaseId="+projectPhaseId+",exploiterId="+exploiterId+",keyContact="+keyContact+" where id="+id);
		
	}else{
		rs.executeSql("insert into CRM_CustomerChannelInfo (customerId,intentId,bizTypeId,expectMoney,deputizeBrandId"
				+",deputizeBrandOther,projectDemand,projectBudget,projectPhaseId,exploiterId,keyContact) "
				+" values ("+CustomerID+","+intentId+","+bizTypeId+","+expectMoney+","+deputizeBrandId+",'"+deputizeBrandOther+"','"
				+projectDemand+"',"+projectBudget+","+projectPhaseId+","+exploiterId+","+keyContact+")");
	}
 	response.sendRedirect("CustomerChannelInfoView.jsp?CustomerID="+CustomerID);
 }
 
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
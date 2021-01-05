<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<%@page import="org.json.JSONObject"%><jsp:useBean id="BudgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String returnStr = "";
boolean getFnaInfoDataBatch = Util.getIntValue(request.getParameter("getFnaInfoDataBatch"),0)==1;//是否批量获取预算信息
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);
if(getFnaInfoDataBatch){
	String[] indexnoArray = request.getParameterValues("indexno");
	if(indexnoArray!=null && indexnoArray.length > 0){
		returnStr = "{\"fnaBudgetInfoArray\":[";
		int indexnoArrayLen = indexnoArray.length;
		for(int i=0;i<indexnoArrayLen;i++){
			int indexno = Util.getIntValue(indexnoArray[i]);
			
			int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype_"+indexno),0);//科目
			int orgtype = Util.getIntValue(request.getParameter("orgtype_"+indexno),0);//报销类型 人员0/部门1/分部2   3/2/1
			int orgid  = Util.getIntValue(request.getParameter("orgid_"+indexno),0);//报销单位
			String applydate  = request.getParameter("applydate_"+indexno);//报销日期
			int dtl_id  = Util.getIntValue(request.getParameter("dtl_id_"+indexno),0);//该明细对应数据库明细表PkId，0表示新增的明细行，无对应数据库记录PkId
			if(orgtype==0){//个人
				orgtype=3;
			}else if(orgtype==1){//部门
				orgtype=2;
			}else if(orgtype==2){//分部
				orgtype=1;
			}else if(orgtype==3){//成本中心
				orgtype=FnaCostCenter.ORGANIZATION_TYPE;
			}
			 
			String infos = BudgetHandler.getBudgetKPI4DWR(applydate,orgtype,orgid,budgetfeetype, true, true, dtl_id, requestid);

			if(i > 0){
				returnStr += ",";
			}
			returnStr += "{\"indexno\":"+indexno+",\"fnainfos\":"+JSONObject.quote(infos)+"}";
		}
		returnStr += "]}";
	}else{
		returnStr = "{\"fnaBudgetInfoArray\":[]}";
	}
}else{
	int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);//科目
	int orgtype = Util.getIntValue(request.getParameter("orgtype"),0);//报销类型 人员0/部门1/分部2   3/2/1
	int orgid  = Util.getIntValue(request.getParameter("orgid"),0);//报销单位
	String applydate  = request.getParameter("applydate");//报销日期
	int dtl_id  = Util.getIntValue(request.getParameter("dtl_id"),0);//该明细对应数据库明细表PkId，0表示新增的明细行，无对应数据库记录PkId
	if(orgtype==0){//个人
		orgtype=3;
	}else if(orgtype==1){//部门
		orgtype=2;
	}else if(orgtype==2){//分部
		orgtype=1;
	}else if(orgtype==3){//成本中心
		orgtype=FnaCostCenter.ORGANIZATION_TYPE;
	}
	 
	String infos = BudgetHandler.getBudgetKPI4DWR(applydate,orgtype,orgid,budgetfeetype, true, true, dtl_id, requestid);
	returnStr = infos;
}
%>   
<%=returnStr%>
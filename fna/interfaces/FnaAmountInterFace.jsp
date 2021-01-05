<%@page import="weaver.hrm.*"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.budget.BudgetPeriod"%><%@page import="weaver.fna.interfaces.BudgetInfoBo"%><%@page import="weaver.fna.interfaces.FnaAmountInterFace"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %><%
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String optype = Util.null2String(request.getParameter("optype"));//费用类型 分部：subcmp；部门：dep；个人：hrm；
User user = HrmUserVarify.getUser(request, response);

StringBuffer returnStr = new StringBuffer();
if("createFnaExpense".equals(optype)){//更新预算信息

	try{
		String[] organizationtypeArray = request.getParameterValues("organizationtype");
		String[] organizationidArray = request.getParameterValues("organizationid");
		String[] applyamountArray = request.getParameterValues("applyamount");
		String[] subjectArray = request.getParameterValues("subject");
		String[] budgetperiodArray = request.getParameterValues("applydate");
		
		List BudgetInfoBoList = new ArrayList();
		int len = organizationtypeArray.length;
		for(int i=0;i<len;i++){
			int organizationtype = Util.getIntValue(organizationtypeArray[i].trim());
			int organizationid = Util.getIntValue(organizationidArray[i].trim());
			double applyamount = Util.getDoubleValue(applyamountArray[i].trim());
			int subject = Util.getIntValue(subjectArray[i].trim());
			String budgetperiod = budgetperiodArray[i].trim();
			
			BudgetInfoBo budgetInfoBo = new BudgetInfoBo(organizationtype, organizationid, applyamount, subject, budgetperiod);
			BudgetInfoBoList.add(budgetInfoBo);
			
		}
		
		String checkBudgetChangeStr = FnaAmountInterFace.checkBudgetChange(BudgetInfoBoList);
		if(!"".equals(checkBudgetChangeStr)){
			returnStr.append("{");
				returnStr.append("\"result\":false,");
				returnStr.append("\"info\":"+JSONObject.quote(FnaAmountInterFace.getAlertInfo(checkBudgetChangeStr,user.getLanguage()))+"");
			returnStr.append("}");
			
		}else{
			for(int i=0;i<len;i++){
				BudgetInfoBo budgetInfoBo = (BudgetInfoBo)BudgetInfoBoList.get(i);

				BudgetPeriod bp = BudgetHandler.getBudgetPeriod(budgetInfoBo.getBudgetperiod(), budgetInfoBo.getSubject());
				
				FnaAmountInterFace.updateAllSupOrganizational(
						budgetInfoBo.getOrganizationtype(), budgetInfoBo.getOrganizationid(), 
						bp.getPeriod(), bp.getPeriodlist(), 
						budgetInfoBo.getSubject()+"", budgetInfoBo.getApplyamount(), 
						true);
				
			}
			
		}
		
	}catch(Exception ex1){
		returnStr.append("{");
			returnStr.append("\"result\":false,");
			returnStr.append("\"info\":"+JSONObject.quote(ex1.getMessage())+"");
		returnStr.append("}");
	}

	//FnaAmountInterFace.updateAllSupOrganizational(organizationtype, organizationid, period, periodlist, subject, budgetAccount, isUpdateSelf);
	
}else if("createFnaExpense".equals(optype)){//使用预算
	try{
		String orgtype = Util.null2String(request.getParameter("orgtype"));//费用类型 分部：subcmp；部门：dep；个人：hrm；
		int orgid  = Util.getIntValue(request.getParameter("orgid"),0);
		String applydate = Util.null2String(request.getParameter("applydate"));
		Double amount = new Double(request.getParameter("amount"));
		int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);
		int type  = Util.getIntValue(request.getParameter("type"),0);
		String requestid = request.getParameter("requestid");
		Integer relatedprj = new Integer(request.getParameter("relatedprj"));
		Integer relatedcrm = new Integer(request.getParameter("relatedcrm"));
		String description = Util.null2String(request.getParameter("description"));
		String debitremark = Util.null2String(request.getParameter("debitremark"));
		
		String guid = FnaAmountInterFace.createFnaExpense(orgtype, orgid, applydate, amount, budgetfeetype, type, requestid, relatedprj, relatedcrm, description, debitremark);
		returnStr.append("{");
			returnStr.append("\"result\":true,");
			returnStr.append("\"guid\":"+JSONObject.quote(guid)+"");
		returnStr.append("}");
		
	}catch(Exception ex1){
		returnStr.append("{");
			returnStr.append("\"result\":false,");
			returnStr.append("\"info\":"+JSONObject.quote(ex1.getMessage())+"");
		returnStr.append("}");
	}
	
}else if("updateFnaExpenseStatus".equals(optype)){//更新预算状态
	try{
		String guid  = request.getParameter("guid");
		int status  = Util.getIntValue(request.getParameter("status"),0);//状态：1生效，0审批中
		
		FnaAmountInterFace.updateFnaExpenseStatus(guid, status);
		returnStr.append("{\"result\":true}");
		
	}catch(Exception ex1){
		returnStr.append("{");
			returnStr.append("\"result\":false,");
			returnStr.append("\"info\":"+JSONObject.quote(ex1.getMessage())+"");
		returnStr.append("}");
	}
	
}else if("removeFnaExpense".equals(optype)){//移除以创建预算
	try{
		String guid  = request.getParameter("guid");
		
		FnaAmountInterFace.removeFnaExpense(guid);
		returnStr.append("{\"result\":true}");
		
	}catch(Exception ex1){
		returnStr.append("{");
			returnStr.append("\"result\":false,");
			returnStr.append("\"info\":"+JSONObject.quote(ex1.getMessage())+"");
		returnStr.append("}");
	}
	
}else{
	returnStr.append("{");
		returnStr.append("\"result\":false,");
		returnStr.append("\"info\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(83339, user.getLanguage()))+"");
	returnStr.append("}");
	
}
%><%=returnStr.toString()%>
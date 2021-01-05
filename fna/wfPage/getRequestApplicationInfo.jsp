<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.workflow.workflow.WorkflowRequestComInfo"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.workflow.browser.BrowserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
DecimalFormat df = new DecimalFormat("#################################################0.00");
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result.append("{\"flag\":false,\"errorInfo\":\"error！\"}");
}else{
	RecordSet rs1 = new RecordSet();
	
	String sqlIsNull = "ISNULL";
	if("oracle".equals(rs1.getDBType())){
		sqlIsNull = "NVL";
	}else if("mysql".equals(rs1.getDBType())){
		sqlIsNull = "ifNULL";
	}
	
	String fysqlc = Util.null2String(request.getParameter("fysqlc")).trim();
	boolean isNewWf = Boolean.valueOf(request.getParameter("isNewWf").trim());
	int dt1_fieldIdReqDtId = Util.getIntValue(request.getParameter("dt1_fieldIdReqDtId"), 0);//明细ID的 fieldID

	RecordSet rs2 = new RecordSet();
	Browser browser = null;
	String sql2222 = " select a.fielddbtype from workflow_billfield a where a.id=?";
	rs2.executeQuery(sql2222, dt1_fieldIdReqDtId);
	if(rs2.next()){
		String fielddbtype = Util.null2String(rs2.getString("fielddbtype")).trim();
		try{
			browser = (Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
		}catch(Exception e){
		}
	}
	

	StringBuffer rowArray = new StringBuffer();
	
	if(!"".equals(fysqlc)){
		WorkflowRequestComInfo workflowRequestComInfo = new WorkflowRequestComInfo();
		FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
		int enableDispalyAll = Util.getIntValue(fnaSystemSetComInfo.get_enableDispalyAll());
		String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
		
		BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();
		FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
		
		HashMap<String, String> requestname_hm = new HashMap<String, String>();
		
		String sqlwhere = FnaCommon.getCanQueryRequestSqlCondition(user, "a", "a");
		
		String _sql = null; 
		//QC295545
		if(isNewWf){
			_sql = "select a.requestid, a.requestidDtlId, a.organizationid, a.organizationtype, a.subject, a.occurdate sourceOccurdate,sum(a.amount) sumAmount \n"+
				" 	from FnaExpenseInfo a "+ 
				" 	where a.requestid in ("+StringEscapeUtils.escapeSql(fysqlc)+") "+
				" 	GROUP BY a.requestid, a.requestidDtlId, a.organizationtype, a.organizationid, a.subject, a.occurdate "+
				" 	HAVING sum("+sqlIsNull+"(a.amount, 0.00)) > 0.00 \n"+
				"   ORDER BY a.requestid, a.requestidDtlId";
		}else{
			_sql = "select * from ( \n"+
				" 	select fei.organizationid, fei.organizationtype, fei.subject, fei.budgetperiods, fei.budgetperiodslist, "+
				" 	MAX(case when (fei.requestid = fei.sourceRequestid) then fei.occurdate else '' end) sourceOccurdate, \n"+
				" 	SUM("+sqlIsNull+"(fei.amount, 0.00)) sumAmount, \n"+
				" 	min(fei.requestid) minRequestid, min(fei.id) minId \n"+
				" 	from workflow_requestbase a "+
				" 	join FnaExpenseInfo fei on a.requestid = fei.requestid "+
				" 	where 1=1 "+sqlwhere+" and a.requestid in ("+StringEscapeUtils.escapeSql(fysqlc)+") "+
				" 	group by fei.organizationid, fei.organizationtype, fei.subject, fei.budgetperiods, fei.budgetperiodslist "+
				" 	HAVING SUM("+sqlIsNull+"(fei.amount, 0.00)) > 0.00 \n"+
				" ) tmpTb1 \n"+
				" order by minRequestid asc, minId asc";
		}
		//out.println("_sql="+_sql);
		rs1.executeQuery(_sql);
		while(rs1.next()){
			int orgid = Util.getIntValue(rs1.getString("organizationid"));
			int orgtype = Util.getIntValue(rs1.getString("organizationtype"));
			int subject = Util.getIntValue(rs1.getString("subject"));
			int budgetperiods = Util.getIntValue(rs1.getString("budgetperiods")); 
			int budgetperiodslist = Util.getIntValue(rs1.getString("budgetperiodslist")); 
			String sourceOccurdate = Util.null2String(rs1.getString("sourceOccurdate")).trim();
			double amount = Util.getDoubleValue(df.format(Util.getDoubleValue(rs1.getString("sumAmount"), 0.00)));
			if(amount > 0.00){
				if(rowArray.length() > 0){
					rowArray.append(",");
				}
				
				String orgtype4SelectVal = "";
				if(orgtype==1){//分部
					orgtype4SelectVal = "2";
				}else if(orgtype==2){//部门
					orgtype4SelectVal = "1";
				}else if(orgtype==3){//个人
					orgtype4SelectVal = "0";
				}else if(orgtype==FnaCostCenter.ORGANIZATION_TYPE){//成本中心
					orgtype4SelectVal = "3";
				}
				String orgname = fnaSplitPageTransmethod.getOrgName(orgid+"", orgtype+"");
				String subjectname = "";
				if(enableDispalyAll==1){
					subjectname = budgetfeeTypeComInfo.getSubjectFullName(subject+"", separator);
				}else{
					subjectname = budgetfeeTypeComInfo.getBudgetfeeTypename(subject+"");
				}
				/*
				String[] retDate = BudgetHandler.getBudgetPeriodArray(budgetperiods, budgetperiodslist, subject);
				String applydate = retDate[0];
				*/

				rowArray.append("{");
				rowArray.append("\"_orgtype\":"+JSONObject.quote(orgtype+"")+",");
				rowArray.append("\"orgtype\":"+JSONObject.quote(orgtype4SelectVal+"")+",");
				rowArray.append("\"applydate\":"+JSONObject.quote(sourceOccurdate+"")+",");
				rowArray.append("\"amount\":"+JSONObject.quote(df.format(amount))+",");
				rowArray.append("\"orgid\":"+JSONObject.quote(orgid+"")+",");
				rowArray.append("\"orgname\":"+JSONObject.quote(orgname+"")+",");
				if(isNewWf){
					int fieldIdReqId = Util.getIntValue(rs1.getString("requestid"));
					int fieldIdReqDtId = Util.getIntValue(rs1.getString("requestidDtlId"));

					String fieldIdReqName = "";
					if(requestname_hm.containsKey(String.valueOf(fieldIdReqId))){
						fieldIdReqName = requestname_hm.get(String.valueOf(fieldIdReqId));
					}else{
						/*
						fieldIdReqName = workflowRequestComInfo.getRequestName(String.valueOf(fieldIdReqId));
						*/
						String sqlll = " select a.requestname from workflow_requestbase a where a.requestid="+String.valueOf(fieldIdReqId);
						rs2.executeQuery(sqlll);
						if(rs2.next()){
							fieldIdReqName = Util.null2String(rs2.getString("requestname")).trim();
							requestname_hm.put(String.valueOf(fieldIdReqId), fieldIdReqName);
						}else{
							requestname_hm.put(String.valueOf(fieldIdReqId), String.valueOf(fieldIdReqId));
						}
					}
					
					rowArray.append("\"fieldIdReqId\":"+JSONObject.quote(String.valueOf(fieldIdReqId))+",");//请求ID值
					rowArray.append("\"fieldIdReqName\":"+JSONObject.quote(fieldIdReqName)+",");//请求名称

					String fieldIdReqDtName = "";
					try{
						if(browser != null){
							BrowserBean bb = browser.searchById(String.valueOf(fieldIdReqId)+"^~^"+String.valueOf(fieldIdReqDtId)+"^~^1");
							fieldIdReqDtName = Util.null2String(bb.getName());
						}
					}catch(Exception e){}
					rowArray.append("\"fieldIdReqDtId\":"+JSONObject.quote(fieldIdReqDtId+"")+",");//明细ID值
					rowArray.append("\"fieldIdReqDtName\":"+JSONObject.quote(fieldIdReqDtName+"")+",");//明细名称
				}
				rowArray.append("\"subject\":"+JSONObject.quote(subject+"")+",");
				rowArray.append("\"subjectname\":"+JSONObject.quote(subjectname+""));
				rowArray.append("}");
			}
		}
		
	}
	
	result.append("{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+
		",\"rowArray\":["+rowArray.toString()+"]"+
		"}");
}
%><%=result.toString() %>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
	int enableDispalyAll = Util.getIntValue(fnaSystemSetComInfo.get_enableDispalyAll());
	String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
	boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter());
	
	int userId = user.getUID();

	String qryType = Util.null2String(request.getParameter("qryType"));

	int filterlevel = Util.getIntValue(request.getParameter("level"),0);
	String displayarchive=Util.null2String(request.getParameter("displayarchive"));//是否显示封存科目
	String fromWfFnaBudgetChgApply=Util.null2String(request.getParameter("fromWfFnaBudgetChgApply")).trim();//=1：来自系统表单预算变更申请单
	int orgType = Util.getIntValue(request.getParameter("orgType"),-1);
	int orgId = Util.getIntValue(request.getParameter("orgId"),-1);
	int orgType2 = Util.getIntValue(request.getParameter("orgType2"),-1);
	int orgId2 = Util.getIntValue(request.getParameter("orgId2"),-1);
	int fromFnaRequest = Util.getIntValue(request.getParameter("fromFnaRequest"),-1);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
	int fieldid = Util.getIntValue(request.getParameter("fieldid"),-1);
	int billid = Util.getIntValue(request.getParameter("billid"),-1);

	int isbill = 0;
	int formid = 0;
	if(workflowid > 0){
		String sql = "select * from workflow_base where id = " + workflowid;
		rs.executeSql(sql);
		if(rs.next()){
			isbill = rs.getInt("isbill");
			formid = Math.abs(rs.getInt("formid"));
		}
	}
	
	Map<String, String> dataMap = new HashMap<String, String>();
	String fnaWfType = FnaCommon.getFnaWfFieldInfo4Expense(workflowid, dataMap);
	
	
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	
	BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();
	
	//系统表单的科目浏览按钮
	if(workflowid!=-1 && fieldid==-1 && billid!=-1){
		rs.executeSql("select * from workflow_billfield where (fieldname = 'subject' or fieldname = 'feetypeid') and billid = " + billid);
		if(rs.next()){
			fieldid = rs.getInt("id");
		}
	}
	
	boolean isFnaFeeWfInfo = false;
	if(workflowid > 0){
		String sql = "select count(*) cnt from fnaFeeWfInfo where workflowid = "+workflowid;
		rs2.executeSql(sql);
		isFnaFeeWfInfo = (rs2.next() && rs2.getInt("cnt") > 0);
	}
	
	
	//路径设置浏览数据过滤
	List<String> subjectList = new ArrayList<String>();
	budgetfeeTypeComInfo.getWfBrowdefListByFeelevel(workflowid+"",fieldid+"", BudgetfeeTypeComInfo.FNAFEETYPE_FIELDTYPE+"", subjectList);
	boolean subjectWfFilter = true;
	if(subjectList.size() == 0){
		subjectWfFilter = false;
	}
	List<String> subjectList_canSelect = new ArrayList<String>();
	if(subjectWfFilter){
		budgetfeeTypeComInfo.getWfBrowdefListByFeelevel_canSelect(workflowid+"",fieldid+"", BudgetfeeTypeComInfo.FNAFEETYPE_FIELDTYPE+"", subjectList_canSelect);
	}
	

	ResourceComInfo rci = new ResourceComInfo();
	int sqlCondOrgType4ftRul = orgType;
	int sqlCondOrgId4ftRul = orgId;
	if(orgType==3){//个人预算
		sqlCondOrgType4ftRul = 2;
		sqlCondOrgId4ftRul = Util.getIntValue(rci.getDepartmentID(orgId+""));
	}
	
	int sqlCondOrgType4ftRul2 = orgType2;
	int sqlCondOrgId4ftRul2 = orgId2;
	if(orgType2==3){//个人预算
		sqlCondOrgType4ftRul2 = 2;
		sqlCondOrgId4ftRul2 = Util.getIntValue(rci.getDepartmentID(orgId2+""));
	}


	if("0".equals(qryType) || "1".equals(qryType)){//按名称查询科目
		String qryName = Util.null2String(request.getParameter("qryName"));

		result.append("{\"dataArray\":[");
		int idx = 0;
		String sql1 = "select a.id, a.name, a.codeName, a.feelevel, a.feeperiod, a.Archive, a.isEditFeeType, a.isEditFeeTypeId from FnaBudgetfeeType a "+
			" where (a.codeName like '%"+StringEscapeUtils.escapeSql(qryName)+"%' or a.name like '%"+StringEscapeUtils.escapeSql(qryName)+"%') "+
			" and a.isEditFeeTypeId > 0 "+
			" ORDER BY a.feelevel, a.displayOrder, a.codeName, a.name, a.id ";
		if("0".equals(qryType)){
			sql1 = "select a.id, a.name, a.codeName, b.orderId, a.feeperiod, a.Archive, a.isEditFeeType, a.isEditFeeTypeId "+
				" from FnaBudgetfeeType a "+
				" join FnaBudgetfeeTypeUsed b on a.id = b.subjectId "+
				" where a.isEditFeeTypeId > 0 "+
				" and b.userId = "+userId+" "+
				" ORDER BY a.feeperiod, b.orderId desc, a.feelevel, a.displayOrder, a.codeName, a.name, a.id ";
		}
		rs1.executeSql(sql1);
		while(rs1.next()){
			String id = rs1.getString("id");
			String name = rs1.getString("name");
			boolean archive = rs1.getInt("Archive")==1;
			int isEditFeeType = Util.getIntValue(rs1.getString("isEditFeeType"));

            if(archive && !"1".equals(displayarchive)){
            	continue;
            }
            
            //路径设置浏览数据过滤
            if(subjectWfFilter && !subjectList_canSelect.contains(id)){
            	continue;
            }
            
        	//如果是【预算变更流程】或者是系统表单【预算变更申请单】的流程，那么科目只有可编制预算是可以选择的
            if(("change".equals(fnaWfType) || (isbill == 1 && formid==159)) && isEditFeeType!=1){
            	continue;
            }
            
            //过滤科目1
            if(isFnaFeeWfInfo && fromFnaRequest == 1 && subjectFilter && sqlCondOrgType4ftRul > 0 && sqlCondOrgId4ftRul > 0){
            	boolean flag = budgetfeeTypeComInfo.checkRuleSetRight(sqlCondOrgType4ftRul, sqlCondOrgId4ftRul, Util.getIntValue(id));
                if(!flag){
                	continue;
                }
            }
            
          	//过滤科目2
            if(isFnaFeeWfInfo && fromFnaRequest == 1 && subjectFilter && sqlCondOrgType4ftRul2 > 0 && sqlCondOrgId4ftRul2 > 0){
            	boolean flag = budgetfeeTypeComInfo.checkRuleSetRight(sqlCondOrgType4ftRul2, sqlCondOrgId4ftRul2, Util.getIntValue(id));
                if(!flag){
                	continue;
                }
            }
          	
            String fullName = name;
            if(enableDispalyAll==1){
            	fullName = budgetfeeTypeComInfo.getSubjectFullName(id, separator);
            }
			
			if(idx>0){
				result.append(",");
			}
			
			result.append("{"+
				"\"id\":"+JSONObject.quote(id)+","+
				"\"name\":"+JSONObject.quote(name)+","+
				"\"fullName\":"+JSONObject.quote(fullName)+""+
				"}");
			idx++;
			
		}
		result.append("]}");
		
	}else if("2".equals(qryType)){//显示科目树
		String supIdFull = Util.null2String(request.getParameter("id"));

		if("".equals(supIdFull)){//初始化组织架构树
			supIdFull = "0_0";
		}
		
		String[] supIdFullArray = supIdFull.split("_");
		int supId = Util.getIntValue(supIdFullArray[1]);
		
		result.append("[");
		int idx = 0;
		String sql1 = "select a.id, a.name, a.feelevel, a.feeperiod, a.Archive, a.isEditFeeType, a.isEditFeeTypeId from FnaBudgetfeeType a "+
			" where a.supsubject = "+supId+" "+
			" ORDER BY a.feeperiod,a.displayOrder,a.codeName, a.name, a.id ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			String id = rs1.getString("id");
			String name = rs1.getString("name");
			int feelevel = Util.getIntValue(rs1.getString("feelevel"));
			boolean archive = rs1.getInt("Archive")==1;
			int isEditFeeTypeId = Util.getIntValue(rs1.getString("isEditFeeTypeId"));
			int isEditFeeType = Util.getIntValue(rs1.getString("isEditFeeType"));

            if(archive && !"1".equals(displayarchive)){
            	continue;
            }
            
            //路径设置浏览数据过滤
            if(subjectWfFilter && !subjectList.contains(id)){
            	continue;
            }

			int canSelect = (isEditFeeTypeId>0)?1:0;
            if(subjectWfFilter && !subjectList_canSelect.contains(id)){
            	canSelect = 0;
            }
            
            if(canSelect==1){ 
        		//如果是【预算变更流程】或者是系统表单【预算变更申请单】的流程，那么科目只有可编制预算是可以选择的
	            if("change".equals(fnaWfType) || (isbill == 1 && formid==159)){
	            	if(isEditFeeType!=1){
	                	canSelect = 0;
		            }
	            	if(isEditFeeTypeId > 0 && Util.getIntValue(id)!=isEditFeeTypeId){
	                	continue;
	            	}
	            }
            }
            
            //过滤科目1
            if(isFnaFeeWfInfo && fromFnaRequest == 1 && subjectFilter && sqlCondOrgType4ftRul > 0 && sqlCondOrgId4ftRul > 0){
            	boolean flag = budgetfeeTypeComInfo.checkRuleSetRight(sqlCondOrgType4ftRul, sqlCondOrgId4ftRul, Util.getIntValue(id));
                if(!flag){
                	continue;
                }
            }
            
          	//过滤科目2
            if(isFnaFeeWfInfo && fromFnaRequest == 1 && subjectFilter && sqlCondOrgType4ftRul2 > 0 && sqlCondOrgId4ftRul2 > 0){
            	boolean flag = budgetfeeTypeComInfo.checkRuleSetRight(sqlCondOrgType4ftRul2, sqlCondOrgId4ftRul2, Util.getIntValue(id));
                if(!flag){
                	continue;
                }
            }
            
            String fullName = name;
            if(enableDispalyAll==1){
            	fullName = budgetfeeTypeComInfo.getSubjectFullName(id, separator);
            }
			
			String isParent = "true";
            if(("change".equals(fnaWfType) || (isbill == 1 && formid==159)) && canSelect==1){
            	//如果是【预算变更流程】或者是系统表单【预算变更申请单】的流程，且，当前科目可以被选中，则它的下级科目都不能选中，所以，可以认为他没有下级科目
				isParent = "false";
            }else{
				String sql2 = "select count(*) cnt from FnaBudgetfeeType a where a.supsubject = "+Util.getIntValue(id);
				rs2.executeSql(sql2);
				if(rs2.next() && rs2.getInt("cnt") > 0){
					isParent = "true";
				}else{
					isParent = "false";
				}
            }
			
			//String icon = "/images/treeimages/home16_wev8.gif";
			
			if(idx>0){
				result.append(",");
			}
			result.append("{"+
				"\"id\":"+JSONObject.quote(feelevel+"_"+id)+","+
				"\"name\":"+JSONObject.quote(name)+","+
				"\"isParent\":"+isParent+","+
				"\"fullName\":"+JSONObject.quote(fullName)+","+
				"\"isEditFeeTypeId\":"+isEditFeeTypeId+","+
				"\"canSelect\":"+canSelect+""+
				//"\"icon\":"+JSONObject.quote(icon)+
				"}");
			idx++;
		}
		result.append("]");
		
	}

}
//System.out.println("result="+result.toString());
%><%=result.toString() %>
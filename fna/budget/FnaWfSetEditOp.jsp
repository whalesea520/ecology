<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.budget.FnaFeeWfInfoComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSetCache"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.fna.general.FnaLanguage"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("add")){//新增、更新：费控流程
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int enable = Util.getIntValue(request.getParameter("enable"), 0);
	String fnaControlSchemeIds = Util.null2String(request.getParameter("fnaControlSchemeIds")).trim();
	String templateFile = Util.null2String(request.getParameter("templateFile")).trim();
	String templateFileMobile = Util.null2String(request.getParameter("templateFileMobile")).trim();
	int fnaWfTypeColl = Util.getIntValue(request.getParameter("fnaWfTypeColl"), 0);
	int fnaWfTypeReverse = Util.getIntValue(request.getParameter("fnaWfTypeReverse"), 0);
	int fnaWfTypeReverseAdvance = Util.getIntValue(request.getParameter("fnaWfTypeReverseAdvance"), 0);
	int budgetCanBeNegative = Util.getIntValue(request.getParameter("budgetCanBeNegative"), 0);

	if("".equals(templateFile)){
		templateFile = FnaWfSet.TEMPLATE_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_FILE_MOBILE;
	}

	File file_templateFile = new File(FnaWfSet.FILE_PATH1+templateFile);
	// 如果文件夹不存在，则创建文件夹
	if (file_templateFile==null || file_templateFile.exists() == false) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("82482,20041",user.getLanguage()))+"}");//模板文件不存在请检查
		out.flush();
		return;
	}

	File file_templateFileMobile = new File(FnaWfSet.FILE_PATH1+templateFileMobile);
	// 如果文件夹不存在，则创建文件夹
	if (file_templateFileMobile==null || file_templateFileMobile.exists() == false) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("82482",user.getLanguage())+
				"("+SystemEnv.getHtmlLabelNames("31506",user.getLanguage())+")"+
				SystemEnv.getHtmlLabelNames("20041",user.getLanguage()))+"}");//模板文件(手机版)不存在请检查
		out.flush();
		return;
	}
	
	String sql = "select count(*) cnt from fnaFeeWfInfo where workflowid = "+workflowid;
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(32141,user.getLanguage()))+"}");//该流程已经被定义，请重新选择流程！
		out.flush();
		return;
		
	}else{
		sql = "INSERT INTO fnaFeeWfInfo \n" +
			" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
			"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim, fnaWfTypeReverseAdvance,budgetCanBeNegative)\n" +
			" VALUES\n" +
			" ("+workflowid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
			" 'fnaFeeWf', 0, "+fnaWfTypeColl+", "+fnaWfTypeReverse+", 1, "+fnaWfTypeReverseAdvance+", "+budgetCanBeNegative+
			")";
		rs.executeSql(sql);

		int id = -1;
		sql = "select id from fnaFeeWfInfo where workflowid = "+workflowid;
		rs.executeSql(sql);
		if(rs.next()){
			id = rs.getInt("id");
		}

		sql = "delete from fnaControlScheme_FeeWfInfo where fnaFeeWfInfoId = "+id;
		rs.executeSql(sql);
		if(!"".equals(fnaControlSchemeIds)){
			String[] fnaControlSchemeIdsArray = fnaControlSchemeIds.split(",");
			for(int i=0;i<fnaControlSchemeIdsArray.length;i++){
				int fnaControlSchemeId = Util.getIntValue(fnaControlSchemeIdsArray[i], 0);
				if(fnaControlSchemeId > 0){
					sql = "insert into fnaControlScheme_FeeWfInfo (fnaControlSchemeId, fnaFeeWfInfoId) values ("+fnaControlSchemeId+", "+id+")";
					rs.executeSql(sql);
				}
			}
		}

		if(fnaWfTypeReverse > 0){
			//"本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！"
			String promptSC = FnaLanguage.getPromptSC_FnaWfSetEditOp(user.getLanguage());
			
			//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
			FnaWfSet.clearOldFnaFeeWfInfoLogicReverseData(workflowid);
			
			FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(id, 
					1, 2, 
					1, 2, 
					0, 0, 
					0, 0, 
					0, 0, 
					promptSC, "", "");
		}

		if(fnaWfTypeReverseAdvance == 1){
			//"本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！"
			String promptSC = FnaLanguage.getPromptSC_FnaWfSetEditPageLogicSetAdvanceReverse(user.getLanguage());
			
			FnaWfSet.saveOrUpdateFnaWfSetLogicAdvanceReverse(id, 
					1, 2, 
					1, 2, 
					0, 0, 
					0, 0, 
					0, 0, 
					promptSC, "", "");
		}
		
		//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
		FnaWfSetCache.clearAllFnaControlSchemeAll();
		
		new FnaFeeWfInfoComInfo().removeCache();
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editBaseInfo")){//保存：基本设置
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int enable = Util.getIntValue(request.getParameter("enable"), 0);
	String fnaControlSchemeIds = Util.null2String(request.getParameter("fnaControlSchemeIds")).trim();
	String templateFile = Util.null2String(request.getParameter("templateFile")).trim();
	String templateFileMobile = Util.null2String(request.getParameter("templateFileMobile")).trim();
	int fnaWfTypeColl = Util.getIntValue(request.getParameter("fnaWfTypeColl"), 0);
	int fnaWfTypeReverse = Util.getIntValue(request.getParameter("fnaWfTypeReverse"), 0);
	int fnaWfTypeReverseAdvance = Util.getIntValue(request.getParameter("fnaWfTypeReverseAdvance"), 0);
	int budgetCanBeNegative = Util.getIntValue(request.getParameter("budgetCanBeNegative"), 0);

	if("".equals(templateFile)){
		templateFile = FnaWfSet.TEMPLATE_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_FILE_MOBILE;
	}

	File file_templateFile = new File(FnaWfSet.FILE_PATH1+templateFile);
	// 如果文件夹不存在，则创建文件夹
	if (file_templateFile==null || file_templateFile.exists() == false) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("64,20041",user.getLanguage()))+"}");//模板不存在请检查
		out.flush();
		return;
	}

	File file_templateFileMobile = new File(FnaWfSet.FILE_PATH1+templateFileMobile);
	// 如果文件夹不存在，则创建文件夹
	if (file_templateFileMobile==null || file_templateFileMobile.exists() == false) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("64",user.getLanguage())+
				"("+SystemEnv.getHtmlLabelNames("31506",user.getLanguage())+")"+
				SystemEnv.getHtmlLabelNames("20041",user.getLanguage()))+"}");//模板(手机版)不存在请检查
		out.flush();
		return;
	}
	
	String sql = "select count(*) cnt from fnaFeeWfInfo where workflowid = "+workflowid+" and id <> "+id;
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(32141,user.getLanguage()))+"}");//该流程已经被定义，请重新选择流程！
		out.flush();
		return;
		
	}else{
		sql = "select workflowid from fnaFeeWfInfo where id = "+id;
		rs.executeSql(sql);
		if(rs.next()){
			int db_workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
			if(db_workflowid!=workflowid){
				sql = "delete from fnaFeeWfInfoField where mainId = "+id;
				rs.executeSql(sql);
				//sql = "delete from fnaFeeWfInfoLogic where mainId = "+id;
				//rs.executeSql(sql);
				sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+db_workflowid;
				rs.executeSql(sql);
				
				FnaWfSet.saveActionSet2Wf("", "", "", 
						"", "", "", 
						"", "", "", 
						db_workflowid);
				
				FnaWfSet.saveActionSet2WfReplayment("", "", "", 
						"", "", "", 
						"", "", "", 
						db_workflowid);
				
				FnaWfSet.saveActionSet2WfAdvanceReplayment("", "", "", 
						"", "", "", 
						"", "", "", 
						db_workflowid);
			}
		}
		
		sql = "update fnaFeeWfInfo \n" +
			" set workflowid = "+workflowid+", "+
			" enable = "+enable+", "+
			" lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"', \n" +
			" templateFile = '"+StringEscapeUtils.escapeSql(templateFile)+"', \n" +
			" templateFileMobile = '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', \n" +
			" fnaWfTypeColl = "+fnaWfTypeColl+", \n" +
			" fnaWfTypeReverse = "+fnaWfTypeReverse+", \n" +
			" fnaWfTypeReverseAdvance = "+fnaWfTypeReverseAdvance+", \n" +
			" budgetCanBeNegative = "+budgetCanBeNegative+" \n"+
			" where id = "+id;
		rs.executeSql(sql);

		sql = "delete from fnaControlScheme_FeeWfInfo where fnaFeeWfInfoId = "+id;
		rs.executeSql(sql);
		if(!"".equals(fnaControlSchemeIds)){
			String[] fnaControlSchemeIdsArray = fnaControlSchemeIds.split(",");
			for(int i=0;i<fnaControlSchemeIdsArray.length;i++){
				int fnaControlSchemeId = Util.getIntValue(fnaControlSchemeIdsArray[i], 0);
				if(fnaControlSchemeId > 0){
					sql = "insert into fnaControlScheme_FeeWfInfo (fnaControlSchemeId, fnaFeeWfInfoId) values ("+fnaControlSchemeId+", "+id+")";
					rs.executeSql(sql);
				}
			}
		}
		
		if(enable==1){
			String retStr = FnaWfSet.fnaWfSetRightOp_save(id, user);
			if(!"".equals(retStr)){				
				sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
				rs.executeSql(sql);
				
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(retStr)+"}");//保存失败
				out.flush();
				return;
			}
		}else{
			sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
			rs.executeSql(sql);
		}
		
		//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
		FnaWfSetCache.clearAllFnaControlSchemeAll();
		
		new FnaFeeWfInfoComInfo().removeCache();

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editActionSet")){//保存：费控动作
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	String frozeNode1Ids = Util.null2String(request.getParameter("frozeNode1Ids")).trim();//冻结-节点前附加操作
	String frozeNode2Ids = Util.null2String(request.getParameter("frozeNode2Ids")).trim();//冻结-节点后附加操作
	String frozeNode3Ids = Util.null2String(request.getParameter("frozeNode3Ids")).trim();//冻结-出口附加操作
	String deductNode1Ids = Util.null2String(request.getParameter("deductNode1Ids")).trim();//扣除-节点前附加操作
	String deductNode2Ids = Util.null2String(request.getParameter("deductNode2Ids")).trim();//扣除-节点后附加操作
	String deductNode3Ids = Util.null2String(request.getParameter("deductNode3Ids")).trim();//扣除-出口附加操作
	String releaseNode1Ids = Util.null2String(request.getParameter("releaseNode1Ids")).trim();//释放-节点前附加操作
	String releaseNode2Ids = Util.null2String(request.getParameter("releaseNode2Ids")).trim();//释放-节点后附加操作
	String releaseNode3Ids = Util.null2String(request.getParameter("releaseNode3Ids")).trim();//释放-出口附加操作

	String freezeBorrowNode1Ids = Util.null2String(request.getParameter("freezeBorrowNode1Ids")).trim();//冻结借款-节点前附加操作
	String freezeBorrowNode2Ids = Util.null2String(request.getParameter("freezeBorrowNode2Ids")).trim();//冻结借款-节点后附加操作
	String freezeBorrowNode3Ids = Util.null2String(request.getParameter("freezeBorrowNode3Ids")).trim();//冻结借款-出口附加操作

	String repaymentBorrowNode1Ids = Util.null2String(request.getParameter("repaymentBorrowNode1Ids")).trim();//冲销借款-节点前附加操作
	String repaymentBorrowNode2Ids = Util.null2String(request.getParameter("repaymentBorrowNode2Ids")).trim();//冲销借款-节点后附加操作
	String repaymentBorrowNode3Ids = Util.null2String(request.getParameter("repaymentBorrowNode3Ids")).trim();//冲销借款-出口附加操作

	String releaseFreezeBorrowNode1Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode1Ids")).trim();//释放冻结借款-节点前附加操作
	String releaseFreezeBorrowNode2Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode2Ids")).trim();//释放冻结借款-节点后附加操作
	String releaseFreezeBorrowNode3Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode3Ids")).trim();//释放冻结借款-出口附加操作
	
	String freezeAdvanceNode1Ids = Util.null2String(request.getParameter("freezeAdvanceNode1Ids")).trim();//冻结预付款-节点前附加操作
	String freezeAdvanceNode2Ids = Util.null2String(request.getParameter("freezeAdvanceNode2Ids")).trim();//冻结预付款-节点后附加操作
	String freezeAdvanceNode3Ids = Util.null2String(request.getParameter("freezeAdvanceNode3Ids")).trim();//冻结预付款-出口附加操作

	String repaymentAdvanceNode1Ids = Util.null2String(request.getParameter("repaymentAdvanceNode1Ids")).trim();//冲销预付款-节点前附加操作
	String repaymentAdvanceNode2Ids = Util.null2String(request.getParameter("repaymentAdvanceNode2Ids")).trim();//冲销预付款-节点后附加操作
	String repaymentAdvanceNode3Ids = Util.null2String(request.getParameter("repaymentAdvanceNode3Ids")).trim();//冲销预付款-出口附加操作

	String releaseFreezeAdvanceNode1Ids = Util.null2String(request.getParameter("releaseFreezeAdvanceNode1Ids")).trim();//释放冻结预付款-节点前附加操作
	String releaseFreezeAdvanceNode2Ids = Util.null2String(request.getParameter("releaseFreezeAdvanceNode2Ids")).trim();//释放冻结预付款-节点后附加操作
	String releaseFreezeAdvanceNode3Ids = Util.null2String(request.getParameter("releaseFreezeAdvanceNode3Ids")).trim();//释放冻结预付款-出口附加操作
	
	String sql = "";
	
	FnaWfSet.saveActionSet2Wf(frozeNode1Ids, frozeNode2Ids, frozeNode3Ids, 
			deductNode1Ids, deductNode2Ids, deductNode3Ids, 
			releaseNode1Ids, releaseNode2Ids, releaseNode3Ids, 
			workflowid);
	
	FnaWfSet.saveActionSet2WfReplayment(freezeBorrowNode1Ids, freezeBorrowNode2Ids, freezeBorrowNode3Ids, 
			repaymentBorrowNode1Ids, repaymentBorrowNode2Ids, repaymentBorrowNode3Ids, 
			releaseFreezeBorrowNode1Ids, releaseFreezeBorrowNode2Ids, releaseFreezeBorrowNode3Ids, 
			workflowid);
	
	FnaWfSet.saveActionSet2WfAdvanceReplayment(freezeAdvanceNode1Ids, freezeAdvanceNode2Ids, freezeAdvanceNode3Ids, 
			repaymentAdvanceNode1Ids, repaymentAdvanceNode2Ids, repaymentAdvanceNode3Ids, 
			releaseFreezeAdvanceNode1Ids, releaseFreezeAdvanceNode2Ids, releaseFreezeAdvanceNode3Ids, 
			workflowid);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("editFieldSet")){//保存：费控字段
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);

	int main_fieldIdSqr = Util.getIntValue(request.getParameter("main_fieldIdSqr"), 0);
	int main_fieldIdFysqlc = Util.getIntValue(request.getParameter("main_fieldIdFysqlc"), 0);
	int main_fieldIdSfbxwc = Util.getIntValue(request.getParameter("main_fieldIdSfbxwc"), 0);
	int main_fieldIdYfkZfHj = Util.getIntValue(request.getParameter("main_fieldIdYfkZfHj"), 0);

	int main_showSqr = Util.getIntValue(request.getParameter("main_showSqr"), 0);
	int main_showFysqlc = Util.getIntValue(request.getParameter("main_showFysqlc"), 0);
	int main_showSfbxwc = Util.getIntValue(request.getParameter("main_showSfbxwc"), 0);
	int main_showAllTypeYfkZfHj = Util.getIntValue(request.getParameter("main_showAllTypeYfkZfHj"), 0);

	int main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"), 0);

	int main_fieldIdFysqlc_isWfFieldLinkage = Util.getIntValue(request.getParameter("main_fieldIdFysqlc_isWfFieldLinkage"), 0);
	int controlflowSubmission = Util.getIntValue(request.getParameter("controlflowSubmission"), 0);
	
	int fieldIdSubject = Util.getIntValue(request.getParameter("fieldIdSubject"), 0);
	int fieldIdOrgType = Util.getIntValue(request.getParameter("fieldIdOrgType"), 0);
	int fieldIdOrgId = Util.getIntValue(request.getParameter("fieldIdOrgId"), 0);
	int fieldIdOccurdate = Util.getIntValue(request.getParameter("fieldIdOccurdate"), 0);
	int fieldIdAmount = Util.getIntValue(request.getParameter("fieldIdAmount"), 0);
	int fieldIdHrmInfo = Util.getIntValue(request.getParameter("fieldIdHrmInfo"), 0);
	int fieldIdDepInfo = Util.getIntValue(request.getParameter("fieldIdDepInfo"), 0);
	int fieldIdSubInfo = Util.getIntValue(request.getParameter("fieldIdSubInfo"), 0);
	int fieldIdFccInfo = Util.getIntValue(request.getParameter("fieldIdFccInfo"), 0);
	int fieldIdReqId = Util.getIntValue(request.getParameter("fieldIdReqId"), 0);
	int fieldIdReqDtId = Util.getIntValue(request.getParameter("fieldIdReqDtId"), 0);
	
	if(main_fieldIdFysqlc == 0){
		fieldIdReqId = 0;
		fieldIdReqDtId = 0;
	}

	int showAllTypeSubject = Util.getIntValue(request.getParameter("showAllTypeSubject"), 0);
	int showAllTypeOrgType = Util.getIntValue(request.getParameter("showAllTypeOrgType"), 0);
	int showAllTypeOrgId = Util.getIntValue(request.getParameter("showAllTypeOrgId"), 0);
	int showAllTypeOccurdate = Util.getIntValue(request.getParameter("showAllTypeOccurdate"), 0);
	int showAllTypeAmount = Util.getIntValue(request.getParameter("showAllTypeAmount"), 0);
	int showAllTypeHrmInfo = Util.getIntValue(request.getParameter("showAllTypeHrmInfo"), 0);
	int showAllTypeDepInfo = Util.getIntValue(request.getParameter("showAllTypeDepInfo"), 0);
	int showAllTypeSubInfo = Util.getIntValue(request.getParameter("showAllTypeSubInfo"), 0);
	int showAllTypeFccInfo = Util.getIntValue(request.getParameter("showAllTypeFccInfo"), 0);

	int automaticTakeOrgId = Util.getIntValue(request.getParameter("automaticTakeOrgId"), 0);

	int dt2_fieldIdJklc = Util.getIntValue(request.getParameter("dt2_fieldIdJklc"), 0);
	int dt2_fieldIdJkdh = Util.getIntValue(request.getParameter("dt2_fieldIdJkdh"), 0);
	int dt2_fieldIdDnxh = Util.getIntValue(request.getParameter("dt2_fieldIdDnxh"), 0);
	int dt2_fieldIdJkje = Util.getIntValue(request.getParameter("dt2_fieldIdJkje"), 0);
	int dt2_fieldIdYhje = Util.getIntValue(request.getParameter("dt2_fieldIdYhje"), 0);
	int dt2_fieldIdSpzje = Util.getIntValue(request.getParameter("dt2_fieldIdSpzje"), 0);
	int dt2_fieldIdWhje = Util.getIntValue(request.getParameter("dt2_fieldIdWhje"), 0);
	int dt2_fieldIdCxje = Util.getIntValue(request.getParameter("dt2_fieldIdCxje"), 0);
	
	int dt2_showJklc = Util.getIntValue(request.getParameter("dt2_showJklc"), 0);
	int dt2_showJkdh = Util.getIntValue(request.getParameter("dt2_showJkdh"), 0);
	int dt2_showDnxh = Util.getIntValue(request.getParameter("dt2_showDnxh"), 0);
	int dt2_showJkje = Util.getIntValue(request.getParameter("dt2_showJkje"), 0);
	int dt2_showYhje = Util.getIntValue(request.getParameter("dt2_showYhje"), 0);
	int dt2_showSpzje = Util.getIntValue(request.getParameter("dt2_showSpzje"), 0);
	int dt2_showWhje = Util.getIntValue(request.getParameter("dt2_showWhje"), 0);
	int dt2_showCxje = Util.getIntValue(request.getParameter("dt2_showCxje"), 0);


	int dt3_fieldIdSkfs = Util.getIntValue(request.getParameter("dt3_fieldIdSkfs"), 0);
	int dt3_fieldIdSkje = Util.getIntValue(request.getParameter("dt3_fieldIdSkje"), 0);
	int dt3_fieldIdKhyh = Util.getIntValue(request.getParameter("dt3_fieldIdKhyh"), 0);
	int dt3_fieldIdHuming = Util.getIntValue(request.getParameter("dt3_fieldIdHuming"), 0);
	int dt3_fieldIdSkzh = Util.getIntValue(request.getParameter("dt3_fieldIdSkzh"), 0);
	
	int dt3_showSkfs = Util.getIntValue(request.getParameter("dt3_showSkfs"), 0);
	int dt3_showSkje = Util.getIntValue(request.getParameter("dt3_showSkje"), 0);
	int dt3_showKhyh = Util.getIntValue(request.getParameter("dt3_showKhyh"), 0);
	int dt3_showHuming = Util.getIntValue(request.getParameter("dt3_showHuming"), 0);
	int dt3_showSkzh = Util.getIntValue(request.getParameter("dt3_showSkzh"), 0);

	int dt4_fieldIdYfklc = Util.getIntValue(request.getParameter("dt4_fieldIdYfklc"), 0);
	int dt4_fieldIdYfkdh = Util.getIntValue(request.getParameter("dt4_fieldIdYfkdh"), 0);
	int dt4_fieldIdDnxh = Util.getIntValue(request.getParameter("dt4_fieldIdDnxh"), 0);
	int dt4_fieldIdYfkje = Util.getIntValue(request.getParameter("dt4_fieldIdYfkje"), 0);
	int dt4_fieldIdYhje = Util.getIntValue(request.getParameter("dt4_fieldIdYhje"), 0);
	int dt4_fieldIdSpzje = Util.getIntValue(request.getParameter("dt4_fieldIdSpzje"), 0);
	int dt4_fieldIdWhje = Util.getIntValue(request.getParameter("dt4_fieldIdWhje"), 0);
	int dt4_fieldIdCxje = Util.getIntValue(request.getParameter("dt4_fieldIdCxje"), 0);
	
	int dt4_showYfklc = Util.getIntValue(request.getParameter("dt4_showYfklc"), 0);
	int dt4_showYfkdh = Util.getIntValue(request.getParameter("dt4_showYfkdh"), 0);
	int dt4_showDnxh = Util.getIntValue(request.getParameter("dt4_showDnxh"), 0);
	int dt4_showYfkje = Util.getIntValue(request.getParameter("dt4_showYfkje"), 0);
	int dt4_showYhje = Util.getIntValue(request.getParameter("dt4_showYhje"), 0);
	int dt4_showSpzje = Util.getIntValue(request.getParameter("dt4_showSpzje"), 0);
	int dt4_showWhje = Util.getIntValue(request.getParameter("dt4_showWhje"), 0);
	int dt4_showCxje = Util.getIntValue(request.getParameter("dt4_showCxje"), 0);

	int fieldIdSubject_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubject, null);
	int fieldIdOrgType_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgType, null);
	int fieldIdOrgId_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgId, null);
	int fieldIdOccurdate_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOccurdate, null);
	int fieldIdAmount_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdAmount, null);
	int fieldIdHrmInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdHrmInfo, null);
	int fieldIdDepInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdDepInfo, null);
	int fieldIdSubInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubInfo, null);
	int fieldIdFccInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdFccInfo, null);
	
	//进行校验
	boolean dt1_haveIsDtlField = (1==fieldIdSubject_isDtl||1==fieldIdOrgType_isDtl||1==fieldIdOrgId_isDtl||1==fieldIdOccurdate_isDtl);

	int fieldIdBudgetInfo = 0;
	int showAllTypeBudgetInfo = 0;
	int fieldIdBudgetInfo_isDtl = 0;
	if(fieldIdBudgetInfo <= 0 && fieldIdHrmInfo > 0){
		fieldIdBudgetInfo = fieldIdHrmInfo;showAllTypeBudgetInfo = showAllTypeHrmInfo;fieldIdBudgetInfo_isDtl = fieldIdHrmInfo_isDtl;
	}
	if(fieldIdBudgetInfo <= 0 && fieldIdDepInfo > 0){
		fieldIdBudgetInfo = fieldIdDepInfo;showAllTypeBudgetInfo = showAllTypeDepInfo;fieldIdBudgetInfo_isDtl = fieldIdDepInfo_isDtl;
	}
	if(fieldIdBudgetInfo <= 0 && fieldIdSubInfo > 0){
		fieldIdBudgetInfo = fieldIdSubInfo;showAllTypeBudgetInfo = showAllTypeSubInfo;fieldIdBudgetInfo_isDtl = fieldIdSubInfo_isDtl;
	}
	if(fieldIdBudgetInfo <= 0 && fieldIdFccInfo > 0){
		fieldIdBudgetInfo = fieldIdFccInfo;showAllTypeBudgetInfo = showAllTypeFccInfo;fieldIdBudgetInfo_isDtl = fieldIdFccInfo_isDtl;
	}
	if(fieldIdBudgetInfo > 0){
		if(fieldIdHrmInfo <= 0){
			fieldIdHrmInfo=fieldIdBudgetInfo;showAllTypeHrmInfo=showAllTypeBudgetInfo;fieldIdHrmInfo_isDtl=fieldIdBudgetInfo_isDtl;
		}
		if(fieldIdDepInfo <= 0){
			fieldIdDepInfo=fieldIdBudgetInfo;showAllTypeDepInfo=showAllTypeBudgetInfo;fieldIdDepInfo_isDtl=fieldIdBudgetInfo_isDtl;
		}
		if(fieldIdSubInfo <= 0){
			fieldIdSubInfo=fieldIdBudgetInfo;showAllTypeSubInfo=showAllTypeBudgetInfo;fieldIdSubInfo_isDtl=fieldIdBudgetInfo_isDtl;
		}
		if(fieldIdFccInfo <= 0){
			fieldIdFccInfo=fieldIdBudgetInfo;showAllTypeFccInfo=showAllTypeBudgetInfo;fieldIdFccInfo_isDtl=fieldIdBudgetInfo_isDtl;
		}
	}
	
	if(fieldIdOrgType_isDtl!=fieldIdOrgId_isDtl){
		//当承担主体选择主表（明细表）字段时，承担主体类型也必须是主表（明细表）字段！
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126794,user.getLanguage()))+"}");
		out.flush();
		return;
	}

	if(fieldIdSubject_isDtl==1 || fieldIdOrgType_isDtl==1 || fieldIdOrgId_isDtl==1 || fieldIdOccurdate_isDtl==1){
		if(fieldIdAmount_isDtl==0){
			//当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【报销金额】必须也是明细字段，请调整字段对应关系！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382393,user.getLanguage()))+"}");
			out.flush();
			return;
		}else if(fieldIdHrmInfo_isDtl==0 || fieldIdDepInfo_isDtl==0 || fieldIdSubInfo_isDtl==0 || fieldIdFccInfo_isDtl==0){
			//当【报销金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382394,user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}

	RecordSet rs2 = new RecordSet();
	{
		int bxMx_orgType_min_selectvalue = -1;
		int bxMx_orgType_max_selectvalue = -1;
		rs2.executeQuery("select max(a.pubid) pubid, min(a.selectvalue) min_selectvalue, max(a.selectvalue) max_selectvalue from workflow_SelectItem a where a.fieldid = "+fieldIdOrgType);
		if(rs2.next()){
			bxMx_orgType_min_selectvalue = rs2.getInt("min_selectvalue");
			bxMx_orgType_max_selectvalue = rs2.getInt("max_selectvalue");
		}
		if(bxMx_orgType_min_selectvalue<0 || bxMx_orgType_max_selectvalue>3){
			//【承担主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382399,user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}
	{
		if(main_fieldIdSfbxwc > 0){
			int _main_showSfbxwc_min_selectvalue = -1;
			int _main_showSfbxwc_max_selectvalue = -1;
			rs2.executeQuery("select max(a.pubid) pubid, min(a.selectvalue) min_selectvalue, max(a.selectvalue) max_selectvalue from workflow_SelectItem a where a.fieldid = "+main_fieldIdSfbxwc);
			if(rs2.next()){
				_main_showSfbxwc_min_selectvalue = rs2.getInt("min_selectvalue");
				_main_showSfbxwc_max_selectvalue = rs2.getInt("max_selectvalue");
			}
			if(_main_showSfbxwc_min_selectvalue<0 || _main_showSfbxwc_max_selectvalue>1){
				//【是否报销完成】可选项范围只能是0、1；0：否；1：是，请检查！
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382440,user.getLanguage()))+"}");
				out.flush();
				return;
			}
		}
	}
	
	int[] fieldTypeArray = new int[]{1, 2, 3, 4, 
			1, 2, 3, 4, 5, 6, 7, 8, 9, 1000, 1010, 
			1, 2, 3, 4, 5, 6, 7, 8, 
			1, 2, 3, 4, 5, 
			1, 2, 3, 4, 5, 6, 7, 8};
	int[] fieldIdArray = new int[]{main_fieldIdSqr, main_fieldIdFysqlc, main_fieldIdSfbxwc, main_fieldIdYfkZfHj, 
			fieldIdSubject, fieldIdOrgType, fieldIdOrgId, fieldIdOccurdate, fieldIdAmount, fieldIdHrmInfo, fieldIdDepInfo, fieldIdSubInfo, fieldIdFccInfo, fieldIdReqId, fieldIdReqDtId, 
			dt2_fieldIdJklc, dt2_fieldIdJkdh, dt2_fieldIdDnxh, dt2_fieldIdJkje, dt2_fieldIdYhje, dt2_fieldIdSpzje, dt2_fieldIdWhje, dt2_fieldIdCxje, 
			dt3_fieldIdSkfs, dt3_fieldIdSkje, dt3_fieldIdKhyh, dt3_fieldIdHuming, dt3_fieldIdSkzh, 
			dt4_fieldIdYfklc, dt4_fieldIdYfkdh, dt4_fieldIdDnxh, dt4_fieldIdYfkje, dt4_fieldIdYhje, dt4_fieldIdSpzje, dt4_fieldIdWhje, dt4_fieldIdCxje};
	int[] isDtlArray = new int[]{0, 0, 0, 0, 
			fieldIdSubject_isDtl, fieldIdOrgType_isDtl, fieldIdOrgId_isDtl, fieldIdOccurdate_isDtl, fieldIdAmount_isDtl, fieldIdHrmInfo_isDtl, fieldIdDepInfo_isDtl, fieldIdSubInfo_isDtl, fieldIdFccInfo_isDtl, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1};
	int[] showAllTypeArray = new int[]{main_showSqr, main_showFysqlc, main_showSfbxwc, main_showAllTypeYfkZfHj, 
			showAllTypeSubject, showAllTypeOrgType, showAllTypeOrgId, showAllTypeOccurdate, showAllTypeAmount, showAllTypeHrmInfo, showAllTypeDepInfo, showAllTypeSubInfo, showAllTypeFccInfo, 0, 0, 
			dt2_showJklc, dt2_showJkdh, dt2_showDnxh, dt2_showJkje, dt2_showYhje, dt2_showSpzje, dt2_showWhje, dt2_showCxje, 
			dt3_showSkfs, dt3_showSkje, dt3_showKhyh, dt3_showHuming, dt3_showSkzh, 
			dt4_showYfklc, dt4_showYfkdh, dt4_showDnxh, dt4_showYfkje, dt4_showYhje, dt4_showSpzje, dt4_showWhje, dt4_showCxje};
	int[] dtlNumberArray = new int[]{0, 0, 0, 0, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			2, 2, 2, 2, 2, 2, 2, 2, 
			3, 3, 3, 3, 3, 
			4, 4, 4, 4, 4, 4, 4, 4};
	int[] automaticTakeArray = new int[]{0, 0, 0, 0, 
			0, 0, automaticTakeOrgId, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0};
	
	String sql = "";
	
	int fieldTypeArrayLen = fieldTypeArray.length;
	for(int i=0;i<fieldTypeArrayLen;i++){
		int fieldType = fieldTypeArray[i];
		int fieldId = fieldIdArray[i];
		int isDtl = isDtlArray[i];
		int showAllType = showAllTypeArray[i];
		int dtlNumber = dtlNumberArray[i];
		int automaticTake = automaticTakeArray[i];
		int controlBorrowingWf = 0;
		if(dtlNumber==0 && fieldType==1){
			controlBorrowingWf = main_fieldIdSqr_controlBorrowingWf;
		}

		sql = "select id from fnaFeeWfInfoField where mainId="+mainId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql = "update fnaFeeWfInfoField "+
				" set workflowid="+workflowid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+", automaticTake = "+automaticTake+", isWfFieldLinkage = 0, "+
				" controlBorrowingWf = "+controlBorrowingWf+" "+
				" where id="+id;
			rs.executeSql(sql);
		}else{
			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber, automaticTake, isWfFieldLinkage, controlBorrowingWf) "+
				" values ("+
				" "+mainId+", "+workflowid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+", "+automaticTake+", 0, "+controlBorrowingWf+" "+
				")";
			rs.executeSql(sql);
		}
	}
	
	sql = "update fnaFeeWfInfoField \n" +
		" set isWfFieldLinkage = "+main_fieldIdFysqlc_isWfFieldLinkage+" \n" +
		" where dtlNumber = 0 and isDtl = 0 and fieldType = 2 and mainId = "+mainId;
	rs.executeSql(sql);
	
	sql = "update fnaFeeWfInfoField \n" +
			" set controlflowSubmission = "+controlflowSubmission+" \n" +
			" where dtlNumber = 0 and isDtl = 0 and fieldType = 2 and mainId = "+mainId;
	rs.executeSql(sql);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);

	sql = "select enable from fnaFeeWfInfo where id = "+mainId;
	rs.executeSql(sql);
	if(rs.next()){
		int enable = rs.getInt("enable");
		if(enable==1){
			String retStr = FnaWfSet.fnaWfSetRightOp_save(mainId, user);
			if(!"".equals(retStr)){				
				sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
				rs.executeSql(sql);
				
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(retStr)+"}");//保存失败
				out.flush();
				return;
			}
		}else{
			sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
			rs.executeSql(sql);
		}
	}else{
		sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
		rs.executeSql(sql);
	}

	//移除指定workflowId缓存中的-自定义费控流程流程的字段对应关系Map对象
	FnaWfSetCache.removeFnaWfFieldSetMap(workflowid);
	//通过读取配置信息更新缓存
	FnaCommon.getFnaWfFieldInfo4Expense(workflowid, new HashMap<String, String>());
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("del") || operation.equals("batchDel")){//删除、批量删除费控流程
	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("del")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "select workflowid from fnaFeeWfInfo where id in ("+ids+")";
	rs.executeSql(sql);
	while(rs.next()){
		int workflowid = rs.getInt("workflowid");
		sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
		rs.executeSql(sql);

		FnaWfSet.saveActionSet2Wf("", "", "", 
				"", "", "", 
				"", "", "", 
				workflowid);
		
		FnaWfSet.saveActionSet2WfReplayment("", "", "", 
				"", "", "", 
				"", "", "", 
				workflowid);
		
		FnaWfSet.saveActionSet2WfAdvanceReplayment("", "", "", 
				"", "", "", 
				"", "", "", 
				workflowid);
		
		//移除指定workflowId缓存中的-自定义费控流程流程的字段对应关系Map对象
		FnaWfSetCache.removeFnaWfFieldSetMap(workflowid);
	}

	sql = "delete from fnaFeeWfInfoLogicAdvanceR where MAINID in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaFeeWfInfoLogicReverse where MAINID in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaControlScheme_FeeWfInfo where fnaFeeWfInfoId in ("+ids+")";
	rs.executeSql(sql);
	
	sql = "delete from fnaFeeWfInfoLogic where mainid in ("+ids+")";
	rs.executeSql(sql);
	
	sql = "delete from fnaFeeWfInfoField where mainid in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaFeeWfInfo where id in ("+ids+")";
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("enable")){//启用、禁用 费控流程
	int id = Util.getIntValue(request.getParameter("id"));
	int enable = 0;
	
	String sql = "select enable, workflowid from fnaFeeWfInfo where id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		enable = rs.getInt("enable");
		int workflowid = rs.getInt("workflowid");
		
		if(enable == 1){
			enable = 0;
		}else{
			enable = 1;
		}

		if(enable==1){
			String retStr = FnaWfSet.fnaWfSetRightOp_save(id, user);
			if(!"".equals(retStr)){				
				sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
				rs.executeSql(sql);
				
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(retStr)+"}");//保存失败
				out.flush();
				return;
			}
		}else{
			sql = "update workflow_base set custompage='', custompage4Emoble='' where id = "+workflowid;
			rs.executeSql(sql);
		}

		sql = "update fnaFeeWfInfo set enable = "+enable+" where id = "+id;
		rs.executeSql(sql);
	}
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote("")+",\"enable\":"+enable+"}");
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetLogicEditPage")){//保存：校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int intensity = Util.getIntValue(request.getParameter("intensity"), 0);
	int kmIdsCondition = Util.getIntValue(request.getParameter("kmIdsCondition"), 0);
	int orgIdsCondition = Util.getIntValue(request.getParameter("orgIdsCondition"), 0);
	String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
	int orgType = Util.getIntValue(request.getParameter("orgType"), 0);
	String subId = Util.null2String(request.getParameter("subId")).trim();
	String depId = Util.null2String(request.getParameter("depId")).trim();
	String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
	String fccId = Util.null2String(request.getParameter("fccId")).trim();
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	String sql = "";
	
	FnaWfSet.saveFnaWfSetLogic(mainId, id, 
			intensity, kmIdsCondition, subjectId, 
			orgIdsCondition, orgType, subId, depId, hrmId, fccId, 
			promptSC, promptEN, promptTC, 
			1);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetLogicEditPageDel") || operation.equals("batchFnaWfSetLogicEditPageDel")){//删除：校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);

	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("FnaWfSetLogicEditPageDel")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "delete from fnaFeeWfInfoLogic where id in ("+ids+")";
	rs.executeSql(sql);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetLogicApplicationEditPage")){//保存：预申请预算校验
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int intensity = Util.getIntValue(request.getParameter("intensity"), 0);
	int kmIdsCondition = Util.getIntValue(request.getParameter("kmIdsCondition"), 0);
	int orgIdsCondition = Util.getIntValue(request.getParameter("orgIdsCondition"), 0);
	String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
	int orgType = Util.getIntValue(request.getParameter("orgType"), 0);
	String subId = Util.null2String(request.getParameter("subId")).trim();
	String depId = Util.null2String(request.getParameter("depId")).trim();
	String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
	String fccId = Util.null2String(request.getParameter("fccId")).trim();
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	String sql = "";
	
	FnaWfSet.saveFnaWfSetLogic(mainId, id, 
			intensity, kmIdsCondition, subjectId, 
			orgIdsCondition, orgType, subId, depId, hrmId, fccId, 
			promptSC, promptEN, promptTC, 
			2);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetLogicApplicationEditPageDel") || operation.equals("batchFnaWfSetLogicApplicationEditPageDel")){//删除：预申请预算校验
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);

	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("FnaWfSetLogicApplicationEditPageDel")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "delete from fnaFeeWfInfoLogic where id in ("+ids+")";
	rs.executeSql(sql);
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetBatchSet1")){//批量设置方案
	String FnaWfSetMulti = Util.null2String(request.getParameter("FnaWfSetMulti")).trim();
	String fnaControlSchemeIds = Util.null2String(request.getParameter("fnaControlSchemeIds")).trim();
	int saveType = Util.getIntValue(request.getParameter("saveType"), 0);//1：追加；2：覆盖；

	String[] FnaWfSetMultiArray = FnaWfSetMulti.split(",");
	
	String sql = "";
	if(saveType == 1){//1：追加；

		for(int i=0;i<FnaWfSetMultiArray.length;i++){
			int fnaFeeWfInfoId = Util.getIntValue(FnaWfSetMultiArray[i], 0);
			if(!"".equals(fnaControlSchemeIds)){
				String[] fnaControlSchemeIdsArray = fnaControlSchemeIds.split(",");
				for(int j=0;j<fnaControlSchemeIdsArray.length;j++){
					int fnaControlSchemeId = Util.getIntValue(fnaControlSchemeIdsArray[j], 0);
					if(fnaControlSchemeId > 0){
						sql = "delete from fnaControlScheme_FeeWfInfo where fnaFeeWfInfoId = "+fnaFeeWfInfoId+" and fnaControlSchemeId = "+fnaControlSchemeId;
						rs.executeSql(sql);
						sql = "insert into fnaControlScheme_FeeWfInfo (fnaControlSchemeId, fnaFeeWfInfoId) values ("+fnaControlSchemeId+", "+fnaFeeWfInfoId+")";
						rs.executeSql(sql);
					}
				}
			}
		}
		
	}else if(saveType == 2){//2：覆盖；

		for(int i=0;i<FnaWfSetMultiArray.length;i++){
			int fnaFeeWfInfoId = Util.getIntValue(FnaWfSetMultiArray[i], 0);
			sql = "delete from fnaControlScheme_FeeWfInfo where fnaFeeWfInfoId = "+fnaFeeWfInfoId;
			rs.executeSql(sql);
			if(!"".equals(fnaControlSchemeIds)){
				String[] fnaControlSchemeIdsArray = fnaControlSchemeIds.split(",");
				for(int j=0;j<fnaControlSchemeIdsArray.length;j++){
					int fnaControlSchemeId = Util.getIntValue(fnaControlSchemeIdsArray[j], 0);
					if(fnaControlSchemeId > 0){
						sql = "insert into fnaControlScheme_FeeWfInfo (fnaControlSchemeId, fnaFeeWfInfoId) values ("+fnaControlSchemeId+", "+fnaFeeWfInfoId+")";
						rs.executeSql(sql);
					}
				}
			}
		}
		
	}
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetEditPageLogicSetReverse")){//保存：冲销校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int totalAmtVerification = Util.getIntValue(request.getParameter("totalAmtVerification"), 0);
	int intensity = Util.getIntValue(request.getParameter("intensity"), 2);
	int totalAmtVerification2 = Util.getIntValue(request.getParameter("totalAmtVerification2"), 0);
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	FnaWfSet.clearOldFnaFeeWfInfoLogicReverseData(workflowid);
	
	FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(mainId, 
			totalAmtVerification, intensity, 
			totalAmtVerification2, 2, 
			0, 0, 
			0, 0, 
			0, 0, 
			promptSC, promptEN, promptTC);
	
	String sql = "";
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetEditPageLogicSetAdvanceReverse")){//保存：预付款冲销校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int totalAmtVerification = Util.getIntValue(request.getParameter("totalAmtVerification"), 0);
	int intensity = Util.getIntValue(request.getParameter("intensity"), 2);
	int totalAmtVerification2 = Util.getIntValue(request.getParameter("totalAmtVerification2"), 0);
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	FnaWfSet.saveOrUpdateFnaWfSetLogicAdvanceReverse(mainId, 
			totalAmtVerification, intensity, 
			totalAmtVerification2, 2, 
			0, 0, 
			0, 0, 
			0, 0, 
			promptSC, promptEN, promptTC);
	
	String sql = "";
	
	sql = "update fnaFeeWfInfo \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	new FnaFeeWfInfoComInfo().removeCache();

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaWfSetEditPageCtrlSave")){//保存：控制节点
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int isAllNodesControl = Util.getIntValue(request.getParameter("isAllNodesControl"), 0);
	String nodectrl1 = Util.null2String(request.getParameter("nodectrl1")).trim();
	String nodectrl2 = Util.null2String(request.getParameter("nodectrl2")).trim();

	String sql = "";
	
	sql = "update fnaFeeWfInfo set isAllNodesControl = " + isAllNodesControl +" where id = " + mainId;
	rs.executeUpdate(sql);
	
	if(isAllNodesControl == 1){
	}else{
		sql = "delete from fnaFeeWfInfoNodeCtrl where mainid = " + mainId;
		rs.executeUpdate(sql);
		
		if(!"".equals(nodectrl1)){
			String[] array = nodectrl1.split(",");
			
			for(String nodeid : array){
				sql = "insert into fnaFeeWfInfoNodeCtrl " +
					" (mainid, nodeid, checkway) " +
					" values " + 
					" ("+mainId+", "+nodeid+", 1) ";
				rs.executeSql(sql);
			}
		}
		if(!"".equals(nodectrl2)){
			String[] array = nodectrl2.split(",");
			
			for(String nodeid : array){
				sql = "insert into fnaFeeWfInfoNodeCtrl " +
					" (mainid, nodeid, checkway) " +
					" values " + 
					" ("+mainId+", "+nodeid+", 2) ";
				rs.executeSql(sql);
			}
		}
			
	}
	
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
}
	
	
%>

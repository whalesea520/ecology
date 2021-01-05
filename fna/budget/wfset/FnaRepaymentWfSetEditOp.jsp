<%@page import="weaver.fna.budget.FnaFeeWfInfoComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSetCache"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.HashMap"%>
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
	String templateFile = Util.null2String(request.getParameter("templateFile")).trim();
	String templateFileMobile = Util.null2String(request.getParameter("templateFileMobile")).trim();

	if("".equals(templateFile)){
		templateFile = FnaWfSet.TEMPLATE_BORROW_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_BORROW_FILE_MOBILE;
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
			"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
			" VALUES\n" +
			" ("+workflowid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
			" 'repayment', 1, 0, 2, 0 "+
			")";
		rs.executeSql(sql);

		int id = -1;
		sql = "select id from fnaFeeWfInfo where workflowid = "+workflowid;
		rs.executeSql(sql);
		if(rs.next()){
			id = rs.getInt("id");
		}

		//"本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！";
		String promptSC = FnaLanguage.getPromptSC_FnaRepaymentWfSetEditPageLogicSet(user.getLanguage());
		
		//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
		FnaWfSet.clearOldFnaFeeWfInfoLogicReverseDataRepayment(workflowid);
		
		FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(id, 
				1, 2, 
				1, 2, 
				0, 0, 
				0, 0, 
				0, 0, 
				promptSC, "", "");
		
		new FnaFeeWfInfoComInfo().removeCache();

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editBaseInfo")){//保存：基本设置
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int enable = Util.getIntValue(request.getParameter("enable"), 0);
	String templateFile = Util.null2String(request.getParameter("templateFile")).trim();
	String templateFileMobile = Util.null2String(request.getParameter("templateFileMobile")).trim();

	if("".equals(templateFile)){
		templateFile = FnaWfSet.TEMPLATE_BORROW_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_BORROW_FILE_MOBILE;
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
				
				FnaWfSet.saveActionSet2WfReplayment("", "", "", 
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
			" templateFileMobile = '"+StringEscapeUtils.escapeSql(templateFileMobile)+"' \n" +
			" where id = "+id;
		rs.executeSql(sql);

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
		
		new FnaFeeWfInfoComInfo().removeCache();

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editActionSet")){//保存：费控动作
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	String freezeBorrowNode1Ids = Util.null2String(request.getParameter("freezeBorrowNode1Ids")).trim();//冻结借款-节点前附加操作
	String freezeBorrowNode2Ids = Util.null2String(request.getParameter("freezeBorrowNode2Ids")).trim();//冻结借款-节点后附加操作
	String freezeBorrowNode3Ids = Util.null2String(request.getParameter("freezeBorrowNode3Ids")).trim();//冻结借款-出口附加操作

	String repaymentBorrowNode1Ids = Util.null2String(request.getParameter("repaymentBorrowNode1Ids")).trim();//冲销借款-节点前附加操作
	String repaymentBorrowNode2Ids = Util.null2String(request.getParameter("repaymentBorrowNode2Ids")).trim();//冲销借款-节点后附加操作
	String repaymentBorrowNode3Ids = Util.null2String(request.getParameter("repaymentBorrowNode3Ids")).trim();//冲销借款-出口附加操作

	String releaseFreezeBorrowNode1Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode1Ids")).trim();//释放冻结借款-节点前附加操作
	String releaseFreezeBorrowNode2Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode2Ids")).trim();//释放冻结借款-节点后附加操作
	String releaseFreezeBorrowNode3Ids = Util.null2String(request.getParameter("releaseFreezeBorrowNode3Ids")).trim();//释放冻结借款-出口附加操作
	
	String sql = "";
	
	FnaWfSet.saveActionSet2WfReplayment(freezeBorrowNode1Ids, freezeBorrowNode2Ids, freezeBorrowNode3Ids, 
			repaymentBorrowNode1Ids, repaymentBorrowNode2Ids, repaymentBorrowNode3Ids, 
			releaseFreezeBorrowNode1Ids, releaseFreezeBorrowNode2Ids, releaseFreezeBorrowNode3Ids, 
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
	int main_showSqr = Util.getIntValue(request.getParameter("main_showSqr"), 0);
	int main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"), 0);

	int dt1_fieldIdHklx = Util.getIntValue(request.getParameter("dt1_fieldIdHklx"), 0);
	int dt1_fieldIdHkje = Util.getIntValue(request.getParameter("dt1_fieldIdHkje"), 0);
	int dt1_fieldIdTzmx = Util.getIntValue(request.getParameter("dt1_fieldIdTzmx"), 0);

	int dt1_showHklx = Util.getIntValue(request.getParameter("dt1_showHklx"), 0);
	int dt1_showHkje = Util.getIntValue(request.getParameter("dt1_showHkje"), 0);
	int dt1_showTzmx = Util.getIntValue(request.getParameter("dt1_showTzmx"), 0);

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
	
	
	int[] fieldTypeArray = new int[]{1, 
			1, 2, 3, 
			1, 2, 3, 4, 5, 6, 7, 8};
	int[] fieldIdArray = new int[]{main_fieldIdSqr, 
			dt1_fieldIdHklx, dt1_fieldIdHkje, dt1_fieldIdTzmx, 
			dt2_fieldIdJklc, dt2_fieldIdJkdh, dt2_fieldIdDnxh, dt2_fieldIdJkje, dt2_fieldIdYhje, dt2_fieldIdSpzje, dt2_fieldIdWhje, dt2_fieldIdCxje};
	int[] isDtlArray = new int[]{0, 
			1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1};
	int[] showAllTypeArray = new int[]{main_showSqr, 
			dt1_showHklx, dt1_showHkje, dt1_showTzmx, 
			dt2_showJklc, dt2_showJkdh, dt2_showDnxh, dt2_showJkje, dt2_showYhje, dt2_showSpzje, dt2_showWhje, dt2_showCxje};
	int[] dtlNumberArray = new int[]{0, 
			1, 1, 1, 
			2, 2, 2, 2, 2, 2, 2, 2};
		
	String sql = "";
	
	int fieldTypeArrayLen = fieldTypeArray.length;
	for(int i=0;i<fieldTypeArrayLen;i++){
		int fieldType = fieldTypeArray[i];
		int fieldId = fieldIdArray[i];
		int isDtl = isDtlArray[i];
		int showAllType = showAllTypeArray[i];
		int dtlNumber = dtlNumberArray[i];
		int controlBorrowingWf = 0;
		if(dtlNumber==0 && fieldType==1){
			controlBorrowingWf = main_fieldIdSqr_controlBorrowingWf;
		}

		sql = "select id from fnaFeeWfInfoField where mainId="+mainId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql = "update fnaFeeWfInfoField "+
				" set workflowid="+workflowid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+", "+
				" controlBorrowingWf = "+controlBorrowingWf+" "+
				" where id="+id;
			rs.executeSql(sql);
		}else{
			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber, controlBorrowingWf) "+
				" values ("+
				" "+mainId+", "+workflowid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+", "+controlBorrowingWf+" "+
				")";
			rs.executeSql(sql);
		}
	}
	
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
		
		FnaWfSet.saveActionSet2WfReplayment("", "", "", 
				"", "", "", 
				"", "", "", 
				workflowid);

		//移除指定workflowId缓存中的-自定义费控流程流程的字段对应关系Map对象
		FnaWfSetCache.removeFnaWfFieldSetMap(workflowid);
	}

	sql = "delete from fnaFeeWfInfoLogic where mainid in ("+ids+")";
	rs.executeSql(sql);
	
	sql = "delete from fnaFeeWfInfoField where mainid in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaFeeWfInfo where id in ("+ids+")";
	rs.executeSql(sql);
	
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
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int totalAmtVerification = Util.getIntValue(request.getParameter("totalAmtVerification"), 0);
	int intensity = Util.getIntValue(request.getParameter("intensity"), 2);
	int totalAmtVerification2 = Util.getIntValue(request.getParameter("totalAmtVerification2"), 0);
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	FnaWfSet.clearOldFnaFeeWfInfoLogicReverseDataRepayment(workflowid);
	
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
	
}
%>

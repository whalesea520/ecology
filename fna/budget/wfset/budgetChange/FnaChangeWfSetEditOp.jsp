<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.budget.FnaFeeWfInfoComInfo"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.budget.FnaWfSetCache"%>
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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
		templateFile = FnaWfSet.TEMPLATE_CHANGE_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_CHANGE_FILE_MOBILE;
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
			" 'change', 1, 2, 0, 0 "+
			")";
		rs.executeSql(sql);

		int id = -1;
		sql = "select id from fnaFeeWfInfo where workflowid = "+workflowid;
		rs.executeSql(sql);
		if(rs.next()){
			id = rs.getInt("id");
		}
		
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
	String templateFile = Util.null2String(request.getParameter("templateFile")).trim();
	String templateFileMobile = Util.null2String(request.getParameter("templateFileMobile")).trim();

	if("".equals(templateFile)){
		templateFile = FnaWfSet.TEMPLATE_CHANGE_FILE;
	}
	if("".equals(templateFileMobile)){
		templateFileMobile = FnaWfSet.TEMPLATE_CHANGE_FILE_MOBILE;
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
				
				FnaWfSet.saveActionSet2WfChange("", "", "", 
						"", "", "", 
						"", "", "", 
						workflowid);
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
	String effectNode1Ids = Util.null2String(request.getParameter("effectNode1Ids")).trim();//生效-节点前附加操作
	String effectNode2Ids = Util.null2String(request.getParameter("effectNode2Ids")).trim();//生效-节点后附加操作
	String effectNode3Ids = Util.null2String(request.getParameter("effectNode3Ids")).trim();//生效-出口附加操作
	String releaseNode1Ids = Util.null2String(request.getParameter("releaseNode1Ids")).trim();//释放-节点前附加操作
	String releaseNode2Ids = Util.null2String(request.getParameter("releaseNode2Ids")).trim();//释放-节点后附加操作
	String releaseNode3Ids = Util.null2String(request.getParameter("releaseNode3Ids")).trim();//释放-出口附加操作
	
	String sql = "";
	
	FnaWfSet.saveActionSet2WfChange(frozeNode1Ids, frozeNode2Ids, frozeNode3Ids, 
			effectNode1Ids, effectNode2Ids, effectNode3Ids, 
			releaseNode1Ids, releaseNode2Ids, releaseNode3Ids, 
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

	int fieldIdSubject = Util.getIntValue(request.getParameter("fieldIdSubject"), 0);
	int fieldIdOrgType = Util.getIntValue(request.getParameter("fieldIdOrgType"), 0);
	int fieldIdOrgId = Util.getIntValue(request.getParameter("fieldIdOrgId"), 0);
	int fieldIdOccurdate = Util.getIntValue(request.getParameter("fieldIdOccurdate"), 0);
	int fieldIdAmount = Util.getIntValue(request.getParameter("fieldIdAmount"), 0);
	int fieldIdHrmInfo = Util.getIntValue(request.getParameter("fieldIdHrmInfo"), 0);
	int fieldIdDepInfo = Util.getIntValue(request.getParameter("fieldIdDepInfo"), 0);
	int fieldIdSubInfo = Util.getIntValue(request.getParameter("fieldIdSubInfo"), 0);
	int fieldIdFccInfo = Util.getIntValue(request.getParameter("fieldIdFccInfo"), 0);

	int fieldIdSubject2 = Util.getIntValue(request.getParameter("fieldIdSubject2"), 0);
	int fieldIdOrgType2 = Util.getIntValue(request.getParameter("fieldIdOrgType2"), 0);
	int fieldIdOrgId2 = Util.getIntValue(request.getParameter("fieldIdOrgId2"), 0);
	int fieldIdOccurdate2 = Util.getIntValue(request.getParameter("fieldIdOccurdate2"), 0);
	int fieldIdHrmInfo2 = Util.getIntValue(request.getParameter("fieldIdHrmInfo2"), 0);
	int fieldIdDepInfo2 = Util.getIntValue(request.getParameter("fieldIdDepInfo2"), 0);
	int fieldIdSubInfo2 = Util.getIntValue(request.getParameter("fieldIdSubInfo2"), 0);
	int fieldIdFccInfo2 = Util.getIntValue(request.getParameter("fieldIdFccInfo2"), 0);

	int showAllTypeSubject = Util.getIntValue(request.getParameter("showAllTypeSubject"), 0);
	int showAllTypeOrgType = Util.getIntValue(request.getParameter("showAllTypeOrgType"), 0);
	int showAllTypeOrgId = Util.getIntValue(request.getParameter("showAllTypeOrgId"), 0);
	int showAllTypeOccurdate = Util.getIntValue(request.getParameter("showAllTypeOccurdate"), 0);
	int showAllTypeAmount = Util.getIntValue(request.getParameter("showAllTypeAmount"), 0);
	int showAllTypeHrmInfo = Util.getIntValue(request.getParameter("showAllTypeHrmInfo"), 0);
	int showAllTypeDepInfo = Util.getIntValue(request.getParameter("showAllTypeDepInfo"), 0);
	int showAllTypeSubInfo = Util.getIntValue(request.getParameter("showAllTypeSubInfo"), 0);
	int showAllTypeFccInfo = Util.getIntValue(request.getParameter("showAllTypeFccInfo"), 0);

	int showAllTypeSubject2 = Util.getIntValue(request.getParameter("showAllTypeSubject2"), 0);
	int showAllTypeOrgType2 = Util.getIntValue(request.getParameter("showAllTypeOrgType2"), 0);
	int showAllTypeOrgId2 = Util.getIntValue(request.getParameter("showAllTypeOrgId2"), 0);
	int showAllTypeOccurdate2 = Util.getIntValue(request.getParameter("showAllTypeOccurdate2"), 0);
	int showAllTypeHrmInfo2 = Util.getIntValue(request.getParameter("showAllTypeHrmInfo2"), 0);
	int showAllTypeDepInfo2 = Util.getIntValue(request.getParameter("showAllTypeDepInfo2"), 0);
	int showAllTypeSubInfo2 = Util.getIntValue(request.getParameter("showAllTypeSubInfo2"), 0);
	int showAllTypeFccInfo2 = Util.getIntValue(request.getParameter("showAllTypeFccInfo2"), 0);

	int automaticTakeOrgId = Util.getIntValue(request.getParameter("automaticTakeOrgId"), 0);
	int automaticTakeOrgId2 = Util.getIntValue(request.getParameter("automaticTakeOrgId2"), 0);

	int fieldIdSubject_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubject, null);
	int fieldIdOrgType_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgType, null);
	int fieldIdOrgId_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgId, null);
	int fieldIdOccurdate_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOccurdate, null);
	int fieldIdAmount_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdAmount, null);
	int fieldIdHrmInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdHrmInfo, null);
	int fieldIdDepInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdDepInfo, null);
	int fieldIdSubInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubInfo, null);
	int fieldIdFccInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdFccInfo, null);

	int fieldIdSubject2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubject2, null);
	int fieldIdOrgType2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgType2, null);
	int fieldIdOrgId2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgId2, null);
	int fieldIdOccurdate2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOccurdate2, null);
	int fieldIdHrmInfo2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdHrmInfo2, null);
	int fieldIdDepInfo2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdDepInfo2, null);
	int fieldIdSubInfo2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubInfo2, null);
	int fieldIdFccInfo2_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdFccInfo2, null);

	int fieldIdBudgetInfo2 = 0;
	int showAllTypeBudgetInfo2 = 0;
	int fieldIdBudgetInfo_isDtl2 = 0;
	if(fieldIdBudgetInfo2 <= 0 && fieldIdHrmInfo2 > 0){
		fieldIdBudgetInfo2 = fieldIdHrmInfo2;showAllTypeBudgetInfo2 = showAllTypeHrmInfo2;fieldIdBudgetInfo_isDtl2 = fieldIdHrmInfo2_isDtl;
	}
	if(fieldIdBudgetInfo2 <= 0 && fieldIdDepInfo2 > 0){
		fieldIdBudgetInfo2 = fieldIdDepInfo2;showAllTypeBudgetInfo2 = showAllTypeDepInfo2;fieldIdBudgetInfo_isDtl2 = fieldIdDepInfo2_isDtl;
	}
	if(fieldIdBudgetInfo2 <= 0 && fieldIdSubInfo2 > 0){
		fieldIdBudgetInfo2 = fieldIdSubInfo2;showAllTypeBudgetInfo2 = showAllTypeSubInfo2;fieldIdBudgetInfo_isDtl2 = fieldIdSubInfo2_isDtl;
	}
	if(fieldIdBudgetInfo2 <= 0 && fieldIdFccInfo2 > 0){
		fieldIdBudgetInfo2 = fieldIdFccInfo2;showAllTypeBudgetInfo2 = showAllTypeFccInfo2;fieldIdBudgetInfo_isDtl2 = fieldIdFccInfo2_isDtl;
	}
	if(fieldIdBudgetInfo2 > 0){
		if(fieldIdHrmInfo2 <= 0){
			fieldIdHrmInfo2=fieldIdBudgetInfo2;showAllTypeHrmInfo2=showAllTypeBudgetInfo2;fieldIdHrmInfo2_isDtl=fieldIdBudgetInfo_isDtl2;
		}
		if(fieldIdDepInfo2 <= 0){
			fieldIdDepInfo2=fieldIdBudgetInfo2;showAllTypeDepInfo2=showAllTypeBudgetInfo2;fieldIdDepInfo2_isDtl=fieldIdBudgetInfo_isDtl2;
		}
		if(fieldIdSubInfo2 <= 0){
			fieldIdSubInfo2=fieldIdBudgetInfo2;showAllTypeSubInfo2=showAllTypeBudgetInfo2;fieldIdSubInfo2_isDtl=fieldIdBudgetInfo_isDtl2;
		}
		if(fieldIdFccInfo2 <= 0){
			fieldIdFccInfo2=fieldIdBudgetInfo2;showAllTypeFccInfo2=showAllTypeBudgetInfo2;fieldIdFccInfo2_isDtl=fieldIdBudgetInfo_isDtl2;
		}
	}
	
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
	
	if(fieldIdOrgType_isDtl!=fieldIdOrgId_isDtl || fieldIdOrgType2_isDtl!=fieldIdOrgId2_isDtl){
		//当承担主体选择主表（明细表）字段时，承担主体类型也必须是主表（明细表）字段！
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126794,user.getLanguage()))+"}");
		out.flush();
		return;
	}

	if(fieldIdSubject_isDtl==1 || fieldIdOrgType_isDtl==1 || fieldIdOrgId_isDtl==1 || fieldIdOccurdate_isDtl==1){
		if(fieldIdAmount_isDtl==0){
			//当【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，【变更金额】必须也是明细字段，请调整字段对应关系！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382395,user.getLanguage()))+"}");
			out.flush();
			return;
		}else if(fieldIdHrmInfo_isDtl==0 || fieldIdDepInfo_isDtl==0 || fieldIdSubInfo_isDtl==0 || fieldIdFccInfo_isDtl==0){
			//当【变更金额】是明细字段时，【预算信息】必须也是明细字段，请调整字段对应关系！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382396,user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}

	if((fieldIdSubject2_isDtl==1 && fieldIdSubject2_isDtl!=fieldIdSubject_isDtl) 
			|| (fieldIdOrgType2_isDtl==1 && fieldIdOrgType2_isDtl!=fieldIdOrgType_isDtl)
			|| (fieldIdOrgId2_isDtl==1 && fieldIdOrgId2_isDtl!=fieldIdOrgId_isDtl)
			|| (fieldIdOccurdate2_isDtl==1 && fieldIdOccurdate2_isDtl!=fieldIdOccurdate_isDtl)){
		if(fieldIdHrmInfo2_isDtl==0 || fieldIdDepInfo2_isDtl==0 || fieldIdSubInfo2_isDtl==0 || fieldIdFccInfo2_isDtl==0){
			//当转出【科目】【承担主体类型】【承担主体】【报销日期】中有任意一个是明细字段时，转出【预算信息】必须也是明细字段，请调整字段对应关系！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382397,user.getLanguage()))+"}");
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
			//【变更主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382400,user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}
	{
		if(fieldIdOrgType2 > 0){
			int bxMx_orgType_min_selectvalue = -1;
			int bxMx_orgType_max_selectvalue = -1;
			rs2.executeQuery("select max(a.pubid) pubid, min(a.selectvalue) min_selectvalue, max(a.selectvalue) max_selectvalue from workflow_SelectItem a where a.fieldid = "+fieldIdOrgType2);
			if(rs2.next()){
				bxMx_orgType_min_selectvalue = rs2.getInt("min_selectvalue");
				bxMx_orgType_max_selectvalue = rs2.getInt("max_selectvalue");
			}
			if(bxMx_orgType_min_selectvalue<0 || bxMx_orgType_max_selectvalue>3){
				//【转出主体类型】可选项范围只能是0、1、2、3；0：个人；1：部门；2：分部；3：成本中心，请检查！
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(382401,user.getLanguage()))+"}");
				out.flush();
				return;
			}
		}
	}
	
	
	int[] fieldTypeArray = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 
			10, 11, 12, 13, 14, 15, 16, 17};
	int[] fieldIdArray = new int[]{fieldIdSubject, fieldIdOrgType, fieldIdOrgId, fieldIdOccurdate, fieldIdAmount, fieldIdHrmInfo, fieldIdDepInfo, fieldIdSubInfo, fieldIdFccInfo, 
			fieldIdSubject2, fieldIdOrgType2, fieldIdOrgId2, fieldIdOccurdate2, fieldIdHrmInfo2, fieldIdDepInfo2, fieldIdSubInfo2, fieldIdFccInfo2};
	int[] isDtlArray = new int[]{fieldIdSubject_isDtl, fieldIdOrgType_isDtl, fieldIdOrgId_isDtl, fieldIdOccurdate_isDtl, fieldIdAmount_isDtl, fieldIdHrmInfo_isDtl, fieldIdDepInfo_isDtl, fieldIdSubInfo_isDtl, fieldIdFccInfo_isDtl, 
			fieldIdSubject2_isDtl, fieldIdOrgType2_isDtl, fieldIdOrgId2_isDtl, fieldIdOccurdate2_isDtl, fieldIdHrmInfo2_isDtl, fieldIdDepInfo2_isDtl, fieldIdSubInfo2_isDtl, fieldIdFccInfo2_isDtl};
	int[] showAllTypeArray = new int[]{showAllTypeSubject, showAllTypeOrgType, showAllTypeOrgId, showAllTypeOccurdate, showAllTypeAmount, showAllTypeHrmInfo, showAllTypeDepInfo, showAllTypeSubInfo, showAllTypeFccInfo, 
			showAllTypeSubject2, showAllTypeOrgType2, showAllTypeOrgId2, showAllTypeOccurdate2, showAllTypeHrmInfo2, showAllTypeDepInfo2, showAllTypeSubInfo2, showAllTypeFccInfo2};
	int[] dtlNumberArray = new int[]{1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1};
	int[] automaticTakeArray = new int[]{0, 0, automaticTakeOrgId, 0, 0, 0, 0, 0, 0, 
			0, 0, automaticTakeOrgId2, 0, 0, 0, 0, 0};
	
	String sql = "";
	
	int fieldTypeArrayLen = fieldTypeArray.length;
	for(int i=0;i<fieldTypeArrayLen;i++){
		int fieldType = fieldTypeArray[i];
		int fieldId = fieldIdArray[i];
		int isDtl = isDtlArray[i];
		int showAllType = showAllTypeArray[i];
		int dtlNumber = dtlNumberArray[i];
		int automaticTake = automaticTakeArray[i];

		sql = "select id from fnaFeeWfInfoField where mainId="+mainId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql = "update fnaFeeWfInfoField "+
				" set workflowid="+workflowid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+", automaticTake = "+automaticTake+" "+
				" where id="+id;
			rs.executeSql(sql);
		}else{
			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber, automaticTake) "+
				" values ("+
				" "+mainId+", "+workflowid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+", "+automaticTake+" "+
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
		
		FnaWfSet.saveActionSet2WfChange("", "", "", 
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
	
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	new FnaFeeWfInfoComInfo().removeCache();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}
%>

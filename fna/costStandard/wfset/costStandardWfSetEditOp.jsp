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
<%@page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostStandardProcedure:edit", user)){
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
	String overStandardTips = Util.null2String(request.getParameter("overStandardTips")).trim();

	
	String sql = "select count(*) cnt from fnaFeeWfInfoCostStandard where workflowid = "+workflowid;
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(32141,user.getLanguage()))+"}");//该流程已经被定义，请重新选择流程！
		out.flush();
		return;
		
	}else{
		sql = "INSERT INTO fnaFeeWfInfoCostStandard \n" +
			" (workflowid, enable, lastModifiedDate, "+
			"  fnaWfType, overStandardTips)\n" +
			" VALUES\n" +
			" ("+workflowid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', "+
			" 'costStandard', '"+StringEscapeUtils.escapeSql(overStandardTips)+"'"+
			")";
		rs.executeSql(sql);

		int id = -1;
		sql = "select id from fnaFeeWfInfoCostStandard where workflowid = "+workflowid;
		rs.executeSql(sql);
		if(rs.next()){
			id = rs.getInt("id");
		}

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editBaseInfo")){//保存：基本设置
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int enable = Util.getIntValue(request.getParameter("enable"), 0);
	String overStandardTips = Util.null2String(request.getParameter("overStandardTips")).trim();

	String sql = "select count(*) cnt from fnaFeeWfInfoCostStandard where workflowid = "+workflowid+" and id <> "+id;
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(32141,user.getLanguage()))+"}");//该流程已经被定义，请重新选择流程！
		out.flush();
		return;
		
	}else{
		sql = "select workflowid from fnaFeeWfInfoCostStandard where id = "+id;
		rs.executeSql(sql);
		if(rs.next()){
			int db_workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
			if(db_workflowid!=workflowid){
				sql = "delete from fnaFeeWfInfoFieldCostStandard where mainId = "+id;
				rs.executeSql(sql);
			}
		}
		
		sql = "update fnaFeeWfInfoCostStandard \n" +
			" set workflowid = "+workflowid+", "+
			" overStandardTips = '"+StringEscapeUtils.escapeSql(overStandardTips)+"', \n" +
			" enable = "+enable+", "+
			" lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
			" where id = "+id;
		rs.executeSql(sql);

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
		out.flush();
		return;
		
	}
	
}else if(operation.equals("editFieldSet")){//保存：费控字段
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String thisGuid = Util.null2String(request.getParameter("thisGuid"));
	
	String sql = "";
	List<String> fcsGuidList = new ArrayList<String>();
	sql = "select * \n" +
			" from FnaCostStandard a \n" +
			" where a.enabled = 1 \n" +
			" order by a.orderNumber, a.name ";
	rs.executeSql(sql);
	while(rs.next()){
		fcsGuidList.add(Util.null2String(rs.getString("guid1")));

	}
	
	int hasMainTable = 0;
	List<String> tabIndexList = new ArrayList<String>();
	sql = "select detailtable from workflow_billfield where billid="+formid+" group by detailtable order by detailtable";
	rs.executeSql(sql);
	while(rs.next()){
		String detailtable = Util.null2String(rs.getString("detailtable"));
		if("".equals(detailtable)){
			hasMainTable = 1;
		}else{
			String dtNumber = detailtable.replaceAll("formtable_main_"+Math.abs(formid)+"_dt", "");
			tabIndexList.add(dtNumber);
		}
	}
	
	if(hasMainTable == 1){
		tabIndexList.add(0, "0");
	}
	
	
	for(int j = 0; j < tabIndexList.size(); j++){
		int tabIndex = Util.getIntValue(tabIndexList.get(j), 0);
		
		String flag = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_flag"));
		
		
		if("true".equals(flag)){
			String[] fieldId_keyName_array = new String[]{"csAmount","costStandardC"};
			int fieldId_keyName_array_len = fieldId_keyName_array.length;
			for(int i=0;i<fieldId_keyName_array_len;i++){
				String fieldId_keyName = fieldId_keyName_array[i];
				
				int fieldType = 0;
				int showAllType = 1;
				
				int fieldValType = 1;
				String fieldValue = "";
				String fieldValueWfSys = "NULL";
				int isDtl = 0;
				int dtlNumber = 0;
				int fieldId = Util.getIntValue(Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fieldId_keyName)), 0);
				
				if(fieldValType==1 && fieldId > 0){
					String sql1 = "select a.id,a.fieldname,a.fieldlabel,a.viewtype,a.fieldhtmltype,a.type,a.dsporder,a.detailtable "+
						" from workflow_billfield a "+
						" where id = "+fieldId;
					rs1.executeSql(sql1);
					if(rs1.next()){
						String _detailtable = Util.null2String(rs1.getString("detailtable"));
						
						if(!"".equals(_detailtable)){
							isDtl = 1;
							dtlNumber = Util.getIntValue(_detailtable.replaceAll("formtable_main_"+Math.abs(formid)+"_dt", ""), 0);
						}
					}
				}
				
				sql = "select id from fnaFeeWfInfoFieldCostStandard where mainId="+mainId+" and fcsGuid1='"+fieldId_keyName+"' and tabIndex = " + tabIndex;
				rs1.executeSql(sql);
				if(rs1.next()){
					int id = rs1.getInt("id");
					sql = "update fnaFeeWfInfoFieldCostStandard "+
						" set workflowid="+workflowid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+", "+
						" fcsGuid1 = '"+fieldId_keyName+"', "+
						" fieldValue = '"+StringEscapeUtils.escapeSql(fieldValue)+"', "+
						" fieldValueWfSys = "+fieldValueWfSys+", "+
						" fieldValType = "+fieldValType+" "+
						" where id="+id + " and tabIndex = " + tabIndex;
					rs1.executeSql(sql);
				}else{
					sql = "insert into fnaFeeWfInfoFieldCostStandard (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber, "+
						" fcsGuid1, fieldValue, fieldValueWfSys, fieldValType, tabIndex) "+
						" values ("+
						" "+mainId+", "+workflowid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+", "+
						" '"+fieldId_keyName+"', '"+StringEscapeUtils.escapeSql(fieldValue)+"', "+fieldValueWfSys+", "+fieldValType+" "+", "+tabIndex+" "+
						")";
					rs1.executeSql(sql);
				}
			}

			int fieldType = 0;
			int showAllType = 1;
			
			for(String fcsGuid : fcsGuidList){
				if(Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid+"_fieldValType"))!=null){
					int fieldValType = Util.getIntValue(Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid+"_fieldValType")), 0);
					int fieldId = Util.getIntValue(Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid+"_fieldId")), 0);
					String fieldValue = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid+"_fieldValue"));
					String fieldValueWfSys = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid+"_fieldValueWfSys"));
					if(Util.getIntValue(fieldValueWfSys) <= 0){
						fieldValueWfSys = "NULL";
					}
					
					int isDtl = 0;
					int dtlNumber = 0;
				
					if(fieldValType==1 && fieldId > 0){
						String sql1 = "select a.id,a.fieldname,a.fieldlabel,a.viewtype,a.fieldhtmltype,a.type,a.dsporder,a.detailtable "+
							" from workflow_billfield a "+
							" where id = "+fieldId;
						rs1.executeSql(sql1);
						if(rs1.next()){
							String _detailtable = Util.null2String(rs1.getString("detailtable"));
							
							if(!"".equals(_detailtable)){
								isDtl = 1;
								dtlNumber = Util.getIntValue(_detailtable.replaceAll("formtable_main_"+Math.abs(formid)+"_dt", ""), 0);
							}
						}
					}
					
					sql = "select id from fnaFeeWfInfoFieldCostStandard where mainId="+mainId+" and fcsGuid1='"+StringEscapeUtils.escapeSql(fcsGuid)+"' and tabIndex = " + tabIndex;
					rs1.executeSql(sql);
					if(rs1.next()){
						int id = rs1.getInt("id");
						sql = "update fnaFeeWfInfoFieldCostStandard "+
							" set workflowid="+workflowid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+", "+
							" fcsGuid1 = '"+StringEscapeUtils.escapeSql(fcsGuid)+"', "+
							" fieldValue = '"+StringEscapeUtils.escapeSql(fieldValue)+"', "+
							" fieldValueWfSys = "+fieldValueWfSys+", "+
							" fieldValType = "+fieldValType+" "+
							" where id="+id + " and tabIndex = " + tabIndex;
						rs1.executeSql(sql);
					}else{
						sql = "insert into fnaFeeWfInfoFieldCostStandard (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber, "+
							" fcsGuid1, fieldValue, fieldValueWfSys, fieldValType, tabIndex) "+
							" values ("+
							" "+mainId+", "+workflowid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+", "+
							" '"+StringEscapeUtils.escapeSql(fcsGuid)+"', '"+StringEscapeUtils.escapeSql(fieldValue)+"', "+fieldValueWfSys+", "+fieldValType+", "+tabIndex+" "+
							")";
						rs1.executeSql(sql);
					}
				}
			}
		}
	}

	sql = "update fnaFeeWfInfoCostStandard \n" +
		" set lastModifiedDate = '"+StringEscapeUtils.escapeSql(currentdate)+"' \n" +
		" where id = "+mainId;
	rs.executeSql(sql);
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("del") || operation.equals("batchDel")){//删除、批量删除费控流程
	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("del")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "delete from fnaFeeWfInfoFieldCostStandard where mainid in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaFeeWfInfoCostStandard where id in ("+ids+")";
	rs.executeSql(sql);
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("enable")){//启用、禁用 费控流程
	int id = Util.getIntValue(request.getParameter("id"));
	int enable = 0;
	
	String sql = "select enable, workflowid from fnaFeeWfInfoCostStandard where id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		enable = rs.getInt("enable");
		int workflowid = rs.getInt("workflowid");
		
		if(enable == 1){
			enable = 0;
		}else{
			enable = 1;
		}

		sql = "update fnaFeeWfInfoCostStandard set enable = "+enable+" where id = "+id;
		rs.executeSql(sql);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote("")+",\"enable\":"+enable+"}");
	out.flush();
	return;
	
}
%>

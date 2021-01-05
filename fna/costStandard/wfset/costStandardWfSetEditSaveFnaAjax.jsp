<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
String sql = "";
String csAmount = Util.null2String(request.getParameter("csAmount")).trim();
String costStandardC = Util.null2String(request.getParameter("costStandardC")).trim();
String thisGuid = Util.null2String(request.getParameter("thisGuid")).trim();
int tabIndex = Util.getIntValue(Util.null2String(request.getParameter("tabIndex")).trim(), 0);
RecordSet rs = new RecordSet();


request.getSession().removeAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_flag");


List<String> fcsGuid1List = new ArrayList<String>();
List<Integer> fieldValTypeList = new ArrayList<Integer>();
List<Integer> fieldIdList = new ArrayList<Integer>();
List<String> fieldValueList = new ArrayList<String>();
List<String> fieldValueWfSysList = new ArrayList<String>();

int cnt = 0;
int nullCnt = 0;
sql = "select * \n" +
	" from FnaCostStandard a \n" +
	" where a.enabled = 1 \n" +
	" order by a.orderNumber, a.name ";
rs.executeSql(sql);
while(rs.next()){
	String fcsGuid1 = Util.null2String(rs.getString("guid1"));
	
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1,csAmount);

	int fieldValType = Util.getIntValue(request.getParameter("s_"+fcsGuid1), 0);
	
	int fieldId = 0;
	String fieldValue = "";
	String fieldValueWfSys = "";
	if(fieldValType==1){
		fieldId = Util.getIntValue(request.getParameter("vSel_"+fcsGuid1), 0);
		
		if(fieldId == 0){
			nullCnt++;
		}
	}else if(fieldValType==2){
		fieldValue = Util.null2String(request.getParameter("vIpt_"+fcsGuid1));
		
		if("".equals(fieldValue.trim())){
			nullCnt++;
		}
	}else if(fieldValType==3){
		fieldValueWfSys = Util.null2String(request.getParameter("vWfSys_"+fcsGuid1)).trim();
		
		if(Util.getIntValue(fieldValueWfSys) <= 0){
			fieldValueWfSys = "";
			nullCnt++;
		}
	}
	
	fcsGuid1List.add(fcsGuid1);
	fieldValTypeList.add(fieldValType);
	fieldIdList.add(fieldId);
	fieldValueList.add(fieldValue);
	fieldValueWfSysList.add(fieldValueWfSys);
	
	cnt++;
}


request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_flag","true");
request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_csAmount",csAmount);
request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_costStandardC",costStandardC);

for(int i = 0; i < fcsGuid1List.size(); i++){
	String fcsGuid1 = fcsGuid1List.get(i);
	int fieldValType = fieldValTypeList.get(i);
	int fieldId = fieldIdList.get(i);
	String fieldValue = fieldValueList.get(i);
	String fieldValueWfSys = fieldValueWfSysList.get(i);
	
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValType",fieldValType);
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldId",fieldId);
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValue",fieldValue);
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValueWfSys",fieldValueWfSys);
}

if(nullCnt==cnt && "".equals(csAmount)){
	request.getSession().setAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_AllNullFlag","true");
}





%>
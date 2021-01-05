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
String returnstr = "";
int formid = Util.getIntValue(request.getParameter("formid"), 0);
String thisGuid = Util.null2String(request.getParameter("thisGuid")).trim();
RecordSet rs = new RecordSet();
StringBuffer error = new StringBuffer("");

User user = HrmUserVarify.getUser (request , response) ;


int hasMainTable = 0;
List<String> tabIndexList = new ArrayList<String>();
String sql = "select detailtable from workflow_billfield where billid="+formid+" group by detailtable order by detailtable";
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
		String flag2 = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_AllNullFlag"));
		
		if(!"true".equals(flag2)){
			String csAmount = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_csAmount"));
			if("".equals(csAmount)){
				if(tabIndex == 0){
					error.append(SystemEnv.getHtmlLabelNames("21778",user.getLanguage())+" "+SystemEnv.getHtmlLabelNames("125609,18019",user.getLanguage())+"；\\n");
				}else if(tabIndex > 0){
					error.append(SystemEnv.getHtmlLabelNames("19325",user.getLanguage())+(j+1)+" "+SystemEnv.getHtmlLabelNames("125609,18019",user.getLanguage())+"；\\n");
				}
			}
		}
	}
	
	
}


if(error.length() > 0){
	returnstr = "{\"flag\":false,\"errorInfo\":\""+error.toString()+"\"}";
}else{
	returnstr = "{\"flag\":true}";
}

%><%=returnstr %>
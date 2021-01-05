<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.maintenance.FnaAdvanceAmountControl"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
DecimalFormat df = new DecimalFormat("#################################################0.00");
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result.append("{\"flag\":false,\"errorInfo\":\"error！\"}");
}else{
	String _____guid1 = Util.null2String(request.getParameter("_____guid1")).trim();
	int Yfklc = Util.getIntValue(request.getParameter("Yfklc"), -1);
	int dnxh = Util.getIntValue(request.getParameter("dnxh"), -1);
	int requestid = Util.getIntValue(request.getParameter("requestid"));
	
	boolean _flag = true;//_____guid1.equals(Util.null2String(request.getSession().getAttribute("FnaSubmitRequestJsAdvance.jsp_____"+_____guid1+"_____"+user.getUID())).trim());

	String Yfklc_requestmark = "";
	String Yfklc_dnxhShowName = "";
	//借款金额：Yfkje；已还金额:yhje；审批中待还款金额：spzje；未还金额：whje；
	String Yfkje = "";
	String yhje = "";
	String spzje = "";
	String whje = "";
	boolean flag = true;
	if(Yfklc > 0 && _flag){
		if(requestid != -1){
			//查询当前操作人是否在此还款流程中
			int userid = user.getUID();
			String sql1 = "select * from workflow_currentoperator a where a.userid ="+userid+" and a.requestid ="+requestid;
			rs.executeSql(sql1);
			if(rs.getCounts()==0){
				flag = false;
			}else{
				//查询当前操作人是否在借款流程中
				String sql2 = "select * from workflow_currentoperator a where a.userid ="+userid+" and a.requestid ="+Yfklc;
				rs.executeSql(sql2);
				if(rs.getCounts()==0){
					String sql3 = "select workflowid from workflow_requestbase where requestid = "+requestid;
					rs.executeSql(sql3);
					int workflowid = 0;
					while(rs.next()){
						workflowid = rs.getInt("workflowid");
					}
					
					String dt1_field_id = "";
					String dt1_field = "";
					String sqlN = "select * from fnaFeeWfInfoField where workflowid="+workflowid;
					rs.executeSql(sqlN);
					while(rs.next()){
						String fieldType = Util.null2String(rs.getString("fieldType"));
						String fieldId = Util.null2String(rs.getString("fieldId"));
						String dtlNumber = Util.null2String(rs.getString("dtlNumber"));
						if(Util.getIntValue(dtlNumber)==4 && Util.getIntValue(fieldType)==1){
							dt1_field_id = fieldId;
						}
					}
					String sqlM = "select fieldname from workflow_billfield where id="+dt1_field_id;
					rs.executeSql(sqlM);
					while(rs.next()){
						dt1_field = rs.getString("fieldname");
					}
					String sql4 = "select b.formid from workflow_requestbase a join workflow_base b on a.workflowid = b.id "+
								" where a.requestid="+requestid;
					rs.executeSql(sql4);
					int formid = 0;
					while(rs.next()){
						formid = rs.getInt("formid");
					}
					formid = Math.abs(formid);
					String tableName = "formtable_main_"+formid;
					String tableNameDetail = "formtable_main_"+formid+"_dt4";
					String sql5 = "select * from "+tableName+" a join "+tableNameDetail+" b on a.id = b.mainid where b."+dt1_field+"="+Yfklc+" and a.requestid="+requestid;
					rs.executeSql(sql5);
					if(rs.getCounts() == 0){
						flag = false;
					}
				}
			}	
		}
		if(flag){
			if(dnxh > 0){
				String sql3 = "select requestmark from workflow_requestbase where requestid = "+Yfklc;
				rs.executeSql(sql3);
				if(rs.next()){
					Yfklc_requestmark = Util.null2String(rs.getString("requestmark"));
				}
				FnaAdvanceAmountControl fnaAdvanceAmountControl = new FnaAdvanceAmountControl();
				HashMap<String, String> advanceInfoHm = fnaAdvanceAmountControl.getAdvanceInfo(Yfklc, dnxh, 0);
				Yfkje = Util.null2String(advanceInfoHm.get("Yfkje"));
				yhje = Util.null2String(advanceInfoHm.get("yhje"));
				spzje = Util.null2String(advanceInfoHm.get("spzje"));
				whje = Util.null2String(advanceInfoHm.get("whje"));
				Yfklc_dnxhShowName = FnaCommon.getRequestAdvanceDnxhShowName(Yfklc, dnxh);
			}	
		}
	}
	
	if(flag){
		result.append("{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+
				",\"requestmark\":"+JSONObject.quote(Yfklc_requestmark)+
				",\"Yfkje\":"+JSONObject.quote(Yfkje)+
				",\"yhje\":"+JSONObject.quote(yhje)+
				",\"spzje\":"+JSONObject.quote(spzje)+
				",\"whje\":"+JSONObject.quote(whje)+
				",\"dnxhShowName\":"+JSONObject.quote(Yfklc_dnxhShowName)+
				"}");
	}else{
		result.append("{\"flag\":false,\"errorInfo\":\"当前操作人无权限！\"}");
	}
	
}
%><%=result.toString() %>
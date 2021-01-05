<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>

<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String _reqIds = Util.null2String(request.getParameter("_reqIds")).trim();

String returnStr = "";
try{
	String brStr = "<br>";
	HashMap<String, HashMap<String, String>> workflowidHm = new HashMap<String, HashMap<String, String>>();
	List<String> wfidList = new ArrayList<String>();
	List<String> reqIdList = FnaCommon.splitToListForSqlCond(_reqIds, 900, ",", new DecimalFormat("#"));
	StringBuffer errorInfo = new StringBuffer("");
	boolean errorFlag = false;

	boolean fnaWfSysWf = false;//流程允许批量提交      报销申请单;付款申请单
	boolean fnaWfCustom = false;//流程允许批量提交      自定义表单费控流程
	rs.executeSql("select * from FnaSystemSet");
	if(rs.next()){
		fnaWfSysWf = 1==Util.getIntValue(rs.getString("fnaWfSysWf"), 0);
		fnaWfCustom = 1==Util.getIntValue(rs.getString("fnaWfCustom"), 0);
	}
	
	for(int i=0;i<reqIdList.size();i++){
		String reqIdCond = reqIdList.get(i);
		
		rs.executeSql("select a.requestid, b.formid, a.workflowid, b.workflowname \n" +
				" from workflow_requestbase a \n" +
				" join workflow_base b on a.workflowid = b.id \n" +
				" where a.requestid in ("+reqIdCond+")");
		while(rs.next()){
			int _requestid = rs.getInt("requestid");
			int _formid = rs.getInt("formid");
			int _workflowid = rs.getInt("workflowid");
			String _workflowname = rs.getString("workflowname");
			if(_workflowid > 0){
				HashMap<String, String> _isEnableFnaWfHm = null;
				if(workflowidHm.containsKey(_workflowid+"")){
					_isEnableFnaWfHm = workflowidHm.get(_workflowid+"");
				}else{
					_isEnableFnaWfHm = FnaCommon.getIsEnableFnaWfHm(_workflowid);
					workflowidHm.put(_workflowid+"", _isEnableFnaWfHm);
				}
				
				boolean _isEnableFnaWfSysWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaWfSysWf"));//系统表单
				boolean _isEnableFnaWfE7 = "true".equals(_isEnableFnaWfHm.get("isEnableFnaWfE7"));//E7的自定义表单费用报销流程
				boolean _isEnableFnaWfE8 = "true".equals(_isEnableFnaWfHm.get("isEnableFnaWfE8"));//E8的自定义表单费用报销流程

				//boolean _isEnableFnaBorrowWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaBorrowWf"));//E8的借款费控流程
				boolean _isEnableFnaRepaymentWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaRepaymentWf"));//E8的还款费控流程
				boolean _isEnableFnaChangeWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaChangeWf"));//E8的预算变更流程
				boolean _isEnableFnaShareWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaShareWf"));//E8的预算已发生费用分摊流程
				
				if((_isEnableFnaWfSysWf && !fnaWfSysWf) 
						|| ((_isEnableFnaWfE7 || _isEnableFnaWfE8 || _isEnableFnaRepaymentWf ||  _isEnableFnaChangeWf || _isEnableFnaShareWf) && !fnaWfCustom)){
					errorFlag = true;
					if(!wfidList.contains(_workflowid+"")){
						wfidList.add(_workflowid+"");
						errorInfo.append(_workflowname+";");
					}
					
				}else{
					if(_isEnableFnaWfSysWf){//系统表单
						//批量提交不做限制
						
					}else if(_isEnableFnaWfE8){//E8的自定义表单费用报销流程
						StringBuffer _errorInfo = new StringBuffer();
						if(!fnaBudgetControl.getFnaWfValidator(_workflowid, _formid, _requestid, user.getUID(), user, _errorInfo, 0)){
							errorFlag = true;
							errorInfo.append(_errorInfo.toString()+";");
						}
						
					}else if(_isEnableFnaWfE7 || _isEnableFnaRepaymentWf ||  _isEnableFnaChangeWf || _isEnableFnaShareWf){//各类自定义表单
						errorFlag = true;
						if(!wfidList.contains(_workflowid+"")){
							wfidList.add(_workflowid+"");
							errorInfo.append(_workflowname+";");
						}
						
					}
				}
			}
		}
	}
	
	if(errorFlag){
		//以下流程是费用流程类型，不允许批量提交！
		returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(82970,user.getLanguage())+brStr+errorInfo.toString())+"}";
	}else{
		returnStr = "{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+"}";
	}
	
}catch(Exception ex1){
	new BaseBean().writeLog(ex1);
	returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";
}
%>
<%=returnStr%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.fna.budget.BudgetApproveWFHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<%@page import="weaver.fna.general.FnaCommon"%><jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetStart" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user= HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

if(requestid != -1){
	String sqlwhere = FnaCommon.getCanQueryRequestSqlCondition(user, "a", "a");
	String _sql = "select 1 from workflow_requestbase a where 1=1 "+sqlwhere+" and a.requestid = "+requestid;
	RecordSetStart.executeSql(_sql);
	if(RecordSetStart.getCounts()<1){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}


RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;


String sql00="select budgetdetail from bill_FnaBudget where id="+ billid ;
RecordSet.executeSql(sql00);
String budgetid00="";
if(RecordSet.next()){
	budgetid00 = Util.null2String(RecordSet.getString("budgetdetail"));
}
if(!budgetid00.equals("")){
	String sql0 = "select status "+
   		" from FnaBudgetInfo "+
		" where id="+budgetid00 ;
	RecordSet.executeSql(sql0);
	if(RecordSet.next()){
		int _status = RecordSet.getInt("status");
		if(_status!=3){
			out.print("<script>"+
				"top.Dialog.alert("+JSONObject.quote(""+SystemEnv.getHtmlLabelName(84478,user.getLanguage()))+", "+
				"function(){wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');});\r\n"+
				"</script>");
			return ;
		}
	}
}

boolean savestatus = RequestManager.saveRequestInfo() ;

requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
            return ;
        }

        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
        return ;
    }
}

boolean ifbottomtotop =  false;//是否启用从下至上编辑财务费用设置
boolean cancelFnaEditCheck =  false;
String ifTrue = "true";
RecordSet.executeSql("select ifbottomtotop,cancelFnaEditCheck from fnasystemset");
if(RecordSet.next()){
	if(RecordSet.getInt("ifbottomtotop")==1){
		ifbottomtotop =  true;
		ifTrue = "false";
	}
	cancelFnaEditCheck = (RecordSet.getInt("cancelFnaEditCheck")==1);
}

//如果操作时提交的话
if (!cancelFnaEditCheck && src.equals("submit")) {
	DecimalFormat df = new DecimalFormat("##############################################0.00");
	RecordSet rs1 = new RecordSet();
	RecordSet rs2 = new RecordSet();
	
    String sql="select budgetdetail from bill_FnaBudget where id="+ billid ;
    rs1.executeSql(sql);
    if(rs1.next()){
    	String budgetinfoid =rs1.getString("budgetdetail");

		List mbudgetvalues = new ArrayList(); List msubject3names = new ArrayList(); 
		List qbudgetvalues = new ArrayList(); List qsubject3names = new ArrayList();
		List hbudgetvalues = new ArrayList(); List hsubject3names = new ArrayList();
		List ybudgetvalues = new ArrayList(); List ysubject3names = new ArrayList();

		int _organizationtype = -1;
		int _budgetorganizationid = -1;
		int _budgetperiods = -1;
    	sql = " select DISTINCT b.budgettypeid, c1.feeperiod, a.organizationtype, a.budgetorganizationid, a.budgetperiods \n" +
    		" from FnaBudgetInfo a \n"+
    		" join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n" +
    		" join FnaBudgetfeeType c1 on b.budgettypeid = c1.id \n" +
    		" where c1.isEditFeeTypeId = 1 and b.budgetinfoid = "+Util.getIntValue(budgetinfoid,0);
   		rs1.executeSql(sql);
   		while(rs1.next()){
   			int _budgettypeid = rs1.getInt("budgettypeid");
   			int _feeperiod = rs1.getInt("feeperiod");
   			_organizationtype = rs1.getInt("organizationtype");
   			_budgetorganizationid = rs1.getInt("budgetorganizationid");
   			_budgetperiods = rs1.getInt("budgetperiods");
   			
   			int _feeperiodCnt = 0;
   			String[] _inputValArray = null;
   			if(_feeperiod==1){
   				_feeperiodCnt = 12;
   			}else if(_feeperiod==2){
   				_feeperiodCnt = 4;
   			}else if(_feeperiod==3){
   				_feeperiodCnt = 2;
   			}else if(_feeperiod==4){
   				_feeperiodCnt = 1;
   			}
   			_inputValArray = new String[_feeperiodCnt];
   			for(int i=0;i<_feeperiodCnt;i++){
   				_inputValArray[i] = "0.00";
   			}
   			
   			String sql2 = "select a.budgetaccount, a.budgetperiodslist \n" +
   					" from FnaBudgetInfoDetail a \n" +
   					" where a.budgettypeid = "+_budgettypeid+" \n" +
   					" and a.budgetinfoid = "+budgetinfoid+" \n" +
   					" ORDER BY a.budgetperiodslist asc";
   			rs2.executeSql(sql2);
   			while(rs2.next()){
   				int _budgetperiodslist = Util.getIntValue(rs2.getString("budgetperiodslist"), -1);

   				if(_budgetperiodslist<1 || _budgetperiodslist>_feeperiodCnt){
   					continue;
   				}
   				_inputValArray[_budgetperiodslist-1] = df.format(Util.getDoubleValue(rs2.getString("budgetaccount"), 0.00));
   			}

   			if(_feeperiod==1){
   				int _idx = msubject3names.indexOf(_budgettypeid+"");
   				if(_idx < 0){
   					mbudgetvalues.add(_inputValArray);
   					msubject3names.add(_budgettypeid+"");
   				}
   			}else if(_feeperiod==2){
   				int _idx = qsubject3names.indexOf(_budgettypeid+"");
   				if(_idx < 0){
   					qbudgetvalues.add(_inputValArray);
   					qsubject3names.add(_budgettypeid+"");
   				}
   			}else if(_feeperiod==3){
   				int _idx = hsubject3names.indexOf(_budgettypeid+"");
   				if(_idx < 0){
   					hbudgetvalues.add(_inputValArray);
   					hsubject3names.add(_budgettypeid+"");
   				}
   			}else if(_feeperiod==4){
   				int _idx = ysubject3names.indexOf(_budgettypeid+"");
   				if(_idx < 0){
   					ybudgetvalues.add(_inputValArray);
   					ysubject3names.add(_budgettypeid+"");
   				}
   			}
   		}

   		//如果是批准生效则做校验
   		if(msubject3names.size() > 0 || qsubject3names.size() > 0 || hsubject3names.size() > 0 || ysubject3names.size() > 0){
			StringBuffer errorInfo = new StringBuffer();
   			FnaBudgetControl fnaBudgetControl = new FnaBudgetControl();
   			fnaBudgetControl.checkBudgetListForImp(_organizationtype, _budgetorganizationid, _budgetperiods, 
   					mbudgetvalues, msubject3names, 
   					qbudgetvalues, qsubject3names, 
   					hbudgetvalues, hsubject3names, 
   					ybudgetvalues, ysubject3names, 
   					ifbottomtotop, 
   					errorInfo, user, true);
			if(errorInfo.length() > 0){
				out.print("<script>"+
					"top.Dialog.alert("+JSONObject.quote(errorInfo.toString())+", "+
					"function(){wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');});\r\n"+
					"</script>");
				return ;
			}
   		}
    }
	
}
boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
	return ;
}
boolean logstatus = RequestManager.saveRequestLog() ;

FnaCommon fnaCommon = new FnaCommon();
if("reject".equals(src) && "0".equals(RequestManager.getNextNodetype())) {    //退回后重新提交
	fnaCommon.releaseBillFnaBudget(requestid);

}else if( RequestManager.getNextNodetype().equals("3")) {    //update to new revision	
	fnaCommon.effectBillFnaBudget(requestid);
    
}

//response.sendRedirect("/workflow/request/RequestView.jsp");
//out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%><%@ include file="/workflow/request/RedirectPage.jsp" %> 

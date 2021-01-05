
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.common.xtable.TableSql" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>                
                 
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
request.setCharacterEncoding("UTF-8");
String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom()); 
boolean isReturned = false;
String paras =request.getParameter("paras");
String[] paraArray = Util.TokenizerString2(paras,"&");
session.removeAttribute("branchid");
User user = HrmUserVarify.getUser (request , response) ;
String whereclause="";
String orderclause="";
String orderclause2="";
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;
if(userid.equals("")) {
	userid = ""+user.getUID();
}
SearchClause.resetClause();

String method=Util.null2String(request.getParameter("method"));
String overtime=Util.null2String(request.getParameter("overtime"));
String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
String complete1=Util.null2String(request.getParameter("complete"));
String workflowidtemp=Util.null2String(request.getParameter("workflowid"));
String wftypetemp=Util.null2String(request.getParameter("wftype"));
String cdepartmentid=Util.null2String(request.getParameter("cdepartmentid"));
int date2during=Util.getIntValue(Util.null2String(request.getParameter("date2during")),0);
int isovertime = 0;
int start = 0;
int iswaitdo = 0;

if (fromPDA.equals("1"))
{
	response.sendRedirect("WFSearchResultPDA.jsp?workflowid="+workflowidtemp+"&wftype="+wftypetemp+"&complete="+complete1);
	return;}

if(overtime.equals("1")){
	//response.sendRedirect("WFSearchResult.jsp?isovertime=1");
	//request.setParameter("isovertime","1");
	isovertime=1;
	//return;
}

if(method.equals("viewhrm")){
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	
    if( isoracle ) {
	    whereclause+=" (',' + TO_CHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }else  if( isdb2 ) {
	    whereclause+=" (',' + VARCHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
	}
    else {
        whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }

	SearchClause.setWhereClause(whereclause);
	//response.sendRedirect("WFSearchResult.jsp?start=1");
	start = 1;
	//return;
	isReturned = true;
}

if(method.equals("all")){
	String complete=Util.null2String(request.getParameter("complete"));

	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
	    whereclause += " t2.isremark in( '0','1','5','8','9','7') and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
		//whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3'  and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
    //modify by xhheng @20030525 for TD1725
		whereclause += " t2.isremark in('2','4') and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	else if(complete.equals("2")){
    //modify by xhheng @20030525 for TD1725
		whereclause += "  t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
  	start=1;
  	iswaitdo = 1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
	  start = 1 ;
	//return;
  isReturned =  true;
}
if(method.equals("myall")){
	String complete=Util.null2String(request.getParameter("complete"));
	
	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	whereclause +="  t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	//response.sendRedirect("WFSearchResult.jsp?start=1");
	start =1;
	//return;
	isReturned =  true;
}
if(method.equals("myreqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
	    whereclause += " t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(inSelectedWorkflowStr) + ") ";
    }
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and (isvalid='1' or isvalid='3') ) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and (isvalid='1' or isvalid='3')) ";
	}
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	//response.sendRedirect("WFSearchResult.jsp?start=1");
	start = 1;
	//return;
	isReturned =  true;
}
if(method.equals("myreqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	//response.sendRedirect("WFSearchResult.jsp?start=1");
	start =1;
	//return;
	isReturned =  true;
}

if(method.equals("reqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
	    whereclause += " t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(inSelectedWorkflowStr) + ") ";
    }
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2' and t2.iscomplete=0  and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
  	  //request.setAttribute("start","1");
  	  start = 1;
  	  //request.setAttribute("iswaitdo","1");
  	start = 1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
    start = 1;
	//return;
  isReturned =  true;
}
//TD8778 褚俊 根据流程类型进入流程列表页面，精确到流程节点
if(method.equals("reqeustbywftypeNode")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
	String workFlowIDsRequest=Util.null2String(request.getParameter("workFlowIDsRequest"));
	String workFlowNodeIDsRequest=Util.null2String(request.getParameter("workFlowNodeIDsRequest"));
	
    String selectedworkflow = "";
    String inSelectedStr = "";
	List selectedWorkflowIdList = Util.TokenizerString(workFlowIDsRequest,",");
    if(fromAdvancedMenu==1){
		for(int i=0; i<selectedWorkflowIdList.size(); i++){
			String wfID = (String)selectedWorkflowIdList.get(i);
			if(!"".equals(workFlowNodeIDsRequest)){
				inSelectedStr += "or ( t1.workflowid = "+wfID+" and t1.currentnodeid in ("+workFlowNodeIDsRequest+") ) ";
			}else{
				inSelectedStr += "or ( t1.workflowid = "+wfID+" ) ";
			}
		}
		if(!"".equals(inSelectedStr)){
			inSelectedStr = inSelectedStr.substring(2);
			whereclause += " ( " + inSelectedStr + " ) ";
		}
    }

    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2' and t2.iscomplete=0  and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
	  iswaitdo=1;
	  iswaitdo =1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
 	 start= 1;
	//return;
  isReturned =  true;
}
//add by ben根据单据号得到流程 
if(method.equals("reqeustbybill")){
	String billid=Util.null2String(request.getParameter("billid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
	}
	
	if(complete.equals("0")){  //未审批
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1 ";
		//whereclause += " and (t1.currentnodetype <> '3' or ((t2.isremark ='1' or t2.isremark ='8' or t2.isremark ='9') and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){ 
		whereclause += " and t1.currentnodetype = '3' and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){  //已审批 （把办结和已办一起显示）
		whereclause += "   and ((t2.isremark ='2' and t1.currentnodetype <> 3 and t2.iscomplete=0) or  (t1.currentnodetype = '3')) and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
	  start = 1;
	  iswaitdo = 1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
	  start = 1;
	//return;
  isReturned =  true;
}
if(method.equals("reqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3')) and t2.islasttimes=1";
	
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
		whereclause +=" and t2.isremark in( '0','1','8','9','5','7') ";
        whereclause += " and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
		whereclause +=" and t2.isremark in( '0','1','8','9','5','7') ";
        whereclause += " and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
	}
    //complete=8表示超时事宜，
	else if(complete.equals("8")){
        whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
        whereclause += " and t1.currentnodetype <> 3 ";
	}
    SearchClause.setWhereClause(whereclause);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
   
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
	  start=1;
	  iswaitdo=1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
  	start=1;
	//return;
  isReturned =  true;
}
if(method.equals("reqeustbywfidNode")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	String nodeids = Util.null2String(request.getParameter("nodeids"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	if(!"".equals(nodeids)){
		whereclause +=" and t1.currentnodeid in ("+nodeids+") ";
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3')) and t2.islasttimes=1";
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
		whereclause +=" and t2.isremark in( '0','1','8','9','5','7') ";
        whereclause += " and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
		whereclause +=" and t2.isremark in( '0','1','8','9','5','7') ";
        whereclause += " and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
	}
    //complete=8表示超时事宜，
	else if(complete.equals("8")){
        whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
        whereclause += " and t1.currentnodetype <> 3 ";
	}
    SearchClause.setWhereClause(whereclause);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
   
  if(complete.equals("0") || complete.equals("3")){//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  //response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
	  start=1;
	  iswaitdo=1;
  }
  else
    //response.sendRedirect("WFSearchResult.jsp?start=1");
  	start=1;
	//return;
  isReturned =  true;
}
String createrid ="";
String docids = "";
String crmids ="";
String hrmids ="";
String prjids = "";
String creatertype ="";
String workflowid = "";
String nodetype = "";
String fromdate = "";
String todate = "";
String lastfromdate ="";
String lasttodate = "";
String requestmark = "";
String branchid ="";
String requestlevel = "";
String requestname ="";
String querys = "";
if(!isReturned){
	createrid=Util.null2String(request.getParameter("createrid"));
	docids=Util.null2String(request.getParameter("docids"));
	crmids=Util.null2String(request.getParameter("crmids"));
    hrmids=Util.null2String(request.getParameter("hrmids"));
    prjids=Util.null2String(request.getParameter("prjids"));
    creatertype=Util.null2String(request.getParameter("creatertype"));
	workflowid=Util.null2String(request.getParameter("workflowid"));
	nodetype=Util.null2String(request.getParameter("nodetype"));
	fromdate=Util.null2String(request.getParameter("fromdate"));
	todate=Util.null2String(request.getParameter("todate"));
	lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
	lasttodate=Util.null2String(request.getParameter("lasttodate"));
	requestmark=Util.null2String(request.getParameter("requestmark"));
	branchid=Util.null2String(request.getParameter("branchid"));
if (!branchid.equals("")) session.setAttribute("branchid",branchid);
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
	requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//add by xhheng @20050414 for TD 1545

if(request.getParameter("iswaitdo")!=null){
	//iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
}

Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


if(!createrid.equals("")&&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.creater='"+createrid+"'";}
	else {whereclause+=" and t1.creater='"+createrid+"'";}
	if(!creatertype.equals("")){
		if(whereclause.equals("")) {whereclause+=" t1.creatertype='"+creatertype+"'";}
		else {whereclause+=" and t1.creatertype='"+creatertype+"'";}
	}
}
//添加附件上传文档的查询
if(!docids.equals("")&&!isReturned){
    RecordSet.executeSql("select fieldname from workflow_formdict where fieldhtmltype=6 ");
}

if( isoracle&&!isReturned ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , To_char(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}else if( isdb2 &&!isReturned) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , varchar(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}
else if(!isReturned){
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (',' + CONVERT(varchar,t4."+fieldname+") + ',' LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
    }
}
if(!workflowid.equals("")&&!isReturned){
	if(whereclause.equals("")) 
	{whereclause+=" t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+")";}
	else 
	{
	 /*--xwj for td2045 on 2005-05-26 --查询流程时, 同时选择流程类型和创建人时出错*/
	 //whereclause+=" and t1.workflowid in("+workflowid+")";
	 whereclause = "t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+") and " + whereclause; 
	}
}
if(!cdepartmentid.equals("")&&!isReturned){
    String tempWhere = "";
    ArrayList tempArr = Util.TokenizerString(cdepartmentid,",");
    for(int i=0;i<tempArr.size();i++){
        String tempcdepartmentid = (String)tempArr.get(i);
        if(tempWhere.equals("")) tempWhere += "departmentid="+tempcdepartmentid;
        else tempWhere += " or departmentid="+tempcdepartmentid;
    }
    if(!tempWhere.equals("")){
    if(whereclause.equals("")) {whereclause+=" exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and ("+tempWhere+"))";}
    else {whereclause+=" and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and ("+tempWhere+"))";}
    }
}
if(!requestname.equals("")&&!isReturned){
	
	
	String newsql ="";
	if((requestname.indexOf(" ")==-1&&requestname.indexOf("+")==-1)||(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")!=-1)){
		newsql+="  t1.requestname like '%"+requestname+"%'";
		}else if(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")==-1){
			String orArray[]=Util.TokenizerString2(requestname," ");
			if(orArray.length>0){
				newsql+="  ( ";
			}
			for(int i=0;i<orArray.length;i++){
				newsql+=" t1.requestname like '%"+orArray[i]+"%'";
				if(i+1<orArray.length){
					newsql+=" or ";
				}
			}
			if(orArray.length>0){
				newsql+=" ) ";
			}
		}else if(requestname.indexOf(" ")==-1&&requestname.indexOf("+")!=-1){
			String andArray[]=Util.TokenizerString2(requestname,"+");
			for(int i=0;i<andArray.length;i++){
				newsql+="  t1.requestname like '%"+andArray[i]+"%'";
				if(i+1<andArray.length){
					newsql+=" and ";
				}
			}
		}
	
	if(whereclause.equals("")) {whereclause+=newsql;}
	else {whereclause+=" and "+newsql;}
}
if(!nodetype.equals("")&&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='"+nodetype+"'";}
	else {whereclause+=" and t1.currentnodetype='"+nodetype+"'";}
}
if(!requestmark.equals("")&&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.requestmark like '%"+requestmark+"%'";}
	else {whereclause+=" and t1.requestmark like '%"+requestmark+"%'";}
}

if(!lastfromdate.equals("")&&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate>='"+lastfromdate+"'";}
	else {whereclause+=" and t1.lastoperatedate>='"+lastfromdate+"'";}
}
if(!lasttodate.equals("")&&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate<='"+lasttodate+"'";}
	else {whereclause+=" and t1.lastoperatedate<='"+lasttodate+"'";}
}
if(during==0&&!isReturned){
	if(!fromdate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate>='"+fromdate+"'";}
		else {whereclause+=" and t1.createdate>='"+fromdate+"'";}
	}
	if(!todate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate<='"+todate+"'";}
		else {whereclause+=" and t1.createdate<='"+todate+"'";}
	}
}
else if(!isReturned){
	if(during==1){
		if(whereclause.equals(""))	whereclause+=" t1.createdate='"+today+"'";
		else  whereclause+=" and t1.createdate='"+today+"'";
	}
	if(during==2){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        /* 刘煜 2004－05－08 修改，原来or 之间没有括号，造成系统死机 */
		if(whereclause.equals(""))	
			whereclause+=" ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
		else  
			whereclause+=" and ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
	}
	if(during==3){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==4){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-7);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==5){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==6){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-30);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==7){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,0,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==8){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-365);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
		
}

if( isoracle &&!isReturned) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}else if( isdb2 &&!isReturned) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}
else if(!isReturned) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+=" (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
    }
}

if(state==1 &&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='3'";}
	else {whereclause+=" and t1.currentnodetype='3'";}
}
if(state==2 &&!isReturned){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype<>'3'";}
	else {whereclause+=" and t1.currentnodetype<>'3'";}
}

if(isdeleted!=2 &&!isReturned){
	if(whereclause.equals(""))	{
        if(isdeleted == 0) whereclause+=" (exists (select 1 from workflow_base where (isvalid='1' or isvalid='3') and workflow_base.id=t2.workflowid)) ";
        else whereclause += " exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
	else {
        if(isdeleted == 0) whereclause+=" and (exists (select 1 from workflow_base where (isvalid='1' or isvalid='3') and workflow_base.id=t2.workflowid)) ";
        else whereclause+=" and exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
}

if(!requestlevel.equals("")&&!isReturned){
	if(whereclause.equals(""))	whereclause+=" t1.requestlevel="+requestlevel;
	else	whereclause+=" and t1.requestlevel="+requestlevel;
}


if(whereclause.equals("")&&!isReturned) whereclause+="  islasttimes=1 ";
else if(!isReturned) whereclause+=" and islasttimes=1 ";
whereclause += WorkflowComInfo.getDateDuringSql(date2during);
orderclause="t2.receivedate ,t2.receivetime";
orderclause2="t2.receivedate ,t2.receivetime";

SearchClause.setOrderClause(orderclause);
SearchClause.setOrderClause2(orderclause2);
SearchClause.setWhereClause(whereclause);
SearchClause.setDepartmentid(cdepartmentid);
SearchClause.setWorkflowId(workflowid);
SearchClause.setNodeType(nodetype);
SearchClause.setFromDate(fromdate);
SearchClause.setToDate(todate);
SearchClause.setCreaterType(creatertype);
SearchClause.setCreaterId(createrid);
SearchClause.setRequestLevel(requestlevel);
//response.sendRedirect("WFSearchResult.jsp?query=1&pagenum=1&iswaitdo="+iswaitdo+"&docids="+docids);
querys = "1";
}
%>

<%


String fromdate2 ="" ;
String todate2 ="" ;
String workcode ="" ;
if(request.getParameter("query")!=null){
	querys=Util.null2String(request.getParameter("query"));
}

String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String isfirst =Util.null2String(request.getParameter("isfirst"));



//add by xhheng @20050414 for TD 1545
if(request.getParameter("isovertime")!=null){
	isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
}

if(fromself.equals("1")) {
  //SearchClause.resetClause(); //added by xwj for td2045 on2005-05-26 
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	todate2 = Util.null2String(request.getParameter("todate2"));
    workcode = Util.null2String(request.getParameter("workcode"));
    requestname = Util.null2String(request.getParameter("requestname"));
}
else {

	workflowid = SearchClause.getWorkflowId();
	nodetype = SearchClause.getNodeType();
	fromdate = SearchClause.getFromDate();
	todate = SearchClause.getToDate();
	creatertype = SearchClause.getCreaterType();
	createrid = SearchClause.getCreaterId();
	requestlevel = SearchClause.getRequestLevel();
    fromdate2 = SearchClause.getFromDate2();
	todate2 = SearchClause.getToDate2();
	requestname = SearchClause.getRequestName();
    cdepartmentid = SearchClause.getDepartmentid();
}


String newsql="";


if(fromself.equals("1")) {
	if(!workflowid.equals(""))
	newsql+=" and t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+")" ;

	if(!nodetype.equals(""))
		newsql += " and t1.currentnodetype='"+nodetype+"'";


	if(!fromdate.equals(""))
		newsql += " and t1.createdate>='"+fromdate+"'";

	if(!todate.equals(""))
		newsql += " and t1.createdate<='"+todate+"'";

	if(!fromdate2.equals(""))
		newsql += " and t2.receivedate>='"+fromdate2+"'";

	if(!todate2.equals(""))
		newsql += " and t2.receivedate<='"+todate2+"'";

    if(!workcode.equals(""))
		newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%"+workcode+"%')";
    
    if(!createrid.equals("")){
		newsql += " and t1.creater='"+createrid+"'";
		newsql += " and t1.creatertype= '"+creatertype+"' ";
	}

    if(!cdepartmentid.equals("")){
        String tempWhere = "";
        ArrayList tempArr = Util.TokenizerString(cdepartmentid,",");
        for(int i=0;i<tempArr.size();i++){
            String tempcdepartmentid = (String)tempArr.get(i);
            if(tempWhere.equals("")) tempWhere += "departmentid="+tempcdepartmentid;
            else tempWhere += " or departmentid="+tempcdepartmentid;
        }
        if(!tempWhere.equals(""))
		newsql += " and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and ("+tempWhere+"))";
	}

	if(!requestlevel.equals("")){
		newsql += " and t1.requestlevel="+requestlevel;
	}
	
	if(!requestname.equals("")){
		if((requestname.indexOf(" ")==-1&&requestname.indexOf("+")==-1)||(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")!=-1)){
		newsql+=" and t1.requestname like '%"+requestname+"%'";
		}else if(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")==-1){
			String orArray[]=Util.TokenizerString2(requestname," ");
			if(orArray.length>0){
				newsql+=" and ( ";
			}
			for(int i=0;i<orArray.length;i++){
				newsql+=" t1.requestname like '%"+orArray[i]+"%'";
				if(i+1<orArray.length){
					newsql+=" or ";
				}
			}
			if(orArray.length>0){
				newsql+=" ) ";
			}
		}else if(requestname.indexOf(" ")==-1&&requestname.indexOf("+")!=-1){
			String andArray[]=Util.TokenizerString2(requestname,"+");
			for(int i=0;i<andArray.length;i++){
				newsql+=" and t1.requestname like '%"+andArray[i]+"%'";
			}
		}
	}
	

 if(!querys.equals("1")) {
  if (!fromselfSql.equals(""))
   newsql += " and " + fromselfSql;
}
else
{
if (fromself.equals("1"))
newsql += " and  islasttimes=1 ";
}

}

String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;

String userID = String.valueOf(user.getUID());

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
boolean superior = false;  //是否为被查看者上级或者本身
if(userID.equals(CurrentUser))
{
	superior = true;
}
else
{
	RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND (managerStr LIKE '%," + userID + ",%' OR managerStr LIKE '" + userID + ",%')");
	
	if(RecordSet.next())
	{
		superior = true;	
	}
}



String sqlwhere="";
if(isovertime==1){
    sqlwhere="where t1.requestid = t2.requestid ";
    int perpage=10;
    RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
    if(RecordSet.next()){
       perpage= RecordSet.getInt("numperpage");
    }
    if(perpage <2) perpage=10;
    String requestids="";
    RecordSet.executeSql("select requestid from SysPoppupRemindInfonew where type=10 and userid = "+user.getUID());
    while(RecordSet.next()){
        if(requestids.equals("")){
            requestids=RecordSet.getString("requestid");
        }else{
            requestids+=","+RecordSet.getString("requestid");
        }
    }
    if(requestids.length()>0){
      	sqlwhere +=" and t2.id in (Select max(id) from workflow_currentoperator where requestid in ( "+requestids+") group by requestid)";
    }else{
        sqlwhere +=" and 1>2";
    }

}
else{
    sqlwhere="where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype;
    
    if(!Util.null2String(SearchClause.getWhereClause()).equals("")){
        sqlwhere += " and "+SearchClause.getWhereClause();
		//out.print("sql***********"+SearchClause.getWhereClause());
    }
}

String orderby = "";
//String orderby2 = "";

//out.print(sqlwhere);

sqlwhere +=" "+newsql ;

//orderby=" t1.createdate,t1.createtime,t1.requestlevel";
orderby=SearchClause.getOrderClause();
if(orderby.equals("")){
    orderby="t2.receivedate ,t2.receivetime";
}
//orderby2=" order by t1.createdate,t1.createtime,t1.requestlevel";

//String tablename = "wrktablename"+ Util.getRandom() ;
if(request.getParameter("start")!=null){
	start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
}
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

//add by xhheng @ 20050302 for TD 1545
String strworkflowid="";
int startIndex = 0;
if(!Util.null2String(SearchClause.getWhereClause()).equals(""))
{
  String tempstr=SearchClause.getWhereClause();
  startIndex = tempstr.indexOf("t1.workflowid")+13;
  if(tempstr.indexOf("t1.workflowid in")!=-1){
	strworkflowid=tempstr.substring(startIndex,tempstr.indexOf(")")+1);		
  }
  else if(tempstr.indexOf("t1.workflowid")!=-1){
   //added by xwj for td2045 on 2005-05-26
    if(tempstr.indexOf("and")!=-1)
        strworkflowid=tempstr.substring(startIndex,tempstr.indexOf("and"));
    else
        strworkflowid=tempstr.substring(startIndex,tempstr.indexOf(")")+1);
  }
 
}
else{
  if(!workflowid.equals(""))
  strworkflowid=" in ("+ workflowid +")";
}

if(strworkflowid.equals(""))
  RecordSet.executeSql("select count(id) as mtcount from workflow_base where multiSubmit=1");
else
  RecordSet.executeSql("select count(id) as mtcount from workflow_base where id "+strworkflowid+" and multiSubmit=1");
boolean isMultiSubmit=false;
if(RecordSet.next()){
  if(RecordSet.getInt("mtcount")>0){
    isMultiSubmit=true;
  }
}

int perpage=10;

RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
   
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){     
        perpage= RecordSet.getInt("numperpage");
    }
}





%>

<%
if(RecordSet.getDBType().equals("oracle"))
{
	sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
else
{
	sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
String tableString = "";

if(perpage <2) perpage=10;                                 

String backfields = " t1.requestid, t1.workflowid multiSubmit, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype ";
String fromSql  = " from workflow_requestbase t1,workflow_currentoperator t2 ";
String sqlWhere = sqlwhere;
String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:currentnodeid+column:isremark";
if(!docids.equals("")){
    fromSql  = fromSql+",workflow_form t4 ";
    sqlWhere = sqlWhere+" and t1.requestid=t4.requestid ";
}


if(!superior){
	sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid=" + userID + " and workFlowCurrentOperator.usertype = " + usertype +") ";
	}

if (!branchid.equals("")){
	sqlWhere += " AND t1.creater in (select id from hrmresource where subcompanyid1="+branchid+")  ";
	}

//System.out.println("sql=select " + backfields + " " + fromSql + " " + sqlWhere);
boolean multiSubmit = false;
if(isMultiSubmit && iswaitdo==1){
tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                    " <checkboxpopedom    popedompara=\"column:workflowid+column:isremark+column:requestid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\" />"+ 
                   "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                      "			<head>";
                     


        tableString+="			</head>"+   			
                     "</table>";
}
else{                         
tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                     "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                     "			<head>";

        tableString+="			</head>"+   			
                     "</table>"; 

}




String tableBaseParas = "";

if(isMultiSubmit){
	
	tableBaseParas = "TableBaseParas={\"sessionId\":\""+sessionId+"\",\"multiSubmit\":\""+true+"\",\"gridId\": TableBaseParas.gridId,\"sort\":\""+orderby+"\",\"operates\":[],\"excerpt\":\"\",\"columns\":[],\"pageSize\":"+perpage+",\"poolname\":\"\",\"sqlgroupby\":\"\",\"dir\":\"desc\",\"sqlisdistinct\":\"true\",\"sqlprimarykey\":\"t1.requestid\",\"popedom\":{\"otherpara\":\"\",\"otherpara2\":\"\",\"transmethod\":\"\"}}";
}
else{
	tableBaseParas = "TableBaseParas={\"sessionId\":\""+sessionId+"\",\"multiSubmit\":\""+false+"\",\"gridId\":TableBaseParas.gridId,\"sort\":\""+orderby+"\",\"operates\":[],\"excerpt\":\"\",\"sqlisprintsql\":\"\",\"columns\":[],\"pageSize\":"+perpage+",\"poolname\":\"\",\"sqlgroupby\":\"\",\"dir\":\"desc\",\"sqlisdistinct\":\"true\",\"sqlprimarykey\":\"t1.requestid\",\"sqlform\":\""+fromSql+"\",\"popedom\":{\"otherpara\":\"\",\"otherpara2\":\"\",\"transmethod\":\"\"}}";
}
out.println(tableBaseParas);




TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlisdistinct("true");
xTableSql.setSqlprimarykey("t1.requestid");

session.setAttribute(sessionId,xTableSql);

return;
	
%>
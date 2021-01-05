
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<%@ page import="weaver.search.*" %>
<%@ page import="weaver.workflow.workflow.*" %>
<%@ page import="weaver.conn.*" %>

<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%!

private String null2String(String s){
	if(s==null){
		return "";
	}
	return s;
}

//add by bpf on 2013-11-13
private void sendRedirect(JspWriter out,HttpServletRequest request,HttpServletResponse response,String url){
	//viewScope表示当前查看的是什么样的流程，共有四种状态：
	//complete:归档的




	//done:已办
	//mine:我的请求
	//doing:待办
	String viewScope=request.getParameter("viewScope");
	String numberType=request.getParameter("numberType");
	viewScope=null2String(viewScope);
	numberType=null2String(numberType);
	url+="&viewScope="+viewScope+"&numberType="+numberType;
	
	String reforward=request.getParameter("reforward");
	
	try{
		if(request.getParameter("getCount")!=null && Boolean.valueOf(request.getParameter("getCount"))==true){
			out.print(getCount(request,response));
			request.getSession().setAttribute("SearchClause",request.getSession().getAttribute("orientSearchClause"));
			request.getSession().removeAttribute("orientSearchClause");
			return;
		}
		
		if(Boolean.valueOf(reforward)==true){
			request.getRequestDispatcher(url).forward(request, response);
		}else{
			Enumeration<String> e=request.getParameterNames();
			while(e.hasMoreElements()){
				String paramenterName=e.nextElement();
				String value=request.getParameter(paramenterName);
				url+="&"+paramenterName+"="+value;
			}
			
			response.sendRedirect(url);
		}
	}catch(Exception e){
		
	}
}

%>

<%
session.removeAttribute("branchid");
session.setAttribute("orientSearchClause",SearchClause);
String whereclause="";
String whereclause2 = "";
String orderclause="";
String orderclause2="";

String resourceid = Util.null2String(request.getParameter("resourceid"));
String userid = "".equals(resourceid) ? Util.null2String((String)session.getAttribute("RequestViewResource")) : resourceid ;
resourceid = userid;
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
String logintype = ""+user.getLogintype();
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
int usertype = 0;

if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userid);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
		//QC235172,如果不是查看自己的代办，主从账号统一显示不需要判断

		if(!"".equals(resourceid) && !userid.equals(resourceid)) belongtoshow = "";
		
		String userIDAll = String.valueOf(userid);	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userid+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
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
int viewType=Util.getIntValue(Util.null2String(request.getParameter("viewType")),0);
int isajaxfresh = Util.getIntValue(Util.null2String(request.getParameter("isajaxfresh")),-1);
int viewcondition = Util.getIntValue(request.getParameter("viewcondition"),0);
//跳转到wfserachResult后是否需要头
boolean needHeader = "true".equals(Util.null2String(request.getParameter("needHeader")));
boolean isopenofs = requestutil.getOfsSetting().getIsuse()==1;
boolean showdone = requestutil.getOfsSetting().getShowdone().equals("1");
if (fromPDA.equals("1"))
{
	sendRedirect(out,request,response,"WFSearchResultPDA.jsp?offical="+offical+"&officalType="+officalType+"&workflowid="+workflowidtemp+"&wftype="+wftypetemp+"&complete="+complete1+"&viewType="+viewType);
	return;}

if(overtime.equals("1")){
	sendRedirect(out,request,response,"WFTabForOverTime.jsp?isovertime=1"+"&viewType="+viewType+"&isFromMessage=1");
	return;
}
whereclause = " (t1.deleted=0 or t1.deleted is null)  ";
if(method.equals("viewhrm")){
	//String resourceid=Util.null2String(request.getParameter("resourceid"));
	
    if( isoracle ) {
	    whereclause+=" and (',' + TO_CHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }else  if( isdb2 ) {
	    whereclause+=" and (',' + VARCHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
	}
    else {
        whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }

	SearchClause.setWhereClause(whereclause);
	sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&offical="+offical+"&officalType="+officalType+"&start=1"+"&viewType="+viewType);
	return;
}
String processing = "";
if(method.equals("all")){
	String complete=Util.null2String(request.getParameter("complete"));
	if(complete.equals("0")){
	    
		if(viewcondition == 3){
	    	whereclause += " and (t2.isremark = '5' or (t2.isremark = '0' and isprocessed is not null ))  and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3'))  and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
		}else if(viewcondition == 1 || viewcondition == 2 || viewcondition == 4){
		    whereclause += " and (((t2.isremark='0' and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7'))  or (t2.isremark = '0' and t2.isprocessed is null)) and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
		}else{
		    whereclause += " and ((t2.isremark='0' and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7'))  and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
		}
		//whereclause += " and (t2.isremark in('1','5','8','9','7') or (t2.isremark = '0' and (t2.isprocessed is null or (t2.isprocessed <> '2' and t2.isprocessed <> '3')))) and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
	    
	    // 分页控件上方的控件  1:未读；2：反馈；3：超时；  	add by Dracula @2014-1-10
	    if(viewcondition == 1)
	    	whereclause += " and t2.viewtype = '0' and t2.isremark != '5' and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3'))  and t2.isprocessed is null ";
	    else if(viewcondition == 2)
	    	whereclause += " and t2.viewtype = '-1'";
	    //else if(viewcondition == 3)
	    //	whereclause += " and t2.isremark = '5'";
	    else if(viewcondition == 4)
	    	whereclause += " and t2.requestid in (select requestid from workflow_requestlog where logtype='s')";
	    processing = "0";	//待办

        if(isopenofs){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark='0' ";
            }else if(viewcondition==1){//未读
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark='0' and viewtype=0 ";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }
	}else if(complete.equals("1")){
    //modify by xhheng @20030525 for TD1725
		whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and(t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
		processing = "1";  	//原办结，办结和已办已合并
	}else if(complete.equals("2")){
    //modify by xhheng @20030525 for TD1725
		whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1";
		processing = "2";	//原已办，办结和已办已合并
		//已办/办结:
        //viewcondition=1表示未归档




        if(viewcondition == 1)
        	whereclause += " and (t2.isremark ='2' or (t2.isremark=0 and t2.takisremark =-2)) and t2.iscomplete=0 ";
        //viewcondition=2表示已归档




        else if(viewcondition == 2)
        	whereclause += " and t2.iscomplete=1 and t1.currentnodetype = 3 ";
        //viewcondition=4表示未读
        else if(viewcondition == 4)
        	whereclause += " and t2.viewtype=0  and (agentType <> '1' or agentType is null) "+WorkflowComInfo.getDateDuringSql(date2during);
        //viewcondition=3表示反馈
        else if(viewcondition == 3)
        	whereclause += " and t2.viewtype=-1 ";

        if(isopenofs&&showdone){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark in ('2','4') ";
            }else if(viewcondition==1){//未归档
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark='2' and iscomplete=0 ";
            }else if(viewcondition==2){//已归档
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark in ('2','4') and iscomplete=1";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }else{
        	whereclause2 += " and 1=2 ";
        }
	}
	SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);//统一待办条件
    //System.out.println("whereclause2 = "+whereclause2);
	if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
	SearchClause.setOrderClause(orderclause);
	SearchClause.setOrderClause2(orderclause2);
    SearchClause.setOrderclauseOs(" operatedate, operatetime ");
	if(isajaxfresh != -1)
	{
		return;
	}
	//TD10848 complete=4，表示待办黄色图标流程




	//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	
	if(complete.equals("0") || complete.equals("3") || complete.equals("4")){
	 sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&viewcondition="+viewcondition+"&offical="+offical+"&officalType="+officalType+"&start=1&iswaitdo=1"+"&viewType="+viewType+"&processing="+processing);
	} else {
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&viewcondition="+viewcondition+"&offical="+offical+"&officalType="+officalType+"&start=1&date2during="+date2during+"&viewType="+viewType+"&processing"+processing);
	}
	return;
}
if(method.equals("myall")){
	//String complete=Util.null2String(request.getParameter("complete"));
	
	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if("1".equals(belongtoshow)){
	whereclause +=" and t1.creater in ("+userIDAll+") and t1.creatertype = " + usertype;
	}else{
	whereclause +=" and t1.creater in ("+userid+") and t1.creatertype = " + usertype;
	}
    whereclause2 += requestutil.getSqlWhere("3",userid,"");
	if(viewcondition == 1){ //未归档




		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
        whereclause2 += " and  iscomplete=0 ";
	}
	else if(viewcondition == 2){	//已归档的
		whereclause += " and (t2.isremark in('1', '2','4','5','8','9') or (t2.isremark=0 and t2.takisremark =-2)) and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
		whereclause2 += " and iscomplete=1 ";
	}else if(viewcondition == 0){	//未归档+已归档的总数，如果不加这个条件，有问题，可以看到t2.isremark in (2,4)
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('1', '2','4','5','8','9') and t1.currentnodetype = '3' )) and t2.islasttimes=1 ";
	}else if(viewcondition == 3){ //反馈
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('1', '2','4','5','8','9') and t1.currentnodetype = '3' )) and t2.islasttimes=1  and t2.viewtype=-1";
		whereclause2 += " and 1=2 ";
    }else if(viewcondition == 4) //未读

	{
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('1', '2','4','5','8','9') and t1.currentnodetype = '3' )) and t2.islasttimes=1 and t2.viewtype=0 ";
        whereclause2 += " and 1=2 ";
	}else if(viewcondition == 5) //超时
	{
		//whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.isremark=5 ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and (t2.isremark=5 or (t2.isremark = '0' and isprocessed <> '1' ))  and t1.currentnodetype <> 3 ";
        whereclause2 += " and 1=2 ";
	}
	SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);
	//我的请求，按照创建时间排序



    orderclause="t1.createdate, t1.createtime ";
    orderclause2=orderclause;
    
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
    SearchClause.setOrderclauseOs("createdate,createtime");

    sendRedirect(out, request, response, "WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader + "&start=1&date2during=" + date2during + "&viewType=" + viewType + "&myrequest="+method);
	return;
}
if(method.equals("myreqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	//System.out.println(complete);
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
	whereclause2 += requestutil.getSqlWhere("3",userid,"");
    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    if(!"".equals(selectedContent))
	    {
	    	selectedworkflow = selectedContent;
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

	if(isopenofs){
        whereclause2 += " and workflowid in (select workflowid from ofs_workflow where sysid="+wftype+" and cancel=0 )";
    }
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and (isvalid='1' or isvalid='3') ) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and (isvalid='1' or isvalid='3')) ";
	}
		if("1".equals(belongtoshow)){
	whereclause +=" and t1.creater in ("+userIDAll+") and t1.creatertype = " + usertype;
	}else{
	whereclause +=" and t1.creater in ("+userid+") and t1.creatertype = " + usertype;
	}
	if(viewcondition == 1){	//未归档


		whereclause2 += " and iscomplete=0 ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(viewcondition == 2){//已归档


		whereclause2 += " and iscomplete=1 ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}else if(viewcondition == 0)//全部
	{
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
	}else if(viewcondition == 3){//反馈
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('2','4') and t1.currentnodetype = '3' )) and t2.islasttimes=1  and t2.viewtype=-1";
		whereclause2 += " and 1=2 ";
	}else if(viewcondition == 4) //未读
	{
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('2','4') and t1.currentnodetype = '3' )) and t2.islasttimes=1  and t2.viewtype=0 ";
	}else if(viewcondition == 5) //超时
	{
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and (t2.isremark=5 or (t2.isremark = '0' and isprocessed <> '1' ))  and t1.currentnodetype <> 3 ";
		//whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.isremark=5 ";
		whereclause2 += " and 1=2 ";
	}
	SearchClause.setWhereClause(whereclause);
	SearchClause.setWhereclauseOs(whereclause2);
	sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType+"&myrequest="+method);
	return;
}
if(method.equals("myreqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
			if("1".equals(belongtoshow)){
	whereclause +=" and t1.creater in ("+userIDAll+") and t1.creatertype = " + usertype;
	}else{
	whereclause +=" and t1.creater in ("+userid+") and t1.creatertype = " + usertype;
	}
	}
	else {
	if("1".equals(belongtoshow)){
	whereclause +=" and t1.creater in ("+userIDAll+") and t1.creatertype = " + usertype;
	}else{
	whereclause +=" and t1.creater in ("+userid+") and t1.creatertype = " + usertype;
	}
	}
	whereclause2 += requestutil.getSqlWhere("3",userid,"");
	whereclause2 += " and workflowid="+workflowid ;
	if(viewcondition == 1){//未归档




		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
		whereclause2 +=" and iscomplete=0 ";
	}
	else if(viewcondition == 2){//已归档




		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
		whereclause2 +=" and iscomplete=1 ";
	}else if(viewcondition == 0){//全部
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
	}else if(viewcondition == 3)
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('2','4') and t1.currentnodetype = '3' )) and t2.islasttimes=1 and t2.viewtype=-1";
	else if(viewcondition == 4) //未读
	{
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and ((t1.currentnodetype <> '3') or (t2.isremark in('2','4') and t1.currentnodetype = '3' )) and t2.islasttimes=1 and t2.viewtype=0 ";
		whereclause2 +=" and viewtype=0 ";
	}else if(viewcondition == 5) //超时
	{
		//whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.isremark=5 ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and (t2.isremark=5 or (t2.isremark = '0' and isprocessed <> '1' ))  and t1.currentnodetype <> 3 ";
		whereclause2 +=" and 1=2 ";
	}
	SearchClause.setWhereClause(whereclause);
	SearchClause.setWhereclauseOs(whereclause2);
    SearchClause.setWorkflowId(workflowid);
	sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType+"&myrequest="+method);
	return;
}

if(method.equals("reqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    if(!"".equals(selectedContent))
	    {
	    	selectedworkflow = selectedContent;
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
        if(wftype.indexOf("-")!=-1){
            whereclause += " t1.workflowid in (0) ";
        }else {
            whereclause += " t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(inSelectedWorkflowStr) + ") ";
        }
    }
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}
    whereclause2 +=" and workflowid in ( select workflowid from ofs_workflow   where sysid = "+wftype+" and (cancel=0 or cancel is null) ) ";
	if(complete.equals("0")){
		whereclause +="  and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办/办结事宜
	else if(complete.equals("2")){
		whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2))  and  t2.islasttimes=1";
		//已办/办结:
        //viewcondition=1表示未归档




        if(viewcondition == 1)
        	whereclause += " and t2.isremark ='2' and t2.iscomplete=0 ";
        //viewcondition=2表示已归档




        else if(viewcondition == 2)
        	whereclause += " and t2.iscomplete=1 and t1.currentnodetype = 3 ";
        //viewcondition=4表示未读
        else if(viewcondition == 4)
        	whereclause += " and t2.viewtype=0  and (agentType <> '1' or agentType is null) "+WorkflowComInfo.getDateDuringSql(date2during);
        //viewcondition=3表示反馈
        else if(viewcondition == 3)
        	whereclause += " and t2.viewtype=-1 ";

        if(isopenofs&&showdone){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark in ('2','4') ";
            }else if(viewcondition==1){//已办
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=2 and iscomplete=0";
            }else if(viewcondition==2){//办结
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark in ('2','4') and iscomplete=1";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }else{
        	whereclause2 += " and 1=2 ";
        }
	}
	//complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " and ((t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) or (t2.isremark=0 and t2.takisremark =-2)) and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) or (t2.isremark=0 and t2.takisremark =-2)) and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
	}
	SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType);
	return;
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
				inSelectedStr += "or ( t1.workflowid = "+wfID+" and t1.currentnodeid in ("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(workFlowNodeIDsRequest)+") ) ";
			}else{
				inSelectedStr += "or ( t1.workflowid = "+wfID+" ) ";
			}
		}
		if(!"".equals(inSelectedStr)){
			inSelectedStr = inSelectedStr.substring(2);
			if(!"".equals(whereclause)){
				whereclause = whereclause + " and ";
			}
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
		whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and  ((t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
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
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
//add by ben根据单据号得到流程 
if(method.equals("reqeustbybill")){
	String billid=Util.null2String(request.getParameter("billid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if ("163".equals(billid)) {
		if(whereclause.equals("")) {
			whereclause +=" t1.workflowid in(select id from workflow_base where (formid = "+billid+" or formid in (select formid from carbasic where isuse=1)) and id not in (select workflowid from carbasic where isuse=0) and isbill='1') ";
		}
		else {
			whereclause +=" and t1.workflowid in(select id from workflow_base where (formid = "+billid+" or formid in (select formid from carbasic where isuse=1)) and id not in (select workflowid from carbasic where isuse=0) and isbill='1') ";
		}
	} else {
		if(whereclause.equals("")) {
			whereclause +=" t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
		}
		else {
			whereclause +=" and t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
		}
	}
	
	
	if(complete.equals("0")){  //未审批




		whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1 ";
		//whereclause += " and (t1.currentnodetype <> '3' or ((t2.isremark ='1' or t2.isremark ='8' or t2.isremark ='9') and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){ 
		whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
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
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("reqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	//System.out.println();
	//complete=0表示已办事宜
	if(complete.equals("0")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        }
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3')) and t2.islasttimes=1";
	    whereclause2 += " and isremark='0' ";
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
        if(whereclause.equals("")) {
            whereclause += " (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }else{
		    whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }
        whereclause2 += " and isremark in ('2','4') and iscomplete = 1 ";
	}
    //complete=2表示已办/办结事宜
	else if(complete.equals("2")){
        if(whereclause.equals("")) {
            whereclause += " (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t2.islasttimes=1 ";
        }else{
		    whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2))  and t2.islasttimes=1 ";
        }
        //已办/办结:
        //viewcondition=1表示未归档

        //whereclause2 += " and isremark in ('2','4') ";

        if(viewcondition == 1) {
            whereclause += " and t2.isremark ='2' and t2.iscomplete=0 ";
            //viewcondition=2表示已归档

            //whereclause2 += " and iscomplete = 1 ";

        }else if(viewcondition == 2) {
            whereclause += " and t2.iscomplete=1 and t1.currentnodetype = 3 ";
            //whereclause2 += " and iscomplete = 1 ";
            //viewcondition=4表示未读
        }else if(viewcondition == 4) {
            whereclause += " and t2.viewtype=0  and (agentType <> '1' or agentType is null) " + WorkflowComInfo.getDateDuringSql(date2during);
            whereclause2 += " and 1=2 ";
            //viewcondition=3表示反馈
        }else if(viewcondition == 3) {
            whereclause += " and t2.viewtype=-1 ";
            whereclause2 += " and 1=2 ";
        }
        if(isopenofs&&showdone){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark in (2,4) ";
            }else if(viewcondition==1){//未读
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=2 and iscomplete=0";
            }else if(viewcondition==2){//未读
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=4 and iscomplete=1";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }else{
        	whereclause2 += " and 1=2 ";
        }
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
        whereclause2 += " and 1=2 ";
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
        whereclause2 += " and 1=2 ";
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }
        whereclause2 += " and 1=2 ";
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
        whereclause2 += " and 1=2 ";
	}

    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }
        whereclause2 += " and 1=2 ";
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }
        whereclause2 += " and 1=2 ";
	}
    //complete=8表示超时事宜，




	else if(complete.equals("8")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }else{
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }
        whereclause2 += " and 1=2 ";
	}

    whereclause2 += " and workflowid="+workflowid ;
    SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
    SearchClause.setWorkflowId(workflowid);
   
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("reqeustbywfidNode")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	String nodeids = Util.null2String(request.getParameter("nodeids"));
	if(!"".equals(workflowid)){
        String tempwfids = WorkflowVersion.getAllVersionStringByWFIDs(workflowid) ;
        if(workflowid.indexOf("-")!=-1) tempwfids=workflowid ;
        if(whereclause.equals("")) {
            whereclause +=" t1.workflowid in ("+tempwfids+") ";
        }else{
		    whereclause +=" and t1.workflowid in ("+tempwfids+") ";
        }
        whereclause2 += " and workflowid="+workflowid ;
	}
	if(!"".equals(nodeids)){
        if(whereclause.equals("")) {
            whereclause +=" t1.currentnodeid in ("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids)+") ";
        }else{
		    whereclause +=" and t1.currentnodeid in ("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids)+") ";
        }
        whereclause2 += " and 1=2 ";
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        }
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3')) and t2.islasttimes=1";
		// 分页控件上方的控件  1:未读；2：反馈；3：超时；  	add by Dracula @2014-1-10
	    if(viewcondition == 1)
	    	whereclause += " and t2.viewtype = '0' and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3'))  and t2.isprocessed is null and t2.isremark <> '5'";
	    else if(viewcondition == 2)
	    	whereclause += " and t2.viewtype = '-1' and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
	    else if(viewcondition == 3)
	    	whereclause += " and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3  ";
	    else if(viewcondition == 4)
	    	whereclause += " and t2.requestid in (select requestid from workflow_requestlog where logtype='s') ";
	    processing = "0";	//待办

        if(isopenofs){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=0 ";
            }else if(viewcondition==1){//未读
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=0 and viewtype=0 ";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
        if(whereclause.equals("")) {
            whereclause += " (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }else{
		    whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=4表示待办事宜，灰色new标记(反馈)
	else if(complete.equals("4")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=8表示超时事宜，




	else if(complete.equals("8")){
        if(whereclause.equals("")) {
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }else{
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }
	}
    SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
    SearchClause.setWorkflowId(workflowid);
   
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType+"&processing="+processing);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType+"&processing="+processing);
	return;
}



//add by bpf on 2013-11-13
//新的流程页面中带数字的的左侧菜单的一级菜单（流程大类别）点击之后的跳转




//实现的方式为reqeustByWfType和reqeustbywfidNode两个分支的代码组合了一下




if(method.equals("reqeustByWfTypeAndComplete")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    if(!"".equals(selectedContent))
	    {
	    	selectedworkflow = selectedContent;
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
	    whereclause += " t1.workflowid in (" +WorkflowVersion.getAllVersionStringByWFIDs(inSelectedWorkflowStr) + ") ";
	    whereclause += " and ";
    }
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}

    if(isopenofs){
        whereclause2 += " and workflowid in (select workflowid from ofs_workflow where sysid="+wftype+" and cancel=0 )";
    }
	String nodeids = Util.null2String(request.getParameter("nodeids"));

	if(!"".equals(nodeids)){
        if(whereclause.equals("")) {
            whereclause +=" t1.currentnodeid in ("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids)+") ";
        }else{
		    whereclause +=" and t1.currentnodeid in ("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids)+") ";
        }

        whereclause2 += " and 1=2 ";
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
        if(whereclause.equals("")) {
        	if(viewcondition == 3){
            	whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3'))  and t2.islasttimes=1";
        	}else{
            	whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        	}
        }else{
        	if(viewcondition == 3){
        		whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3'))  and t2.islasttimes=1";
        	}else{
        		whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and t2.islasttimes=1";
        	}
        }
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark in ('1', '8', '9') and t1.currentnodetype = '3')) and t2.islasttimes=1";
		// 分页控件上方的控件  1:未读；2：反馈；3：超时；  	add by Dracula @2014-1-10
	    if(viewcondition == 1)
	    	whereclause += " and t2.viewtype = '0' and t2.isremark != '5' and t2.isprocessed is null ";
	    else if(viewcondition == 2)
	    	whereclause += " and t2.viewtype = '-1'";
	    //else if(viewcondition == 3)
	    	//whereclause += " and t2.isremark = '5'";
	    else if(viewcondition == 4)
	    	whereclause += " and t2.requestid in (select requestid from workflow_requestlog where logtype='s')";
	    processing = "0";	//待办

        if(isopenofs){
            if(viewcondition==0){//全部
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=0 ";
            }else if(viewcondition==1){//未读
                whereclause2 += " and userid="+user.getUID()+" and islasttimes=1 and isremark=0 and viewtype=0 ";
            }else{
                whereclause2 += " and 1=2 ";
            }
        }
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
        if(whereclause.equals("")) {
            whereclause += " (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }else{
		    whereclause += " and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2)) and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
		
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and ((t2.isremark=0 and (t2.takisremark is null or t2.takisremark=0 )) or t2.isremark in('1','5','8','9','7')) and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=8表示超时事宜，




	else if(complete.equals("8")){
        if(whereclause.equals("")) {
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }else{
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }
	}
    SearchClause.setWhereClause(whereclause);
    SearchClause.setWhereclauseOs(whereclause2);
    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        //orderclause="t2.receivedate ,t2.receivetime ";
        orderclause="operatedate, operatetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType+"&processing="+processing);
  else
    sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&start=1&date2during="+date2during+"&viewType="+viewType+"&processing"+processing);
	return;
}














String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
if (!branchid.equals("")) session.setAttribute("branchid",branchid);
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//add by xhheng @20050414 for TD 1545
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;

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


if(!createrid.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.creater='"+createrid+"'";}
	else {whereclause+=" and t1.creater='"+createrid+"'";}
	if(!creatertype.equals("")){
		if(whereclause.equals("")) {whereclause+=" t1.creatertype='"+creatertype+"'";}
		else {whereclause+=" and t1.creatertype='"+creatertype+"'";}
	}
}

//添加附件上传文档的查询




if(!docids.equals("")){
    RecordSet.executeSql("select fieldname from workflow_formdict where fieldhtmltype=6 ");
}

if( isoracle ) {
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
}else if( isdb2 ) {
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
else {
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
if(!workflowid.equals("")){
	if(whereclause.equals("")) 
	{whereclause+=" t1.workflowid in("+ WorkflowVersion.getAllVersionStringByWFIDs(workflowid) +")";}
	else 
	{
	 /*--xwj for td2045 on 2005-05-26 --查询流程时, 同时选择流程类型和创建人时出错*/
	 //whereclause+=" and t1.workflowid in("+workflowid+")";
	 whereclause = "t1.workflowid in("+ WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ") and " + whereclause; 
	}
}
if(!cdepartmentid.equals("")){
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
whereclause += WorkflowComInfo.getDateDuringSql(date2during);
if(!requestname.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.requestname like '%"+requestname+"%'";}
	else {whereclause+=" and t1.requestname like '%"+requestname+"%'";}
}
if(!nodetype.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='"+nodetype+"'";}
	else {whereclause+=" and t1.currentnodetype='"+nodetype+"'";}
}
if(!requestmark.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.requestmark like '%"+requestmark+"%'";}
	else {whereclause+=" and t1.requestmark like '%"+requestmark+"%'";}
}

if(!lastfromdate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate>='"+lastfromdate+"'";}
	else {whereclause+=" and t1.lastoperatedate>='"+lastfromdate+"'";}
}
if(!lasttodate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate<='"+lasttodate+"'";}
	else {whereclause+=" and t1.lastoperatedate<='"+lasttodate+"'";}
}
if(during==0){
	if(!fromdate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate>='"+fromdate+"'";}
		else {whereclause+=" and t1.createdate>='"+fromdate+"'";}
	}
	if(!todate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate<='"+todate+"'";}
		else {whereclause+=" and t1.createdate<='"+todate+"'";}
	}
}
else{
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

if( isoracle ) {
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
}else if( isdb2 ) {
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
else {
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

if(state==1){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='3'";}
	else {whereclause+=" and t1.currentnodetype='3'";}
}
if(state==2){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype<>'3'";}
	else {whereclause+=" and t1.currentnodetype<>'3'";}
}

if(isdeleted!=2){
	if(whereclause.equals(""))	{
        if(isdeleted == 0) whereclause+=" (exists (select 1 from workflow_base where (isvalid=1 or isvalid=3) and workflow_base.id=t2.workflowid)) ";
        else whereclause += " exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
	else {
        if(isdeleted == 0) whereclause+=" and (exists (select 1 from workflow_base where (isvalid=1 or isvalid=3) and workflow_base.id=t2.workflowid)) ";
        else whereclause+=" and exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
}

if(!requestlevel.equals("")){
	if(whereclause.equals(""))	whereclause+=" t1.requestlevel="+requestlevel;
	else	whereclause+=" and t1.requestlevel="+requestlevel;
}


if(whereclause.equals("")) whereclause+="  islasttimes=1 ";
else whereclause+=" and islasttimes=1 ";

orderclause="t2.receivedate ,t2.receivetime";
orderclause2="t2.receivedate ,t2.receivetime";

SearchClause.setOrderClause(orderclause);
SearchClause.setOrderClause2(orderclause2);
SearchClause.setWhereClause(whereclause);

SearchClause.setWorkflowId(workflowid);
SearchClause.setNodeType(nodetype);
SearchClause.setFromDate(fromdate);
SearchClause.setToDate(todate);
SearchClause.setCreaterType(creatertype);
SearchClause.setCreaterId(createrid);
SearchClause.setRequestLevel(requestlevel);
SearchClause.setDepartmentid(cdepartmentid);
sendRedirect(out,request,response,"WFSearchResult.jsp?resourceid=" + resourceid + "&needHeader=" + needHeader  + "&query=1&pagenum=1&iswaitdo="+iswaitdo+"&docids="+docids+"&date2during="+date2during+"&viewType="+viewType);


%>















































<%!
	private String getLike(HttpServletRequest request,String parameter){
		parameter=request.getParameter(parameter);
		if(parameter==null){
			parameter="'%'";
		}else{
			parameter="'%"+parameter+"%'";
		}
		return parameter;
	}
%>
	
<%!
	private String getCount(HttpServletRequest request,HttpServletResponse response){
		String flowTitle=getLike(request,"flowTitle");//流程名称
		String workflowid = "";
		String nodetype = "";
		String fromdate = "";
		String todate = "";
		String creatertype = "";
		String createrid = "";
		String requestlevel = "";
		String fromdate2 = "";
		String todate2 = "";
		String workcode = "";
		String querys = Util.null2String(request.getParameter("query"));
		String fromself = Util.null2String(request.getParameter("fromself"));
		String fromselfSql = Util.null2String(request.getParameter("fromselfSql"));
		String isfirst = Util.null2String(request.getParameter("isfirst"));
		String docids = Util.null2String(request.getParameter("docids"));
		String flag = Util.null2String(request.getParameter("flag"));
		String branchid = "";
		String cdepartmentid = "";
		WorkflowComInfo WorkflowComInfo=null;
		try{
			WorkflowComInfo=new WorkflowComInfo();
		}catch(Exception e){
			
		}
		
		RecordSet RecordSet=new RecordSet();
		User user = HrmUserVarify.getUser (request , response) ;
		int usertype = 0;
		int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")), 0);
		try {
			branchid = Util.null2String((String) request.getSession().getAttribute("branchid"));
		} catch (Exception e) {
			branchid = "";
		}
		BaseBean baseBean = new BaseBean();
		SearchClause SearchClause=(SearchClause)request.getSession().getAttribute("SearchClause");
		int isovertime = Util.getIntValue(request.getParameter("isovertime"), 0);
		


		workflowid = SearchClause.getWorkflowId();
		nodetype = SearchClause.getNodeType();
		fromdate = SearchClause.getFromDate();
		todate = SearchClause.getToDate();
		creatertype = SearchClause.getCreaterType();
		createrid = SearchClause.getCreaterId();
		requestlevel = SearchClause.getRequestLevel();
		fromdate2 = SearchClause.getFromDate2();
		todate2 = SearchClause.getToDate2();
		cdepartmentid = SearchClause.getDepartmentid();
		
		String newsql = "";
		if (!workflowid.equals("") && !workflowid.equals("0"))
			newsql += " and t1.workflowid in(" + workflowid + ")";
		if (date2during > 0 && date2during < 37)
			newsql += WorkflowComInfo.getDateDuringSql(date2during);
		if (fromself.equals("1")) {

			if (!nodetype.equals(""))
				newsql += " and t1.currentnodetype='" + nodetype + "'";

			if (!fromdate.equals(""))
				newsql += " and t1.createdate>='" + fromdate + "'";

			if (!todate.equals(""))
				newsql += " and t1.createdate<='" + todate + "'";

			if (!fromdate2.equals(""))
				newsql += " and t2.receivedate>='" + fromdate2 + "'";

			if (!todate2.equals(""))
				newsql += " and t2.receivedate<='" + todate2 + "'";

			if (!workcode.equals(""))
				newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";

			if (!createrid.equals("")) {
				newsql += " and t1.creater='" + createrid + "'";
				newsql += " and t1.creatertype= '" + creatertype + "' ";
			}
			if (!cdepartmentid.equals("")) {
				String tempWhere = "";
				ArrayList tempArr = Util.TokenizerString(cdepartmentid, ",");
				for (int i = 0; i < tempArr.size(); i++) {
					String tempcdepartmentid = (String) tempArr.get(i);
					if (tempWhere.equals(""))
						tempWhere += "departmentid=" + tempcdepartmentid;
					else
						tempWhere += " or departmentid=" + tempcdepartmentid;
				}
				if (!tempWhere.equals(""))
					newsql += " and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and (" + tempWhere + "))";
			}

			if (!requestlevel.equals("")) {
				newsql += " and t1.requestlevel=" + requestlevel;
			}

			if (!querys.equals("1")) {
				if (!fromselfSql.equals(""))
					newsql += " and " + fromselfSql;
			} else {
				if (fromself.equals("1"))
					newsql += " and  islasttimes=1 ";
			}

		}
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		String CurrentUser = "".equals(resourceid) ? Util.null2String((String) request.getSession().getAttribute("RequestViewResource")) : resourceid;
		String userID = String.valueOf(user.getUID());
		int userid=user.getUID();
		String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
		String userIDAll = String.valueOf(user.getUID());
		
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
		String logintype = "" + user.getLogintype();
		if (logintype.equals("2"))
			usertype = 1;
		if (CurrentUser.equals("")) {
			CurrentUser = "" + user.getUID();
		}
		boolean superior = false; //是否为被查看者上级或者本身




		if (userID.equals(CurrentUser)) {
			superior = true;
		} else {
			RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%," + userID + ",%'");

			if (RecordSet.next()) {
				superior = true;
			}
		}

		String sqlwhere = "";
		if("1".equals(belongtoshow)){
		if (isovertime == 1) {
			sqlwhere = "where t1.requestname like "+flowTitle+" and  (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.id in (Select max(z1.id) from workflow_currentoperator z1 where exists(select 1 from SysPoppupRemindInfonew z2 where  z1.requestid=z2.requestid and z2.type=10 and z2.userid in ("
					+ userIDAll
					+ ") and z2.usertype='"
					+ (Util.getIntValue(logintype, 1) - 1)
					+ "' and exists (select 1 from workflow_currentoperator z3 where z2.requestid=z3.requestid and ((z3.isremark='0' and (z3.isprocessed='2' or z3.isprocessed='3' or z3.isprocessed is null))  or z3.isremark='5') and z3.islasttimes=1)) group by z1.requestid)";
		} else {
			if (superior && !flag.equals(""))
				CurrentUser = userID;
			sqlwhere = "where  t1.requestname like "+flowTitle+" and   (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid in (" + userIDAll + ") and t2.usertype=" + usertype;
			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				sqlwhere += " and " + SearchClause.getWhereClause();
				//out.print("sql***********"+SearchClause.getWhereClause());
			}
		}

		if (RecordSet.getDBType().equals("oracle")) {
			sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in (" + userIDAll + "))) ";
		} else {
			sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater (" + userIDAll + "))) ";
		}
		}else{
			if (isovertime == 1) {
			sqlwhere = "where t1.requestname like "+flowTitle+" and  (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.id in (Select max(z1.id) from workflow_currentoperator z1 where exists(select 1 from SysPoppupRemindInfonew z2 where  z1.requestid=z2.requestid and z2.type=10 and z2.userid in ("
					+ user.getUID()
					+ ") and z2.usertype='"
					+ (Util.getIntValue(logintype, 1) - 1)
					+ "' and exists (select 1 from workflow_currentoperator z3 where z2.requestid=z3.requestid and ((z3.isremark='0' and (z3.isprocessed='2' or z3.isprocessed='3' or z3.isprocessed is null))  or z3.isremark='5') and z3.islasttimes=1)) group by z1.requestid)";
		} else {
			if (superior && !flag.equals(""))
				CurrentUser = userID;
			sqlwhere = "where  t1.requestname like "+flowTitle+" and   (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid = " + CurrentUser + " and t2.usertype=" + usertype;
			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				sqlwhere += " and " + SearchClause.getWhereClause();
				//out.print("sql***********"+SearchClause.getWhereClause());
			}
		}

		if (RecordSet.getDBType().equals("oracle")) {
			sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater=" + user.getUID() + ")) ";
		} else {
			sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater=" + user.getUID() + ")) ";
		}
		}
		String orderby = "";
		sqlwhere += " " + newsql;
		orderby = SearchClause.getOrderClause();
		if (orderby.equals("")) {
			orderby = "t2.receivedate ,t2.receivetime";
		}
		String strworkflowid = "";
		int startIndex = 0;

		String fromhp = Util.null2String(request.getParameter("fromhp"));
		if (fromhp.equals("1")) {
			String eid = Util.null2String(request.getParameter("eid"));
			String tabid = Util.null2String(request.getParameter("tabid"));
			RecordSet.execute("select count(content) as count from workflowcentersettingdetail where  type = 'flowid' and eid=" + eid + "and tabId = '" + tabid + "'");
			if (RecordSet.next()) {
				if (RecordSet.getInt("count") > 0) {
					strworkflowid = " in (select content from workflowcentersettingdetail where  type = 'flowid' and eid=" + eid + "and tabId = '" + tabid + "' )";
				}
			}
		} else {

			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				String tempstr = SearchClause.getWhereClause();
				if (tempstr.indexOf("t1.workflowid") != -1) {
					startIndex = tempstr.indexOf("t1.workflowid") + 13;//added by xwj for td2045 on 2005-05-26
					if (tempstr.indexOf("and") != -1) {
						if (tempstr.indexOf("(t1.deleted=0") != -1) {
							int startIndex1 = tempstr.indexOf("and");
							int startIndex2 = tempstr.indexOf("and", startIndex1 + 1);
							strworkflowid = tempstr.substring(startIndex, startIndex2);
						} else {
							strworkflowid = tempstr.substring(startIndex, tempstr.indexOf("and"));
						}
						if (strworkflowid.indexOf("(") != -1 && strworkflowid.indexOf(")") == -1)
							strworkflowid += ")";
					} else
						strworkflowid = tempstr.substring(startIndex, tempstr.indexOf(")") + 1);
					if (strworkflowid.indexOf("(") != -1 && strworkflowid.indexOf(")") == -1)
						strworkflowid += ")";
				}
			} else {
				if (!workflowid.equals(""))
					strworkflowid = " in (" + workflowid + ")";
			}
		}
			
		String tableString = "";
	
		String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype,t2.isprocessed ";
		String fromSql = " from workflow_requestbase t1,workflow_currentoperator t2 ";//xxxxx
		String sqlWhere = sqlwhere;
		if (sqlWhere.indexOf("in (select id from workflow_base where isvalid=") < 0) {
			sqlWhere += " and t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		}
		String para2 = "column:requestid+column:workflowid+column:viewtype+" + isovertime + "+" + user.getLanguage() + "+column:nodeid+column:isremark+" + userID
				+ "+column:agentorbyagentid+column:agenttype+column:isprocessed";
		if (!docids.equals("")) {
			fromSql = fromSql + ",workflow_form t4 ";
			sqlWhere = sqlWhere + " and t1.requestid=t4.requestid ";
		}
	
		if (!superior) {
if("1".equals(belongtoshow)){
			sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
					+ userIDAll + ") and workFlowCurrentOperator.usertype = " + usertype + ") ";
}else{
			sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
					+ userID + ") and workFlowCurrentOperator.usertype = " + usertype + ") ";
}
		}
	
		if (!branchid.equals("")) {
			sqlWhere += " AND t1.creater in (select id from hrmresource where subcompanyid1=" + branchid + ")  ";
		}
		
		//add by bpf on 2013-11-14
		String countSql="select count(1) as wfCount "+fromSql+sqlWhere;
		try{
			response.getWriter().print(countSql);
			response.getWriter().print("                     ");
		}catch(Exception e){
			
		}
		
		RecordSet.executeSql(countSql);
		String wfCount="0";
	       while(RecordSet.next()){
	       	wfCount=RecordSet.getString("wfCount");
	       }
	       return wfCount;
	       
}
		%>

<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.homepage.cominfo.*,weaver.synergy.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@page import="weaver.page.HPTypeEnum"%>
<%@ page import="weaver.workflow.request.todo.*" %>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page"/>
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />

<jsp:useBean id="userSetting" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body>
<%
   
 //   User user = HrmUserVarify.getUser (request , response) ;
	int eid= Util.getIntValue(request.getParameter("eid"),0) ;
	//主页id
	int hpid= Util.getIntValue(request.getParameter("hpid"),0) ;
	String pagetype=Util.null2String(request.getParameter("pagetype"));
    String fieldids=Util.null2String(request.getParameter("fieldids"));
    String fieldvalues=URLDecoder.decode(Util.null2String(request.getParameter("fieldvalues")), "utf-8");
	int tabid = Util.getIntValue(request.getParameter("tabid"),0);
	int completeflag = Util.getIntValue(request.getParameter("completeflag"),0);
	if(tabid==0){
		rs.execute("select * from hpsetting_wfcenter where eid="+eid +" order by tabId");
		rs.next();
		tabid = Util.getIntValue(rs.getString("tabId"));
		completeflag = Util.getIntValue(rs.getString("completeflag"));
	}
	if(eid==0) return;	
	//
	int wfviewtype= Util.getIntValue(request.getParameter("viewtype"),-1) ;

	String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
	int usertype = 0;
	String logintype = ""+user.getLogintype();
	//System.out.println(userid+"=="+user.getUID());
	if(userid.equals("")||!userid.equals(""+user.getUID())) {
		userid = ""+user.getUID();
		session.setAttribute("RequestViewResource",userid) ;
		if(logintype.equals("2")) usertype= 1;
	}
	
	 
	String strsqlwhere=hpec.getStrsqlwhere(""+eid);
	if(strsqlwhere.equals("")){
		String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" and tabId="+tabid;
		rs.execute(tabSql);
		strsqlwhere = rs.getString("sqlWhere");
	}
    int viewType=0;
	 
	int typeCount=getContentCount(eid+"",tabid+"","typeid");
	int flowCount=getContentCount(eid+"",tabid+"","flowid");
	int nodeCount=getContentCount(eid+"",tabid+"","nodeid");
	String strSqlWf="";
	boolean isExclude=false;
	String showCopy="1";
	
	//if (!"".equals(strsqlwhere))  { //表示为老版本流程中心
	//	HomepageSetting.wfCenterUpgrade(strsqlwhere,eid);
    //} 
     ConnStatement statement = null;
    try{
		 statement=new ConnStatement();
	   String sSql="select * from hpsetting_wfcenter where eid="+eid+" and tabId="+tabid;
	   statement.setStatementSql(sSql) ;	
	   statement.executeQuery();     
	   if(statement.next()){
		    viewType=Util.getIntValue(statement.getString("viewType")); 		
		    showCopy = Util.null2String(statement.getString("showCopy"));
		    completeflag = Util.getIntValue(statement.getString("completeflag"));
			isExclude=Util.getIntValue(statement.getString("isExclude"),0)==0?false:true;		
		}		
	    statement.close();
     }catch(Exception e){
			
	}finally {
		statement.close();
	}
    
	//System.out.println("wfids:"+wfids);
	//System.out.println("nodeids:"+nodeids);
	String extSql = "";
	/*
	if(!"".equals(wfids)){
		extSql = " and f.workflowid in ("+wfids+") ";
	}*/
	
	extSql = getExistsSql(eid+"",tabid+"","f.workflowid","flowid",false);


	
	String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+"");
		String resourceids =user.getUID()+"";
		if(belongtoshow.equals("1")&&"0".equals(user.getAccount_type())){
			String belongtoids = user.getBelongtoids();
			resourceids=resourceids+","+belongtoids;
		}
  	String inSelectedStr="";
  	String inSelectedStrOs=""; //统一待办
  	String whereclause="";
  	String whereclauseOs="";   //统一待办
	String orderclause="";
	String orderclauseOs="";   //统一待办
	String orderclause2="";

	SearchClause.resetClause();
	if(viewType==1){ //待办事宜
		inSelectedStr +=" 1=1 ";
		if (isExclude){
			if(flowCount>0){
				inSelectedStr +=  getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0){
				inSelectedStr +=  getExistsSql(eid+"",tabid+"","t2.nodeid","nodeid",isExclude);
			}

		} else {
			if(flowCount>0){
				inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0){
				inSelectedStr += " and ("+getExistsSql(eid+"",tabid+"","t2.nodeid","nodeid",isExclude,"")+" or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ) )";
			}
		}
		if(flowCount>0){
			inSelectedStrOs += getExistsSql(eid+"",tabid+"","workflowid","flowid",isExclude,"");
		}
		whereclause += inSelectedStr;
		whereclauseOs += inSelectedStrOs;
		if("1".equals(showCopy)){//显示抄送事宜
				whereclause +=" and (t2.isremark in('1','5','8','9','7') or t2.isremark='0' and (takisremark is null or takisremark=0)) and t2.islasttimes=1";
		}else{//不显示抄送事宜
				whereclause +=" and (t2.isremark in('1','5','7') or t2.isremark='0' and (takisremark is null or takisremark=0)) and t2.islasttimes=1";

		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        
		if("".equals(whereclauseOs)){
			whereclauseOs += " 1=1 " + RequestUtil.getSqlWhere("0", ""+user.getUID(), "");
		} else {
			whereclauseOs += RequestUtil.getSqlWhere("0", ""+user.getUID(), "");
		}
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		SearchClause.setWhereClause(whereclause);
		SearchClause.setWhereclauseOs(whereclauseOs);
	    orderclause="t2.receivedate ,t2.receivetime ";
	    orderclauseOs="receivedate ,receivetime ";
	    //System.out.println("isExclude:"+isExclude);
		//System.out.println("whereclause:"+whereclause);
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	    SearchClause.setOrderclauseOs(orderclauseOs);
	    response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid+"&iswaitdo=1");
		
	}else if(viewType==2){ //已办事宜
		inSelectedStr +=" 1=1 ";
		if (isExclude){
			if(flowCount>0){
				inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0) {
			    inSelectedStr+=getExistsSql(eid+"",tabid+"","t1.currentnodeid","nodeid",isExclude)+" and t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid+"",tabid+"","nownodeid","nodeid",isExclude,"")+" )";
			}
		} else {
			if(flowCount>0){
				inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0){
			    inSelectedStr+=" and ("+getExistsSql(eid+"",tabid+"","t1.currentnodeid","nodeid",isExclude,"")+" or t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid+"",tabid+"","nownodeid","nodeid",isExclude,"")+" ) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
			}
		}
		if(flowCount>0){
			inSelectedStrOs += getExistsSql(eid+"",tabid+"","workflowid","flowid",isExclude,"");
		}
	
		if(nodeCount>0) {
			whereclause += "";
		}
		whereclause += inSelectedStr;
		whereclauseOs += inSelectedStrOs;
		whereclause += " and (t2.isremark ='2' or (t2.isremark='0' and takisremark=-2))  and t2.iscomplete=0 and t2.islasttimes=1 ";
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') ) ";
		
		if("".equals(whereclauseOs)){
			whereclauseOs += " 1=1 " + RequestUtil.getSqlWhere("1", ""+user.getUID(), "");
		} else {
			whereclauseOs += RequestUtil.getSqlWhere("1", ""+user.getUID(), "");
		}
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
        	//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		//whereclause += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
		SearchClause.setWhereClause(whereclause);
		SearchClause.setWhereclauseOs(whereclauseOs);
	    orderclause="t2.receivedate ,t2.receivetime ";
	    orderclauseOs="receivedate ,receivetime ";
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	    SearchClause.setOrderclauseOs(orderclauseOs);
	    
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
		
	}else if(viewType==3){ //办结事宜
		/*if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}*/
		inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
		inSelectedStrOs += getExistsSql(eid+"",tabid+"","workflowid","flowid",isExclude,"");
		whereclause += inSelectedStr;
		whereclauseOs += inSelectedStrOs;
		if("".equals(whereclause)){
			whereclause = "t1.currentnodetype = '3' and (t2.isremark in('2','4') or (t2.isremark='0' and takisremark=-2)) and iscomplete=1 and islasttimes=1 ";
		}else{
			whereclause += " and t1.currentnodetype = '3' and (t2.isremark in('2','4') or (t2.isremark='0' and takisremark=-2)) and iscomplete=1 and islasttimes=1 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        
		if("".equals(whereclauseOs)){
			whereclauseOs += " 1=1 " + RequestUtil.getSqlWhere("2", ""+user.getUID(), "");
		} else {
			whereclauseOs += RequestUtil.getSqlWhere("2", ""+user.getUID(), "");
		}
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}

		SearchClause.setWhereClause(whereclause);
		SearchClause.setWhereclauseOs(whereclauseOs);
	    orderclause="t2.receivedate ,t2.receivetime ";
	    orderclauseOs="receivedate ,receivetime ";
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	    SearchClause.setOrderclauseOs(orderclauseOs);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
		
   	}else if(viewType==4){ //我的请求
		inSelectedStr +=" 1=1 ";
		if (isExclude){
			if(flowCount>0){
				inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0){
			    inSelectedStr+=getExistsSql(eid+"",tabid+"","t1.currentnodeid","nodeid",isExclude)+ "and t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid+"",tabid+"","nownodeid","nodeid",isExclude,"")+" )";
			}
		} else {
			if(flowCount>0){
				inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude);
			}
			if(nodeCount>0){
			    inSelectedStr+=" and ("+getExistsSql(eid+"",tabid+"","t1.currentnodeid","nodeid",isExclude,"")+" or t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid+"",tabid+"","nownodeid","nodeid",isExclude,"")+" ) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
			}
		}
   		if(flowCount>0){
   			inSelectedStrOs += getExistsSql(eid+"",tabid+"","workflowid","flowid",isExclude,"");
		}
		whereclause += inSelectedStr;
		whereclauseOs += inSelectedStrOs;
		whereclause +=" and t1.creater in  ("+resourceids+") and t1.creater=t2.userid  and t1.creatertype = " + usertype;

		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		if(completeflag==1){
		    whereclause += " and t1.currentnodetype <> '3' ";
		}else if(completeflag==2){
		    whereclause += " and t1.currentnodetype = '3' ";
		}
		//System.out.println("whereclause=="+whereclause);
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		
		String ofsSw = "";
		if(completeflag==1){
			ofsSw += " and iscomplete=0 ";
		}else if(completeflag==2){
			ofsSw += " and iscomplete=1 ";
		}
		if("".equals(whereclauseOs)){
			whereclauseOs += " 1=1 " + RequestUtil.getSqlWhere("3", ""+user.getUID(), ofsSw);
		} else {
			whereclauseOs += RequestUtil.getSqlWhere("3", ""+user.getUID(), ofsSw);
		}
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		SearchClause.setWhereClause(whereclause);
		SearchClause.setWhereclauseOs(whereclauseOs);
	    orderclause="t2.receivedate ,t2.receivetime ";
	    orderclause="receivedate ,receivetime ";
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	    SearchClause.setOrderclauseOs(orderclauseOs);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
		
	}else if(viewType==5){ //抄送事宜
		/*if(!"".equals(wfids)){
			
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}
		}*/
		inSelectedStr +=getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
	
		whereclause += inSelectedStr;
	
		if("".equals(whereclause)){
			whereclause +=" t2.isremark in ('8', '9','7') and t2.islasttimes=1 ";
		}else{
			whereclause +=" and t2.isremark in ('8', '9','7') and t2.islasttimes=1 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
	    whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		
	    if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
	    
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
		
	}else if(viewType==6){ //督办事宜
	
		
		inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
		
		whereclause += inSelectedStr;
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		whereclause +=" and t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			//whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,false);
		}
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	    SearchClause.setWorkflowId(getContentStr(eid+"",tabid+"","flowid"));
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSuperviseList.jsp?method=workflow");
		
	}else if(viewType==7){ //超时事宜
		
		/*if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}*/
		inSelectedStr +=getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
		whereclause += inSelectedStr;
		
		if("".equals(whereclause)){
			whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
	        whereclause += " and t1.currentnodetype <> 3 ";
		}else{
			whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
	        whereclause += " and t1.currentnodetype <> 3 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		//whereclause+="  and t2.workflowtype!=1 ";
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
		
	}else if(viewType==8){ //反馈事宜
		/*if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}*/
		inSelectedStr +=getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
		whereclause += inSelectedStr;
	
		if(!"".equals(whereclause)){
			whereclause +=" and ";
		}
		whereclause += " t2.needwfback=1 and viewtype=-1 and isremark in('2','4') and t1.requestid = t2.requestid and userid  in ("+resourceids+") and usertype="+(Util.getIntValue(user.getLogintype())-1);		
		whereclause += " and t2.id in(select max(id) from workflow_currentoperator where needwfback = 1 and viewtype = -1 and isremark in ('2', '4') and userid in ("+resourceids+") and usertype="+(Util.getIntValue(user.getLogintype())-1)+" group by requestid)";
		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
		
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&fromhp=1&eid="+eid+"&tabid="+tabid);
	//所有事宜	
	} else if(viewType==10){
	    inSelectedStr += getExistsSql(eid+"",tabid+"","t1.workflowid","flowid",isExclude,"");
		whereclause += inSelectedStr;

		//获取流程共享信息
		String currentid = "";
		currentid = wfShareAuthorization.getCurrentoperatorIDByUser(user);
		
		if(!"".equals(currentid)){
			whereclause +=" and t1.requestid = t2.requestid  and   t2.islasttimes=1 " ;
			whereclause += "and  (( t2.userid in( "+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		}else{
			whereclause +=" and t1.requestid = t2.requestid  and   t2.islasttimes=1 and  t2.userid in( "+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		}
		//是否有共享的流程
		if(!"".equals(currentid)){
			whereclause += " ) or (t2.id in ("+currentid+") )) ";
		}
		
		whereclause += " and (t1.deleted=0 or t1.deleted is null) ";

		whereclause +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
       
		if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			String sqladd="";
			//需添加其他条件
			whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
			whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
			    
			String syparaSqlwhere = sowf.getWFAndSql4Base(eid+"",requestid,hpid,user," where "+whereclause);
			sqladd += syparaSqlwhere;
			String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid+"","",requestid,hpid,user," where "+whereclause,fieldids,fieldvalues);
			sqladd += appendparam;
			
			whereclause += sqladd;
		} else {
			//协同模块添加参数
			whereclause +=setCooperate(user,hpid,eid+"",Util.getIntValue(request.getParameter("requestid"),-1),sowf,whereclause,true);
		}
		
		whereclauseOs = " 1=2 ";
		
		SearchClause.setWhereClause(whereclause);
		SearchClause.setWhereclauseOs(whereclauseOs);
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	    
	    response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1&isall=1&fromhp=1&eid="+eid+"&tabid="+tabid);
	
	}else{ //不是以上任何一个，跳转到安全页面
		inSelectedStr += "t1.workflowid in (0) ";
		whereclause += inSelectedStr;
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchs.jsp?start=1");
		
	}
%>


<%!
public String getExistsSql(String eid,String tabid,String field,String type,boolean isExclude){
	return getExistsSql(eid,tabid,field,type,isExclude,"and");
}
public String getExistsSql(String eid,String tabid,String field,String type,boolean isExclude,String expression){
    RecordSet recordSet = new RecordSet();
	String sql="";
	recordSet.execute("select count(*) from workflowcentersettingdetail where eid="+eid+" and tabid='"+tabid+"' and type='"+type+"'");
	recordSet.next();
	if(recordSet.getInt(1)>0){
		if(isExclude){
			sql = " "+expression+" "+field+" not in (select content from workflowcentersettingdetail where type='"+type+"' and eid="+eid+" and tabId ='"+tabid+"') ";
		}else{
			sql = " "+expression+" "+field+" in (select content from workflowcentersettingdetail where type='"+type+"' and eid="+eid+" and tabId ='"+tabid+"') ";
		}
	}
	    
	
	return sql;

}

public ArrayList getContentList(String eid,String tabid,String type){
	ArrayList list  = new ArrayList();
	RecordSet recordSet = new RecordSet();
	recordSet.execute("select content from workflowcentersettingdetail where eid='"+eid+"' and tabid='"+tabid+"' and type='"+type+"'");
	while(recordSet.next()){
		list.add(recordSet.getString("content"));
	}
	return list;
}

public int getContentCount(String eid,String tabid,String type){
	int count  = 0;
	RecordSet recordSet = new RecordSet();
	recordSet.execute("select count(content) from workflowcentersettingdetail where eid='"+eid+"' and tabid='"+tabid+"' and type='"+type+"'");
	recordSet.next();
	count = recordSet.getInt(1);
	return count;
}

public String getContentStr(String eid,String tabid,String type){
	String contentStr="";
	RecordSet recordSet = new RecordSet();
	recordSet.execute("select content from workflowcentersettingdetail where eid='"+eid+"' and tabid='"+tabid+"' and type='"+type+"'");
	while(recordSet.next()){
		contentStr +=","+recordSet.getString("content");
	}
	if(contentStr.startsWith(",")){
		contentStr.replaceFirst(",","");
	}
	return contentStr;
}

//设置协同条件
public String setCooperate(User user,int hpid,String eid,int requestid,SynergyOperatWorkflow sowf,String whereclause,boolean isaddother){
   String sqladd="";
   //需添加其他条件
   if(isaddother){
       whereclause += " and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
   }
    whereclause += " and (t1.deleted=0 or t1.deleted is null) ";
   //协同模块添加参数
	if( hpid < 0 )
	{
		//通用设置
		String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,hpid,user," where "+whereclause);
		sqladd += syparaSqlwhere;
		//添加相关流程反向规则设置
		String appendparam=sowf.getWFRelationitems(eid,requestid,hpid,user," where "+whereclause);
		sqladd += appendparam;
	}
    return sqladd;
}

%>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.*,weaver.general.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.workflow.request.*" %>
<%@ page import="weaver.workflow.request.todo.RequestUtil" %>
<%@page import="weaver.page.HPTypeEnum"%>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="WorkflowCount" class="weaver.page.element.WorkflowCount" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page"/>
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page"/>
<jsp:useBean id="HomepageFiled" class="weaver.homepage.HomepageFiled" scope="page"/>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page"/>
<jsp:useBean id="userSetting" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<%
    /*
        基本信息
        --------------------------------------
        hpid:表首页ID
        subCompanyId:首页所属分部的分部ID
        eid:元素ID
        ebaseid:基本元素ID
        styleid:样式ID
        
        条件信息
        --------------------------------------
        String strsqlwhere 格式为 条件1^,^条件2...
        int perpage  显示页数
        String linkmode 查看方式  1:当前页 2:弹出页
 
        
        字段信息
        --------------------------------------
        fieldIdList
        fieldColumnList
        fieldIsDate
        fieldTransMethodList
        fieldWidthList
        linkurlList
        strsqlwherecolumnList
        isLimitLengthList

        样式信息
        ----------------------------------------
        String hpsb.getEsymbol() 列首图标
        String hpsb.getEsparatorimg()   行分隔线 
    */

%>
<%  

    int wfTypeCount=0;
    int wfFlowCount = 0;
    int wfNodeCount = 0;
    String viewType="１";
    String strSqlWf="";
    String showCopy="1";
    String completeflag="0";
    boolean isExclude=false;
    
    //更新当前tab信息
    String tabid = Util.null2String(request.getParameter("tabId"));
    String updateSql = "update  hpcurrenttab set currenttab ='"+tabid+"' where eid="
        + eid
        + " and userid="
        + user.getUID()
        + " and usertype="
        + user.getType();
    rs.execute(updateSql);
    
  if (!"".equals(strsqlwhere))  { //表示为老版本流程中心
        HomepageSetting.wfCenterUpgrade(strsqlwhere,Util.getIntValue(eid));
   } 

   String scolltype = "";
   rs.execute("select scrolltype,isRemind from hpelement where id="+eid ); 
   if(rs.next()){
       scolltype = rs.getString("scrolltype");
    }

   String imgType="";
   String imgSrc ="";
  // String scolltype="";
   rs.execute("select imgtype,imgsrc from hpFieldLength where eid="+eid+" and usertype=3 order by id desc");
   if(rs.next()){
        imgType = rs.getString("imgtype");
        imgSrc = rs.getString("imgsrc");

   }
   String tabId = Util.null2String(request.getParameter("tabId"));
   
  ConnStatement statement = null;
    try{
        statement=new ConnStatement();
       String sSql="select * from hpsetting_wfcenter where eid="+eid+" and tabId ='"+tabId+"'";
       statement.setStatementSql(sSql) ;    
       statement.executeQuery();     
       if(statement.next()){
            viewType=Util.null2String(statement.getString("viewType"));     
            completeflag=Util.null2String(statement.getString("completeflag"));         
            
            showCopy = Util.null2String(statement.getString("showCopy"));
             
            isExclude=Util.getIntValue(statement.getString("isExclude"),0)==0?false:true;
            
        }       
        statement.close();
    }catch(Exception e){
    }finally {
        statement.close();
    }
    int tabs = 1;
    String tabsql="select count(1) from hpsetting_wfcenter where eid="+eid;
    rs.execute(tabsql);
    if(rs.next()) tabs = rs.getInt(1);
    HashMap map;
    if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
        map = (HashMap)WorkflowCount.getWorkflowCountByWorkflowForm(Util.getIntValue(request.getParameter("requestid"),-1), Util.getIntValue(hpid), fieldids, fieldvalues, eid, user);
    } else {
        map = (HashMap)WorkflowCount.getWorkflowCount(eid,user);
    }
    String showCount = (String)map.get(tabId);
    int count = Util.getIntValue(showCount.split(",")[0],0);
    if(count>=100) count = 99;
    String flag = Util.null2o(showCount.split(",")[1]);
    
    //统一待办异构系统集成参数
  	int isUse = 0; // 0未启用, 1启用
  	String oaShortName = ""; // 系统简称
  	String oaFullName = ""; // 系统全称
  	String showSysName = "0"; // 0不显示系统名称, 1显示系统简称, 2显示系统全称
  	int showDone = 0; // 0不显示已办(已办、办结), 1显示已办(已办、办结)
  	RecordSet ofsSettingRs =  new RecordSet();
  	ofsSettingRs.execute("select IsUse,OAShortName,OAFullName,ShowSysName,ShowDone from ofs_setting");
  	if(ofsSettingRs.next()) {
  		isUse = ofsSettingRs.getInt("IsUse");
  		oaShortName = ofsSettingRs.getString("OAShortName");
  		oaFullName = ofsSettingRs.getString("OAFullName");
  		showSysName = ofsSettingRs.getString("ShowSysName");
  		showDone = ofsSettingRs.getInt("ShowDone");
  	}
  	//定义列表是否显示"系统名称"栏, 只有待办(1)、已办(2)、办结(3)和我的请求(4)才会显示系统名
  	boolean isShowSysname = false;
  	if (1 == isUse) {
  		if (1 == showDone && ("1".equals(viewType) || "2".equals(viewType) || "3".equals(viewType) || "4".equals(viewType)) && ("1".equals(showSysName) || "2".equals(showSysName))) {
  			isShowSysname = true;
  		} else if (("1".equals(viewType) || "4".equals(viewType)) && ("1".equals(showSysName) || "2".equals(showSysName))) {
  	    	isShowSysname = true;
  	 	}
  	}
    
    String extSql = "";
    
    String backFields="";
    String sqlFrom="";
    String sqlWhere="";
    String ofsBackFields="";  // 统一待办
	String ofsSqlFrom="";     // 统一待办
	String ofsSqlWhere="";    // 统一待办
	String ofsSql = "";       // 统一待办
    String hasexists = " and exists ";
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+"");
    String resourceids =user.getUID()+"";
    if(belongtoshow.equals("1")&&"0".equals(user.getAccount_type())){
        String belongtoids = user.getBelongtoids();
        resourceids=resourceids+","+belongtoids;
    }
    
    //baseBean.writeLog("=============>type="+Util.getIntValue(viewType));
    if(Util.getIntValue(viewType)==1){ //1:待办事宜
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t2.userid, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3 ";
        if("1".equals(showCopy)){//显示抄送事宜
            sqlWhere="where t1.requestid = t2.requestid and (t2.isremark='0' and (takisremark is null or takisremark=0) or  t2.isremark='1' or  t2.isremark='5' or  t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
                " and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
        }else{//不显示抄送事宜
            sqlWhere="where t1.requestid = t2.requestid and (t2.isremark='0' and (takisremark is null or takisremark=0) or  t2.isremark='1' or  t2.isremark='5' or  t2.isremark='7') and t2.islasttimes=1 " +
                " and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
        }
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
                        
        if(getCount(eid,tabId,"nodeid")>0){
            sqlWhere+= getFreeNodeSql(eid,tabid,"t2.nodeid",isExclude );
        //  if(isExclude) hasexists = " and t2.nodeid not in ";
        //  else hasexists = " and t2.nodeid in ";
    /*      String plusStr = " or ";
            if(isExclude) {
                hasexists = " t2.nodeid not in ";
                plusStr = " and ";
            }
            else hasexists = " t2.nodeid in ";
            sqlWhere+= " and ("+hasexists + " (select content from workflowcentersettingdetail where type='nodeid' and eid="+eid+" and tabid='"+tabid+"') " + plusStr + hasexists + "(select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' and f.workflowid in (select content from workflowcentersettingdetail where type='flowid' and eid="+eid+" and tabid='"+tabid+"') )) ";
*/
        }else{
            sqlWhere+=getExistsSql(eid,tabId,"t2.nodeid","nodeid",isExclude);   
        }
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                baseBean.writeLog("syparaSqlwhere==>"+syparaSqlwhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }
        
		//统一待办异构系统流程数据
		if (1 == isUse) {
			ofsBackFields = " sysid, pcurl, requestid, creatorid as creater, 0 as creatertype, workflowid, requestname, " +
			" userid, receivedate, receivetime, viewtype, '' as isreminded, sysid as workflowtype, 0 as nodeid  , 0 as requestlevel, isremark, " +
			" '' as isprocessed, 0 as agentorbyagentid, '' as agenttype ";
			ofsSqlFrom = " from Ofs_todo_data";
			ofsSqlWhere = " where 1=1 " + RequestUtil.getSqlWhere("0", ""+user.getUID(), "");
			ofsSqlWhere += getExistsSql(eid,tabId,"sysid","typeid",isExclude);
			ofsSqlWhere += getExistsSql(eid,tabId,"workflowid","flowid",isExclude);
			
			ofsSql = "select distinct " + ofsBackFields + ofsSqlFrom + ofsSqlWhere;
		}
    } else if (Util.getIntValue(viewType)==2){//2:已办事宜
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.userid,t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype "
            + " , (case  WHEN t2.operatedate IS NULL  THEN t2.receivedate ELSE t2.operatedate END) operatedate "
            + " , (case  WHEN t2.operatetime IS NULL  THEN t2.receivetime ELSE t2.operatetime END) operatetime ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
    
        sqlWhere="where t1.requestid = t2.requestid and (t2.isremark=2 or (t2.isremark='0' and takisremark=-2)) and  t2.iscomplete=0  and t2.islasttimes=1 " +
                " and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and t1.currentnodeid not in("+wfNodeSetting+") and EXISTS(select 1 from workflow_nownode where nownodeid not in("+wfNodeSetting+") and requestid=t1.requestid)";
        } else {
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t1.currentnodeid in("+wfNodeSetting+") or EXISTS(select 1 from workflow_nownode where nownodeid in("+wfNodeSetting+") and requestid=t1.requestid) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
        }*/
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        
        if(getCount(eid,tabId,"nodeid")>0){
            sqlWhere+= getFreeNodeSql(eid,tabid,"t1.currentnodeid",isExclude );
    //      if(isExclude) hasexists = " and t1.currentnodeid not in ";
    //      else hasexists = " and t1.currentnodeid in ";
    //      sqlWhere+= hasexists + " (select content from workflowcentersettingdetail where type='nodeid' and eid="+eid+" and tabid='"+tabid+"' or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' and f.workflowid in (select content from workflowcentersettingdetail where type='flowid' and eid="+eid+" and tabid='"+tabid+"') )) ";
        }else{  
            sqlWhere+=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude);
        }
        
        sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                    String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }

		//统一待办异构系统流程数据
		if (1 == isUse && 1 == showDone) {
			ofsBackFields = " sysid, pcurl, requestid, creatorid as creater, 0 as creatertype, workflowid, requestname, " +
			" userid, receivedate, receivetime, viewtype, '' as isreminded, sysid as workflowtype, 0 as nodeid  , 0 as requestlevel, isremark, " +
			" '' as isprocessed, 0 as agentorbyagentid, '' as agenttype, operatedate, operatetime ";
			ofsSqlFrom = " from Ofs_todo_data";
			ofsSqlWhere = " where 1=1 " + RequestUtil.getSqlWhere("1", ""+user.getUID(), "");
			ofsSqlWhere += getExistsSql(eid,tabId,"sysid","typeid",isExclude);
			ofsSqlWhere += getExistsSql(eid,tabId,"workflowid","flowid",isExclude);
			
			ofsSql = "select distinct " + ofsBackFields + ofsSqlFrom + ofsSqlWhere;
		}
    } else if (Util.getIntValue(viewType)==3){// 3:办结事宜
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.userid,t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype "
            + " , (case  WHEN t2.operatedate IS NULL  THEN t2.receivedate ELSE t2.operatedate END) operatedate "
            + " , (case  WHEN t2.operatetime IS NULL  THEN t2.receivetime ELSE t2.operatetime END) operatetime ";
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
    
        sqlWhere="where t1.requestid = t2.requestid and (t2.isremark in('2','4') or (t2.isremark='0' and takisremark=-2)) and iscomplete=1 and t1.currentnodetype = '3'  and t2.islasttimes=1 " +
                " and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
        
        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
        } else {
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
        }*/
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        
        //sqlWhere+=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude);
        
        
        sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                    String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }
        
		//统一待办异构系统流程数据
		if (1 == isUse && 1 == showDone) {
			ofsBackFields = " sysid, pcurl, requestid, creatorid as creater, 0 as creatertype, workflowid, requestname, " +
			" userid, receivedate, receivetime, viewtype, '' as isreminded, sysid as workflowtype, 0 as nodeid  , 0 as requestlevel, isremark, " +
			" '' as isprocessed, 0 as agentorbyagentid, '' as agenttype, operatedate, operatetime ";
			ofsSqlFrom = " from Ofs_todo_data";
			ofsSqlWhere = " where 1=1 " + RequestUtil.getSqlWhere("2", ""+user.getUID(), "");
			ofsSqlWhere += getExistsSql(eid,tabId,"sysid","typeid",isExclude);
			ofsSqlWhere += getExistsSql(eid,tabId,"workflowid","flowid",isExclude);
			
			ofsSql = "select distinct " + ofsBackFields + ofsSqlFrom + ofsSqlWhere;
		}
    } else if (Util.getIntValue(viewType)==4){//4:我的请求
        
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.userid,t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype, t1.createdate, t1.createtime ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
    
        sqlWhere="where t1.requestid = t2.requestid and t1.creater=t2.userid and t1.creater in ( "+resourceids+") and t1.creatertype = "+(Util.getIntValue(user.getLogintype())-1)+" and t2.islasttimes=1 " ;
                //" and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and t1.currentnodeid not in("+wfNodeSetting+") and t1.requestid in(select requestid from workflow_nownode where nownodeid not in("+wfNodeSetting+"))";
        } else {
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t1.currentnodeid in("+wfNodeSetting+") or t1.requestid in(select requestid from workflow_nownode where nownodeid in("+wfNodeSetting+")) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
        }*/
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        
        if(isExclude){
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude)+" and t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid,tabId," nownodeid","nodeid",isExclude,"")+" and requestid=t1.requestid)";
            }
        }else{
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +="and ("+getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude,"")+" or t1.requestid in(select requestid from workflow_nownode where "+getExistsSql(eid,tabId," nownodeid","nodeid",isExclude,"")+" ) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
            }
        }
                            
        if(completeflag.equals("1")){
            sqlWhere += " and t1.currentnodetype <> '3' ";
        }else if(completeflag.equals("2")){
            sqlWhere += " and t1.currentnodetype = '3' ";
        }
        sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //add by wshen 判断流程非撤消
//      sqlWhere +=" and (t1.currentstatus<>1 or t1.currentstatus is null)and (t1.status<>'撤销' or t1.status is null or t1.status='' ) ";
        
        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }
        
		//统一待办异构系统流程数据
		if (1 == isUse) {
			ofsBackFields = " sysid, pcurl, requestid, creatorid as creater, 0 as creatertype, workflowid, requestname,  " +
			" userid, receivedate, receivetime, viewtype , '' as isreminded, sysid as workflowtype, 0 as nodeid  , 0 as requestlevel, isremark, " +
			" '' as isprocessed, 0 as agentorbyagentid, '' as agenttype,  createdate,  createtime";
			ofsSqlFrom = " from Ofs_todo_data";
			String ofsSw = "";
			if(completeflag.equals("1")){
				ofsSw += " and iscomplete=0 ";
			}else if(completeflag.equals("2")){
				ofsSw += " and iscomplete=1 ";
			}
			ofsSqlWhere = " where 1=1 " + RequestUtil.getSqlWhere("3", ""+user.getUID(), ofsSw);
			ofsSqlWhere += getExistsSql(eid,tabId,"sysid","typeid",isExclude);
			ofsSqlWhere += getExistsSql(eid,tabId,"workflowid","flowid",isExclude);
			
			ofsSql = "select distinct " + ofsBackFields + ofsSqlFrom + ofsSqlWhere;
		}
    }else if (Util.getIntValue(viewType)==5){//5:抄送事宜
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t2.userid , t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
    
        sqlWhere="where t1.requestid = t2.requestid and ( t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
                " and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);

        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
        } else {
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
        }*/
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //sqlWhere+=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude);
        
        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }
    }else if (Util.getIntValue(viewType)==6){//6:督办事宜 

        //ArrayList  flowList= getContentList(eid,tabId,"flowid");  
        ArrayList  flowList= getContentList(eid,tabId,"flowid");	
        int logintype = Util.getIntValue(user.getLogintype());
        int userID = user.getUID();
        
        WFUrgerManager.setLogintype(logintype);
        WFUrgerManager.setUserid(userID);

		String _workflowIDs = "";
	    int countme = 0;
        if(flowList.size()>0) {
            for(int k=0;k<flowList.size();k++){
                String tempworkflowid = (String)flowList.get(k);
                if(tempworkflowid!= null && tempworkflowid.length() > 0){
                    if(countme > 0) _workflowIDs += ",";
                    _workflowIDs += tempworkflowid;
                    countme++;
                }
            }
        }
        WFUrgerManager.setWorkflowIDs(_workflowIDs);

        //性能优化
        //ArrayList wftypes=WFUrgerManager.getWrokflowTree();
        String requestidGetSql = WFUrgerManager.getWfShareSqlWhere();
        

//      List requestlist = new ArrayList();
//      
//        StringBuffer requestidsb = new StringBuffer();
//        
//        StringBuffer requestidsql = new StringBuffer(" 1=2 ");
//        
//        
//      for(int i=0;i<wftypes.size();i++){
//          WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
//          ArrayList workflows=wftype.getWorkflows();
//          
//          for (int j=0;j<workflows.size();j++){
//              WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
//                String tempWorkflow=wfworkflow.getWorkflowid()+"";
//                if(flowList.size()==0||flowList.contains(tempWorkflow)) {
//                    ArrayList requests=wfworkflow.getReqeustids();
//                    requestlist.addAll(requests);
//                    /*
//                    for(int k=0;k<requests.size();k++){
//                        if(requestids.equals("")){
//                            requestids=(String)requests.get(k);
//                        }else{
//                            requestids+=","+requests.get(k);
//                        }
//                    }
//                    */
//                }
//          }
//      }
        
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,max(t2.receivedate) as receivedate,t1.receivetime,t1.requestlevel ";
        if (rs.getDBType().equals("oracle")) {
            backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t1.createdate || t1.createtime  as receivedate,t1.requestlevel ";
            //sqlFrom = " from (select workflowtype,nodeid,workflowid,requestid,max(receivedate||' '||receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid,workflowid,nodeid,workflowtype) t2,workflow_requestbase t1 ";
        } else {
            backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t1.createdate + t1.createtime as receivedate,t1.requestlevel ";
            //sqlFrom = " from (select workflowtype,nodeid,workflowid,requestid,max(receivedate+' '+receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid,workflowtype,nodeid,workflowid) t2,workflow_requestbase t1 ";
        }
        sqlFrom = " from workflow_requestbase t1,(" + requestidGetSql +  ") temp,workflow_base t3  ";
    
        sqlWhere="where temp.requestid=t1.requestid ";
        sqlWhere += " and (t1.currentnodetype is null or t1.currentnodetype <>3) ";
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        sqlWhere += " and exists (select 1 from workFlow_CurrentOperator where t1.workflowid=workflow_currentoperator.workflowid and t1.requestid=workflow_currentoperator.requestid) and NOT EXISTS (select 1 from workFlow_CurrentOperator t where t.isremark in('0','1','5','8','9','7') and t.userid=" + userID + " and t.usertype=" + (logintype - 1) + " and t.requestid=t1.requestid)";
        /*for(int i = 0;i<requestlist.size();i++)
        {
            if(requestlist.size()>100)
            {
                if((i%100==0)&&i>0)
                {
                    requestidsql.append(" or t1.requestid in(-1").append(requestidsb.toString()).append(") ");
                    requestidsb = new StringBuffer();
                }
            }
            requestidsb.append(",").append((String)requestlist.get(i));
        }
        if(!requestidsb.toString().equals(""))
        {
            requestidsql.append(" or t1.requestid in(-1").append(requestidsb.toString()).append(") ");
        }
        sqlWhere+=" and ("+requestidsql.toString()+")";
        */
        //判断流程是否有效
        //sqlWhere +=" and t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t1.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }

        //sqlWhere += " group by t1.requestid,t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t2.receivetime,t1.requestlevel ";
    }else if (Util.getIntValue(viewType)==7){//7:超时事宜
        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype ";
        sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
    
        sqlWhere="where t1.requestid = t2.requestid and t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and  ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') "+
                " and t1.currentnodetype <> 3";
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+") ";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t2.nodeid not in("+wfNodeSetting+"))";
        }else{
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+") ";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t2.nodeid in("+wfNodeSetting+") or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
        }*/
        
        
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        
        if(isExclude){
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude);
            }
        }else{
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +="and ("+getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude,"")+" or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
            }
        }   
        
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }
        
    }else if (Util.getIntValue(viewType)==8){//8:反馈事宜

        //backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
        backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t2.userid, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype ";
        //sqlFrom=" from workflow_requestbase t1, ( select  receivedate,receivetime,requestid,viewtype,isreminded,nodeid,isremark,workflowtype,workflowid from workflow_currentoperator where "+
        //          " id in( select max(id) from workflow_currentoperator where needwfback=1 and viewtype=-1 and isremark in('2','4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+"  group by requestid) "+
        //          ") t2 ";

        sqlFrom=" from workflow_requestbase t1, ( select  receivedate,receivetime,requestid,viewtype,isreminded,nodeid,isremark,workflowtype,workflowid,isprocessed,userid,agentorbyagentid,agenttype from workflow_currentoperator where "+
                    " id in( select max(id) from workflow_currentoperator where needwfback=1 and viewtype=-1 and isremark in('2','4') and userid in ("+resourceids+") and usertype="+(Util.getIntValue(user.getLogintype())-1)+"  group by requestid) "+
                    ") t2,workflow_base t3  ";
        sqlWhere=" where t1.requestid = t2.requestid ";
        sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
        /*if (isExclude==1){
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+") ";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid  not in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and ( t2.nodeid not in("+wfNodeSetting+"))";
        }else{
            if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+") ";
            if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and ( t2.nodeid in("+wfNodeSetting+")  or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ) )";
        }*/
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
        
        sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
        
        if(isExclude){
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +=getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude);
            }
        }else{
            if(!getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude).equals("")){
                sqlWhere +="and ("+getExistsSql(eid,tabId," t1.currentnodeid","nodeid",isExclude,"")+" or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
            }
        }
        
        sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
        //判断流程是否有效
        //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

        //协同模块添加参数
        if(Util.getIntValue(hpid) < 0 )
        {
            if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
                String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                sqlWhere += appendparam;
            } else {
                int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += syparaSqlwhere;
               //添加相关流程反向规则设置
                String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                sqlWhere += appendparam;
            }
        }

    //所有流程（用户参与过的所有流程）
    }else if (Util.getIntValue(viewType)==10){
        
            backFields="0 as sysid, '' as pcurl, t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.userid,t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed,t2.agentorbyagentid,t2.agenttype ";
            sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3  ";
            
            //获取流程共享信息
            String currentid = "";
            currentid = wfShareAuthorization.getCurrentoperatorIDByUser(user);
            if(!"".equals(currentid)){
                sqlWhere = "where t1.requestid = t2.requestid  and t2.islasttimes=1 ";
                sqlWhere += "and  ((t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
            }else{
                sqlWhere="where t1.requestid = t2.requestid  and t2.islasttimes=1 and  t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
            }
            //是否有共享的流程
            if(!"".equals(currentid)){
                sqlWhere += " ) or ("+Util.getSubINClause(currentid, "t2.id", "in")+" )) ";
            }
            
            //该用户参与过
            //sqlWhere="where t1.requestid = t2.requestid  and t2.islasttimes=1 and  t2.userid in ("+resourceids+") and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
            //流程未被删除
            sqlWhere += " and (t1.deleted=0 or t1.deleted is null) ";
            
            sqlWhere+=getExistsSql(eid,tabId,"t2.workflowtype","typeid",isExclude);
            
            sqlWhere+=getExistsSql(eid,tabId,"t2.workflowid","flowid",isExclude);
            
            sqlWhere+=getExistsSql(eid,tabId,"t2.nodeid","nodeid",isExclude);               
            //判断流程是否有效
            //sqlWhere +=" and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
        sqlWhere +=" and t3.id=t2.workflowid and (t3.isvalid='1' or t3.isvalid='3') ";

            //协同模块添加参数
            if(Util.getIntValue(hpid) < 0 )
            {
                if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
                    int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                    String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                    sqlWhere += syparaSqlwhere;
                    String appendparam=sowf.getWFRelationitemsByWorkflowForm(eid,"",requestid,Util.getIntValue(hpid),user,sqlWhere,fieldids,fieldvalues);
                    sqlWhere += appendparam;
                } else {
                    int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
                    String syparaSqlwhere = sowf.getWFAndSql4Base(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                    sqlWhere += syparaSqlwhere;
                   //添加相关流程反向规则设置
                    String appendparam=sowf.getWFRelationitems(eid,requestid,Util.getIntValue(hpid),user,sqlWhere);
                    sqlWhere += appendparam;
                }
            }
            
    }
    sqlWhere +="  and (t1.currentstatus<>1 or t1.currentstatus is null)";//所有流程都排除撤销流程？
    //baseBean.writeLog(sqlFrom+sqlWhere);
    
    //out.println("viewType:"+viewType);
    //out.println("backFields:"+backFields);
    
    
    /*
    sppb.setBackFields(backFields);
    sppb.setPrimaryKey("t1.requestid");
    sppb.setDistinct(true);
    //sppb.setIsPrintExecuteSql(true);
    sppb.setSqlFrom(sqlFrom);
    sppb.setSqlWhere(sqlWhere); 
    if (Util.getIntValue(viewType)==6) {
        //sppb.setSqlOrderBy("receivedate ,t2.receivetime");
        sppb.setSqlOrderBy("receivedate");
        sppb.setDistinct(false);
    }else {
        int ivt = Util.getIntValue(viewType);
      //--------------------------------------------
      // 已办、办结按照处理时间排序
      // 我的请求按照创建时间排序
      // 其他按照接受时间排序
      //--------------------------------------------
        if (ivt == 2 || ivt == 3) {
            sppb.setSqlOrderBy(" operatedate , operatetime");
        } else if (ivt == 4) {
            sppb.setSqlOrderBy("t1.createdate, t1.createtime");
        } else {
            sppb.setSqlOrderBy("t2.receivedate ,t2.receivetime");
        }
    }
    sppb.setSortWay(sppb.DESC);
    
    spu.setRecordCount(perpage);
    spu.setSpp(sppb);
	*/
    
    String imgSymbol="";
    if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
    
    
    String  strStyle="";
    if("1".equals(isFixationRowHeight)) strStyle+="height:"+(perpage*23)+"px;";
    if(!"".equals(background)) strStyle+="background:url('/weaver/weaver.file.FileDownload?fileid="+background+"');";
        int rowcount=0;
                
        //rs=spu.getCurrentPageRs(1,perpage);
        String querySql = getQuerySql(eid, tabId, backFields, sqlFrom, sqlWhere, perpage, viewType, ofsSql);
        //baseBean.writeLog("querySql:"+querySql);
        rs.execute(querySql);
        int height = rs.getCounts()*23;
        int tabsize = Util.getIntValue(request.getParameter("tabsize"),1);
        int eHeight=Util.getIntValue(hpec.getHeight(eid),0);

        if(eHeight>0&&height<eHeight){
            if(tabsize>1){
                height = eHeight-32;
            }else{
                height = eHeight;
            }
        }
    //baseBean.writeLog(strStyle);
%>

      <%
        if("Up".equals(scolltype)||"Down".equals(scolltype)) {
            out.println("<MARQUEE DIRECTION="+scolltype.toLowerCase()+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200 height="+height+">");
        }else if("Left".equals(scolltype)||"Right".equals(scolltype)) {
            out.println("<MARQUEE DIRECTION="+scolltype.toLowerCase()+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200>");
        }
     %>
<TABLE  style="<%=strStyle%>" id="_contenttable_<%=eid%>" class=Econtent  width=100%>
   <TR valign='middle'>
     <TD width=1px valign='middle'>
     <%if(imgType.equals("1")){ %>
        <img src='<%=imgSrc%>' />
     <%} %>
     </TD>
     <TD width='*' valign="top">
        <TABLE width="100%" class="elementdatatable">    
        <%
        String receivetime = "";
        while (rs.next()){
        	int sysid = rs.getInt("sysid");
			String pcurl = Util.null2String(rs.getString("pcurl"));
            String requestid=Util.null2String(rs.getString("requestid"));           
            String workflowid=Util.null2String(rs.getString("workflowid"));
            String nodeid=Util.null2String(rs.getString("nodeid"));
            String workflowtype=Util.null2String(rs.getString("workflowtype"));
            String requestlevel=Util.null2String(rs.getString("requestlevel"));
            String creater=Util.null2String(rs.getString("creater"));
            String isremark=Util.null2String(rs.getString("isremark"));
            String rquserid = Util.null2String(rs.getString("userid"));
            
        %>
        <TR>
                <TD width="8"><%=imgSymbol%></TD>
                <%                  
                    int size=fieldIdList.size();
                    for(int i=0;i<size;i++){
                        String fieldId=(String)fieldIdList.get(i);
                        String columnName=(String)fieldColumnList.get(i);
                        String strIsDate=(String)fieldIsDate.get(i);
                        String fieldTransMethod=(String)fieldTransMethodList.get(i);
                        String fieldwidth=(String)fieldWidthList.get(i);
                        String linkurl=(String)linkurlList.get(i);
                        String valuecolumn=(String)valuecolumnList.get(i);  

                        String isLimitLength=(String)isLimitLengthList.get(i);
                        String showValue="";                    
                        String cloumnValue=Util.null2String(rs.getString(columnName)); 
                        String titleValue = cloumnValue;
                        //cloumnValue = "<font >"+cloumnValue+"</font>";
                        
                        String nameTdTitle="";
                        if("requestname".equals(columnName)){   
							cloumnValue = cloumnValue.replaceAll("<br>"," ");
							cloumnValue = cloumnValue.replaceAll("&dt;&at;"," ");
							//cloumnValue = Util.delHtml(cloumnValue);
                            //改为按要求显示自定义流程标题的前缀信息
                            String nodetitle="";
                            if(Util.getIntValue(viewType)!=6){ //非督办
                                if("0".equals(isremark)){
                                    rsIn.executeSql("select nodetitle from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
                                }else{
                                    if(rsIn.getDBType().equals("oracle")){
                                        rsIn.executeSql("select nodetitle from workflow_flownode f, (select nodeid from workflow_currentoperator t2 where rownum = 1 and t2.isremark=0 and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and t2.requestid="+requestid+" order by  t2.receivedate desc, t2.receivetime desc ) n where f.workflowid="+workflowid+" and f.nodeid = n.nodeid ");
                                    }else{
                                        rsIn.executeSql("select nodetitle from workflow_flownode where workflowid="+workflowid+" and nodeid = (select top 1 nodeid from workflow_currentoperator t2 where t2.isremark=0 and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and t2.requestid="+requestid+" order by  t2.receivedate desc, t2.receivetime desc ) ");
                                    }
                                }
                                if(rsIn.next()){
                                    nodetitle = Util.null2String(rsIn.getString("nodetitle"));
                                }
                            }  
                            nameTdTitle=titleValue;
							cloumnValue = cloumnValue.replace("<br>"," ");
                            if("".equals(nodetitle)) cloumnValue=cloumnValue;   
                            else    cloumnValue="（"+nodetitle+"）"+cloumnValue;  
                                             
                        }                                      
                        //if("1".equals(isLimitLength))   cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
                       

                            //cloumnValue=Util.StringReplace(cloumnValue,"&lt;","<"); 
                            //cloumnValue=Util.StringReplace(cloumnValue,"&gt;",">"); 
                            cloumnValue=Util.StringReplace(cloumnValue,"&quot;","\"");
                            cloumnValue=Util.StringReplace(cloumnValue,"&nbsp;"," ");

                            //cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
                      
                        
              %>
              <%
			  //统一待办集成参数选择显示系统名称且元素显示字段选中"系统名称"字段才显示系统名称
			  if("sysname".equals(columnName)){
				  String sysname = "";
				  if (isShowSysname) {
					  if (sysid == 0) { // OA
						  sysname = "1".equals(showSysName) ? oaShortName : oaFullName;
					  } else if (sysid < 0) { // 异构系统
						  RecordSet ofsSysinfoRs = new RecordSet();
						  ofsSysinfoRs.execute("select SysShortName, SysFullName from Ofs_sysinfo where sysid = " + sysid);
				    	  if (ofsSysinfoRs.next()) {
				    		  sysname = "1".equals(showSysName) ? ofsSysinfoRs.getString("SysShortName") : ofsSysinfoRs.getString("SysFullName");
				          }
				      }
				  } else {
					  fieldwidth = "1";
				  }
			  %>
				<td width="<%=fieldwidth%>">
					<font class=font><%out.print(sysname);%></font>
				</td>
			  <%}%>
              <%if("requestname".equals(columnName)){
            	  if (sysid < 0) {
  					%>
  						<td class='reqdetail' width="<%=fieldwidth%>" title="<%=nameTdTitle%>" rquserid="<%=rquserid%>" requestid="<%=requestid %>">
  					<%
					    cloumnValue = cloumnValue.replaceAll("<br>"," ");
						cloumnValue = cloumnValue.replaceAll("&dt;&at;"," ");
  						String pcprefixurl = "";
  						RecordSet ofsSysinfoRs = new RecordSet();
  						ofsSysinfoRs.execute("select Pcprefixurl from Ofs_sysinfo where sysid = " + sysid);
  				    	if (ofsSysinfoRs.next()) {
  				    		pcprefixurl = ofsSysinfoRs.getString("Pcprefixurl");
  				        }
  				    	//String url = pcprefixurl + pcurl;
  				    	String url = "/workflow/request/ViewRequest.jsp?requestid="+requestid+"&_workflowid="+workflowid+"&_workflowtype="+workflowtype+"&isovertime=0";
  				    	if ("0".equals(rs.getString("viewtype"))) {
  				    		out.print("<a class=\"ellipsis notRead\" href=\"javaScript:openFullWindowHaveBarForWF('"+url+"','"+requestid+"')\"><font class=\"font\"><span class=\"reqname\" onclick=\"javaScript:setWorkFlowRefresh("+eid+","+ebaseid+")\"><font class=\"font\">"+cloumnValue+"</font></span></font></font></a><IMG id=\'wflist_"+requestid+"img\' title=\'"+SystemEnv.getHtmlLabelName(19154,user.getLanguage())+"\' class=\'wfremindimg\' src=\'/images/ecology8/statusicon/BDNew_wev8.png\' align=absbottom>");
  				    	} else {
  				    		out.print("<a class=\"ellipsis\" href=\"javaScript:openFullWindowHaveBarForWF('"+url+"','"+requestid+"')\"><font class=\"font\"><span class=\"reqname\" onclick=\"javaScript:setWorkFlowRefresh("+eid+","+ebaseid+")\"><font class=\"font\">"+cloumnValue+"</font></span></font></font></a>");
  				    	}
  			    	 %>
  			    	 	</td>
  				    <%
  					} else {
                        //cloumnValue = Util.delHtml(cloumnValue);
						cloumnValue = cloumnValue.replace("<br>"," ");
                        cloumnValue = "<font class=font><span class='reqname'  onclick='javaScript:setWorkFlowRefresh("+eid+","+ebaseid+")' > <font class='font'>"+cloumnValue;
                        String strName="";  
                        if(Util.getIntValue(viewType)==6){
                            String para2 = requestid+"+"+workflowid+"+"+user.getUID()+"+"+(Util.getIntValue(user.getLogintype())-1)+"+"+ user.getLanguage()+"+"+rquserid;
                            cloumnValue += "</font></span></font>";
                            strName=WorkFlowTransMethod.getWfNewLinkByUrger(cloumnValue,para2);
							strName =  strName.replace("<br>"," ");
                        } else {
                            
                            //if(Util.getIntValue(viewType)==1)
                            //{
                                int isbill=0;
                                int formid=0;
                                ////根据后台设置在MAIL标题后加上流程中重要的字段
                                rsIn.execute("select formid,isbill from workflow_base where id="+workflowid);
                                if (rsIn.next()){
                                    formid=rsIn.getInt(1);
                                    isbill=rsIn.getInt(2);
                                    
                                }
                                if(!belongtoshow.equals("1")||!"0".equals(user.getAccount_type())){
                                    MailAndMessage mailTitle=new MailAndMessage();
                                    
                                    String titles=mailTitle.getTitle(Util.getIntValue(requestid,-1),Util.getIntValue(workflowid,-1),formid,user.getLanguage(),isbill);
                                    if(!titles.equals("")) {
                                        cloumnValue+="<b>（"+titles+"）</b>";
                                        //out.println("<b>（"+titles+"）</b>");
                                        nameTdTitle =nameTdTitle+"（"+titles+"）";
                                    }
                                }
                            //}
                            //nameTdTitle= Util.delHtml(nameTdTitle);
							nameTdTitle = nameTdTitle.replaceAll("&dt;&at;"," ");
                            nameTdTitle = nameTdTitle.replaceAll("%nbsp;"," ");
                            cloumnValue += "</font></span></font>";
                            strName=HomepageFiled.getRequestNewLink(rs,user,cloumnValue,linkmode,belongtoshow);
                        }   
                        %>
                        <td class='reqdetail' width="<%=fieldwidth%>" title="<%=nameTdTitle%>" rquserid="<%=rquserid%>" requestid="<%=requestid %>">
                            <%      
                         //strName = "<font class=font>"+strName+"</font>";
                       if("0".equals(rs.getString("viewtype"))){
                          strName = strName.replace("href"," class='ellipsis notRead' href");
                        }else{
                         strName = strName.replace("href"," class='ellipsis' href");
                        }
						 strName =  strName.replaceAll("<br>"," ");
						 strName = strName.replaceAll("&dt;&at;"," ");
                        out.println(strName);
                    %>
                </td>
             <%}}%>  
                
             <%if("importantleve".equals(columnName)){%>
                <td width="<%=fieldwidth%>"><%="<font class=font>"+WorkFlowTransMethod.getWFSearchResultUrgencyDegree(requestlevel,""+user.getLanguage())+"</font>"%></td>
              <%}%>  
                
                
               <%if("creater".equals(columnName)){
              
               String tmpValue = HomepageFiled.getHrmStr(rs,user,cloumnValue,linkmode);
               tmpValue = tmpValue.substring(0,tmpValue.indexOf(">")+1)+"<font class=font>"+tmpValue.substring(tmpValue.indexOf(">")+1,tmpValue.indexOf("</a>"))+"</font>"+tmpValue.substring(tmpValue.indexOf("</a>"),tmpValue.length());
               %>
                <td width="<%=fieldwidth%>"><%=tmpValue%></td>
              <%}%>

               <%if("createrDept".equals(columnName)){%>
                <td width="<%=fieldwidth%>">
                    <%="<font class=font>"+DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(creater))+"</font>"%>
               </td>
              <%}%>

               <%if("workflowtype".equals(columnName)){
			   		String workflowname = "";
			   		if (sysid < 0) {
			   		 	RecordSet ofsWfRs = new RecordSet();
			   			ofsWfRs.execute("select workflowname from ofs_workflow where sysid = " + sysid + " and workflowid = " + workflowid);
			   			if (ofsWfRs.next()) {
				   			workflowname = ofsWfRs.getString("workflowname");
			   			}
			   		} else {
			   			workflowname = WorkflowComInfo.getWorkflowname(workflowid);
			   		}
			   %>
				<td  width="<%=fieldwidth%>">
					<%="<font class=font>"+workflowname+"</font>"%>
                </td>
              <%}%>
               <%
                if(Util.getIntValue(viewType)==6){//TD:39434
                    cloumnValue = Util.null2String(rs.getString("receivedate"));
                    receivetime = cloumnValue.substring(10);
                    cloumnValue = cloumnValue.substring(0,10);
                }       
                if("receivedate".equals(columnName)){%>
                <td width="<%=fieldwidth%>"><%="<font class=font>"+cloumnValue+"</font>"%></td>
              <%}%>

              <%if("receivetime".equals(columnName)){
                  if(Util.getIntValue(viewType)==6){
                    cloumnValue = receivetime;
                  }
                  %>
                <td width="<%=fieldwidth%>"><%="<font class=font>"+cloumnValue+"</font>"%></td>
              <%}%>

            <%}%>
            <td style="position:relative;width:10px;">
                <img class="imgdetail" style="cursor:pointer; display:none;position: absolute;right:5px;top:8px;" src="/images/ecology8/homepage/req_wev8.png" width="12px" height="12px;">
            </td>
        </TR>
        <%
        rowcount++;
        if(perpage!=1&&rowcount<perpage){
        %>      
         <TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=<%=size+2%>></td></TR>
         <%}%>
        <%}%>
         </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>
<%if("Left".equals(scolltype)||"Right".equals(scolltype)||"Up".equals(scolltype)||"Down".equals(scolltype)) 
    out.println("</MARQUEE>");
%>

<div id="signPreview_<%=eid %>" class="signPreview" style="z-index:9999;">
    <div class="arrowsblock" style="display: none"><img src="/images/ecology8/homepage/arrows_wev8.png" width="13px" height="8px"></div>
    <div class="arrowsblockup" style="display: none"><img src="/images/ecology8/homepage/arrows_up_wev8.png" width="13px" height="8px"></div>
    
    <div class="signContainer" style="position: relative">
        <img style="position: absolute;top:10px;right: 8px;cursor: pointer;z-index:1;" class="close" src="/images/ecology8/homepage/close_wev8.png" width="20px" height="20px">
        <div style="margin-top:-10px;background:#e5f5ff;height:40px;line-height:40px;font-size: 16px;color: #242424;z-index:1;padding-left:20px;">
			<div class="signTitle" style="line-height: 40px;height: 40px;overflow: hidden;margin-right:38px;"></div>
        </div>



        <div class="signContent" style="overflow:hidden;position: relative;">
            <div class="content" style="border: 0px; "></div>
        </div>
        <!-- <iframe height='450px' width="100%" border="0px" style="border: 0px"></iframe> -->
        <div class="signMore"><%=SystemEnv.getHtmlLabelName(82720,user.getLanguage()) %></div>
    </div>
    
    
</div>
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
public int getCount(String eid,String tabid,String type){
    int count  = 0;
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select count(id) from workflowcentersettingdetail where eid="+eid+" and tabid='"+tabid+"' and type='"+type+"'");
    while(recordSet.next()){
        count = recordSet.getInt(1);
    }
    return count;
}
public String getFreeNodeSql(String eid,String tabid,String key,boolean isExclude ){
    String plusStr = " or ",isIn = " in ";
    String retStr = " and (";
    if(isExclude) {
        isIn = " not in ";
        plusStr = " and ";
    }
    retStr+=  key + isIn+  " (select content from workflowcentersettingdetail where type='nodeid' and eid="+eid+" and tabid='"+tabid+"') " 
        +plusStr + " t2.nodeid " + isIn+ " (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' and f.workflowid in (select content from workflowcentersettingdetail where type='flowid' and eid="+eid+" and tabid='"+tabid+"') )) ";
    return retStr;
}

public String getQuerySql(String eid, String tabid, String backFields, String sqlFrom, String sqlWhere, int perpage, String viewType, String ofsSql) {
	String returnSql = "";
	RecordSet rs = new RecordSet();
	String dbType = rs.getDBType();
	
	if ("oracle".equals(dbType)) {
		String oracleRow = "oracle_rownum";
		returnSql = "select r.* from (  " +
			" select my_table.*, rownum as my_rownum from (" + 
				" select tableA.*, rownum as "+ oracleRow +" from (" +  
					" select ";
				
		if (Util.getIntValue(viewType) == 6) { // 督办
			returnSql += backFields;
		} else {
			returnSql += " distinct " + backFields;
		}
		
		// 添加from语句
		String _sqlFrom = sqlFrom.trim();
		if (_sqlFrom.length() > 4 && _sqlFrom.substring(0, 4).equalsIgnoreCase("from")) {
			returnSql += " " + sqlFrom;
		} else {
			returnSql += " from " + sqlFrom;
		}

		//添回where语句
		String _sqlWhere = sqlWhere.trim();
		if (!"".equalsIgnoreCase(_sqlWhere)) { 
			if (_sqlWhere.length() > 5 && _sqlWhere.substring(0, 5).equalsIgnoreCase("where")) {
				returnSql += " " + sqlWhere;
			} else {
				returnSql += " where " + sqlWhere;
			}
		}
		
		//统一待办异构系统流程
		if (!"".equals(ofsSql)) {
			returnSql += " union all " + ofsSql;
		}
		
		returnSql += ") tableA ";
		
		returnSql += " order by ";
		int ivt = Util.getIntValue(viewType);
	    if (ivt == 2 || ivt == 3) { // 已办、办结按照处理时间排序
	        returnSql += " tableA.operatedate desc, tableA.operatetime desc";
	    } else if (ivt == 4) { // 我的请求按照创建时间排序
	        returnSql += " tableA.createdate desc , tableA.createtime desc";
	    } else if (Util.getIntValue(viewType)==6) { // 督办
			returnSql += " tableA.receivedate desc";
		} else { // 其他按照接受时间排序
			returnSql += " tableA.receivedate desc, tableA.receivetime desc";
	    }
		
		returnSql += " ) my_table ) r where my_rownum <= " + perpage + " and my_rownum > 0 ";
	} else if ("sqlserver".equals(dbType)) {
		returnSql = "select "; 
		
		if (Util.getIntValue(viewType) == 6) { // 督办
			returnSql += backFields;
		} else {
			returnSql += " distinct " + backFields;
		}
		
		// 添加from语句
		String _sqlFrom = sqlFrom.trim();
		if (_sqlFrom.length() > 4 && _sqlFrom.substring(0, 4).equalsIgnoreCase("from")) {
			returnSql += " " + sqlFrom;
		} else {
			returnSql += " from " + sqlFrom;
		}

		//添回where语句
		String _sqlWhere = sqlWhere.trim();
		if (!"".equalsIgnoreCase(_sqlWhere)) { 
			if (_sqlWhere.length() > 5 && _sqlWhere.substring(0, 5).equalsIgnoreCase("where")) {
				returnSql += " " + sqlWhere;
			} else {
				returnSql += " where " + sqlWhere;
			}
		}
		
		//统一待办异构系统流程
		if (!"".equals(ofsSql)) {
			returnSql += " union all " + ofsSql;
		}
		
		returnSql = "select top "+ perpage +" a.* from (" + returnSql + ") a";
		
		returnSql += " order by ";
	    int ivt = Util.getIntValue(viewType);
	    if (ivt == 2 || ivt == 3) { // 已办、办结按照处理时间排序
	        returnSql += " a.operatedate desc, a.operatetime desc";
	    } else if (ivt == 4) { // 我的请求按照创建时间排序
	        returnSql += " a.createdate desc, a.createtime desc";
	    } else if (Util.getIntValue(viewType)==6) { // 督办
			returnSql += " a.receivedate desc";
		} else { // 其他按照接受时间排序
			returnSql += " a.receivedate desc, a.receivetime desc";
	    }
	}
	
	return returnSql;
}
%>
<style>
    
</style>

<script type="text/javascript">

    var hoverTimer_<%=eid%>;  
    var contentDiv_<%=eid%> = jQuery("#signPreview_<%=eid%>").find(".signContent");
    jQuery("#tabContant_<%=eid%>").find(".reqdetail").parent().hover(function(){
            $(this).find(".imgdetail").show();
        },
        function(){
            $(this).find(".imgdetail").hide();
        });
        
    jQuery("#tabContant_<%=eid%>").find(".imgdetail").bind("click",function(){
        
         var signPreview = jQuery("#signPreview_<%=eid %>");
         $this = jQuery(this).parents("tr:first").find(".reqdetail");
         contentDiv_<%=eid%>.css("height","350px");
        
            $(".signPreview").hide();   
            $(".signPreview").find(".content").html("");
            var requestid = $this.attr("requestid")
            var rquserid =  $this.attr("rquserid")
            var title = $this.attr("title")
            signPreview.find(".signTitle").html(title);
            signPreview.find(".content").load("/workflow/request/WorkflowSignPreView.jsp?requestid="+requestid+"&f_weaver_belongto_userid="+rquserid+"&firstLoadNum=4&everyLoadNum=3",function(data){
                var etop = $this.parents(".item:first").offset().top;
                var eleft = $this.parents(".item:first").offset().left;
                //alert(eleft)
                if($this.parents(".item:first").css("position")=="static"){
                    etop = 0
                    eleft= 0
                    
                }
                var left = $this.offset().left
                left = left - eleft
                var top = $this.offset().top
                var rtop = top-etop;
                
                if(top <signPreview.height() || top - $(document).scrollTop()+350 < $(window).height()){
                    $(".arrowsblockup").hide();
                    $(".arrowsblock").show();
                    $(".signContainer").removeClass("signContainerup")
                    $(".signMore").removeClass("signMoreup")
                    
                }else{
                    $(".arrowsblockup").show();
                    $(".arrowsblock").hide();
                    $(".signContainer").addClass("signContainerup")
                    $(".signMore").addClass("signMoreup")
                    rtop = rtop-350-20
                    if(curPage!=parseInt(totalPage)){
                        rtop = rtop-60;
                    }else{
                        rtop = rtop-20;
                    }
                }
                //alert(top+rtop-$(document).scrollTop())
                if(top+rtop-$(document).scrollTop()<0){
                    rtop = top-etop;
                    $(".arrowsblockup").hide();
                    $(".arrowsblock").show();
                    $(".signContainer").removeClass("signContainerup")
                    $(".signMore").removeClass("signMoreup")
                }
                
                signPreview.css("top",rtop);
                signPreview.css("left",left);
                signPreview.attr("top",rtop);
                
                var ulheight = contentDiv_<%=eid%>.find(".content").height();
                //alert(ulheight)
                if(ulheight>350){
                    
                    ulheight = 350;
                    contentDiv_<%=eid%>.height(ulheight);
                }
                //alert(ulheight);
                //
                contentDiv_<%=eid%>.perfectScrollbar();
                
                if(curPage==parseInt(totalPage)){
                    signPreview.find(".signMore").hide();
                    signPreview.find(".signMore").prev().css("border-bottom-width","1px");
                }else{
                    signPreview.find(".signMore").show();
                    signPreview.find(".signMore").prev().css("border-bottom-width","0px");
                }
                signPreview.show();
                })
    })
    
    
    jQuery("#signPreview_<%=eid%>").find(".close").bind("click",function(){
        jQuery("#signPreview_<%=eid %>").hide();
    })
        
    jQuery("#signPreview_<%=eid%>").find(".signMore").bind("click",function(){
        //var ifm = jQuery("#signPreview_<%=eid %>").find(".signContent").find("iframe")[0];
        // ifm.contentWindow.loadSign();
        if(!loadSign()){
        
            
            
            //alert(ulheight);
            ulheight = 350;
            //contentDiv_<%=eid%>.scrollTo(ulheight);
            
            if(curPage==parseInt(totalPage)){
                ulheight=ulheight+40;
                jQuery(this).hide();
                
                
            }
            contentDiv_<%=eid%>.height(ulheight)
            //alert(ulheight)
            //contentDiv_<%=eid%>.height(ulheight);
            contentDiv_<%=eid%>.perfectScrollbar("update");
        }
    })
        
    if(<%=flag%>=="1") {
        if(<%=tabs%>>1) jQuery("#<%=eid%>_<%=tabId%>").html("(<%=count%>)");
        else jQuery("#count_<%=eid%>").html(" (<%=count%>)");
    }
    //处理
    var isremind='<%=isremind%>';
    if(isremind!==''){
        setRemindInfo("<%=eid%>",isremind,"reqdetail","reqname");
    }
    
</script>



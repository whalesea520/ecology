
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session"/>
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="TimeUtil" class="weaver.general.TimeUtil" scope="page" />

<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT type="text/javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<FORM id=frmmain name=frmmain method=post action="WFSuperviseList.jsp">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    String method = Util.null2String(request.getParameter("method"));
    String objid = Util.null2String(request.getParameter("objid"));
    String workflowid = Util.null2String(request.getParameter("workflowid"));
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
	//菜单点击：workflow 点击的是流程 type 点击的是流程类型
	String menutype = Util.null2String(request.getParameter("menutype"));
	//菜单点击：workflowid or worktypeid 依据menutype而定
	String menuid = Util.null2String(request.getParameter("menuid"));
	//菜单点击：flowAll 所有流程;flowNew 未读流程;flowResponse 反馈的;flowOut 超时的


	String complete = Util.null2String(request.getParameter("complete"));
	//已督办：2；未督办：1
	String isdo = Util.null2String(request.getParameter("isdo"));
    //创建日期标识
	String datecondition=Util.null2String(request.getParameter("createdateselect"));
	//接收日期标识
	String recievedateselect = Util.null2String(request
				.getParameter("recievedateselect"));
    
	int ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
    int creatersubcompanyid=Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
    int createrid = Util.getIntValue(request.getParameter("createrid"),0);
    int createrid2=Util.getIntValue(request.getParameter("createrid2"),0);
    int unophrmid=Util.getIntValue(request.getParameter("unophrmid"),0);

    String sqlwhere="";
    boolean isnew = false;

    //根据页面上(用户所输入的)查询方式来设置查询条件


    if (method.equals("type")&&!objid.trim().equals("")) {
    	workflowid = "";
        sqlwhere=" b.workflowtype="+objid;
    }
    if (method.equals("workflow")&&!objid.trim().equals("")) {
    	workflowid = objid;
        sqlwhere=" b.id="+objid;
    }
    if (method.equals("request")&&!objid.trim().equals("")) {
        String level = Util.null2String(request.getParameter("level"));
        //类型级别
		if (level.equals("1"))
		{
		workflowid = "";
        sqlwhere=" b.workflowtype="+objid;
		}else if (level.equals("2"))
		{
		workflowid = objid;
        sqlwhere=" b.id="+objid;
		}
		isnew = true;
    }
    
    
    //如果当前流程ID列表为空，则对其进行二次赋值


    //if(workflowid.equals("")){
    //      //如果当前流程类型不为空，则将流程类型的所有流程设置为流程ID列表
//      if(method.equals("type")&&!objid.trim().equals("")){
//          RecordSet.execute("select id from workflow_base where workflowtype="+objid);
//          while(RecordSet.next()){
//              int id_tmp = Util.getIntValue(RecordSet.getString(1), 0);
//              workflowid += (id_tmp+",");
//          }
//          if(!workflowid.equals("")){
//              workflowid = workflowid.substring(0, workflowid.length()-1);
//          }
//      }else{
//      //如果当前流程类型为空，则从会话作用域中来获取流程ID列表
//          workflowid = SearchClause.getWorkflowId();
//      }
//  }
    //ArrayList  flowList=Util.TokenizerString(workflowid,",");
    
    
    //调用WFUrgerManager类获取当前用户的所有流程的流程督办的配置信息


    int logintype = Util.getIntValue(user.getLogintype(),1);
    int userID = user.getUID();
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
userlist.add(userID + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
    WFUrgerManager.setLogintype(logintype);
    WFUrgerManager.setUserid(userID);

      if(method.equals("workflow")){
        String workflowids = "";
			ArrayList  flowList=Util.TokenizerString(SearchClause.getWorkflowId(),",");
			for(int k=0;k<flowList.size();k++)
			{
			  String tempworkflowid = (String)flowList.get(k);
			RecordSet.executeQuery("select wfid from workflow_versioninfo where wfversionid = ?",WorkflowVersion.getActiveVersionWFID(tempworkflowid + ""));
			while(RecordSet.next()){
				workflowids += "," + RecordSet.getString(1);
			}
			}
		if(workflowids.length() > 0){
			workflowids = workflowids.substring(1);
		}
        workflowid += workflowids;
    }else if(menutype.equals("workflow")){
        String workflowids = "";
        RecordSet.executeQuery("select wfid from workflow_versioninfo where wfversionid = ?",WorkflowVersion.getActiveVersionWFID(menuid + ""));
        while(RecordSet.next()){
            workflowids += "," + RecordSet.getString(1);
        }
        if(workflowids.length() > 0){
            workflowids = workflowids.substring(1);
        }
        workflowid += workflowids;
    }else if(menutype.equals("type")){
        String workflowids = "";
        RecordSet.executeQuery("select id from workflow_base where isvalid in (1,3) and workflowtype = ?",menuid);
        while(RecordSet.next()){
            workflowids += "," + RecordSet.getString(1);
        }
        if(workflowids.length() > 0){
            workflowids = workflowids.substring(1);
        }
        workflowid += workflowids;
    }
    WFUrgerManager.setSqlwhere(sqlwhere);
    WFUrgerManager.setWorkflowIDs(workflowid);
    
    //性能优化，不再使用getWrokflowTree方法，直接使用getWfShareSqlWhere取得获取requestid的SQL语句
    String requestidGetSql = WFUrgerManager.getWfShareSqlWhere();
    //ArrayList wftypes=WFUrgerManager.getWrokflowTree();
    //String tmpTableName = WFUrgerManager.getTmpTableName();
    
    //String requestids = "";
    //String requestSql = "";
    //Map mapRequestIDs = new HashMap();
    //  for(int i=0;i<wftypes.size();i++){
    //    WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
    //    ArrayList workflows=wftype.getWorkflows();
    //
    //    for(int j=0;j<workflows.size();j++){
    //        //if(j>0) break;
    //        WFWorkflows wfObj=(WFWorkflows)workflows.get(j);
    //        String tempWorkflow=wfObj.getWorkflowid()+"";
    //        //查询的流程ID列表为空，或者流程ID列表包含
    //        if("".equals(workflowid) || flowList.contains(tempWorkflow)) {
    //            ArrayList requests = null;
    //
    //            if(isnew){
    //                requests=wfObj.getNewrequestids();
    //            }else{
    //                requests=wfObj.getReqeustids();
    //            }
    //            
    //          for(int k=0;k<requests.size();k++){
    //                if(requestids.equals("")){
    //                    requestids=(String)requests.get(k);
    //                }else{
    //                    requestids+=","+requests.get(k);
    //                }
    //            }
    //        }
    //    }
    //}
   	
    
   	String newsql =" where (t1.currentnodetype is null or t1.currentnodetype<>'3') and (t1.deleted<>1 or (t1.deleted is null or t1.deleted='')) ";

    //高级搜索条件
    WfAdvanceSearchUtil  conditionutil=new  WfAdvanceSearchUtil(request,RecordSet);
   
    String conditions=conditionutil.getAdVanceSearchConditionUrger();

    if(!conditions.equals(""))
    {
     newsql += conditions;
    }
    // =====================添加页面上的查询条件            Start   =====================
    if (!workflowid.equals("")){
      //去掉最前边的逗号
      while(workflowid.startsWith(",")){
        workflowid = workflowid.substring(1);
      }
      newsql += " and t1.workflowid in(" + workflowid + ")";
    }






     

	 // =====================添加页面上的查询条件            END   =====================
    
	 
int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =false;
boolean hasrequestname =true;
boolean hasreceivetime =false;
boolean hasstatus =false;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
/*
RecordSet.executeProc("workflow_RUserDefault_Select",""+userID);
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}
*/
perpage=10;
/*
if(!hascreatetime&&!hascreater&&!hasworkflowname&&!hasrequestlevel&&!hasrequestname&&!hasreceivetime&&!hasstatus&&!hasreceivedpersons&&!hascurrentnode){
	hascreatetime =true;
	hascreater =true;
	hasworkflowname =true;
	hasrequestlevel =true;
	hasrequestname =true;
	hasreceivetime =true;
	hasstatus =true;
	hasreceivedpersons =true;
	hascurrentnode =true;			
}
*/

//update by fanggsh 20060711 for TD4532 begin
boolean hasSubWorkflow =false;

//主要用于 显示定制列以及 表格 每页展示记录数选择
String pageIdStr = "7";

if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1){
	RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}
}

	
   // RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:_table.lastPage(),_self}";
   // RCMenuHeight += RCMenuHeightStep;
   	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:rightMenuSearch(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>


<input type=hidden name=method value="<%=method%>">
<input type=hidden name=objid value="<%=objid%>">
<input type=hidden name=isdo value="<%=isdo %>">


		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
				   <input type="button" value="<%=SystemEnv.getHtmlLabelName(84561,user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="doReadFlagByBatch()">
                    
					<input type="text" class="searchInput" name="flowTitle" value="<%=Util.null2String(request.getParameter("requestname"))%>"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>


<%
%>
			
      <!--高级设置表单-->
<div class="advancedSearchDiv" id="advancedSearchDiv">
   <wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
		    	<wea:item>
			       <input class=inputstyle  type="text" name="requestname" style='width:80%' value="<%=Util.null2String(request.getParameter("requestname"))%>">
			       <input class=inputstyle  type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.getWFPageId(pageIdStr) %>"/>
		    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("882,714", user.getLanguage())%></wea:item>
	    	<wea:item> <input class=inputstyle  type="text" name="workcode" style='width:80%'  value='<%=Util.null2String(request.getParameter("workcode"))%>' ></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=requestlevel size=1>
					<option value=""></option>
					<option value="0"
							<% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>
								</option>
					<option value="1"
							<% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%>
								</option>
					<option value="2"
							<% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>
								</option>
				</select>
	    	</wea:item>
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		 <span style="float:left;">
						<select class=inputstyle name=creatertype  onchange="changeType(this.value,'createridselspan','createrid2selspan');">
						<%if (!user.getLogintype().equals("2")) {%>
						<option value="0"
								<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%>
									</option>
						<%}%>
						<option value="1"
								<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%>
									</option>
					    </select>
    			 </span>
			   
		   	     <span id="createridselspan" style="<%=(creatertype.equals("0") || creatertype.equals(""))?"":"display:none;float:left;" %>">
			   
                   <brow:browser viewType="0" name="createrid" browserValue='<%= createrid+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'> 
				   </brow:browser> 

                  </span>
	                      
				  <span id="createrid2selspan" style="<%=!(creatertype.equals("0") || creatertype.equals(""))?"":"display:none;float:left;" %>">

	                      <brow:browser viewType="0" name="createrid2" browserValue='<%= createrid2+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=7"  browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(createrid2+""),user.getLanguage())%>'> 
				         </brow:browser> 

					</span>
	    	</wea:item>
	    	
	    </wea:group>
	     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		   <brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1&selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'> </brow:browser>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
	        <wea:item attributes="{colspan:3}">
	        	<span class="wuiDateSpan" selectId="recievedateselect" selectValue="">
					<input class=wuiDateSel type="hidden" name="recievedatefrom" value="<%=Util.null2String(request.getParameter("recievedatefrom"))%>">
					<input class=wuiDateSel type="hidden" name="recievedateto" value="<%=Util.null2String(request.getParameter("recievedateto"))%>">
				</span>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
	    	<wea:item attributes="{colspan:3}">
	    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
					<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=Util.null2String(request.getParameter("createdatefrom"))%>">
					<input class=wuiDateSel type="hidden" name="createdateto" value="<%=Util.null2String(request.getParameter("createdateto"))%>">
				</span>
	    	</wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
			<wea:item>
			    <select class=inputstyle size=1 name=wfstatu>
					<option value="">&nbsp;</option>
					<option value="1"
							<% if(Util.null2String(request.getParameter("wfstatu")).equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246, user.getLanguage())%>
								</option>
					<option value="0"
							<% if(Util.null2String(request.getParameter("wfstatu")).equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>
								</option>
					<option value="2"
							<% if(Util.null2String(request.getParameter("wfstatu")).equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>
								</option>
			     </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
			<wea:item>
			    <select class=inputstyle size=1 name=nodetype>
				<option value="">&nbsp;</option>
				<option value="0"
						<% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%>
							</option>
				<option value="1"
						<% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>
							</option>
				<option value="2"
						<% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%>
							</option>
				<option value="3"
						<% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>
							</option>
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
            <wea:item>
			       <brow:browser viewType="0" name="unophrmid" browserValue='<%= ""+unophrmid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=unophrmid!=0?Util.toScreen(ResourceComInfo.getResourcename(unophrmid+""),user.getLanguage()):""%>'> </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
            <wea:item>
			       <brow:browser viewType="0" name="docids" browserValue='<%=Util.null2String(request.getParameter("docids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=9" width="80%" browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(Util.null2String(request.getParameter("docids"))+""),user.getLanguage())%>'> </brow:browser>
			</wea:item>
			 <wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
			 <wea:item>
			       <brow:browser viewType="0" name="hrmids" browserValue='<%=Util.null2String(request.getParameter("hrmids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(Util.null2String(request.getParameter("hrmids"))+""),user.getLanguage())%>'> </brow:browser>
			 </wea:item>
			 <wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
			 <wea:item>
			        <brow:browser viewType="0" name="crmids" browserValue='<%=Util.null2String(request.getParameter("crmids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18" width="80%" browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(Util.null2String(request.getParameter("crmids"))+""),user.getLanguage())%>'> </brow:browser>
			 </wea:item>
			 <wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
			 <wea:item>
			        <brow:browser viewType="0" name="prjids" browserValue='<%=Util.null2String(request.getParameter("prjids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=135" width="80%" browserSpanValue='<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(Util.null2String(request.getParameter("prjids"))+""),user.getLanguage())%>'> </brow:browser>
			 </wea:item>
			 <wea:item></wea:item>
			


	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit"/>
				<span class="e8_sep_line">|</span>
				<input type="button" type="reset" onclick="resetCondtion()"; name="reset" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_cancel" >
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>



</div>
<TABLE width="100%"  cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <%
	            String tableString = "";
				String fromSql = "";
				String sqlWhere = newsql;
				/*  修改QC170325 QC171287 QC170790  发生的问题。
				//判断session中是否存在附加条件
				String __whereClause = SearchClause.getWhereClause();
				//System.err.println("!!=="+__whereClause);
				if(__whereClause != null && !__whereClause.trim().equals("")){
					if(__whereClause.trim().startsWith("and")){
						sqlWhere += __whereClause;
					}else{
						sqlWhere += (" and " + __whereClause);
					}
				}
				*/

	            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname,t1.requestnamenew, t1.status,t1.requestlevel,t1.currentnodeid";
	            if(RecordSet.getDBType().equals("oracle")){
	                //修改督办数据重复的问题
					//fromSql = " from (select requestid,viewtype,max(receivedate||' '||receivetime) as receivedatetime from workflow_currentoperator group by requestid,viewtype) t2,workflow_requestbase t1 ";
	                //fromSql = " from (select requestid,max(receivedate||' '||receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
	                backfields += ",t1.createdate ||' '|| t1.createtime as receivedatetime";
	            }else{
					//fromSql = " from (select requestid,viewtype,max(receivedate+' '+receivetime) as receivedatetime from workflow_currentoperator group by requestid,viewtype) t2,workflow_requestbase t1 ";
	                //fromSql = " from (select requestid,max(receivedate+' '+receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
	                backfields += ",t1.createdate +' '+ t1.createtime as receivedatetime";
				}
	            fromSql = " from workflow_requestbase t1 ";
	            //性能优化，直接使用获取requestid的SQL语句
                //性能优化后，不在插入临时表
                //if(tmpTableName != null) {
                //      fromSql += " ,(Select requestId from "+requestidGetSql+") t2 ";
                //  sqlWhere = " where t1.requestid=t2.requestid ";
                //} else {
                //    sqlWhere += " AND t1.requestid in("+requestidGetSql+") ";
                //}
                fromSql += " inner join ("+requestidGetSql+") t2 on t1.requestid=t2.requestid ";
                fromSql += " left join hrmresource t3 on t1.creater=t3.id ";
                fromSql += " inner join workflow_base t4 on t4.id=t1.workflowid ";
                //过滤停留在督办人待办的流程
                //在workFlow_CurrentOperator中存在的条件已经添加到getWfShareSqlWhere中，此处删除
                //fromSql += "        and exists (select 1 from workFlow_CurrentOperator where t1.workflowid=workflow_currentoperator.workflowid and t1.requestid=workflow_currentoperator.requestid) and NOT EXISTS (select 1 from workFlow_CurrentOperator t where t.isremark in('0','1','5','8','9','7') and t.userid=" + userID + " and t.usertype=" + (logintype - 1) + " and t.requestid=t1.requestid)";
                if (RecordSet.getDBType().equals("oracle")) {
                }else{
                    fromSql += "      and exists (select 1 from workFlow_CurrentOperator where t1.workflowid=workflow_currentoperator.workflowid and t1.requestid=workflow_currentoperator.requestid) and NOT EXISTS (select 1 from workFlow_CurrentOperator t where t.isremark in('0','1','5','8','9','7') and t.userid=" + userID + " and t.usertype=" + (logintype - 1) + " and t.requestid=t1.requestid)";
                }
                
                //fromSql += "        and  NOT EXISTS (select 1 from workFlow_CurrentOperator t where t.isremark in('0','1','5','8','9','7') and t.userid=" + userID + " and t.usertype=" + (logintype - 1) + " and t.requestid=t1.requestid)";
                if (!requestidGetSql.equals("")) {
	            //if (!requestids.equals("")) {
	            //	if (isnew) {
	            //		sqlWhere += " AND t1.requestid in("+requestids+") ";
	            //	}
	            }else{
	                sqlWhere+=" and 1>2 ";
	            }
	            if(RecordSet.getDBType().equals("oracle"))
	            {
					if("1".equals(belongtoshow)){
	            	sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in ("+userIDAll+"))) ";
					}else{
					sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in ("+user.getUID()+"))) ";
					}
	            }
	            else
	            {
					if("1".equals(belongtoshow)){
	            	sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater in ("+userIDAll+"))) ";
					}else{
					sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
					}
	            }
                sqlWhere += " and (t1.currentnodetype is null or t1.currentnodetype <>3) ";
	            String table1 = "select " + backfields + fromSql + sqlWhere;
	            backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.requestnamenew, t1.status,t1.requestlevel,t1.currentnodeid,t1.receivedatetime";
	            fromSql =" from ("+table1+") t1 ";
	            
	            sqlWhere = " 1 = 1 ";
				//已督办


				if(isdo.equals("2")){
				if("1".equals(belongtoshow)){
					sqlWhere += " and (select count(0) from workflow_requestlog where requestid =t1.requestid and logtype='s' and operator in ("+userIDAll+"))>0  ";
				}else{
					sqlWhere += " and (select count(0) from workflow_requestlog where requestid =t1.requestid and logtype='s' and operator="+user.getUID()+")>0  ";
				}
				}
				//未督办


				else if(isdo.equals("1")){
					if("1".equals(belongtoshow)){
					sqlWhere += " and (select count(0) from workflow_requestlog where requestid =t1.requestid and logtype='s' and operator in ("+userIDAll+"))=0  ";
					}else{
					sqlWhere += " and (select count(0) from workflow_requestlog where requestid =t1.requestid and logtype='s' and operator="+user.getUID()+")=0  ";
					}
				}
				//查询条件直接放进requestidGetSql中，此处删除
				/*
				if(menutype.equals("workflow")){
				    String workflowids = "";
                    RecordSet.executeQuery("select wfid from workflow_versioninfo where wfversionid = ?",WorkflowVersion.getActiveVersionWFID(menuid + ""));
                    while(RecordSet.next()){
                        workflowids += "," + RecordSet.getString(1);
                    }
                    if(workflowids.length() > 0){
                        workflowids = workflowids.substring(1);
                        sqlWhere += " and t1.workflowid in ("+workflowids+") ";
                    }else{
                        sqlWhere += " and t1.workflowid = '"+menuid+"' ";
                    }
				}else if(menutype.equals("type")){
                    String workflowids = "";
                    RecordSet.executeQuery("select id from workflow_base where isvalid in (1,3) and workflowtype = ?",menuid);
                    while(RecordSet.next()){
                        workflowids += "," + RecordSet.getString(1);
                    }
                    if(workflowids.length() > 0){
                        workflowids = workflowids.substring(1);
                        sqlWhere += " and t1.workflowid in ("+workflowids+") ";
                    }else{
                        sqlWhere += " and t1.workflowid = '"+menuid+"' ";
                    }
					//sqlWhere += " and  (select count(0) from workflow_base where id=t1.workflowid and workflowtype='"+menuid+"')>0 ";
				}
				*/
				
				
				//未读流程
				if(complete.equals("3")){
					if("1".equals(belongtoshow)){
					sqlWhere += " and (select count(0) from workflow_requestviewlog where id=t1.requestid and currentnodeid = t1.currentnodeid and viewer in ("+userIDAll+"))=0";
					}else{
					sqlWhere += " and (select count(0) from workflow_requestviewlog where id=t1.requestid and currentnodeid = t1.currentnodeid and viewer="+user.getUID()+")=0";
					}
				}
				//反馈流程
				else if(complete.equals("4"));
				//超时流程
				else if(complete.equals("8"));
				
				String popeUrgepara = "column:requestid+column:workflowid+"+user.getUID()+"+"+(logintype-1)+"+"+ user.getLanguage();

				String operateString= "";
				operateString = "<operates>";

                operateString +=" <popedom transmethod=\"weaver.general.WorkFlowTransMethod.getWfUrgerNewOperation\"  otherpara=\""+popeUrgepara+"\"   ></popedom> ";

    			//operateString +="     <operate href=\"javascript:doReadFlag();\" text=\"标记为已读\" index=\"0\"/>";
 	       		operateString +="</operates>";
                String orderby = " t1.receivedatetime ";
                String para2 = "column:requestid+column:workflowid+"+userID+"+"+(logintype-1)+"+"+ user.getLanguage();
				String para4=user.getLanguage()+"+"+user.getUID();

                tableString = " <table   instanceid=\"workflowRequestListTable\"       tabletype=\"checkbox\" pagesize=\"" +PageIdConst.getPageSize(PageIdConst.getWFPageId(pageIdStr),user.getUID())+ "\" >" +
					
                        "	   <sql backfields=\"" + backfields + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />" +
                        operateString + 
                        "			<head>";
                        tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\"" + SystemEnv.getHtmlLabelName(1334, user.getLanguage()) + "\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkByUrger\"  otherpara=\"" + para2 + "\"/>";       
                        tableString += "<col width=\"10%\" display=\""+hasworkflowname+"\" text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage()) + "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                        tableString += "<col width=\"6%\" display=\""+hascreater+"\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage()) + "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";                        
                        tableString += "<col width=\"10%\" display=\""+hascreatetime+"\"  text=\"" + SystemEnv.getHtmlLabelName(722, user.getLanguage()) + "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
		                tableString += "<col width=\"8%\" display=\""+hasrequestlevel+"\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage()) + "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\"" + user.getLanguage() + "\"/>";
		                tableString += "<col width=\"8%\" display=\""+hascurrentnode+"\" text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage()) + "\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                        tableString += "<col width=\"10%\" display=\""+hasreceivetime+"\" text=\"" + SystemEnv.getHtmlLabelName(17994, user.getLanguage()) + "\" column=\"requestid\" otherpara=\"" + para2 + "\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFUrgerRecievedate\"/>";
		                tableString += "<col width=\"8%\" display=\""+hasstatus+"\" text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
		                tableString += "<col width=\"15%\" display=\""+hasreceivedpersons+"\" text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4 + "\" transmethod=\"weaver.general.WorkFlowTransMethod.getMUnOperators\"/>";
		                tableString += "<col width=\"6%\" display=\""+hasSubWorkflow+"\"  text=\"" + SystemEnv.getHtmlLabelName(19363, user.getLanguage()) + "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\"" + user.getLanguage() + "\"/>";

                tableString += "			</head>" +
                        "</table>";
            %>

            <wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
        </td>
    </tr>
</TABLE>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</form>
</body>

<script type="text/javascript">
function rightMenuSearch(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		document.frmmain.submit();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			document.frmmain.submit();
		}
	}
}
	
function changeType(type,span1,span2){
	if(type=="1"){
		jQuery("#"+span1).hide();
		jQuery("#"+span2).show();		
	}else{
		jQuery("#"+span2).hide();
		jQuery("#"+span1).show();
	}
}

var dialog = null;
//批处理


function  doReadFlagByBatch()
{
	if(_xtable_CheckedCheckboxId()=="")
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
	else
	{
		//批量督办
		var reqids = _xtable_CheckedCheckboxId();
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/search/WFSuperviseSignature.jsp?reqids="+reqids;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26039,user.getLanguage())%>";
		dialog.Width = 450;
		dialog.Height = 227;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
}



//标记为已读	
function doReadFlag(requestid,params,obj){

        var ajax=ajaxinit();
	    ajax.open("POST", "WFSuperviseDoFlag.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("requestid="+requestid);
        //获取执行状态


        //alert(ajax.readyState);
        //alert(ajax.status);
        ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里


        if (ajax.readyState==4&&ajax.status == 200) {
       
		try{
           
           var rsdata=$.trim(ajax.responseText);
		   if(rsdata==="success")
		   {
		       _table. reLoad();
		   }

        }catch(e){

		}
        
		}

        }
        
	
}

function onShowWorkFlow(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, false);
}

function onShowWorkFlowBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			$GetEle("objid").value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$GetEle(inputname).value = "";
			if (needed) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle("objid").value = "";
		}
	}
}
</script>


<SCRIPT language="javascript">
	jQuery("#topTitle").topMenuTitle({searchFn:searchItem});
    var showTableDiv = document.getElementById('divshowreceivied');
    var oIframe = document.createElement('iframe');
    function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
        message_Div.id="message_Div";
        message_Div.className="xTable_message";
        showTableDiv.appendChild(message_Div);
        var message_Div1 = document.getElementById("message_Div");
        message_Div1.style.display="inline";
        message_Div1.innerHTML=content;
        var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
        var pLeft= document.body.offsetWidth/2-50;
        message_Div1.style.position="absolute"
        message_Div1.style.top=pTop;
        message_Div1.style.left=pLeft;

        message_Div1.style.zIndex=1002;

        oIframe.id = 'HelpFrame';
        showTableDiv.appendChild(oIframe);
        oIframe.frameborder = 0;
        oIframe.style.position = 'absolute';
        oIframe.style.top = pTop;
        oIframe.style.left = pLeft;
        oIframe.style.zIndex = message_Div1.style.zIndex - 1;
        oIframe.style.width = parseInt(message_Div1.offsetWidth);
        oIframe.style.height = parseInt(message_Div1.offsetHeight);
        oIframe.style.display = 'block';
        }

        function ajaxinit(){
        var ajax=false;
        try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
        try {
        ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
        ajax = false;
        }
        }
        if (!ajax && typeof XMLHttpRequest!='undefined') {
        ajax = new XMLHttpRequest();
        }
        return ajax;
        }
        function showallreceived(requestid,returntdid){
        showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
        var ajax=ajaxinit();

        ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("requestid="+requestid+"&returntdid="+returntdid);
        //获取执行状态


        //alert(ajax.readyState);
        //alert(ajax.status);
        ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里


        if (ajax.readyState==4&&ajax.status == 200) {
        try{
        document.getElementById(returntdid).innerHTML = ajax.responseText;
        }catch(e){}
        showTableDiv.style.display='none';
        oIframe.style.display='none';
        }
        }
        }

</script>

<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="java.util.*,java.sql.Timestamp"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="java.util.Date"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkFlowInit" class="weaver.soa.workflow.WorkFlowInit" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />

		<%
			String colnum4show = Util.null2String(request.getParameter("colnum4show"));
			String offical = Util.null2String(request.getParameter("offical"));
			//当该参数为空时，直接return掉，并重置location
			if(colnum4show.equals("")){
				//收集所有的requrest.笨办法，不好意思


				int __fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
				String __selectedContent = Util.null2String(request.getParameter("selectedContent"));
				int __infoId = Util.getIntValue(request.getParameter("infoId"),0);
				String __needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));
				String __needall=Util.null2String(request.getParameter("needall"));
				String __prjid = Util.null2String(request.getParameter("prjid"));
				String __docid = Util.null2String(request.getParameter("docid"));
				String __crmid = Util.null2String(request.getParameter("crmid"));
				String __hrmid = Util.null2String(request.getParameter("hrmid"));
				String __topage = Util.null2String(request.getParameter("topage"));
				String __isec = Util.null2String(request.getParameter("isec"));
				int __sedtodo = Util.getIntValue(request.getParameter("usedtodo"),-1);
			%>
		<% 
			//return;
			}%>

	<%!public String getRandom() {
		return "" + (((int) (Math.random() * 1000000) % 3) + 1);
	}%>
	<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String needfav ="1";
String needhelp ="";
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();
String belongtoshow = "";				
RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userid);
if(RecordSet.next()){
	belongtoshow = RecordSet.getString("belongtoshow");
}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
userIDAll = userid+","+Belongtoids;
}
String logintype = user.getLogintype();
int usertype = 0;
//String seclevel = "";
if(logintype.equals("2")){
	usertype = 1;
	//seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
}
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";

/* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);

String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));//是否需要弹出新页面  true:需要   false或其它：不需要


if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}
if(fromAdvancedMenu==1){
	needPopupNewPage="true";
}

boolean navigateTo = false;
int navigateToWfid = 0;
int navigateToIsagent = 0;
int navigateToAgenter = 0;
String commonuse = "";
if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	if(info!=null){
		selectedworkflow = info.getSelectedContent();
		
		List workflowNum = Util.TokenizerString(selectedworkflow,"|");
		int tnum = 0;
		for(Iterator it = workflowNum.iterator();it.hasNext();){
			if(((String)it.next()).startsWith("W")) tnum++;
		}
		if(tnum==1) navigateTo = true;
	}
} else if(usertype==0){
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
	    selectedworkflow=RecordSet.getString("selectedworkflow");
	    isuserdefault=RecordSet.getString("isuserdefault");
	    commonuse = RecordSet.getString("commonuse");
	}
}   

/* edited end */
if(!"".equals(selectedContent)){
	selectedworkflow = selectedContent;
}
if(!selectedworkflow.equals(""))    selectedworkflow+="|";

String needall=Util.null2String(request.getParameter("needall"));
if(needall.equals("1")) {		//全部流程
	isuserdefault="0";
	fromAdvancedMenu=0;
}
if(needall.equals("0")) {		//收藏夹流程


	//isuserdefault="1";		//收藏夹默认为空加上此行


	if("".equals(selectedworkflow)){
		needall="-1";
	}
}
int tdNum=0;
int tdOnum=0;
String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
int colorindex=0;
%>

<%
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));

String isec = Util.null2String(request.getParameter("isec"));
if("1".equals(isec)){
//topage = URLEncoder.encode(topage);
}
//获取流程新建权限体系sql条件
//List wfcreateruleuserinfo = new ArrayList();
//存放可以创建对应流程的人
//数据结构：key ： 流程id，value:可以创建这条流程的所有人员，类型为list
Map<String, List<String>> wfcreateinfo = new HashMap<String, List<String>>();
ArrayList NewWorkflowTypes = new ArrayList();
ArrayList NewWorkflows = new ArrayList();
 /*modify by mackjoe at 2005-09-14 增加子流程流程代理创建权限*/
ArrayList subAgentWorkflows = new ArrayList();
ArrayList subAgenterids = new ArrayList();
List<String> userlist = null;
String wfcrtSqlWhereMain = "";
User BelongtoUser = new User();
int Belongtoid=0;
String[] arr = null;
String sql = "";
//获取流程新建权限体系sql条件
if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
arr = Belongtoids.split(",");
for(int i=0;i<arr.length;i++){
Belongtoid = Util.getIntValue(arr[i]);
BelongtoUser = WorkFlowInit.getUser(Belongtoid);
BelongtoUser.getUserSubCompany1();
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(BelongtoUser, "t1");
sql="select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);

while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}

//所有可创建流程集合
sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
RecordSet.executeSql(sql);

while(RecordSet.next()){
    String _workflowid = RecordSet.getString("workflowid");
	NewWorkflows.add(_workflowid);
	//获取可以创建这条流程的人员集合


	 userlist = wfcreateinfo.get(_workflowid);
	//第一次为空


	if (userlist == null) {
	    userlist = new ArrayList<String>();
	    wfcreateinfo.put(_workflowid, userlist);
	}
	
	//把当前那个户添加进去
	userlist.add(BelongtoUser.getUID() + "");
}

//TD13554
Calendar subtoday = Calendar.getInstance();

	String subcurrentdate = Util.add0(subtoday.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(subtoday.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(subtoday.get(Calendar.DAY_OF_MONTH), 2) ;

	String subcurrenttime = Util.add0(subtoday.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(subtoday.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(subtoday.get(Calendar.SECOND), 2) ;
if (usertype == 0) {
	//获得当前的日期和时间
	String subbegindate="";
	String subbegintime="";
	String subenddate="";
	String subendtime="";
	int subagentworkflowtype=0;
	int subagentworkflow=0;
	int subbeagenterid=0;
	//sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid = "+Belongtoid+" order by t1.workflowtype,t.workflowid";
	sql = "select distinct t1.workflowtype,t.workflowid,t.bagentuid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid in ("+Belongtoid+") order by t1.workflowtype,t.workflowid";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean subisvald=false;
	    subbegindate=Util.null2String(RecordSet.getString("begindate"));
	    subbegintime=Util.null2String(RecordSet.getString("begintime"));
	    subenddate=Util.null2String(RecordSet.getString("enddate"));
	    subendtime=Util.null2String(RecordSet.getString("endtime"));
	    subagentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    subagentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    subbeagenterid=Util.getIntValue(RecordSet.getString("bagentuid"),0);
        

	    if(!subbegindate.equals("")){
	        if((subbegindate+" "+subbegintime).compareTo(subcurrentdate+" "+subcurrenttime)>0)
	            continue;
	    }
	    if(!subenddate.equals("")){
	        if((subenddate+" "+subendtime).compareTo(subcurrentdate+" "+subcurrenttime)<0)
	            continue;
	    }
		
		boolean subhaswfcreateperm = shareManager.hasWfCreatePermission(subbeagenterid, subagentworkflow);
		if(subhaswfcreateperm){
	        if(NewWorkflowTypes.indexOf(subagentworkflowtype+"")==-1){
	            NewWorkflowTypes.add(subagentworkflowtype+"");
	        }
	        
	        int subindx=subAgentWorkflows.indexOf(""+subagentworkflow);
	        if(subindx==-1){
	        	if(!offical.equals("1")||WorkflowComInfo.getIsWorkflowDoc(""+subagentworkflow).equals("1")){
		            subAgentWorkflows.add(""+subagentworkflow);
		            subAgenterids.add(""+subbeagenterid);
		        }
	        }else{
	            String subtempagenter=(String)subAgenterids.get(subindx);
	            if (subtempagenter.indexOf(subbeagenterid + "") == -1) {
	            	subtempagenter += "," + subbeagenterid;
		            subAgenterids.set(subindx,subtempagenter);	
	            }
	        }
	    }
	}
	//end
}


}
}

wfcrtSqlWhereMain = shareManager.getWfShareSqlWhere(user, "t1");
String sqlmain="select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);

while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}


//所有可创建流程集合
sqlmain = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);

while(RecordSet.next()){
    String _workflowid = RecordSet.getString("workflowid");
	NewWorkflows.add(_workflowid);
	//获取可以创建这条流程的人员集合


	 userlist = wfcreateinfo.get(_workflowid);

	//第一次为空


	if (userlist == null) {
	    userlist = new ArrayList<String>();
	    wfcreateinfo.put(_workflowid, userlist);
	}
	
	//把当前那个户添加进去
	userlist.add(user.getUID() + "");
}


/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//TD13554
Calendar today = Calendar.getInstance();

	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(today.get(Calendar.SECOND), 2) ;
if (usertype == 0) {
	//获得当前的日期和时间
	String begindate="";
	String begintime="";
	String enddate="";
	String endtime="";
	int agentworkflowtype=0;
	int agentworkflow=0;
	int beagenterid=0;
	//sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid = "+userid+" order by t1.workflowtype,t.workflowid";
	sql = "select distinct t1.workflowtype,t.workflowid,t.bagentuid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid in ("+userIDAll+") order by t1.workflowtype,t.workflowid";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean isvald=false;
	    begindate=Util.null2String(RecordSet.getString("begindate"));
	    begintime=Util.null2String(RecordSet.getString("begintime"));
	    enddate=Util.null2String(RecordSet.getString("enddate"));
	    endtime=Util.null2String(RecordSet.getString("endtime"));
	    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    beagenterid=Util.getIntValue(RecordSet.getString("bagentuid"),0);
        

	    if(!begindate.equals("")){
	        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
	            continue;
	    }
	    if(!enddate.equals("")){
	        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
	            continue;
	    }
		
		boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
		if(haswfcreateperm){
	        if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
	            NewWorkflowTypes.add(agentworkflowtype+"");
	        }
	        
	        int indx=AgentWorkflows.indexOf(""+agentworkflow);
	        if(indx==-1){
	        	if(!offical.equals("1")||WorkflowComInfo.getIsWorkflowDoc(""+agentworkflow).equals("1")){
		            AgentWorkflows.add(""+agentworkflow);
		            Agenterids.add(""+beagenterid);
		        }
	        }else{
	            String tempagenter=(String)Agenterids.get(indx);
	            if (tempagenter.indexOf(beagenterid + "") == -1) {
	            	tempagenter += "," + beagenterid;
		            Agenterids.set(indx,tempagenter);	
	            }
	        }
	    }
	}
	//end
}

String  freewfCreater="";
boolean  canFreeWfCreate=false;

List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<NewWorkflows.size();i++){
	tempWorkflowId=(String)NewWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId).equals("1"))continue;
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+tempWorkflowId).equals("1"))continue;
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

String dataCenterWorkflowTypeId="";
RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
if(RecordSet.next()){
	dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
}

this.rs=RecordSet;
List inputReportList=this.getAllInputReport(String.valueOf(userid));
//if(inputReportList.size()>0){
//	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
//}
if(inputReportList.size()>0&&NewWorkflowTypes.indexOf(dataCenterWorkflowTypeId)==-1){
	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
}
ArrayList NewInputReports = new ArrayList();
Map inputReportMap=null;
String inprepId=null;
String inprepName=null;
for(int i=0;i<inputReportList.size();i++){
	inputReportMap=(Map)inputReportList.get(i);
	inprepId=Util.null2String((String)inputReportMap.get("inprepId"));
	if(!inprepId.equals("")&&inputReportFormIdList.indexOf(InputReportComInfo.getbillid(inprepId))==-1){
		NewInputReports.add(inprepId);
	}
}

int wftypetotal=WorkTypeComInfo.getWorkTypeNum();
int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=0;

while(WorkTypeComInfo.next()){
		String wftypename=WorkTypeComInfo.getWorkTypename();
		String wftypeid = WorkTypeComInfo.getWorkTypeid();
		if(NewWorkflowTypes.indexOf(wftypeid)==-1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
 			continue;            
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true) {
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
}
WorkTypeComInfo.setTofirstRow();
%>
		<%
		//int usedtodo = 1;
		int usedtodo = Util.getIntValue(request.getParameter("usedtodo"),-1);
		if(fromAdvancedMenu!=1 && usertype==0&&!commonuse.equals("0") && usedtodo == 1){   //常用流程
        	String agentWfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
		if(RecordSet.getDBType().equals("oracle")){
	        	/*if(offical.equals("1")){
	        		RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t2.isWorkflowDoc=1 and t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" and ((t.beginDate||t.beginTime||':00'<='"+currentdate+currenttime+"' and t.endDate||t.endTime||':00'>='"+currentdate+currenttime+"'))or(t.beginDate||t.beginTime='' and t.endDate||t.endTime = ''))) order by count desc) WHERE ROWNUM <= 12 ORDER BY ROWNUM ASC");
	        	}else{
	        		RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" and ((t.beginDate||t.beginTime||':00'<='"+currentdate+currenttime+"' and t.endDate||t.endTime||':00'>='"+currentdate+currenttime+"'))or(t.beginDate||t.beginTime='' and t.endDate||t.endTime = ''))) order by count desc) WHERE ROWNUM <= 12 ORDER BY ROWNUM ASC");
	        	}*/
				if(offical.equals("1")){
        		RecordSet.execute("select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t2.isWorkflowDoc=1 and t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid=" + userid +" )) and ROWNUM <= 12 order by count desc");
        		}else{
        		RecordSet.execute("select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid=" + userid +" )) and ROWNUM <= 12 order by count desc");
        		}
	        }else{
	        	if(offical.equals("1")){
	        		RecordSet.execute("select top 12 * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t2.isWorkflowDoc=1 and t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid=" + userid +" )) order by count desc");
	        	}else{
	        		RecordSet.execute("select top 12 * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' ) or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid=" + userid +" )) order by count desc");
	        	}
	        }
				List<Map> todoList = new ArrayList<Map>();
        	if(RecordSet.getCounts()>0){
				int increment=0;
			    String isImportWf="";
				boolean isWfShow=false;
				String curtypeid ="";
                //遍历常用流程
               while(RecordSet.next()){
                    Map todoMap = new HashMap();
					 boolean selfwf = true;
					 isWfShow=false;
			         int isagent=0;
			         int beagenter=0;
					 int subisagent=0;
			         int subbeagenter=0;
					 String subagentname="";
			         String agentname="";
			         ArrayList agenterlist=new ArrayList();
					 ArrayList subagenterlist=new ArrayList();
                     String wfid= RecordSet.getString("wfid");
					 if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+wfid).equals("1"))continue;
                     if(NewWorkflows.indexOf(wfid) != -1){
                        //isWfShow=true;
                        increment++;
					  //流程导入
					  isImportWf=WorkflowComInfo.getIsImportwf(wfid);
					  curtypeid = WorkflowComInfo.getWorkflowtype(wfid);

				 	 if(increment==12){
						break;
					 }else if(increment%3==1){
					 } 
				 	 
				 	selfwf = shareManager.hasWfCreatePermission(userid, Integer.parseInt(wfid));
				 	isWfShow = selfwf;
					  //javascript:onNewRequest(=wfid,0,0)
					  todoMap.put("wfid", wfid);
					  todoMap.put("wfname", Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage()));
					  todoMap.put("selfwf", selfwf); 
					   //创建代理流程
					  if(AgentWorkflows.indexOf(wfid)>-1){
						  selfwf = false;
						agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
						isagent=1;	
						List agentList = new ArrayList();
						for(int k=0;k<agenterlist.size();k++){
							Map agentMap = new HashMap();
							beagenter=Util.getIntValue((String)agenterlist.get(k),0);
							agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
							String ownDepid = ResourceComInfo.getDepartmentID((String)agenterlist.get(k));
							String depName = DepartmentComInfo.getDepartmentname(ownDepid);
							agentMap.put("beagenter", beagenter);
							agentMap.put("agentname", agentname);
							agentMap.put("userid", userid);
							agentMap.put("ownDepid", ownDepid);
							agentMap.put("depName", depName);
							agentList.add(agentMap);
							//onclick="javascript:onNewRequest(wfid,isagent,beagenter);"
						}
						todoMap.put("agents", agentList);
				   }
					  //可以创建这条流程的人员集合


			  userlist = wfcreateinfo.get(wfid + "");																
						 for (int i = 0; i < userlist.size()-1; i++) {
							for (int j = userlist.size() - 1; j > i; j--) {
								if (userlist.get(j).equals(userlist.get(i))) {
									 userlist.remove(j);
										}
									}
							}
							  if(userlist.size()>0 && "1".equals(belongtoshow)){
								  	List MainSubList = new ArrayList();
								    //Map mainsubMap1 = new HashMap();
									//int k = 0	;
					for(int k =0;k<userlist.size();k++)	{
						
						  Map mainsubMap1 = new HashMap();
						   // Map mainsubMap3 = new HashMap();
							// Map mainsubMap4 = new HashMap();
							int belongtouserid=Util.getIntValue((String)userlist.get(k),0);
							if(belongtouserid!=userid){
						  	selfwf = false;
							String username=ResourceComInfo.getResourcename((String)userlist.get(k));
							String ownDepid = ResourceComInfo.getDepartmentID((String)userlist.get(k));
							String depName = DepartmentComInfo.getDepartmentname(ownDepid);	
							String jobName = jobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle((String)userlist.get(k)));
							mainsubMap1.put("mainuserid2",userid);
							//MainSubList.add(mainsubMap1);
							mainsubMap1.put("belongtoid",belongtouserid);
							//MainSubList.add(mainsubMap2);
							mainsubMap1.put("depName",depName);
							//MainSubList.add(mainsubMap3);
							mainsubMap1.put("jobName",jobName);
							//MainSubList.add(mainsubMap4);
							/*MainSubList.add("mainuserid2");
							MainSubList.add(userid);
							MainSubList.add("belongtoid");
							MainSubList.add(belongtouserid);
							MainSubList.add("depName");
							MainSubList.add(depName);
							MainSubList.add("jobName");
							MainSubList.add(jobName);
							mainsubMap1.put(k,MainSubList);	 */
							//todoMap.put("mainsub", k);
							MainSubList.add(mainsubMap1);
					
						
					  
					  }
					  }


					  todoMap.put("mainsub", MainSubList);
					  }

					  			   //创建代理流程
							//Map subagentMap2 = new HashMap();
					  if(subAgentWorkflows.indexOf(wfid)>-1){
						 // selfwf = false;
						subagenterlist=Util.TokenizerString((String)subAgenterids.get(subAgentWorkflows.indexOf(wfid)),",");
						subisagent=1;	
						List subagentList = new ArrayList();
						for(int z=0;z<subagenterlist.size();z++){
							Map subagentMap = new HashMap();
							subbeagenter=Util.getIntValue((String)subagenterlist.get(z),0);
							subagentname=ResourceComInfo.getResourcename((String)subagenterlist.get(z));
							String subownDepid = ResourceComInfo.getDepartmentID((String)subagenterlist.get(z));
							String subdepName = DepartmentComInfo.getDepartmentname(subownDepid);
							subagentMap.put("beagenter", subbeagenter);
							subagentMap.put("agentname", subagentname);
							subagentMap.put("userid", Belongtoid);
							subagentMap.put("ownDepid", subownDepid);
							subagentMap.put("depName", subdepName);
							subagentList.add(subagentMap);
							
							//onclick="javascript:onNewRequest(wfid,isagent,beagenter);"
						}
						todoMap.put("agents", subagentList);
						//subagentMap2.put("subagents", subagentList);
						//MainSubList.add(subagentMap2);
				   }
					                                     	    

              }  
			  if(AgentWorkflows.indexOf(wfid)!=-1  && !isWfShow){
			 	 increment++;
				 if(increment==12){
					break;
				 }else if(increment%3==1){
                 }
				   selfwf = false;
				   todoMap.put("wfid", wfid);
				   todoMap.put("wfname", Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage()));
				   todoMap.put("selfwf", selfwf);
				   agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
				   isagent=1;
					List agentList2 = new ArrayList();
				   for(int i=0;i<agenterlist.size();i++){
					   Map agentMap2 = new HashMap();
					   beagenter=Util.getIntValue((String)agenterlist.get(i),0);
						agentname=ResourceComInfo.getResourcename((String)agenterlist.get(i));
						String ownDepid = ResourceComInfo.getDepartmentID((String)agenterlist.get(i));
						String depName = DepartmentComInfo.getDepartmentname(ownDepid);
						agentMap2.put(beagenter, userid);
						agentMap2.put("beagenter", beagenter);
						agentMap2.put("agentname", agentname);
						agentMap2.put("userid", userid);
						agentMap2.put("ownDepid", ownDepid);
						agentMap2.put("depName", depName);
						agentList2.add(agentMap2);
						//onNewRequest(wfid,isagent,beagenter)
						//Util.toScreen(agentname,user.getLanguage())///Util.toScreen(depName,user.getLanguage())
				  }
						todoMap.put("agents", agentList2);
			  }
			  if(todoMap.isEmpty()){
		        continue;
		      }
              todoList.add(todoMap);
         }
	} 
     JSONArray json = new JSONArray();     
     //json.put(todoList);
     out.print(json.fromObject(todoList).toString());
				
     //System.out.println();
	} //常用流程-end
	if(usedtodo != 1){		//全部流程、收藏夹begin
							
		int i=0;
		int needtd=rownum;
		int numRows=0;
		List<Map> todoList = new ArrayList<Map>();
		while(WorkTypeComInfo.next()){
			String wftypename=WorkTypeComInfo.getWorkTypename();
			String wftypeid = WorkTypeComInfo.getWorkTypeid();
			
			if(offical.equals("1") && !WorkTypeComInfo.hasWorkflowDoc(wftypeid))	continue;
			if(NewWorkflowTypes.indexOf(wftypeid)==-1)	continue;            
		 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && isuserdefault.equals("1"))	continue;
		 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1)	continue;
		 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true)	continue;
	 		numRows++;
			needtd--;
		%>
				
		<%
	 	int isfirst = 1;
		//标识当前记录所处条数


		int countinfo=0;
		if(dataCenterWorkflowTypeId.equals(wftypeid)){
			while(InputReportComInfo.next()){
			 	inprepId = InputReportComInfo.getinprepid();
				inprepName=InputReportComInfo.getinprepname();
			 	if(NewInputReports.indexOf(inprepId)==-1){
			 		    continue;
		        }
			 	//check right
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& isuserdefault.equals("1")) continue;
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& fromAdvancedMenu==1) continue;
			 	i++;
			 	countinfo++;
				%>
			<%}// end while
			InputReportComInfo.setTofirstRow();
	  	}// end if

	    //流程对应的li是否创建
	    boolean  isWfShow; 
	    
		while(WorkflowComInfo.next()){
			Map todoMap = new HashMap();
			 boolean selfwf = true;
			String wfname=WorkflowComInfo.getWorkflowname();
			String wfid = WorkflowComInfo.getWorkflowid();
			if(offical.equals("1")&&!WorkflowComInfo.getIsWorkflowDoc(""+wfid).equals("1"))continue;

		 	String curtypeid = WorkflowComInfo.getWorkflowtype();
	        String  isImportWf=WorkflowComInfo.getIsImportwf();
			isWfShow=false; 

					 int isagent=0;
			         int beagenter=0;
					 int subisagent=0;
			         int subbeagenter=0;
					 String subagentname="";
			         String agentname="";
			         ArrayList agenterlist=new ArrayList();
					 ArrayList subagenterlist=new ArrayList();

		 	if(!curtypeid.equals(wftypeid)) continue;
		 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
		 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;
		 	if(isfirst ==1){
		 		isfirst = 0;
			}
			
			if(NewWorkflows.indexOf(wfid)!=-1){
				countinfo++;
			 	isWfShow=true;
		   %>														
				
			   <% //创建代理流程
			   selfwf = shareManager.hasWfCreatePermission(userid, Integer.parseInt(wfid));
			   isWfShow = selfwf;
			   todoMap.put("wfid", wfid);
				todoMap.put("wfname", Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage()));
				todoMap.put("selfwf", selfwf);
				if(AgentWorkflows.indexOf(wfid)>-1){
					selfwf = false;
					agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
					isagent=1;			 
					List agentList = new ArrayList();
					for(int k=0;k<agenterlist.size();k++){
						Map agentMap = new HashMap();
						beagenter=Util.getIntValue((String)agenterlist.get(k),0);
						agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
						String ownDepid = ResourceComInfo.getDepartmentID((String)agenterlist.get(k));
						String depName = DepartmentComInfo.getDepartmentname(ownDepid);
						agentMap.put("beagenter", beagenter);
						agentMap.put("agentname", agentname);
						agentMap.put("userid", userid);
						agentMap.put("ownDepid", ownDepid);
						agentMap.put("depName", depName);
						agentList.add(agentMap);
					}
					todoMap.put("agents", agentList);
				}

							  //可以创建这条流程的人员集合


			  userlist = wfcreateinfo.get(wfid + "");																
						 for (int ii = 0; ii < userlist.size(); ii++) {
							for (int jj = userlist.size()-1; jj > ii; jj--) {
								if (userlist.get(jj).equals(userlist.get(ii))) {
									 userlist.remove(jj);
										}
									}
							}
							  if(userlist.size()>0 && "1".equals(belongtoshow)){
								  	List MainSubList = new ArrayList();
								    //Map mainsubMap1 = new HashMap();
									//int k = 0	;
							for(int k =0;k<userlist.size();k++)	{
						
						  Map mainsubMap1 = new HashMap();
						   // Map mainsubMap3 = new HashMap();
							// Map mainsubMap4 = new HashMap();
							int belongtouserid=Util.getIntValue((String)userlist.get(k),0);
							if(belongtouserid!=userid){
						  	selfwf = false;
							String username=ResourceComInfo.getResourcename((String)userlist.get(k));
							String ownDepid = ResourceComInfo.getDepartmentID((String)userlist.get(k));
							String depName = DepartmentComInfo.getDepartmentname(ownDepid);	
							String jobName = jobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle((String)userlist.get(k)));
							mainsubMap1.put("mainuserid1",userid);
							//MainSubList.add(mainsubMap1);
							mainsubMap1.put("belongtoid",belongtouserid);
							//MainSubList.add(mainsubMap2);
							mainsubMap1.put("depName",depName);
							//MainSubList.add(mainsubMap3);
							mainsubMap1.put("jobName",jobName);
							//MainSubList.add(mainsubMap4);
							/*MainSubList.add("mainuserid2");
							MainSubList.add(userid);
							MainSubList.add("belongtoid");
							MainSubList.add(belongtouserid);
							MainSubList.add("depName");
							MainSubList.add(depName);
							MainSubList.add("jobName");
							MainSubList.add(jobName);
							mainsubMap1.put(k,MainSubList);	 */
							//todoMap.put("mainsub", k);
							MainSubList.add(mainsubMap1);
								   //创建代理流程
						/*	Map subagentMap2 = new HashMap();
					  if(subAgentWorkflows.indexOf(wfid)>-1){
						 // selfwf = false;
						subagenterlist=Util.TokenizerString((String)subAgenterids.get(subAgentWorkflows.indexOf(wfid)),",");
						subisagent=1;	
						List subagentList = new ArrayList();
						for(int z=0;z<subagenterlist.size();z++){
							Map subagentMap = new HashMap();
							subbeagenter=Util.getIntValue((String)subagenterlist.get(z),0);
							subagentname=ResourceComInfo.getResourcename((String)subagenterlist.get(z));
							String subownDepid = ResourceComInfo.getDepartmentID((String)subagenterlist.get(z));
							String subdepName = DepartmentComInfo.getDepartmentname(subownDepid);
							subagentMap.put("subbeagenter", subbeagenter);
							subagentMap.put("subagentname", subagentname);
							subagentMap.put("belongtouserid", belongtouserid);
							subagentMap.put("subownDepid", ownDepid);
							subagentMap.put("subdepName", depName);
							subagentList.add(subagentMap);
							
							//onclick="javascript:onNewRequest(wfid,isagent,beagenter);"
						}
						subagentMap2.put("subagents", subagentList);
						MainSubList.add(subagentMap2);
				   }
					*/	
					  
					  }
					  }
					  todoMap.put("mainsub", MainSubList);
					  }

					    			   //创建代理流程
							//Map subagentMap2 = new HashMap();
					  if(subAgentWorkflows.indexOf(wfid)>-1){
						 // selfwf = false;
						subagenterlist=Util.TokenizerString((String)subAgenterids.get(subAgentWorkflows.indexOf(wfid)),",");
						subisagent=1;	
						List subagentList = new ArrayList();
						for(int z=0;z<subagenterlist.size();z++){
							Map subagentMap = new HashMap();
							subbeagenter=Util.getIntValue((String)subagenterlist.get(z),0);
							subagentname=ResourceComInfo.getResourcename((String)subagenterlist.get(z));
							String subownDepid = ResourceComInfo.getDepartmentID((String)subagenterlist.get(z));
							String subdepName = DepartmentComInfo.getDepartmentname(subownDepid);
							subagentMap.put("beagenter", subbeagenter);
							subagentMap.put("agentname", subagentname);
							subagentMap.put("userid", Belongtoid);
							subagentMap.put("ownDepid", subownDepid);
							subagentMap.put("depName", subdepName);
							subagentList.add(subagentMap);
							
							//onclick="javascript:onNewRequest(wfid,isagent,beagenter);"
						}
						todoMap.put("agents", subagentList);
						//subagentMap2.put("subagents", subagentList);
						//MainSubList.add(subagentMap2);
				   }
					
	           }
		        //流程代理信息
	            if(AgentWorkflows.indexOf(wfid)>-1 && !isWfShow){
			        //如果未创建，则创建该流程对应得而li节点
	                if(!isWfShow){
	                	selfwf = false;
						countinfo++;
					 
                        agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
                        isagent=1;
                        todoMap.put("wfid", wfid);
     				   todoMap.put("wfname", Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage()));
     				  todoMap.put("selfwf", selfwf);
                        List agentList2 = new ArrayList();
                        for(int k=0;k<agenterlist.size();k++){
	                		Map agentMap2 = new HashMap();
							beagenter=Util.getIntValue((String)agenterlist.get(k),0);
							agentname=ResourceComInfo.getResourcename((String)agenterlist.get(k));
							String ownDepid = ResourceComInfo.getDepartmentID((String)agenterlist.get(k));
							String depName = DepartmentComInfo.getDepartmentname(ownDepid);
							agentMap2.put("beagenter", beagenter);
							agentMap2.put("agentname", agentname);
							agentMap2.put("userid", userid);
							agentMap2.put("ownDepid", ownDepid);
							agentMap2.put("depName", depName);
							agentList2.add(agentMap2);
			 			}
                        todoMap.put("agents", agentList2);
					} 
			}
	        navigateToWfid = Util.getIntValue(wfid);
		 	navigateToIsagent = isagent;
	        navigateToAgenter = beagenter;
	        
	        if(todoMap.isEmpty()){
	        	continue;
	        }
	        
	        todoList.add(todoMap);
			}
			WorkflowComInfo.setTofirstRow();
			colorindex++;
			if(needtd==0){
				needtd=rownum;
				tdNum++;
			}
		}
		JSONArray json = new JSONArray();     
	    //json.put(todoList);
	    out.print(json.fromObject(todoList).toString());
	}
%>

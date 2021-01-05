<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.workflow.request.SubWorkflowManager" %>
<%@ page import="weaver.workflow.workflow.WFSubDataAggregation" %>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="SystemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>

<%
	int f_weaver_belongto_userid = Util.getIntValue(Util.null2String(request.getParameter("f_weaver_belongto_userid")), 0);
	int f_weaver_belongto_usertype = Util.getIntValue(Util.null2String(request.getParameter("f_weaver_belongto_usertype")), 0);
    //User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
    User user = HrmUserVarify.getUser (request , response) ;
	int userid = Util.getIntValue(Util.null2String(request.getParameter("userid")), 0);
	int requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid")), 0);
	int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")), 0);
	int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")), 0);
	int isOldWf = Util.getIntValue(Util.null2String(request.getParameter("isOldWf")), 0);
	String ismultiprintmode = Util.null2String(session.getAttribute(userid + "" + requestid+ "ismultiprintmode"));
	//判断意见区域是否不显示
	String isHideArea = "0";
    String thisHideInputTemp = "";
    //是否流程督办
    int urger = Util.getIntValue(request.getParameter("urger"),0);
    //是否流程柑橘
    int isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);
    //String isHideInput = "0";
    int _ismode=-1;
    String isworkflowhtmldoc=Util.null2String(session.getAttribute("isworkflowhtmldoc"+requestid));
	rssign.executeSql("select ishidearea,ishideinput,ismode from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
	if (rssign.next()) {
		isHideArea = ""+Util.getIntValue(rssign.getString("ishidearea"), 0);
		thisHideInputTemp = Util.null2String(rssign.getString("ishideinput"));
		_ismode = Util.getIntValue(rssign.getString("ismode"),-1);
	}
	
	int _forward = Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
	int _submit = Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
	
	//默认动态加载签字意见
	boolean signListType = false ;
	if ("0".equals(isHideArea)) {
		rssign.executeSql("select signlisttype from workflow_RequestUserDefault where userId = "+userid);
		if(rssign.next()){
	         if(rssign.getString("signlisttype").equals("0")){
	        	 signListType = true;
	         }		
		}
		SubWorkflowManager.loadRelatedRequest(request);
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.workflow.request.RequestSignRelevanceWithMe"%>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<%@page import="weaver.general.Util"%>


<%
int initrequestid = requestid;
ArrayList allrequestid = new ArrayList();
ArrayList allrequestname = new ArrayList();
ArrayList canviewwf = (ArrayList)session.getAttribute("canviewwf");
if(canviewwf == null) canviewwf = new ArrayList();
int mainrequestid = 0;
int mainworkflowid = 0;
String subWfSetId = "0";
String isDiff = "";
String canviewworkflowid = "-1";
boolean hasMainReq = false;
boolean hasChildReq = false;
boolean hasParallelReq = false;

boolean hasOldMainReq = false;
boolean hasOldChildReq = false;
boolean hasOldParallelReq = false;

rssign.executeSql("select * from workflow_requestbase where requestid = "+ requestid);
if(rssign.next()){
   mainworkflowid = rssign.getInt("workflowid");
}

String _isPrint = Util.null2String(request.getParameter("isprint"));
if("1".equals(_isPrint))		//系统单据打印
	_isPrint = "true";
String isReadMain = "0";			//子流程是否可查看主流程签字意见
String isReadMainNodes = "";		//子流程可查看主流程签字意见的范围
String isReadParallel = "0";		//平行流程是否可查看签字意见
String isReadParallelNodes = "";	//平行流程是否可查看签字意见的范围

/*查询当前请求的主请求*/
rssign.executeSql("select sub.subwfid,sub.isSame,sub.mainrequestid,req.requestname from workflow_subwfrequest sub"
		+ " left join workflow_requestbase req on req.requestid=sub.mainrequestid"
		+ " where sub.subrequestid=" + requestid);
if(rssign.next()){
   if(rssign.getInt("mainrequestid") > -1){
     subWfSetId = Util.null2String(rssign.getString("subwfid"));
     isDiff = Util.null2String(rssign.getString("isSame"));
     mainrequestid = rssign.getInt("mainrequestid");
     
     allrequestid.add(mainrequestid + ".main");
     allrequestname.add(rssign.getString("requestname"));
     
     hasMainReq = true;
   }
 }

String mainworkflowid_temp = "";
//老数据
if (!hasMainReq) {
    rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = "+ requestid);
    if(rssign.next()){
        if(rssign.getInt("mainrequestid") > -1){
          mainrequestid = rssign.getInt("mainrequestid");
          rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
          if(rssign.next()){
              mainworkflowid_temp = rssign.getString("workflowid"); 
              String reqname2 = rssign.getString("requestname");
              rssign.executeSql("select 1 from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid_temp+" and subworkflowid ="+workflowid+" and isread = 1 union select 1 from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid="+mainworkflowid+" and b.subWorkflowId="+workflowid);
      		  if(rssign.next()){
      		      allrequestid.add(mainrequestid + ".main");
                  allrequestname.add(reqname2);
                  hasMainReq = true;
                  hasOldMainReq = true;
      		  }
          }
        }
      }
}
if ("".equals(mainworkflowid_temp)) {
    mainworkflowid_temp = "-1";   
}
//mainworkflowid_temp
rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in ("+mainworkflowid_temp+", " + workflowid + ") and isread = 1 ");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");
}

rssign.executeSql("select distinct b.subworkflowid from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid in ("+mainworkflowid_temp+","+workflowid+")");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");
}

/*如果当前请求拥有主请求，则才会拥有平行请求。平行请求是指：同一个主请求在同一触发设置中触发的其他请求*/
/*查询当前请求的平行请求*/
if(hasMainReq){
	rssign.executeSql(" select sub.subrequestid requestid,req.requestname from workflow_subwfrequest sub"
			+ " left join workflow_requestbase req on req.requestid=sub.subrequestid"
			+ " where sub.mainrequestid=" + mainrequestid + " and sub.subwfid=" + subWfSetId
			+ " and sub.subrequestid <> "  + initrequestid);
	while(rssign.next()){
	    allrequestid.add(rssign.getString("requestid") + ".parallel");
	    allrequestname.add(rssign.getString("requestname"));
	    canviewwf.add(rssign.getString("requestid"));
	    
    	hasParallelReq = true;
	}
	
	rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ mainworkflowid_temp +" and workflowid in ("+canviewworkflowid+")");
	while(rssign.next()){
	    if (allrequestid.contains(rssign.getString("requestid") + ".parallel")) {
	        continue;
	    }
	        
	    allrequestid.add(rssign.getString("requestid") + ".parallel");
	    allrequestname.add(rssign.getString("requestname"));
	    canviewwf.add(rssign.getString("requestid"));
	    if (!(initrequestid + "").equals(rssign.getString("requestid"))) {
	    	hasParallelReq = true;
	    	hasOldParallelReq = true;
	    }
	}
}

/*查询主流程和平行流程查看范围*/
if(hasMainReq && !hasOldMainReq){
	/*触发不同流程和相同流程的配置不在同一张表中，需要判断后查询 */
	if("1".equals(isDiff)){
	    rssign.executeSql("select isreadMainWfNodes,isreadMainwf,"
	   			+ " isreadParallelwfNodes,isreadParallelwf from workflow_tridiffwfsubwf"
	   			+ " where id = " + subWfSetId);
	}else{
	    rssign.executeSql("select isreadMainWfNodes,isreadMainwf,"
				+ " isreadParallelwfNodes,isreadParallelwf from workflow_subwfset"
				+ " where id = " + subWfSetId);
	}
	if(rssign.next()){
	    isReadMain = Util.null2String(rssign.getString("isreadMainwf"));
	    isReadMainNodes = Util.null2String(rssign.getString("isreadMainWfNodes"));
	    isReadParallel = Util.null2String(rssign.getString("isreadParallelwf"));
	    isReadParallelNodes = Util.null2String(rssign.getString("isreadParallelwfNodes"));
	}
}

/*查询当前请求的子请求*/
rssign.executeSql("select sub.subwfid,sub.isSame,sub.subrequestid requestid,req.requestname"
	+ " from workflow_subwfrequest sub left join workflow_requestbase req on req.requestid=sub.subrequestid"
	+ " where sub.mainrequestid='" + initrequestid + "' order by sub.subrequestid desc");

Map<String, String> triggerIsDiffMap = new HashMap<String, String>();
Map<String, String> requestSettingMap = new HashMap<String, String>();			
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".sub");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
    hasChildReq = true;
    
    subWfSetId = Util.null2String(rssign.getString("subwfid"));
    isDiff = Util.null2String(rssign.getString("isSame"));
    
    requestSettingMap.put(rssign.getString("requestid"), subWfSetId);
    triggerIsDiffMap.put(subWfSetId, isDiff);
}
/**161014 zzw 添加判断 **/
if(requestid>0&&!"-1".equals(canviewworkflowid)){
rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ requestid+" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    if (allrequestid.contains(rssign.getString("requestid") + ".sub")) {
        continue;
    }
    
    allrequestid.add(rssign.getString("requestid") + ".sub");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
    hasChildReq = true;
    hasOldChildReq = true;
  }
}


/*查询子流程查看范围*/
class TriggerSetting{
	private String settingId;
	private String isRead;
	private String isReadNodes;
	
	public void setSettingId(String settingId){
		this.settingId = settingId;
	}
	
	public String getSettingId(){
		return this.settingId;
	}
	
	public void setIsRead(String isRead){
		this.isRead = isRead;
	}
	
	public String getIsRead(){
		return this.isRead;
	}
	
	public void setIsReadNodes(String isReadNodes){
		this.isReadNodes = isReadNodes;
	}
	
	public String getIsReadNodes(){
		return this.isReadNodes;
	}
}
List<TriggerSetting> _triggerSettings = new ArrayList<TriggerSetting>();
Map<String, TriggerSetting> triggerSettingMap = new HashMap<String, TriggerSetting>();
if(hasChildReq){
	Iterator<String> _settingIds = triggerIsDiffMap.keySet().iterator();
	while( _settingIds.hasNext() ){
		String _triggerSettingId = _settingIds.next();
		String _isDiff = triggerIsDiffMap.get(_triggerSettingId);
		
		/*触发不同流程和相同流程的配置不在同一张表中，需要判断后查询 */
		if("1".equals(_isDiff)){
		    rssign.executeSql("select id,isreadNodes,isread from workflow_tridiffwfsubwf"
		   			+ " where id = " + _triggerSettingId);
		}else{
		    rssign.executeSql("select id,isreadNodes,isread from workflow_subwfset"
					+ " where id = " + _triggerSettingId);
		}
		
		if(rssign.next()){	
			String _settingId = Util.null2String(rssign.getString("id"));
			//主流程是否可查看子流程签字意见
		    String _isRead = Util.null2String(rssign.getString("isread"));
		    //主流程可查看子流程签字意见的范围
		    String _isReadNodes = Util.null2String(rssign.getString("isreadNodes"));
		    
		    TriggerSetting _triggerSetting = new TriggerSetting();
		    _triggerSetting.setSettingId(_settingId);
		    _triggerSetting.setIsRead(_isRead);
		    _triggerSetting.setIsReadNodes(_isReadNodes);
		    
		    _triggerSettings.add(_triggerSetting);
		}
	}
	
	//将list转化为，方便通过settingId直接获取setting
	for(int i = 0; i < _triggerSettings.size(); i++){
		TriggerSetting _triggerSetting = _triggerSettings.get(i);
		triggerSettingMap.put(_triggerSetting.getSettingId(), _triggerSetting);
	}
}

session.setAttribute("canviewwf",canviewwf);
requestid = initrequestid;
%>

 <%
				    boolean isLight = false;
				    int nLogCount = 0;
				    //获取是否开启签章，启用签章时，禁用引用按钮
				    String tempIsFormSignature=null;
				    RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
			         if(RecordSet.next()){
			        	 tempIsFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
			        }
				    int tempRequestLogId = 0;
				    int tempImageFileId = 0;
				    /*--  xwj for td2104 on 20050802 B E G I N --*/
				    String viewLogIds = "";
				    ArrayList canViewIds = new ArrayList();
				    String viewNodeId = "-1";
				    String tempNodeId = "-1";
				    String singleViewLogIds = "-1";
				    char procflag = Util.getSeparator();
				    RecordSetLog.executeSql("select nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" order by receivedate desc ,receivetime desc");
				    if(RecordSetLog.next()){
				    	viewNodeId = RecordSetLog.getString("nodeid");
				        RecordSetLog1
				                .executeSql("select viewnodeids from workflow_flownode where workflowid="
				                        + workflowid + " and nodeid=" + viewNodeId);
				        if (RecordSetLog1.next()) {
				            singleViewLogIds = RecordSetLog1.getString("viewnodeids");
				        }

				        if ("-1".equals(singleViewLogIds)) {//全部查看
				            RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="
				                            + requestid + "))");
				            while (RecordSetLog2.next()) {
				                tempNodeId = RecordSetLog2.getString("nodeid");
				                if (!canViewIds.contains(tempNodeId)) {
				                    canViewIds.add(tempNodeId);
				                }
				            }
				        } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看
				        } else {//查看部分
				            String tempidstrs[] = Util.TokenizerString2(
				                    singleViewLogIds, ",");
				            for (int i = 0; i < tempidstrs.length; i++) {
				                if (!canViewIds.contains(tempidstrs[i])) {
				                    canViewIds.add(tempidstrs[i]);
				                }
				            }
				        }
				    }
				    String reportid1 = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"reportid"));
				    String isfromreport1 = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromreport"));
				    String isfromflowreport1 = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromflowreport"));
				    
				    if("1".equals(isfromreport1) &&  requestid != 0){
				    	if(ReportAuthorization.checkUserReportPrivileges(reportid1,String.valueOf(requestid),user)){
						  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
						  	while(RecordSetLog2.next()){
							  	tempNodeId = RecordSetLog2.getString("nodeid");
							  	if(!canViewIds.contains(tempNodeId)){
							  	canViewIds.add(tempNodeId);
							  	}
						  	}
						  	
				    	}
				    }

				    if("1".equals(isfromflowreport1) &&  requestid != 0){
				    	if(ReportAuthorization.checkFlowReport(reportid1,String.valueOf(requestid),user)){
				    		RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
						  	while(RecordSetLog2.next()){
							  	tempNodeId = RecordSetLog2.getString("nodeid");
							  	if(!canViewIds.contains(tempNodeId)){
							  	canViewIds.add(tempNodeId);
							  	}
						  	}
				    	}
				    }
				  
				  //处理相关流程的查看权限
				  String allsubrequestid = "";
				  int desrequestid_temp = Util.getIntValue(request.getParameter("desrequestid"),0);
				  String isurger_temp=Util.null2String(request.getParameter("isurger"));
				  String wfmonitor_temp=Util.null2String(request.getParameter("wfmonitor"));
				  int intervenorright_temp=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);
				  if(desrequestid_temp!=0)
				  {
				  	RecordSetLog2.executeSql("select workflowid from workflow_requestbase where requestid = "+desrequestid_temp);
				  	if(RecordSetLog2.next()){
				  		WFManager.setWfid(RecordSetLog2.getInt("workflowid"));
				  		WFManager.getWfInfo();
				  	}
				  	String issignview = WFManager.getIssignview();
				  	allsubrequestid = WFSubDataAggregation.getAllSubRequestIds(desrequestid_temp);
				  if("1".equals(issignview)){
				  	RecordSetLog.executeSql("select  a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid_temp+"  and  a.userid=b.userid) and userid="+userid+" order by receivedate desc ,receivetime desc");
				  	if(RecordSetLog.next()){
				  	viewNodeId = RecordSetLog.getString("nodeid");
				  	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
				  	if(RecordSetLog1.next()){
				  	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
				  	}
				  	if("-1".equals(singleViewLogIds)){//全部查看
				  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid_temp+"))");
				  	while(RecordSetLog2.next()){
				  	tempNodeId = RecordSetLog2.getString("nodeid");
				  	if(!canViewIds.contains(tempNodeId)){
				  	canViewIds.add(tempNodeId);
				  	}
				  	}
				  	}
				  	else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
				  	
				  	}
				  	else{//查看部分
				  	String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
				  	for(int i=0;i<tempidstrs.length;i++){
				  	if(!canViewIds.contains(tempidstrs[i])){
				  	canViewIds.add(tempidstrs[i]);
				  	}
				  	}
				  	}
				  	}
				  	
				  }else{
				  	RecordSetLog.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid_temp+"  and  a.userid=b.userid)");
				  	while(RecordSetLog.next()){
				  	viewNodeId = RecordSetLog.getString("nodeid");
				  	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
				  	if(RecordSetLog1.next()){
				  	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
				  	}
				  	
				  	if("-1".equals(singleViewLogIds)){//全部查看
				  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid_temp+"))");
				  	while(RecordSetLog2.next()){
				  	tempNodeId = RecordSetLog2.getString("nodeid");
				  	if(!canViewIds.contains(tempNodeId)){
				  	canViewIds.add(tempNodeId);
				  	}
				  	}
				  	}
				  	else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
				  	
				  	}
				  	else{//查看部分
				  	String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
				  	for(int i=0;i<tempidstrs.length;i++){
				  	if(!canViewIds.contains(tempidstrs[i])){
				  	canViewIds.add(tempidstrs[i]);
				  	}
				  	}
				  	}
				  	}
					//////子流程数据汇总，主流程查看汇总数据中相关请求签字意见权限
					if(!"".equals(allsubrequestid)){
					  	RecordSetLog.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid in("+allsubrequestid+")  and  a.userid=b.userid)");
					  	while(RecordSetLog.next()){
						  	viewNodeId = RecordSetLog.getString("nodeid");
						  	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
						  	if(RecordSetLog1.next()){
						  		singleViewLogIds = RecordSetLog1.getString("viewnodeids");
						  	}
						  	
						  	if("-1".equals(singleViewLogIds)){//全部查看
							  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid in("+allsubrequestid+")))");
							  	while(RecordSetLog2.next()){
								  	tempNodeId = RecordSetLog2.getString("nodeid");
								  	if(!canViewIds.contains(tempNodeId)){
								  		canViewIds.add(tempNodeId);
								  	}
							  	}
						  	}
						  	else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
						  	
						  	}
						  	else{//查看部分
							  	String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
							  	for(int i=0;i<tempidstrs.length;i++){
								  	if(!canViewIds.contains(tempidstrs[i])){
								  		canViewIds.add(tempidstrs[i]);
							  		}
						  		}
						  	}
					  	}
					}
					//////end
				  }
				  	
				  }
				  if(isurger_temp.trim().equals("true")||wfmonitor_temp.trim().equals("true")||intervenorright_temp>0){
					  //RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid);
					  RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
					  while(RecordSetLog2.next()){
					  tempNodeId = RecordSetLog2.getString("nodeid");
					  if(!canViewIds.contains(tempNodeId)){
					  canViewIds.add(tempNodeId);
					  }
					  }    
				  }
				  
					//添加流程共享查看签字意见权限
					String iswfshare1 = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"iswfshare"));
					if("1".equals(iswfshare1) && canViewIds.size() == 0){
						String userids = "";
						userids = wfShareAuthorization.getSignByrstUser(String.valueOf(requestid),user);
						
						//流程共享的签字意见查看权限与共享人权限一致
						if(!"".equals(userids)){
							RecordSetLog2.executeSql("select workflowid from workflow_requestbase where requestid = "+requestid);
							if(RecordSetLog2.next()){
								WFManager.setWfid(RecordSetLog2.getInt("workflowid"));
								WFManager.getWfInfo();
							}
							String issignview = WFManager.getIssignview();
							if("1".equals(issignview)){
								//RecordSetLog.executeSql("select  a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('0','2','4') and b.requestid="+requestid+"  and  a.userid=b.userid) and userid in ("+userids+") order by receivedate desc ,receivetime desc");
								String currentsql = "SELECT c.id ,b.requestid  FROM workflow_currentoperator c,workflow_requestbase b WHERE c.requestid=b.requestid and c.nodeid=b.currentnodeid and b.requestid="+requestid+"  AND c.islasttimes = 1 order by receivedate desc ,receivetime desc";
								RecordSetLog.executeSql(currentsql);
								if(RecordSetLog.next()){
									viewNodeId = RecordSetLog.getString("nodeid");
									RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
									if(RecordSetLog1.next()){
										singleViewLogIds = RecordSetLog1.getString("viewnodeids");
										}
									if("-1".equals(singleViewLogIds)){//全部查看
										RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
										while(RecordSetLog2.next()){
											tempNodeId = RecordSetLog2.getString("nodeid");
											if(!canViewIds.contains(tempNodeId)){
												canViewIds.add(tempNodeId);
												}
										}
									}else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
						  	
									}else{//查看部分
										String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
										for(int i=0;i<tempidstrs.length;i++){
											if(!canViewIds.contains(tempidstrs[i])){
												canViewIds.add(tempidstrs[i]);
												}
											}
										}
									}
								}else{
									//RecordSetLog.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('0','2','4') and b.requestid="+requestid+"  and  a.userid=b.userid) and userid in ("+userids+") ");
									String currentsql = "SELECT c.id ,b.requestid  FROM workflow_currentoperator c,workflow_requestbase b WHERE c.requestid=b.requestid and c.nodeid=b.currentnodeid and b.requestid="+requestid+"  AND c.islasttimes = 1";
									RecordSetLog.executeSql(currentsql);
									while(RecordSetLog.next()){
										viewNodeId = RecordSetLog.getString("nodeid");
										RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
										if(RecordSetLog1.next()){
											singleViewLogIds = RecordSetLog1.getString("viewnodeids");
										}
						  	
										if("-1".equals(singleViewLogIds)){//全部查看
											RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
											while(RecordSetLog2.next()){
												tempNodeId = RecordSetLog2.getString("nodeid");
												if(!canViewIds.contains(tempNodeId)){
													canViewIds.add(tempNodeId);
												}
											}
										}else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
										
										}else{//查看部分
											String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
											for(int i=0;i<tempidstrs.length;i++){
												if(!canViewIds.contains(tempidstrs[i])){
													canViewIds.add(tempidstrs[i]);
												}
											}
										}
									}
								}
							/////////////////////////////////
						}
						//流程共享打开相关流程的签字意见查看权限
						if(desrequestid_temp!=0){

						  	RecordSetLog2.executeSql("select workflowid from workflow_requestbase where requestid = "+desrequestid_temp);
						  	if(RecordSetLog2.next()){
						  		WFManager.setWfid(RecordSetLog2.getInt("workflowid"));
						  		WFManager.getWfInfo();
						  	}
						  	String issignview = WFManager.getIssignview();
						  if("1".equals(issignview)){
						  	//RecordSetLog.executeSql("select  a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('0','2','4') and b.requestid="+desrequestid_temp+"  and  a.userid=b.userid) and userid in ("+userids+") order by receivedate desc ,receivetime desc");
						  	String currentsql = "SELECT c.id ,b.requestid  FROM workflow_currentoperator c,workflow_requestbase b WHERE c.requestid=b.requestid and c.nodeid=b.currentnodeid and b.requestid="+desrequestid_temp+"  AND c.islasttimes = 1 order by receivedate desc ,receivetime desc";
							RecordSetLog.executeSql(currentsql);
						  	if(RecordSetLog.next()){
						  	viewNodeId = RecordSetLog.getString("nodeid");
						  	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
						  	if(RecordSetLog1.next()){
						  	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
						  	}
						  	if("-1".equals(singleViewLogIds)){//全部查看
						  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid_temp+"))");
						  	while(RecordSetLog2.next()){
						  	tempNodeId = RecordSetLog2.getString("nodeid");
						  	if(!canViewIds.contains(tempNodeId)){
						  	canViewIds.add(tempNodeId);
						  	}
						  	}
						  	}
						  	else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
						  	
						  	}
						  	else{//查看部分
						  	String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
						  	for(int i=0;i<tempidstrs.length;i++){
						  	if(!canViewIds.contains(tempidstrs[i])){
						  	canViewIds.add(tempidstrs[i]);
						  	}
						  	}
						  	}
						  	}
						  }else{
						  	//RecordSetLog.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('0','2','4') and b.requestid="+desrequestid_temp+"  and  a.userid=b.userid) and userid in ("+userids+")");
						  	String currentsql = "SELECT c.id ,b.requestid  FROM workflow_currentoperator c,workflow_requestbase b WHERE c.requestid=b.requestid and c.nodeid=b.currentnodeid and b.requestid="+desrequestid_temp+"  AND c.islasttimes = 1";
							RecordSetLog.executeSql(currentsql);
						  	while(RecordSetLog.next()){
						  	viewNodeId = RecordSetLog.getString("nodeid");
						  	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
						  	if(RecordSetLog1.next()){
						  	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
						  	}
						  	
						  	if("-1".equals(singleViewLogIds)){//全部查看
						  	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid_temp+"))");
						  	while(RecordSetLog2.next()){
						  	tempNodeId = RecordSetLog2.getString("nodeid");
						  	if(!canViewIds.contains(tempNodeId)){
						  	canViewIds.add(tempNodeId);
						  	}
						  	}
						  	}
						  	else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
						  	
						  	}
						  	else{//查看部分
						  	String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
						  	for(int i=0;i<tempidstrs.length;i++){
						  	if(!canViewIds.contains(tempidstrs[i])){
						  	canViewIds.add(tempidstrs[i]);
						  	}
						  	}
						  	}
						  	}
						  }
						}
						//System.out.println("can@#$$$$$$$$$$$$$$$$");
					}
					//流程共享查看签字意见end
				  if(canViewIds.size()>0){
					  for(int a=0;a<canViewIds.size();a++)
					  {
					  viewLogIds += (String)canViewIds.get(a) + ",";
					  }
					  viewLogIds = viewLogIds.substring(0,viewLogIds.length());
				  }
				  else{
				      viewLogIds = "-1";
				  }
				    
				    String sqlTemp = "select nodeid from workflow_flownode where workflowid = " + workflowid + " and nodetype = '0'";
				    RecordSet.executeSql(sqlTemp);
				    RecordSet.next();
				    String creatorNodeId = RecordSet.getString("nodeid");
				    /*----added by xwj for td2891 end-----*/
				    /*----added by chujun for td8883 start ----*/
				    WFManager.setWfid(workflowid);
				    WFManager.getWfInfo();
				    String orderbytype = Util.null2String(WFManager.getOrderbytype());
				    String orderby = "desc";
				    String imgline = "<img src=\"/images/xp/L_wev8.png\">";
				    if ("2".equals(orderbytype)) {
				        orderby = "asc";
				        imgline = "<img src=\"/images/xp/L1_wev8.png\">";
				    }
				    WFLinkInfo.setRequest(request);
				    ArrayList log_loglist = new ArrayList();

				    String lineNTdOne = "";
				    String lineNTdTwo = "";
				    int log_branchenodeid = 0;
				    String log_tempvalue = "";
				    
				    //-----------------------------------
				    // 预留流程签字意见每次加载条数 START
				    //-----------------------------------
				    RecordSet.executeSql("select pageSize from ecology_pagesize where pageId = 'SIGNVIEW_VIEWID' and userid="+user.getUID());
				    int wfsignlddtcnt = 10;
				    if(RecordSet.next()){
				    	wfsignlddtcnt = RecordSet.getInt("pageSize");
				    }
				    
				    if ("true".equals(_isPrint) || "1".equals(isworkflowhtmldoc)) {
				        wfsignlddtcnt = Integer.MAX_VALUE;
				    }
				    //-----------------------------------
				    // 预留流程签字意见每次加载条数 END
				    //-----------------------------------

				%>
				<%
				    requestid = initrequestid;
				%>
<%
//获取头像显示信息
   String txStatus = "1";//默认显示头像
   RecordSet.executeSql("select status from WorkflowSignTXStatus where userid="+userid);
   if(RecordSet.next()){
	   txStatus = RecordSet.getString("status");
   }
   
   int totalCount = 0;
   
   int currentPageCount = wfsignlddtcnt;//每页展示条数
   int totalPages = (totalCount + currentPageCount - 1)
           / currentPageCount;//总共页数
   if (totalPages <= 0) {
       totalPages = 1;
   }
   int currentPageSize = 1;//当前页码
   
   //获取at流转意见的总信息条数
   int atcount = 0;//WFLinkInfo.getRequestLogTotalCount(requestid, workflowid, viewLogIds, " and t1.logid in (" + logids + ")");
   
   int attotalPages = (atcount + currentPageCount - 1) / currentPageCount;//总共页数
   if (attotalPages <= 0) {
       attotalPages = 1;
   }
%>



<script type="text/javascript">
jQuery(".moreBtn_option").hover(function(){
	jQuery(this).addClass("moreBtn_optionSelect");
},function(){
	jQuery(this).removeClass("moreBtn_optionSelect");
});
var signallPages = <%=totalPages %>;
var signallitems = <%=totalCount %>;
function signtabchanges(tabindex, tar){
	closeAllRelatedRequestDiv();
    if(tabindex==0){
 		signallPages = <%=totalPages %>;
 		signallitems = <%=totalCount %>;
        jQuery($GetEle("signall")).css("display", "");
		jQuery("#advancedSearch").css("display","");
		//与我相关
		jQuery("input[name='yuwoxiangguan']").val("");
		//搜索条件
		jQuery("input[name='caozuozhe']").val(jQuery("#searchOphrmid").val());//操作者
		jQuery("input[name='bumen']").val(jQuery("#searchOwnerdepartmentid").val());//部门
		jQuery("input[name='fenbu']").val(jQuery("#searchCreatersubcompanyid").val());//分部
		jQuery("input[name='yijian']").val(jQuery("input[name='searchContent']").val());//意见
		jQuery("input[name='jiedian']").val(jQuery("#searchNodename").val());//节点名称
		jQuery("input[name='caozuoriqi']").val(jQuery("#searchDoccreatedateselect").val());//操作日期
		jQuery("input[name='kaishishijian']").val(jQuery("input[name='searchRecievedatefrom']").val());	
		jQuery("input[name='jieshushijian']").val(jQuery("input[name='searchRecievedateto']").val());
		
		jQuery($GetEle("signid")).html("");
		jQuery(".signblockbarULclass li").removeClass("current");
		jQuery("#oTDtype_0").addClass("current");
		
		currentTabIndex = 0;
    	toggertab(currentTabIndex);
    } else if(tabindex==1 || tabindex==2){
   		signallitems = 0;
   		signallPages = 1;
		jQuery($GetEle("signall")).css("display", "");
		jQuery("#advancedSearch").css("display","none");
		jQuery("#adserch").css("display","none");
		//与我相关
		if(tabindex==1){
			jQuery("input[name='yuwoxiangguan']").val(<%=user.getUID()%>);
		}else{
			jQuery("input[name='yuwoxiangguan']").val("");
		}
		//搜索条件
		jQuery("input[name='caozuozhe']").val("");//操作者
		jQuery("input[name='bumen']").val("");//部门
		jQuery("input[name='fenbu']").val("");//分部
		jQuery("input[name='yijian']").val("");//意见
		jQuery("input[name='jiedian']").val("");//节点名称
		jQuery("input[name='caozuoriqi']").val("");//操作日期
		jQuery("input[name='kaishishijian']").val("");	
		jQuery("input[name='jieshushijian']").val("");
	
		jQuery($GetEle("signid")).html("");
		
		jQuery(".signblockbarULclass li").removeClass("current");
		jQuery("#oTDtype_" + tabindex).addClass("current");
		
		currentTabIndex = tabindex;
    	toggertab(currentTabIndex);
	} else if(tabindex==3 || tabindex==4){
		jQuery("#relwfsltblock_" + tabindex).css("left", (jQuery("#oTDtype_" + tabindex).offset().left - 5) + "px");
		jQuery("#relwfsltblock_" + tabindex).show();
		currentTabIndex = tabindex;
    	toggertab(currentTabIndex);
	}
}


//与我相关的记录条数
var pgnumber = 2;
var sucNm = true;

var requestLogDataMaxRquestLogId = 0;
//滚动加载参数START
var isScrollLoad = <%=signListType%>;
var scrollPage = 0;
//滚动加载参数END
<%if(!("true".equals(_isPrint) || "1".equals(isworkflowhtmldoc))){%>
	if(isScrollLoad == true){
		wfsignlddtcnt = 14;
	}
<%}%>
//判断相关子流程是否已经加载过子流程标题，否则，如果子流程意见过多，再次加载时，会在下面继续生成标题
var isRelwfTitleIsLoad = false;
function resetScrollLoadParam(){
   <%if(!("true".equals(_isPrint) || "1".equals(isworkflowhtmldoc))){%>
	scrollPage = 0;
   <%}%>
}
var ___synflag = true;


function unbindScrollEve(){
	if(isScrollLoad == true){
	   	jQuery(window).unbind("scroll",autoScrollSign);
	}
}
function bindScrollEve(){
	if(isScrollLoad == true){
	   	jQuery(window).bind("scroll",autoScrollSign);
	}
}
//高级搜索提交
function search() {
	scrollPage = 1;
	signallPages = 0;
	signallitems = 0;
	try {
		_onChange();
	} catch (e) {}
	
	jQuery("input[name='caozuozhe']").val(jQuery("#searchOphrmid").val()); //操作者
	jQuery("input[name='bumen']").val(jQuery("#searchOwnerdepartmentid").val()); //部门
	jQuery("input[name='fenbu']").val(jQuery("#searchCreatersubcompanyid").val()); //分部
	jQuery("input[name='yijian']").val(jQuery("input[name='searchContent']").val()); //意见
	jQuery("input[name='jiedian']").val(jQuery("#searchNodename").val()); //节点名称
	jQuery("input[name='caozuoriqi']").val(jQuery("#searchDoccreatedateselect").val()); //操作日期
	jQuery("input[name='kaishishijian']").val(jQuery("input[name='searchRecievedatefrom']").val());
	jQuery("input[name='jieshushijian']").val(jQuery("input[name='searchRecievedateto']").val());
	var prePage = 1;
	requestLogDataMaxRquestLogId = 0;
	//(清楚已经存在的签字意见的iframe,防止切换tab页以后，frameId相同，导致根据id调整签字意见高度时，找不到当前页的签字意见)
	for (var i=0; i<5; i++) {
		var currentsignBlockid = "#signid_" + i;
		jQuery(currentsignBlockid).html("");
	}
	jQuery("div[id^=signid_]").each(function(){
	  jQuery(this).find("iframe").remove();
	});
	showAllSignLog3('<%=workflowid%>', '<%=requestid%>', '<%=viewLogIds%>', '<%=orderby%>', prePage, "signTbl", "requestLogDataIsEnd<%=requestid%>", "WorkFlowLoddingDiv_<%=requestid%>", requestLogDataMaxRquestLogId);

}

function resetSearch() {
	
	if(jQuery(".e8_pageinfo")){
		jQuery(".e8_pageinfo").css("display","none");
	}
	jQuery("#searchOphrmid").val(""); //操作者
	jQuery("#searchOwnerdepartmentid").val(""); //部门
	jQuery("#searchCreatersubcompanyid").val(""); //分部
	jQuery("input[name='searchContent']").val(""); //意见
	jQuery("#searchNodename").val(""); //节点名称
	jQuery("#searchDoccreatedateselect").val(""); //操作日期
	jQuery("input[name='searchRecievedatefrom']").val("");
	jQuery("input[name='searchRecievedateto']").val("");
	
	jQuery("#searchDoccreatedateselect").val("0");
	//alert(jQuery(jQuery("#searchDoccreatedateselect option").get(0)).text());
	jQuery("#searchDoccreatedateselect").next("span").find("a[class=sbSelector]").html(jQuery(jQuery("#searchDoccreatedateselect option").get(0)).text());
	jQuery("#searchNodename").next("span").find("a[class=sbSelector]").html(jQuery(jQuery("#searchNodename option").get(0)).text());
	
	jQuery("#searchOphrmidspan").html(""); //操作者
	jQuery("#searchOwnerdepartmentidspan").html(""); //部门
	jQuery("#searchCreatersubcompanyidspan").html(""); //分部
	
	//搜索条件
	jQuery("input[name='caozuozhe']").val("");//操作者
	jQuery("input[name='bumen']").val("");//部门
	jQuery("input[name='fenbu']").val("");//分部
	jQuery("input[name='yijian']").val("");//意见
	jQuery("input[name='jiedian']").val("");//节点名称
	jQuery("input[name='caozuoriqi']").val("");//操作日期
	jQuery("input[name='kaishishijian']").val("");	
	jQuery("input[name='jieshushijian']").val("");
	jQuery("#searchRecievedatefromspan").html("");
	jQuery("#searchRecievedatetospan").html("");
	jQuery("#searchRecievedate").css("display","none");
}

function flipOver(sign, topage) {
	try {
		_onChange();
	} catch (e) {}
	if (!___synflag && isScrollLoad) {
		return ;
	}
	var currentpageInfoBlockid = "#searchInfo_" + currentTabIndex + " ";
	var prePage = jQuery(currentpageInfoBlockid + "#prePage").val();
	var allPages = jQuery(currentpageInfoBlockid + "#allPages").val();
	if (sign == -1) {
		//初始加载
		prePage = 1;
		if(isScrollLoad){
			scrollPage ++;
			prePage = scrollPage;
		}	

		if(prePage > allPages)
			return;
	
		requestLogDataMaxRquestLogId = 0;
		if(currentTabIndex == 3 || currentTabIndex == 4){
			signallitems = 0;
		}
		initPaperChange(1);
	} else if (sign == 0) {
		//首页
		if (prePage <= 1) {
			return;
		} else {
			prePage = 1;
			requestLogDataMaxRquestLogId = 0;
		}
		initPaperChange(prePage);
	} else if (sign == 1) {
		//上一页
		if (prePage <= 1) {
			return;
		} else {
			prePage--;
			requestLogDataMaxRquestLogId = jQuery(currentpageInfoBlockid + "#pageMaxRquestLogId").val();
		}
		initPaperChange(prePage);
	} else if (sign == 2) {
		//下一页
		if (prePage >= allPages || allPages <= 1) {
			return;
		} else {
			prePage++;
			jQuery(currentpageInfoBlockid + "#pageMaxRquestLogId").val(requestLogDataMaxRquestLogId);
		}
		initPaperChange(prePage);
	} else if (sign == 3) {
		//尾页
		if (prePage >= allPages || allPages <= 1) {
			return;
		} else {
			prePage = allPages;
		}
		initPaperChange(prePage);
	} else if (sign == 4) {
		//跳转
		var page = topage;
		if (page == "" || page.length == 0) {
			return;
		} else if (isNaN(page)) {
			return;
		} else if (page < 0 || page > allPages) {
			return;
		} else {
			prePage = page;
		}
		initPaperChange(topage);
	}
	if (currentTabIndex != 1) {
		var tempwfid = jQuery("#searchInfo_" + currentTabIndex + " #sign_relwfid").val();
		var tempreqid = jQuery("#searchInfo_" + currentTabIndex + " #sign_relreqid").val();
		var tempviewlogs = jQuery("#searchInfo_" + currentTabIndex + " #sign_relviewlogs").val();
		var loadbyuser = jQuery("#searchInfo_" + currentTabIndex + " #loadbyuser").val();
//		alert(tempwfid + ", " + tempreqid + ", " + tempviewlogs);
		showAllSignLog3(tempwfid, tempreqid, tempviewlogs, '<%=orderby%>', prePage, "signTbl", "requestLogDataIsEnd<%=requestid%>", "WorkFlowLoddingDiv_<%=requestid%>", '', loadbyuser);
	} else {
		showAllSignLog3('<%=workflowid%>', '<%=requestid%>', '<%=viewLogIds%>', '<%=orderby%>', prePage, "signTbl", "requestLogDataIsEnd<%=requestid%>", "WorkFlowLoddingDiv_<%=requestid%>");
	}
}

function initPaperChange(topage, totalPages2, totalCount2) {
	try {
		_onChange();
	} catch (e) {}
	
	<%
	if ("true".equals(_isPrint) || "1".equals(isworkflowhtmldoc)) {
	%>
	if (true) {
		return ;
	}
	<%
	}
	%>
	
	var totalPage = signallPages;
	var totalRecords = signallitems;
	var pageNo = <%=currentPageSize%>;
	if (!!totalPages2) {
		totalPage = totalPages2;
	}
	if (!!totalCount2) {
		totalRecords = totalCount2;
	}
	if (topage) pageNo = topage;

	if (!pageNo) {
		pageNo = 1;
	}
	//生成分页控件
	kkpager.init({
		isGoPage:true,
		pagerid: 'div_pager_' + currentTabIndex,
		pagesize:"" + wfsignlddtcnt,
		pno: pageNo,
		//总页码
		total: totalPage,
		//总数据条数
		totalRecords: totalRecords,
		//链接前部
		hrefFormer: 'pager_test',
		//链接尾部
		hrefLatter: '.html',
		getLink: function(n) {
			return this.hrefFormer + this.hrefLatter + "?pno=" + n;
		}
	});
	kkpager.generPageHtml();
	if(isScrollLoad){
		jQuery("[id^=pagesplitblock]").hide();
	}
}



var hasHead = false;

var forward = <%=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0) %>;
var submit = <%=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0) %>;

function toggleImg(obj){
				var _obj =jQuery(obj);
				jQuery(".userheadimg").toggle();
				var img = _obj.find("span:eq(0)").attr("img");
				var ajax = ajaxinit();
				ajax.open("POST", "/workflow/request/WorkflowSignStatusAjax.jsp", true);
				ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				if(img != "show"){
					ajax.send("txstatus=1");
					jQuery("#txstatus").val("1");
					ajax.onreadystatechange=function(){
						if (ajax.readyState == 4 && ajax.status == 200) {
						     jQuery("#userTip").attr("title","<%=SystemEnv.getHtmlLabelName(81564, user.getLanguage())%>");
							 _obj.find("span:eq(0)").removeClass("hideHuser");
							 _obj.find("span:eq(0)").addClass("showHuser");
							 _obj.find("span:eq(0)").attr("img","show");
						}
					}
				}else{
					ajax.send("txstatus=0");
					jQuery("#txstatus").val("0");
					ajax.onreadystatechange=function(){
						if (ajax.readyState == 4 && ajax.status == 200) {
							  jQuery("#userTip").attr("title","<%=SystemEnv.getHtmlLabelName(81563, user.getLanguage())%>");
							 _obj.find("span:eq(0)").removeClass("showHuser");
							 _obj.find("span:eq(0)").addClass("hideHuser");
							 _obj.find("span:eq(0)").attr("img","hide");
						}
					}
				}
			}
function showAllSignLog3(workflowid, requestid, viewLogIds, orderby, pageNumber, targetEle, requestLogDataIsEnd, WorkFlowLoddingDiv, maxRequestLogId, loadbyuser) {
	if (loadbyuser == null) {
		loadbyuser = false;
	}
	if (!___synflag && isScrollLoad) {
		return ;
	}
	if (isScrollLoad) {
		if (pageNumber > 1) {
			//maxRequestLogId = jQuery("#maxrequestlogid" + pageNumber).val();
			maxRequestLogId = jQuery("input[name='maxrequestlogid" + (pageNumber-1) + "']").val();
			
		} else {
			maxRequestLogId = 0;
		}
	} else {
		maxRequestLogId = -1;
	}
	
	___synflag = false;
	unbindScrollEve();
	
	try {
		_onChange();
	} catch (e) {}
	
	var currentsignBlockid = "#signid_" + currentTabIndex;
	var currentpageInfoBlockid = "#searchInfo_" + currentTabIndex + " ";
	
    //var scrollLoadingDiv = "<div id='scrollLoddingDiv' style='position:absolute;bottom:20px;text-align: center; width: 100%; height: 18px; overflow: hidden;'><img src='/images/loading2_wev8.gif' style='vertical-align: middle;'> &nbsp; <span style='vertical-align: middle;line-height: 100%;'><%=SystemEnv.getHtmlLabelName(81558, user.getLanguage())%></span></div>";
    var scrollLoadingDiv = "<div id='scrollLoddingDiv' style='text-align: center; width: 100%; height: 38px; line-height:38px;overflow: hidden;'><img src='/images/loading2_wev8.gif' style='vertical-align: middle;'> &nbsp; <span style='vertical-align: middle;line-height: 100%;'><%=SystemEnv.getHtmlLabelName(81558, user.getLanguage())%></span></div>";
    
	var relwfrequestname = jQuery("#relwfrequestname_" + requestid).html();
	if (isScrollLoad){
		if(relwfrequestname&&!isRelwfTitleIsLoad){
			relwfrequestname = "<div class=\"relwfrequestnameclass\" style=\"background:#fff !important;\">" + relwfrequestname + "</div>";
			jQuery(currentsignBlockid).append(relwfrequestname);
		}else{
			jQuery(currentsignBlockid).append('');
		}
	}else{
		if(relwfrequestname){
			relwfrequestname = "<div class=\"relwfrequestnameclass\" style=\"background:#fff !important;\">" + relwfrequestname + "</div>";
			jQuery(currentsignBlockid).html(relwfrequestname);
		}else{
			jQuery(currentsignBlockid).html('');
		}
	}
	//获取搜索数据
	var operatorid = encodeURI(encodeURI(jQuery("input[name='caozuozhe']").val())); //操作者
	var deptid = encodeURI(encodeURI(jQuery("input[name='bumen']").val())); //部门
	var subcomid = encodeURI(encodeURI(jQuery("input[name='fenbu']").val())); //分部
	var content = encodeURI(encodeURI(jQuery("input[name='yijian']").val())); //意见
	var nodename = encodeURI(encodeURI(jQuery("#searchNodename").val())); //节点名称
	nodename = jQuery("input[name='jiedian']").val();
	var createdateselect = encodeURI(encodeURI(jQuery("input[name='caozuoriqi']").val())); //操作日期
	var createdatefrom = encodeURI(encodeURI(jQuery("input[name='kaishishijian']").val()));
	var createdateto = encodeURI(encodeURI(jQuery("input[name='jieshushijian']").val()));
	var atmet = encodeURI(encodeURI(jQuery("input[name='yuwoxiangguan']").val())); //与我相关
	var txstatus = jQuery("#txstatus").val();
	var saslrtn = 0;
	//jQuery("#" + WorkFlowLoddingDiv).show();
	var crurrentPageNumber = pageNumber;
	var ajax = ajaxinit();
	ajax.open("POST", "/workflow/request/WorkflowViewSignMore.jsp", true);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send("isFormSignature="+"<%=tempIsFormSignature%>"+"&workflowid=" + workflowid + "&requestid=" + requestid + "&languageid=<%=user.getLanguage()%>&desrequestid=<%=desrequestid_temp%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=0&userid=<%=userid%>&isprint=<%=_isPrint %>&isOldWf=<%=isOldWf%>&viewLogIds=" + viewLogIds + "&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby=" + orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=" + wfsignlddtcnt + "&forward=" + forward + "&submit=" + submit + "&operatorid=" + operatorid + "&deptid=" + deptid + "&subcomid=" + subcomid + "&content=" + content + "&nodename=" + nodename + "&createdateselect=" + createdateselect + "&createdatefrom=" + createdatefrom + "&createdateto=" + createdateto + "&atmet=" + atmet+"&txstatus="+txstatus+"&loadbyuser="+loadbyuser+"&isHideInput=<%=thisHideInputTemp%>&urger=<%=urger%>&isintervenor=<%=isintervenor%>");
	if(isScrollLoad){
		jQuery("#signall").append(scrollLoadingDiv);
	}else{
		jQuery("#signall").append(scrollLoadingDiv);
	}
	//获取执行状态
	ajax.onreadystatechange = function() {
		//如果执行状态成功，那么就把返回信息写到指定的层里
		if (ajax.readyState == 4 && ajax.status == 200) {
			try {
				var $targetEle = jQuery("#" + targetEle);
				saslrtn = ajax.responseText.replace(/(^\s*)|(\s*$)/g, "").indexOf("<requestlognodata>");
				if (saslrtn == -1) {
					//var headStr = "";
					//if (!hasHead) {
					//	headStr = jQuery("#headTitle").html();
					//	if (headStr == null) headStr = "";
					//	hasHead = true;
					//}
					//var tableStr = "<table class='liststyle liststyle1' cellspacing=0 style=\"margin:0;width:100%;\">" + "<colgroup>" + "<col width='10%'><col width='50%'> <col width='10%'>  <col width='30%'>" + "</colgroup>" + headStr + jQuery.trim(ajax.responseText) + "</table>";
					var tableStr = jQuery.trim(ajax.responseText);
					//jQuery("#requestlogappednDiv").append(tableStr);
					var relwfrequestname = jQuery("#relwfrequestname_" + requestid).html();
					if (isScrollLoad){
						if (relwfrequestname) {
							isRelwfTitleIsLoad = true;
							jQuery(currentsignBlockid).append(tableStr);
						} else {
							jQuery(currentsignBlockid).append(tableStr);
						}
					}else{
						if (relwfrequestname) {
							relwfrequestname = "<div class=\"relwfrequestnameclass\" style=\"background:#fff !important;\">" + relwfrequestname + "</div>";
							jQuery(currentsignBlockid).html(relwfrequestname + tableStr);
						} else {
							jQuery(currentsignBlockid).html(tableStr);
						}
					}
					
					//jQuery(currentsignBlockid).append(tableStr);
					
					jQuery(currentsignBlockid + "#requestlogappednDiv table tbody tr:first").addClass("HeaderForXtalbe");
					jQuery("#mainWFHead").css("display", "none");
					sucNm = true;
					//liuzy 将查询后的个数、页数赋值
					var allPages = jQuery(currentsignBlockid).find("[name='allPages"+crurrentPageNumber+"']").val();
					signallPages = allPages;
					var allItems = jQuery(currentsignBlockid).find("[name='allItems"+crurrentPageNumber+"']").val();
					signallitems = allItems;
					jQuery(currentpageInfoBlockid + "#allPages").val(allPages);
					jQuery(currentpageInfoBlockid + "#allItems").val(allItems);
					jQuery(currentpageInfoBlockid + "#prePage").val(pageNumber);
                    if(isScrollLoad != true){
						initPaperChange(pageNumber, signallPages, signallitems);
					}else{
						 if(isScrollLoad){
							bindScrollEve();
						 }
					}
				} else {
					//jQuery(currentsignBlockid).html("");
					//没有结果则清除分页栏数据
					initPaperChange(1, 1, 0);
					jQuery(currentpageInfoBlockid + "#prePage").val(1);
					jQuery(currentpageInfoBlockid + ".prePage").text(1);

					jQuery(currentpageInfoBlockid + "#allItems").val(0);
					jQuery(currentpageInfoBlockid + ".allItems").text(0);

					jQuery(currentpageInfoBlockid + "#allPages").val(1);
					jQuery(currentpageInfoBlockid + ".allPages").text(1);

					jQuery("#signall").find("a[name='shouye']").removeClass("signpage");
					jQuery("#signall").find("a[name='shangyiye']").removeClass("signpage");
					jQuery("#signall").find("a[name='xiayiye']").removeClass("signpage");
					jQuery("#signall").find("a[name='weiye']").removeClass("signpage");
				}
				//requestLogDataMaxRquestLogId = jQuery("input[name='maxrequestlogid" + crurrentPageNumber + "']").val();
				jQuery("iframe[name^=FCKsigniframe]").contents().find('div.small_pic a').each(function (i,e){
					var ahref = $(e).attr("pichref");
					var dive = $(e).parent().parent().find("#"+ahref);
					$(e).fancyZoom({scaleImg: true, closeOnClick: false ,iframenames: dive});
				});
				
				jQuery("#adserch").css("display", "none");     
				___synflag = true;            
			} catch(e) {
				alert(e);
			}
			oIframe.style.display = 'none';
			//jQuery("#" + WorkFlowLoddingDiv).hide();
			jQuery("#scrollLoddingDiv").remove();
			
			<%
			if ("true".equals(_isPrint) && !"1".equals(ismultiprintmode)) {
			%>
				judgeBrowserPrint();
			<%
			}
			%>

			<%if("1".equals(ismultiprintmode)){%>
				window.setTimeout(function(){frameResize();},100);
			<%}%>
		}
	}
}


function quoteClick(obj){
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+|\n+|\r+$/g,'');
	};
	var frameId__= jQuery(obj).closest("table").parent().closest("table").find("iframe").attr("name");
	var srcHtml__ = jQuery(obj).closest("table").parent().closest("table").find("iframe").contents().find("body").html();
	/////////将引用的img过滤
	if(srcHtml__.indexOf("small_pic")>-1 || srcHtml__.indexOf("SMALL_PIC")>-1){
		var firstnum = srcHtml__.indexOf("<div");
		if(firstnum == -1){
			firstnum = srcHtml__.indexOf("<DIV");
		}
		var begin_srcHtml = srcHtml__.substring(0,firstnum);
	  	var cycle_begin = "";
		var new_srcHtml = "";
	  	var end_srcHtml = "";
	  	var divwords = "";

	  	//alert(srcHtml__);
	  	var cycleString = srcHtml__.substring(firstnum);
		while(cycleString.indexOf("<img") > -1 || cycleString.indexOf("<IMG") > -1){
			//得到div图片之间的文字
			var j = cycleString.indexOf("</div");
			if(j == -1){
		  		j =  cycleString.indexOf("</DIV");
		  	}
			var divwordstemp = cycleString.substring(j+6);
			var k = divwordstemp.indexOf("<div");
			if(k == -1){
		  		k =  divwordstemp.indexOf("<DIV");
		  	}
			divwords = divwordstemp.substring(0, k);
			begin_srcHtml += divwords;
		  	//第一个img
			var b = cycleString.indexOf("<img");
			if(b == -1){
		  		b =  cycleString.indexOf("<IMG");
		  	}
			cycleString = cycleString.substring(b);
			var e = cycleString.indexOf(">");
			cycleString = cycleString.substring(e+1);
			//第二个img
			var m = cycleString.indexOf("<img");
			if(m == -1){
		  		m =  cycleString.indexOf("<IMG");
		  	}
			cycleString = cycleString.substring(m);
			var imgString = "";
			var n = cycleString.indexOf(">");
			imgString = cycleString.substring(0, n);
			cycleString = cycleString.substring(n+1);
			imgString = imgString.replace("class=\"maxImg\"","");
			begin_srcHtml += "<p> " + imgString +"/> </p>";
			end_srcHtml = cycleString;
		}
		var r = end_srcHtml.indexOf("</div>");
		if(r == -1){
	  		r =  end_srcHtml.indexOf("</DIV>");
	  	}
		end_srcHtml = end_srcHtml.substring(r+6);
		begin_srcHtml += end_srcHtml;
		//alert(end_srcHtml);
		srcHtml__ = begin_srcHtml;
	}
	/////////
	var bodyHtml__ = jQuery(srcHtml__);
	bodyHtml__.find("a").css("text-decoration", "none");
	bodyHtml__.find("a").css("color", "#000000");
	bodyHtml__.find("td").css("border","0px");
    bodyHtml__.find("th").css("border","0px");
	bodyHtml__.css("border-collapse", "none");
	bodyHtml__.css("border", "0px");
	bodyHtml__.css("font-family", "微软雅黑");
	bodyHtml__.css("padding-left", "10px");
	bodyHtml__.css("padding-bottom","5px");
    var yy__="<%=SystemEnv.getHtmlLabelName(19422, user.getLanguage())%>";//引用
	var user__ = jQuery.trim(jQuery("#user_"+frameId__).html());//用户名
	var useragent__ = jQuery.trim(jQuery("#useragent_"+frameId__).html());//用户名
	if(!frameId__){
		user__=jQuery.trim(jQuery(obj).closest("table").parent("td").parent("tr").find("a[id^=user_]").html());
		useragent__=jQuery.trim(jQuery(obj).closest("table").parent("td").parent("tr").find("a[id^=useragent_]").html());
	}
	var department__="";
	if(!!useragent__){
		user__ = "<font color='#3F9AFF'> "+useragent__+"->"+user__+" </font>";
		department__ =jQuery(obj).closest("table").parent().closest("table").find("a:eq(2)").html();//部门
	}else{  
		user__ = "<font color='#3F9AFF'> "+user__+" </font>";
		department__ =jQuery(obj).closest("table").parent().closest("table").find("a:eq(1)").html();//部门
	}
	var time__ = jQuery(obj).closest("table").parent().prev().find("span:eq(0)").html();//时间
	var title__= yy__;
	if(!!user__){
		title__ += user__;
	}
	if(!!department__){
		title__ += department__;
	}
	if(!!time__){
		title__ += time__;
	}
	//var headHtml__ = "<span  style='text-indent:0px;padding-left:10px;color:#6b6b6b;font-family:微软雅黑;font-size:12px'>"+title__+"</span>";
	var container__ = "<span><div style='text-indent:0px;padding-left:10px;font-family:微软雅黑;border:1px solid #ddeaf6;;padding-top:10px;background:#f9fcff;'>"
						   + "    <span style='text-indent:0px;padding-left:10px;color:#6b6b6b;font-family:微软雅黑;font-size:12px'>" + title__ + "</span>"
						   + jQuery("<div></div>").append(bodyHtml__).html()
	 					   + "</div></span>";
	//container__.append(headHtml__).append(bodyHtml__);
	//content__ = jQuery("<span></span>").append(container__).html();
	
	//追加内容,不在焦点位置添加
	//content__=content__.replace(/<p><br\/><\/p>/,"").replace(/&nbsp;/,"").replace(/\:/,"");
	content__=container__.replace(/<p><br\/><\/p>/,"").replace(/&nbsp;/,"").replace(/\:/,"");
    var _editor__ =UE.getEditor('remark');
    _editor__.setContent(content__+"<br>",true);
	_editor__.focus(true);		
	_editor__.setContent("<br>",true);
	try {
		initRemark();
		autoscroll4remark();
	} catch(e) {}
	CkeditorExt.updateContent('remark');
	_editor__.focus(true);
	try {
		var remarkscrolltop = jQuery("#remark").offset().top;
		jQuery(document.body).animate({scrollTop : remarkscrolltop + "px"}, 500);
	} catch(e) {}
}


function transtoClick(obj){
	var resid = jQuery(obj).parent().find("span:eq(0)").html();
	if(!resid){
		resid = jQuery.trim(jQuery(obj).closest("table").parent().prev().find("input[name=displayid]").val());
	}
	doReview(resid);
}

initrequestid = "<%=initrequestid%>";
viewLogIds = "<%=viewLogIds%>";
//打开转发对话框
function openDialog(title, url) {
	url = url.replace(/&{2,5}/g,"&");
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(24964,user.getLanguage())%>";
	dlg.maxiumnable = true;
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}

//打开转发对话框
function openDialog2(title, url) {
	url = url.replace(/&{2,5}/g,"&");
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%>";
	dlg.maxiumnable = true;
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}

//打开转发对话框
function openDialog3(title, url) {
	url = url.replace(/&{2,5}/g,"&");
	var dlg = new window.top.Dialog(); //定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model = false;
	dlg.Width = 1060; //定义长度
	dlg.Height = 500;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(23746,user.getLanguage())%>";
	dlg.maxiumnable = true;
	dlg.show();
	//保留对话框对象
	window.dialog = dlg;
}
function showrelsign(relreqid, tabid) {
	jQuery("#searchInfo_" + tabid + " #allItems").val(jQuery("#sign_relwf_" + relreqid + " #allItems").val());
	jQuery("#searchInfo_" + tabid + " #perItem").val(jQuery("#sign_relwf_" + relreqid + " #perItem").val());
	jQuery("#searchInfo_" + tabid + " #allPages").val(jQuery("#sign_relwf_" + relreqid + " #allPages").val());
	jQuery("#searchInfo_" + tabid + " #prePage").val(jQuery("#sign_relwf_" + relreqid + " #prePage").val());
	jQuery("#searchInfo_" + tabid + " #sign_relwfid").val(jQuery("#sign_relwf_" + relreqid + " #sign_relwfid").val());
	jQuery("#searchInfo_" + tabid + " #sign_relreqid").val(jQuery("#sign_relwf_" + relreqid + " #sign_relreqid").val());
	jQuery("#searchInfo_" + tabid + " #sign_relviewlogs").val(jQuery("#sign_relwf_" + relreqid + " #sign_relviewlogs").val());
	
	
	jQuery($GetEle("signall")).css("display", "");
	jQuery("#advancedSearch").css("display","none");
	jQuery("#adserch").css("display","none");
	//与我相关
	jQuery("input[name='yuwoxiangguan']").val("");
	//搜索条件
	jQuery("input[name='caozuozhe']").val("");//操作者
	jQuery("input[name='bumen']").val("");//部门
	jQuery("input[name='fenbu']").val("");//分部
	jQuery("input[name='yijian']").val("");//意见
	jQuery("input[name='jiedian']").val("");//节点名称
	jQuery("input[name='caozuoriqi']").val("");//操作日期
	jQuery("input[name='kaishishijian']").val("");	
	jQuery("input[name='jieshushijian']").val("");
	jQuery($GetEle("signid")).html("");
	
	jQuery(".signblockbarULclass li").removeClass("current");
	jQuery("#oTDtype_" + tabid).addClass("current");
	
	currentTabIndex = tabid;
	toggertab(tabid);
	resetScrollLoadParam();
   	flipOver(-1);
   //	if (jQuery("#signid_" + tabid).children("table").length <= 0) {
	//}
	if (tabid == 3 || tabid == 4) {
		jQuery("#relwfsltblock_" + tabid).hide();
	}
}

function toggertab(tabid) {
	for (var i=0; i<5; i++) {
		if (i == tabid) {
			jQuery("#pagesplitblock_" + i).show();
			jQuery("#div_pager_" + i).show();
			jQuery("#signid_" + i).show();
		} else {
			jQuery("#pagesplitblock_" + i).hide();
			jQuery("#div_pager_" + i).hide();
			jQuery("#signid_" + i).hide();
		}
		var currentsignBlockid = "#signid_" + i;
		jQuery(currentsignBlockid).html("");
	}
	//(清楚已经存在的签字意见的iframe,防止切换tab页以后，frameId相同，导致根据id调整签字意见高度时，找不到当前页的签字意见)
	jQuery("div[id^=signid_]").each(function(){
	  jQuery(this).find("iframe").remove();
	});
	scrollPage = 0;
	resetScrollLoadParam();
	if(isScrollLoad == true){
	   	isRelwfTitleIsLoad = false;
	}
	if(tabid != "3" && tabid != "4"){
	  flipOver(-1);
	}
	//解锁
	___synflag = true;
	resetSearch();
}
 
function autoScrollSign(){
	var top =jQuery(window).scrollTop();
	var bodyheight = jQuery(document).height();
	if (bodyheight - top - jQuery(window).height()-900 <= 0){
		primaryWfLogLoadding();
	}
}
jQuery(document).ready(function(){
   jQuery(".groupHeadHide").find(".hideBlockDiv").hide();
   if (parent.window.location.href.indexOf("/workflow/request/ViewRequest.jsp") != -1) {
	   jQuery("iframe[name='delzw']").hide();
   }
});

jQuery(document).ready(function($){ 
 jQuery(".transto").css("opacity","0");
  jQuery(".quote").css("opacity","0");
});

function showquote(obj){
	jQuery(obj).attr("src","/images/sign/sign_yy_hot_wev8.png");
}
function hidequote(obj){
	jQuery(obj).attr("src","/images/sign/sign_yy_normal_wev8.png");
}
function showtransto(obj){
	jQuery(obj).attr("src","/images/sign/sign_zf_hot_wev8.png");
}
function hidetransto(obj){
	jQuery(obj).attr("src","/images/sign/sign_zf_normal_wev8.png");
}
function showquoteandtransto(obj){
	jQuery(obj).find(".transto").css("opacity","1");
    jQuery(obj).find(".quote").css("opacity","1");
}
function hidequoteandtransto(obj){
	jQuery(obj).find(".transto").css("opacity","0");
    jQuery(obj).find(".quote").css("opacity","0");
}

jQuery(".singleSignTbl,.signblockbarclass").live("click",function(){
   if(!!document.frmmain.Consult){
      if(document.frmmain.Consult.DocEmpty && document.frmmain.Consult.OpinionText == ""){
	      jQuery(".signaturebyhand").css("display","none");
	      jQuery("#remarkShadowDiv").css("display","");
	      jQuery("#signrighttool").css("display","none");
	      jQuery("#signtabtoolbar").css("display","none");
	  }
   }
});
function showBabysay(id,img,line){
	if(jQuery("#"+id).css("display")=="none"){
			jQuery("#"+id).css("max-width",(jQuery("#"+id).parent().width()-20));
			jQuery("#"+id).css("display","");
			img.src="/wui/theme/ecology8/templates/default/images/2_wev8.png";
			jQuery("#"+line+" span").click();
			jQuery("#"+line+" span").unbind("click");
	}else{
			jQuery("#"+id).css("display","none");
			img.src="/wui/theme/ecology8/templates/default/images/1_wev8.png";
	}
}
function showQuote(id,b,obj){
	if(b){
		  jQuery("."+id).css("display","");
	}else{
		  jQuery("."+id).css("display","none");
	}
}	
function thisSignForB(id,b,obj){
	var o = jQuery(obj).next();
	showQuote(id,b,o);
	if(b)
	   jQuery(obj).next().find(".singleSignTbl").trigger("mouseover");
	else
	   jQuery(obj).next().find(".singleSignTbl").trigger("mouseout");
}
function wfbtnOver(obj){
	jQuery(obj).css("color","red");
}
function wfbtnOut(obj){
	jQuery(obj).css("color","#123885");
}
function toggleUserList(obj){
    	if(jQuery(obj).attr("src")=="/images/sign/sign_zk_hot_wev8.png"){
            jQuery(obj).attr("src","/images/sign/sign_sq_hot_wev8.png");
            jQuery(obj).parent().prev("span").css("max-width", "95%");
            var _toggleimgobj = jQuery(obj).parent().prev("span").children("span");
            jQuery(obj).parent().prev("span").css("height", "auto");
            jQuery(_toggleimgobj[0]).css("display","none");
            jQuery(_toggleimgobj[1]).css("display","");
        }else{
            jQuery(obj).attr("src","/images/sign/sign_zk_hot_wev8.png");
            jQuery(obj).parent().prev("span").css("height","17px");           
            jQuery(obj).css("float", "");
            jQuery(obj).parent().prev("span").css("width", "");        
            var _toggleimgobj = jQuery(obj).parent().prev("span").children("span");
            jQuery(_toggleimgobj[0]).css("display","");
            jQuery(_toggleimgobj[1]).css("display","none");
        }
}
</script>
<%} %>


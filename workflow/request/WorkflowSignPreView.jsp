<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.request.WFCoadjutantManager" %>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="remarkRight" class="weaver.workflow.request.RequestRemarkRight" scope="page" />
<%
	int firstLoadNum = Util.getIntValue(Util.null2String(request.getParameter("firstLoadNum"),"3"));
	int everyLoadNum = Util.getIntValue(Util.null2String(request.getParameter("everyLoadNum"),"3"));
	int requestid = Util.getIntValue(request.getParameter("requestid"));
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
    user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
	RecordSet RecordSet = new RecordSet();
	RecordSet RecordSetLog = new RecordSet();
	
	int userid = user.getUID();
	int workflowid = -1;
	RecordSet.executeSql("select * from workflow_requestbase where requestid = "+ requestid);
	if(RecordSet.next()){
		workflowid = RecordSet.getInt("workflowid");
	}
	
	String viewLogIds = "";
    ArrayList canViewIds = new ArrayList();
    String viewNodeId = "-1";
    String tempNodeId = "-1";
    String singleViewLogIds = "-1";
    RecordSet.executeSql("select nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" order by receivedate desc ,receivetime desc");
    if(RecordSet.next()){
    	viewNodeId = RecordSet.getString("nodeid");
    	RecordSetLog.executeSql("select viewnodeids from workflow_flownode where workflowid="+workflowid+" and nodeid=" + viewNodeId);
        if(RecordSetLog.next()) {
            singleViewLogIds = RecordSetLog.getString("viewnodeids");
        }

        if("-1".equals(singleViewLogIds)) {		//全部查看
        	RecordSetLog.executeSql("select nodeid from workflow_flownode where workflowid="+workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
            while(RecordSetLog.next()) {
                tempNodeId = RecordSetLog.getString("nodeid");
                if(!canViewIds.contains(tempNodeId)) {
                    canViewIds.add(tempNodeId);
                }
            }
        } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {	//全部不能查看
        } else {	//查看部分
            String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
            for (int i = 0; i < tempidstrs.length; i++) {
                if(!canViewIds.contains(tempidstrs[i])) {
                    canViewIds.add(tempidstrs[i]);
                }
            }
        }
    }

    boolean canView = false ;// 是否可以查看
    RecordSet rs = new RecordSet();
	rs.executeSql("select id, requestid,isremark,nodeid,groupdetailid from workflow_currentoperator where userid="+userid+" and requestid="+requestid+" order by isremark,id");
	while(rs.next()) {
		canView=true;
		WFCoadjutantManager wfcm = new WFCoadjutantManager();
	    String isremark = Util.null2String(rs.getString("isremark")) ;
	    if(isremark.equals("7")) wfcm.getCoadjutantRights(Util.getIntValue(rs.getString("groupdetailid")));
	    if( isremark.equals("1")||isremark.equals("5") || (isremark.equals("7") && wfcm.getIsmodify().equals("1"))|| isremark.equals("9")  ) {
	    	canView=true;
	    	break;
	    }
	    if(isremark.equals("8")){
	    	canView=true;
	        break;
	    }
	}
	String logintype = user.getLogintype();
	boolean isurger = false;
	boolean wfmonitor=false;  
	if(!canView) 
		isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
	if(!canView&&!isurger) 
		wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);  
	//System.err.println("canView==="+canView+"isurger==="+isurger);
	if(isurger || wfmonitor){
		  RecordSet.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid);
		  while(RecordSet.next()){
			  tempNodeId = RecordSet.getString("nodeid");
			  if(!canViewIds.contains(tempNodeId)){
			  	canViewIds.add(tempNodeId);
			  }
		  }    
	  }
	if(canViewIds.size()>0){
		for(int a=0;a<canViewIds.size();a++){
			viewLogIds += (String)canViewIds.get(a) + ",";
		}
	 	viewLogIds = viewLogIds.substring(0,viewLogIds.length());
	}else{
	    viewLogIds = "-1";
	}
	//节点签字意见权限控制
	String sqlcondition = remarkRight.getRightCondition(requestid,workflowid,userid);
    int totalCount = WFLinkInfo.getRequestLogTotalCount(requestid, workflowid, viewLogIds, sqlcondition);
    int totalPage = (totalCount-firstLoadNum+everyLoadNum-1)/everyLoadNum+1;
%>

<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>
<script type="text/javascript">
var curPage = 1;		//异步请求加载，判断curPage值是否改变代表一次加载完成

var totalPage = 0;		//总页数，判断curPage>totalPage时，全部加载完成，"加载更多"按钮无效

jQuery(document).ready(function(){
	totalPage = jQuery("#totalPage").val();
	<%if(totalCount==0){	%>
		jQuery("#nosigndiv").show();
	<%}else{	%>
		loadSign();
	<%}	%>
});

function loadSign(){
	jQuery("#signloadingdiv").show();
	var signDiv = jQuery("#signdiv");
	var exiseSignNum = signDiv.find("table[name='signtable']").size();
	if(curPage>parseInt(totalPage))
		return;
	var requestid = jQuery("#requestid").val();
	var workflowid = jQuery("#workflowid").val();
	var viewLogIds = jQuery("#viewLogIds").val();
	var loadNum = curPage==1 ? jQuery("#firstLoadNum").val() : jQuery("#everyLoadNum").val();
	var maxrequestlogid = curPage==1 ? 0 : jQuery("[name='maxrequestlogid"+(curPage-1)+"']").val();
	jQuery.ajax({
		type: "POST",
		url: "/workflow/request/WorkflowSignPreViewData.jsp",
		data: {requestid: requestid, workflowid: workflowid, viewLogIds: viewLogIds, curPage: curPage, loadNum: loadNum, maxrequestlogid: maxrequestlogid, userid: "<%=user.getUID() %>", languageid: "<%=user.getLanguage() %>"},
		success: function(result){
			var noSign = result.replace(/(^\s*)|(\s*$)/g, "").indexOf("<requestlognodata>");
			if(noSign==-1){
				var tableStr = jQuery.trim(result);
				signDiv.append(tableStr);
			}
			curPage++;
			jQuery("#signloadingdiv").hide();
		}
	});
}

function returnTrue(o){
	return;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);
}

function wfbtnOver(obj){
	jQuery(obj).css("color","red");
}
function wfbtnOut(obj){
	jQuery(obj).css("color","#123885");
}
</script>
<div id="signloadingdiv" style="width:100%; position:absolute; top:180px; display:none;" align="center">
	<img src='/express/task/images/loading1_wev8.gif' align="absMiddle">
</div>
<div id="searchInfo">
	<input type="hidden" id="firstLoadNum" value="<%=firstLoadNum %>" />
	<input type="hidden" id="everyLoadNum" value="<%=everyLoadNum %>" />
	<input type="hidden" id="totalCount" value="<%=totalCount %>" />
	<input type="hidden" id="totalPage" value="<%=totalPage %>" />
	<input type="hidden" id="requestid" value="<%=requestid %>" />
	<input type="hidden" id="workflowid" value="<%=workflowid %>" />
	<input type="hidden" id="viewLogIds" value="<%=viewLogIds %>" />
</div>
<div id="signdiv" class="signdiv"></div>
<div id="nosigndiv" style="line-height:20em;font-size:16px;color:#4a6379;text-align:center;display:none;">
	<img src="/images/ecology8/workflow/noSignNotice_wev8.png" style="position:relative; top:4px;"/>&nbsp;
	<span><%=SystemEnv.getHtmlLabelName(22521, user.getLanguage())%></span>
</div>

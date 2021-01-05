<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String logintype = user.getLogintype();
int usertype = 0;
//String seclevel = "";
if(logintype.equals("2")){
	usertype = 1;
	//seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
}
List wfidList = new ArrayList();
List wfnameList = new ArrayList();
List wfEditList = new ArrayList();
List orderidList = new ArrayList();
String wfid = "";
String orderid = "";
String wfcrtSqlWhereMain = "";
wfcrtSqlWhereMain = shareManager.getWfShareSqlWhere(user, "t1");
//所有可创建流程集合
//String sqlmain = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhereMain ;
String sqlmain=" select distinct t1.workflowid,t2.workflowname from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id   and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);
//System.out.println("sqlmain = "+sqlmain);
while(RecordSet.next()){
  String _workflowid = RecordSet.getString("workflowid");
  String _workflowname = RecordSet.getString("workflowname");
  wfidList.add(_workflowid);
  wfnameList.add(_workflowname);
	//获取可以创建这条流程的人员集合

/*
	 userlist = wfcreateinfo.get(_workflowid);

	//第一次为空


	if (userlist == null) {
	    userlist = new ArrayList<String>();
	    wfcreateinfo.put(_workflowid, userlist);
	}
	
	//把当前那个户添加进去
	userlist.add(user.getUID() + "");*/
}

String wfname = "";
String isvalid = "";

boolean altMesFlog = true;
String checkAltMesSql = "SELECT count(1) from Workflow_RecordNavigation where userid = "+user.getUID();
RecordSet.executeSql(checkAltMesSql);
if(RecordSet.next()){
	if (RecordSet.getInt(1) > 0) {
    	altMesFlog = false;
	}
}


//////////////////////
//所有可创建流程集合
/*String wfcrtSqlWhereMain = shareManager.getWfShareSqlWhere(user, "t1");
String sqlmain = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhereMain;
RecordSet.executeSql(sqlmain);

while(RecordSet.next()){
    String _workflowid = RecordSet.getString("workflowid");
    wfidList.add(_workflowid);
}*/

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
  	<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/wf/requestshow.css">
  	<script type="text/javascript">
  		$(function () {
  			//鼠标移到图标上触发事件，显示设置和启用图标
  			$(".item .itemico img").hover(function (e) {
  				var imgobj = $(this).parent().parent().find("img");
  				$(this).attr("src", "/rdeploy/assets/img/wf/requestadd.png");
  			});
  			//只有鼠标移除整个item范围才会隐藏图标
  			$(".item").hover(null, function () {
  				var imgobj = $(this).find("img");
  				imgobj.attr("src", "/rdeploy/assets/img/wf/requesticon.png");
  			});
  			
  			$(".item .itemico img").bind("click", function () {
  				var wfid = jQuery(this).parent().parent().find("input[name=wfid]").val();
  				onNewRequest(wfid);
  			});
  			
  			jQuery("html").mousedown(function (e){ 
	       		parent.$(".hiddensearch").animate({ 
					height: 0
					}, 200,null,function() {
						parent.jQuery(".hiddensearch").hide();
				}); 
	       		parent.jQuery(".opensright").hide();
				parent.jQuery(".selectstatus").hide();
				parent.jQuery(".sbPerfectBar").hide();
  			});
  		});
  		
  		function onNewRequest(wfid){
  			jQuery.post('AddWorkflowUseCount.jsp',{wfid:wfid});
  		    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent=0&beagenter=0";
  		    var width = screen.availWidth-10 ;
  		    var height = screen.availHeight-50 ;
  		    var szFeatures = "top=0," ;
  	 	    szFeatures +="left=0," ;
  		    szFeatures +="width="+width+"," ;
  		    szFeatures +="height="+height+"," ;
  		    szFeatures +="directories=no," ;
  		    szFeatures +="status=yes,toolbar=no,location=no," ;
  		    szFeatures +="menubar=no," ;
  		    szFeatures +="scrollbars=yes," ;
  		    szFeatures +="resizable=yes" ; //channelmode
  		    window.open(redirectUrl,"",szFeatures) ;
  		}
  	</script>
  </head>
  <body>
  	
  	<div class="content">
  		<!-- item block 循环开始 -->
		<% 
		for(int z=0;z<wfidList.size();z++){ 
			int workflowid = Integer.parseInt((String) wfidList.get(z));
			String workflowname = (String) wfnameList.get(z);
  		%>
  		<div class="item">
  			<div style="width:100%;height:20px;"></div>
  			<div class="itemico" >
  				<img src="/rdeploy/assets/img/wf/requesticon.png">
  			</div>
  			<div class="itemtitle" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
  				<%=workflowname %>
  			</div>
  			<%--<input type="hidden" name="contain" value="<%=contain%>"> --%>
  			<input type="hidden" name="wfid" value="<%=workflowid%>">
  			<%--
  				<%=Util.toScreen(WorkflowComInfo.getWorkflowname(""+workflowid),user.getLanguage())%>
  			<input type="hidden" name="wfname" value="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(""+workflowid),user.getLanguage())%>">
  			<input type="hidden" name="orderid" value="<%=orderid%>"> --%>
  		</div><!-- item block -->
  		<%} %>
  	</div>

  </body>
</html>

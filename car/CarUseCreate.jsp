
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2")){
	usertype = 1;
}

ArrayList NewWorkflowTypeids = new ArrayList();
ArrayList NewWorkflowTypenames = new ArrayList();
//获取用车流程新建权限体系sql条件
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
String sql = "select distinct t2.workflowtype,t3.typename from ShareInnerWfCreate t1,workflow_base t2,workflow_type t3 where t2.workflowtype = t3.id and t1.workflowid=t2.id and (t2.formid=163 or t2.formid in (select formid from carbasic)) and t1.workflowid not in (select workflowid from carbasic where isuse=0) and t2.isbill=1 and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflowTypeids.add(RecordSet.getString("workflowtype"));
	NewWorkflowTypenames.add(RecordSet.getString("typename"));
}
//所有可创建用车流程集合
ArrayList NewWorkflowids = new ArrayList();
ArrayList NewWorkflownames = new ArrayList();
sql = "select distinct t2.id as workflowid,t2.workflowname from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and (t2.formid=163 or t2.formid in (select formid from carbasic)) and t1.workflowid not in (select workflowid from carbasic where isuse=0) and t2.isbill=1 and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflowids.add(RecordSet.getString("workflowid"));
	NewWorkflownames.add(RecordSet.getString("workflowname"));
}
if (NewWorkflowids != null && NewWorkflowids.size() == 1) {
	String workflowid = Util.null2String(NewWorkflowids.get(0));
	response.sendRedirect("/workflow/request/AddRequest.jsp?workflowid="+workflowid+"&isagent=0&beagenter=0");
}

	
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
	.e8_boxhead {
		width: 100%;
		height: 60px;
		visibility: visible; 
		opacity: 1;
		border-bottom: 1px solid #D0D0D0;
	}
	.e8_boxhead .e8_tablogo {
		float: left;
		width: 43px;
		height: 60px;
		line-height: 60px;
		background-repeat: no-repeat;
		margin-left: 6px; 
		background-position-x: 50%;
		background-position-y: 50%;
	}
	.e8_boxhead .e8_title {
		padding: 0px;
		margin: 0px;
	}
	.e8_boxhead .e8_title .new{
		font-family: 'Microsoft Yahei', Arial, sans-serif;
		font-size: 16px;
		font-weight: normal;
		line-height: 38px;
		padding-left: 2px;
	}
	.e8_boxhead .e8_title .title{
		height: 40px;
		font-family: 'Microsoft Yahei', Arial, sans-serif;
		font-size: 12px;
		font-weight: normal;
		line-height: 20px;
		color: #0D93F6;
		padding-left: 2px;
	}
	.maindiv {
		padding-top: 10px;
		font-family: 'Microsoft Yahei', Arial, sans-serif;
		font-size: 12px;
	}
	.maindiv . nousecar {
		
	}
	.maindiv .workflowtype {
		width: 60%;
		font-size: 12px;
		font-weight: bold;
		margin: 10px 0px 0px 8px;
		border-bottom: 1px solid #D0D0D0;
	}
	.maindiv .workflow {
		width: 60%;
		height: 20px;
		margin: 8px 0px 0px 8px;
		vertical-align: middle;
		border-bottom: 1px dashed #F0F0F0;
	}
	.maindiv .workflow a {
		color: #D0D0D0;
		margin-left: 15px;
	}
</style>
</head>
<body>
<div class="e8_boxhead">
<div class="e8_tablogo"><img style="vertical-align: middle;" src="/js/tabs/images/nav/mnav0_wev8.png"></div>
<div class="e8_title">
<div class="new"><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%><!-- 新建流程 --></div>
<div class="title"><%=SystemEnv.getHtmlLabelName(82288,user.getLanguage())%><!-- 用车请求 --></div>
</div>
</div>
<div class="maindiv" style="padding-bottom:45px;">
<%if (NewWorkflowids == null) {%>
	<span class="nousecar"><%=SystemEnv.getHtmlLabelName(82289,user.getLanguage())%><!-- 没有车辆流程 --></span>
<%} else {
	for (int t = 0 ; t < NewWorkflowTypeids.size() ; t++) {
		String workflowtypeid = Util.null2String(NewWorkflowTypeids.get(t));
		String workflowtypename = Util.null2String(NewWorkflowTypenames.get(t));
%>
	    <div class="workflowtype"><%=workflowtypename%></div>
<%
		sql = "select distinct t2.id as workflowid,t2.workflowname from ShareInnerWfCreate t1,workflow_base t2 where workflowtype="+workflowtypeid+" and t1.workflowid=t2.id and (t2.formid=163 or t2.formid in (select formid from carbasic)) and t1.workflowid not in (select workflowid from carbasic where isuse=0) and t2.isbill=1 and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			String workflowid = Util.null2String(RecordSet.getString("workflowid"));
			String workflowname = Util.null2String(RecordSet.getString("workflowname"));
			String url = "/workflow/request/AddRequest.jsp?workflowid="+workflowid+"&isagent=0&beagenter=0";
%>
			<div class="workflow"><img style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/><a onclick="javascript:onUrl('<%=url%>');"><%=workflowname%></a></div>
<%  	}
	} 
}%>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>
<script>
	function onUrl(url) {
		location.href = url;
	}
	function closePrtDlgARfsh() {
		parent.closeDlgARfsh();
	}
</script>
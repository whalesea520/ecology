
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>

</HEAD>
<BODY>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21737,user.getLanguage()) ;//设置:自定义右键按钮
    String needfav = "";
    String needhelp = "";
    String rulesrc = Util.null2String(request.getParameter("rulesrc"));
    String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String isnew = Util.null2String(request.getParameter("isnew"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	int ruleid = Util.getIntValue(request.getParameter("ruleid"), 0);
	String navname = "";
	String nodegroupid = "";
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("4"))
	{	//如果是出口和批次，需要根据 节点ID确定规则ID
		if (ruleid == 0) {
			//没有传递过来则从db取第一条
			RecordSet.executeSql(" select id from rule_base where rulesrc="+rulesrc +" and linkid="+linkid);
			if(RecordSet.first())
				ruleid = Util.getIntValue(RecordSet.getString("id"),0);
		}
		if(rulesrc.equals("2"))
		{
			
			RecordSet1.executeSql(" select t2.nodename,t1.workflowid from workflow_flownode t1,workflow_nodebase t2 where t1.nodeid = t2.id and t2.id="+nodeid);
			RecordSet1.first();
			navname = SystemEnv.getHtmlLabelName(81951,user.getLanguage())+" (" //批次条件设置
			+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
			+Util.null2String(RecordSet1.getString("nodename"))+")";
		}
	}else if (rulesrc.equals("3"))	//传过来等于3不等于实际等于3，再往数据库请求一次查真是的rulesrc
	{
		ruleid = Util.getIntValue(request.getParameter("ruleid"),0);
		RecordSet.executeSql(" select * from rule_base where id="+ruleid);
		if(RecordSet.first())
		{
			
			rulesrc = Util.null2String(RecordSet.getString("rulesrc"));
			if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("4"))
			{
				formid = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
				linkid = Util.null2String(RecordSet.getString("linkid"));
				if(rulesrc.equals("2"))//节点
				{
					nodegroupid = linkid;
					RecordSet1.executeSql(" select t4.nodename,t3.workflowid from workflow_nodegroup t1,workflow_groupdetail t2,workflow_flownode t3,workflow_nodebase t4 "
							 +" where t1.id = t2.groupid and t1.nodeid=t3.nodeid and t3.nodeid=t4.id "
							 +" and t2.id="+nodegroupid);
					RecordSet1.first();
					navname = SystemEnv.getHtmlLabelName(81951,user.getLanguage())+" ("//批次条件设置
							+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
							+Util.null2String(RecordSet1.getString("nodename"))+")";
				}
			}else
			{
				navname = SystemEnv.getHtmlLabelName(81952,user.getLanguage());//规则条件设置
			}
		}
	}
	
	//找出流程名称和节点名称/出口名称
	if(rulesrc.equals("1"))
	{	//出口
		RecordSet1.executeSql(" select workflowid,linkname from workflow_nodelink where id="+linkid);
		RecordSet1.first();
		navname = SystemEnv.getHtmlLabelName(18850,user.getLanguage())+" ("
				+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
				+Util.null2String(RecordSet1.getString("linkname"))+")";
	}else if(rulesrc.equals("4"))//督办
	{
		//RecordSet1.executeSql(" select workflowid from workflow_urgerdetail where id="+linkid);
		//RecordSet1.first();
		navname = SystemEnv.getHtmlLabelName(81953,user.getLanguage())+" ("+WorkflowComInfo.getWorkflowname(Util.null2String(linkid))+")";//督办条件设置
	}else if(rulesrc.equals("5"))//督办
	{
		//RecordSet1.executeSql(" select workflowid from workflow_urgerdetail where id="+linkid);
		//RecordSet1.first();
		//navname = "流程数据交换设置";//督办条件设置
		RecordSet1.executeSql("select name from  wfec_indatawfset where id="+linkid);
		RecordSet1.first();
		navname = RecordSet1.getString(1);
	}
	else if(rulesrc.equals("6"))//代理条件
	{
		navname =SystemEnv.getHtmlLabelName(18461,user.getLanguage()) +" ("+WorkflowComInfo.getWorkflowname(Util.null2String(wfid))+")";//督办条件设置
	} else if(rulesrc.equals("7") || rulesrc.equals("8")) {  //子流程触发条件
        navname =SystemEnv.getHtmlLabelName(126298,user.getLanguage()) +" ("+WorkflowComInfo.getWorkflowname(Util.null2String(wfid))+")";
    } 
	titlename = navname;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;//保存
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:onClean(),_self} " ;//清空
%>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSave();"/>
			<!-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(33881, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onMapping();"/>
			<input type="button" value="测试条件" class="e8_btn_top"  onclick="javascript:onSave1();"/> -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage()) %>" class="e8_btn_top" id="cleanBtn" onclick="javascript:onClean();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table> 
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="{'groupDisplay':'none'}"><!-- 基本信息 -->
		<wea:item attributes="{'isTableList':'true'}">
			<jsp:include page="/workflow/ruleDesign/ruleDesign.jsp">
				<jsp:param name="pagetype" value="1" />
				<jsp:param name="formid" value="<%=formid %>" />
				<jsp:param name="isbill" value="<%=isbill %>" />
				<jsp:param name="linkid" value="<%=linkid %>" />
				<jsp:param name="rulesrc" value="<%=rulesrc %>" />
				<jsp:param name="ruleid" value="<%=ruleid %>" />
				<jsp:param name="isnew" value="<%=isnew %>" />
				<jsp:param name="wfid" value="<%=wfid %>" />
 			</jsp:include>
		</wea:item>
	</wea:group>
</wea:layout>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		settitle();
	});
	function settitle()
	{
		var navname = "<%=navname%>";
		parent.setTabObjName(navname);
	}
	function closeDialog(){
		dialog.close();
	}
	
	function setRuleDesign(ruleRelationship){
		try{
		parentWin.parent.setRuleRelation(ruleRelationship);
		}catch(e){}
	}
	
	function setConditionElement(rulename,ruleid,rulesrc,ruleids,rulecondits,maplistids)
	{
		/*if(rulesrc === "4")
		{
			var sp4 = "<a style='cursor:pointer' ruleid='"+ruleid+"' onclick=\"onShowBrowsersByWFU(this,'-4','<%=formid%>','<%=isbill%>')\">"+rulename+"</a>";
			jQuery(parentWin.wfconditions).html(sp4);
			jQuery(parentWin.wfconditioncn).val(rulename);
			jQuery(parentWin.wfconditionss).val(ruleid);
		}else if(rulesrc === "2")
		{
			var sp2 = "<a style='cursor:pointer' ruleid='"+ruleid+"' onclick=\"onShowBrowsers(this,'-2','<%=nodeid%>','<%=formid%>','<%=isbill%>')\">"+rulename+"</a>";
			jQuery(parentWin.conditions).html(sp2);
			jQuery(parentWin.conditioncn).val(rulename);
			jQuery(parentWin.conditionss).val(ruleid);
		}else if(rulesrc === "1")
		{
			jQuery(parentWin.$GetEle("por<%=linkid%>_con")).val(ruleid);
			jQuery(parentWin.$GetEle("por<%=linkid%>_con_cn")).val(rulename);
		}*/
		if(parentWin._table)
			parentWin._table.reLoad();
		if(rulesrc != "3"&&rulesrc != "5"){
			parentWin.parent.setParentPic("<%=linkid%>",true,rulesrc,ruleids,rulecondits,maplistids);
		}
		closeDialog();
	}
</script>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>

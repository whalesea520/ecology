
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.rdeploy.workflow.WFNodeBean"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>

<%

/////////////35内部留言、36通知公告
int workflowid = Util.getIntValue(request.getParameter("wfid"),0);
String modeurl = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+workflowid+"&isTemplate=0&versionid_toXtree=1";
int isclose = Util.getIntValue(request.getParameter("isclose"),0);
//当前节点
int nodeid = -1;
//当前节点流转的下一个节点

//权限校验
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int prenodeid = -1;
//创建节点
int startnodeid = -1;
//归档节点
int stopnodeid = -1;
int createrid = 0;
int approvalnodeid = 0;
int managenodeid = 0;

createrid=user.getUID();
//查询流程的创建节点和归档节点
RecordSet.executeSql("select nodeid,nodetype from workflow_flownode where (nodetype=0 or nodetype=3) and workflowid="+workflowid);
while (RecordSet.next()) {
	int nodetype = Util.getIntValue(RecordSet.getString("nodetype"),0);
	if(nodetype == 0){
		startnodeid = Util.getIntValue(RecordSet.getString("nodeid"),0);
	}else if(nodetype == 3){
		stopnodeid = Util.getIntValue(RecordSet.getString("nodeid"),0);
	}
}

int floworder = 0;
List nodeList = new ArrayList();
String nodeStr = "[";
String nodesql = " select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature, "+
				 " node.IsPendingForward,base.operators,base.Signtype,base.floworder  "+
				 " from workflow_flownode node,workflow_nodebase base  "+
				 " where (base.IsFreeNode is null or base.IsFreeNode!='1') "+
				 " AND node.nodeid=base.id and node.workflowid = "+workflowid +
				 " order by node.nodetype,base.floworder ";

RecordSet.executeSql(nodesql);
while (RecordSet.next()) {

	WFNodeBean wfNodeBean = new WFNodeBean();
	String operators = Util.null2String(RecordSet.getString("operators"));
	String operatornames = "";
	ArrayList operatorlist = Util.TokenizerString(operators,",");
	
	//int floworder = Util.getIntValue(RecordSet.getString("floworder"),0);
	String nodename = Util.null2String(RecordSet.getString("nodename"));
	int Signtype = Util.getIntValue(RecordSet.getString("Signtype"),0);
	int wfnodeid = Util.getIntValue(RecordSet.getString("id"),0);
	int nodetype = Util.getIntValue(RecordSet.getString("nodetype"),0);
	
	int grouptype = 0;
	int objid = 0;
	String objname = "";
	String groupsql = "SELECT type,objid FROM workflow_groupdetail WHERE groupid in ( "+
						" SELECT id FROM workflow_nodegroup WHERE nodeid = "+wfnodeid+" )";
	rs.executeSql(groupsql);
	if(rs.next()){
		grouptype = Util.getIntValue(rs.getString("type"),0);
		objid = Util.getIntValue(rs.getString("objid"),0);
	}
	
	if(objid != 0){
		rs.executeSql("select lastname from hrmresource where id="+objid);
		if(rs.next()){
			objname = Util.null2String(rs.getString("lastname"));
		}
	}
	
	if(nodetype == 0){
	   operatorlist = new ArrayList();
       operatorlist.add(createrid+"");
       operators = createrid+"";
    }
	
	if(nodetype == 1){
		approvalnodeid = wfnodeid;
	}
	
	if(nodetype == 2){
		managenodeid = wfnodeid;
	}

	//0:所有人type=4,1:指定人type=3,2:创建人经理type=18,3:创建人本人type=17
	if(grouptype == 3){
		//operatornames=SystemEnv.getHtmlLabelName(23122, user.getLanguage());
		operatornames=objname;
	}else if(grouptype == 4){
		operatornames=SystemEnv.getHtmlLabelName(1340, user.getLanguage());
	}else if(grouptype == 17){
		operatornames=SystemEnv.getHtmlLabelName(15079, user.getLanguage());
	}else if(grouptype == 18){
		operatornames=SystemEnv.getHtmlLabelName(15080, user.getLanguage());
	}
	
	wfNodeBean.setWfnodeid(wfnodeid);
	wfNodeBean.setNodetype(nodetype);
	wfNodeBean.setFloworder(floworder);
	wfNodeBean.setNodename(nodename);
	wfNodeBean.setSigntype(Signtype);
	wfNodeBean.setOperators(operators);
	wfNodeBean.setOperatornames(operatornames);
	wfNodeBean.setGrouptype(grouptype);
	wfNodeBean.setObjid(objid);
	wfNodeBean.setObjname(objname);
	nodeList.add(wfNodeBean);
	floworder++;
}

for(int r=0;r<nodeList.size();r++){ 
	WFNodeBean wfnb = (WFNodeBean) nodeList.get(r);
	nodeStr=nodeStr+"{";
	nodeStr=nodeStr+"nodeid:'"+wfnb.getWfnodeid()+"',";
	nodeStr=nodeStr+"nodetype:'"+wfnb.getNodetype()+"',";
	nodeStr=nodeStr+"floworder:'"+wfnb.getFloworder()+"',";
	nodeStr=nodeStr+"nodename:'"+wfnb.getNodename()+"',";
	nodeStr=nodeStr+"Signtype:'"+wfnb.getSigntype()+"',";
	nodeStr=nodeStr+"operators:'"+wfnb.getOperators()+"',";
	nodeStr=nodeStr+"operatornames:'"+wfnb.getOperatornames()+"',";
	nodeStr=nodeStr+"grouptype:'"+wfnb.getGrouptype()+"',";
	nodeStr=nodeStr+"objid:'"+wfnb.getObjid()+"',";
	nodeStr=nodeStr+"objname:'"+wfnb.getObjname()+"',";
	if(r != nodeList.size()-1){
		nodeStr=nodeStr+"nextnodetype:'"+((WFNodeBean) nodeList.get(r+1)).getNodetype()+"',";
	}else{
		nodeStr=nodeStr+"nextnodetype:'3',";
	}
	nodeStr=nodeStr+"},";
}

if(nodeStr.lastIndexOf(",") > -1){
	nodeStr = nodeStr.substring(0,nodeStr.lastIndexOf(","));
}
nodeStr += "]";
//System.out.println("nodeStr = " + nodeStr);

//显示html预览
String modeid = "";
String formid ="";
String isbill ="";
String tempnodeid ="";
String defaulemodeid = "";
List modeList = new ArrayList();
String nodehtml = "select id,formid,isbill,nodeid from workflow_nodehtmllayout where nodeid = "+startnodeid+" and workflowid = "+workflowid + " and type=0 ORDER BY id desc";
rs.executeSql(nodehtml);
//System.out.println("nodehtml = " + nodehtml);
while(rs.next()){
	modeid = Util.null2String(rs.getString("id"));
	formid = Util.null2String(rs.getString("formid"));
	isbill = Util.null2String(rs.getString("isbill"));
	tempnodeid = Util.null2String(rs.getString("nodeid"));
	modeList.add(modeid);
}
if(modeList.size()>0){
	defaulemodeid = Util.null2String(modeList.get(0));
}
int allnodenum = nodeList.size();
int divisor = allnodenum/4;
int remainder = allnodenum%4;
if(divisor > 0 && remainder == 0){
	divisor -= 1;
}
int mainSpanhigh = 160 + divisor*176;

//模板切换
int modenum = modeList.size();
//int modenum = 3;
%>
<script type='text/javascript' src='/js/workflow/wfEditInterface_wev8.js'></script>
<link href="/css/ecology8/request/wfEditInterface_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language="javascript" src="/rdeploy/assets/js/jquery.easing.1.3.js"></script>
<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">
<!--	<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>-->
	<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
	<script language="javascript" src="/js/jquery/ui/ui.droppable_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<%--浏览框js版 --%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<style type="text/css">
.topoperator {
	float:right;line-height:35px;margin:5px;padding:0px 18px;background:#6abc50;color:#fff;cursor:pointer;font-family:微软雅黑 !important;
}
.topoperatorslt {
	background:#6ad04a!important;font-family:微软雅黑 !important;
}
</style>
<script type="text/javascript">
jQuery(function () {
	$("#inadvancedmode").hover(function () {
		$(this).addClass("topoperatorslt");
	}, function () {
		$(this).removeClass("topoperatorslt");
	});
	
	$("#inadvancedmode").bind("click", function () {
		window.open("<%=modeurl %>");
	});

	var fullData=eval("<%=nodeStr%>");

	var currnodeid=<%=nodeid%>;
	var nextnodeid=<%=prenodeid%>;
	var currwfid =<%=workflowid%>;

	var option=[
		{id:0,value:'<%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%>'},
		{id:1,value:'<%=SystemEnv.getHtmlLabelName(359, user.getLanguage())%>'},
		{id:2,value:'<%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%>'},
		{id:3,value:'<%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>'}
	];

	workflowInterface.setNodeTypeOption(option);

	option=[
		{id:0,value:'<%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%>'},
		{id:1,value:'<%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%>'},
		{id:2,value:'<%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%>'}
	];

	workflowInterface.setSignTypeOption(option);

	option=[{id:0,value:'<%=SystemEnv.getHtmlLabelName(83519, user.getLanguage())%>'},
			{id:1,value:'<%=SystemEnv.getHtmlLabelName(32178, user.getLanguage())%>'},
			{id:2,value:'<%=SystemEnv.getHtmlLabelName(84500, user.getLanguage())%>'}]
	workflowInterface.setRoadTypeOption(option);
	
	workflowInterface.setInitNodeName('<%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%>');

	workflowInterface.create(jQuery("#mainSpan"),fullData,currnodeid,nextnodeid,currwfid);
	middleresize();

	
	jQuery("#forleft").unbind('click').click(function () {
		if(isover == 0){
			switchTemplate('left');
		}
	});
	jQuery("#forright").unbind('click').click(function () {
		if(isover == 0){
			switchTemplate('right');
		}
	});
});

function doSave() {
	if (check_form(document.wfEditForm,document.wfEditForm.checkfield.value)){
		wfEditForm.submit();
	}
}

var dialog = parent.parent.getDialog(parent.window);
var parentWin = parent.parent.getParentWindow(parent.window);

function clostWin()
{
	//关闭对话框
	dialog.close();
}

var isclose = "<%=isclose%>";
if(isclose == 1){
	dialog.close();
}

var __modenum = "<%=modenum%>";
var iframeheightbegin = 0;
function middleresize(){
	var mainSpanhigh = "<%=mainSpanhigh%>";
	jQuery("#mainSpan").height(mainSpanhigh);
	jQuery("#tosc").width(__modenum*100+"%");
	for(var modeq = 0;modeq<__modenum;modeq++){
		jQuery("#modediv_"+modeq).width(100/__modenum+"%");
	}
}

var __rollnum = 0;
var lsh,rsh;
var leftright = "";
var isover = 0;
function switchTemplate(obj){
	if(obj == "right"){
		if(__rollnum < (__modenum-1)){
			isover += 1;
			__rollnum += 1;
			rsh=setInterval(leftloop,20);
			leftright = "right";
			repSetValue(__rollnum);
		}else{
			return false;
		}
	}else if(obj == "left"){
		if(__rollnum > 0){
			isover += 1;
			__rollnum -= 1;
			lsh=setInterval(leftloop,20);
			leftright = "left";
			repSetValue(__rollnum);
		}else{
			return false;
		}
	}
	//jQuery("#middlediv").scrollLeft(toscWidth/2-10);
}

function leftloop(){
	//判断是否左侧内容全部进入滚动条
	if(leftright == "right"){
		var toscWidth = jQuery("#tosc").width();
		var toleft = toscWidth*(__rollnum)/__modenum;
		var left=jQuery("#middlediv").scrollLeft()+20;
		if(toleft > left){
			jQuery("#middlediv").scrollLeft(left);
		}else{
			clearInterval(rsh);
			isover -= 1;
			return false;
		}
	}else if(leftright == "left"){
		var toscWidth = jQuery("#tosc").width();
		var toleft = toscWidth*(__rollnum)/__modenum;
		var left=jQuery("#middlediv").scrollLeft()-20;
		if(left > toleft){
			jQuery("#middlediv").scrollLeft(left);
		}else{
			clearInterval(lsh);
			isover -= 1;
			return false;
		}
	}
}

function repSetValue(obj){
	var inputmode_ = jQuery("#inputmode_"+obj).val();
	jQuery("#inputmode").val(inputmode_);
	jQuery("#rownum").val(jQuery("#rownum").val()+1);
	jQuery("input[name^=ismodify_]").each(function (i, e) {
		var evalue = $(e).val();
		if(evalue == 0){
			$(e).val("2");
		}
	});
}

</script>

<div style="width:100%;position: fixed;background-color:#FAFAFA;z-index:999;font-family:微软雅黑 !important;font-size: 12px;border-bottom:1px solid  #d3d3d3;">
	<div style="float:left;line-height:50px;font-size: 12px;">&nbsp;&nbsp;&nbsp;&nbsp;流转节点</div>
	
	<div style="float:left;" id="test112"></div>
	
	<%--
	<div style="float:left;margin-top:12px;width: 150px;">
		<select id="selectType" name="selectType" onchange="changeGroupType();" disabled="disabled">
		<option  value="0"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
		<option  value="1"><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage())%></option>
		<option  value="2"><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></option>
		<option  value="3"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></option>
           </select>
    </div> 
    --%>
<%--</div> --%>
<div style="float:right;right: 0px;">
	<span class="topoperator" id="inadvancedmode">进入高级模式</span>
</div>
<%--
<div id="createridse1span" name="createridse1span" class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
           <brow:browser viewType="0" name="createrid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" browserSpanValue=""> 
			</brow:browser> 
</div>
--%>

</div>
<div style="width:100%;height: 46px;"></div>
<div id="mainSpan">	
</div>
<div style="width:100%;height:40px;line-height:40px;font-size: 12px;background-color:#F7F7FA;">&nbsp;&nbsp;&nbsp;&nbsp;表单预览</div>
<div id="middlediv">
<%if(modenum > 1){%>
	<div class="aleft" id="forleft" ></div>
	<div class="rightward" id="forright" ></div>
	<div style="width:100%;height:52px;"></div>
<% }%>
	<div id="tosc" style="display:block;width:100%;height:100%;">
	<%for(int k=0;k<modenum;k++){%>
		<div id="modediv_<%=k%>" style="float:left;width:100%;height:100%;">
			<iframe name="middleiframe" width="100%" height="100%" src="/rdeploy/wf/request/showInterfaceView.jsp?wfid=<%= workflowid%>&modeid=<%=modeList.get(k)%>&layouttype=0&nodetype=0&formid=<%=formid %>&isbill=<%=isbill %>&nodeid=<%=tempnodeid %>" frameborder="0" ></iframe>
			<script type="text/javascript">
		    jQuery("iframe[name=middleiframe]").load(function () {
		    	var iframeheight = jQuery(this).contents().find(".excelTempDiv").height();
		    	if(iframeheightbegin < iframeheight){
			    	if(__modenum > 1){
			    		jQuery("#middlediv").height(iframeheight+100);
			    	}else{
			    		jQuery("#middlediv").height(iframeheight+50);
			    	}
			    	iframeheightbegin = iframeheight;
		    	}
		    });
			</script>
		</div>
		<input type='hidden' id="inputmode_<%=k%>" name="inputmode_<%=k%>" value="<%=modeList.get(k) %>" />
	<%} %>
	<div class="clear"></div>
	</div>
</div>

<form id='wfEditForm' name="wfEditForm" method="post" action="wfEdit_operation.jsp">
	<input type='hidden' id="old_inputmode" name="old_inputmode" value="<%=defaulemodeid %>" />
	<input type='hidden' id="inputmode" name="inputmode" value="" />
	<input type='hidden' id="workflowid" name="workflowid" value="<%=workflowid%>" />
	<input type='hidden' id="startnodeid" name="startnodeid" value="<%=startnodeid%>" />
	<input type='hidden' id="rownum" name="rownum" value="0" />
	<input type='hidden' id="indexnum" name="indexnum" value="<%=nodeList.size()%>"/>
	<input type='hidden' id="allnum" name="allnum" value="<%=nodeList.size()%>"/>
	<input type='hidden' id="checkfield" name="checkfield"/>
	<input type='hidden' id="deletenode" name="deletenode"/>
	<%
		for(int r=0;r<nodeList.size();r++){ 
			WFNodeBean wfnb = (WFNodeBean) nodeList.get(r);
	%>
		<input type="hidden" name="floworder_<%=r%>" value="<%=wfnb.getFloworder()%>">
		<input type="hidden" name="nodename_<%=r%>" value="<%=wfnb.getNodename()%>">
		<input type="hidden" name="wfnodeid_<%=r%>" value="<%=wfnb.getWfnodeid()%>">
		<input type="hidden" name="nodetype_<%=r%>" value="<%=wfnb.getNodetype()%>">
		<input type="hidden" name="Signtype_<%=r%>" value="<%=wfnb.getSigntype()%>">
		<input type="hidden" name="operators_<%=r%>" value="<%=wfnb.getOperators()%>">
		<input type="hidden" name="operatornames_<%=r%>" value="<%=wfnb.getOperatornames()%>">
		<input type="hidden" name="grouptype_<%=r%>" value="<%=wfnb.getGrouptype()%>">
		<input type="hidden" name="objid_<%=r%>" value="<%=wfnb.getObjid()%>">
		<input type="hidden" name="objname_<%=r%>" value="<%=wfnb.getObjname()%>">
		<input type="hidden" name="ismodify_<%=r%>" value="0">
		<%
			if(r != nodeList.size()-1){
		%>
			<input type="hidden" name="nextnodetype_<%=r%>" value="<%=((WFNodeBean) nodeList.get(r+1)).getNodetype()%>">
		<%
			}else{
		%>
			<input type="hidden" name="nextnodetype_<%=r%>" value="<%=3%>">
		<%
			}
		} %>
</form>


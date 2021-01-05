<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@page import="weaver.general.MouldIDConst"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="weaver.file.Prop" %>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
BaseBean bb = new BaseBean();
DecimalFormat df = new DecimalFormat("##########################################0.00");
String _guid1 = UUID.randomUUID().toString();
int requestId = Util.getIntValue(Util.null2String(request.getParameter("requestid")), 0);
int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")), 0);
int hpid_ABS = Math.abs(Util.getIntValue(hpid, 0));

RecordSet rs1 = new RecordSet();
String sql1 = "";

if(workflowid<=0){
	sql1 = "select * from synergy_base a where a.frommodule = 'workflow' and a.id = "+hpid_ABS;
	rs1.executeSql(sql1);
	if(rs1.next()){
		workflowid = rs1.getInt("wfid");
	}
}

User user = HrmUserVarify.getUser(request, response);
//out.println("user="+user+";hpid="+hpid+";requestId="+requestId+";workflowid="+workflowid+";<br>");
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

if(requestId<=0&&workflowid<=0){
	return ;
}

int creater = user.getUID();

if(requestId > 0){
	sql1 = "select a.workflowid, a.creater from workflow_requestbase a where a.requestid = "+requestId+" "+
		" and exists (select 1 from workflow_currentoperator wc where wc.requestid = a.requestid and wc.userid="+user.getUID()+" and wc.usertype=0)";
	//out.println("sql1="+sql1+"<br />");
	rs1.executeSql(sql1);
	if(rs1.next()){
		//out.println("rs1.next()=true<br />");
		creater = rs1.getInt("creater");
	}else{
		//out.println("rs1.next()=false<br />");
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}
//out.println("sql1 done<br />");


String guid1_fnaBudgetAssistant1 = "";
int hrm = 0;
int dep = 0;
int subCmp = 0;
int fcc = 0;
sql1 = "select * from fnaBudgetAssistant1 a where a.eid = "+eidInt;
//out.println("sql1="+sql1+"<br />");
rs1.executeSql(sql1);
if(rs1.next()){
	guid1_fnaBudgetAssistant1 = Util.null2String(rs1.getString("guid1")).trim();
	hrm = rs1.getInt("hrm");
	dep = rs1.getInt("dep");
	subCmp = rs1.getInt("subCmp");
	fcc = rs1.getInt("fcc");
}else{
	return ;
}

String currentDate = TimeUtil.getCurrentDateString();
String[] currentDateArray = currentDate.split("-");
String currentYYYY = currentDateArray[0];
String currentMM = currentDateArray[1];
String currentDD = currentDateArray[2];
String currentLastYYYY = currentYYYY;
String currentLastMM = currentMM;
if(Util.getIntValue(currentMM)==1){
	currentLastYYYY = (Util.getIntValue(currentYYYY)-1)+"";
	currentLastMM = "12";
}else{
	currentLastMM = (Util.getIntValue(currentMM)-1)+"";
}
if(Util.getIntValue(currentLastMM)<10){
	currentLastMM = "0"+Util.getIntValue(currentLastMM);
}

Map<String, String> dataMap = new HashMap<String, String>();
String fnaWfType = FnaCommon.getFnaWfFieldInfo4Expense(workflowid, dataMap);
//out.println("workflowid="+workflowid+";fnaWfType="+fnaWfType+"<br />");
if(!"fnaFeeWf".equals(fnaWfType)){
	return;
}
int formid = Util.getIntValue(dataMap.get("formid"), 0);
int formidABS = Math.abs(formid);
String main_fieldIdSqr_fieldName = Util.null2String(dataMap.get("main_fieldIdSqr_fieldName")).trim();//三条流程的申请人数据库字段
//out.println("main_fieldIdSqr_fieldName="+main_fieldIdSqr_fieldName+"<br />");

request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_dataMap_"+_guid1, dataMap);
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_creater_"+_guid1, creater+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_requestId_"+_guid1, requestId+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_workflowid_"+_guid1, workflowid+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_fnaWfType_"+_guid1, fnaWfType+"");

request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentDate_"+_guid1, currentDate+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentYYYY_"+_guid1, currentYYYY+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentMM_"+_guid1, currentMM+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentDD_"+_guid1, currentDD+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentLastYYYY_"+_guid1, currentLastYYYY+"");
request.getSession().setAttribute("fnaBudgetAssistant1_View.jsp_currentLastMM_"+_guid1, currentLastMM+"");

double defaultHeight = 334 + 21 + 171;

String url_FnaExpenseInfo_Dep = "/page/element/fnaBudgetAssistant1/FnaExpenseInfo.jsp?_guid1="+_guid1+"&orgTypeName=dep";
String url_FnaExpenseInfo_SubCmp = "/page/element/fnaBudgetAssistant1/FnaExpenseInfo.jsp?_guid1="+_guid1+"&orgTypeName=subCmp";
String url_FnaExpenseInfo_Hrm = "/page/element/fnaBudgetAssistant1/FnaExpenseInfo.jsp?_guid1="+_guid1+"&orgTypeName=hrm";
String url_FnaExpenseInfo_Fcc = "/page/element/fnaBudgetAssistant1/FnaExpenseInfo.jsp?_guid1="+_guid1+"&orgTypeName=fcc";
%>
<div style="width:100%;overflow:hidden;table-layout:fixed;height: <%=defaultHeight+62 %>px;">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName" style="margin-left: 0px;"></span>
			</div>
			<div>
			    <ul class="tab_menu">
			    <%if(hrm==1){ %>
		    		<li id="divMainInfoLi1">
			        	<a id="divMainInfo1" href="<%=url_FnaExpenseInfo_Hrm %>" onclick="divMainInfo_onclick(1);" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("6087",user.getLanguage()) %><!-- 个人 --> 
			        	</a>
			        </li>
			    <%}
			    if(dep==1){ %>
		    		<li id="divMainInfoLi2">
			        	<a id="divMainInfo2" href="<%=url_FnaExpenseInfo_Dep %>" onclick="divMainInfo_onclick(2);" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("124",user.getLanguage()) %><!-- 部门 --> 
			        	</a>
			        </li>
			    <%}
			    if(subCmp==1){ %>
		    		<li id="divMainInfoLi3">
			        	<a id="divMainInfo3" href="<%=url_FnaExpenseInfo_SubCmp %>" onclick="divMainInfo_onclick(3);" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("141",user.getLanguage()) %><!-- 分部 --> 
			        	</a>
			        </li>
			    <%}
			    if(fcc==1){ %>
		    		<li id="divMainInfoLi4">
			        	<a id="divMainInfo4" href="<%=url_FnaExpenseInfo_Fcc %>" onclick="divMainInfo_onclick(4);" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("515",user.getLanguage()) %><!-- 成本中心 --> 
			        	</a>
			        </li>
			    <%} %>
			    </ul> 
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box" style="width: 800px;height: <%=defaultHeight %>px;">
			<iframe src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" scrolling="no" height="100%" frameborder="0"  width="100%"></iframe>
	    </div>
	</div>
</div>
<style type="text/css">
	td{
		cursor:pointer;
		text-align: center;
	}
</style>
<script type="text/javascript">
function divMainInfo_onclick(_num){
	jQuery("#divMainInfoLi1,#divMainInfoLi2,#divMainInfoLi3,#divMainInfoLi4").removeClass("current"); 
	jQuery("#divMainInfoLi"+_num).addClass("current").show();
}
function initWfPageUrlParams(){
	var poststr = "";
	var fysqlc = "";
	var _parent = window.parent;
	if(_parent!=null){
		var _bodyiframe = _parent.jQuery("#bodyiframe");
		if(_bodyiframe.length==1){
			var _contentWindow = _bodyiframe[0].contentWindow;
			if(_contentWindow!=null && _contentWindow.getPoststr!=null){
				poststr = _contentWindow.getPoststr();
				fysqlc = _contentWindow.getFysqlc();
			}
		}
	}
	
	var wfPageUrlParams = "&fysqlc="+fysqlc+"&poststr="+poststr;
	jQuery('#divMainInfo1').attr("href","<%=url_FnaExpenseInfo_Hrm %>"+wfPageUrlParams);
	jQuery('#divMainInfo2').attr("href","<%=url_FnaExpenseInfo_Dep %>"+wfPageUrlParams);
	jQuery('#divMainInfo3').attr("href","<%=url_FnaExpenseInfo_SubCmp %>"+wfPageUrlParams);
	jQuery('#divMainInfo4').attr("href","<%=url_FnaExpenseInfo_Fcc %>"+wfPageUrlParams);

	if(poststr!=""){
    <%if(hrm==1){ %>
		jQuery("#divMainInfo1")[0].click();
    <%}else if(dep==1){ %>
		jQuery("#divMainInfo2")[0].click();
    <%}else if(subCmp==1){ %>
		jQuery("#divMainInfo3")[0].click();
    <%}else if(fcc==1){ %>
		jQuery("#divMainInfo4")[0].click();
    <%} %>
	}
}
jQuery(document).ready(function(){
	jQuery('.e8_box').Tabs({
    	getLine:1,
        contentID:"#divMainInfo",
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        staticOnLoad:true,
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(127743, user.getLanguage())) %>,
    	needInitBoxHeight:false
    });

	initWfPageUrlParams();
});
</script>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
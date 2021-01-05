<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("fnaControlScheme:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//费控流程 //33075
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();


int mainId = Util.getIntValue(request.getParameter("mainId"));
int id = Util.getIntValue(request.getParameter("id"), 0);

int workflowid = 0;
boolean enable = false;

String sql = "select * from fnaFeeWfInfo where id = "+mainId;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
}

int intensity = 1;
int kmIdsCondition = 1;
int orgIdsCondition = 1;

String subjectId = "";

int orgType = 1;
String orgIds = "";

String subId = "";
String depId = "";
String hrmId = "";
String fccId = "";

String promptSC = "";

if(id > 0){
	sql = "select * from fnaControlSchemeDtl where id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		intensity = rs.getInt("intensity");
		kmIdsCondition = rs.getInt("kmIdsCondition");
		orgIdsCondition = rs.getInt("orgIdsCondition");

		subjectId = Util.null2String(rs.getString("kmIds")).trim();

		orgType = rs.getInt("orgType");
		orgIds = Util.null2String(rs.getString("orgIds")).trim();

		if(orgType == 1){
			subId = orgIds;
		}else if(orgType == 2){
			depId = orgIds;
		}else if(orgType == 3){
			hrmId = orgIds;
		}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
			fccId = orgIds;
		}

		promptSC = Util.null2String(rs.getString("promptSC")).trim();
	}
}else{
	//"#orgTypeName# #orgName# 科目：#subjectName# #feeDay# 的 可用金额为：#budgetavail#，申请金额为：#applyamount#";
	promptSC = FnaLanguage.getPromptSC_FnaControlSchemeSetLogicEditPage(user.getLanguage());
}

StringBuffer shownameSubject = new StringBuffer();
if(!"".equals(subjectId)){
	sql = "select a.id, a.name from FnaBudgetfeeType a where a.id in ("+subjectId+") ORDER BY a.codename, a.name, a.id ";
	subjectId = "";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameSubject.length() > 0){
			shownameSubject.append(",");
			subjectId+=",";
		}
		shownameSubject.append(Util.null2String(rs.getString("name")).trim());
		subjectId+=Util.null2String(rs.getString("id")).trim();
	}
}

StringBuffer shownameSub = new StringBuffer();
StringBuffer shownameDep = new StringBuffer();
StringBuffer shownameHrm = new StringBuffer();
StringBuffer shownameFcc = new StringBuffer();

if(orgType == 1){
	sql = "select a.id, a.subcompanyname name from HrmSubCompany a where a.id in ("+orgIds+") ORDER BY a.showorder, a.subcompanycode, a.subcompanyname";
	subId = orgIds;
}else if(orgType == 2){
	sql = "select a.id, a.departmentname name from HrmDepartment a where a.id in ("+orgIds+") ORDER BY a.showorder, a.departmentcode, a.departmentname";
	depId = orgIds;
}else if(orgType == 3){
	sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+orgIds+") ORDER BY a.dsporder, a.workcode, a.lastname";
	hrmId = orgIds;
}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
	sql = "select a.id, a.name name from FnaCostCenter a where a.id in ("+orgIds+") ORDER BY a.code, a.name";
	fccId = orgIds;
}

subId="";depId="";hrmId="";fccId="";

if(!"".equals(orgIds)){
	rs.executeSql(sql);
	while(rs.next()){
		if(orgType == 1){
			if(shownameSub.length() > 0){
				shownameSub.append(",");
				subId+=",";
			}
			shownameSub.append(Util.null2String(rs.getString("name")).trim());
			subId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == 2){
			if(shownameDep.length() > 0){
				shownameDep.append(",");
				depId+=",";
			}
			shownameDep.append(Util.null2String(rs.getString("name")).trim());
			depId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == 3){
			if(shownameHrm.length() > 0){
				shownameHrm.append(",");
				hrmId+=",";
			}
			shownameHrm.append(Util.null2String(rs.getString("name")).trim());
			hrmId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
			if(shownameFcc.length() > 0){
				shownameFcc.append(",");
				fccId+=",";
			}
			shownameFcc.append(Util.null2String(rs.getString("name")).trim());
			fccId+=Util.null2String(rs.getString("id")).trim();
		}
	}
}

%>

<%@page import="weaver.fna.general.FnaLanguage"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32132,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<input id="mainId" name="mainId" value="<%=mainId %>" type="hidden" />
<input id="id" name="mainId" value="<%=id %>" type="hidden" />
<input id="workflowid" name="workflowid" value="<%=workflowid %>" type="hidden" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27955,user.getLanguage())%>'><!-- 触发条件 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %></wea:item><!-- 预算科目 -->
		<wea:item>
			<select id="kmIdsCondition" name="kmIdsCondition" style="width: 60px;float: left;">
				<option value="1" <%=(kmIdsCondition==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(353, user.getLanguage()) %></option><!-- 属于 -->
				<option value="2" <%=(kmIdsCondition==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21473, user.getLanguage()) %></option><!-- 不属于 -->
			</select>
	        <brow:browser viewType="0" name="subjectId" browserValue='<%=subjectId %>' 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/feeTypeByGroupCtrl/FnaBudgetfeeTypeByGroupCtrlBrowserMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=FnaBudgetfeeTypeMultiByGroupCtrl"  temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>'
	                browserSpanValue='<%=shownameSubject.toString() %>' width="70%" 
	                >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33189,user.getLanguage()) %></wea:item><!-- 费用单位类型 -->
		<wea:item>
			<select id="orgType" name="orgType" onchange="orgType_onchange();" style="width: 60px;float: left;">
			<%if(fnaBudgetOAOrg){ %>
				<option value="1" <%=(orgType==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141, user.getLanguage()) %></option><!-- 分部 -->
				<option value="2" <%=(orgType==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124, user.getLanguage()) %></option><!-- 部门 -->
				<option value="3" <%=(orgType==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(6087, user.getLanguage()) %></option><!-- 个人 -->
			<%} %>
			<%if(fnaBudgetCostCenter){ %>
				<option value="<%=FnaCostCenter.ORGANIZATION_TYPE %>" 
					<%=(orgType==FnaCostCenter.ORGANIZATION_TYPE)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(515, user.getLanguage()) %></option><!-- 成本中心 -->
			<%} %>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32135,user.getLanguage()) %></wea:item><!-- 费用单位 -->
		<wea:item>
			<select id="orgIdsCondition" name="orgIdsCondition" style="width: 60px;float: left;">
				<option value="1" <%=(orgIdsCondition==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(353, user.getLanguage()) %></option><!-- 属于 -->
				<option value="2" <%=(orgIdsCondition==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21473, user.getLanguage()) %></option><!-- 不属于 -->
			</select>
			
		<%if(fnaBudgetOAOrg){ %>
            <span id="spanSubId" style="display: none;">
		        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=shownameSub.toString() %>' width="70%" 
		                >
		        </brow:browser>
		    </span>
            <span id="spanDepId" style="display: none;">
		        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=shownameDep.toString() %>' width="70%" 
		                >
		        </brow:browser>
		    </span>
            <span id="spanHrmId" style="display: none;">
		        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
		                browserSpanValue='<%=shownameHrm.toString() %>' width="70%" 
		                >
		        </brow:browser>
		    </span>
		<%} %>
		<%if(fnaBudgetCostCenter){ %>
            <span id="spanFccId" style="display: none;">
		        <brow:browser viewType="0" name="fccId" browserValue='<%=fccId %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
		                browserSpanValue='<%=shownameFcc.toString() %>' width="70%" 
		               	>
		        </brow:browser>
		    </span>
		<%} %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32134,user.getLanguage()) %></wea:item><!-- 费控强度 -->
		<wea:item>
			<select id="intensity" name="intensity" style="width: 60px;float: left;">
				<option value="2" <%=(intensity==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32137, user.getLanguage()) %></option><!-- 强控 -->
				<option value="3" <%=(intensity==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32138, user.getLanguage()) %></option><!-- 弱控 -->
				<option value="1" <%=(intensity==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(26009, user.getLanguage()) %></option><!-- 不控制 -->
			</select>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33141,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 提示语句 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(22054,user.getLanguage()) %></wea:item><!-- 中文简体 -->
		<wea:item>
			<wea:required id="promptSCspan" required="true">
				<input id="promptSC" name="promptSC" value="<%=FnaCommon.escapeHtml(promptSC) %>" maxlength="2000" style="width: 90%;" class="inputstyle" 
				 onblur="checkinput('promptSC','promptSCspan');" />
			</wea:required>
		</wea:item>
		<wea:item>
			<font color="red">
				<%=SystemEnv.getHtmlLabelName(33151,user.getLanguage()) %>：<br /><!-- 提示语句占位符 -->
				#subjectName#：<%=SystemEnv.getHtmlLabelName(15409,user.getLanguage()) %><br /><!-- 科目名称 -->
				#orgTypeName#：<%=SystemEnv.getHtmlLabelName(32135,user.getLanguage())+SystemEnv.getHtmlLabelName(15795,user.getLanguage()) %><br /><!-- 费用单位类型名称 -->
				#orgName#：<%=SystemEnv.getHtmlLabelName(32135,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage()) %><br /><!-- 费用单位名称 -->
				#feeDay#：<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())+SystemEnv.getHtmlLabelName(97,user.getLanguage()) %><br /><!-- 费用日期 -->
				#applyamount#：<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage()) %><br /><!-- 费用金额 -->
				#budgetavail#：<%=SystemEnv.getHtmlLabelName(22807,user.getLanguage()) %><!-- 当前可用金额 -->
			</font>
		</wea:item><!-- 使用说明 -->
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>

<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	checkinput("promptSC","promptSCspan");
	resizeDialog(document);
	orgType_onchange();
});

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//保存
function doSave(_openEditPage){
	var mainId = null2String(jQuery("#mainId").val());
	var id = null2String(jQuery("#id").val());
	var workflowid = null2String(jQuery("#workflowid").val());

	var intensity = null2String(jQuery("#intensity").val());
	var kmIdsCondition = null2String(jQuery("#kmIdsCondition").val());
	var orgIdsCondition = null2String(jQuery("#orgIdsCondition").val());
	var subjectId = null2String(jQuery("#subjectId").val());
	var orgType = null2String(jQuery("#orgType").val());
	var subId = null2String(jQuery("#subId").val());
	var depId = null2String(jQuery("#depId").val());
	var hrmId = null2String(jQuery("#hrmId").val());
	var fccId = null2String(jQuery("#fccId").val());
	var promptSC = null2String(jQuery("#promptSC").val());
	var promptEN = null2String(jQuery("#promptEN").val());
	var promptTC = null2String(jQuery("#promptTC").val());

	/*
	if(subjectId=="" && ((orgType=="1" && subId=="") || (orgType=="2" && depId=="") || (orgType=="3" && hrmId=="") || (orgType=="<%=FnaCostCenter.ORGANIZATION_TYPE %>" && fccId==""))){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32144,user.getLanguage())%>");//请至少选择一个科目或者费用单位
		return;
	}
	*/
	if(promptSC==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33141,user.getLanguage())+
				SystemEnv.getHtmlLabelName(22054,user.getLanguage())+SystemEnv.getHtmlLabelName(18019,user.getLanguage()) %>");//提示语句中文简体必填
		return;
	}
	
	try{
		var _data = "operation=FnaControlSchemeSetLogic&mainId="+mainId+"&id="+id+"&workflowid="+workflowid+
			"&intensity="+intensity+"&kmIdsCondition="+kmIdsCondition+"&orgIdsCondition="+orgIdsCondition+
			"&subjectId="+subjectId+"&orgType="+orgType+"&subId="+subId+
			"&depId="+depId+"&hrmId="+hrmId+"&fccId="+fccId+"&promptSC="+encodeURI(promptSC)+
			"&promptEN="+promptEN+"&promptTC="+encodeURI(promptTC);

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/budget/FnaControlSchemeSetOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						var parentWin = parent.parent.getParentWindow(window);
						//parentWin._table.reLoad();
						parentWin.onBtnSearchClick();
						doClose2();
					}else{
						top.Dialog.alert(_json.msg);
					}

			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
	}
}

//切换费用单位类型
function orgType_onchange(){
	var spanSubIdObj = jQuery("#spanSubId");
	var spanDepIdObj = jQuery("#spanDepId");
	var spanHrmIdObj = jQuery("#spanHrmId");
	var spanFccIdObj = jQuery("#spanFccId");

	spanSubIdObj.hide();
	spanDepIdObj.hide();
	spanHrmIdObj.hide();
	spanFccIdObj.hide();
	
	var orgType = jQuery("#orgType").val();
	if(orgType=="1"){
		spanSubIdObj.show();
	}else if(orgType=="2"){
		spanDepIdObj.show();
	}else if(orgType=="3"){
		spanHrmIdObj.show();
	}else if(orgType=="<%=FnaCostCenter.ORGANIZATION_TYPE %>"){
		spanFccIdObj.show();
	}
}

//关闭
function doClose(){
	var dialog = parent.parent.getDialog(window);	
	dialog.closeByHand();
}

//关闭
function doClose2(){
	var parentWin = parent.parent.getParentWindow(window);
	parentWin.closeDialog();
}

</script>

</body>
</html>

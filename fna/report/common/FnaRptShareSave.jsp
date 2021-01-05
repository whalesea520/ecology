<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
	</head>
<%
String rptTypeName = Util.null2String(request.getParameter("rptTypeName")).trim();
boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

String sql = "";

String groupGuid1 = Util.null2String(request.getParameter("groupGuid1")).trim();
String fnaTmpTbLogId = Util.null2String(request.getParameter("fnaTmpTbLogId")).trim();


HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(Util.getIntValue(fnaTmpTbLogId), user.getUID());

boolean isView = "true".equals(retHm.get("isView"));//查看
boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
if(!isEdit && !isFull) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

int shareType = 0;
StringBuffer shareIds = new StringBuffer("");
String secLevel1 = "";
String secLevel2 = "";
int shareLevel = 0;

if(!"".equals(groupGuid1)){
	rs.executeSql("select * from fnaTmpTbLogShare where groupGuid1 = '"+StringEscapeUtils.escapeSql(groupGuid1)+"' and fnaTmpTbLogId="+Util.getIntValue(fnaTmpTbLogId)+" ORDER BY id");
	while(rs.next()){
		shareType = rs.getInt("shareType");
		if(shareType != 0){
			if(shareIds.length() > 0){
				shareIds.append(",");
			}
			shareIds.append(rs.getInt("shareId"));
		}
		secLevel1 = Util.null2String(rs.getString("secLevel1")).trim();
		secLevel2 = Util.null2String(rs.getString("secLevel2")).trim();
		shareLevel = rs.getInt("shareLevel");
	}
}

if(Util.getIntValue(secLevel1) == -1){
	secLevel1 = "";
}

if(Util.getIntValue(secLevel2) == -1){
	secLevel2 = "";
}

String hrmId = "";
String depId = "";
String subId = "";
String roleId = "";

StringBuffer shownameHrm = new StringBuffer();
StringBuffer shownameDep = new StringBuffer();
StringBuffer shownameSub = new StringBuffer();
StringBuffer shownameRole = new StringBuffer();

if(shareType==0){
	//所有人
}else if(shareType==1){
	hrmId = shareIds.toString();
	sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+hrmId+") ORDER BY a.dsporder, a.workcode, a.lastname";
}else if(shareType==2){
	depId = shareIds.toString();
	sql = "select a.id, a.departmentname name from HrmDepartment a where a.id in ("+depId+") ORDER BY a.showorder, a.departmentcode, a.departmentname";
}else if(shareType==3){
	subId = shareIds.toString();
	sql = "select a.id, a.subcompanyname name from HrmSubCompany a where a.id in ("+subId+") ORDER BY a.showorder, a.subcompanycode, a.subcompanyname";
}else if(shareType==4){
	roleId = shareIds.toString();
	sql = "select a.id, a.rolesmark name from HrmRoles a where a.id in ("+roleId+") ORDER BY a.rolesmark";
}

hrmId="";depId="";subId="";roleId="";

if(!"".equals(sql)){
	rs.executeSql(sql);
	while(rs.next()){
		if(shareType == 1){
			if(shownameHrm.length() > 0){
				shownameHrm.append(", ");
				hrmId+=",";
			}
			shownameHrm.append(Util.null2String(rs.getString("name")).trim());
			hrmId+=Util.null2String(rs.getString("id")).trim();
		}else if(shareType == 2){
			if(shownameDep.length() > 0){
				shownameDep.append(", ");
				depId+=",";
			}
			shownameDep.append(Util.null2String(rs.getString("name")).trim());
			depId+=Util.null2String(rs.getString("id")).trim();
		}else if(shareType == 3){
			if(shownameSub.length() > 0){
				shownameSub.append(", ");
				subId+=",";
			}
			shownameSub.append(Util.null2String(rs.getString("name")).trim());
			subId+=Util.null2String(rs.getString("id")).trim();
		}else if(shareType == 4){
			if(shownameRole.length() > 0){
				shownameRole.append(", ");
				roleId+=",";
			}
			shownameRole.append(Util.null2String(rs.getString("name")).trim());
			roleId+=Util.null2String(rs.getString("id")).trim();
		}
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSave(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		
<input class="inputstyle" type="hidden" id="fnaTmpTbLogId" name="fnaTmpTbLogId" value="<%=fnaTmpTbLogId %>" />
<input class="inputstyle" type="hidden" id="groupGuid1" name="groupGuid1" value="<%=groupGuid1 %>" />
<wea:layout type="2Col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item><!-- 对象类型 -->
		<wea:item>
			<select id='shareType' name='shareType' onchange='shareType_onchange();' style="width: 60px;float: left;">
				<option value="0" <%=shareType==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
				<option value="1" <%=shareType==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33451,user.getLanguage())%></option><!-- 人员 -->
				<option value="2" <%=shareType==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
				<option value="3" <%=shareType==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
				<option value="4" <%=shareType==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item><!-- 对象 -->
		<wea:item>
            <span id="spanHrmId" style="display: none;">
		        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fresourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
		                completeUrl="/data.jsp?type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
		                browserSpanValue='<%=shownameHrm.toString() %>' width="80%" >
		        </brow:browser>
		    </span>
            <span id="spanDepId" style="display: none;">
		        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fselecteds=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
		                completeUrl="/data.jsp?type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=shownameDep.toString() %>' width="80%" >
		        </brow:browser>
		    </span>
            <span id="spanSubId" style="display: none;">
		        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fselectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
		                completeUrl="/data.jsp?type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=shownameSub.toString() %>' width="80%" >
		        </brow:browser>
		    </span>
            <span id="spanRoleId" style="display: none;">
		        <brow:browser viewType="0" name="roleId" browserValue='<%=roleId %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("65")+"%3Fselectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2"
		                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(34190,user.getLanguage())%>'
		                browserSpanValue='<%=shownameRole.toString() %>' width="80%" >
		        </brow:browser>
		    </span>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></wea:item><!-- 安全级别 -->
		<wea:item>
			<input class="inputstyle" type="text" id="secLevel1" name="secLevel1" value="<%=secLevel1 %>" style="width: 50px;text-align: right;" />
			<span id="spanSecLevel">&nbsp;~&nbsp;</span>
			<input class="inputstyle" type="text" id="secLevel2" name="secLevel2" value="<%=secLevel2 %>" style="width: 50px;text-align: right;" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26137, user.getLanguage())%></wea:item><!-- 共享权限 -->
		<wea:item>
			<select id='shareLevel' name='shareLevel' style="width: 60px;float: left;">
				<option value="0" <%=shareLevel==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><!-- 查看 -->
				<option value="1" <%=shareLevel==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option><!-- 编辑 -->
			<%if(isFull){ %>
				<option value="2" <%=shareLevel==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option><!-- 完全控制 -->
			<%} %>
			</select>
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
	controlNumberCheck_jQuery("secLevel1", false, 0, false, 3);
	controlNumberCheck_jQuery("secLevel2", false, 0, false, 3);
	shareType_onchange();
});



function shareType_onchange(){
	var spanHrmIdObj = jQuery("#spanHrmId");
	var spanDepIdObj = jQuery("#spanDepId");
	var spanSubIdObj = jQuery("#spanSubId");
	var spanRoleIdObj = jQuery("#spanRoleId");

	spanHrmIdObj.hide();
	spanDepIdObj.hide();
	spanSubIdObj.hide();
	spanRoleIdObj.hide();

	jQuery("#secLevel1").show();
	jQuery("#secLevel2").show();
	jQuery("#spanSecLevel").show();
	
	var shareType = jQuery("#shareType").val();
	if(shareType=="1"){
		spanHrmIdObj.show();
		jQuery("#secLevel1").hide();
		jQuery("#secLevel2").hide();
		jQuery("#spanSecLevel").hide();
	}else if(shareType=="2"){
		spanDepIdObj.show();
	}else if(shareType=="3"){
		spanSubIdObj.show();
	}else if(shareType=="4"){
		spanRoleIdObj.show();
	}
}

function doSave(){
	var fnaTmpTbLogId = jQuery("#fnaTmpTbLogId").val();
	var groupGuid1 = jQuery("#groupGuid1").val();

	var shareType = jQuery("#shareType").val();
	
	var hrmId = jQuery("#hrmId").val();
	var depId = jQuery("#depId").val();
	var subId = jQuery("#subId").val();
	var roleId = jQuery("#roleId").val();

	var secLevel1 = jQuery("#secLevel1").val();
	var secLevel2 = jQuery("#secLevel2").val();
	var shareLevel = jQuery("#shareLevel").val();
	
	if(shareType=="1" && hrmId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33451,18019", user.getLanguage()) %>");
		return;
	}
	if(shareType=="2" && depId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("124,18019", user.getLanguage()) %>");
		return;
	}
	if(shareType=="3" && subId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("141,18019", user.getLanguage()) %>");
		return;
	}
	if(shareType=="4" && roleId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("122,18019", user.getLanguage()) %>");
		return;
	}
	
	var shareId = "";
	if(shareType=="1"){
		shareId = hrmId;
	}else if(shareType=="2"){
		shareId = depId;
	}else if(shareType=="3"){
		shareId = subId;
	}else if(shareType=="4"){
		shareId = roleId;
	}
	var rptTypeName = "<%=rptTypeName %>";
	var _data = "operation=FnaRptShareSave&rptTypeName="+encodeURI(rptTypeName)+"&fnaTmpTbLogId="+fnaTmpTbLogId+"&groupGuid1="+groupGuid1+
		"&shareType="+shareType+"&shareId="+shareId+"&secLevel1="+secLevel1+"&secLevel2="+secLevel2+"&shareLevel="+shareLevel;

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/report/common/FnaRptSaveOp.jsp",
		type : "post",
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(msg){ 
			try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			if(msg.flag){
				var parentWin = parent.getParentWindow(window);
				parentWin.hiddenSaveBtn();
				onCancel2();
			}else{
				alert(msg.erroInfo);
			}
		}
	});
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
</script>
</BODY>
</HTML>

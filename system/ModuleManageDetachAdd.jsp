<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.splitepage.transform.SptmForHR"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。

/*int userid=user.getUID();
String sqlUid = "select count(*) cnt from HrmResourceManager where id='"+userid+"' ";
rs.executeSql(sqlUid);
if(!rs.next() || rs.getInt("cnt") <= 0){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}*/

if(!HrmUserVarify.checkUserRight("HrmModuleManageDetach:Edit", user)){
  response.sendRedirect("/notice/noright.jsp");	
  return;
}
	
String roleId = Util.null2String(request.getParameter("id"));
String cmd ="new";
if(roleId.length()>0)cmd="edit";
String roleIdType = "1";
if(Util.getIntValue(roleId, 0) < 0){
	roleIdType = "2";
}

SptmForHR sptmForHR = new SptmForHR();

String browserRoleIds = "";
String browserHrmIds = "";
String shownameRoles = "";
String shownameHrms = "";

if ("1".equals(roleIdType)) {
	shownameRoles = sptmForHR.getModuleManageDetachAdmin(roleId, user.getLanguage()+"");
	browserRoleIds = roleId;
} else if ("2".equals(roleIdType)) {
	shownameHrms = sptmForHR.getModuleManageDetachAdmin(roleId, user.getLanguage()+"");
	browserHrmIds = roleId;
}

String subIds = "";
String sql = "select aa.subcompanyid from SysRoleSubcomRight aa where aa.roleid = "+Util.getIntValue(roleId, 0);
rs.executeSql(sql);
while(rs.next()){
	String _subId = Util.null2String(rs.getString("subcompanyid")).trim();
	if(!"".equals(subIds)){
		subIds+=",";
	}
	subIds+=_subId;
}

String shownameSubs = "";
if(Util.getIntValue(roleId, 0) != 0){
	shownameSubs = sptmForHR.getModuleManageDetachOrg(roleId, user.getLanguage()+"");
}

String detachable= "";
String hrmdetachable= "";
String wfdetachable= "";
String docdetachable= "";
String portaldetachable= "";
String cptdetachable= "";
String mtidetachable= "";

String appdetachable = "";

int dftsubcomid= 0;
int hrmdftsubcomid= 0;
int wfdftsubcomid= 0;
int docdftsubcomid= 0;
int portaldftsubcomid= 0;
int cptdftsubcomid= 0;
int mtidftsubcomid= 0;
rs.executeProc("SystemSet_Select","");
if(rs.next()){
	detachable= Util.null2String(rs.getString("detachable"));
	if("1".equals(detachable)){
		hrmdetachable= Util.null2String(rs.getString("hrmdetachable"));
		wfdetachable= Util.null2String(rs.getString("wfdetachable"));
		docdetachable= Util.null2String(rs.getString("docdetachable"));
		portaldetachable= Util.null2String(rs.getString("portaldetachable"));
		cptdetachable= Util.null2String(rs.getString("cptdetachable"));
		mtidetachable= Util.null2String(rs.getString("mtidetachable"));
	}
	
	appdetachable = Util.null2String(rs.getString("appdetachable"));
	
	dftsubcomid=Util.getIntValue(rs.getString("dftsubcomid"),0);
	hrmdftsubcomid=Util.getIntValue(rs.getString("hrmdftsubcomid"),0);
	wfdftsubcomid=Util.getIntValue(rs.getString("wfdftsubcomid"),0);
	docdftsubcomid=Util.getIntValue(rs.getString("docdftsubcomid"),0);
	portaldftsubcomid=Util.getIntValue(rs.getString("portaldftsubcomid"),0);
	cptdftsubcomid=Util.getIntValue(rs.getString("cptdftsubcomid"),0);
	mtidftsubcomid=Util.getIntValue(rs.getString("mtidftsubcomid"),0);
}

boolean b_hrmdetachable= false;
boolean b_wfdetachable= false;
boolean b_docdetachable= false;
boolean b_portaldetachable= false;
boolean b_cptdetachable= false;
boolean b_mtidetachable= false;

List rightidList = new ArrayList();
sql = "select aa.rightid from SystemRightRoles aa where aa.roleid = "+Util.getIntValue(roleId, 0);

rs.executeSql(sql);
while(rs.next()){
	String rightid = Util.getIntValue(rs.getString("rightid"))+"";
	rightidList.add(rightid);
}

if(rightidList.contains("22") || rightidList.contains("25")){
	b_hrmdetachable = true;//人力资源
}
if(rightidList.contains("91") || rightidList.contains("591")){
	b_wfdetachable= true;//工作流程
}
if(rightidList.contains("1") || rightidList.contains("10") || rightidList.contains("11")|| rightidList.contains("453")){
	b_docdetachable= true;//知识管理
}
if(rightidList.contains("599") || rightidList.contains("645")|| rightidList.contains("659")){
	b_portaldetachable= true;//门户管理
}
if(rightidList.contains("439")){
	b_cptdetachable= true;//资产管理
}
if(rightidList.contains("200") || rightidList.contains("350")){
	b_mtidetachable= true;//会议管理 
}

%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js"></script>
	</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("19049,24326", user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onAdd(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form method="post" name="weaver" action="ModuleManageDetachOperation.jsp">
<wea:layout type="2Col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("19049,1507", user.getLanguage())%></wea:item><!-- 模块管理员 -->
		<wea:item>
			<input id="roleId" name="roleId" value="<%=roleId %>" type="hidden" />
			<%
			String roleSel = "";
			String hrmSel = "";
			String roleDisplay = "none";
			String hrmDisplay = "none";
			if("".equals(roleId)){
				if(roleIdType.equals("1")){//角色
					roleSel = "selected";
					roleDisplay = "block";
				}else if(roleIdType.equals("2")){//人员
					hrmSel = "selected";
					hrmDisplay = "block";
				}
			%>
				<select id='roleIdType' name='roleIdType' onchange='roleIdType_onchange();' style="width: 40px;float: left;">
	                <option value=1 <%=roleSel%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
	                <option value=2 <%=hrmSel%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
				</select>
	            <span id="spanRoleId" style="display: <%=roleDisplay %>;">
			        <brow:browser viewType="0" name="roleIds" browserValue='<%=browserRoleIds %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(122,user.getLanguage())%>'
			                browserSpanValue='<%=shownameRoles %>' width="70%" >
			        </brow:browser>
			    </span>
	            <span id="spanHrmId" style="display: <%=hrmDisplay %>;">
			        <brow:browser viewType="0" name="hrmIds" browserValue='<%=browserHrmIds %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
			                browserSpanValue='<%=shownameHrms %>' width="70%" >
			        </brow:browser>
			    </span>
			<%}else{ 
				if(Util.getIntValue(roleId, 0) > 0){//角色
					roleSel = "selected";
					roleDisplay = "block";
					%><span style="width: 40px;float: left;"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></span>
					<input id="roleIdType" name="roleIdType" value="1" type="hidden" /><%=shownameRoles %><%
				}else if(Util.getIntValue(roleId, 0) < 0){//人员
					hrmSel = "selected";
					hrmDisplay = "block";
					%><span style="width: 40px;float: left;"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></span>
					<input id="roleIdType" name="roleIdType" value="2" type="hidden" /><%=shownameHrms %><%
				}
				%><input id="roleIds" name="roleIds" value="<%=browserRoleIds %>" type="hidden" />
				<input id="hrmIds" name="hrmIds" value="<%=browserHrmIds %>" type="hidden" /><%
			} %>
			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("33062", user.getLanguage())%></wea:item><!-- 组织机构 -->
		<wea:item>
		<%
		String url = new BrowserComInfo().getBrowserurl("194")+"?show_virtual_org=-1&selectedids=";
		%>
	        <brow:browser viewType="0" name="subIds" browserValue='<%=subIds %>' 
	                browserUrl='<%=url %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
	                browserSpanValue='<%=(shownameSubs) %>' width="89%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("633,19049", user.getLanguage())%></wea:item><!-- 管理模块 -->
		<wea:item>
				<!-- jNiceHidden -->
			<%if("1".equals(hrmdetachable)){ %>
				<input type="checkbox" value="1" id="chkHrm" name="chkHrm" <%=b_hrmdetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(179, user.getLanguage()) %><br /><!-- 人力资源 -->
			<%}else{%>
				<input type="hidden" value="<%=b_hrmdetachable?"1":"" %>" id="chkHrm" name="chkHrm"/>
			<%}if("1".equals(wfdetachable)){ %>
				<input type="checkbox" value="1" id="chkWf" name="chkWf" <%=b_wfdetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(2118, user.getLanguage()) %><br /><!-- 工作流程 -->
			<%}else{%>
				<input type="hidden" value="<%=b_wfdetachable?"1":"" %>" id="chkWf" name="chkWf"/>
			<%}if("1".equals(docdetachable)){ %>
				<input type="checkbox" value="1" id="chkDoc" name="chkDoc" <%=b_docdetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(2115, user.getLanguage()) %><br /><!-- 知识管理 -->
			<%}else{

			%>
				<input type="hidden" value="<%=b_docdetachable?"1":"" %>" id="chkDoc" name="chkDoc"/>
			<%}if("1".equals(portaldetachable)){ %>
				<input type="checkbox" value="1" id="chkPortal" name="chkPortal" <%=b_portaldetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(20613, user.getLanguage()) %><br /><!-- 门户管理 -->
			<%}else{%>
				<input type="hidden" value="<%=b_portaldetachable?"1":"" %>" id="chkPortal" name="chkPortal"/>
			<%}if("1".equals(cptdetachable)){ %>
				<input type="checkbox" value="1" id="chkCpt" name="chkCpt" <%=b_cptdetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(2116, user.getLanguage()) %><br /><!-- 资产管理 -->
			<%}else{%>
				<input type="hidden" value="<%=b_cptdetachable?"1":"" %>" id="chkCpt" name="chkCpt"/>
			<%}if("1".equals(mtidetachable)){ %>
				<input type="checkbox" value="1" id="chkMti" name="chkMti" <%=b_mtidetachable?"checked":"" %> /><%=SystemEnv.getHtmlLabelNames("2103,633", user.getLanguage()) %><br /><!-- 会议管理  -->
			<%}else{%>
				<input type="hidden" value="<%=b_mtidetachable?"1":"" %>" id="chkMti" name="chkMti"/>
			<%} %>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
		    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	jQuery("body").jNice();
	roleIdType_onchange();
});
	
//type:1.人员 2. 分部 3.部门 4.角色
//sourcetype:
function onAdd(){
	var roleId=jQuery("#roleId").val();
	var roleIdType=jQuery("#roleIdType").val();
	var roleIds=jQuery("#roleIds").val();
	var hrmIds=jQuery("#hrmIds").val();
	var subIds=jQuery("#subIds").val();
	
	var chkHrm=jQuery("#chkHrm").attr("checked")?"1":"";
	if(jQuery("#chkHrm").attr("type")=="hidden")chkHrm=jQuery("#chkHrm").val();
	var chkWf=jQuery("#chkWf").attr("checked")?"1":"";
	if(jQuery("#chkWf").attr("type")=="hidden")chkWf=jQuery("#chkWf").val();
	var chkDoc=jQuery("#chkDoc").attr("checked")?"1":"";
	if(jQuery("#chkDoc").attr("type")=="hidden")chkDoc=jQuery("#chkDoc").val();
	var chkPortal=jQuery("#chkPortal").attr("checked")?"1":"";
	if(jQuery("#chkPortal").attr("type")=="hidden")chkPortal=jQuery("#chkPortal").val();
	var chkCpt=jQuery("#chkCpt").attr("checked")?"1":"";
	if(jQuery("#chkCpt").attr("type")=="hidden")chkCpt=jQuery("#chkCpt").val();
	var chkMti=jQuery("#chkMti").attr("checked")?"1":"";
	if(jQuery("#chkMti").attr("type")=="hidden")chkMti=jQuery("#chkMti").val();
	if((roleIdType=="1" && roleIds=="") || roleIdType=="2" && hrmIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>");//必填信息不完整!
		return false ;
	}
	var _data = "operation=save&cmd=<%=cmd%>&roleId="+uescape(roleId)+"&roleIdType="+uescape(roleIdType)+"&roleIds="+uescape(roleIds)+"&hrmIds="+uescape(hrmIds)+"&subIds="+uescape(subIds)+
		"&chkHrm="+uescape(chkHrm)+"&chkWf="+uescape(chkWf)+"&chkDoc="+uescape(chkDoc)+
		"&chkPortal="+uescape(chkPortal)+"&chkCpt="+uescape(chkCpt)+"&chkMti="+uescape(chkMti);
	jQuery.ajax({
		url : "/system/ModuleManageDetachOperation.jsp",
		type : "post",
		async : true,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(msg){ 
			if(msg.flag){
				var parentWin = parent.getParentWindow(window);
				var dialog = parent.getDialog(parentWin);
				parentWin.onBtnSearchClick();
				onCancel2();
			}else{
				top.Dialog.alert(msg.msg);
			}
		}
	});
}

function roleIdType_onchange(){
	var _roleIdType = jQuery("#roleIdType");
	jQuery("#spanRoleId").hide();
	jQuery("#spanHrmId").hide();

	var roleIdType = _roleIdType.val();
	if(roleIdType=="1"){
		jQuery("#spanRoleId").show();
	}else if(roleIdType=="2"){
		jQuery("#spanHrmId").show();
	}
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

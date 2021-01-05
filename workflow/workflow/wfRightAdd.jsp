<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.splitepage.transform.SptmForHR"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
SptmForHR sptmForHR = new SptmForHR();

int userid=user.getUID();

String pkcol = Util.null2String(request.getParameter("id"));
int permissiontype = 2;
String sysadmin = "";

String pkColSqlStr = "CONVERT(VARCHAR, CASE WHEN (permissiontype=2) then roleid ELSE userid END)+'_'+CONVERT(VARCHAR, permissiontype)+";
if("oracle".equalsIgnoreCase(rs.getDBType())){
	pkColSqlStr = "to_char(CASE WHEN (permissiontype=2) then roleid ELSE userid END)||'_'||to_char(permissiontype)||";
}
String backfields = " * ";
String fromSql = " from (\n" +
		"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol, 0 tbType \n" +
		"	from wfAccessControlList \n" +
		" ) t1 \n";
String sqlWhere = " where pkcol = '"+StringEscapeUtils.escapeSql(pkcol)+"'";

String browserRoleIds = "";
String browserHrmIds = "";
String shownameRoles = "";
String shownameHrms = "";

String Workflowids = "";
String Workflownames = "";
String Docids = "";
String Docnames = "";
String Portalids = "";
String Portalnames = "";
String Coworkids = "";
String Coworknames = "";

String sql = "select "+backfields+" "+fromSql+" "+sqlWhere;
rs.executeSql(sql);
while(rs.next()){
	permissiontype = rs.getInt("permissiontype");
	sysadmin = Util.null2String(rs.getString("sysadmin")).trim();
	int dataOrder = Util.getIntValue("");
	int tbType = rs.getInt("tbType");
	
	String otherpara = permissiontype+"+"+sysadmin+"+"+dataOrder+"+"+user.getLanguage();

	if("".equals(browserRoleIds) && "".equals(browserHrmIds)){
		if (permissiontype==2) {
			shownameRoles = sptmForHR.getFunSysadmin(pkcol, otherpara);
			browserRoleIds = sysadmin;
		} else if (permissiontype==5) {
			shownameHrms = sptmForHR.getFunSysadmin(pkcol, otherpara);
			browserHrmIds = sysadmin;
		}
	}
	
	if(tbType==0){
		Workflowids = sptmForHR.getWorkflowids2(otherpara);
		Workflownames = sptmForHR.getWorkflowids(pkcol, otherpara);
		
	}else if(tbType==1){
		Docids = sptmForHR.getDocids2(otherpara);
		Docnames = sptmForHR.getDocids(pkcol, otherpara);
		
	}else if(tbType==2){
		Portalids = sptmForHR.getPortalids2(otherpara);
		Portalnames = sptmForHR.getPortalids(pkcol, otherpara);
		
	}else if(tbType==3){
		Coworkids = sptmForHR.getCoworkids2(otherpara);
		Coworknames = sptmForHR.getCoworkids(pkcol, otherpara);
		
	}
}

%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js"></script>
	</head>
<%
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onAdd(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33808, user.getLanguage())%>"/>
	</jsp:include>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td>
			<td class="rightSearchSpan" style="text-align: right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd();">
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

	<wea:layout type="2Col" >
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelNames("33381,1507", user.getLanguage())%></wea:item><!-- 功能管理员 -->
			<wea:item>
				<%
				String roleSel = "";
				String hrmSel = "";
				String roleDisplay = "none";
				String hrmDisplay = "none";
				if("".equals(pkcol)){
					if(permissiontype==2){//角色
						roleSel = "selected";
						roleDisplay = "block";
					}else if(permissiontype==5){//人员
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
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids=#id#"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
				                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(122,user.getLanguage())%>'
				                browserSpanValue='<%=shownameRoles %>' width="74%" >
				        </brow:browser>
				    </span>
		            <span id="spanHrmId" style="display: <%=hrmDisplay %>;">
				        <brow:browser viewType="0" name="hrmIds" browserValue='<%=browserHrmIds %>' 
				                browserUrl='<%=new BrowserComInfo().getBrowserurl("1") %>'
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
				                completeUrl="/data.jsp?type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
				                browserSpanValue='<%=shownameHrms %>' width="74%" >
				        </brow:browser>
				    </span>
				<%}else{ 
					if(permissiontype==2){//角色
						roleSel = "selected";
						roleDisplay = "block";
						%><span style="width: 40px;float: left;"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></span>
						<input id="roleIdType" name="roleIdType" value="1" type="hidden" /><%=shownameRoles %><%
					}else if(permissiontype==5){//人员
						hrmSel = "selected";
						hrmDisplay = "block";
						%><span style="width: 40px;float: left;"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></span>
						<input id="roleIdType" name="roleIdType" value="2" type="hidden" /><%=shownameHrms %><%
					}
					%><input id="roleIds" name="roleIds" value="<%=browserRoleIds %>" type="hidden" />
					<input id="hrmIds" name="hrmIds" value="<%=browserHrmIds %>" type="hidden" /><%
				} %>
				
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("33378",user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 赋权设置 -->
			<wea:item><%=SystemEnv.getHtmlLabelNames("18499,33439", user.getLanguage())%></wea:item><!-- 工作流类型 -->
			<wea:item>
		        <brow:browser viewType="0" name="workflowids" browserValue='<%=Workflowids %>' 
		        	 browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids=" 
		        	 idKey="id" nameKey="name"  hasInput="true" width="92%" isSingle="false" 
		        	 hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=workflowBrowser&wfRightAdd=1"  
		        	 browserSpanValue='<%=(Workflownames) %>'>
		        </brow:browser>
			</wea:item>
		</wea:group>
	</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
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
	roleIdType_onchange();
});
	
//type:1.人员 2. 分部 3.部门 4.角色
//sourcetype:
function onAdd(){
	var roleIdType=jQuery("#roleIdType").val();
	var roleIds=jQuery("#roleIds").val();
	var hrmIds=jQuery("#hrmIds").val();
	
	var workflowids=jQuery("#workflowids").val();
	var docids=jQuery("#docids").val();
	var portalids=jQuery("#portalids").val();
	var coworkids=jQuery("#coworkids").val();
	
	if((roleIdType=="1" && roleIds=="")||(roleIdType=="2" && hrmIds=="")||workflowids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");//必填信息不完整!
		return false ;
	}
	
	var _data = "operation=save&roleIdType="+uescape(roleIdType)+"&roleIds="+uescape(roleIds)+"&hrmIds="+uescape(hrmIds)+"&workflowids="+uescape(workflowids)+
		"&docids="+uescape(docids)+"&portalids="+uescape(portalids)+"&coworkids="+uescape(coworkids)+"&replaceworkflow=<%=!"".equals(pkcol)%>";
	jQuery.ajax({
		url : "/system/EffectManageEmpowerOperation.jsp",
		type : "post",
		/*async : false,*/
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(msg){ 
			var pw = parent.getParentWindow(window);
			pw.location = pw.location;

			parent.getDialog(window).close();
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

//关闭
function doClose(){
	parent.getDialog(window).close();
}
</script>
	</BODY>
</HTML>

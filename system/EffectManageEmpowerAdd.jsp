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
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
/*int userid=user.getUID();
String sqlUid = "select count(*) cnt from HrmResourceManager where id="+userid;
rs.executeSql(sqlUid);
if(!rs.next() || rs.getInt("cnt") <= 0){
   response.sendRedirect("/notice/noright.jsp");	
   return;
}*/

if(!HrmUserVarify.checkUserRight("HrmEffectManageEmpower:Edit", user)){
  response.sendRedirect("/notice/noright.jsp");	
  return;
}

SptmForHR sptmForHR = new SptmForHR();


String pkcol = Util.null2String(request.getParameter("id"));
int permissiontype = 2;
String sysadmin = "";

String pkColSqlStr = "CONVERT(VARCHAR, CASE WHEN (permissiontype=2) then roleid ELSE userid END)+'_'+CONVERT(VARCHAR, permissiontype)+";
if("oracle".equalsIgnoreCase(rs.getDBType())){
	pkColSqlStr = "to_char(CASE WHEN (permissiontype=2) then roleid ELSE userid END)||'_'||to_char(permissiontype)||";
}

String pkColSqlStr4 = "CONVERT(VARCHAR,sharevalue)+'_'+CONVERT(VARCHAR, case when (sharetype=1) then 5 else 2 end)+";
if("oracle".equalsIgnoreCase(rs.getDBType())){
   pkColSqlStr4 = "to_char(sharevalue)||'_'||to_char(case when (sharetype=1) then 5 else 2 end)||";
}

String shareValue = "sharevalue";
if("oracle".equalsIgnoreCase(rs.getDBType())){
	shareValue = "to_number(sharevalue)";
}

String backfields = " * ";
String fromSql = " from (\n" +
		"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol, 0 tbType \n" +
		"	from wfAccessControlList \n" +
		"	where  dirtype = 0 \n" +
		"	and operationcode = 1 \n" +
		"	and permissiontype in (2, 5) \n" +
		"	UNION \n" +
		"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol, 1 tbType \n" +
		"	from DirAccessControlList \n" +
		"	where  dirtype = 2 \n" +
		"	and operationcode = 1 \n" +
		"	and permissiontype in (2, 5) \n" +
		"	UNION \n" +
		"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol, 2 tbType \n" +
		"	from ptAccessControlList \n" +
		"	where  dirtype = 0 \n" +
		"	and operationcode = 1 \n" +
		"	and permissiontype in (2, 5) \n" +
		//"	UNION \n" +
		//"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol, 3 tbType \n" +
		//"	from cwAccessControlList \n" +
		//"	where  dirtype = 0 \n" +
		//"	and operationcode = 1 \n" +
		//"	and permissiontype in (2, 5)\n" +
		
		 "	UNION \n" +
		 "	select DISTINCT case when (sharetype=1) then 5 else 2 end as permissiontype,  "+shareValue+" as sysadmin, "+pkColSqlStr4+"'' pkcol, 3 tbType \n" +
		 "	from cotype_sharemanager \n" +
		 "	where  sharetype in (1, 4) \n" +		
		
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
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js"></script>
	</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("18361,33378", user.getLanguage());
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
		<wea:item><%=SystemEnv.getHtmlLabelNames("15433", user.getLanguage())%></wea:item><!-- 工作流类型 -->
		<wea:item>
	        <brow:browser viewType="0" name="workflowids" browserValue='<%=Workflowids %>' 
	                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids=" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=workflowBrowser"  temptitle='<%= SystemEnv.getHtmlLabelNames("15433",user.getLanguage())%>'
	                browserSpanValue='<%=(Workflownames) %>' width="89%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("26268,92", user.getLanguage())%></wea:item><!-- 知识目录 -->
		<wea:item>
	        <brow:browser viewType="0" name="docids" browserValue='<%=Docids %>' 
	                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/docs/category/DocMainCategoryMutiBrowser.jsp?mainCategoryIds=" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=categoryBrowser&onlySec=true"  temptitle='<%= SystemEnv.getHtmlLabelNames("26268,92",user.getLanguage())%>'
	                browserSpanValue='<%=(Docnames) %>' width="89%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("582", user.getLanguage())%></wea:item><!-- 门户 -->
		<wea:item>
	        <brow:browser viewType="0" name="portalids" browserValue='<%=Portalids %>' 
	                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/portal/HpinfoMutiBrowser.jsp?hpinfoIds=" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=HpinfoMutiBrowser"  temptitle='<%= SystemEnv.getHtmlLabelNames("582",user.getLanguage())%>'
	                browserSpanValue='<%=(Portalnames) %>' width="89%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("17855,34242", user.getLanguage())%></wea:item><!-- 协作区 -->
		<wea:item>
	        <brow:browser viewType="0" name="coworkids" browserValue='<%=Coworkids %>' 
	                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/cowork/MutiCoworkTypeBrowser.jsp?coworkTypeIds=" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=coworktype"  temptitle='<%=SystemEnv.getHtmlLabelNames("17855,34242", user.getLanguage())%>'
	                browserSpanValue='<%=(Coworknames) %>' width="89%" >
	        </brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
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
	
	if((roleIdType=="1" && roleIds=="") || roleIdType=="2" && hrmIds==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>");//必填信息不完整!
		return false ;
	}
	
	var _data = "operation=save&roleIdType="+uescape(roleIdType)+"&roleIds="+uescape(roleIds)+"&hrmIds="+uescape(hrmIds)+"&workflowids="+uescape(workflowids)+
		"&docids="+uescape(docids)+"&portalids="+uescape(portalids)+"&coworkids="+uescape(coworkids);
	jQuery.ajax({
		url : "/system/EffectManageEmpowerOperation.jsp",
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

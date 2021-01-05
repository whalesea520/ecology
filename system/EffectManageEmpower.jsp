<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
/*
int userid=user.getUID();
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(446, user.getLanguage());
String needfav = "1";
String needhelp = "";
String qname = Util.null2String(request.getParameter("flowTitle"));
String roleids = Util.null2String(request.getParameter("roleids"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String id="";
%>
<HTML>
	<HEAD>
</head>
<BODY>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365, user.getLanguage())+",javascript:addNew(),_self}";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136, user.getLanguage())+",javascript:batchDel(),_self}";
RCMenuHeight += RCMenuHeightStep;
/*
if(HrmUserVarify.checkUserRight("FnaYearsPeriods:Log",user)) {
	if(rs.getDBType().equals("db2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) =37 and relatedid="+user.getLoginid()+",_self} " ;   
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =37 and relatedid="+user.getLoginid()+",_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep ;	
}*/
%>


<script type="text/javascript">
//关闭
function doClose1(){
	window.closeDialog();
}

function onBtnSearchClick(cmd){
	if(cmd==1)document.getElementById("flowTitle").value="";
	document.getElementById("frmmain").submit();
}

function addNew(){
	_fnaOpenDialog("/system/EffectManageEmpowerAdd.jsp", 
			"<%=SystemEnv.getHtmlLabelNames("365,18361,33378", user.getLanguage()) %>", 
			550, 450);
}

function doEdit(id){
	_fnaOpenDialog("/system/EffectManageEmpowerAdd.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelNames("93,18361,33378", user.getLanguage()) %>", 
			550, 450);
}
	
function doDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			jQuery.ajax({
				url : "/system/EffectManageEmpowerOperation.jsp",
				type : "post",
				async : true,
				processData : false,
				data : "operation=delete&id="+id,
				dataType : "json",
				success: function do4Success(msg){ 
					if(msg.flag){
						onBtnSearchClick();
					}else{
						top.Dialog.alert(msg.msg);
					}
				}
			});
		}, function(){}
	);
}

//批量删除
function batchDel(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDelete&ids="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			jQuery.ajax({
				url : "/system/EffectManageEmpowerOperation.jsp",
				type : "post",
				async : true,
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(msg){
					if(msg.flag){
						onBtnSearchClick();
					}else{
						top.Dialog.alert(msg.msg);
					}
				}
			});	
		}, function(){}
	);
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form class=ViewForm id="frmmain" action="/system/EffectManageEmpower.jsp" method="post">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
				<!-- 
					<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>" />
				 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" 
						class="e8_btn_top" onclick="addNew();"/><!-- 新建 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" 
						class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
						<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="roleids" browserValue="<%=roleids %>" 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids=#id#"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
            completeUrl="/data.jsp?type=65"  temptitle="<%= SystemEnv.getHtmlLabelName(122,user.getLanguage())%>"
            browserSpanValue="<%=rolesComInfo.getRolesRemark(roleids) %>" width="74%" >
	        </brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="resourceids" browserValue="<%=resourceids %>" 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids=#id#"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
            completeUrl="/data.jsp?type=17"  temptitle="<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>"
            browserSpanValue="<%=resourceComInfo.getLastname(resourceids) %>" width="74%" >
	        </brow:browser>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick(1);"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
<%
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
			"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol \n" +
			"	from wfAccessControlList \n" +
			"	where  dirtype = 0 \n" +
			"	and operationcode = 1 \n" +
			"	and permissiontype in (2, 5) \n" +
			"	UNION \n" +
			"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol \n" +
			"	from DirAccessControlList \n" +
			"	where  dirtype = 2 \n" +
			"	and operationcode = 1 \n" +
			"	and permissiontype in (2, 5) \n" +
			"	UNION \n" +
			"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol \n" +
			"	from ptAccessControlList \n" +
			"	where  dirtype = 0 \n" +
			"	and operationcode = 1 \n" +
			"	and permissiontype in (2, 5) \n" +
			//"	UNION \n" +
			//"	select DISTINCT permissiontype, CASE WHEN (permissiontype=2) then roleid ELSE userid END sysadmin, "+pkColSqlStr+"'' pkcol \n" +
			//"	from cwAccessControlList \n" +
			//"	where  dirtype = 0 \n" +
			//"	and operationcode = 1 \n" +
			//"	and permissiontype in (2, 5)\n" +
			
			"	UNION \n" +
			"	select DISTINCT case when (sharetype=1) then 5 else 2 end as permissiontype,  "+shareValue+" as sysadmin, "+pkColSqlStr4+"'' pkcol \n" +
			"	from cotype_sharemanager \n" +
			"	where  sharetype in (1, 4) \n" +	
							
			" ) t1, hrmresource h \n";
	String sqlWhere = " where 1=1 and h.id=t1.sysadmin and h.status in(0,1,2,3) ";
	
	String sysadminField = "sysadmin" ;
	if("oracle".equalsIgnoreCase(rs.getDBType())){
		sysadminField = "to_number(sysadmin)" ;
	}
		
	if(roleids.length()>0){
		sqlWhere += " and permissiontype=2 and "+sysadminField+" in ("+roleids+") ";
	}
	
	if(resourceids.length()>0){
		sqlWhere += " and permissiontype=5 and "+sysadminField+" in ("+resourceids+") ";
	}
	
	if(qname.length()>0){
		sqlWhere += " and ( (permissiontype=2 and "+sysadminField+" in (select id from hrmroles where rolesname like '%"+qname+"%' or rolesmark like '%"+qname+"%')) "+
				" or (permissiontype=5 and "+sysadminField+" in (select id from hrmresource where lastname like '%"+qname+"%' )))";
	}
	
	String orderby = "permissiontype,sysadmin";
	String tableString = "";

	//out.println("select "+backfields+" "+fromSql+" "+sqlWhere+" order by "+orderby);
	tableString = "<table instanceid=\""+PageIdConst.Hrm_EffectManageEmpower+"\" tabletype=\"checkbox\"   pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_EffectManageEmpower,user.getUID(),PageIdConst.HRM)+"\" >"+
					"<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+"\" "+
					" sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\"  sqlprimarykey=\"pkcol\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
					"<head>"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1867, user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(122, user.getLanguage())+"）\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getDetachType\" />"+//类型（人员/角色） 
						"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("33381,1507", user.getLanguage())+"\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getFunSysadmin\" />"+//功能管理员 
						"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("15433", user.getLanguage())+"\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getWorkflowids\" />"+//工作流类型
						"<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("26268,92", user.getLanguage())+"\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getDocids\" />"+//知识目录
						"<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("582", user.getLanguage())+"\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getPortalids\" />"+//门户
						"<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("17694", user.getLanguage())+"\" column=\"pkcol\" orderkey=\"pkcol\""+
							" otherpara=\"column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getCoworkids\" />"+//协作区
					"</head>"+
					"<operates>"+
						//"<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaYearsPeriods_popedom\" otherpara=\"column:status\" ></popedom> "+
						"<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+//编辑
						"<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+//删除
					"</operates>"+
				"</table>";
%>
 			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_EffectManageEmpower %>"/>
			<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
		</form>
	</BODY>
</HTML>


	
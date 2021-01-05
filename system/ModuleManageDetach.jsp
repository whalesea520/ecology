<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
/*
int userid=user.getUID();
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

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(446, user.getLanguage());
String needfav = "1";
String needhelp = "";
String qname = Util.null2String(request.getParameter("flowTitle"));
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
if(HrmUserVarify.checkUserRight("FnaYearsPeriods:Log",user)) {
	if(rs.getDBType().equals("db2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;   
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep ;	
}
%>


<script type="text/javascript">
function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=where operateitem=167 and relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=where operateitem=167";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}

//关闭
function doClose1(){
	window.closeDialog();
}

function onBtnSearchClick(){
	document.getElementById("frmmain").submit();
}

function addNew(){
	_fnaOpenDialog("/system/ModuleManageDetachAdd.jsp", 
			"<%=SystemEnv.getHtmlLabelNames("365,19049,24326", user.getLanguage()) %>", 
			450, 390);
}

function doEdit(id){
	_fnaOpenDialog("/system/ModuleManageDetachAdd.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelNames("93,19049,24326", user.getLanguage()) %>", 
			450, 390);
}
	
function doDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			jQuery.ajax({
				url : "/system/ModuleManageDetachOperation.jsp",
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
				url : "/system/ModuleManageDetachOperation.jsp",
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
	<form class=ViewForm id="frmmain" action="/system/ModuleManageDetach.jsp" method="post">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" 
						class="e8_btn_top" onclick="addNew();"/><!-- 新建 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" 
						class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<%
	//文档相关权限(1, 10, 11, 453,)
	//DocMainCategory:ALL rightid=1
	//DocMould:ALL rightid=10
	//DocMould:ALL rightid=10
	//DocFrontpage:ALL rightid=11
	//WebMagazine:Main rightid=453
	
	String backfields = " * ";
	String fromSql = " from (\n" +
			" select distinct a.roleid, case when a.roleid > 0 then 0 else 1 end ordKey \n" +
			" from systemrightroles a \n" +
		//	" where a.rightid in (22, 25, 91, 591, 10,11,453,599, 645,659, 439, 200, 350) and a.roleid <> 0 \n" +
			" where a.rightid in (22, 25, 91, 591, 8, 10, 11, 453, 645, 659, 439, 200, 350) and a.roleid <> 0 \n" +
		" ) t1 ";
	String sqlWhere = "";
	String orderby = "ordKey";
	String tableString = "";

	if (!"".equals(qname)) {
		sqlWhere += " where ( ";
		sqlWhere += " 	( "+
					" 		exists ("+
					"			select 1 from hrmrolemembers aa "+
					"			join HrmResource bb on aa.resourceid = bb.id "+
					" 			where aa.roleid = t1.roleid and ( bb.lastname like '%" + StringEscapeUtils.escapeSql(qname) + "%' or bb.lastname like '%" + StringEscapeUtils.escapeSql(qname) + "%' ) "+
					"		) "+
					"		and "+
					"		(t1.roleid < 0) "+
					" 	) or ( ";
		sqlWhere += " 		exists ( "+
					"			select 1 from HrmRoles aa "+
					" 			where aa.id = t1.roleid and ( aa.rolesmark like '%" + StringEscapeUtils.escapeSql(qname) + "%' or aa.rolesname like '%" + StringEscapeUtils.escapeSql(qname) + "%' ) "+
					"		) "+
					"		and "+
					"		(t1.roleid > 0) "+
					" 	) ";
		sqlWhere += " ) ";
	}
	
	//out.println("select "+backfields+" "+fromSql+" "+sqlWhere+" order by "+orderby);
	tableString =" <table pageId=\""+PageIdConst.Hrm_decentralizedmanagement+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_decentralizedmanagement,user.getUID(),PageIdConst.HRM)+"\" >"+
					"<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+"\" "+
					" sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\"  sqlprimarykey=\"roleid\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
					"<head>"+
						"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1867, user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(122, user.getLanguage())+"）\" column=\"roleid\" orderkey=\"roleid\""+
							" otherpara=\""+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getModuleManageDetachType\" />"+//类型（人员/角色） 
						"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("19049,1507", user.getLanguage())+"\" column=\"roleid\" orderkey=\"roleid\""+
							" otherpara=\""+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getModuleManageDetachAdmin\" />"+//模块管理员 
						"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("33062", user.getLanguage())+"\" column=\"roleid\" orderkey=\"roleid\""+
							" otherpara=\""+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getModuleManageDetachOrg\" />"+//组织机构
						"<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("633,19049", user.getLanguage())+"\" column=\"roleid\" orderkey=\"roleid\""+
							" otherpara=\""+user.getLanguage()+"\" "+
							" transmethod=\"weaver.splitepage.transform.SptmForHR.getModuleManageDetachMod\" />"+//管理模块
					"</head>"+
					"<operates>"+
						//"<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaYearsPeriods_popedom\" otherpara=\"column:status\" ></popedom> "+
						"<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+//编辑
						"<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+//删除
					"</operates>"+
				"</table>";
%>			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_decentralizedmanagement %>"/>
			<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
		</form>
	</BODY>
</HTML>



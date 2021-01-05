<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@page import="weaver.splitepage.transform.SptmForHR"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(446, user.getLanguage());
String needfav = "1";
String needhelp = "";

String type1 = Util.null2String(request.getParameter("type1"),"1");

String nameq = Util.null2String(request.getParameter("nameq"));
String qname = Util.null2String(request.getParameter("flowTitle"));

if(qname.length()>0&&nameq.length()==0)nameq=qname;
String name = Util.null2String(request.getParameter("name"));

if(qname.length()==0 && name.length()>0)qname = name;
if(name.length()==0&&qname.length()>0)name=qname;

String description = Util.null2String(request.getParameter("description"));

String hrmId = Util.null2String(request.getParameter("hrmId"));
String subId = Util.null2String(request.getParameter("subId"));
String depId = Util.null2String(request.getParameter("depId"));
String roleId = Util.null2String(request.getParameter("roleId"));

String userSql = "",subSql = "", deptSql = "", roleSql = "";
if (!"".equals(hrmId)) {
	String[] userids = hrmId.split(",");
	for(int i =0;i<userids.length;i++){
		if("oracle".equals(RecordSet.getDBType())){
			userSql += "or ','||content||',' like '%,"+userids[i]+",%' ";
		}else{
			userSql += "or ','+content+',' like '%,"+userids[i]+",%' ";
		}
	}
	if(userSql.length() > 0){
		userSql = userSql.substring(2);
	}
}
	 
if (!"".equals(subId)) {
	String[] subidss = subId.split(",");
	for(int i =0;i<subidss.length;i++){
		if("oracle".equals(RecordSet.getDBType())){
			subSql += "or ','||content||',' like '%,"+subidss[i]+",%' ";
		}else{
			subSql += "or ','+content+',' like '%,"+subidss[i]+",%' ";
		}
	}
	if(subSql.length() > 0){
		subSql = subSql.substring(2);
	}
} 

if (!"".equals(depId)) {

	String[] departmentids = depId.split(",");
	for(int i =0;i<departmentids.length;i++){
		if("oracle".equals(RecordSet.getDBType())){
			deptSql += "or ','||content||',' like '%,"+departmentids[i]+",%' ";
		}else{
			deptSql += "or ','+content+',' like '%,"+departmentids[i]+",%' ";
		}
	}
	if(deptSql.length() > 0){
		deptSql = deptSql.substring(2);
	}
} 

if (!"".equals(roleId)) {

	String[] roleids = roleId.split(",");
	for(int i =0;i<roleids.length;i++){
		if("oracle".equals(RecordSet.getDBType())){
			roleSql += "or ','||content||',' like '%,"+roleids[i]+",%' ";
		}else{
			roleSql += "or ','+content+',' like '%,"+roleids[i]+",%' ";
		}
	}
	if(roleSql.length() > 0){
		roleSql = roleSql.substring(2);
	}
} 

SptmForHR sptmForHR = new SptmForHR();

String shownameHrm = "";
String shownameDep = "";
String shownameSub = "";
String shownameRole = "";

if ("1".equals(type1)) {
	shownameHrm = sptmForHR.getContent(hrmId, type1);
} else if ("2".equals(type1)) {
	shownameSub = sptmForHR.getContent(subId, type1);
} else if ("3".equals(type1)) {
	shownameDep = sptmForHR.getContent(depId, type1);
} else if ("4".equals(type1)) {
	shownameRole = sptmForHR.getContent(roleId, type1);
}
	
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
%>


<script type="text/javascript">

function setKeyword(source,target,formId){
	jQuery("#"+target).val(jQuery("#"+source).val());
}
//关闭
function doClose1(){
	window.closeDialog();
}

function onBtnSearchClick(){
	document.getElementById("frmmain").submit();
}

function addNew(){
	_fnaOpenDialog("/system/sysdetach/AppDetachAdd.jsp", 
			"<%=SystemEnv.getHtmlLabelNames("365,33062,24327", user.getLanguage()) %>", 
			450, 200);
}

function doEdit(id, para2, para3, _type, parentWin){
	if(_type==null){
		_type = 0;
	}
	if(parentWin!=null){
		doClose1();
		onBtnSearchClick();
	}
	_fnaOpenDialog("/system/sysdetach/AppDetachEdit.jsp?id="+id+"&_type="+_type, 
			"<%=SystemEnv.getHtmlLabelNames("93,33062,24327", user.getLanguage()) %>", 
			600, 490);
}
	
function doDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			jQuery.ajax({
				url : "/system/sysdetach/AppDetachOperation.jsp",
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
				url : "/system/sysdetach/AppDetachOperation.jsp",
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
jQuery(function(){
	type1_onchange(1);
});

function type1_onchange(from){
 	if("1" != from){
		jQuery($GetEle("hrmId")).val("");
		jQuery($GetEle("subId")).val("");
		jQuery($GetEle("depId")).val("");
		jQuery($GetEle("roleId")).val("");
 	}
 	
	var _type1 = jQuery("#type1");
	jQuery("#spanHrmId").hide();
	jQuery("#spanSubId").hide();
	jQuery("#spanDepId").hide();
	jQuery("#spanRoleId").hide();

	_type1.parent().parent().next().hide();
	_type1.parent().parent().next().next().hide();

	_type1.parent().parent().next().next().next().hide();
	_type1.parent().parent().next().next().next().next().hide();
	
	var type1 = _type1.val();
	if(type1=="1"){
		jQuery("#spanHrmId").show();
	}else if(type1=="2"){
		jQuery("#spanSubId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
	}else if(type1=="3"){
		jQuery("#spanDepId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
	}else if(type1=="4"){
		jQuery("#spanRoleId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
		_type1.parent().parent().next().next().next().show();
		_type1.parent().parent().next().next().next().next().show();
	}
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" 
						class="e8_btn_top" onclick="addNew();"/><!-- 新建 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" 
						class="e8_btn_top" onclick="batchDel()"/><!-- 批量删除 -->
					<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname%>"  onchange="setKeyword('flowTitle','name','frmmain');" />
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
	<form class=ViewForm id="frmmain" name="frmmain" action="/system/sysdetach/AppDetachList.jsp" method="post">
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="name" name="name" class="inputStyle" value='<%=name%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="description" name="description" class="inputStyle" value=<%=description%>></wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
						<wea:item>
							<%
				String hrmSel = "";
				String subSel = "";
				String depSel = "";
				String roleSel = "";
				String hrmDisplay = "none";
				String subDisplay = "none";
				String depDisplay = "none";
				String roleDisplay = "none";
				if(type1.equals("1")){//人力资源
					hrmSel = "selected";
					hrmDisplay = "block";
				}else if(type1.equals("2")){//分部
					subSel = "selected";
					subDisplay = "block";
				}else if(type1.equals("3")){//部门
					depSel = "selected";
					depDisplay = "block";
				}else if(type1.equals("4")){//角色
					roleSel = "selected";
					roleDisplay = "block";
				}
				%>
				<select id='type1' name='type1' onchange='type1_onchange();'  style="width:50px;float: left;visibility: visible !important;">
	                <option value=1 <%=hrmSel%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
	                <option value=2 <%=subSel%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	                <option value=3 <%=depSel%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	                <option value=4 <%=roleSel%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				</select>
				
	            <span id="spanHrmId" style="display: <%=hrmDisplay %>;">
			        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameHrm) %>' width="60%" >
			        </brow:browser>
			    </span>
	            <span id="spanSubId" style="display: <%=subDisplay %>;">
			        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameSub) %>' width="60%" >
			        </brow:browser>
			    </span>
	            <span id="spanDepId" style="display: <%=depDisplay %>;">
			        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameDep) %>' width="60%" >
			        </brow:browser>
			    </span>
	            <span id="spanRoleId" style="display: <%=roleDisplay %>;">
			        <brow:browser viewType="0" name="roleId" browserValue='<%=roleId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("65") %>'
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(122,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameRole) %>' width="60%" >
			        </brow:browser>
			    </span>
						</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%
	String backfields = "*";
	String sqlWhere = " where 1 = 1 ";
	String fromSql = " from SysDetachInfo ";
	String orderby = "id";
	String tableString = "";

	if (!"".equals(qname)) {
		sqlWhere += " and (name like '%" + StringEscapeUtils.escapeSql(qname) + "%' or description like '%" + StringEscapeUtils.escapeSql(qname) + "%')";
	}
	
	if (!"".equals(name)) {
		sqlWhere += " and name like '%"+name+"%'";
	}  	  	
	
	if (!"".equals(description)) {  
		sqlWhere += " and description like '%"+description+"%'"; 	  	
	}
	
	if (!"".equals(hrmId)) {
		sqlWhere += " and id in(select infoid from sysdetachdetail where type1=1 and ("+userSql+") and sourcetype = 2)";
	}
	 
	if (!"".equals(subId)) {
		sqlWhere += " and id in(select infoid from sysdetachdetail where type1=2 and ("+subSql+") and sourcetype = 2)";
	} 
	
	if (!"".equals(depId)) {
		sqlWhere += " and id in(select infoid from sysdetachdetail where type1=3 and ("+deptSql+") and sourcetype = 2)";
	} 
	
	if (!"".equals(roleId)) {
		sqlWhere += " and id in(select infoid from sysdetachdetail where type1=4 and ("+roleSql+") and sourcetype = 2)";
	} 
	
	tableString = "<table instanceid=\"FnaYearsTable\" tabletype=\"checkbox\"   pagesize=\""+PageIdConst.DEFAULTPAGESIZE+"\" >"+
					"<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+"\" "+
					" sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
					"<head>"+
						"<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(195, user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+//名称
						"<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(433, user.getLanguage())+"\" column=\"description\" orderkey=\"description\"/>"+//描述
						"<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"+2\" transmethod=\"weaver.splitepage.transform.SptmForHR.getMemberRangeContent\" />"+//对象
						"<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(34102, user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"+1\" transmethod=\"weaver.splitepage.transform.SptmForHR.getMemberRangeContent\" />"+//查看范围
					"</head>"+
					"<operates>"+
						//"<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaYearsPeriods_popedom\" otherpara=\"column:status\" ></popedom> "+
						"<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+//编辑
						"<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+//删除
					"</operates>"+
				"</table>";
%>
			<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
		</form>
	</BODY>
</HTML>



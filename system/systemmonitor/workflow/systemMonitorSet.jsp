
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree_wev8.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
TABLE.ListStyle TD.Line {
	 BACKGROUND-COLOR: #B7E0F7 ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 2px
}
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/xloadtree/xtree4workflowMonitorSet_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4workflow_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("WorkflowMonitor:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String info = Util.null2String(request.getParameter("infoKey"));
String wfHomeIcon = "/images/treeimages/Home_wev8.gif";
boolean wfintervenor= GCONST.getWorkflowIntervenorByMonitor();
%>
<script language="JavaScript">
<%if(info!=null && !info.equals("")){
    if(info.equals("1")){%>
      top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18563,user.getLanguage())%>')
    <%}
 }%>
</script>



<%
int userid=user.getUID();
String monitorhrmid=Util.null2String(request.getParameter("monitorhrmid"));
String infoid=Util.null2String(request.getParameter("infoid"));
String isclose = Util.null2String(request.getParameter("isclose"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String queryTypeid = Util.null2String(request.getParameter("queryTypeid"));

String needhelp ="";

String monitor=userid+"";
if(!"".equals(monitorhrmid))
	monitor=monitorhrmid;
String oldtypeid = Util.null2String(request.getParameter("oldtypeid"));
String typeid = Util.null2String(request.getParameter("typeid"));
typeid = (Util.getIntValue(typeid,0)<=0)?"":typeid;
String typename = "";
if(Util.getIntValue(typeid,0)>0)
{
	rs.executeSql("select * from Workflow_MonitorType where id = "+typeid);
	if(rs.next())
	{
		typename = rs.getString("typename");
	}
}
if(Util.getIntValue(oldtypeid,0)<=0&&Util.getIntValue(typeid,0)>0)
{
	oldtypeid = typeid;
}

String cdepar = Util.null2String(request.getParameter("cdepar"));

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;




//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable = 0;
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
if(isUseWfManageDetach){
	detachable = 1;
	session.setAttribute("detachable","1");
}
	
//添加监控时默认值
if("".equals(subcompanyid) && isUseWfManageDetach){
      if(user.getUID() == 1 ){
	       	 rs.executeProc("SystemSet_Select","");
	         if(rs.next()){
	             subcompanyid = rs.getString("wfdftsubcomid");
	         }
	  }else{
	      int[] hasRightSubArr = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowMonitor:All",1);
	      if(hasRightSubArr.length > 0){
	          subcompanyid = String.valueOf(hasRightSubArr[0]);  
	      }
	  }
}
//按钮权限
if (isUseWfManageDetach){
        int operatelevel=0;
        operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", Util.getIntValue(subcompanyid,-1));
        if(operatelevel < 0){
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }
}

String isOpenWorkflowStopOrCancel=GCONST.getWorkflowStopOrCancel();//是否开启流程暂停或取消设置

boolean isadmin = user.isAdmin();
String fromself = Util.null2String(request.getParameter("fromself"));

String jktype = "";
String jkvalue = "";
String fwtype = "";
String fwvalue = "";
String hrmmanageids = "";
String hrmids = "";
String roleids = "";
String hrmname = "";
String rolename = "";
String adminname = "";

String subcompanyids = "";
String subcompanynames = "";
String departmentids = "";
String departmentnames = "";
String hrmids_fw = "";
String hrmnames_fw = "";

String hrmdisplay = "none";
String roledisplay = "none";
String admindisplay = "none";
String showallselectdisplay = "none";
String showselectdisplay = "none";
String showsubcompanydisplay = "none";
String showdepartmentdisplay = "none";
String showresource2display = "none";
String title = SystemEnv.getHtmlLabelNames("665,68", user.getLanguage());
if(!"".equals(infoid)){
	rs.execute("select jktype,jkvalue,fwtype,fwvalue from workflow_monitor_info where id = " + infoid);
	rs.next();
	jktype = Util.null2String(rs.getString(1));
	jkvalue = Util.null2String(rs.getString(2));
	fwtype = Util.null2String(rs.getString(3));
	fwvalue = Util.null2String(rs.getString(4));
	
}
if(!"".equals(fromself)){
	jktype = Util.null2String(request.getParameter("jktype"));
	jkvalue = Util.null2String(request.getParameter("jkvalue"));
	fwtype = Util.null2String(request.getParameter("fwtype"));
	fwvalue = Util.null2String(request.getParameter("fwvalue"));
}
if("1".equals(jktype)){
	hrmdisplay = "block";
	showallselectdisplay = "block";
	hrmids = jkvalue;
	 for(String s : hrmids.split(","))
	 	hrmname += ","+ResourceComInfo.getLastname(s);
	 if(!"".equals(hrmname))
		 hrmname = hrmname.substring(1);
}
if("2".equals(jktype)){
	roledisplay = "block";
	showallselectdisplay = "block";
	roleids = jkvalue;
	 for(String s : roleids.split(","))
		 rolename += ","+RolesComInfo.getRolesRemark(s);
	 if(!"".equals(rolename))
		 rolename = rolename.substring(1);
}
if("3".equals(jktype)){
	admindisplay = "block";
	showselectdisplay = "block";
	hrmmanageids = jkvalue;
	 for(String s : hrmmanageids.split(","))
		 adminname += ","+ResourceComInfo.getLastname(s);
	 if(!"".equals(adminname))
		 adminname = adminname.substring(1);
}
if("4".equals(fwtype)){//分部
	showsubcompanydisplay = "block";
	subcompanyids = fwvalue;
	for(String s : subcompanyids.split(","))
		subcompanynames += ","+SubCompanyComInfo.getSubcompanyname(s);
	 if(!"".equals(subcompanynames))
		 subcompanynames = subcompanynames.substring(1);
}
if("7".equals(fwtype)){//部门
	showdepartmentdisplay = "block";
	departmentids = fwvalue;
	for(String s : departmentids.split(","))
		departmentnames += ","+DepartmentComInfo.getDepartmentname(s);
	 if(!"".equals(departmentnames))
		 departmentnames = departmentnames.substring(1);
}
if("10".equals(fwtype)){//指定人员
	showresource2display = "block";
	hrmids_fw = fwvalue;
	 for(String s : hrmids_fw.split(","))
		 hrmnames_fw += ","+ResourceComInfo.getLastname(s);
	 if(!"".equals(hrmnames_fw))
		 hrmnames_fw = hrmnames_fw.substring(1);
}
if("".equals(infoid) && "".equals(fromself)){
	hrmmanageids = user.getUID()+"";
	adminname = ResourceComInfo.getLastname(hrmmanageids);
	if(isadmin){
		admindisplay = "block";
		showselectdisplay = "block";
	}else{
		hrmdisplay = "block";
		showallselectdisplay = "block";
	}
}

if(StringUtils.isEmpty(adminname) && isadmin && user.getUID() != 1){
    adminname = user.getLastname();
    hrmmanageids = user.getUID()+"";
}

%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16216,user.getLanguage())+",javascript:goexpandall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+",javascript:docollapseall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=title %>"/>
</jsp:include>
<FORM name="frmmain" action="/system/systemmonitor/workflow/systemMonitorOperation.jsp" method="post">
<input type=hidden name="actionKey" value="add">
<input type=hidden name="detachable" value="<%=detachable %>">
<INPUT type="hidden" name="oldmonitortypeid"  id ="oldmonitortypeid" value=<%=typeid%>>
<INPUT type="hidden" name="monitortypeid"  id ="monitortypeid" value=<%=typeid%>>
<INPUT type="hidden" name="oldmonitorhrmid"  id ="oldmonitorhrmid" value=<%=monitor%>>
<INPUT type="hidden" name="monitorhrmid"  id ="monitorhrmid" value=<%=monitor%>>
<INPUT type="hidden" name="infoid"  id ="infoid" value=<%=infoid%>>
<INPUT type="hidden" name="queryTypeid"  id ="queryTypeid" value="<%=queryTypeid%>">
 
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top"  onclick="doSave()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(16216,user.getLanguage())%>" class="e8_btn_top" onclick="goexpandall()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>" class="e8_btn_top" onclick="docollapseall()"/>
				<span title="<%=SystemEnv.getHtmlLabelNames("81804", user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
	<div style="width:100%;height:100%;">
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%>' attributes="{'samePair':'groupShow','itemAreaDisplay':'block'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></wea:item>
			<wea:item>
				<table style="width:100%"><tr>
						<td style="width:20%">
						<SELECT style="width:170px" id="jktype" name=jktype onchange="doShow(this)">
							<option value="1" <%if("1".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							<%if(isadmin){ %>
								<option value="3" <%if("3".equals(jktype) || "".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
							<%}else{
							    if("3".equals(jktype)){%>
							 	   <option value="3" <%if("3".equals(jktype) || "".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
							<%}}%>
						</SELECT>
						</td>
						<td style="width:80%">
							<span id="showresource" style="display:<%=hrmdisplay %>">
							<brow:browser viewType="0" name="hrmids" browserValue='<%=hrmids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=1" width="400px" browserSpanValue='<%=hrmname %>' >
							</brow:browser>
							</span>
							<span id="showrole" style="display:<%=roledisplay %>">
							<brow:browser viewType="0" name="roleids" browserValue='<%=roleids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
								completeUrl="/data.jsp?type=65" width="400px" browserSpanValue='<%=rolename %>' >
							</brow:browser>
							</span>
							<%	
								if(isadmin){
									if(user.getUID() == 1){
							%>
							<span id="showresourcemanager" style="display:<%=admindisplay %>">
							<brow:browser viewType="0" name="hrmmanageids" browserValue='<%=hrmmanageids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/MutiSysadminBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=multisysadmin" width="400px" browserSpanValue='<%=adminname %>'>
							</brow:browser>
							</span>
							<%}else{ %>
							<span id="showresourcemanager" style="display:<%=admindisplay %>">
								<%=adminname %>
									<input type="hidden" name="hrmmanageids" value="<%=hrmmanageids %>">
							</span>
							<%}}else{
							    if("3".equals(jktype)){%>
							    <span id="showresourcemanager" style="display:<%=admindisplay %>">
								<%=adminname %>
									<input type="hidden" name="hrmmanageids" value="<%=hrmmanageids %>">
							</span>
							<%}} %>
						</td>
						</tr></table>
					
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></wea:item>
			<wea:item>
			<brow:browser name="inputt2" viewType="0" hasBrowser="true" hasAdd="false" 
           				getBrowserUrlFn="getMonitorTypeBrowserUrl" isMustInput="2" isSingle="true" hasInput="true"
            				completeUrl="/data.jsp?type=monitortypeBrowser"  width="200px" browserValue='<%=typeid%>' browserSpanValue='<%=Util.toScreen(typename,user.getLanguage())%>'/> 
            				
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelNames("665,19467", user.getLanguage()) %>
			</wea:item>
			<wea:item>
				<table style="width:100%"><tr>
						<td style="width:20%">
							<span id="showallselect" style="display: <%=showallselectdisplay %>">
								<select name="jkfw1" id="jkfw1" style="width: 170px" onchange="docheckFw(this)">
									<option value="1" <%if("1".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
									<option value="2" <%if("2".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option><!-- 同分部 -->
									<option value="3" <%if("3".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(82790,user.getLanguage())%></option><!-- 同分部及下级分部 -->
									<option value="4" <%if("4".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option><!-- 指定分部 -->
									<option value="5" <%if("5".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option><!-- 同部门 -->
									<option value="6" <%if("6".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelNames("18511,15022,17587",user.getLanguage())%></option><!-- 同部门及下级部门 -->
									<option value="7" <%if("7".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option><!-- 指定部门 -->
									<option value="8" <%if("8".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(81863,user.getLanguage())%></option><!-- 直接下属 -->
									<option value="9" <%if("9".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></option><!-- 所有下属 -->
									<option value="10" <%if("10".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(81811,user.getLanguage())%></option><!-- 指定人员 -->
								</select>
							</span>
							<span id="showselect" style="display: <%=showselectdisplay %>">
								<select name="jkfw2" id="jkfw2"  style="width: 170px" onchange="docheckFw(this)">
									<option value="1" <%if("1".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
									<option value="4" <%if("4".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option><!-- 指定分部 -->
									<option value="7" <%if("7".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option><!-- 指定部门 -->
									<option value="10" <%if("10".equals(fwtype)) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(81811,user.getLanguage())%></option><!-- 指定人员 -->
								</select>
							</span>
						</td>
						<td style="width:80%">
							<span id="showsubcompany" style="display: <%=showsubcompanydisplay %>">
							<brow:browser viewType="0" name="subcompanyids" browserValue='<%=subcompanyids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" width="400px" browserSpanValue='<%=subcompanynames %>' >
							</brow:browser>
							</span>
							<span id="showdepartment" style="display: <%=showdepartmentdisplay %>">
							<brow:browser viewType="0" name="departmentids" browserValue='<%=departmentids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=4" width="400px" browserSpanValue='<%=departmentnames %>' >
							</brow:browser>
							</span>
							<span id="showresource2" style="display: <%=showresource2display %>">
							<brow:browser viewType="0" name="hrmids_fw" browserValue='<%=hrmids_fw %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=1" width="400px" browserSpanValue='<%=hrmnames_fw %>' >
							</brow:browser>
							</span>
						</td>
						</tr></table>
			</wea:item>
			<%if(detachable==1){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
			<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
	           				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowMonitor:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
            				completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="200px" browserValue='<%=subcompanyid%>' browserSpanValue='<%=Util.toScreen(subCompInfo.getSubCompanyname(String.valueOf(subcompanyid)),user.getLanguage())%>'
            				_callBack="onShowSubcompany" /> 
			</wea:item>
			<%}%>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("34097", user.getLanguage()) %>' attributes="{'samePair':'groupShow','itemAreaDisplay':'block'}" >
			<wea:item attributes="{'colspan':'2','isTableList':'true'}">

<SPAN id="wfspan">
<TABLE class=ListStyle cellspacing=1 width="100%">
<TR class=Header style="border:2px  solid #B7E0F7;border-left:none;border-right:none;border-top:none;">
	<TH width="29%"><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TH>
	<th width="7%"><INPUT type=checkbox notBeauty=true name="checkall" id="checkall" value="1" onclick="onCheckAll(this);"><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%></th>
    <th width="12%"><INPUT type=checkbox notBeauty=true name="viewcheckall" id="viewcheckall" value="1" onclick="onViewCheckAll(this);"><%=SystemEnv.getHtmlLabelName(82770,user.getLanguage())%></th>
    <th width="11%" <%if(!wfintervenor){%>style="display:none"<%}%>><INPUT type=checkbox notBeauty=true name="intervenorcheckall" id="intervenorcheckall" value="1" onclick="onIntervenorCheckAll(this);"><%=SystemEnv.getHtmlLabelName(82771,user.getLanguage())%></th>
    <th width="8%"><INPUT type=checkbox notBeauty=true name="delcheckall" id="delcheckall" value="1" onclick="onDelCheckAll(this);"><%=SystemEnv.getHtmlLabelName(20307,user.getLanguage())%></th>
    <th width="11%"><INPUT type=checkbox notBeauty=true name="fbcheckall" id="fbcheckall" value="1" onclick="onFBCheckAll(this);"><%=SystemEnv.getHtmlLabelName(82772,user.getLanguage())%></th>
    <th width="11%"><INPUT type=checkbox notBeauty=true name="focheckall" id="focheckall" value="1" onclick="onFOCheckAll(this);"><%=SystemEnv.getHtmlLabelName(82773,user.getLanguage())%></th>
    <th width="11%" style="<%=isOpenWorkflowStopOrCancel.equals("1")?"":"display: none"%>"><INPUT type=checkbox notBeauty=true name="socheckall" id="socheckall" value="1" onclick="onSOCheckAll(this);"><%=SystemEnv.getHtmlLabelName(82774,user.getLanguage())%></th>
</TR>
<%--
<TR style="height:1px;"><TD class="Line" colSpan="8"></TD></TR> --%>
<tr>
	<td colspan="9" id="treeTD" class="tableField" style="background:#FFFFFF!important;text-align:center;">
		<script type="text/javascript">
		isOpenWorkflowStopOrCancel="<%=isOpenWorkflowStopOrCancel%>"; //是否开启流程暂停或撤销设置
		
		webFXTreeConfig.blankIcon		= "/images/xp2/blank_wev8.png";
		webFXTreeConfig.lMinusIcon		= "/images/xp2/pointto1_wev8.png";
		webFXTreeConfig.lPlusIcon		= "/images/xp2/pointto_wev8.png";
		webFXTreeConfig.tMinusIcon		= "/images/xp2/pointto1_wev8.png";
		webFXTreeConfig.tPlusIcon		= "/images/xp2/pointto_wev8.png";
		webFXTreeConfig.iIcon			= "/images/xp2/I_wev8.png";
		webFXTreeConfig.lIcon			= "/images/xp2/L_wev8.png";
		webFXTreeConfig.tIcon			= "/images/xp2/T_wev8.png";
		webFXTreeConfig.folderIcon      = "images/xp2/T_wev8.png";
		webFXTreeConfig.openFolderIcon  = "images/xp2/T_wev8.png";
	    webFXTreeConfig.usePersistence=false;
	    webFXTreeConfig.wfintervenor=<%=wfintervenor%>;
	
	    var rti;
		var tree = new WebFXTree('<%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%>','','','<%=wfHomeIcon%>','<%=wfHomeIcon%>');
		
		<%out.println(WorkTypeComInfo.getMMTypeInfo2(String.valueOf(infoid),""+userid,Util.getIntValue(oldtypeid,0),Util.getIntValue(subcompanyid,0),detachable,cdepar));%>
		if(tree.childNodes.length == 0){
			jQuery('#treeTD').html("<span><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></span>");	
		}else{
			document.write(tree);
		}
		</script>
	</td>
</tr>
</table>
</span>
</wea:item>
		</wea:group>
	</wea:layout>
	</div>
<BR>
<BR>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closecancle();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>


<script type="text/javascript">
var fwtype;
var dialog = null;
var parentWin = null;
try{
	 dialog = parent.getDialog(window);
	 parentWin = parent.getParentWindow(window);
	}catch(e){}

if("<%=isclose%>"==1){
	parentWin.location="/system/systemmonitor/workflow/systemMonitorStatic.jsp?typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>";
	dialog.close();
}

function closecancle(){
	//var newdialog = parent.getDialog(window);
	dialog.close();
}

function getMonitorTypeBrowserUrl(){
	return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/monitor/monitortypeBrowser.jsp?selectedids="+jQuery('#inputt2').val();
}


function onShowHrm(spanname,inputename){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
  
  <%if(1==detachable){%>
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=WorkflowMonitor:All","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  <%}else{%>
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  <%}%>
  if (datas){
	   if(datas.id!=""){
	    spanname.innerHTML= "<A href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>";
	    inputename.value=datas.id;
		location.href = "/system/systemmonitor/workflow/systemMonitorSet.jsp?typeid="+frmmain.monitortypeid.value+"&subcompanyid=<%=subcompanyid%>&monitorhrmid="+datas.id;
	   }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	    inputename.value="";
	   }
  }
}
function onShowSubcompany(datas,e)
{	var subcompanyid = frmmain.subcompanyid.value;
	if(subcompanyid!=""){	
		var jktype = frmmain.jktype.value;
		var jkvalue = '';
		if(jktype == 1){
	    	jkvalue = frmmain.hrmids.value;
	    }
	    if(jktype == 2){
	    	jkvalue = frmmain.roleids.value;
	    }
	    if(jktype == 3){
	    	jkvalue = frmmain.hrmmanageids.value;
	    }
		var fwvalue = '';
		 if(fwtype == 4){
		    	fwvalue = frmmain.subcompanyids.value;
		    }
		    if(fwtype == 7){
		    	fwvalue = frmmain.departmentids.value;
		    }
		    if(fwtype == 10){
		    	fwvalue = frmmain.hrmids_fw.value;
		    }
		//location.href = "/system/systemmonitor/workflow/systemMonitorSet.jsp?fromself=1&typeid="+frmmain.inputt2.value+"&infoid=<%=infoid%>&subcompanyid="+subcompanyid+"&jktype="+jktype+"&jkvalue="+jkvalue+"&fwtype="+fwtype+"&fwvalue="+fwvalue;
	}
}
var expandall=false;

function doSave(){
	var isCheck = false;
	var len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        //if (document.frmmain.elements[i].name.indexOf('w')==0) {
    		if(document.frmmain.elements[i].checked==true) {
        		//alert(document.frmmain.elements[i].name);
        		isCheck = true;
        		break;
    		}
        //}
    }
   if(!isCheck) {
	   top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22442,user.getLanguage())%>!');
	   return;
   }
   var checkfields = "";
   <% if(detachable==1){ %>
		checkfields = 'jktype,inputt2,subcompanyid';
   <%}else{%>
		checkfields = 'jktype,inputt2';
   <%}%>
   //监控类型非空校验
   	var jktype = jQuery('#jktype').val();
   	var jkfw = '';
	if(jktype == 1){
		checkfields += ',hrmids,jkfw1';
		jkfw = jQuery('#jkfw1').val();
	}else if(jktype == 2){
		checkfields += ',roleids,jkfw1';
		jkfw = jQuery('#jkfw1').val();
	}else if(jktype == 3){
		checkfields += ',hrmmanageids,jkfw2';
		jkfw = jQuery('#jkfw2').val();
	}

	//监控范围非空校验
	if(jkfw == 4){
		checkfields += ',subcompanyids';
	}else if(jkfw == 7){
		checkfields += ',departmentids';
	}else if(jkfw == 10){
		checkfields += ',hrmids_fw';
	}

	if (check_form(frmmain,checkfields)){
		var str1 = jQuery("input[name='inputt1']").val();
		var str2 = jQuery("input[name='inputt2']").val();
		jQuery("#monitorhrmid").val(str1); 
		jQuery("#monitortypeid").val(str2);
       window.document.frmmain.submit();
       //obj.disabled = true;
    }
}


function checkMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    if(!mainchecked){
        document.all("vt"+id).checked=mainchecked;
        document.all("it"+id).checked=mainchecked;
        document.all("dt"+id).checked=mainchecked;
        document.all("bt"+id).checked=mainchecked;
        document.all("ot"+id).checked=mainchecked;
        document.all("st"+id).checked=mainchecked;
        document.all("checkall").checked=mainchecked;
        document.all("viewcheckall").checked=mainchecked;
        document.all("intervenorcheckall").checked=mainchecked;
        document.all("delcheckall").checked=mainchecked;
        document.all("fbcheckall").checked=mainchecked;
        document.all("focheckall").checked=mainchecked;
        document.all("socheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id || (!mainchecked && (document.frmmain.elements[i].name=='vw'+id || document.frmmain.elements[i].name=='iw'+id || document.frmmain.elements[i].name=='dw'+id || document.frmmain.elements[i].name=='bw'+id || document.frmmain.elements[i].name=='ow'+id|| document.frmmain.elements[i].name=='sw'+id))) {
            document.frmmain.elements[i].checked= mainchecked ;
        } 
    }
    */
    
    var mainchecked=jQuery("input[name='t" + id + "']")[0].checked;
    if(!mainchecked){
        jQuery("input[name='vt"+id + "']")[0].checked=false;
        jQuery("input[name='it"+id + "']")[0].checked=false;
        jQuery("input[name='dt"+id + "']")[0].checked=false;
        jQuery("input[name='bt"+id + "']")[0].checked=false;
        jQuery("input[name='ot"+id + "']")[0].checked=false;
        jQuery("input[name='st"+id + "']")[0].checked=false;
        jQuery("input[name='checkall" + "']")[0].checked=false;
        jQuery("input[name='viewcheckall" + "']")[0].checked=false;
        jQuery("input[name='intervenorcheckall" + "']")[0].checked=false;
        jQuery("input[name='delcheckall" + "']")[0].checked=false;
        jQuery("input[name='fbcheckall" + "']")[0].checked=false;
        jQuery("input[name='focheckall" + "']")[0].checked=false;
        jQuery("input[name='socheckall" + "']")[0].checked=false;
    }
	try{
    	jQuery("input[name='w" + id + "']")
	        .each(function(){
	        	this.checked = mainchecked;
	        });
    	if(!mainchecked){
    		jQuery("input[name='vw" + id + "'][checked]")
    		.add(jQuery("input[name='iw" + id + "'][checked]"))
    		.add(jQuery("input[name='dw" + id + "'][checked]"))
    		.add(jQuery("input[name='bw" + id + "'][checked]"))
    		.add(jQuery("input[name='ow" + id + "'][checked]"))
    		.add(jQuery("input[name='sw" + id + "'][checked]"))
	        .each(function(){
	        	this.checked= mainchecked ;
	        });
    	}
	}catch(e){}
    
}

function checkSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!obj.checked){
    document.all("checkall").checked=obj.checked;
    document.all("viewcheckall").checked=obj.checked;
    document.all("intervenorcheckall").checked=obj.checked;
    document.all("delcheckall").checked=obj.checked;
    document.all("fbcheckall").checked=obj.checked;
    document.all("focheckall").checked=obj.checked;
    document.all("socheckall").checked=obj.checked;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="VW"+wfid||document.frmmain.elements[i].value=="IW"+wfid||document.frmmain.elements[i].value=="DW"+wfid||document.frmmain.elements[i].value=="BW"+wfid||document.frmmain.elements[i].value=="OW"+wfid||document.frmmain.elements[i].value=="SW"+wfid) {
            document.frmmain.elements[i].checked=false;
        }
    }
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
            if(document.frmmain.elements[i].checked){
                document.all("t"+id).checked=true;
                return;
            }
        }
    }
    document.all("t"+id).checked=false;
    document.all("vt"+id).checked=false;
    document.all("it"+id).checked=false;
    document.all("dt"+id).checked=false;
    document.all("bt"+id).checked=false;
    document.all("ot"+id).checked=false;
    document.all("st"+id).checked=false;
    */
    
    if(!obj.checked){
	    document.all("checkall").checked=obj.checked;
	    document.all("viewcheckall").checked=obj.checked;
	    document.all("intervenorcheckall").checked=obj.checked;
	    document.all("delcheckall").checked=obj.checked;
	    document.all("fbcheckall").checked=obj.checked;
	    document.all("focheckall").checked=obj.checked;
	    document.all("socheckall").checked=obj.checked;
		try{
    		jQuery("input[value='VW" + wfid + "']")
    			.add(jQuery("input[value='VW" + wfid + "']"))
    			.add(jQuery("input[value='IW" + wfid + "']"))
    			.add(jQuery("input[value='DW" + wfid + "']"))
    			.add(jQuery("input[value='BW" + wfid + "']"))
    			.add(jQuery("input[value='OW" + wfid + "']"))
    			.add(jQuery("input[value='SW" + wfid + "']"))
	        .each(function(){
	        	this.checked = false;
	        });
		}catch(e){}
    }
    
    var wObjects = jQuery("input[name='w" + id + "']");
    for(var i = 0; i < wObjects.length; i++){
        
        if(wObjects[i].checked){
            //该类型的可查看流程内容checkbox
    		document.all("t"+id).checked=true;
            return;
        }
    }
    document.all("t"+id).checked=false;
    document.all("vt"+id).checked=false;
    document.all("it"+id).checked=false;
    document.all("dt"+id).checked=false;
    document.all("bt"+id).checked=false;
    document.all("ot"+id).checked=false;
    document.all("st"+id).checked=false;
}

function onCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
	    for( i=0; i<len; i++) {
	        if (document.frmmain.elements[i].name.indexOf('t')==0) {
	    		document.frmmain.elements[i].checked=!obj.checked;
	            document.frmmain.elements[i].click();
	        }
	    }
    	expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0 || (!obj.checked && (
        document.frmmain.elements[i].name.indexOf('vt')==0 || document.frmmain.elements[i].name.indexOf('vw')==0||
        document.frmmain.elements[i].name.indexOf('it')==0 || document.frmmain.elements[i].name.indexOf('iw')==0||
        document.frmmain.elements[i].name.indexOf('dt')==0 || document.frmmain.elements[i].name.indexOf('dw')==0||
        document.frmmain.elements[i].name.indexOf('bt')==0 || document.frmmain.elements[i].name.indexOf('bw')==0||
        document.frmmain.elements[i].name.indexOf('ot')==0 || document.frmmain.elements[i].name.indexOf('ow')==0||
        document.frmmain.elements[i].name.indexOf('st')==0 || document.frmmain.elements[i].name.indexOf('sw')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(!obj.checked){
        document.all("viewcheckall").checked=obj.checked;
        document.all("intervenorcheckall").checked=obj.checked;
        document.all("delcheckall").checked=obj.checked;
        document.all("fbcheckall").checked=obj.checked;
        document.all("focheckall").checked=obj.checked;
        document.all("socheckall").checked=obj.checked;
        
    }
    */
    if(!expandall){
	    jQuery("input[name^='t']").each(function(){
    		this.checked=!obj.checked;
            this.click();
        });
    	expandall=true;
    }
    jQuery("input[name^='t']").add(jQuery("input[name^='w']")).each(function(){
    	this.checked = obj.checked;
    });
    if(!obj.checked){
        jQuery("input[name^='t']").add(jQuery("input[name^='w']"))
        .add(jQuery("input[name^='vt']")).add(jQuery("input[name^='vw']"))
        .add(jQuery("input[name^='it']")).add(jQuery("input[name^='iw']"))
        .add(jQuery("input[name^='dt']")).add(jQuery("input[name^='dw']"))
        .add(jQuery("input[name^='bt']")).add(jQuery("input[name^='bw']"))
        .add(jQuery("input[name^='ot']")).add(jQuery("input[name^='ow']"))
        .add(jQuery("input[name^='st']")).add(jQuery("input[name^='sw']"))
        .each(function(){
        	this.checked = false;
        });
    }
    if(!obj.checked){
        document.all("viewcheckall").checked=obj.checked;
        document.all("intervenorcheckall").checked=obj.checked;
        document.all("delcheckall").checked=obj.checked;
        document.all("fbcheckall").checked=obj.checked;
        document.all("focheckall").checked=obj.checked;
        document.all("socheckall").checked=obj.checked;
        
    }
}

function viewcheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("vt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("viewcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='vw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    
	try{
		var mainchecked=jQuery("input[name='vt"+id + "']")[0].checked ;
	    if(mainchecked){
	        //该类型的允许监控checkbox
	        jQuery("input[name='t"+id + "']").each(function(){
	            this.checked=mainchecked;
	        });
	    }else{
	        //总的可查看内容checkbox
	        jQuery("#viewcheckall")[0].checked=mainchecked;
	        //该种类的可查看内容checkbox
	        jQuery("input[name='it"+ id + "']").each(function(){
	            this.checked=mainchecked;
	        });
	        //该种类所有流程的可查看内容checkbox
	        jQuery("input[name='iw"+ id + "']").each(function(){
	            this.checked=mainchecked;
	        });
	    }
	    //该类型所有流程的可查看内容checkbox
	    jQuery("input[name='vw"+id  + "']").each(function(){
	        this.checked = mainchecked;
	    });
	    //该类型对应的所有流程的允许监控checkbox
	    if(mainchecked){
		    jQuery("input[name='w"+id + "']").each(function(){
	            this.checked = mainchecked;
	        });
	    }
	}catch(e){}
}

function viewcheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("viewcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='vw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("vt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("vt"+id).checked=false;
    */
    if(obj.checked){
        //该流程的允许监控checkbox
        jQuery("input[value='W" + wfid + "']").each(function(){
            this.checked=true;
            //该种类的允许监控checkbox
            jQuery("input[name='t" + id + "']")[0].checked=true;
        });
    }else{
        //总的可查看流程内容checkbox
        jQuery("#viewcheckall").checked=false;
        //可干预流程流转checkbox
        jQuery("input[value='IW" + wfid + "']").each(function(){
            this.checked=false;
        });
        
    }
    var iwObjects = jQuery("input[name='iw" + id + "']");
    var itcheckFlag = false;
    for(var i=0;i < iwObjects.length;i++){
        if(iwObjects[i].checked){
            itcheckFlag = true;
            break;
        }
    }
    jQuery("input[name='it" + id + "']")[0].checked = itcheckFlag;
    //该类型所有流程的可查看流程内容checkbox
    var vwObjects = jQuery("input[name='vw" + id + "']");
    for(var i = 0; i < vwObjects.length; i++){
        
        if(vwObjects[i].checked){
            //该类型的可查看流程内容checkbox
            jQuery("input[name='vt" + id + "']")[0].checked=true;
            return;
        }
    }
    //该类型的可查看流程内容checkbox
    jQuery("input[name='vt" + id + "']")[0].checked=false;
}

function onViewCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('vt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('vt')==0 || document.frmmain.elements[i].name.indexOf('vw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */  
	//将流程种类的可查看流程内容checkbox统一显示
	
    if(!expandall){
	    jQuery("input[name^='vt']").each(function(){
            this.checked=!obj.checked;
            this.click();
	    });
        expandall=true;
    }
    
    //编辑流程种类的可查看流程内容checkbox
    jQuery("input[name^='vt']").each(function(){
        this.checked=obj.checked;
    });
    //编辑流程的可查看流程内容checkbox
    jQuery("input[name^='vw']").each(function(){
        this.checked=obj.checked;
    });
    if(obj.checked){
	    //编辑流程种类的可查看流程内容checkbox
	    jQuery("input[name^='vt']").each(function(){
	        this.checked=obj.checked;
	    });
	    //编辑流程的可查看流程内容checkbox
	    jQuery("input[name^='vw']").each(function(){
	        this.checked=obj.checked;
	    });
	    
        //总的允许监控checkbox
        jQuery("#checkall")[0].checked = true;
        //编辑流程种类的允许监控checkbox
        jQuery("input[value^='T']").each(function(){
            this.checked=true;
        });
        //编辑流程的允许监控checkbox
        jQuery("input[value^='W']").each(function(){
           this.checked=true;
        });
    }else{
        //总的可干预流程流转checkbox
        jQuery("#intervenorcheckall")[0].checked = false;
        //编辑流程种类的可干预流程流转checkbox
        jQuery("input[name^='it']").each(function(){
            this.checked=false;
        });
        //编辑流程的可干预流程流转checkbox
        jQuery("input[name^='iw']").each(function(){
           this.checked=false;
        });
    }

}

function intervenorcheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("it"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("intervenorcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='iw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    
    var mainchecked=$GetEle("it"+id).checked ;
    if(mainchecked){
        $GetEle("t"+id).checked=mainchecked;
        $GetEle("vt"+id).checked=mainchecked;
    }
    else{
        $GetEle("intervenorcheckall").checked=mainchecked;
    }
    jQuery("input[name='iw" + id + "']").each(function(){
        this.checked= mainchecked;
    });
    if(mainchecked){
        jQuery("input[name='w" + id + "']").each(function(){
            this.checked= mainchecked;
        });
        jQuery("input[name='vw" + id + "']").each(function(){
            this.checked= mainchecked;
        });
    }
}

function intervenorcheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("intervenorcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='iw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("it"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("it"+id).checked=false;
    */
    
    if(obj.checked){
        jQuery("input[value='W" + wfid + "']").each(function(){
            //该流程的允许监控checkbox
            this.checked=true;
            //该流程种类的允许监控checkbox
            jQuery("input[name='t" + id + "']")[0].checked=true;
        });
        jQuery("input[value='VW" + wfid + "']").each(function(){
            //该流程的允许监控checkbox
            this.checked=true;
            //该流程种类的允许监控checkbox
            jQuery("input[name='vt" + id + "']")[0].checked=true;
        });
    }else{
        //总的可干预流程流转checkbox
        jQuery("#intervenorcheckall")[0].checked=false;
    }
    var iwObjects = jQuery("input[name='iw" + id + "']");
    for(var i = 0; i < iwObjects.length; i++){
        if(iwObjects[i].checked){
            //该流程种类的可干预流程流转checkbox
            jQuery("input[name='it" + id + "']")[0].checked=true;
            return;
        }
    }
    jQuery("input[name='it" + id + "']")[0].checked=false;
}

function onIntervenorCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('it')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('it')==0 || document.frmmain.elements[i].name.indexOf('iw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */
    
    try{
        //将流程种类的可干预流程流转checkbox统一显示
	    if(!expandall){
	        jQuery("input[name^='it']").each(function(){
	            this.checked=!obj.checked;
	            this.click();
	        });
	        expandall=true;
	    }
	    //各个类的可干预流程流转checkbox
	    jQuery("input[name^='it']").each(function(){
	       this.checked=obj.checked;
	    });
	    //各个流程的可干预流程流转checkbox
        jQuery("input[name^='iw']").each(function(){
           this.checked=obj.checked;
        });
	    if(obj.checked){
	        //各个类的允许监控checkbox
	        jQuery("input[name^='t']").each(function(){
	           this.checked=true;
	        });
            //各个流程的允许监控checkbox
            jQuery("input[name^='w']").each(function(){
               this.checked=true;
            });
            //各个类的允许监控checkbox
            jQuery("input[name^='vt']").each(function(){
               this.checked=true;
            });
            //各个流程的允许监控checkbox
            jQuery("input[name^='vw']").each(function(){
               this.checked=true;
            });
	        jQuery("#checkall")[0].checked=true;
            jQuery("#viewcheckall")[0].checked=true;
	    }
    }catch(e){}

}

function delcheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("dt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("delcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='dw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    var mainchecked=jQuery("input[name='dt" + id + "']")[0].checked ;
    if(mainchecked){ 
        document.all("t"+id).checked=mainchecked;
    }else{
        document.all("delcheckall").checked=mainchecked;
    }
    jQuery("input[name='dw" + id + "']").each(function(){
       this.checked=mainchecked;
    });
    if(mainchecked){
	    jQuery("input[name='w" + id + "']").each(function(){
	       this.checked=mainchecked;
	    });
    }
    	
}

function delcheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("delcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='dw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("dt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("dt"+id).checked=false;
    */
    if(obj.checked){
	    for(var i = 0; i < jQuery("input[value='W" + wfid + "']").length; i++){
	        jQuery("input[value='W" + wfid + "']")[i].checked=true;
	        document.all("t"+id).checked=true;
	        break;
	    }
    }else{
        document.all("delcheckall").checked=obj.checked;
    }
    var dwObjects = jQuery("input[name='dw" + id + "']");
    for(var i = 0; i < dwObjects.length; i++){
        if(dwObjects[i].checked){
            //该流程种类的可干预流程流转checkbox
            jQuery("input[name='dt" + id + "']")[0].checked=true;
            return;
        }
    }
    
}

function onDelCheckAll(obj){
    /*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('dt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('dt')==0 || document.frmmain.elements[i].name.indexOf('dw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */
    
    if(!expandall){
	    jQuery("input[name^='dt']").each(function(){
	       this.checked=!obj.checked;
	       this.click();
	    });
    	expandall=true;
    }
    jQuery("input[name^='dt']").add(jQuery("input[name^='dw']")).each(function(){
       this.checked=obj.checked;
    });
    if(obj.checked){
    	jQuery("input[name^='t']")
    		.add(jQuery("input[name^='w']")).each(function(){
	       this.checked=obj.checked;
	    });
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function fbcheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("bt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("fbcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='bw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    
    var mainchecked=jQuery("input[name='bt" + id + "']")[0].checked;
    if(mainchecked){
        document.all("t"+id).checked=mainchecked;
    }else{
        document.all("fbcheckall").checked=mainchecked;
    }
    jQuery("input[name='bw" + id + "']").each(function(){
        this.checked= mainchecked ;
    });
    if(mainchecked){
	    jQuery("input[name='w" + id + "']").each(function(){
	        this.checked= mainchecked ;
	    });
    }
    
}

function fbcheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("fbcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='bw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("bt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("bt"+id).checked=false;
    */
    
    if(obj.checked){
	    for(var i = 0; i < jQuery("input[value='W" + wfid + "']").length; i++){
	        jQuery("input[value='W" + wfid + "']")[i].checked=true;
	        document.all("t"+id).checked=true;
	        break;
	    }
    }else{
        document.all("fbcheckall").checked=obj.checked;
    }
    var bwObjects = jQuery("input[name='bw" + id + "']");
    for(var i = 0; i < bwObjects.length; i++){
        if(bwObjects[i].checked){
            //该流程种类的可干预流程流转checkbox
            jQuery("input[name='bt" + id + "']")[0].checked=true;
            return;
        }
    }
    document.all("bt"+id).checked=false;
}

function onFBCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('bt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('bt')==0 || document.frmmain.elements[i].name.indexOf('bw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */
    if(!expandall){
	    jQuery("input[name^='bt']").each(function(){
    		this.checked=!obj.checked;
            this.click();
	    });
	    expandall=true;
    }
    
    jQuery("input[name^='bt']").add(jQuery("input[name^='bw']")).each(function(){
		this.checked=obj.checked;
    });
    if(obj.checked){
	    jQuery("input[name^='t']").add(jQuery("input[name^='w']")).each(function(){
			this.checked=obj.checked;
	    });
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function focheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("ot"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("focheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='ow'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    var mainchecked=jQuery("input[name='ot" + id + "']")[0].checked;
    if(mainchecked){
    	document.all("t"+id).checked=mainchecked;
    }else{
        document.all("focheckall").checked=mainchecked;
    }
    jQuery("input[name='ow" + id + "']").each(function(){
        this.checked= mainchecked ;
    });
    if(mainchecked){
	    jQuery("input[name='w" + id + "']").each(function(){
	        this.checked= mainchecked ;
	    });
    }
}

function focheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("focheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='ow'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("ot"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("ot"+id).checked=false;
    */
    
    if(obj.checked){
	    for(var i = 0; i < jQuery("input[value='W" + wfid + "']").length; i++){
	        jQuery("input[value='W" + wfid + "']")[i].checked=true;
            document.all("t"+id).checked=true;
            break;
	    }
    }else{
        document.all("focheckall").checked=obj.checked;
    }
    var owObjects = jQuery("input[name='ow" + id + "']");
    for(var i = 0; i < owObjects.length; i++){
        if(owObjects[i].checked){
            //该流程种类的可干预流程流转checkbox
            jQuery("input[name='ot" + id + "']")[0].checked=true;
            return;
        }
    }
    document.all("ot"+id).checked=false;
}

function onFOCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('ot')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('ot')==0 || document.frmmain.elements[i].name.indexOf('ow')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */
    
    if(!expandall){
	    jQuery("input[name^='ot']").each(function(){
    		this.checked=obj.checked;
            this.click();
	    });
	    expandall=true;
    }
    
    jQuery("input[name^='ot']").add(jQuery("input[name^='ow']")).each(function(){
		this.checked=obj.checked;
    });
    if(obj.checked){
	    jQuery("input[name^='t']").add(jQuery("input[name^='w']")).each(function(){
			this.checked=obj.checked;
	    });
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}
function onSOCheckAll(obj){
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('st')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('st')==0 || document.frmmain.elements[i].name.indexOf('sw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) 
        {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }
    */
    if(!expandall){
	    jQuery("input[name^='st']").each(function(){
    		this.checked=!obj.checked;
            this.click();
	    });
	    expandall=true;
    }
    
    jQuery("input[name^='st']").add(jQuery("input[name^='sw']")).each(function(){
		this.checked=obj.checked;
    });
    if(obj.checked){
	    jQuery("input[name^='t']").add(jQuery("input[name^='w']")).each(function(){
			this.checked=obj.checked;
	    });
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}
function socheckMain(id) {
	/*
    len = document.frmmain.elements.length;
    var mainchecked=document.all("st"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("socheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='sw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
    */
    var mainchecked=jQuery("input[name='st" + id + "']")[0].checked;
    if(mainchecked){
    	document.all("t"+id).checked=mainchecked;
    }else{
        document.all("socheckall").checked=mainchecked;
    }
    jQuery("input[name='sw" + id + "']").each(function(){
        this.checked= mainchecked ;
    });
    if(mainchecked){
	    jQuery("input[name='w" + id + "']").each(function(){
	        this.checked= mainchecked ;
	    });
    }
}

function socheckSub(obj,wfid,id) {
	/*
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("socheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='sw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("st"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("st"+id).checked=false;
    */
    if(obj.checked){
	    for(var i = 0; i < jQuery("input[value='W" + wfid + "']").length; i++){
	        jQuery("input[value='W" + wfid + "']")[i].checked=true;
            document.all("t"+id).checked=true;
            break;
	    }
    }else{
        document.all("socheckall").checked=obj.checked;
    }
    var swObjects = jQuery("input[name='sw" + id + "']");
    for(var i = 0; i < swObjects.length; i++){
        if(swObjects[i].checked){
            //该流程种类的可干预流程流转checkbox
            jQuery("input[name='st" + id + "']")[0].checked=true;
            return;
        }
    }
    document.all("st"+id).checked=false;
}
function goexpandall(){
tree.expandAll();
expandall=true;
}
function docollapseall(){
tree.collapseAll();
}

function doShow(obj){
	var thisvalue = obj.value;
	if(thisvalue==1){
		$GetEle("showresource").style.display='';
		$GetEle("showrole").style.display='none';
		$GetEle("showresourcemanager").style.display='none';
		$GetEle("showallselect").style.display='block';
		$GetEle("showselect").style.display='none';
		var obj2 = {};
		obj2.value = $GetEle("jkfw1").value;
		docheckFw(obj2);
	}
	
	if(thisvalue==2){
		$GetEle("showresource").style.display='none';
		$GetEle("showrole").style.display='';
		$GetEle("showresourcemanager").style.display='none';
		$GetEle("showallselect").style.display='block';
		$GetEle("showselect").style.display='none';

		var obj2 = {};
		obj2.value = $GetEle("jkfw1").value;
		docheckFw(obj2);
	}
	
	if(thisvalue==3){
		$GetEle("showresource").style.display='none';
		$GetEle("showrole").style.display='none';
		$GetEle("showresourcemanager").style.display='';
		$GetEle("showallselect").style.display='none';
		$GetEle("showselect").style.display='block';

		var obj2 = {};
		obj2.value = $GetEle("jkfw2").value;
		docheckFw(obj2);
	}
	
}

function docheckFw(obj){
	var fwvalue = obj.value;
	fwtype = obj.value;
	if(fwvalue == 4){
		$GetEle("showsubcompany").style.display='block';
		$GetEle("showdepartment").style.display='none';
		$GetEle("showresource2").style.display='none';
	}else if(fwvalue == 7){
		$GetEle("showsubcompany").style.display='none';
		$GetEle("showdepartment").style.display='block';
		$GetEle("showresource2").style.display='none';
	}else if(fwvalue == 10){
		$GetEle("showsubcompany").style.display='none';
		$GetEle("showdepartment").style.display='none';
		$GetEle("showresource2").style.display='block';
	}else{
		$GetEle("showsubcompany").style.display='none';
		$GetEle("showdepartment").style.display='none';
		$GetEle("showresource2").style.display='none';
	}
	
}




jQuery(function(){
	if('<%=showallselectdisplay%>' == 'block'){
		jQuery('#showallselect').show();
		jQuery('#showselect').hide();
	}
	if('<%=showselectdisplay%>' == 'block'){
		jQuery('#showallselect').hide();
		jQuery('#showselect').show();
	}
	var windowHeight = parent.parent.document.body.clientHeight;
	//计算监控条件表单的高度
	var prefix = 380;
	<%if(detachable==1){%>
		prefix = 410;
	<%}%>
	jQuery('#webfx-tree-object-4-cont').css('height',windowHeight-prefix).css('overflow','auto');
	
	<%if(!isadmin && "3".equals(jktype)){%>
		jQuery('#jktype').selectbox("disable");
	<%}%>
})
</script>

</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int companyid=Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);
int subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+id),0);
//封存判断
String canceled = "";
rs.executeSql("select canceled from HrmDepartment where id="+id);
if(rs.next()){
 canceled = rs.getString("canceled");
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean hasHrmDeartmentVirtual = false;
rs.executeSql(" select count(*) from hrmdepartmentvirtual");
if(rs.next()){
	if(rs.getInt(1)>0)hasHrmDeartmentVirtual = true;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int sublevelAdd=0;

if(detachable==1){
      sublevelAdd=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
        sublevelAdd=2;
    }
}

boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
String groupSqlwhere = "";

String pubGroupUser = GroupAction.getPubGroupUser(user);
String priGroupUser = GroupAction.getPriGroupUser(user);
String canSeeGroupids = pubGroupUser+","+priGroupUser;
if(canSeeGroupids.length() > 0){
	groupSqlwhere += " ("+Util.getSubINClause(canSeeGroupids, "id", "in")+") ";
}else{
	groupSqlwhere += " 1 = 2 ";
}
if(!cansave){
	groupSqlwhere += " and type = 0";
}

boolean canAdd = sublevelAdd>0?true:false;


if(canAdd && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,30042",user.getLanguage())+",javascript:addHrmResource();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(hasHrmDeartmentVirtual){ 
RCMenu += "{"+SystemEnv.getHtmlLabelNames("34100",user.getLanguage())+",javascript:setVirtualDepartment();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(130759,user.getLanguage())+",javascript:addToGroup(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	if(id==null)id="";
	var url = "";
	dialog.Width = 800;
	dialog.Height = 1000;
	dialog.maxiumnable=true;
	if(cmd=="editHrmResource"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,30042", user.getLanguage())%>";
		url = "/hrm/HrmTab.jsp?_fromURL=HrmResource&isdialog=1&isView=0&id="+id;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editHrmResource(id)
{
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id);
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=29 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=29")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function addHrmResource(){
 	window.parent.parent.location.href="/hrm/resource/HrmResource_frm.jsp?departmentid=<%=id%>";
}

function setVirtualDepartment(){
	var resourceids = _xtable_CheckedCheckboxId();
	if(resourceids.match(/,$/)){
		resourceids = resourceids.substring(0,resourceids.length-1);
	}
	if(resourceids==null||resourceids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34095,user.getLanguage())%>");
		return;
	}
	
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=setDepartmentVirtual&isdialog=1&resourceids="+resourceids;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(34100,user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addToGroup(){
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130803,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	if(dialog==null)dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/group/MultiGroupBrowser.jsp?sqlwhere=<%=xssUtil.put(groupSqlwhere)%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("18214",user.getLanguage())%>";
	dialog.Width = 576;
	dialog.Height = 632;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.callback = addGroupMember;
	dialog.show();
}
function addGroupMember(data){
	var id = _xtable_CheckedCheckboxId();
	jQuery.ajax({
		type: "post",
		url: "/hrm/group/HrmGroupData.jsp",
		data: {method:"addGroupMember",userid:id, groupid:data.id},
		dataType: "JSON",
		success: function(result){
			window.location.reload();
		}
	});
}
</script>
</head>
<body>
<FORM name="searchfrm" id="searchfrm" method=post >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(canAdd&& ("0".equals(canceled) || "".equals(canceled))){ %>
			<input type=button class="e8_btn_top" onclick="addHrmResource();"  value="<%=SystemEnv.getHtmlLabelNames("82,30042",user.getLanguage())%>"></input>
			<%if(hasHrmDeartmentVirtual){ %>
			<input type=button class="e8_btn_top" onclick="setVirtualDepartment();"  value="<%=SystemEnv.getHtmlLabelName(34100,user.getLanguage())%>"></input>
			<%} %>
		<%} %>	
			<input type=button class="e8_btn_top" onclick="addToGroup();" value="<%=SystemEnv.getHtmlLabelNames("130759",user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
 
AppDetachComInfo adci = new AppDetachComInfo();
String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
//姓名	编号	性别	直接上级	岗位	登录名	   安全级别	   显示顺序	
String backfields = " id, lastname, workcode, sex, managerid, jobtitle, loginid, seclevel, dsporder, status "; 
String fromSql  = " from HrmResource ";
//String sqlWhere = " where departmentid in ("+DepartmentComInfo.getAllChildDepartId(""+id,""+id)+")";
String sqlWhere = " where status in (0,1,2,3) and departmentid = "+id+"";
sqlWhere += (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
String orderby = " dsporder " ;
String tableString = "";

//编辑    日志
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourceOperate\" otherpara=\""+canAdd+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivities:log", user)+":"+HrmUserVarify.checkUserRight("HrmCompanyEdit:Add", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:editHrmResource();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       //operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 
 	      tableString =" <table pageId=\""+PageIdConst.HRM_ResourceList+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceList,user.getUID(),PageIdConst.HRM)+"\" >"+
 			"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
 	    operateString+
 	    "			<head>"+
 	    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmEditHrmResourceName\" otherpara=\"column:id\"/>"+
 	    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\"/>"+
 	    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getSexName\" orderkey=\"sex\"/>"+
 	    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getStatusName\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" />"+
 	    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+"\" column=\"managerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" orderkey=\"managerid\"/>"+
 	    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" orderkey=\"jobtitle\"/>";
 	    if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All",user)){
 			tableString += "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"loginid\" orderkey=\"loginid\"/>";
 	  		tableString +="		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\"/>";
 	  	};
 	  	tableString += "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>"+
 	    "			</head>"+
 	    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
 </form> 
</body>
</html>

<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

</head>

<%
boolean monitorRight = HrmUserVarify.checkUserRight("WorkflowMonitor:All", user);
if(!monitorRight){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean isadmin = user.isAdmin();
String info = Util.null2String(request.getParameter("infoKey"));
int typeid = Util.getIntValue(Util.null2String(session.getAttribute("monitoryjktypeid")),0);
int subcompanyid = Util.getIntValue(Util.null2String(session.getAttribute("managemonitor_subcompanyid")),0);
int userid=user.getUID();
String flowTitle = Util.null2String(request.getParameter("flowTitle"));
 String jktype = Util.null2String(request.getParameter("jktype"));
 String inputt11 = "";
 String hrmmanageids = Util.null2String(request.getParameter("hrmmanageids"));
 String hrmids = Util.null2String(request.getParameter("hrmids"));
 String roleids = Util.null2String(request.getParameter("roleids"));
 String hrmname = "";
 String rolename = "";
 String adminname = "";
 String resourcedisplay = "none";
 String roledisplay = "none";
 String managerdisplay = "none";
 if("1".equals(jktype)){
	 inputt11 = hrmids;
	 hrmmanageids = "";
	 roleids = "";
	 hrmname = ResourceComInfo.getLastname(hrmids);
	 resourcedisplay = "block";
 }else if("2".equals(jktype)){
	 inputt11 = roleids;
	 hrmmanageids = "";
	 hrmids = "";
	 rolename = RolesComInfo.getRolesRemark(roleids);
	 roledisplay = "block";
 }else if("3".equals(jktype)){
	 inputt11 = hrmmanageids;
	 hrmids = "";
	 roleids = "";
	 adminname = ResourceComInfo.getLastname(hrmmanageids);
	 managerdisplay = "block";
 }else
	 resourcedisplay = "block";
String inputt22 = Util.null2String(request.getParameter("inputt22"));
if(info!=null && !"".equals(info))
{
  if("1".equals(info))
  {
      info=SystemEnv.getHtmlLabelName(17989,user.getLanguage())+SystemEnv.getHtmlLabelName(15242,user.getLanguage());
  }
  else if("2".equals(info))
  {
      info=SystemEnv.getHtmlLabelName(17989,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage());
  }
%>
<script language="JavaScript">
<%if(info!=null && !info.equals("")){
    if(info.equals("1")){%>
      top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18563,user.getLanguage())%>')
    <%}
 }%>
</script>
<%
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";

int monitor=userid;

String outFields = "1 as ranking__ , r.count,r.id,r.monitortype,r.typename,r.typeorder ";
String backfields = "";
String sqlfrom = "";
String sqlwhere = " where 1 = 1";
String sqlorderby = "";

int detachable=0;
if(manageDetachComInfo.isUseWfManageDetach()){
	detachable = 1;
}
boolean hasFullControl = false;
int operatelevel=0;
if(detachable == 1){
	operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", subcompanyid);
	if(operatelevel < 2 && subcompanyid == 0){
	    int[] subcompanyid2 = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowMonitor:All",2);
		if(subcompanyid2 != null){
	    	hasFullControl = subcompanyid2.length > 0;
		}
	}
	//当开启分权，系统管理员初始化分部值
	if(user.getUID() == 1){
		 rs.executeProc("SystemSet_Select","");
         if(rs.next()){
             int subcompanyidtemp = Util.getIntValue(rs.getString("wfdftsubcomid"),0);
             if(subcompanyidtemp > 0){
			    rs.executeUpdate("update workflow_monitor_info set subcompanyid = ? where subcompanyid = 0",subcompanyidtemp);
             }
         }
	}
}
else{
	if (monitorRight){
		operatelevel = 2;
	}
}

String nvlstr = "isnull";
if(RecordSet.getDBType().equals("oracle"))
	nvlstr = "nvl";
sqlwhere += " and a.monitortype = b.id";

if(typeid>0){
	sqlwhere += " and "+nvlstr+"(a.monitortype,0) = "+typeid;
}


if(!"".equals(flowTitle)){
	sqlwhere += " and exists (select 1 from (                                                         ";
	sqlwhere += " select id,lastname,1 jktype from hrmresource where lastname like '%"+flowTitle+"%'  ";
	sqlwhere += " union                                                                               ";
	sqlwhere += " select id,rolesmark,2 jktype from hrmroles where rolesmark like '%"+flowTitle+"%'   ";
	sqlwhere += " union                                                                           ";
	sqlwhere += " select id,lastname,3 jktype from hrmresourcemanager where lastname like '%"+flowTitle+"%'  ";
	if(RecordSet.getDBType().equals("oracle"))
		sqlwhere += " ) t where a.jktype = t.jktype and instr(','||a.jkvalue||',' , ','|| t.id ||',') > 0)   ";
	else
		sqlwhere += " ) t where a.jktype = t.jktype and ','+cast(a.jkvalue as varchar)+',' like '%,'+ cast(t.id as varchar) +',%')   ";
}

if(!"".equals(inputt11)){
	if(RecordSet.getDBType().equals("oracle"))
		sqlwhere += " and  instr(','||a.jkvalue||',' , ','|| '"+inputt11+"' ||',') > 0 ";
	else
		sqlwhere += " and  ','+a.jkvalue+',' like '%,'+ '"+inputt11+"' +',%' ";
}
if(!"".equals(inputt22)){
	sqlwhere += " and a.monitortype = '"+inputt22+"' ";
}

if(detachable == 1){
    if(subcompanyid  >  0){
        sqlwhere += " and a.subcompanyid = "+subcompanyid;  
    }
    String hasRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowMonitor:All",-1);
    if(StringUtils.isNotBlank(hasRightSub)){
        //sqlwhere += " and a.subcompanyid in ("+hasRightSub+")";
		sqlwhere += " and ("+Util.getSubINClause(hasRightSub, "a.subcompanyid", "in") +")";
    }else{
    	sqlwhere += " and 1 = 2";
	}
}


sqlfrom += " workflow_monitor_info a, workflow_monitortype b ";
backfields += " flowcount count,a.id,"+nvlstr+"(a.monitortype, 0) as monitortype,b.typename,a.subcompanyid,b.typeorder,a.fwtype,a.fwvalue";

sqlorderby += "  a.id ";
String typeid01 = String.valueOf(typeid);
//out.println("select " + backfields + " from " + sqlfrom + sqlwhere);
String typename = "";
if(!"".equals(inputt22)){
	RecordSet.execute("select typename from workflow_monitortype where id = " + inputt22);
	RecordSet.next();
	typename = RecordSet.getString(1);
}
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel > 0|| hasFullControl)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addM(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
} 
if(operatelevel > 1|| hasFullControl){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deltype(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="formSearchg" name="formSearchg" method="post" action="/system/systemmonitor/workflow/systemMonitorStatic.jsp">
<!-- 2014-07-17 -->
<INPUT type="hidden" name="typeid"  id ="typeid" value=<%=typeid%>>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SYSTEM_MONITOR %>"/>
<TABLE class=Shadow>
	<tr>
		<td valign="top">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%if(operatelevel > 0|| hasFullControl){ %> 
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="addM()"/>	
					<%} if(operatelevel > 1|| hasFullControl){%>		
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
					<%} %>
					<input type="text" class="searchInput" name="flowTitle"  value="<%=flowTitle%>"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelNames("81804", user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
					<wea:layout type="fourCol">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
							<wea:item><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></wea:item>
							<wea:item>
								<table style="width:100%"><tr>
						<td style="width:50%">
						<SELECT style="width:100%" name=jktype onchange="doShow(this)">
							<option value="1" <%if("1".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							<%if(isadmin) {%>
								<option value="3" <%if("3".equals(jktype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
							<%} %>
						</SELECT>
						</td>
						<td style="width:50%">
							<span id="showresource" style="display:<%=resourcedisplay %>">
							<brow:browser viewType="0" name="hrmids" browserValue='<%=hrmids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=1" width="100%" browserSpanValue='<%=hrmname %>' >
							</brow:browser>
							</span>
							<span id="showrole" style="display:<%=roledisplay %>">
							<brow:browser viewType="0" name="roleids" browserValue='<%=roleids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
								completeUrl="/data.jsp?type=65" width="100%" browserSpanValue='<%=rolename %>' >
							</brow:browser>
							</span>
							<span id="showresourcemanager" style="display:<%=managerdisplay %>">
							<brow:browser viewType="0" name="hrmmanageids" browserValue='<%=hrmmanageids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/sysadminBrowser.jsp?_from=systemMonitorStatic"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=sysadmin" width="100%" browserSpanValue='<%=adminname %>'>
							</brow:browser>
							</span>
						</td>
						</tr></table>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser name="inputt22" viewType="0" hasBrowser="true" hasAdd="false" 
		             				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/monitor/monitortypeBrowser.jsp?selectedids=" isMustInput="1" isSingle="true" hasInput="true"
		              				completeUrl="/data.jsp?type=monitortypeBrowser"  width="150px" browserValue='<%=inputt22 %>' browserSpanValue='<%=typename %>'/> 
							</wea:item>
						</wea:group>
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="toolbar">
								<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit();"/>
								<span class="e8_sep_line">|</span>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
								<span class="e8_sep_line">|</span>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
					</wea:layout>
				
			</div>
<%

//String sqlWhere = "";
String tableString = "";

tableString =   " <table instanceid=\"WorkflowMonitorListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SYSTEM_MONITOR,user.getUID())+"\" >"+
				" 		<checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" showmethod=\"weaver.workflow.monitor.Monitor.getCheckBox\" />"+
                "       <sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backfields+"\" sqlform=\""+sqlfrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"ranking__\"   />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18560,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.monitor.Monitor.getWorkflowMonitor2\" />";
                //"           <col width=\"10%\"  text=\"type\" hide=\"true\" name=\"monitortype\" column=\"monitortype\" orderkey=\"monitortype\" />";
if(detachable==1){
 tableString += "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.monitor.Monitor.getWorkflowCompanyname\" />";
}
 tableString += " 			<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2239,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\"/>"+
                " 			<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("665,19467", user.getLanguage())+"\" column=\"id\" otherpara=\"column:fwtype+column:fwvalue+"+user.getLanguage()+"\" orderkey=\"typename\" transmethod=\"weaver.workflow.monitor.Monitor.getJkfw\" />"+
                " 			<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18561,user.getLanguage())+"\" column=\"count\" otherpara=\"column:id\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorCount\"/>"+
                " 			<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18562,user.getLanguage())+"\" column=\"id\" otherpara=\"column:subcompanyid+column:monitortype+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.monitor.Monitor.getshowMonitorDetail\"/>"+
                "       </head>"+
                "		<operates>"+
                "		<popedom otherpara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" transmethod=\"weaver.workflow.monitor.Monitor.getCanDelTypeList\"></popedom> "+
                "		<operate href=\"javascript:newDialog();\" otherpara=\"column:subcompanyid+column:monitortype\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" otherpara=\"column:subcompanyid+column:monitortype\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+  
                " </table>";

%>

			<TABLE width="100%" cellspacing=0>
			    <tr>
			        <td valign="top">  
			            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			        </td>
			    </tr>
			</TABLE>
		</td>
	</tr>
</TABLE>

</form>
<!-- 2014-07-17 -->

</BODY>

<script type="text/javascript">
var diag_vote;
   jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

	function doSubmit() {
		var isselected = "#formSearchg";
		jQuery(isselected).find("input[type='text']").val("");
		document.formSearchg.submit();
	}

	function reSetInputt1(){
		//var typename=$("input[name='flowTitle']",parent.document).val();
		//$("input[name='inputt2__']").val(typename);
	}

	function onBtnSearchClick(){
		var isselected = "#formSearchg";
		jQuery(isselected).find(".e8_os").find("span.e8_showNameClass").remove();
		jQuery(isselected).find(".e8_os").find("input[type='hidden']").val("");
		document.formSearchg.submit();
	}

function detailDialog(infoid,monitortype){
	var url = "/system/systemmonitor/workflow/systemMonitorDetail.jsp?infoid="+infoid+"&typeid="+monitortype;
	var dlg=new window.top.Dialog();//定义Dialog对象
	var title = "<%=SystemEnv.getHtmlLabelNames("665,18562", user.getLanguage()) %>";
	dlg.currentWindow = window;
	dlg.Model=false;
	//dlg.Width = 1020;
	//dlg.Height = 600;
	var ht = window.screen.height;
	var wt = window.screen.width;
	dlg.Width = wt;
	dlg.Height = ht;
	//dlg.maxiumnable=true;
	//dlg.DefaultMax=true;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
}
	
function detailDialog1(infoid,subcompanyid,monitortype){
	var url = "/system/systemmonitor/workflow/systemMonitorDetail.jsp?infoid="+infoid+"&subcompanyid="+subcompanyid+"&typeid="+monitortype;
	var dlg=new window.top.Dialog();//定义Dialog对象
	var title = "<%=SystemEnv.getHtmlLabelNames("665,18562", user.getLanguage()) %>";
	dlg.currentWindow = window;
	dlg.Model=false;
	//dlg.Width = 1020;
	//dlg.Height = 600;
	var ht = window.screen.height;
	var wt = window.screen.width;
	dlg.Width = wt;
	dlg.Height = ht;
	//dlg.maxiumnable=true;
	//dlg.DefaultMax=true;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
}
	
function newDialog(infoid,obj){
	var temstr = obj.split("+");
	var subcompanyid = "";
	var monitortype = "";
	var url = "";
	if("<%=detachable%>"=="1"){
		subcompanyid = temstr[0];
		monitortype = temstr[1];
		url = "/system/systemmonitor/workflow/systemMonitorSet.jsp?infoid="+infoid+"&subcompanyid="+subcompanyid+"&typeid="+monitortype+"&queryTypeid=<%=typeid%>";
	}else{
		monitortype = temstr[1];
		url = "/system/systemmonitor/workflow/systemMonitorSet.jsp?infoid="+infoid+"&typeid="+monitortype+"&queryTypeid=<%=typeid%>";
	}
	var dlg=new window.top.Dialog();//定义Dialog对象
	var title = "<%=SystemEnv.getHtmlLabelNames("93,665", user.getLanguage()) %>";
	dlg.currentWindow = window;
	dlg.Model=false;
	var ht = window.screen.height;
	var wt = window.screen.width;
	dlg.Width = wt;
	dlg.Height = ht;
	//dlg.maxiumnable=true;
	//dlg.DefaultMax=true;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
}

   function onDel(id,obj){
		var temstr = obj.split("+");
		var subid = "";
		var typeid = "";
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			subid = temstr[0];
			typeid = temstr[1];
			window.location = "/system/systemmonitor/workflow/systemMonitorOperation.jsp?infoid="+id+"&actionKey=del&subcompanyid="+subid+"&typeid="+typeid+"&detachable=<%=detachable%>&monitortypeid=<%=typeid01%>";
		}, function () {}, 320, 90,true);
   }
   
   function deltype(){
		var infoids = "";
		var typeids = "";
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked")){
				infoids = infoids +$(this).attr("checkboxId")+",";
				//typeids = typeids + jQuery(this).parent().parent().parent().find("td").eq(3).text()+",";
				typeids = typeids + jQuery(this).parent().parent().parent().find("td[name='monitortype']").html()+",";
			}
		});
		if(infoids==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			return false;
		}
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			window.location = "/system/systemmonitor/workflow/systemMonitorOperation.jsp?infoids="+infoids+"&actionKey=deleteAll&typeids="+typeids+"&monitortypeid=<%=typeid01%>";
		}, function () {}, 320, 90,true);
	}
   
	function addM(){
		//window.location.href="/system/systemmonitor/workflow/systemMonitorSet.jsp?subcompanyid=<%=subcompanyid%>&typeid=<%=typeid%>";
		var url = "/system/systemmonitor/workflow/systemMonitorSet.jsp?subcompanyid=<%=subcompanyid%>&typeid=<%=typeid%>";
		var dlg=new window.top.Dialog();//定义Dialog对象
		var title = "<%=SystemEnv.getHtmlLabelNames("82,665", user.getLanguage()) %>";
		dlg.currentWindow = window;
		dlg.Model=false;
		var ht = window.screen.height;
		var wt = window.screen.width;
		dlg.Width = wt;
		dlg.Height = ht;
		//dlg.maxiumnable=true;
		//dlg.DefaultMax=true;
		dlg.URL=url;
		dlg.Title=title;
		dlg.show();
	}
   
   function mnToggleleft(){
		var f = window.parent.document.getElementById("oTd1").style.display;	
		if (f != null) {
			if (f==''){
				window.parent.document.getElementById("oTd1").style.display='none'; 			
			}else{ 
				window.parent.document.getElementById("oTd1").style.display=''; 
			}
		}
	}  

   function doShow(obj){
		var thisvalue = obj.value;
		if(thisvalue==1){
			$GetEle("showresource").style.display='';
			$GetEle("showrole").style.display='none';
			$GetEle("showresourcemanager").style.display='none';
		}
		
		if(thisvalue==2){
			$GetEle("showresource").style.display='none';
			$GetEle("showrole").style.display='';
			$GetEle("showresourcemanager").style.display='none';
		}
		
		if(thisvalue==3){
			$GetEle("showresource").style.display='none';
			$GetEle("showrole").style.display='none';
			$GetEle("showresourcemanager").style.display='';
		}
		
	} 

   function viewDepartment(departmentid) {
		openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+departmentid)
	}
	
	function viewSubCompany(subcompanyid) {
		openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp&id="+subcompanyid)
	}

	function viewRole(roleid){
		openFullWindowForXtable("/hrm/roles/HrmRolesEdit.jsp?id="+roleid)
	}
 </script>

</HTML>


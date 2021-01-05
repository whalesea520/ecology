<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();	
	
});

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='requestname']").val(typename);
	window.location="/system/systemmonitor/workflow/WorkflowToDocTab.jsp?requestname="+typename;
}
</script> 
</head>

<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>)
 <%}
 else if("rbfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>)
 <%}
 else{
 
 }
 }%>
</script>
<%----xwj for td3665 20060301 end---%>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22231,user.getLanguage());
String needfav ="1";
String needhelp ="";
String offical = Util.null2String(request.getParameter("offical"));

if(!HrmUserVarify.checkUserRight("workflowtodocument:all",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(34257,user.getLanguage())+",javascript:WorkflowToDoc(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id=weaver name=weaver method=get action="WorkflowToDocTab.jsp"><%--xwj for td2978 20051108--%>
<input type=hidden name=fromself value="1">
<input type=hidden name=operation>

<%

ArrayList canoperaternode = new ArrayList(); //added by xwj  for td2903  20051019

/* --- added by xwj  for td2903  20051019 --  B E G I N ---*/
ArrayList monitorWfList = new ArrayList();
String monitorWfStrs = "";

String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String requestname ="" ;//added xwj for for td2903  20051019
String workcode = Util.null2String(request.getParameter("workcode"));//编号
String typeid = Util.null2String(request.getParameter("typeid"));//流程类型id
String ownerdepartmentid = Util.null2String(request.getParameter("ownerdepartmentid"));//创建人部门
String creatersubcompanyid = Util.null2String(request.getParameter("creatersubcompanyid"));//创建人分部id

String fromself =Util.null2String(request.getParameter("fromself"));

workflowid = Util.null2String(request.getParameter("workflowid"));
nodetype = Util.null2String(request.getParameter("nodetype"));
fromdate = Util.null2String(request.getParameter("fromdate"));
todate = Util.null2String(request.getParameter("todate"));
creatertype = Util.null2String(request.getParameter("creatertype"));

if("0".equals(creatertype)){
	createrid = Util.null2String(request.getParameter("createrid"));
}else if("1".equals(creatertype)){
	createrid = Util.null2String(request.getParameter("createrid2"));
}
requestlevel = Util.null2String(request.getParameter("requestlevel"));
requestname = Util.null2String(request.getParameter("requestname"));//added xwj for for td2903  20051019

String recievedatefrom = Util.null2String(request.getParameter("recievedatefrom"));
String recievedateto = Util.null2String(request.getParameter("recievedateto"));
int wfstatu = Util.getIntValue(request.getParameter("wfstatu"),0);//处理状态
int isdeleted= Util.getIntValue(request.getParameter("isdeleted"),0);//流程状态
int archivestyle = Util.getIntValue(request.getParameter("archivestyle"),0);//归档状态
String unophrmid = Util.null2String(request.getParameter("unophrmid"));




String newsql=" ";
//查询流程的所有版本数据
if(!workflowid.equals("")&&!workflowid.equals("0")){
    String wfids = WorkflowVersion.getVersionStringByWfid(workflowid);
    if("".equals(wfids)){
        wfids = workflowid;
    }
	newsql+=" and a.workflowid in("+wfids+")";
}
if(!nodetype.equals(""))
    newsql += " and currentnodetype='"+nodetype+"'";

if(!fromdate.equals(""))
    newsql += " and createdate>='"+fromdate+"'";

if(!todate.equals(""))
    newsql += " and createdate<='"+todate+"'";

if(!createrid.equals("")){
    newsql += " and creater='"+createrid+"'";
    newsql += " and creatertype= '"+creatertype+"' ";
}

if(!requestlevel.equals(""))
    newsql += " and requestlevel="+requestlevel;

if(!requestname.equals(""))
    newsql += " and requestname like '%"+requestname+"%' ";

if (!workcode.equals(""))
	newsql += " and a.creatertype= '0' and a.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";
	
if(!typeid.equals("") && !typeid.equals("0")){//类别
	newsql += " and b.workflowtype='" + typeid + "'";
}

//虚拟部门 客户部门
if(StringUtil.isNotNull(ownerdepartmentid)||StringUtil.isNotNull(creatersubcompanyid)){
    newsql += " and exists (select 1 from hrmresource c where c.id = a.creater ";
    if(StringUtil.isNotNull(ownerdepartmentid)){
        newsql+= " and c.departmentid = "+ownerdepartmentid;
    }
    if(StringUtil.isNotNull(creatersubcompanyid)){
        newsql+= " and c.subcompanyid1 = "+creatersubcompanyid;
    }
    newsql+=" union all select 1 from HrmResourceVirtualView d where a.creater = d.id ";
    if(StringUtil.isNotNull(ownerdepartmentid)){
        newsql+= " and d.departmentid = "+ownerdepartmentid;
    }
    if(StringUtil.isNotNull(creatersubcompanyid)){
        newsql+= " and d.subcompanyid1 = "+creatersubcompanyid;
    }
    newsql += ")";
}


//处理状态
if(wfstatu!=0 || archivestyle!=0 || !recievedatefrom.equals("") ||!recievedatefrom.equals("")){
    newsql+= " and exists (select 1 from workflow_currentoperator t where a.requestid = t.requestid ";
	if(wfstatu==1){
		newsql+= " and t.isremark in ( '0','1','5','8','9','7')";
	}
	if(wfstatu == 2){
	    newsql+= " and t.isremark in ('2','4')";
	}
	
	if (archivestyle == 1) {
		newsql+= " and t.iscomplete<>1";//未归档				
	}
	if(archivestyle == 2){
		newsql+= " and t.iscomplete=1";//归档
	}
	
	//接受日期
	if(!recievedatefrom.equals(""))
	    newsql+= " and t.receivedate>='"+recievedatefrom+"'";

	if(!recievedatefrom.equals(""))
	    newsql+= " and t.receivedate<='"+recievedateto+"'";
	
	newsql+=")";
}


WfAdvanceSearchUtil wfd = new WfAdvanceSearchUtil(request,RecordSet);
//相关文档docinputname
newsql +=wfd.handleDocCondition("a.docids");
//相关人力资源
newsql +=wfd.handleHrmCondition("a.hrmids");
//相关客户
newsql +=wfd.handleCrmCondition("a.crmids");
//相关项目
newsql +=wfd.handleProsCondition("a.prjids");


//流程状态
if(isdeleted==0){
	isdeleted=1;
}else if(isdeleted==1){
	isdeleted=0;
}
if(isdeleted!=2){
	if (isdeleted == 0) {				
		newsql +=" and b.isvalid = '0'";
	} else if (isdeleted == 1) {	
		newsql +=" and b.isvalid <> '0'";
	}
}

//未操作者
if (!unophrmid.equals("")) {
    newsql += " and exists (select 1 from workflow_currentoperator t where t.requestid = a.requestid and t.userid='" + unophrmid + "' and (isremark in ('0','1','5','7','8','9') OR (isremark='4' AND viewtype=0)))";
}


//newsql+=" and a.workflowid=b.workflowid and b.monitorhrmid = " + user.getUID()+" ";
newsql+=" and a.workflowid=b.id and b.wfdocpath is not null and b.wfdocpath <>' ' ";
String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
String userlang = ""+user.getLanguage();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String sqlwhere="where requestid > 0 " +newsql ;
String orderby=" createdate ,createtime ";

String tablename = "wrktablename"+ Util.getRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

String _createrid = Util.null2String(request.getParameter("createrid"));
String _createrid2 = Util.null2String(request.getParameter("createrid2"));
String _ownerdepartmentid_name = request.getParameter("ownerdepartmentid_name");
String _creatersubcompanyid_name = request.getParameter("creatersubcompanyid_name");
String _recievedatefrom = Util.null2String(request.getParameter("recievedatefrom"));
String _recievedateto = Util.null2String(request.getParameter("recievedateto"));
String _unophrmid = request.getParameter("unophrmid");
String _unophrmid_name = request.getParameter("unophrmid_name");
String _docids = request.getParameter("docids");
String _docids_name = request.getParameter("docids_name");
String _hrmcreaterid = request.getParameter("hrmcreaterid");
String _hrmcreaterid_name = request.getParameter("hrmcreaterid_name");
String _crmids = request.getParameter("crmids");
String _crmids_name = request.getParameter("crmids_name");
String _proids = request.getParameter("proids");
String _proids_name = request.getParameter("proids_name");
String _creatersubcompanyid =  request.getParameter("creatersubcompanyid");


String _creatersubcompanySpanVal = SubCompanyComInfo.getSubCompanyname(Util.null2String(request.getParameter("creatersubcompanyid")));
String _unophrmidSpanVal = ResourceComInfo.getLastname(Util.null2String(request.getParameter("unophrmid")));
String _docidsSpanVal = DocComInfo.getDocname(Util.null2String(request.getParameter("docids")));
String _hrmcreateridSpanVal = ResourceComInfo.getLastname(Util.null2String(request.getParameter("hrmcreaterid")));
String _crmidsSpanVal = CustomerInfoComInfo.getCustomerInfoname(Util.null2String(request.getParameter("crmids")));
String _proidsSpanVal = ProjectInfoComInfo.getProjectInfoname(Util.null2String(request.getParameter("proids")));

%>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(34257,user.getLanguage()) %>" class="e8_btn_top" onclick="WorkflowToDoc()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=requestname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">	
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	 <input type="text" style='' name="requestname" value="<%=requestname %>" />
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
		    	<wea:item><input type="text" style='' name="workcode" value="<%=workcode %>" ></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
		    	<% 
		    		String wfbytypeBrowserURL = "/workflow/workflow/WFTypeBrowserContenter.jsp";
		    		String typename = "";
		    		if(!typeid.equals("") && !typeid.equals("0")){
		    	    	RecordSet.executeQuery("select typename from workflow_type where id = ?",typeid);
		    	    	if(RecordSet.next()){
		    	    	    typename = Util.null2String(RecordSet.getString(1));
		    	    	}
		    		}
		    	%>
		    	<wea:item>
    		    	<brow:browser viewType="0" name="typeid" browserValue="<%=typeid %>"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser="true"
					isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
					browserDialogWidth="600px"
					browserSpanValue="<%=typename %>"></brow:browser>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	 <brow:browser viewType="0" name="workflowid" browserValue="<%=workflowid %>" onPropertyChange="loadCustomSearch($('#workflowid').val())" browserOnClick="" browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('workflowBrowser')" width="80%" browserSpanValue="<%=WorkflowComInfo.getWorkflowname(workflowid) %>"> </brow:browser>
			    	 <input type="hidden" id="workflowid_name" name="workflowid_name" value="<%=request.getParameter("workflowid_name")%>"/> 
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<select class=inputstyle name=requestlevel style='' size=1>
						<option value="" ></option>
						<option value="0"><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
						<option value="1"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
					</select>
		    	</wea:item>
		    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
		    	<wea:item >
			        <span  style='float:left'>
						<select class=inputstyle name=creatertype  style='height:25px;width:100px;' onchange="changeType(this.value,'createridse1span','createridse2span');">
							<%if (!user.getLogintype().equals("2")) {%>
								<option value="0" <%if("0".equals(creatertype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></option>
							<%}%>
								<option value="1" <%if("1".equals(creatertype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
						</select>								
					</span>
					<span id="createridse1span" style="">
						<brow:browser viewType="0" id="createrid" name="createrid" browserValue="<%=_createrid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue="<%=ResourceComInfo.getLastname(_createrid) %>"> 
					   </brow:browser> 
					</span>
					<span id="createridse2span" style="display:none;">
						<brow:browser viewType="0" id="createrid2" name="createrid2" browserValue="<%=_createrid2 %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px;" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18"  browserSpanValue="<%=CustomerInfoComInfo.getCustomerInfoname(_createrid2) %>"> 
						</brow:browser> 
					</span>
		    	</wea:item>
		    	
		    </wea:group>
		     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  >
		    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		 <brow:browser viewType="0" name="ownerdepartmentid" browserValue="<%=ownerdepartmentid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue="<%=DepartmentComInfo.getDepartmentName(ownerdepartmentid) %>"> </brow:browser>
		    		 <input type="hidden" id="ownerdepartmentid_name" name="ownerdepartmentid_name" value="<%=_ownerdepartmentid_name%>"/>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<brow:browser viewType="0" name="creatersubcompanyid" browserValue="<%=_creatersubcompanyid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue="<%=_creatersubcompanySpanVal %>"> </brow:browser> 
		    		<input type="hidden" id="creatersubcompanyid_name" name="creatersubcompanyid_name" value="<%=_creatersubcompanyid_name%>"/>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
		    	<wea:item  attributes="{'colspan':'3'}">
		    		<span class="wuiDateSpan" selectId="recievedateselect" selectValue="">
						<input class="wuiDateSel" type="hidden" name="recievedatefrom" value="<%=_recievedatefrom%>">
						<input class="wuiDateSel" type="hidden" name="recievedateto" value="<%=_recievedateto%>">
					</span>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
		    	<wea:item>
		            <select class=inputstyle size=1 style='' name="wfstatu">
						<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(24627, user.getLanguage())%></option>
					</select>
		    	</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class="inputstyle" size="1" style='' name="archivestyle">
						<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class="inputstyle"  size="1" name="isdeleted" style=''>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				    </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class="inputstyle" size="1" name="nodetype" style=''>
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%></option>
						<option value="3" ><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
				<wea:item>
			        <brow:browser viewType="0" name="unophrmid" browserValue="<%=_unophrmid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue="<%=_creatersubcompanySpanVal %>"> </brow:browser>
			         <input type="hidden" id="unophrmid_name" name="unophrmid_name" value="<%=_unophrmid_name%>"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
				<wea:item>
		          	<brow:browser viewType="0" name="docids" browserValue="<%=_docids %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('9')" width="80%" browserSpanValue="<%=_docidsSpanVal %>"> </brow:browser>
		          	<input type="hidden" id="docids_name" name="docids_name" value="<%=_docids_name%>"/>
				</wea:item>
				<%if(!offical.equals("1")){ %>
					<wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
					<wea:item>
				         <brow:browser viewType="0" name="hrmcreaterid" browserValue="<%=_hrmcreaterid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue="<%=_hrmcreateridSpanVal %>"> </brow:browser>
				         <input type="hidden" id="hrmcreaterid_name" name="hrmcreaterid_name" value="<%=_hrmcreaterid_name%>"/>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
					<wea:item>
				         <brow:browser viewType="0" name="crmids" browserValue="<%=_crmids %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('18')" width="80%" browserSpanValue="<%=_crmidsSpanVal %>"> </brow:browser>
				         <input type="hidden" id="crmids_name" name="crmids_name" value="<%=_crmids_name%>"/>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
					<wea:item>
			        	<brow:browser viewType="0" name="proids" browserValue="<%=_proids %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('135')" width="80%" browserSpanValue="<%=_proidsSpanVal %>"> </brow:browser>
			        	<input type="hidden" id="proids_name" name="proids_name" value="<%=_proids_name%>"/>
					</wea:item>
				<%} %>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
					<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="button"  onclick="onReset()" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
<input name=start type=hidden value="<%=start%>">
<input type=hidden name=multiSubIds id=multiSubIds>


<%
String tableString = "";
String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel,0 as isview ";
String fromSql  = " workflow_requestbase a,workflow_base b";
String sqlWhere = sqlwhere;
//out.print("select "+backfields + "from "+fromSql+" where "+sqlWhere);
String para1="column:requestid+column:isview+column:workflowid+"+userlang;
String para4=userlang+"+"+user.getUID();

tableString =   " <table tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_TODOC,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultFlowName\"  otherpara=\""+para1+"\" />"+
                "           <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,a.requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
                "           <col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
                "           <col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"currentnodeid\"  transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\" />"+
                "           <col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(18565,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators2\" />"+
                "           <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
                "       </head>"+
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>

<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_TODOC%>"/>
</form>


<SCRIPT language="javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			curl = "#";
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ rid + "'>"
						+ rname + "</a>";
			} else {
				spanobj.innerHTML = rname;
			}
			inputobj.value = rid;
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function getajaxurl(type) {
	/*
	var tmpval = $GetEle("creatertype").value;
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp";
	}else {
		url = "/data.jsp?type="+type;
	}*/	
	return "/data.jsp?type="+type;
}
function onChangeResource(){
	var tmpval = $GetEle("creatertype").value;
	var tempurl1 = "";
	if (tmpval == "0") {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	}else {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	return tempurl1;
}
function oncreatertype(e){
	var target=e.srcElement||e.target;
	$("#createrid").val("");
	$("#createrid").next().html("");
	if($(target).val()=="0")
		$("#createrid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	else{
		$("#createrid").attr("_url","/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	}
}
function OnChangePage(start){
        document.weaver.start.value = start;
		document.weaver.submit();
}

var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.top=pTop;
     message_Div1.style.left=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(requestid,returntdid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}

function changeType(type,span1,span2){
	if(type=="1"){
		jQuery("#"+span1).css("display","none");
		jQuery("#"+span2).css("display","");
		cleanBrowserValue('createrid');	
	}else{
		jQuery("#"+span2).css("display","none");
		jQuery("#"+span1).css("display","");
		cleanBrowserValue('createrid2');
	}
}

function setSelectBoxValue(selector, value) {
	if (value == null) {
		value = selector.find('option').first().val();
	}
	selector.selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
}

function onReset() {
	//browser
	jQuery('#advancedSearchDiv .e8_os input[type="hidden"]').each(function() {
		cleanBrowserValue(jQuery(this).attr('name'));
	});
	//input
	jQuery('#advancedSearchDiv').find('input[type=hidden]').val('');
	jQuery('#advancedSearchDiv').find('input[type=text]').val('');

	jQuery('#tabcontentframe_box',window.parent.document).find('input[type=text]').val('');
	//select
	jQuery('#advancedSearchDiv select').each(function() {
		setSelectBoxValue(jQuery(this));
	});
}

function cleanBrowserValue(name) {
	_writeBackData(name, 1, {id:'',name:''});
}

function WorkflowToDoc(){
	var multiSubIds =  _xtable_CheckedCheckboxId();
	if(multiSubIds=="" || multiSubIds == null){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return;
	}
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22232,user.getLanguage())%>", function (){
		_displayloaddingblock();
		jQuery.ajax({
			url : "/system/systemmonitor/workflow/WorkflowToDocOperation.jsp",
			type : "post",
			data:'operation=wftodoc&multiSubIds='+multiSubIds,
			success: function(){
				_hidloaddingblock();
				weaver.submit();
			}
		});	
	}, function () {}, 320, 90,false);
} 

function _displayloaddingblock() {
	try {
		var pTop= parent.document.body.offsetHeight/2+parent.document.body.scrollTop - 50 + jQuery(".e8_boxhead", parent.document).height()/2 ;
		var pLeft= parent.document.body.offsetWidth/2 - (65);
		jQuery("#submitloaddingdiv", parent.document).css({"top":pTop, "left":pLeft, "display":"inline-block;"});
		jQuery("#submitloaddingdiv", parent.document).show();
		jQuery("#submitloaddingdiv_out", parent.document).show();
	} catch (e) {}
}
function _hidloaddingblock() {
	try {
		jQuery("#submitloaddingdiv", parent.document).hide();
		jQuery("#submitloaddingdiv_out", parent.document).hide();
	} catch (e) {}
}
jQuery(document).ready(function () {
	changeType('<%=creatertype%>','createridse1span','createridse2span');
	setSelectBoxValue(jQuery('#advancedSearchDiv').find('select[name=requestlevel]'),'<%=requestlevel%>');
	setSelectBoxValue(jQuery('#advancedSearchDiv').find('select[name=wfstatu]'),'<%=Util.null2String(request.getParameter("wfstatu"))%>');
	setSelectBoxValue(jQuery('#advancedSearchDiv').find('select[name=archivestyle]'),'<%=Util.null2String(request.getParameter("archivestyle"))%>');
	setSelectBoxValue(jQuery('#advancedSearchDiv').find('select[name=isdeleted]'),'<%=Util.null2String(request.getParameter("isdeleted"))%>');
	setSelectBoxValue(jQuery('#advancedSearchDiv').find('select[name=nodetype]'),'<%=Util.null2String(request.getParameter("nodetype"))%>');
});
</script>
</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

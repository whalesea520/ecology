<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	frmSearch.action="/hrm/resource/HrmResourceSys.jsp"
	jQuery("#frmSearch").submit();
}

function onBtnRefresh(){
	window.location.reload();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function onBatchSave(){
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	if(dialog==null)dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/resource/HrmResourceSysManagerEdit.jsp?isdialog=1&resourceid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(27827,user.getLanguage())%>";
	dialog.Width = 400;
	dialog.Height = 200;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.show();
}

function onBatchJobTitleSave(){
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	if(dialog==null)dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/resource/HrmResourceSysJobTitleEdit.jsp?isdialog=1&resourceid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("25465,6086",user.getLanguage())%>";
	dialog.Width = 400;
	dialog.Height = 200;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.show();
}


function onBatchDept(){
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/resource/HrmResourceSysDepartEdit.jsp?isdialog=1&resourceid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("20839,6090,124",user.getLanguage())%>";
	dialog.Width = 400;
	dialog.Height = 200;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.show();
}

function onBatchBelongtoSave(){
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	var accounttype="";
	jQuery("input[name=chkInTableTag]").each(function(){
		var checkboxid = jQuery(this).attr("checkboxid");
		if((","+id+",").indexOf(","+checkboxid+",")!=-1){
			if(accounttype.length>0)accounttype+=",";
			accounttype += jQuery(this).parent().parent().parent().find("input[name=accounttype]").val();
		}
	}) 
	accounttype = ","+accounttype+",";
	if(accounttype.indexOf(",0,")!=-1&&accounttype.indexOf(",1,")!=-1){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125528,user.getLanguage())%>");
		return false;
	}
	
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceSysBelongtoEdit&isdialog=1&ids="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125524,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.show();
}

function onValidateCode(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/resource/HrmResourceSysValidateCode.jsp?isdialog=1&resourceid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("18725",user.getLanguage())%>";
	dialog.Width = 400;
	dialog.Height = 200;
	dialog.Drag = true;
	dialog.normalDialog = false;
	dialog.URL = url;
	dialog.show();
}


function afterValidateSave(obj){
 jQuery("input[name='validatecode']").val(jQuery.trim(obj));
	frmSearch.submit(); 
}

//id, dsporder, loginid, password, email, manager, seclevel, passwordstate, needusb,
var pluginId = {
		type:"hidden",
		name:"id",
		addIndex:false
	};
var pluginAccounttype = {
		type:"hidden",
		name:"accounttype",
		addIndex:false
	};
		
var pluginDsporder = {
		type:"input",
		name:"dsporder",
		bind:[
			{type:"keyup",fn:function(){
				checknumberJd(this);
			}}
		],
		addIndex:false,
		notNull:true
	};
	
function checknumberJd(obj){
	if(isNaN(obj.value)== true){
		$(obj).attr("value","");
	}
	if($(obj).val()==""){
		$(obj).attr("value","0.0");
	}
}

var pluginLoginid = {
		type:"input",
		name:"loginid",
		addIndex:false,
		notNull:false
	};

var pluginPassword = {
		type:"password",
		name:"password",
		addIndex:false,
		notNull:true
	};

var pluginEmail = {
		type:"input",
		name:"email",
		addIndex:false,
		notNull:false
	};

var pluginManager={
		type:"browser",
		addIndex:false,
		attr:{
			name:"managerid",
			viewType:"0",
			browserValue:"",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"javascript:openhrm($id$);",
			completeUrl:"/data.jsp",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			width:"98%",
			hasAdd:false,
			isSingle:false
		}
	};
	
function openSmallCard(id){
	pointerXY(event);
	openhrm(id);
}	
	
var pluginDepartment={
		type:"browser",
		addIndex:false,
		attr:{
			name:"departmentid",
			viewType:"0",
			browserValue:"",
			isMustInput:"2",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"javascript:opendepartment($id$);",
			completeUrl:"/data.jsp?type=4",
			browserUrl:"/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp",
			width:"98%",
			hasAdd:false,
			isSingle:false
		}
	};
	
var pluginJobtitle={
		type:"browser",
		addIndex:false,
		attr:{
			name:"jobtitle",
			viewType:"0",
			browserValue:"",
			isMustInput:"2",
			browserSpanValue:"",
			hasInput:true,
			completeUrl:"/data.jsp?type=24",
			browserUrl:"/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/JobTitlesBrowser.jsp",
			width:"98%",
			hasAdd:false,
			isSingle:false
		}
	};

function opendepartment(id){
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&hasTree=false&id="+id);
}
	
function openResouce(id){
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id);
}
	
var pluginSeclevel = {
		type:"input",
		name:"seclevel",
		addIndex:false,
		notNull:true
	};
	
var usbstate = {
		type:"select",
		name:"usbstate",
		defaultValue:"0",
		notNull:false,
		addIndex:false,
		bind:[
			{type:"change",fn:function(){
				//alert("change:passwordstate="+this.value);
			}}
		],
		options:[
		{text:"<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>",value:"0"},
		{text:"<%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%>",value:"1"},
		{text:"<%=SystemEnv.getHtmlLabelName(83726,user.getLanguage())%>",value:"2"}
		]
	};
	
function onShowResource(obj){
	var manageridspan = jQuery(obj).parent().parent().parent().find("span[id=manageridspan]");
	var managerid = jQuery(obj).parent().parent().parent().find("input[id=managerid]");
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas) {
			if(wuiUtil.getJsonValueByIndex(datas,0)!=""){
				var id = wuiUtil.getJsonValueByIndex(datas,0);
				var name = wuiUtil.getJsonValueByIndex(datas,1);
				var sHtml = "";
				if (id != "") {
					sHtml = sHtml + "<a href=/hrm/resource/HrmResource.jsp?id=" + id + ">" + name + "</a>&nbsp";
				}
				jQuery(manageridspan).html(sHtml);
				jQuery(managerid).val(id);
			} else {
				jQuery(manageridspan).html("");
				jQuery(managerid).val("");
			}
		}
}

</script>
</head>
<BODY>
<%
if(!HrmUserVarify.checkUserRight("HrmResourceSys:Mgr",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(15513,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
int minpasslen=settings.getMinPasslen();
String passwordComplexity = settings.getPasswordComplexity();
String checkSysValidate = Util.null2String(settings.getCheckSysValidate());

String saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage()) ;
String saveManager = SystemEnv.getHtmlLabelNames("2191,596",user.getLanguage()) ;
String saveJobtitle = SystemEnv.getHtmlLabelNames("2191,6086",user.getLanguage()) ;
String saveBelong = SystemEnv.getHtmlLabelNames("68,131095",user.getLanguage()) ;
String saveGroup = SystemEnv.getHtmlLabelName(130759,user.getLanguage()) ;
String saveDept = SystemEnv.getHtmlLabelNames("2191,124",user.getLanguage()) ;

String savePwdName = SystemEnv.getHtmlLabelNames("17993",user.getLanguage()) ;

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("HrmResourceSys:Mgr",user)) {
	
if("1".equals(checkSysValidate)){
	RCMenu += "{"+saveName+",javascript:onSave(this,1),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+saveName+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+savePwdName+",javascript:updatePassword(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+saveManager+",javascript:onBatchSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+saveJobtitle+",javascript:onBatchJobTitleSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+saveDept+",javascript:onBatchDept(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+saveGroup+",javascript:addToGroup(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+saveBelong+",javascript:onBatchBelongtoSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
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

String fromHrmTab = Util.null2String(request.getParameter("fromHrmTab")) ;
String did = Util.null2String(request.getParameter("departmentid")) ;
String qname = Util.null2String(request.getParameter("qname")) ;
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String managerid_kwd = Util.null2String(request.getParameter("managerid_kwd")) ;
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1")) ;
String subcompanyid1_kwd=Util.null2String(request.getParameter("subcompanyid1_kwd")) ;
String departmentid = Util.null2String(request.getParameter("departmentid")) ;
String departmentid_kwd=Util.null2String(request.getParameter("departmentid_kwd")) ;
String accounttype = Util.null2String(request.getParameter("accounttype")) ;


String sqlwhere =" where status not in (4,5,6,7) ";
String searchSql = "" ;

if(!qname.equals("")){
searchSql += " and lastname like '%"+qname+"%'";
}		

if(resourceid.length()>0){
searchSql += " and id = '"+resourceid+"'";	
}
if(managerid_kwd.length()>0){
	searchSql += " and managerid = "+managerid_kwd;	
}

if (!"".equals(subcompanyid1)) {
searchSql += " and subcompanyid1 = "+subcompanyid1 ;
}

if (!"".equals(subcompanyid1_kwd)) {
searchSql += " and subcompanyid1 = "+subcompanyid1_kwd ;
}

if (!"".equals(departmentid)) {
	searchSql +=  " and departmentid = "+departmentid ;
}

if (!"".equals(departmentid_kwd)) {
searchSql +=  " and departmentid = "+departmentid_kwd ;
}

if (!"".equals(accounttype)) {
	if(accounttype.equals("1")){
		searchSql +=  " and accounttype=1 " ;
	}else{
		searchSql +=  " and (accounttype=0 or accounttype=null or accounttype is null) " ;
	}
}

if ("1".equals("fromHrmTab")&&!"".equals(did) && "".equals(departmentid_kwd)) {
searchSql +=  " and departmentid = "+did ;
}

if (!"".equals(searchSql)) {
sqlwhere += searchSql ;
}

int[] subcompanyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"HrmResourceSys:Mgr",0);
String subcomids = "";
for(int i=0;subcompanyids!=null&&i<subcompanyids.length;i++){
	if(subcomids.length()>0)subcomids+=",";
	subcomids += subcompanyids[i];
}
if(subcomids.length()>0){
	//sqlwhere += " and subcompanyid1 in("+subcomids+") ";
	sqlwhere += " and ( "+weaver.hrm.common.Tools.getOracleSQLIn(subcomids,"subcompanyid1")+")";
}else{
	sqlwhere += " and 1=2 ";
}

String passwordFlag = "qiwuien";
	
String backfields = " id, accounttype, lastname, dsporder, loginid, '"+passwordFlag+"' as password, email, managerid, " 
									+ " seclevel, usbstate, needusb, subcompanyid1, departmentid,jobtitle ";
String fromSql  = " from hrmresource ";
String orderby = " dsporder,lastname " ;

//姓名		显示顺序			登录名					密码					安全级别		 usb加密保护			动态密码	
String tableString =" <table pageId=\""+PageIdConst.HRM_ResourceSys+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceSys,user.getUID(),PageIdConst.HRM)+"\">"+
					 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"Asc\" />"+
          "			<head>"+
          "				<col width=\"0%\" hide=\"true\" editPlugin=\"pluginId\" text=\"\" column=\"id\"/>"+
          "				<col width=\"0%\" hide=\"true\" editPlugin=\"pluginAccounttype\" text=\"\" column=\"accounttype\"/>"+
          "				<col width=\"3%\" text=\"\" column=\"accounttype\" transmethod=\"weaver.hrm.resource.ResourceComInfo.accounttype\" />"+
        //"				<col width=\"15%\" labelid=\"413\"  text=\""+SystemEnv.getHtmlLabelName(25034,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/hrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />"+
		  		"				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(25034,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\" />"+
          "				<col width=\"10%\" editPlugin=\"pluginDsporder\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" />"+
          "				<col width=\"8%\" editPlugin=\"pluginLoginid\"  text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"loginid\" orderkey=\"loginid\"/>"+
          "				<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(409,user.getLanguage())+"\" column=\"password\" orderkey=\"password\"/>"+
          //"				<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+"\" column=\"managerid\" orderkey=\"managerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\" />"+
          "				<col width=\"8%\" editPlugin=\"pluginEmail\" text=\""+SystemEnv.getHtmlLabelName(20869,user.getLanguage())+"\" column=\"email\" />"+
        	"				<col width=\"14%\" editPlugin=\"pluginManager\" text=\""+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+"\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastnamesForSimpleHrm\" column=\"managerid\" />"+
        //"				<col width=\"14%\" editPlugin=\"pluginDepartment\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmenid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentsForEdit\" />"+
          "				<col width=\"14%\" editPlugin=\"pluginJobtitle\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesnameForEdit\" />"+
          "				<col width=\"8%\" editPlugin=\"pluginSeclevel\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\"  orderkey=\"seclevel\"/>"+
          "				<col width=\"14%\" editPlugin=\"usbstate\" text=\""+SystemEnv.getHtmlLabelName(32511,user.getLanguage())+"\" column=\"usbstate\"  orderkey=\"usbstate\"/>"+
          "			</head>"+
          " </table>";
 
	String showTitle = "";
 if(departmentid_kwd.length()>0){
 	showTitle = DepartmentComInfo.getDepartmentName(departmentid_kwd);
 }else if(departmentid.length()>0){
 	showTitle = DepartmentComInfo.getDepartmentName(departmentid);
 }else if(subcompanyid1.length()>0){
 	showTitle = SubCompanyComInfo.getSubCompanyname(subcompanyid1);
 }else if(subcompanyid1_kwd.length()>0){
 	showTitle = SubCompanyComInfo.getSubCompanyname(subcompanyid1_kwd);
 }else if(companyid.length()>0){
 	showTitle = CompanyComInfo.getCompanyname(companyid);
 }
showTitle =Util.toHtmlMode(showTitle);
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showTitle.length()>0){%>
 parent.setTabObjName('<%=showTitle%>')
 <%}%>
 
});
</script>
<%
String message = Util.null2String(request.getParameter("message"));
if("1".equals(message)){
 %>
<DIV>
    <font color=red size=2>
    <%=SystemEnv.getHtmlLabelName(16129,user.getLanguage())%>
</font>
</DIV>
<%}else if("2".equals(message)){
%>
<DIV>
    <font color=red size=2>
    <%=SystemEnv.getHtmlLabelName(131446,user.getLanguage())%>
</font>
</DIV>
<%} %>
<form id=frmSearch name="frmSearch" action="HrmResourceSysOperation.jsp" method=post >
<input class=inputstyle name="ids" type=hidden value="">
<input type="hidden" name="method" value="save">
<input type="hidden" name="tableMax" value="0"/>
<input type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>"/>
<input type="hidden" name="departmentid" value="<%=departmentid%>"/>
<input type="hidden" name="validatecode" value=""/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmResourceSys:Mgr", user)){ %>
			<%
				if("1".equals(checkSysValidate)){
			 %>
				<input type=button class="e8_btn_top" onclick="onSave(this,1);" value="<%=saveName %>"></input>
			 <%
				}else{
				%>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=saveName %>"></input>
				
			<%	}
			  %>
				<input type=button class="e8_btn_top" onclick="onBatchSave();" value="<%=saveManager %>"></input>
				<input type=button class="e8_btn_top" onclick="onBatchJobTitleSave();" value="<%=saveJobtitle %>"></input>
				<input type=button class="e8_btn_top" onclick="onBatchDept();" value="<%=saveDept %>"></input>
				<input type=button class="e8_btn_top" onclick="addToGroup();" value="<%=saveGroup %>"></input>
				<input type=button class="e8_btn_top" onclick="onBatchBelongtoSave();" value="<%=saveBelong %>"></input>
			<%} %>
			<input type="text" class="searchInput" name="qname" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
	  <wea:item>	 
	 	 	 	<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp" width="120px"
	      browserSpanValue='<%=ResourceComInfo.getLastname(resourceid) %>'>
	      </brow:browser>
	   </wea:item>  
	    <wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>
	    <wea:item>
	  	 	 <brow:browser viewType="0" name="managerid_kwd" browserValue='<%=managerid_kwd %>' 
	       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
	       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	       completeUrl="/data.jsp" width="120px"
	       browserSpanValue='<%=ResourceComInfo.getLastname(managerid_kwd) %>'>
	       </brow:browser>
	    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
	    	  	 <brow:browser viewType="0" name="subcompanyid1_kwd" browserValue='<%=subcompanyid1_kwd %>'
	            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
	            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	            completeUrl="/data.jsp?type=164" width="120px"
	            browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid1_kwd) %>'>
	            </brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	    <wea:item>
	   	  <brow:browser viewType="0" name="departmentid_kwd" browserValue='<%=departmentid_kwd %>' 
	       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
	       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	       completeUrl="/data.jsp?type=4" width="120px"
	       browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid_kwd) %>'>
	       </brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
	    <wea:item>
				  <select class=InputStyle id=accounttype name=accounttype>
				    <option value=""></option>
				    <option value="0" <%=accounttype.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
				    <option value="1" <%=accounttype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
				  </select>
	    </wea:item>
	</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
  			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
</wea:layout>
</div>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceSys %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</form>
<script language=vbs>
sub onShowSubcompanyid()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmSearch.subcompanyid1.value)
	if NOT isempty(id) then
	    if id(0)<> 0 then
		subcompanyid1span.innerHtml = id(1)
		frmSearch.subcompanyid1.value=id(0)
		else
		subcompanyid1span.innerHtml = ""
		frmSearch.subcompanyid1.value=""
		end if
	end if
	
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmSearch.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmSearch.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmSearch.departmentid.value=""
	end if
	end if
end sub

</script>

<script language=javascript>

function afterDoWhenLoaded(){
	$('td[spacevalue="<%=passwordFlag%>"]').each(function(){
		$(this).html('<a class="e8_btn_top" style="height:30px;padding:2px 5px;"  onclick="updatePassword(this);">密码</a>') ;
		$(this).find('a').mouseover(function(){
			$(this).css('cssText','height:30px;padding:2px 5px;color:#ffffff!important;');
		}).mouseout(function(){
			$(this).css('cssText','height:30px;padding:2px 5px;color:#018EFB!important;');
		});
	});
}


function updatePassword(ob){
	var id ;
	if(ob){
		id = $(ob).parent().parent().find('input:checkbox[name="chkInTableTag"]').attr('checkboxid');
	}else{
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>");
		return false;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}

	if(dialog==null)dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/resource/batchUpdate/HrmResourceSysBatchUpdatePwd.jsp?ids="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("20839,83511",user.getLanguage())%>";
	dialog.Width = 476;
	dialog.Height = 332;
	dialog.Drag = true;
	dialog.normalDialog = false;
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

function jsSubcompanyid1(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}

function jsDepartmentid(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}

function onSave(obj,checkSysValidate){
	var checkdata = true;
	jQuery(".notNullImg").each(function(){
		if(jQuery(this).css("display")!="none"){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>');
			checkdata = false;
			return false;
		}
	})
  
   $("img[src ='/images/BacoError_wev8.gif']").each(function(){
		if(jQuery(this).css("display")!="none"){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>');
			checkdata = false;
			return false;
		}
	})

	if(!checkdata)return;
	
	//检测邮箱
	var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
	jQuery("input[name=email]").each(function(){
		var email = this.value;
		if(email&&email!=""){
			var chkFlag = pattern.test(email);
			if(!chkFlag){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
			  checkdata = false;
				return false;
			}
		}
	});
	if(!checkdata)return;
		
	//检测登录名重复
	jQuery("input[name=loginid]").each(function(index){
		var loginid = jQuery.trim(this.value);
		if(loginid=="")return true;
		var resourceid = jQuery("input[name=id]")[index].value;
		var cValue = ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=checkLoginId&resourceid="+resourceid+"&id="+loginid)));
		if(cValue&&cValue=="1"){
			checkdata = false;
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%>"+loginid+"<%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
			return false;
		}else{
			jQuery("input[name=loginid]").each(function(index1){
				if(index!=index1 && loginid==this.value){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%>"+loginid+"<%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				  checkdata = false;
					return false;
				}
			});
		}
		if(!checkdata)return false;
	});
	
	//检测密码复杂度
	jQuery("input[name=password]").each(function(){
		if(this.value!='qiwuien'){
			var chkFlag = CheckPasswordComplexity(this.value);
			if(!chkFlag){
			  checkdata = false;
				return false;
			}
		}
	});
	
	//检测安全级别不能为负数
	jQuery("input[name=seclevel]").each(
		function(){
			if(this.value.indexOf("-")>=0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130809,user.getLanguage())%>");
				checkdata = false;
				return false;
			}
		}
	);
	
	if(!checkdata)return;
	

	if(!checkdata)return;
	if(checkSysValidate && "1" == checkSysValidate){
		onValidateCode();
	}else{
		obj.disabled = true ;
		frmSearch.submit(); 
	}
}
function onClear(){
	document.frmSearch.method.value="empty";
	frmSearch.action="HrmResourceSys.jsp"
	frmSearch.submit();
}

function CheckPasswordComplexity(cs)
{
	var checkpass = true;
	if(cs.length<<%=minpasslen%>){
	    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");
			return false;
	}
	<%
	if("1".equals(passwordComplexity))
	{
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863,user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716,user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
</script>
</BODY>
</HTML>


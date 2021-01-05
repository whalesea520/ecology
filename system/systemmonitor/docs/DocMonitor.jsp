
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="java.math.BigDecimal" %>
<% 
	String hasTab = Util.null2String(request.getParameter("hasTab"));
	if(hasTab.equals("")){
		response.sendRedirect("/docs/search/DocSearchTab.jsp?_fromURL=5&"+request.getQueryString());
		return;
	}
%>

<jsp:useBean id="DocSearchForMonitorComInfo" class="weaver.docs.search.DocSearchForMonitorComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%
	//String fromUrlType = Util.null2String(request.getParameter("fromUrlType")); 
	String fromUrlType = "1";
%>
<HTML>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/DocMonitorInit_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<%if(!fromUrlType.equals("1")){ %>
	<style type="text/css">
		#advancedSearchOuterDiv{
			display:block;
			position:relative;
			border-bottom:none;
			border-right:none;
		}
	</style>
<%} %>
<%if(fromUrlType.equals("1")){ %>
	<script type="text/javascript">
		//parent.rebindNavEvent(".e8_box",false,false);
	</script>
<%} %>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());
String needfav ="1";
String needhelp ="";
String operation = Util.null2String(request.getParameter("operation"));
String isFromLeftMenu="0";//是否从左方菜单进入，如果是的话得清除session里的查询条件
if(operation.equals("")){
	isFromLeftMenu="1";//操作为空则可认为是从左方菜单进入
	//operation="publishDoc";//操作默认为发布
	operation="deleteDoc";//操作默认为删除
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script type="text/javascript">
	
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(16757,user.getLanguage())%>");
		}catch(e){}
	
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(fromUrlType.equals("1")){ %>
				<input type="text" class="searchInput" id="flowTitle" name="flowTitle" onchange="setKeyword('flowTitle','docSubject','weaver');" value="<%= Util.toScreenToEdit(request.getParameter("docSubject"),user.getLanguage())%>"/>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%}else{ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="doSubmit();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_top" onclick="formreset();"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统

String needSubmit=Util.null2String(request.getParameter("needSubmit"));
String ishow = Util.null2String(request.getParameter("ishow"));
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
int  operatelevel=2;
String loginType = user.getLogintype() ;
String fromSearch = Util.null2String(request.getParameter("fromSearch"));


String docSubject = "";
String mainCategory = "";
String subCategory = "";
String secCategory = "";
String departmentId = "";
String docCreaterId = "";
String userType = "1";//1:员工  2:外部用户
String docCreateDateFrom = ""; 
String docCreateDateTo = "";
String path= Util.null2String(request.getParameter("path"));

double sizeOfAllAccessoryBegin=-1;
double sizeOfAllAccessoryEnd=-1;
double sizeOfSingleAccessoryBegin=-1;
double sizeOfSingleAccessoryEnd=-1;
String docStatusSearch="";

String includeHistoricalVersion="0";//是否包含文档历史版本    1：是  0:否
String includeAccessoryHistoricalVersion="0";//是否包含附件历史版本    1：是  0:否
String checkOutStatus="0";//签出状态    1：自动签出  2：强制签出 0或其它:未签出
String isFromMonitor = Util.null2String(request.getParameter("isFromMonitor"));
String  secinput="1";
if(isFromMonitor.equals("1")){
isFromLeftMenu="0";
fromSearch="1";
secCategory= Util.null2String(request.getParameter("secCategory1"));
if("".equals(secCategory)){
	secCategory= Util.null2String(request.getParameter("secCategory"));
}
subcompanyId=scc.getSubcompanyIdFQ(secCategory);
operatelevel= Util.getIntValue(CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocEdit:Edit",Util.getIntValue(subcompanyId,0))+"",0);
secinput="0";
}else{
operatelevel=2;
}
if( isFromLeftMenu.equals("0") ) {

	if(fromSearch.equals("1")){

		docSubject = Util.toScreenToEdit(request.getParameter("docSubject"),user.getLanguage());
		mainCategory = Util.null2String(request.getParameter("mainCategory"));
		subCategory= Util.null2String(request.getParameter("subCategory"));
		secCategory= Util.null2String(request.getParameter("secCategory"));
		departmentId= Util.null2String(request.getParameter("departmentId"));
		docCreaterId = Util.null2String(request.getParameter("docCreaterIdSelected"));
		if(docCreaterId.equals("")){
			docCreaterId = Util.null2String(request.getParameter("docCreaterIdSelected1"));
		}
		userType = Util.null2String(request.getParameter("userType"));
		docCreateDateFrom = Util.null2String(request.getParameter("docCreateDateFrom"));
		docCreateDateTo = Util.null2String(request.getParameter("docCreateDateTo"));
		if (!secCategory.equals("")) path = scc.getAllParentName(secCategory,true);

		sizeOfAllAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryBegin"),-1);
		sizeOfAllAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryEnd"),-1);
        sizeOfSingleAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryBegin"),-1);
        sizeOfSingleAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryEnd"),-1);

		docStatusSearch = Util.null2String(request.getParameter("docStatusSearch"));

		includeHistoricalVersion = Util.null2String(request.getParameter("includeHistoricalVersion"));
		includeAccessoryHistoricalVersion = Util.getIntValue(request.getParameter("includeAccessoryHistoricalVersion"),0)+"";
		
		checkOutStatus = Util.null2String(request.getParameter("checkOutStatus"));

		DocSearchForMonitorComInfo.resetSearchInfo() ;
		DocSearchForMonitorComInfo.setDocsubject(docSubject);
		DocSearchForMonitorComInfo.setMaincategory(mainCategory);
		DocSearchForMonitorComInfo.setSubcategory(subCategory);
		DocSearchForMonitorComInfo.setSeccategory(secCategory);
		DocSearchForMonitorComInfo.setDoccreaterid(docCreaterId);
		DocSearchForMonitorComInfo.setDocdepartmentid(departmentId);
		DocSearchForMonitorComInfo.setUsertype(userType);
		//DocSearchForMonitorComInfo.setUserID(""+user.getUID());
		//DocSearchForMonitorComInfo.setLoginType(loginType) ;
		DocSearchForMonitorComInfo.setDoccreatedateFrom(docCreateDateFrom);
		DocSearchForMonitorComInfo.setDoccreatedateTo(docCreateDateTo);
		DocSearchForMonitorComInfo.setSizeOfAllAccessoryBegin(sizeOfAllAccessoryBegin);
		DocSearchForMonitorComInfo.setSizeOfAllAccessoryEnd(sizeOfAllAccessoryEnd);
		DocSearchForMonitorComInfo.setSizeOfSingleAccessoryBegin(sizeOfSingleAccessoryBegin);
		DocSearchForMonitorComInfo.setSizeOfSingleAccessoryEnd(sizeOfSingleAccessoryEnd);
		//DocSearchForMonitorComInfo.setDocStatusSearch(docStatusSearch);

		if(operation.equals("publishDoc")){//操作为发布时,显示状态为"6:待发布"的文档
			DocSearchForMonitorComInfo.addDocstatus("6");
			if(!docStatusSearch.equals("6")){
				docStatusSearch="";
			}
		}

		if(operation.equals("archiveDoc")){//操作为归档时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			if(!docStatusSearch.equals("1,2")){
				docStatusSearch="";
			}
		}

		if(operation.equals("invalidDoc")){//操作为失效时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			if(!docStatusSearch.equals("1,2")){
				docStatusSearch="";
			}
		}

		if(operation.equals("cancelDoc")){//操作为作废时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			DocSearchForMonitorComInfo.addDocstatus("5");
			DocSearchForMonitorComInfo.addDocstatus("7");
			if(!docStatusSearch.equals("1,2")&&!docStatusSearch.equals("5")&&!docStatusSearch.equals("7")){
				docStatusSearch="";
			}
		}

		if(operation.equals("reopenFromArchiveDoc")){//操作为重新打开归档时,显示状态为"5:归档"的文档
			DocSearchForMonitorComInfo.addDocstatus("5");
			if(!docStatusSearch.equals("5")){
				docStatusSearch="";
			}
		}

		if(operation.equals("reopenFromCancellationDoc")){//操作为重新打开作废时,显示状态为"8:作废"的文档
			DocSearchForMonitorComInfo.addDocstatus("8");
			if(!docStatusSearch.equals("8")){
				docStatusSearch="";
			}
		}

		if(operation.equals("deleteDoc")){//操作为删除时,显示任何状态的文档

		}

		DocSearchForMonitorComInfo.setDocStatusSearch(docStatusSearch);

		DocSearchForMonitorComInfo.setIncludeHistoricalVersion(includeHistoricalVersion);
		DocSearchForMonitorComInfo.setIncludeAccessoryHistoricalVersion(includeAccessoryHistoricalVersion);
		DocSearchForMonitorComInfo.setCheckOutStatus(checkOutStatus);

	}else{


		docSubject = DocSearchForMonitorComInfo.getDocsubject();
		mainCategory = DocSearchForMonitorComInfo.getMaincategory();
		subCategory = DocSearchForMonitorComInfo.getSubcategory();
		secCategory= DocSearchForMonitorComInfo.getSeccategory();
		departmentId= DocSearchForMonitorComInfo.getDocdepartmentid();
		docCreaterId = DocSearchForMonitorComInfo.getDoccreaterid();
		userType = DocSearchForMonitorComInfo.getUsertype();
		docCreateDateFrom = DocSearchForMonitorComInfo.getDoccreatedateFrom();
		docCreateDateTo = DocSearchForMonitorComInfo.getDoccreatedateTo();

		sizeOfAllAccessoryBegin=DocSearchForMonitorComInfo.getSizeOfAllAccessoryBegin();
		sizeOfAllAccessoryEnd=DocSearchForMonitorComInfo.getSizeOfAllAccessoryEnd();
		sizeOfSingleAccessoryBegin=DocSearchForMonitorComInfo.getSizeOfSingleAccessoryBegin();
		sizeOfSingleAccessoryEnd=DocSearchForMonitorComInfo.getSizeOfSingleAccessoryEnd();

        docStatusSearch=DocSearchForMonitorComInfo.getDocStatusSearch();

		if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

        includeHistoricalVersion=DocSearchForMonitorComInfo.getIncludeHistoricalVersion();
        includeAccessoryHistoricalVersion=DocSearchForMonitorComInfo.getIncludeAccessoryHistoricalVersion();
        checkOutStatus=DocSearchForMonitorComInfo.getCheckOutStatus();
	}
}else{
    DocSearchForMonitorComInfo.resetSearchInfo() ;
    DocSearchForMonitorComInfo.setUsertype(userType);
	////从左方菜单进入.操作默认为发布,文档状态为'6',待发布.
    //DocSearchForMonitorComInfo.addDocstatus("6");
	//从左方菜单进入.操作默认为删除,文档状态为全部
}

String _completeUrl = userType.equals("1")?"/data.jsp":"/data.jsp?type=7";
if(docCreateDateFrom.equals("")){
	//docCreateDateFrom = TimeUtil.getDateByOption("5","0");
}

String whereclause = " where " + DocSearchForMonitorComInfo.FormatSQLSearch(user.getLanguage()) ;

boolean  isDocAdmin=false;//当前用户是否为文档管理员
if(HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {//如果具有删除文档的权限,则认为是文档管理员
	isDocAdmin=true ;
}

if(!isDocAdmin){//如果不为系统管理员,则只能查询到当前用户有管理权限的主目录或分目录下的文档

    String userTypeSql=null;
	if(loginType!=null&&loginType.equals("1")){//当前用户为内部用户
	    userTypeSql="    and usertype=0 ";
	}else{
	    userTypeSql="    and usertype>0 ";
	}

    StringBuffer sb=new StringBuffer();
	sb.append(" and exists ( ")
	  .append(" select 1 ")
	  .append("   from DirAccessControlDetail ")
	  .append("  where sourceid=t1.seccategory ")
	  .append("    and sourcetype=2 ")
	  .append("    and sharelevel=1 ")
	  .append("    and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+ShareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))")

	  .append(" ) ");

	whereclause+=sb.toString();

}

//TD.6662 added by wdl
//whereclause+=" and not exists (select 1 from docdetail where doceditionid > 0 and id<>t1.id and doceditionid = (select doceditionid from docdetail where id = t1.id) and (docstatus <= 0 or docstatus in (3,4,6)) ) ";
//TD.6662 end

if(operation.equals("checkInCompellablyDoc")){
	//whereclause+=" and t1.checkOutStatus='1' ";
	if("1".equals(checkOutStatus)||"2".equals(checkOutStatus)){
		whereclause+=" and t1.checkOutStatus='"+checkOutStatus+"' ";
	}else{
		whereclause+=" and (t1.checkOutStatus='1' or t1.checkOutStatus='2') ";
	}
}

/* td.6856 added by wdl */
//whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
if(operation.equals("deleteDoc")&&"1".equals(includeHistoricalVersion)){

}else{
    whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
}

if(Util.null2String(request.getParameter("docCreateDateFrom")).equals("")) {
	//whereclause += " and 1=2 ";
}
//out.println(whereclause);
/*
if(operation.equals("cancelDoc")){
	whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
}
*/
/* added end */


%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!fromUrlType.equals("1")&&operatelevel>0){

	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:formreset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(fromUrlType.equals("1")&&operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmitRight(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(operation.equals("publishDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:publishDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("archiveDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:archiveDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("invalidDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:invalidDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("cancelDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:cancelDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("reopenFromArchiveDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:reopenFromArchiveDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("reopenFromCancellationDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:reopenFromCancellationDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operation.equals("deleteDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:deleteDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	
	if(operation.equals("checkInCompellablyDoc")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:checkInCompellablyDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<style type="text/css">
	.typeArea{
		text-align:center;
		width:12%;
		height:100%;
		border-left:1px solid #cddae1;
		border-top:1px solid #F4F4F4;
		border-bottom:1px solid #cddae1;
		float:left;
		cursor:pointer;
		position:relative;
		background-color:#f4f4f4;
	}
	.typeSelectArea{
		cursor:default;
		background-color:#3ecbcb;
		color:#227c77;
		text-align:center;
		float:left;
		width:12%;
		height:100%;
		border-left:1px solid #3ecbcb;
		border-top:1px solid #3ecbcb;
		border-bottom:1px solid #3ecbcb;
		position:relative;
	}
	.typeSelectAreaSelect{
		color:#fff!important;
		background-color:#207c7c!important;
		border-left:1px solid #207c7c!important;
		border-top:1px solid #207c7c!important;
	}
	
	.typeSelectAreaSelect .typeIconArea{
		float: left;
		width: 16px!important;
		height: 16px!important;
		margin-left: 30px!important;
		margin-right: 10px!important;
	}
	
	.typeSelectAreaSelect .typeOperation{
		float: left;
		padding-top: 15px!important;
	}
	
	.typeIconArea{
		width:100%;
		padding-top:25px;
		height:24px;
		background-repeat:no-repeat;
		background-position:50% 50%;
	}
	.typeOperationArea{
		width:101%;
		height:35px;
		display:none;
		text-align:center;
		line-height:35px;
		position:absolute;
		background-color:#3ecbcb;
		bottom:0;
		left:-1px;
	}
	.typeArea:hover .typeDeleteIcon{
		background-image:url(/images/docs/monitor/delete_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeDeleteIcon{
		background-image: url(/images/docs/monitor/sdelete_wev8.png)!important;
	}
	.typeArea:hover .typePublishIcon{
		background-image:url(/images/docs/monitor/publish_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typePublishIcon{
		background-image: url(/images/docs/monitor/spublish_wev8.png)!important;
	}
	.typeArea:hover .typeArchiveIcon{
		background-image:url(/images/docs/monitor/archive_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeArchiveIcon{
		background-image: url(/images/docs/monitor/sarchive_wev8.png)!important;
	}
	.typeArea:hover .typeInvalidIcon{
		background-image:url(/images/docs/monitor/invalid_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeInvalidIcon{
		background-image: url(/images/docs/monitor/sinvalid_wev8.png)!important;
	}
	.typeArea:hover .typeCancelIcon{
		background-image:url(/images/docs/monitor/cancel_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeCancelIcon{
		background-image: url(/images/docs/monitor/scancel_wev8.png)!important;
	}
	.typeArea:hover .typeReopenarchiveIcon{
		background-image:url(/images/docs/monitor/reopenarchive_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeReopenarchiveIcon{
		background-image: url(/images/docs/monitor/sreopenarchive_wev8.png)!important;
		margin-left:14px!important;
	}
	.typeArea:hover .typeReopencancelIcon{
		background-image:url(/images/docs/monitor/reopencancel_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeReopencancelIcon{
		background-image: url(/images/docs/monitor/sreopencancel_wev8.png)!important;
		margin-left:14px!important;
	}
	.typeArea:hover .typeCheckInIcon{
		background-image:url(/images/docs/monitor/checkin_hover_wev8.png)!important;
	}
	.typeSelectAreaSelect .typeCheckInIcon{
		background-image: url(/images/docs/monitor/scheckin_wev8.png)!important;
		margin-left:22px!important;
	}
</style>

<div style="width:100%;height:86px;font-size:12px;color:#7f7f7f;position:relative;">
	<%if(operation.equals("deleteDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeDeleteIcon" style="background-image:url(/images/docs/monitor/delete_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="deleteDoc();"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('deleteDoc');">
			<div class="typeIconArea typeDeleteIcon" style="background-image:url(/images/docs/monitor/delete_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("publishDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typePublishIcon" style="background-image:url(/images/docs/monitor/publish_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="publishDoc();"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('publishDoc');">
			<div class="typeIconArea typePublishIcon" style="background-image:url(/images/docs/monitor/publish_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("archiveDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeArchiveIcon" style="background-image:url(/images/docs/monitor/archive_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="archiveDoc();"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('archiveDoc');">
			<div class="typeIconArea typeArchiveIcon" style="background-image:url(/images/docs/monitor/archive_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("invalidDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeInvalidIcon" style="background-image:url(/images/docs/monitor/invalid_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="invalidDoc();"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('invalidDoc');">
			<div class="typeIconArea typeInvalidIcon" style="background-image:url(/images/docs/monitor/invalid_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("cancelDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeCancelIcon" style="background-image:url(/images/docs/monitor/cancel_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="cancelDoc();"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('cancelDoc');">
			<div class="typeIconArea typeCancelIcon" style="background-image:url(/images/docs/monitor/cancel_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("reopenFromArchiveDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeReopenarchiveIcon" style="background-image:url(/images/docs/monitor/reopenarchive_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(19686,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="reopenFromArchiveDoc()"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('reopenFromArchiveDoc');">
			<div class="typeIconArea typeReopenarchiveIcon" style="background-image:url(/images/docs/monitor/reopenarchive_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(19686,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("reopenFromCancellationDoc")){ %>
		<div class="typeSelectArea">
			<div class="typeIconArea typeReopencancelIcon" style="background-image:url(/images/docs/monitor/reopencancel_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(19687,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="reopenFromCancellationDoc()"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" onclick="switchOperation('reopenFromCancellationDoc');">
			<div class="typeIconArea typeReopencancelIcon" style="background-image:url(/images/docs/monitor/reopencancel_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(19687,user.getLanguage())%></div>
		</div>
	<%} %>
	<%if(operation.equals("checkInCompellablyDoc")){ %>
		<div class="typeSelectArea" style="width:15%;border-right:1px solid #3ecbcb;">
			<div class="typeIconArea typeCheckInIcon" style="background-image:url(/images/docs/monitor/checkin_hover_wev8.png);"></div>
			<div class="typeOperation"><%=SystemEnv.getHtmlLabelName(19688,user.getLanguage())%></div>
			<div class="typeOperationArea">
				<div style="width:50%;float:left;cursor:pointer;" onclick="checkInCompellablyDoc()"><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%></div>
				<div style="width:1px;float:left;">|</div>
				<div style="float:left;width:49%;cursor:pointer;" onclick="cancelExecute();"><%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%></div>
			</div>
		</div>
	<%}else{ %>
		<div class="typeArea" style="border-right:1px solid #cddae1;width:15%;" onclick="switchOperation('checkInCompellablyDoc');">
			<div class="typeIconArea typeCheckInIcon" style="background-image:url(/images/docs/monitor/checkin_wev8.png);"></div>
			<div><%=SystemEnv.getHtmlLabelName(19688,user.getLanguage())%></div>
		</div>
	<%} %>
	<div style="clear:both;"></div>
</div>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<input type="hidden" name="_completeUrl" id="_completeUrl" value="<%=_completeUrl %>"/>
<FORM id=weaver name=weaver method=post action="DocMonitor.jsp" target="_self">
<input name=fromSearch type=hidden value="1">
<input name="isFromMonitor" id="isFromMonitor" type=hidden value="<%=isFromMonitor%>">
<input name="secCategory1" id="secCategory1" type=hidden value="<%=secCategory%>">
<input name="isInit" id="isInit" type=hidden value="1">
<input name="ishow" id="ishow" type=hidden value="false">
<input name="hasTab" id="hasTab" type=hidden value="1">
<input type="hidden" id="fromUrlType" name="fromUrlType" value="1"/>
<input name="operation" id="operation" type=hidden value="<%=operation %>"/>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item><input type="text"  class=InputStyle id="docSubject"  name="docSubject" value='<%=docSubject%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
			   <brow:browser viewType="0" name="departmentId" browserValue='<%= ""+departmentId %>' 
					   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
					   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					   completeUrl="/data.jsp?type=4" width="80%"
					   browserSpanValue='<%=!departmentId.equals("")?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentId+""),user.getLanguage()):""%>'>
			   </brow:browser>
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;">
			  <select class=inputstyle  name=userType id="userType" onChange="onChangeUserType(this.value)" style="width:110px;">
				  <%if(isgoveproj==0){%>
				  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
				  <option value="2" <%if(userType.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
			  <%}else{%>
			  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
			  <%}%>
			  </select>
			  </span>
			  <span id="crmAndHrm" style="">
			   <span id="hrm" >
					<brow:browser viewType="0" name="docCreaterIdSelected" browserValue='<%=userType.equals("1")?(""+docCreaterId):"" %>' 
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					 completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=(!docCreaterId.equals("")&&userType.equals("1"))?Util.toScreen(ResourceComInfo.getResourcename(docCreaterId+""),user.getLanguage()):""%>'></brow:browser>
				</span>
			   <span id="crm" >
					<brow:browser viewType="0" name="docCreaterIdSelected1" browserValue='<%=userType.equals("2")?(""+docCreaterId):"" %>' 
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
					 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					 completeUrl="/data.jsp?type=7" linkUrl="#" width="49%"
					browserSpanValue='<%=(!docCreaterId.equals("")&&userType.equals("2"))?Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(docCreaterId+""),user.getLanguage()):""%>'></brow:browser>
				</span>
			  </span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="doccreatedateselect">
			    <input class=wuiDateSel type="hidden" name="docCreateDateFrom" value="<%=docCreateDateFrom%>">
			    <input class=wuiDateSel  type="hidden" name="docCreateDateTo" value="<%=docCreateDateTo%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
		<wea:item>
			
			 <span >
				<brow:browser viewType="0" name="secCategory" browserValue='<%=secCategory%>' idKey="id" nameKey="path"
				 browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
				 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=secinput%>'
				 completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
				browserSpanValue='<%=path%>'></brow:browser>
			</span>

			<input type=hidden name=mainCategory value="<%=mainCategory%>">
			<INPUT type=hidden name=subCategory value="<%=subCategory%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19544,user.getLanguage())%></wea:item>
		<wea:item>
			<%
				if(operation.equals("publishDoc")){//操作为发布时,显示状态为"6:待发布"的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("archiveDoc")){//操作为归档时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("invalidDoc")){//操作为失效时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("cancelDoc")){//操作为作废时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效  "的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
					  <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
					  <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("reopenFromArchiveDoc")){//操作为重新打开归档时,显示状态为"5:归档"的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("reopenFromCancellationDoc")){//操作为重新打开作废时,显示状态为"8:作废"的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("deleteDoc")){//操作为删除时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效 8:作废"的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="0" <%if(docStatusSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
					  <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
					  <option value="3" <%if(docStatusSearch.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
					  <option value="4" <%if(docStatusSearch.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
					  <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
					  <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
					  <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
					  <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
					  <option value="9" <%if(docStatusSearch.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
				  </select>
			<%
				}else if(operation.equals("checkInCompellablyDoc")){//操作为强制签入时,显示状态为"0:草稿   1:生效/正常  2:生效/正常  7:失效 "的文档
			%>
				  <select class=inputstyle  name=docStatusSearch>
					  <option value=""></option>
					  <option value="0" <%if(docStatusSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
					  <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
					  <option value="3" <%if(docStatusSearch.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
					  <option value="4" <%if(docStatusSearch.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
					  <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
					  <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
					  <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
					  <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
					  <option value="9" <%if(docStatusSearch.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
				  </select>
			<%
				}
			%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20011,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  size=6 style="width:35%!important" name="sizeOfAllAccessoryBegin" value="<%=sizeOfAllAccessoryBegin==-1?"":String.valueOf(sizeOfAllAccessoryBegin)%>" onKeyPress="ItemNum_KeyPress('sizeOfAllAccessoryBegin')" onBlur="checknumber1(sizeOfAllAccessoryBegin)">&nbsp;K
		&nbsp;-&nbsp;
		<input class=InputStyle style="width:35%!important"  size=6 name="sizeOfAllAccessoryEnd" value="<%=sizeOfAllAccessoryEnd==-1?"":String.valueOf(sizeOfAllAccessoryEnd)%>" onKeyPress="ItemNum_KeyPress('sizeOfAllAccessoryEnd')" onBlur="checknumber1(sizeOfAllAccessoryEnd)">&nbsp;K
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20012,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle style="width:35%!important"  size=6 name="sizeOfSingleAccessoryBegin" value="<%=sizeOfSingleAccessoryBegin==-1?"":String.valueOf(sizeOfSingleAccessoryBegin)%>" onKeyPress="ItemNum_KeyPress('sizeOfSingleAccessoryBegin')" onBlur="checknumber1(sizeOfSingleAccessoryBegin)">&nbsp;K
			&nbsp;-&nbsp;
			<input class=InputStyle style="width:35%!important"  size=6 name="sizeOfSingleAccessoryEnd" value="<%=sizeOfSingleAccessoryEnd==-1?"":String.valueOf(sizeOfSingleAccessoryEnd)%>" onKeyPress="ItemNum_KeyPress('sizeOfSingleAccessoryEnd')" onBlur="checknumber1(sizeOfSingleAccessoryEnd)">&nbsp;K
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23931,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=includeAccessoryHistoricalVersion>
			  <option value="0" <%if(includeAccessoryHistoricalVersion.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			  <option value="1" <%if(includeAccessoryHistoricalVersion.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
		  </select>
		</wea:item>
		<%if(operation.equals("deleteDoc")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(23930,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle  name=includeHistoricalVersion>
				  <option value="0" <%if(includeHistoricalVersion.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
				  <option value="1" <%if(includeHistoricalVersion.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			  </select>
			</wea:item>
		<%}else if(operation.equals("checkInCompellablyDoc")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(21824,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle  name=checkOutStatus>
					  <option value="0"></option>
					  <option value="1" <%if(checkOutStatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21807,user.getLanguage())%></option>
					  <option value="1" <%if(checkOutStatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21806,user.getLanguage())%></option>
				  </select>
			</wea:item>
		<%}%>
	</wea:group>
	<%if(fromUrlType.equals("1")){ %>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	<%} %>
</wea:layout>
<TEXTAREA  id="docIdSelected" name="docIdSelected" style="display:none;"></TEXTAREA>
</form>
</div>
<%if(fromUrlType.equals("1")){ %>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCMONITORLIST %>"/>
<%} %>
                          <%


                            //分页
                            UserDefaultManager.setUserid(user.getUID());
                            UserDefaultManager.selectUserDefault();
                            int perpage = UserDefaultManager.getNumperpage();
                            if(perpage <2) perpage=10;                       
                            
							String backfields="";
							String sqlOrderBy="";
							if(operation.equals("checkInCompellablyDoc")){
								backfields ="t1.id, t1.checkOutUserId,t1.checkOutUserType,t1.checkOutDate,t1.checkOutTime,t1.checkOutStatus,t1.docSubject,t1.maincategory,t1.subCategory,t1.secCategory,t1.docextendname,t1.ownerid,t1.ownerType ";
								sqlOrderBy="checkOutDate,checkOutTime";

							}else{
								backfields ="t1.id, t1.docCreaterId,t1.userType,t1.doccreatedate,t1.doccreatetime,t1.docStatus,t1.docSubject,t1.maincategory,t1.subCategory,t1.secCategory,t1.docextendname,t1.ownerid,t1.ownerType ";
								sqlOrderBy="doccreatedate,doccreatetime";
							}
                           
                            String fromSql = " from docdetail t1  ";

                            String sqlWhere = whereclause;


                            String tableString =" <table pageId=\""+PageIdConst.DOC_DOCMONITORLIST+"\" instanceid=\"DocMonitorTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCMONITORLIST,user.getUID(),PageIdConst.DOC)+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+sqlOrderBy+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "        <col width=\"2%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" labelid=\"63\" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>"+
                                                 "				<col width=\"28%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" labelid=\"58\" column=\"id\" otherpara=\"column:docSubject\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameForDocMonitor\"  orderkey=\"docSubject\"/>";

							if(operation.equals("checkInCompellablyDoc")){
                                   tableString+= "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"\" labelid=\"19690\" column=\"checkOutUserId\" orderkey=\"checkOutUserId\" otherpara=\"column:checkOutUserType\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"/>";
							}else{
                                   tableString+= "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" labelid=\"79\" column=\"ownerid\" orderkey=\"ownerid\" otherpara=\"column:ownerType\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"/>";
							}												 

												 
							tableString+=        "				<col width=\"12%\" pkey=\"id+weaver.splitepage.transform.SptmForDoc.getAllDirName\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" labelid=\"92\" column=\"secCategory\" orderkey=\"secCategory\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
							if(operation.equals("checkInCompellablyDoc")){
                                   tableString+= "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19691,user.getLanguage())+"\" labelid=\"19691\" column=\"checkOutDate\" orderkey=\"checkOutDate,checkOutTime\"  otherpara=\"column:checkOutTime\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCreateTimeForDocMonitor\"/>"+
                                                 "			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(21824,user.getLanguage())+"\" labelid=\"21824\" column=\"checkOutStatus\" orderkey=\"checkOutStatus\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCheckOutStatusForDocMonitor\" />";
							}else{
                                   tableString+= "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" labelid=\"722\" column=\"doccreatedate\" orderkey=\"docCreateDate,docCreateTime\"  otherpara=\"column:docCreateTime\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCreateTimeForDocMonitor\"/>"+
                                                 "			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" labelid=\"602\" column=\"docStatus\" orderkey=\"docStatus\" otherpara=\""+user.getLanguage()+"+column:id"+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" />";
							}												 

												 
							tableString+=        "				<col width=\"23%\"  text=\""+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"\" labelid=\"156\" column=\"id\" otherpara=\""+includeAccessoryHistoricalVersion+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAccessoryForDocMonitor\"/>"+
                                                 "			</head>"+   			
                                                 "</table>"; 
                          %>
                          <%if(fromUrlType.equals("1")){
						    if(isFromMonitor.equals("1")){
								if(secCategory.equals("")||secCategory==null||secCategory.equals("null")){
						  %>
	                         <div align=right style='width:100%;text-align:center;'>请先选择目录...</div>
	                         <%}else{%>
							  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
							 
							<% }}else{%>
							 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
							
							
							<%}} %>       
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>



<script language="javascript">

var needSubmit="<%=needSubmit%>";

function doSubmitRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		doSubmit();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			doSubmit();
		}
	}
}

//提交
function doSubmit() {
	//if(check_form(document.weaver,'docCreateDateFrom'))
		document.weaver.submit();
}
if(needSubmit=="1"){
	doSubmit();
}

//切换操作
function switchOperation(operation){
	jQuery('#isInit').val(0);
	jQuery("#operation").val(operation);
	if("<%=fromUrlType%>"!="1"){
		jQuery("#fromUrlType").val("");
	}
	document.weaver.submit();
}

var intervaltimer = null
function afterDoWhenLoaded(){
	intervaltimer = window.setInterval(function(){
		var ids = _xtable_CheckedCheckboxId();
		if(!!ids){
			if(jQuery(".typeSelectArea div.typeOperationArea").css("display")=="none"){
				<%if(operatelevel>0){%>
				slideUp();
				<%}%>
			}
		}else{
			slideDown();
		}
	},200);
}

function slideUp(){
	jQuery(".typeSelectArea").addClass("typeSelectAreaSelect");
	jQuery(".typeSelectArea div.typeOperationArea").slideDown("normal");
}

function slideDown(){
	jQuery(".typeSelectArea div.typeOperationArea").slideUp("normal",function(){
		jQuery(".typeSelectArea").removeClass("typeSelectAreaSelect");
	});
}

function cancelExecute(){
	_xtable_CleanCheckedCheckbox();
}

var __e8Executing = false;

function executeAction(){
	if(__e8Executing){
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		jQuery.ajax({
			url:"/system/systemmonitor/docs/DocMonitorOperation.jsp",
			dataType:"json",
			data:{
				ajax:"1",
				docIdSelected:checkedCheckboxId,
				operation:"<%=operation%>",
				hasTab:"<%=hasTab%>"
			},
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
				__e8Executing = true;
			},
			complete:function(){
				__e8Executing = false;
				e8showAjaxTips("",false);
				cancelExecute();
				
				slideDown();
		
			},
			success:function(){
				_table.reLoad();
			}
		});
	}
}

//发布
function publishDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}

}

//归档
function archiveDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//失效
function invalidDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//作废
function cancelDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//重新打开归档
function reopenFromArchiveDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//重新打开作废
function reopenFromCancellationDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}


//删除
function deleteDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
	    top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){

            document.weaver.docIdSelected.value=checkedCheckboxId; 
            document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
            document.weaver.submit();
	    });
	}


}

//强制签入
function checkInCompellablyDoc(){
	if(true){
		executeAction();
		return;
	}
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}
 


function onSelectCategory() {
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas) {
        if(datas.id!=""){
			$("input[name=secCategory]").val(datas.id);
			$("#path").html(datas.path);
        }else{
        	$("input[name=secCategory]").val("");
			$("#path").html("");
        }
	}
}

var hrmClone = null;
var crmClone = null;
jQuery(document).ready(function(){
	<%if(ishow.equals("")){ %>
	//jQuery("#advancedSearch").trigger("click");
	<%} %>
	<%if(userType.equals("1")){ %>
		jQuery("#crm").hide();
	<%}else if(userType.equals("2")){%>
		jQuery("#hrm").hide();
	<%}%>
});

function onChangeUserType(userType) {
	//document.getElementById("docCreaterIdSelected").value="";
	//document.getElementById("docCreaterIdSelectedspan").innerHTML ="";
	jQuery("#docCreaterIdSelected").val("");
	jQuery("#docCreaterIdSelected1").val("");
	jQuery("#docCreaterIdSelectedspan").html("");
	jQuery("#docCreaterIdSelected1span").html("");
	if(userType==1){
		jQuery("#crm").hide();
		jQuery("#hrm").show();
	}else if(userType==2){
		jQuery("#hrm").hide();
		jQuery("#crm").show();
	}
}


function formreset(){
	resetCondition();

}

</script>

<script language=javascript>

function getDateForDocMonitor(){
	WdatePicker({el:$('#doccreatedatefromspan')[0],onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$($('input[name=docCreateDateFrom]')[0]).value = returnvalue;
		$('#doccreatedatefromspan').html(returnvalue)
	},oncleared:function(dp){
		$dp.$($('input[name=docCreateDateFrom]')[0]).value="";
		$('#doccreatedatefromspan').html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
		
	}});
}

</script>


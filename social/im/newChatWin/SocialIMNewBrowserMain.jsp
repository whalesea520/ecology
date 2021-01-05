
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<%
String url = Util.null2String(request.getParameter("url"));
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());


//来自报表
String fromReport=Util.null2String(request.getParameter("fromReport"));
String fromReportformid=Util.null2String(request.getParameter("fromReportformid"));
//来自节点前
String fromNode=Util.null2String(request.getParameter("fromNode"));
String fromNodeFormid=Util.null2String(request.getParameter("fromNodeFormid"));
String fromNodeWfid=Util.null2String(Util.getIntValue(request.getParameter("fromNodeWfid")+"", 0)+"");

String fromReportisbill=Util.null2String(request.getParameter("fromReportisbill"));
String fromcapital = Util.null2String(request.getParameter("fromcapital"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
String cptstateid = Util.null2String(request.getParameter("cptstateid"));
String cptsptcount = Util.null2String(request.getParameter("cptsptcount"));
String isdata = Util.null2String(request.getParameter("isdata"));
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
//add by zhouquan 菜单自定义后台管理的浏览框参数
String defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
String menuId = Util.null2String(request.getParameter("menuId"));
String virtualtype= Util.null2String(request.getParameter("virtualtype"));

//add by zhy 报表字段默认值弹窗-请求参数
String reportdicts=Util.null2String(request.getParameter("reportdicts"));
String reportdicts_type=Util.null2String(request.getParameter("reportdicts_type"));
String reportdicts_title=Util.null2String(request.getParameter("reportdicts_title"));
String defaultval=Util.null2String(request.getParameter("defaultval"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String urltarget = Util.null2String(request.getParameter("urltarget"));
String browsertype = Util.null2String(request.getParameter("browsertype"));
if(reportdicts.equals("true")){
	url+="?type="+reportdicts_type+"&title="+reportdicts_title+"&defaultval="+defaultval+"&fieldid="+fieldid+"&isbill="+isbill+"&urltarget="+urltarget+"&browsertype="+browsertype;
}
//isedit如果为1则显示具有编辑权限以上的分部    
String isedit = Util.null2String(request.getParameter("isedit"));

//TD9734修改
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String notCompany = Util.null2String(request.getParameter("notCompany"));
String allselect = Util.null2String(request.getParameter("allselect"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
//TD4957修改
String cptuse = Util.null2String(request.getParameter("cptuse"));
String personCmd = Util.null2String(request.getParameter("personCmd"));

String subscribePara = Util.null2String(request.getParameter("subscribePara"));

String meetingtype = Util.null2String(request.getParameter("meetingtype"));
String meetingname = Util.null2String(request.getParameter("meetingname"));
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String deptlevel=Util.null2String(request.getParameter("deptlevel"));
String splitflag=Util.null2String(request.getParameter("splitflag"));

String workflowId=Util.null2String(request.getParameter("workflowId"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String nodelinkid=Util.null2String(request.getParameter("nodelinkid"));
String ispreoperator=Util.null2String(request.getParameter("ispreoperator"));
String actionid=Util.null2String(request.getParameter("actionid"));

String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String needcheckds = Util.null2String(request.getParameter("needcheckds"));
String dmlformid = Util.null2String(request.getParameter("dmlformid"));
String dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
String dmltablename = Util.null2String(request.getParameter("dmltablename"));
String iscustom=Util.null2String(request.getParameter("iscustom"));
String moduleManageDetach = Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)

String action = Util.null2String(request.getParameter("action"));
String sysfavouriteids = Util.null2String(request.getParameter("sysfavouriteids"));
String fav_pagename = Util.null2String(request.getParameter("fav_pagename"));
//System.out.println("fav_pagename : "+fav_pagename);
String fav_uri = Util.null2String(request.getParameter("fav_uri"));
String fav_querystring = Util.null2String(request.getParameter("fav_querystring"));
String othercallback = Util.null2String(request.getParameter("othercallback"));

//微信窗口传递参数
String workflowid = Util.null2String(request.getParameter("workflowid"));
String reqid = Util.null2String(request.getParameter("reqid"));


String isSingle =  Util.null2String(request.getParameter("isSingle"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlcondition = Util.null2String(request.getParameter("sqlcondition"));
boolean ishead = true;

//云盘窗口传递参数
String hasClear =  Util.null2String(request.getParameter("hasClear"));
String hasCancel = Util.null2String(request.getParameter("hasCancel"));
String hasWarm = Util.null2String(request.getParameter("hasWarm"));
String categoryid = Util.null2String(request.getParameter("categoryid"));
String folderid = Util.null2String(request.getParameter("folderid"));
String operationcode = Util.null2String(request.getParameter("operationcode"));


if(url.indexOf("?")>0){
	ishead = false;
}

if(!"".equals(hasClear)){
	if(ishead){
		url+="?hasClear="+hasClear;
	}else{
		url+="&hasClear="+hasClear;
	}
	ishead = false;
}

if(!"".equals(operationcode)){
	if(ishead){
		url+="?operationcode="+operationcode;
	}else{
		url+="&operationcode="+operationcode;
	}
	ishead = false;
}

if(!"".equals(hasCancel)){
	if(ishead){
		url+="?hasCancel="+hasCancel;
	}else{
		url+="&hasCancel="+hasCancel;
	}
	ishead = false;
}
if(!"".equals(hasWarm)){
	if(ishead){
		url+="?hasWarm="+hasWarm;
	}else{
		url+="&hasWarm="+hasWarm;
	}
	ishead = false;
}
if(!"".equals(categoryid)){
	if(ishead){
		url+="?categoryid="+categoryid;
	}else{
		url+="&categoryid="+categoryid;
	}
	ishead = false;
}
if(!"".equals(folderid)){
	if(ishead){
		url+="?folderid="+folderid;
	}else{
		url+="&folderid="+folderid;
	}
	ishead = false;
}


if(!"".equals(isSingle)){
	if(ishead){
		url+="?isSingle="+isSingle;
	}else{
		url+="&isSingle="+isSingle;
	}
	ishead = false;
}

if(!"".equals(reqid)){
	if(ishead){
		url+="?reqid="+reqid;
	}else{
		url+="&reqid="+reqid;
	}
	ishead = false;
}


if("".equals(splitflag)) splitflag = ",";

if(!fromcapital.equals("")){
	if(ishead){
		url+="?fromcapital="+fromcapital;
	}else{
		url+="&fromcapital="+fromcapital;
	}
	ishead = false;
}
if(!meetingid.equals("")){
	if(ishead){
		url+="?meetingid="+meetingid;
	}else{
		url+="&meetingid="+meetingid;
	}
	ishead = false;
}
if(!cptstateid.equals("")){
	if(ishead){
		url+="?stateid="+cptstateid;
	}else{
		url+="&stateid="+cptstateid;
	}
	ishead = false;
}
if(!cptsptcount.equals("")){
	if(ishead){
		url+="?sptcount="+cptsptcount;
	}else{
		url+="&sptcount="+cptsptcount;
	}
	ishead = false;
}
if(!isdata.equals("")){
	if(ishead){
		url+="?isdata="+isdata;
	}else{
		url+="&isdata="+isdata;
	}
	ishead = false;
}
if(!ProjID.equals("")){
	if(ishead){
		url+="?ProjID="+ProjID;
	}else{
		url+="&ProjID="+ProjID;
	}
	ishead = false;
}
if(!taskrecordid.equals("")){
	if(ishead){
		url+="?taskrecordid="+taskrecordid;
	}else{
		url+="&taskrecordid="+taskrecordid;
	}
	ishead = false;
}
if(!crmManager.equals("")){
	if(ishead){
    	url+="?crmManager="+crmManager;
	}else{
		url+="&crmManager="+crmManager;
	}
	ishead = false;
}
//add by zhouquan 菜单自定义后台管理的浏览框参数
if(!defaultLevel.equals("")){
	if(ishead){
		url+="?defaultLevel="+defaultLevel;
	}else{
		url+="&defaultLevel="+defaultLevel;
	}
	ishead = false;
}
if(!menuId.equals("")){
	if(ishead){
		url+="?menuId="+menuId;
	}else{
		url+="&menuId="+menuId;
	}
	ishead = false;
}
if(!isedit.equals("")){
	if(ishead){
		url+="?isedit="+isedit;
	}else{
		url+="&isedit="+isedit;
	}
	ishead = false;
}
if(!cptuse.equals("")){
	if(ishead){
		url+="?cptuse="+cptuse;
	}else{
		url+="&cptuse="+cptuse;
	}
	ishead = false;
}
if(!subscribePara.equals("")){
	if(ishead){
		url+="?subscribePara="+subscribePara;
	}else{
		url+="&subscribePara="+subscribePara;
	}
	ishead = false;
}
if(!subcompanyid.equals("")){
	if(ishead){
		url+="?subcompanyid="+subcompanyid;
	}else{
		url+="&subcompanyid="+subcompanyid;
	}
	ishead = false;
}
if(!notCompany.equals("")){
	if(ishead){
		url+="?notCompany="+notCompany;
	}else{
		url+="&notCompany="+notCompany;
	}
	ishead = false;
}
if(!allselect.equals("")){
	if(ishead){
		url+="?allselect="+allselect;
	}else{
		url+="&allselect="+allselect;
	}
	ishead = false;
}
if(!rightStr.equals("")){
	if(ishead){
		url+="?rightStr="+rightStr;
	}else{
		url+="&rightStr="+rightStr;
	}
	ishead = false;
}
if(!personCmd.equals("")){
	if(ishead){
		url+="?personCmd="+personCmd;
	}else{
		url+="&personCmd="+personCmd;
	}
	ishead = false;
}

if(!meetingtype.equals("")){
	if(ishead){
		url+="?meetingtype="+meetingtype;
	}else{
		url+="&meetingtype="+meetingtype;
	}
	ishead = false;
}
if(!meetingname.equals("")){
	if(ishead){
		url+="?meetingname="+meetingname;
	}else{
		url+="&meetingname="+meetingname;
	}
}
if(!roomid.equals("")){
	if(ishead){
		url+="?roomid="+roomid;
	}else{
		url+="&roomid="+roomid;
	}
	ishead = false;
}
if(!startdate.equals("")){
	if(ishead){
		url+="?startdate="+startdate;
	}else{
		url+="&startdate="+startdate;
	}
	ishead = false;
}
if(!enddate.equals("")){
	if(ishead){
		url+="?enddate="+enddate;
	}else{
		url+="&enddate="+enddate;
	}
	ishead = false;
}
if(!starttime.equals("")){
	if(ishead){
		url+="?starttime="+starttime;
	}else{
		url+="&starttime="+starttime;
	}
	ishead = false;
}
if(!endtime.equals("")){
	if(ishead){
		url+="?endtime="+endtime;
	}else{
		url+="&endtime="+endtime;
	}
	ishead = false;
}
if(!selectedids.equals("")){
	if(ishead){
		url+="?selectedids="+selectedids;
	}else{
		url+="&selectedids="+selectedids;
	}
	ishead = false;
}
if(!splitflag.equals("")){
	if(ishead){
		url+="?splitflag="+splitflag;
	}else{
		url+="&splitflag="+splitflag;
	}
	ishead = false;
}

if(!deptlevel.equals("")){
	if(ishead){
		url+="?deptlevel="+deptlevel;
	}else{
		url+="&deptlevel="+deptlevel;
	}
	ishead = false;
}
if(!workflowId.equals("")){
	if(ishead){
		url+="?workflowId="+workflowId;
	}else{
		url+="&workflowId="+workflowId;
	}
	ishead = false;
}
if(!nodeid.equals("")){
	if(ishead){
		url+="?nodeid="+nodeid;
	}else{
		url+="&nodeid="+nodeid;
	}
	ishead = false;
}
if(!nodelinkid.equals("")){
	if(ishead){
		url+="?nodelinkid="+nodelinkid;
	}else{
		url+="&nodelinkid="+nodelinkid;
	}
	ishead = false;
}
if(!ispreoperator.equals("")){
	if(ishead){
		url+="?ispreoperator="+ispreoperator;
	}else{
		url+="&ispreoperator="+ispreoperator;
	}
	ishead = false;
}
if(!actionid.equals("")){
	if(ishead){
		url+="?actionid="+actionid;
	}else{
		url+="&actionid="+actionid;
	}
	ishead = false;
}
if(!datasourceid.equals("")){
	if(ishead){
		url+="?datasourceid="+datasourceid;
	}else{
		url+="&datasourceid="+datasourceid;
	}
	ishead = false;
}
if(!needcheckds.equals("")){
	if(ishead){
		url+="?needcheckds="+needcheckds;
	}else{
		url+="&needcheckds="+needcheckds;
	}
	ishead = false;
}
if(!dmlformid.equals("")){
	if(ishead){
		url+="?dmlformid="+dmlformid;
	}else{
		url+="&dmlformid="+dmlformid;
	}
	ishead = false;
}
if(!dmltablename.equals("")){
	if(ishead){
		url+="?dmltablename="+dmltablename;
	}else{
		url+="&dmltablename="+dmltablename;
	}
	ishead = false;
}
if(!dmlisdetail.equals("")){
	if(ishead){
		url+="?dmlisdetail="+dmlisdetail;
	}else{
		url+="&dmlisdetail="+dmlisdetail;
	}
	ishead = false;
}

if(!moduleManageDetach.equals("")){//(模块管理分权-分权管理员专用)
	if(ishead){
		url+="?moduleManageDetach="+moduleManageDetach;
	}else{
		url+="&moduleManageDetach="+moduleManageDetach;
	}
	ishead = false;
}

if(!action.equals("")){
	if(ishead){
		url+="?action="+action;
	}else{
		url+="&action="+action;
	}
	ishead = false;
}
if(!sysfavouriteids.equals("")){
	if(ishead){
		url+="?sysfavouriteids="+sysfavouriteids;
	}else{
		url+="&sysfavouriteids="+sysfavouriteids;
	}
	ishead = false;
}
if(!fav_pagename.equals("")){
	fav_pagename = java.net.URLEncoder.encode(fav_pagename,"utf-8");
	if(ishead){
		url+="?fav_pagename="+fav_pagename;
	}else{
		url+="&fav_pagename="+fav_pagename;
	}
	ishead = false;
}
if(!fav_uri.equals("")){
	fav_uri = java.net.URLEncoder.encode(fav_uri,"utf-8");
	if(ishead){
		url+="?fav_uri="+fav_uri;
	}else{
		url+="&fav_uri="+fav_uri;
	}
	ishead = false;
}
if(!fav_querystring.equals("")){
	fav_querystring = java.net.URLEncoder.encode(fav_querystring,"utf-8");
	if(ishead){
		url+="?fav_querystring="+fav_querystring;
	}else{
		url+="&fav_querystring="+fav_querystring;
	}
	ishead = false;
}
if(!othercallback.equals("")){
	if(ishead){
		url+="?othercallback="+othercallback;
	}else{
		url+="&othercallback="+othercallback;
	}
	ishead = false;
}
if(!virtualtype.equals("")){
	if(ishead){
		url+="?virtualtype="+virtualtype;
	}else{
		url+="&virtualtype="+virtualtype;
	}
	ishead = false;
}

if(!f_weaver_belongto_userid.equals("")){
	if(ishead){
		url+="?f_weaver_belongto_userid="+f_weaver_belongto_userid;
	}else{
		url+="&f_weaver_belongto_userid="+f_weaver_belongto_userid;
	}
	ishead = false;
}

if(!f_weaver_belongto_usertype.equals("")){
	if(ishead){
		url+="?f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	}else{
		url+="&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	}
	ishead = false;
}
//System.out.println("sqlwhere:"+sqlwhere+",sqlcondition:"+sqlcondition);
if(!sqlwhere.equals("")){
	if(ishead){
		url+="?sqlwhere="+xssUtil.put(java.net.URLEncoder.encode(sqlwhere,"UTF-8"));
	}else{
		url+="&sqlwhere="+xssUtil.put(java.net.URLEncoder.encode(sqlwhere,"UTF-8"));
	}
	ishead = false;
}
if(!sqlcondition.equals("")){
	if(ishead){
		url+="?sqlcondition="+xssUtil.put(java.net.URLEncoder.encode(sqlcondition,"UTF-8"));
	}else{
		url+="&sqlcondition="+xssUtil.put(java.net.URLEncoder.encode(sqlcondition,"UTF-8"));
	}
	ishead = false;
}

//System.out.println(">>>>>>>>>>>>/systeminfo/BrowserMain.jsp  url="+url);
//System.out.println("url:"+url);

//针对自定义浏览按钮，做特殊处理
int CommonBrowserIndex = url.indexOf("/interface/CommonBrowser.jsp?type=browser.");//单选
int MultiCommonBrowserIndex = url.indexOf("/interface/MultiCommonBrowser.jsp?type=browser.");//多选
String browserType = "";
String frombrowserid = "";//触发字段id
long currenttime = System.currentTimeMillis();
if(CommonBrowserIndex>=0||MultiCommonBrowserIndex>=0){
	//解析url，获得type
	String tempUrl = url.substring(url.indexOf("?")+1);
	String tempUrlParas[] = tempUrl.split("&");
	for(int i=0;i<tempUrlParas.length;i++){
		String tempParas[] = tempUrlParas[i].split("=");
		if(tempParas.length>1){
			String paraName = Util.null2String(tempParas[0]);
			if(paraName.equals("type")){
				browserType = Util.null2String(tempParas[1]);
				String bts[] = browserType.split("\\|");
				browserType = bts[0];
				if(bts.length>1){
					frombrowserid = bts[1];
				}
			}
		}
	}
	Browser browser=(Browser)StaticObj.getServiceByFullname(URLDecoder.decode(browserType,"utf-8"), Browser.class);
	String Search = browser.getSearch();//
	String SearchByName = browser.getSearchByName();//
}


//针对自定义浏览按钮，做特殊处理
int sapSingleBrowserIndex = url.indexOf("/interface/sapSingleBrowser.jsp?type");//单选
int sapMutilBrowserIndex = url.indexOf("/interface/sapMutilBrowser.jsp?type");//多选

//针对集成浏览按钮，做特殊处理
int IntSingleBrowserIndex = url.indexOf("/integration/sapSingleBrowser.jsp?type");//单选
int IntMutilBrowserIndex = url.indexOf("/integration/sapMutilBrowser.jsp?type");//多选

String sapbrowserid = "";//浏览框id
boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromfieldid = "";//字段id
if(sapSingleBrowserIndex>=0||sapMutilBrowserIndex>=0||IntSingleBrowserIndex>=0||IntMutilBrowserIndex>=0){
	//解析url，获得type
	String tempUrl = url.substring(url.indexOf("?")+1);
	String tempUrlParas[] = tempUrl.split("&");
	for(int i=0;i<tempUrlParas.length;i++){
		String tempParas[] = tempUrlParas[i].split("=");
		if(tempParas.length>1){
			String paraName = Util.null2String(tempParas[0]);
			if(paraName.equals("type")){
				browserType = Util.null2String(tempParas[1]);
				String strs[] = browserType.split("\\|");
				if(strs.length==2){
					sapbrowserid = Util.null2String(strs[0]);
					frombrowserid = Util.null2String(strs[1]);
					strs = frombrowserid.split("_");
					if(strs.length==2){
						fromfieldid = strs[0];
						detailrow = strs[1];
						ismainfiled = false;
					}else{
						fromfieldid = strs[0];
					}
				}
			}
		}
	}
}

List<String> mouldIDS = new ArrayList<String>();
mouldIDS.add("doc");
mouldIDS.add("hrm");
mouldIDS.add("resource");
mouldIDS.add("workflow");
mouldIDS.add("favourite");
mouldIDS.add("integration");
mouldIDS.add("networkdisk");

String mouldID = Util.null2String(request.getParameter("mouldID"));
String tmpMouldID = Util.null2String(url.split("/")[1]);
if(mouldID.length()==0 && (tmpMouldID.equals("docs")))mouldID = "doc";

if(mouldID.length()==0 && (tmpMouldID.equals("hrm")))mouldID = "hrm";
if(url.indexOf("LanguageBrowser.jsp")>0 
	|| url.indexOf("LgcAssetUnitBrowser.jsp")>0
	|| url.indexOf("CurrencyBrowser.jsp")>0
	|| url.indexOf("CityBrowser.jsp")>0
	)mouldID = "hrm";
if(url.indexOf("ResourceBrowser.jsp")>0
		||url.indexOf("ResourceBrowserByRight.jsp")>0
		||url.indexOf("MultiInviteBrowser.jsp")>0
		||url.indexOf("ResourceBrowserByDec.jsp")>0
		||url.indexOf("MultiResourceBrowserByDec.jsp")>0
		||url.indexOf("MultiDepartmentBrowserByOrder.jsp")>0
		||url.indexOf("MultiDepartmentBrowserByDecOrder.jsp")>0
		||url.indexOf("MutiRolesBrowser.jsp")>0
		||url.indexOf("HrmOrgGroupBrowser")>0
		){
	mouldID = "";
}
int IntFavouriteBrowserIndex = url.indexOf("FavouriteBrowser.jsp");
if(IntFavouriteBrowserIndex>0)
{
	mouldID = "favourite";
}
int IntCommonBrowserIndex = url.indexOf("/interface/CommonBrowser.jsp");
if(IntCommonBrowserIndex>-1)
{
	mouldID = "workflow";
}
int IntMultiCommonBrowserIndex = url.indexOf("/interface/MultiCommonBrowser.jsp");
if(IntMultiCommonBrowserIndex>-1)
{
	mouldID = "workflow";
}
String cmd = Util.null2String(request.getParameter("cmd"));
if(cmd.equalsIgnoreCase("cleanMID")){
	mouldID = "";
}
String navID = MouldIDConst.getID(mouldID);
if(!mouldID.equals("")){
	if(ishead){
		url += "?mouldID="+mouldID;
	}else{
		url += "&mouldID="+mouldID;
	}
	ishead = false;
}
%>

<html>

<head>
<%if(mouldIDS.indexOf(mouldID)!=-1){ %>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<script type="text/javascript">
		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        iframe:"main",
		        mouldID:"<%= navID%>",
		        staticOnLoad:true
		    });
		 
		 }); 
	</script>
<%} %>
</head>

<script language="javascript">
var url = "<%=url%>";
var fromReport="<%=fromReport%>";
var fromReportformid="<%=fromReportformid%>";
var fromReportisbill="<%=fromReportisbill%>";
var fromNode="<%=fromNode%>";
var fromNodeFormid="<%=fromNodeFormid%>";
var fromNodeWfid="<%=fromNodeWfid%>";
var iscustom="<%=iscustom%>";
<%if(sapSingleBrowserIndex>=0||sapMutilBrowserIndex>=0){%>
	jQuery(document).ready(function(){
		try{
			var fromNodeorReport=0;//用于判断改浏览按钮的点击来源为报表或节点前或批次条件
			var formid = "";
			var isbill ="";
			var workflowid = "";
			if(fromReport=="1"){//来自报表界面--/workflow/report/ReportResult.jsp
				 formid = fromReportformid;
				 isbill =fromReportisbill;
			 	 workflowid =fromNodeWfid;
			 	 fromNodeorReport="1";
			}else if(fromNode=="1"){//来自节点前默认值和批次条件
				 formid = fromNodeFormid;
				 isbill =fromReportisbill;
			 	 workflowid = fromNodeWfid;
			 	 fromNodeorReport="1";
			}
			else{
				 formid = getDialogArgumentValueByName("formid");
				 isbill = getDialogArgumentValueByName("isbill");
				 workflowid = getDialogArgumentValueByName("workflowid"); 
			}
			var isfirefox=checkFirefoxOrIE();
			var browserType = "<%=browserType%>";
			var currenttime = "<%=currenttime%>";
			var sapbrowserid = "<%=sapbrowserid%>";
			var frombrowserid = "<%=frombrowserid%>";
			url += "&workflowid="+workflowid+"&currenttime="+currenttime+"&sapbrowserid="+sapbrowserid+"&frombrowserid="+frombrowserid+"&fromNodeorReport="+fromNodeorReport; 
			jQuery.ajax({
				url : "/workflow/request/GetSapBrowserParas.jsp",
				type : "post",
				processData : false,
				data : "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&currenttime="+currenttime+"&isfirefox="+isfirefox,
				dataType : "xml",
				success: function do4Success(msg){
					try{
						if(fromReport=="1"||fromNode=="1"){//节点前的动作也不应该走else的逻辑
								
						}else{
							var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
							var fieldids = needChangeField.split(",");
							for(var i=0;i<fieldids.length;i++){
								var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
								if(fieldid!=""){
									var fieldobj = window.dialogArguments.document.getElementById(fieldid);
									if(fieldobj!=null){
										var fieldvalue = fieldobj.value;
										url += "&"+fieldid+"="+fieldvalue;
									}
								}
							}
						}
					}catch(e){
						
					}
					setFrameSrc();				
				},
				error:function(){
					setFrameSrc();
				}
			});
		}catch(e){
			setFrameSrc();
		}
	});
<%}else if(IntSingleBrowserIndex>=0||IntMutilBrowserIndex>=0){%>
		jQuery(document).ready(function(){
		try{
			var fromNodeorReport=0;//用于判断改浏览按钮的点击来源为报表或节点前或批次条件
			if(fromReport=="1"){//来自报表界面--/workflow/report/ReportResult.jsp
			 	 fromNodeorReport="1";
			}else if(fromNode=="1"){//来自节点前默认值和批次条件
			 	 fromNodeorReport="1";
			}
			//var formid = window.dialogArguments.document.getElementById("formid").value;
			//var isbill = window.dialogArguments.document.getElementById("isbill").value;
			//var workflowid = window.dialogArguments.document.getElementById("workflowid").value;
			var browserType = "<%=browserType%>";
			var currenttime = "<%=currenttime%>";
			var sapbrowserid = "<%=sapbrowserid%>";
			var frombrowserid = "<%=frombrowserid%>";
			var workflowid = "<%=workflowid%>"
			url += "&currenttime="+currenttime+"&sapbrowserid="+sapbrowserid+"&workflowid="+workflowid+"&frombrowserid="+frombrowserid+"&fromNodeorReport="+fromNodeorReport;
			setFrameSrc();
		}catch(e){
			setFrameSrc();
		}
	});
<%}else if(CommonBrowserIndex>=0||MultiCommonBrowserIndex>=0){%>
	jQuery(document).ready(function(){
		try{
			var formid = getDialogArgumentValueByName("formid");
			var isbill = getDialogArgumentValueByName("isbill");
			var workflowid = getDialogArgumentValueByName("workflowid");
			
			var browserType = "<%=browserType%>";
			var frombrowserid = "<%=frombrowserid%>";
			var currenttime = "<%=currenttime%>";
			url += "&workflowid="+workflowid+"&currenttime="+currenttime;
			var strdata = "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&frombrowserid="+frombrowserid+"&currenttime="+currenttime;
			if(iscustom==1){
				strdata+="&iscustom=1";
			}
			jQuery.ajax({
				url : "/workflow/request/GetCustomizeBrowserParas.jsp",
				type : "post",
				contentType: "application/x-www-form-urlencoded; charset=utf-8",
				processData : false,
				data : strdata,
				dataType : "xml",
				success: function do4Success(msg){
					//alert(msg);
					try{
						var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
						//alert("needChangeField : "+needChangeField);
						var fieldids = needChangeField.split(",");
						for(var i=0;i<fieldids.length;i++){
							var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
							if(fieldid!=""){
								if(fieldid.indexOf("=")>1)
								{
									var newfilenames = fieldid.split("=");
									var searchfieldname = newfilenames[0];
									var workflowfieldid = newfilenames[1];
									url += "&"+searchfieldname+"=";
									url += getDialogArgumentValueByName(workflowfieldid);
								}else{
									url += "&"+fieldid+"=";
									if(iscustom==1){
										var tempfieldid="con"+fieldid.substring(fieldid.indexOf("field")+5)+"_value";
										url += getDialogArgumentValueByName(tempfieldid);
									}else{
										url+=getDialogArgumentValueByName(fieldid);
									}
								}
							}
						}
					}catch(e){
					}
					setFrameSrc();
				},
				error:function(){
					setFrameSrc();
				}
			});
		}catch(e){
			setFrameSrc();
		}
	});
<%}else{%>
	window.onload=function(){
		setFrameSrc();
	}
<%}%>

function setFrameSrc(){
	document.getElementById("main").src = encodeuri(url);
	
}

/**
 * 将uri中的中文进行编码
 * 此方法不会对已经编码的中文进行二次编码
 */
function encodeuri(uri) {
	try {
		var result = "";
		var lastpatternIndex = 0;
		var regex = /[\u4E00-\u9FA5]/;
		for (var i=0; i<url.length; i++) {
			var c = url.charAt(i);
			if (regex.test(c)) {
				result += url.substring(lastpatternIndex, i) + encodeURI(c);
				lastpatternIndex = i + 1;
			}
		}
		if (lastpatternIndex < url.length) {
			result += url.substr(lastpatternIndex);
		}
		return result;
	} catch (e) {
	}
	return uri;
}


var parentWin = null;//parent.getParentWindow(window);
var dialog = null;//parent.getDialog(window);


function getDialogArgumentValueByName(name) {
	var _document;
	if(dialog){
		_document = parentWin.document;
	}else{
		_document = window.dialogArguments.document;
	}
	
	var ele = _document.getElementById(name);
	
	if (ele == undefined || ele == null) {
		var eles = _document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	
	if (ele) {
		//return escape(ele.value);
		return encodeURIComponent(ele.value);
	}
	return "";
}

function checkFirefoxOrIE(){
		var userAgent=window.navigator.userAgent.toLowerCase();
		if(userAgent.indexOf("firefox")>=1){
			//document.write("你用的是火狐浏览器！版本是：Firefox/"+versionName+"<br>");
			return "1";
		}else{
			return "0";
		}
}

</script>

<!--
<frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize >
  <frame name="main" id="main" marginwidth="0" marginheight="0" scrolling="auto" src="">
  <noframes>
  <body>
  <p>此网页使用了框架，但您的浏览器不支持框架。</p>

  </body>
  </noframes>
</frameset>
-->
<body scroll="no" style="margin:0 auto;overflow:hidden;">
<%if(mouldIDS.indexOf(mouldID)!=-1){ %>
<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
		    <ul class="tab_menu">
		    	<li class="defaultTab" >
		        	<a href="#" target="tabcontentframe">
						<%=TimeUtil.getCurrentTimeString() %>
					</a>
		        </li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
				<iframe name="main" id="main" onload="update();" browserFlag="true" marginwidth="0" marginheight="0" scrolling="auto" src=""  framespacing="0" border="0" frameborder="0" style="height:100%;width:100%;padding: 0px;margin: 0px;"/>
			</div>
	    </div>
	</div> 
<%}else{ %>
	<iframe name="main" id="main" browserFlag="true" marginwidth="0" marginheight="0" scrolling="auto" src=""  framespacing="0" border="0" frameborder="0" style="height:100%;width:100%;padding: 0px;margin: 0px;"/>
<%} %>    
</body>

</html>


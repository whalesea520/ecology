<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchMouldManager" class="weaver.docs.search.DocSearchMouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />

<%
String from = Util.null2String(request.getParameter("from"));
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String nodeid = Util.null2String(request.getParameter("nodeid"));
String docdetachable="0";
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
String subcompanyId = Util.null2String(request.getParameter("subcompanyId"));
if(subcompanyId.equals("")){
 subcompanyId=SecCategoryComInfo.getSubcompanyIdFQ(Util.null2String(request.getParameter("seccategory")));
}
int language = user.getLanguage();
int  operatelevel= Util.getIntValue(CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocumentRecycle:All",Util.getIntValue(subcompanyId,0))+"",0);
if(isUseDocManageDetach){
   docdetachable="1";
}
String allsecids="";
if(isUseDocManageDetach&&urlType.equals("23")){
	allsecids=SecCategoryManager.getAllSeccategoryBySubcompanyid(Util.getIntValue(subcompanyId));
}
String  secinput="1";
if(isUseDocManageDetach&&urlType.equals("23")){
	secinput="0";
}
//operatelevel=2;
int departmentid= 0 ;
int creatersubcompanyid = 0;
creatersubcompanyid = Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
departmentid= Util.getIntValue(request.getParameter("departmentid"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String infoId = Util.null2String(request.getParameter("infoId"));
String searchMsg = SystemEnv.getHtmlLabelName(83436,user.getLanguage());
String fromUrlType = Util.null2String(request.getParameter("fromUrlType"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<%
Enumeration em = request.getParameterNames();
boolean isinit = true;
String pageId = "Doc:myRecycleDocList";
if(urlType.equals("23")){
	pageId="Doc:RecycleDocList";
}
RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
RecordSet.next();
int docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
if(docsrecycleIsOpen!=1){
	response.sendRedirect("/docs/docs/DocRecycleRemind.jsp");
}
boolean hasOperateMenu=true;
if(urlType.equals("23")&&!user.getLoginid().equalsIgnoreCase("sysadmin")){
//检查权限//假设包含“回收站文档管理”权限的角色为“文档监控员”，有角色成员A。如果知识管理模块未启用管理分权，则只要A的“成员级别”大于或等于“功能权限”级别，就能够进入回收站文档管理界面管理所有目录下的已逻辑删除的文档。
	if(!HrmUserVarify.checkUserRight("DocumentRecycle:All", user)){
			response.sendRedirect("/notice/noright.jsp");	//没权限的时候跳转无权限页面
			return;
	}else{
		if(isUseDocManageDetach){
			if(operatelevel<1){
				hasOperateMenu=false;	//机构权限的“操作级别”为“禁止”或“只读”时，意为对属于所选机构的文档目录下的回收站文档无操作权限
			}
		}	
	}
}
isinit = Util.null2String(request.getParameter("isinit")).equals("false")?false:true;
String isShow = Util.null2String(request.getParameter("ishow"));
isShow = "false";
String docarchivedateselect = Util.null2String(request.getParameter("docarchivedateselect"));
String doclastmoddateselect = Util.null2String(request.getParameter("doclastmoddateselect"));
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(urlType.equals("0")&&doccreatedateselect.equals("")){
	doccreatedateselect = "1";
}
String docapprovedateselect = Util.null2String(request.getParameter("docapprovedateselect"));
String approvedateselect = Util.null2String(request.getParameter("approvedateselect"));
String subscribedateselect = Util.null2String(request.getParameter("subscribedateselect"));
String currentState = Util.null2String(request.getParameter("currentState"));
String pop_state = Util.null2String(request.getParameter("pop_state"));
//需要保留从快速搜索过来的文档标题信息

String docsubject = Util.null2String(request.getParameter("docsubject"),"");


int userid =user.getUID();
int advanced=Util.getIntValue(request.getParameter("advanced"),0);
boolean isUsedCustomSearch = "true".equals(Util.null2String(request.getParameter("isUsedCustomSearch")))?true:false;


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "文档回收站";

String doccontent = "" ;
String containreply = "" ;
int maincategoryid= 0 ;
int subcategoryid= 0 ;
int seccategoryid= 0 ;
int maincategory= 0 ;
int subcategory= 0 ;
int seccategory= 0 ;
int docid= 0 ;

int ownersubcompanyid = 0;
int doclangurage= 0 ;
int hrmresid= 0 ;
int itemid= 0 ;
int itemmaincategoryid= 0 ;
int crmid= 0 ;
int projectid= 0 ;
int financeid= 0 ;
String docpublishtype = "" ;
String docstatus = "" ;
String keyword= "" ;
String contentname="";
int ownerid= 0 ;
int ownerid2= 0 ;   //客户拥有者的id
int date2during = 0;


seccategoryid =  Util.getIntValue(Util.null2String(request.getParameter("seccategoryid")),0);

String docno = "" ;
String doclastmoddatefrom = "" ;
String doclastmoddateto = "" ;
String docarchivedatefrom = "" ;
String docarchivedateto = "" ;
String doccreatedatefrom = "" ;
String doccreatedateto = "" ;
String docapprovedatefrom = "" ;
String docapprovedateto = "" ;
String replaydoccountfrom = "" ;
String replaydoccountto = "" ;


String usertype = "" ;
String deleteusertype = "" ;
String customSearchPara ="";

String subscribeDateFrom = "";
String subscribeDateTo = "";
String approveDateFrom = "";
String approveDateTo = "";

String dspreply = Util.null2String(request.getParameter("dspreply"));


int doclastmoduserid = 0 ;
int docarchiveuserid = 0 ;
int doccreaterid = 0 ;
int doccreaterid2 = 0 ;  //客户拥有者的id
int docdeleteuserid = 0 ;
int docdeleteuserid2 = 0 ;  //管理员的id
int docapproveuserid = 0 ;
int assetid = 0 ;

int showtype = 0;
String treeDocTemp="";
String treeDocFieldId="";
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
customSearchPara = Util.null2String(request.getParameter("customSearchPara"));
date2during=Util.getIntValue(request.getParameter("date2during"),-1);
if(date2during == 0)
{
	date2during = 38;
}


int ownerdepartmentid = 0;

int negative = 0;

String TDWidth = "";
	ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
	ownersubcompanyid = Util.getIntValue(request.getParameter("ownersubcompanyid"),0);
	String vdepartmentid=Util.null2String(request.getParameter("departmentid"));
    doccontent = Util.toScreenToEdit(request.getParameter("doccontent"),user.getLanguage());
    containreply = Util.toScreenToEdit(request.getParameter("containreply"),user.getLanguage());
    maincategory= Util.getIntValue(request.getParameter("maincategory"),0);
    subcategory= Util.getIntValue(request.getParameter("subcategory"),0);
    seccategory= Util.getIntValue(request.getParameter("seccategory"),0);
    docid= Util.getIntValue(request.getParameter("docid"),0);
    
    doclangurage= Util.getIntValue(request.getParameter("doclangurage"),0);
    hrmresid= Util.getIntValue(request.getParameter("hrmresid"),0);
    itemid= Util.getIntValue(request.getParameter("itemid"),0);
    itemmaincategoryid= Util.getIntValue(request.getParameter("itemmaincategoryid"),0);
    crmid= Util.getIntValue(request.getParameter("crmid"),0);
    projectid= Util.getIntValue(request.getParameter("projectid"),0);
    financeid= Util.getIntValue(request.getParameter("financeid"),0);
    docpublishtype= Util.toScreenToEdit(request.getParameter("docpublishtype"),user.getLanguage());
    docstatus= Util.toScreenToEdit(request.getParameter("docstatus"),user.getLanguage());
    keyword= Util.toScreenToEdit(request.getParameter("keyword"),user.getLanguage());
	contentname= Util.toScreenToEdit(request.getParameter("contentname"),user.getLanguage());
    ownerid= Util.getIntValue(request.getParameter("ownerid"),0);
    ownerid2= Util.getIntValue(request.getParameter("ownerid2"),0);
   
    docno = Util.toScreenToEdit(request.getParameter("docno"),user.getLanguage());
    doclastmoddatefrom = Util.toScreenToEdit(request.getParameter("doclastmoddatefrom"),user.getLanguage());
    doclastmoddateto = Util.toScreenToEdit(request.getParameter("doclastmoddateto"),user.getLanguage());

    docarchivedatefrom = Util.toScreenToEdit(request.getParameter("docarchivedatefrom"),user.getLanguage());
    
    subscribeDateFrom = Util.toScreenToEdit(request.getParameter("subscribeDateFrom"),user.getLanguage());
    subscribeDateTo = Util.toScreenToEdit(request.getParameter("subscribeDateTo"),user.getLanguage());
    approveDateFrom = Util.toScreenToEdit(request.getParameter("approveDateFrom"),user.getLanguage());
    approveDateTo = Util.toScreenToEdit(request.getParameter("approveDateTo"),user.getLanguage());
    
    docarchivedateto = Util.toScreenToEdit(request.getParameter("docarchivedateto"),user.getLanguage());
    doccreatedatefrom = Util.toScreenToEdit(request.getParameter("doccreatedatefrom"),user.getLanguage());
    doccreatedateto = Util.toScreenToEdit(request.getParameter("doccreatedateto"),user.getLanguage());
    docapprovedatefrom = Util.toScreenToEdit(request.getParameter("docapprovedatefrom"),user.getLanguage());
    docapprovedateto = Util.toScreenToEdit(request.getParameter("docapprovedateto"),user.getLanguage());
    replaydoccountfrom = Util.toScreenToEdit(request.getParameter("replaydoccountfrom"),user.getLanguage());
    replaydoccountto = Util.toScreenToEdit(request.getParameter("replaydoccountto"),user.getLanguage());


    doclastmoduserid = Util.getIntValue(request.getParameter("doclastmoduserid"),0);
    docarchiveuserid = Util.getIntValue(request.getParameter("docarchiveuserid"),0);
    doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
	docdeleteuserid = Util.getIntValue(request.getParameter("docdeleteuserid"),0);
    doccreaterid2 = Util.getIntValue(request.getParameter("doccreaterid2"),0);
	docdeleteuserid2 = Util.getIntValue(request.getParameter("docdeleteuserid2"),0);

    docapproveuserid = Util.getIntValue(request.getParameter("docapproveuserid"),0);
    assetid = Util.getIntValue(request.getParameter("assetid"),0);
	usertype = Util.null2String(request.getParameter("usertype"));
	deleteusertype = Util.null2String(request.getParameter("deleteusertype"));	
	showtype = Util.getIntValue(request.getParameter("showtype"),0);
	treeDocFieldId =Util.null2String(request.getParameter("treeDocFieldId"));
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(date2during==-1)
{
	date2during = olddate2during;
}
    if ("0".equals(replaydoccountfrom))  replaydoccountfrom = "" ;
    if ("0".equals(replaydoccountto))  replaydoccountto = "" ;

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />	
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String topButton = "";

%>
	<div id='DocSearchDiv' style=''>
	
<form name="frmmain" id="frmmain" method="post" action="DocRecycleContent.jsp?offical=<%=offical %>&officalType=<%=officalType %>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>"/>
<input type="hidden" id="subcompanyId" name="subcompanyId" value="<%=subcompanyId %>"/>
<% if(DocReplyUtil.isUseNewReply()) { %>
<input type="hidden" id="dspreply" name="dspreply" value="1" />
<%}%>
<input type="hidden" id="_doccreater" name="_doccreater" value=""/>
<input type="hidden" id="urlType" name="urlType" value="<%= urlType %>"/>
<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
<input type="hidden" name = "customSearchPara">
<input type="hidden" name="opera">
<input type="hidden" name="from" value="<%=from%>">
<input type="hidden" name="showtype" value="<%=showtype%>">
<input type="hidden" name="self"  value="false">
<input type="hidden" name="isUsedCustomSearch"  value="<%=isUsedCustomSearch%>">
<input type="hidden" name="seccategoryid"  value="<%=seccategoryid%>">
<input type="hidden" id="isinit" name="isinit" value="<%=isinit%>">
<input type="hidden" id="ishow" name="ishow" value="false"/>
<DIV style="display:none">
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClickRight(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(hasOperateMenu){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16211,user.getLanguage())+",javascript:doMuliRecover(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doMuliDelete(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
	<button type="button" class=btnSearch accessKey=S onClick="onBtnSearchClick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>

	<%String useCustomSearch = "";%>
		<input type="hidden" name="pageId" id="pageId"  value="<%=pageId%>"/>
<%
String	columnUrl = "ext/DocSearchViewColumnExt.jsp?displayUsage="+displayUsage;
String	gridUrl = "ext/DocSearchGridExt.jsp?displayUsage="+displayUsage;	
if(isSysadmin==1){
	topButton +="{iconCls:'btn_viewUrl',text:'"+SystemEnv.getHtmlLabelName(21682, user.getLanguage())+"',handler:function(){viewSourceUrl()}},";
	topButton +="'-',";
}
if(topButton.length()>5){
	topButton = topButton.substring(0,topButton.length()-5);
}
topButton = "["+topButton+"]";

int mouldid=0;
%>
</div>
	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td style="<%=TDWidth%>">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(hasOperateMenu){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(16211,user.getLanguage())%>" class="e8_btn_top" onclick="doMuliRecover()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doMuliDelete()"/>
			<%}%>
			<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="<%= docsubject %>" onchange="setKeyword('flowTitle','docsubject','frmmain');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
	String advanceattrs = "{'samePair':'advanceCondition'}";
%>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >

  
<%
	int rowNum = 0;
	String attrs = "{'expandAllGroup':'"+((urlType.equals("13")||urlType.equals("14")||urlType.equals("15"))?"true":"false")+"'}"; 
%>

<wea:layout type="4col" attributes='<%=attrs %>'>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle type="text"  name="docsubject" id="docsubject" value="<%=docsubject%>">
				   <span class="e8tips" title="<%=searchMsg %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
			<wea:item>
				 <span style="float:left;">
						<select id="doccreateridsel" style="width:80px;" name="doccreaterididsel" onchange="changeType(this.value,'doccreaterid','doccreaterid2','usertype');">
							<option value="1" <%=doccreaterid2==0?"selected":"" %>>
								<%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>
							</option>
							<option value="2" <%=doccreaterid2!=0?"selected":"" %>>
								<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
							</option>
						</select>
					 </span>

				  <span id="doccreateridselspan" style="<%=doccreaterid2==0?"":"display:none;" %>">
				   <brow:browser viewType="0" name="doccreaterid" browserValue='<%= ""+doccreaterid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_callback="afterShowResource"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>'></brow:browser>
					</span>
				<span id="doccreaterid2selspan" style="<%=doccreaterid2!=0?"":"display:none;" %>">
						  <brow:browser viewType="0" name="doccreaterid2" browserValue='<%= ""+doccreaterid2 %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7" linkUrl="javascript:openhrm($id$)" width="150px"
				browserSpanValue='<%=doccreaterid2!=0?Util.toScreen(CustomerInfo.getCustomerInfoname(doccreaterid2+""),user.getLanguage()):""%>'></brow:browser>
				</span>
				<input type="hidden" name="usertype" value="<%=usertype%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
			<wea:item>
				<span >
					<brow:browser viewType="0" name="seccategory" browserValue='<%=""+seccategory%>' idKey="id" nameKey="path"
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
					 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=""+secinput%>'
					 completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
					browserSpanValue='<%=SecCategoryComInfo.getAllParentName(""+seccategory,true)%>'></brow:browser>
				</span>
			</wea:item>
			<%if(urlType.equals("23")){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(26684,user.getLanguage())%></wea:item>
			<wea:item>
				 <span style="float:left;">
						<select id="docdeleteuseridsel" style="width:80px;" name="docdeleteuserididsel" onchange="changeType2(this.value,'docdeleteuserid','docdeleteuserid2','deleteusertype');">
							<option value="1" <%=docdeleteuserid2==0?"selected":"" %>>
								<%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>
							</option>
							<%if(isUseDocManageDetach){%>
							<option value="2" <%=docdeleteuserid2!=0?"selected":"" %>>
							 <%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
							</option>
							<%}else{%>
							<option value="2" <%=docdeleteuserid2!=0?"selected":"" %>>
							 <%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%>
							</option>
							<%}%>
						</select>
					 </span>

				  <span id="docdeleteuseridselspan" style="<%=docdeleteuserid2==0?"":"display:none;" %>">
				   <brow:browser viewType="0" name="docdeleteuserid" browserValue='<%= ""+docdeleteuserid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_callback="afterShowResource"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(docdeleteuserid+""),user.getLanguage())%>'></brow:browser>
					</span>
				<%if(isUseDocManageDetach){%>
				<span id="docdeleteuserid2selspan" style="<%=docdeleteuserid2!=0?"":"display:none;" %>">
						  <brow:browser viewType="0" name="docdeleteuserid2" browserValue='<%= ""+docdeleteuserid2 %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/sysadminBrowser.jsp?_from=1" _callback="afterShowParent2"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=sysadmin" linkUrl="javascript:openhrm($id$)" width="150px"
				browserSpanValue='<%=docdeleteuserid2!=0?Util.toScreen(ResourceComInfo.getResourcename(docdeleteuserid2+""),user.getLanguage()):""%>'></brow:browser>
				</span>
				<%}else{%>
				<span id="docdeleteuserid2selspan" >
				<input type="hidden" id="docdeleteuserid2" name="docdeleteuserid2" value="<%=docdeleteuserid2%>">
				</span>
				<%}%>
				
				<input type="hidden" name="deleteusertype" value="<%=deleteusertype%>">
			</wea:item>
			<%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="doccreatedateselect" _defaultValue=<%=urlType.equals("0")?"1":"0" %>>
					<input class=wuiDateSel type="hidden" name="doccreatedatefrom" value="<%=doccreatedatefrom%>">
					<input class=wuiDateSel  type="hidden" name="doccreatedateto" value="<%=doccreatedateto%>">
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					<brow:browser viewType="0" name="departmentid" browserValue='<%= ""+departmentid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=4" 
							browserSpanValue='<%=departmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage()):""%>'>
					</brow:browser>
				</span>
			</wea:item>
			<%if(date2duringTokens.length>0){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=inputstyle  size=1 id=date2during name=date2during>
						<!-- 全部 -->
						<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<%
						for(int i=0;i<date2duringTokens.length;i++)
						{
							int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
							if(tempdate2during>36||tempdate2during<1)
							{
								continue;
							}
						%>
						<!-- 最近个月 -->
						<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
						<%
						} 
						%>
						
					 </select>
				</wea:item>
			<%}%>
		</wea:group>
		<%String __attrs = "{'itemAreaDisplay':'"+("none")+"'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' attributes="<%=__attrs %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="docno" value='<%=docno%>'></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></wea:item>
				<wea:item>
						<span style="float:left;">
							<select style="width:80px;" id="owneridsel" name="owneridsel" onchange="changeType(this.value,'ownerid','ownerid2','usertype');">
								<option value="1" <%=ownerid2==1?"selected":"" %>>
									<%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>
								</option>
								<option value="2" <%=ownerid2!=0?"selected":"" %>>
									<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
								</option>
							</select>
    					</span>
					<span id="owneridselspan" style="<%=ownerid2==0?"":"display:none;" %>">
					<brow:browser viewType="0" name="ownerid" browserValue='<%= ""+ownerid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_callback="afterShowResource"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=ownerid!=0?Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
					<span id="ownerid2selspan" style="<%=ownerid2!=0?"":"display:none;" %>"><brow:browser viewType="0" name="ownerid2" browserValue='<%= ""+ownerid2 %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=7" width="150px"
					browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(ownerid2+""),user.getLanguage())%>'></brow:browser>
					</span>
				</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=4" 
									browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownersubcompanyid" browserValue='<%= ""+ownersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=ownersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(ownersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle  id="docpublishtype" size="1" name="docpublishtype">
                            <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                            <option value="1" <%if (docpublishtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
                            <option value="2" <%if (docpublishtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
                            <option value="3" <%if (docpublishtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
                          </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doclastmoddateselect">
					    <input class=wuiDateSel type="hidden" name="doclastmoddatefrom" value="<%=doclastmoddatefrom%>">
					    <input class=wuiDateSel  type="hidden" name="doclastmoddateto" value="<%=doclastmoddateto%>">
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
                        <brow:browser viewType="0" name="treeDocFieldId" browserValue='<%= ""+treeDocFieldId %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
					hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99999" 
					browserSpanValue='<%=!"".equals(treeDocFieldId)?DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId,","):""%>'>
					</brow:browser>
					</span>
				</wea:item>

				<wea:item><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="keyword" <%if(!(keyword.equals(""))){%>value='<%=keyword%>'<%}%>></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(2001,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountfrom" value="<%=replaydoccountfrom%>" size=8>
                          -
                          <input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountto" value="<%=replaydoccountto%>" size=9>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle id="docstatus" name="docstatus">
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						<option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
						<option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
				  </select>
				</wea:item>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
  </wea:layout>
<div id='advicedSearchDiv' >

<div id='customSearchDiv'></div>
</div>

</div>
</form>
	</div>


<div style="display:none;">
	<brow:browser name="otherDocId" browserBtnID="otherDocId_btn" viewType="0" isMustInput="1" _callback="afterShowMDocidForOwner" getBrowserUrlFn="getBrowserUrl"></brow:browser>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
int langid=user.getLanguage();
String backfields="t1.id,t1.docextendname,t1.docsubject,t1.ownerid,t1.docdeleteuserid,t1.docvestin,t1.seccategory,t1.docdeletedate,t1.docdeletetime";
String sqlFrom="recycle_docdetail t1 ";
String orderBy="t1.docdeletedate asc,t1.docdeletetime asc ,t1.id asc ";
String sqlWhere=" t1.ishistory!=1 ";
if(!urlType.equals("23")){
	sqlWhere+=" and t1.docdeleteuserid="+user.getUID();
}
if(!allsecids.equals("")&&isUseDocManageDetach&&urlType.equals("23")){
	sqlWhere+=" and t1.seccategory in ("+allsecids+")";
}else if(isUseDocManageDetach&&allsecids.equals("")&&urlType.equals("23")){
	sqlWhere+=" and 1=2 ";
}
if(!docsubject.equals("")){
	sqlWhere+=" and t1.docsubject like '%"+docsubject+"%' ";
}
if(deleteusertype.equals("2")){
	docdeleteuserid=docdeleteuserid2;
}
if(doccreaterid>0){
	sqlWhere+=" and t1.doccreaterid = "+doccreaterid;
}
if(seccategory>0){
	sqlWhere+=" and t1.seccategory ="+seccategory;
}
if (!doccreatedatefrom.equals("")) {
	sqlWhere = sqlWhere + " and t1.doccreatedate>='" + doccreatedatefrom + "' ";
}
if (!doccreatedateto.equals("")) {
	sqlWhere = sqlWhere + " and t1.doccreatedate<='"	+ doccreatedateto + "' ";
}
if(departmentid>0){
	sqlWhere+=" and t1.departmentid = "+departmentid;
}
if(docdeleteuserid>0){
	sqlWhere+=" and t1.docdeleteuserid = "+docdeleteuserid;
}
Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
		Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);
if(date2during>0&&date2during<37)
{
	Calendar tempday = Calendar.getInstance();
	tempday.clear();
	tempday.set(year,month,day-30*date2during);
	String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
		Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
			sqlWhere+=" and t1.doclastmoddate>'"+lastday+"' ";
}

if(!docno.equals("")){
	sqlWhere+=" and t1.docno like '%"+ Util.fromScreen2(docno, langid)+"%' ";
}
if (doccreaterid>0 || ownerid>0) {
	 String _userid=doccreaterid>0?(doccreaterid+""):(ownerid+"");
	 HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
	 User belongsuser=new User();
	 String belongtoshow = userSetting.getBelongtoshowByUserId(_userid); 		
	 String belongtoids = belongsuser.getBelongtoidsByUserId(_userid);
	 String account_type = belongsuser.getAccount_type();
	if (doccreaterid>0 && ownerid>0) {
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		sqlWhere = sqlWhere + " and (t1.doccreaterid in("+belongtoids+","+doccreaterid + ") or t1.ownerid in(" +belongtoids+","+ownerid + ") ) ";
		}else{
			sqlWhere = sqlWhere + " and (t1.doccreaterid="	+ doccreaterid + " or t1.ownerid=" + ownerid + ") ";
		}
	} else if (doccreaterid>0) {
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			sqlWhere = sqlWhere + " and t1.doccreaterid in(" +belongtoids+","+doccreaterid	+ ") ";
		}else{
			sqlWhere = sqlWhere + " and t1.doccreaterid=" + doccreaterid + " ";
		}
	} else if (ownerid>0) {
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			sqlWhere = sqlWhere + " and t1.ownerid in(" +belongtoids+","+ownerid + ") ";
		}else{
			sqlWhere = sqlWhere + " and t1.ownerid=" + ownerid + " ";
		}
	}
}
if(ownerdepartmentid>0|| creatersubcompanyid>0 || ownersubcompanyid>0){
	sqlFrom += " ,hrmresource hr";
}
if(ownerdepartmentid<0|| creatersubcompanyid<0|| ownersubcompanyid<0||Util.getIntValue(vdepartmentid,0)<0){
	sqlFrom += " ,(  select tv2.subcompanyid1 ,tv2.id,tv2.departmentid  from HrmResourceVirtual tv1,HrmResource tv2 where tv1.resourceid=tv2.id ";
	if(Util.getIntValue(vdepartmentid,0)<0){
	 sqlFrom +=" and tv1.departmentid   = "+vdepartmentid;
	}
	if(ownerdepartmentid<0){
	 sqlFrom +=" and tv1.departmentid   = "+ownerdepartmentid;
	}
	if(creatersubcompanyid<0){
	 sqlFrom +=" and tv1.subcompanyid  = "+creatersubcompanyid;
	}
	if(ownersubcompanyid<0){
	 sqlFrom +=" and tv1.subcompanyid  = "+ownersubcompanyid;
	}
	 sqlFrom +=" ) hr ";
}
if(ownerdepartmentid>0){
	sqlWhere =sqlWhere+" and hr.id = t1.ownerid and hr.departmentid = " + ownerdepartmentid;
}

if(creatersubcompanyid>0){
	sqlWhere =sqlWhere+" and hr.id = t1.doccreaterid and hr.subcompanyid1 = " + creatersubcompanyid;
}
if(creatersubcompanyid<0||Util.getIntValue(vdepartmentid,0)<0){
	sqlWhere =sqlWhere+" and hr.id = t1.doccreaterid";

}
if(ownersubcompanyid>0){
	sqlWhere =sqlWhere+" and hr.id = t1.ownerid and hr.subcompanyid1 = " + ownersubcompanyid;
}
if(ownersubcompanyid<0||ownerdepartmentid<0){
	sqlWhere =sqlWhere+" and hr.id = t1.ownerid ";
}
if (docpublishtype.equals("1") || docpublishtype.equals("2") || docpublishtype.equals("3")) {
	if (docpublishtype.equals("1")) {
		sqlWhere += " and (t1.docpublishtype='1'  or t1.docpublishtype='' or t1.docpublishtype is null )";
	} else {
		sqlWhere += " and t1.docpublishtype='" + docpublishtype + "' ";
	}
}
if (!doclastmoddatefrom.equals("")) {
	sqlWhere = sqlWhere + " and t1.doclastmoddate>='" + doclastmoddatefrom + "' ";
}
if (!doclastmoddateto.equals("")) {
	sqlWhere = sqlWhere + " and t1.doclastmoddate<='" + doclastmoddateto + "' ";
}
if (!treeDocFieldId.equals("")) {
	if(",".equals(treeDocFieldId.substring(0,1))) 
	treeDocFieldId=treeDocFieldId.substring(1);
	sqlWhere = sqlWhere + " and  t1.id in (select docid from  DocDummyDetail where catelogid in ("+treeDocFieldId+")) ";
}
if (!keyword.equals("")) 
{
	String keywordSql = "";
	keyword = keyword.trim();
	ArrayList keywordList = Util.TokenizerString(keyword, " ");
	if(keywordList!=null&&keywordList.size()>0)
	{
		for(int i=0;i<keywordList.size();i++)
		{
			String tempkeyword = (String)keywordList.get(i);
			keywordSql += keywordSql.equals("")?" t1.keyword like '%"+tempkeyword+"%' ":" or t1.keyword like '%"+tempkeyword+"%' ";
		}
		if(!keywordSql.equals(""))
		{
			keywordSql =" ("+keywordSql+") ";
		}
	}
	if(!keywordSql.equals(""))
	{
		sqlWhere = sqlWhere + " and  "+keywordSql;
	}
}
if (!replaydoccountfrom.equals("")) {
	sqlWhere = sqlWhere + " and t1.replaydoccount >=" + replaydoccountfrom + " ";
}
if (!replaydoccountto.equals("")) {
	sqlWhere = sqlWhere + " and t1.replaydoccount <=" + replaydoccountto + " ";
}
if (docstatus.equals("1") || docstatus.equals("5") || docstatus.equals("7")) {
	if (docstatus.equals("1")) {
		sqlWhere += " and t1.docstatus in (1,2)";
	} else {
		sqlWhere += " and t1.docstatus=" + docstatus + " ";
	}
}

//设置好搜索条件	 
String  operateString= "";
if(hasOperateMenu){
	operateString= "<operates width=\"20%\">";
	operateString+="     <operate href=\"javascript:onRecoverSingleDoc()\" text=\""+SystemEnv.getHtmlLabelName(16211,user.getLanguage())+"\"  index=\"0\"/>";
	operateString+="     <operate href=\"javascript:onDeleteSingleDoc()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>";
	operateString+="</operates>";	
}              

String tableString =" <table  tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),PageIdConst.DOC)+"\" >"+
					 "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
					 operateString+
					 "<head>"+
					 "<col width=\"3%\"   align=\"center\" text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\" orderkey=\"docextendname\"/>"+
					 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" labelid=\"58\" column=\"id\" otherpara=\"column:docSubject\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameForDocMonitor\"  orderkey=\"docSubject\"/>"+
					 "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" labelid=\"79\" column=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\" orderkey=\"ownerid\"/>";
if(urlType.equals("23")){
	tableString=tableString+"<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(26684,user.getLanguage())+"\" labelid=\"26684\" column=\"docdeleteuserid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\" orderkey=\"docdeleteuserid\"/>";
}					 
					 tableString=tableString+"<col pkey=\"allpath\"  width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" labelid=\"92\" column=\"seccategory\" otherpara=\"column:docvestin+"+user.getUID()+"\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\" orderkey=\"seccategory\"/>"+
					 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(130704,user.getLanguage())+"\"  column=\"docdeletedate\"   transmethod=\"weaver.splitepage.transform.SptmForDoc.getHasdeletedays\" orderkey=\"docdeletedate\"/>"+
					 "</head>"+   			
					 "</table>"; 
%>
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 


<!-- Ext搜索结果显示列信息定义  -->

<script type="text/javascript">
	function setKeyword(source,target,formId){
	jQuery("input#"+target).val(jQuery("#"+source).val());
	}
</script>
<script type="text/javascript">
function onRecoverDoc(docid,isLast){
	var url = "/docs/docs/DocRecycleOperate.jsp?operation=recover&docid="+docid;
	jQuery.ajax({
		url : url , 
		data : {},
		type: 'POST',
		async:false,
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		},
		complete:function(){
			if(isLast){
				e8showAjaxTips("",false);
			}
		},
		success: function (data) {
			if(isLast){
				_xtable_CleanCheckedCheckbox();
				_table.reLoad();
			}
		},
		error: function (xhr) { 
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130665,user.getLanguage())%>");  
		} 
	});
}
function onRecoverSingleDoc(docid){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(130666,user.getLanguage())%>",function(){
		var url = "/docs/docs/DocRecycleOperate.jsp?operation=recover&docid="+docid;
		jQuery.ajax({
			url : url , 
			data : {},
			type: 'POST',
			async:false,
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success: function (data) {
				_table.reLoad();
				_xtable_CleanCheckedCheckbox();
			},
			error: function (xhr) { 
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130665,user.getLanguage())%>"); 
			} 
		});
	});
}
//批量恢复文档
function doMuliRecover(recDocIds){
	if(!recDocIds){
		recDocIds = _xtable_CheckedCheckboxId();
	}
	if(!recDocIds){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130667,user.getLanguage())%>");
		return;
	}
	var recIdArr = recDocIds.split(",");
	var _tips="<%=SystemEnv.getHtmlLabelName(130668,user.getLanguage())%> "+(recIdArr.length-1)+" <%=SystemEnv.getHtmlLabelName(130669,user.getLanguage())%>?";
	top.Dialog.confirm(_tips,function(){
		var isLast = false;
		for(var i=0;i<recIdArr.length;i++){
			if(i==recIdArr.length-1)
				isLast = true;
			onRecoverDoc(recIdArr[i],isLast);
		}
	});
}
function onDeleteDoc(docid,isLast){
	var url = "/docs/docs/DocRecycleOperate.jsp?operation=delete&docid="+docid;
	jQuery.ajax({
		url : url , 
		data : {},
		type: 'POST',
		async:false,
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		},
		complete:function(){
			if(isLast){
				e8showAjaxTips("",false);
			}
		},
		success: function (data) {
			if(isLast){
				_table.reLoad();
				_xtable_CleanCheckedCheckbox();
			}
		},
		error: function (xhr) { 
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>"); 
		} 
	});
}
function onDeleteSingleDoc(docid){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(130670,user.getLanguage())%>",function(){
		var url = "/docs/docs/DocRecycleOperate.jsp?operation=delete&docid="+docid;
		jQuery.ajax({
			url : url , 
			data : {},
			type: 'POST',
			async:false,
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success: function (data) {
				_table.reLoad();
				_xtable_CleanCheckedCheckbox();
			},
			error: function (xhr) { 
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>"); 
			} 
		});
	});
}
//批量删除文档
function doMuliDelete(delDocIds){
	if(!delDocIds){
		delDocIds = _xtable_CheckedCheckboxId();
	}
	if(!delDocIds){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	
	var delIdArr = delDocIds.split(",");
	var _tips="<%=SystemEnv.getHtmlLabelName(130671,user.getLanguage())%> "+(delIdArr.length-1)+" <%=SystemEnv.getHtmlLabelName(130669,user.getLanguage())%>?";
	top.Dialog.confirm(_tips,function(){
		var isLast = false;
		for(var i=0;i<delIdArr.length;i++){
			if(i==delIdArr.length-1)
				isLast = true;
			onDeleteDoc(delIdArr[i],isLast);
		}
	});
}
function setCustomSearch(e,d,n,seccategory){
		jQuery.post(
				'/docs/search/ext/CustomFieldExtProxy.jsp',
				{
					'seccategory' : d.id
				},
				function(data){					
					jQuery('#customSearchDiv').html(data);			
					__defaultTemplNamespace__.initLayout();
					jQuery('#customSearchDiv').find('select').each(function(i,v){
						beautySelect(jQuery(v));
					});
				}
			);
	}

function getBrowserUrl(){
	var inputeId = jQuery("#otherDocId_btn").data("inputeId");
	var para = jQuery("#otherDocId_btn").data("para");
	return "/systeminfo/BrowserMain.jsp?url=/docs/docsubscribe/MutiDocByOwenerBrowser.jsp?documentids=" + inputeId.value + "&subscribePara=" + para;
}

function selectCheckbox(obj){
     changeCheckboxStatus(obj);
     _xtalbe_chkCheck(obj) ;
 }

function afterShowMDocidForOwner(e, id1, name, params) {
    var spanId = jQuery("#otherDocId_btn").data("spanId");
	var inputeId = jQuery("#otherDocId_btn").data("inputeId");
	var checkboxId = jQuery("#otherDocId_btn").data("checkboxId");
	var para = jQuery("#otherDocId_btn").data("para");
    if (id1!=null) {
        if (id1.id != "") {
            selectCheckbox(checkboxId);
            DocIds = id1.id;
            DocName = id1.name;
            sHtml = "";
            inputeId.value = DocIds;
            while (DocIds.indexOf(",")>-1){
             curid = DocIds.substring(0, DocIds.indexOf(",") - 1);
             curname = DocName.substring(0, DocName.indexOf(",") - 1);
             DocIds = DocIds.substring(DocIds.indexOf(",") + 1, DocIds.length);
             DocName = DocName.substring(DocName.indexOf(",") + 1, DocName.length);
             sHtml = sHtml + curname + "&nbsp";
             
            }
            sHtml = sHtml + DocName + "&nbsp";
            jQuery(spanId).html(sHtml);
            
        } else {
            spanId.innerHTML = "";
            inputeId.value = "";
        };
    }
}

var sessionId="";		
var colInfo;
var gridUrl ='<%=gridUrl%>';
var displayUsage = '<%=displayUsage%>';
var seccategoryid='<%=seccategory%>';
var subcategoryid = '<%=subcategory%>';
var maincategoryid = '<%=maincategory%>';
var customSearchPara = '<%=customSearchPara%>';
function URLencode(sStr) 
{
	 return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}

function getSearchPara(){
	var docSearchForm = document.forms.frmmain;
	var searchPara ='';
	for(i=0;i<docSearchForm.elements.length;i++)
	{
		if(docSearchForm.elements[i].type=='checkbox'){
			if(docSearchForm.elements[i].checked==false){
				continue;
			}
		}
		if(docSearchForm.elements[i].name=='customSearchPara'){
			continue;
		}
		if(docSearchForm.elements[i].name=='seccategory'&&seccategoryid!='0'){
			searchPara+='&seccategory='+jQuery("#seccategory").val();
		}else if(docSearchForm.elements[i].name!= ''){

			if(docSearchForm.elements[i].value!=''){
				searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
			}
		}
	}
	searchPara='sessionId='+sessionId+'&list=all&from=<%=from%>&showtype=<%=showtype%>'+searchPara+"&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>";
	return searchPara;
}	


function getGridInfo(){
	var url = '<%=columnUrl%>';
	var data2duringparam = "";
	if(document.getElementById("date2during"))
	{
		data2duringparam = "&date2during="+document.getElementById("date2during").value;
	}
	if(url.indexOf("?")==-1){
		url = url+"?seccategoryid="+$GetEle("seccategoryid").value+"&isUsedCustomSearch="+$GetEle("isUsedCustomSearch").value+data2duringparam;
	}else{
		url = url+"&seccategoryid="+$GetEle("seccategoryid").value+"&isUsedCustomSearch="+$GetEle("isUsedCustomSearch").value+data2duringparam;
	}
	if(customSearchPara==''){
		url =url+'&'+getSearchPara();
	}else{
		url =url+'&'+customSearchPara;
	}

	var obj; 

	if (window.ActiveXObject) { 
		obj = new ActiveXObject('Microsoft.XMLHTTP'); 
	} 
	else if (window.XMLHttpRequest) { 
		obj = new XMLHttpRequest(); 
	} 	
	obj.open('GET', url+"&b="+new Date().getTime(), false); 
	obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
	obj.send(null); 
	if (obj.status == "200") {
		var tmpcolInfo =  obj.responseText;
		
		var posTemp=tmpcolInfo.indexOf("^^");
		if(posTemp!=-1){
			colInfo=tmpcolInfo.substring(0,posTemp);
			sessionId=tmpcolInfo.substring(posTemp+2,tmpcolInfo.length);
		}else{
			colInfo=tmpcolInfo;
		}
	} else {
	} 	    
}
</script>

<script type="text/javascript">
	//getGridInfo();	
		
</script>



<script type="text/javascript">

function afterShowResource(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="1";
		     $GetEle("ownerid2span").innerHTML="";
		     $GetEle("ownerid2").value="";
		     $GetEle("doccreaterid2span").innerHTML="";
		     $GetEle("doccreaterid2").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function afterShowParent(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="2";
	       $GetEle("owneridspan").innerHTML="";
	       jQuery("input[name='ownerid']")[0].value="";
		   
		   $GetEle("doccreateridspan").innerHTML="";
		   $GetEle("doccreaterid").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function afterShowParent2(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("deleteusertype").value="2";		   
		   $GetEle("docdeleteuseridspan").innerHTML="";
		   $GetEle("docdeleteuserid").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

</script>

<script language=javascript>
var isUsedCustomSearch = "<%=isUsedCustomSearch%>"
function encode(str){
    return escape(str);
}

function changelevel(tmpindex) {  
    try { //如果只有一个数量的时候就会出现BUG
    	document.all("check_con")(tmpindex-1).checked = true
    } catch (ex)   {
      document.all("check_con").checked = true
    }
}

function search(){  //确认搜索提交按钮
	var docSearchForm =$GetEle("frmmain");
	document.getElementById("isinit").value = "true";
	$GetEle("customSearchPara").value = getSearchPara();
	docSearchForm.submit();
}	

function onBtnSearchClickRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		onBtnSearchClick();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			onBtnSearchClick();
		}
	}
}

function onBtnSearchClick(){
		try
		{
			document.getElementById("isinit").value = "true";
		}
		catch(e)
		{
		}
		$GetEle("self").value='true'
		search();
}


</script>
</body>

<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery(".e8tips").wTooltip({html:true});
		try{
			parent.parent.cancelSelectedNode();
		}catch(e){}
	});
	<%if(isUseDocManageDetach&&allsecids.equals("")&&urlType.equals("23")&&subcompanyId.equals("")){%>
	function afterDoWhenLoaded(){
		jQuery(".e8EmptyTR").children(0).html("<%=SystemEnv.getHtmlLabelName(130713,user.getLanguage())%>...");
	}
	<%}%>	
	function changeType(val,span1,span2,input){
		if(val=="2"){
			jQuery("#"+span1).val("");
			jQuery("#"+span1+"span").html("");
			jQuery("#"+span2+"selspan").show();
			jQuery("#"+span1+"selspan").hide();
		}else{
			jQuery("#"+span2).val("");
			jQuery("#"+span2+"span").html("");
			jQuery("#"+span1+"selspan").show();
			jQuery("#"+span2+"selspan").hide();
		}
		if(input){
			jQuery("input[name='" + input + "']").val(val);
		}
	}
	function changeType2(val,span1,span2,input){
		<%if(isUseDocManageDetach){%>
		if(val=="2"){
			jQuery("#"+span1).val("");
			jQuery("#"+span1+"span").html("");
			jQuery("#"+span2+"selspan").show();
			jQuery("#"+span1+"selspan").hide();
		}else{
			jQuery("#"+span2).val("");
			jQuery("#"+span2+"span").html("");
			jQuery("#"+span1+"selspan").show();
			jQuery("#"+span2+"selspan").hide();
		}
		<%}else{%>
		if(val=="2"){
			jQuery("#"+span1).val("");
			jQuery("#"+span2).val("1");
			jQuery("#"+span1+"span").html("");
			jQuery("#"+span1+"selspan").hide();
		}else{
			jQuery("#"+span2).val("");
			jQuery("#"+span2+"span").html("");
			jQuery("#"+span1+"selspan").show();
		}
		<%}%>
		
		if(input){
			jQuery("input[name='" + input + "']").val(val);
		}
	}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</html>
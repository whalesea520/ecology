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
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />

<%!
	private String outPrint(int rowNum){
		 	if(rowNum%3==0){
		 		return "</tr><TR style=\"height:1px;\"><TD class=Line colSpan=6></TD></TR><tr>";
			}else{
				return "";
			}
	}
 %>

<%
String from = Util.null2String(request.getParameter("from"));
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isDetach=Util.null2String(request.getParameter("isDetach"));
String docdetachable="0";
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
String subcompanyId = Util.null2String(request.getParameter("subcompanyId"));
if(subcompanyId.equals("")){
 subcompanyId=SecCategoryComInfo.getSubcompanyIdFQ(Util.null2String(request.getParameter("seccategory")));
}
int language = user.getLanguage();
int  operatelevel= Util.getIntValue(CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocShareRight:all",Util.getIntValue(subcompanyId,0))+"",0);
if(isUseDocManageDetach){
   docdetachable="1";
}
String  secinput="1";
if((urlType.equals("15")||urlType.equals("11"))&&docdetachable.equals("1")){
secinput="0";
}else{
operatelevel=2;
}


int departmentid= 0 ;
int creatersubcompanyid = 0;
creatersubcompanyid = Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
departmentid= Util.getIntValue(request.getParameter("departmentid"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String infoId = Util.null2String(request.getParameter("infoId"));
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String searchMsg = SystemEnv.getHtmlLabelName(83436,user.getLanguage());
if("11".equals(urlType)||"15".equals(urlType)){//批量调整共享需要做权限判断
	if(!HrmUserVarify.checkUserRight("DocShareRight:all", user)){
				response.sendRedirect("/notice/noright.jsp");
				return;
	}
}
if("".equals(urlType)){
	if(offical.equals("1")){
		if(officalType==1)urlType="-99";
		else urlType="-98";
	}
}
boolean isRanking = (urlType.equals("2")||urlType.equals("1")||urlType.equals("3")||urlType.equals("4"));
String fromUrlType = Util.null2String(request.getParameter("fromUrlType"));
if(urlType.equals("14")&&fromUrlType.equals("1")){
	urlType = "6";
}
if ("docsubscribe".equals(request.getParameter("from"))) {
    response.sendRedirect("/docs/docsubscribe/DocSubscribe.jsp");
    return ;
} else if ("shareMutiDoc".equals(request.getParameter("from"))){
    //response.sendRedirect("/docs/docs/ShareMutiDocList.jsp");
    //return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%if(urlType.equals("13")||urlType.equals("14")||urlType.equals("15")){ %>
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
		parent.rebindNavEvent(null,null,null,parent.parent.loadLeftTree,{_window:window,hasLeftTree:true});
	</script>
<%} %>
<%if(urlType.equals("6")||urlType.equals("16")|| urlType.equals("5")){ %>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			if(jQuery("#dspreply").val()=="1"){
				jQuery("li.current",parent.document).removeClass("current");
				jQuery("#notReply",parent.document).addClass("current");
			}else if(jQuery("#dspreply").val()=="2"){
				jQuery("li.current",parent.document).removeClass("current");
				jQuery("#onlyReply",parent.document).addClass("current");
			}else if(jQuery("#dspreply").val()=="0"){
				jQuery("li.current",parent.document).removeClass("current");
				jQuery("#docAll",parent.document).addClass("current");
			}
		});
	</script>
<%}else if(urlType.equals("0")){ %>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			reSelectTab();
		});
		
		function reSelectTab(){
			var doccreatedateselect = jQuery("#doccreatedateselect");
			if(doccreatedateselect.length>0){
				if(doccreatedateselect.val()=="0"){
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docAll",parent.document).parent().addClass("current");
				}else if(doccreatedateselect.val()=="2"){
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docWeek",parent.document).parent().addClass("current");
				}else if(doccreatedateselect.val()=="3"){
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docMonth",parent.document).parent().addClass("current");
				}else if(doccreatedateselect.val()=="4"){
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docQuarterly",parent.document).parent().addClass("current");
				}else if(doccreatedateselect.val()=="5"){
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docYear",parent.document).parent().addClass("current");
				}else{
					jQuery("li.current",parent.document).removeClass("current");
					jQuery("#docToday",parent.document).parent().addClass("current");
				}
			}else{
				setTimeout(function(){
					reSelectTab();
				},50);
			}
		}
	</script>
<%} %>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<%
Enumeration em = request.getParameterNames();
boolean isinit = true;

String navName = "";

if(urlType.equals("5")){//我的文档
	navName = SystemEnv.getHtmlLabelName(1212,user.getLanguage());
}else if(urlType.equals("10")||urlType.equals("13")){//批量共享
	navName = SystemEnv.getHtmlLabelName(18037,user.getLanguage());
}else if(urlType.equals("2")){//最多回复
	navName = SystemEnv.getHtmlLabelName(32122,user.getLanguage());
}else if(urlType.equals("1")){//最多阅读
	navName = SystemEnv.getHtmlLabelName(32122,user.getLanguage());
}else if(urlType.equals("4")){//最多下载
	navName = SystemEnv.getHtmlLabelName(32122,user.getLanguage());
}else if(urlType.equals("0")){//最新文档
	navName = SystemEnv.getHtmlLabelName(16397,user.getLanguage());
}else if(urlType.equals("3")){//评分最高
	navName = SystemEnv.getHtmlLabelName(32122,user.getLanguage());
}else if((urlType.equals("6")&&fromUrlType.equals("1"))||urlType.equals("14")){//查询文档
	navName = SystemEnv.getHtmlLabelName(16399,user.getLanguage());
}else if((urlType.equals("6")&&!fromUrlType.equals("1"))){//文档目录
	navName = SystemEnv.getHtmlLabelName(16398,user.getLanguage());
	if(nodeid.indexOf("com_")!=-1 && creatersubcompanyid!=0){
		navName = SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+"");
	}else if(nodeid.indexOf("dept_")!=-1 && departmentid!=0){
		navName = DepartmentComInfo.getDepartmentName(""+departmentid);
	}
}else if(urlType.equals("11") || urlType.equals("15")){//批量调整共享
	navName = SystemEnv.getHtmlLabelName(31794,user.getLanguage());
}else if(urlType.equals("12")){//文档弹窗设置
	navName = SystemEnv.getHtmlLabelName(21885,user.getLanguage());
}else if(urlType.equals("7")||urlType.equals("8")||urlType.equals("9")){//文档订阅
	navName = SystemEnv.getHtmlLabelName(32121,user.getLanguage());
}else if(urlType.equals("16")){//文档中心
	navName = SystemEnv.getHtmlLabelName(19874,user.getLanguage());
}else if(urlType.equals("18")){//未读文档
	navName = SystemEnv.getHtmlLabelName(18441,user.getLanguage());
}else if(urlType.equals("-99")){//发文库
	navName = SystemEnv.getHtmlLabelName(33786,user.getLanguage());
}else if(urlType.equals("-98")){//收文库
	navName = SystemEnv.getHtmlLabelName(33793,user.getLanguage());
}
String pageId = "";

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
DocSearchComInfo.resetSearchInfo();
String docsubject = Util.null2String(request.getParameter("docsubject"),"");
DocSearchComInfo.setDocsubject(docsubject);
 
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid =user.getUID();
int advanced=Util.getIntValue(request.getParameter("advanced"),0);
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
boolean isUsedCustomSearch = "true".equals(Util.null2String(request.getParameter("isUsedCustomSearch")))?true:false;
//Docsubscribe add


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = navName;
String needfav ="1";
String needhelp ="";

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
String accessorycountfrom = "" ;
String accessorycountto = "" ;
String usertype = "" ;
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
int docapproveuserid = 0 ;
int assetid = 0 ;

int showtype = 0;
String treeDocTemp="";
String treeDocFieldId="";
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
customSearchPara = Util.null2String(request.getParameter("customSearchPara"));
session.setAttribute("customSearchPara_cu_"+userid,customSearchPara);
String isNew = Util.null2String(request.getParameter("isNew"));


date2during=Util.getIntValue(request.getParameter("date2during"),-1);
if(date2during == 0)
{
	date2during = 38;
}


int ownerdepartmentid = 0;

int negative = 0;

String TDWidth = "";

String strAccess="";
String srcType="0";
String srcContent="0";
String srcReply="0";
String eid = "";
String tabid = "";

if(mouldid==0){
	docsubject = DocSearchComInfo.getDocsubject();
	ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
	ownersubcompanyid = Util.getIntValue(request.getParameter("ownersubcompanyid"),0);
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
    accessorycountfrom = Util.toScreenToEdit(request.getParameter("accessorycountfrom"),user.getLanguage());
    accessorycountto = Util.toScreenToEdit(request.getParameter("accessorycountto"),user.getLanguage());

    doclastmoduserid = Util.getIntValue(request.getParameter("doclastmoduserid"),0);
    docarchiveuserid = Util.getIntValue(request.getParameter("docarchiveuserid"),0);
    doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
    doccreaterid2 = Util.getIntValue(request.getParameter("doccreaterid2"),0);

    docapproveuserid = Util.getIntValue(request.getParameter("docapproveuserid"),0);
    assetid = Util.getIntValue(request.getParameter("assetid"),0);
	usertype = Util.null2String(request.getParameter("usertype"));
	
	showtype = Util.getIntValue(request.getParameter("showtype"),0);
	treeDocFieldId =Util.null2String(request.getParameter("treeDocFieldId"));
	

}
else{
	DocSearchMouldManager.setId(mouldid);
	DocSearchMouldManager.selectSearchMouldInfo();
        docsubject = Util.toScreenToEdit(DocSearchMouldManager.getDocsubject(),user.getLanguage());
    doccontent = Util.toScreenToEdit(DocSearchMouldManager.getDoccontent(),user.getLanguage());
    containreply = DocSearchMouldManager.getContainreply();
    maincategory=DocSearchMouldManager.getMaincategory();
    subcategory=DocSearchMouldManager.getSubcategory();
    seccategory=DocSearchMouldManager.getSeccategory();
    docid=DocSearchMouldManager.getDocid();
    departmentid=DocSearchMouldManager.getDepartmentid();
    doclangurage=DocSearchMouldManager.getDoclangurage();
    hrmresid=DocSearchMouldManager.getHrmresid();
    itemid=DocSearchMouldManager.getItemid();
    itemmaincategoryid=DocSearchMouldManager.getItemmaincategoryid();
    crmid=DocSearchMouldManager.getCrmid();
    projectid=DocSearchMouldManager.getProjectid();
    financeid=DocSearchMouldManager.getFinanceid();
    docpublishtype=DocSearchMouldManager.getDocpublishtype();
    docstatus=DocSearchMouldManager.getDocstatus();
    keyword=DocSearchMouldManager.getKeyword();
    ownerid=DocSearchMouldManager.getOwnerid();
    ownerid2=DocSearchMouldManager.getOwnerid2();    //得到客户拥有者的id

    docno = DocSearchMouldManager.getDocno();
    doclastmoddatefrom = DocSearchMouldManager.getDoclastmoddatefrom();
    doclastmoddateto = DocSearchMouldManager.getDoclastmoddateto();
    docarchivedatefrom = DocSearchMouldManager.getDocarchivedatefrom();
    docarchivedateto = DocSearchMouldManager.getDocarchivedateto();
    doccreatedatefrom = DocSearchMouldManager.getDoccreatedatefrom();
    doccreatedateto = DocSearchMouldManager.getDoccreatedateto();
    docapprovedatefrom = DocSearchMouldManager.getDocapprovedatefrom();
    docapprovedateto = DocSearchMouldManager.getDocapprovedateto();
    replaydoccountfrom = DocSearchMouldManager.getReplaydoccountfrom();
    replaydoccountto = DocSearchMouldManager.getReplaydoccountto();
    accessorycountfrom = DocSearchMouldManager.getAccessorycountfrom();
    accessorycountto = DocSearchMouldManager.getAccessorycountto();

    doclastmoduserid = DocSearchMouldManager.getDoclastmoduserid();
    docarchiveuserid = DocSearchMouldManager.getDocarchiveuserid();
    doccreaterid = DocSearchMouldManager.getDoccreaterid();
    doccreaterid2 = DocSearchMouldManager.getDoccreaterid2();   //得到客户创建者的id
    docapproveuserid = DocSearchMouldManager.getDocapproveuserid();
    assetid = DocSearchMouldManager.getAssetid();
    treeDocFieldId =String.valueOf(DocSearchMouldManager.getTreeDocFieldId());
}

if(((urlType.equals("6")&&!fromUrlType.equals("1")) || urlType.equals("5")) && dspreply.equals("")){
	dspreply="1";
}

if(urlType.equals("0") && "1".equals(doccreatedateselect)){
	doccreatedatefrom = TimeUtil.getDateByOption("1","1");
	doccreatedateto = TimeUtil.getDateByOption("1","1");
}

if(urlType.equals("16")){//文档中心
	if(dspreply.equals("")){
		dspreply="1";
	}
	eid=Util.null2String(request.getParameter("eid"));
	tabid =Util.null2String(request.getParameter("tabid")); 
	if("".equals(tabid)){
		rs.execute("select * from hpNewsTabInfo where eid="+eid +" order by tabId");
		rs.next();
		tabid = rs.getString("tabId");
	}
	String strsqlwhere =hpec.getStrsqlwhere(eid);
	
	rs.execute("select sqlWhere from hpNewsTabInfo where eid = '"+eid+"' and tabId='"+tabid+"'");
	if(rs.next()){
		strsqlwhere = rs.getString("sqlWhere");
	}
	
	if(strsqlwhere.indexOf("^topdoc^")!=-1){
		strsqlwhere = Util.StringReplace(strsqlwhere, "^topdoc^","#");
		String[] temp = Util.TokenizerString2(strsqlwhere, "#");
		strsqlwhere = Util.null2String(temp[0]);
		//topDocIds = Util.null2String(temp[1]);
	}
	// 得到新闻页ID以及相关的展现方式
	if(strsqlwhere.length()<3){ 
		negative = 1;
	}else if("^,^".equals(strsqlwhere.substring(0,3))){
		negative = 1 ;
	}else{
		try {
			strsqlwhere = Util.StringReplace(strsqlwhere, "^,^","&");
		} catch (Exception e) {					
			e.printStackTrace();
		}
		String[] strsqlwheres = Util.TokenizerString2(strsqlwhere, "&");
		String newsId = Util.null2String(strsqlwheres[0]);
		int showModeId = Util.getIntValue(strsqlwheres[1]);
		String srcOpenFirstAccess="0";
		if (strsqlwheres.length>3) srcOpenFirstAccess=strsqlwheres[3];
		ArrayList docSrcList=Util.TokenizerString(""+newsId, "|");
		if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
		if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
		if (docSrcList.size()>2) {
			String _reply=Util.null2String((String)docSrcList.get(2));
			if(dspreply.equals("")){
				if(_reply.equals("1")){
					_reply="0";
				}else{
					_reply = "1";
				}
			}
		}
		if("0".equals(srcContent)) negative = 1 ;
		if("1".equals(srcOpenFirstAccess)) strAccess="isOpenFirstAss=1";
		else strAccess="isOpenFirstAss=0"; 
	}
	
}

//未读文档
if(urlType.equals("0")  && !"".equals(Util.null2String(request.getParameter("eid")))){

     eid=Util.null2String(request.getParameter("eid"));
     String strsqlwhere =hpec.getStrsqlwhere(eid);
	 ArrayList docSrcList=Util.TokenizerString(""+strsqlwhere, "|");
	 if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
	 if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
	 if (docSrcList.size()>2) {
		   srcReply=Util.null2String((String)docSrcList.get(2));
	 }
	// if("0".equals(srcContent)) negative = 1 ;

}


if(urlType.equals("5")){//我的文档
	if(user.getLogintype().equals("2")){//客户
		doccreaterid2 = user.getUID();
	}else{
		doccreaterid = user.getUID();
	}
}

String tempnavname = "";

if(seccategory!=0){
	tempnavname = Util.null2String(SecCategoryComInfo.getSecCategoryname(""+seccategory));
}else if(subcategory!=0){
	tempnavname = Util.null2String(SubCategoryComInfo.getSubCategoryname(""+subcategory));
}else if(maincategory!=0){
	tempnavname = Util.null2String(MainCategoryComInfo.getMainCategoryname(""+maincategory));
}
if(!tempnavname.trim().equals("")){
	navName = tempnavname;
}

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
   if(urlType.equals("15")||urlType.equals("11")){
    olddate2during=0;//批量调整共享默认显示全部文档
  
  }
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(date2during==-1)
{
	date2during = olddate2during;
}

%>
<%
    //add by dongping  for TD1419 文档的检索模板结果不对
    //因为,当 accessorycountfrom accessorycountto replaydoccountfrom replaydoccountto 四个字段,当不输入时,它就会在搜索条件里为0

    if ("0".equals(accessorycountfrom))  accessorycountfrom = "" ;
    if ("0".equals(accessorycountto))  accessorycountto = "" ;
    if ("0".equals(replaydoccountfrom))  replaydoccountfrom = "" ;
    if ("0".equals(replaydoccountto))  replaydoccountto = "" ;

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />	
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String topButton = "";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
%>
<%if(isShow.equals("true")){ %>
<script type="text/javascript">
	jQuery(document).ready(function(){
		//jQuery("#advancedSearch").trigger("click");
	});
</script>
<%} %>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%= navName %>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>


	<div id='DocSearchDiv' style=''>
	
<form name="frmmain" id="frmmain" method="post" action="DocCommonContent.jsp?offical=<%=offical %>&officalType=<%=officalType %>&fromadvancedmenu=<%=fromAdvancedMenu%>&selectedContent=<%=selectedContent%>&infoId=<%=infoId%>">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>"/>
<input type="hidden" id="subcompanyId" name="subcompanyId" value="<%=subcompanyId %>"/>
<% if(DocReplyUtil.isUseNewReply()) { %>
<input type="hidden" id="dspreply" name="dspreply" value="1" />
<%}%>

<% if(urlType.equals("0")){ %>
		<input type="hidden" id="operation" name="operation"/>
		<input type="hidden" id="signValus" name="signValus"/>
	<%} %>

<% if(urlType.equals("0")  &&  !"".equals(Util.null2String(request.getParameter("eid")))){ %>
    <input type="hidden" id="srcType" name="srcType" value="<%=srcType %>"/>
    <input type="hidden" id="eid" name="eid" value="<%=eid %>"/>
	<input type="hidden" id="tabid" name="tabid" value="<%=tabid %>"/>
	<input type="hidden" id="negative" name="negative" value="<%=negative %>"/>
	<input type="hidden" id="srcContent" name="srcContent" value="<%=srcContent %>"/>
	<input type="hidden" id="srcReply" name="srcReply" value="<%=srcReply %>"/>
	<input type="hidden" id="strAccess" name="strAccess" value="<%=strAccess %>"/> 
<%}%>

<% if(urlType.equals("16")){ %>
	<input type="hidden" id="srcType" name="srcType" value="<%=srcType %>"/>
	<input type="hidden" id="eid" name="eid" value="<%=eid %>"/>
	<input type="hidden" id="tabid" name="tabid" value="<%=tabid %>"/>
	<input type="hidden" id="negative" name="negative" value="<%=negative %>"/>
	<input type="hidden" id="srcContent" name="srcContent" value="<%=srcContent %>"/>
	<input type="hidden" id="srcReply" name="srcReply" value="<%=srcReply %>"/>
	<input type="hidden" id="strAccess" name="strAccess" value="<%=strAccess %>"/>
<%} %>
<input type="hidden" id="_doccreater" name="_doccreater" value=""/>
<input type="hidden" name="mouldid" value="<%=mouldid%>">
<input type="hidden" id="urlType" name="urlType" value="<%= urlType %>"/>
<%if(urlType.equals("13")||urlType.equals("14")||urlType.equals("15")||  (urlType.equals("6") && fromUrlType.equals("1"))){ %>
	<input type="hidden" id="fromUrlType" name="fromUrlType" value="1"/>
<%} %>
<%if(urlType.equals("-99")||urlType.equals("-98")){ %>
	<input type="hidden" id="offical" name="offical" value="<%=offical %>"/>
	<input type="hidden" id="officalType" name="officalType" value="<%=officalType %>"/>
<%} %>
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
<%if(urlType.equals("8") || urlType.equals("9")){ %>
	<input type="hidden" id="subscribeIds" name="subscribeIds"/>
	<input type="hidden" id="docIds" name="docIds"/>
	<input type="hidden" id="operation" name="operation"/>
<%} %>
<DIV style="display:none">
<%
boolean haveRightToDummy = true;//DocTreeDocFieldManager.getIsHaveRightToDummy(user.getUID());
if(userightmenu_self==1||true){
	//if(urlType.equals("14")||urlType.equals("13")||urlType.equals("15")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClickRight(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	//}
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onBtnSearchClick();}},";
	topButton +="'-',";
}
if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){
	if(isShow.equals("false")&&(urlType.equals("6") || urlType.equals("0"))){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+",javascript:doSubscribe(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		if(urlType.equals("6") && haveRightToDummy){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+",javascript:importSelectedToDummy(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+",javascript:importAllToDummy(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
	
	if(urlType.equals("5")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:doMuliDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	
	if(HrmUserVarify.checkUserRight("DocFileBatchDownLoad:ALL", user) && (urlType.equals("6")||urlType.equals("10"))){
	if(userightmenu_self==1||true){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("27105",user.getLanguage())+",javascript:bacthDownloadImageFile(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
		topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(27105, user.getLanguage())+"',handler:function(){bacthDownloadImageFile();}},";
		topButton +="'-',";
	}
	}
}
%>
	<button type="button" class=btnSearch accessKey=S onClick="onBtnSearchClick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>

	<%String useCustomSearch = "";%>
	<%if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){ 
		if(urlType.equals("6") && seccategory!=0){
			rs.executeSql("select useCustomSearch from DocSecCategory where id = " + seccategory);
			
			if(rs.next()){
				useCustomSearch = Util.null2String(rs.getString("useCustomSearch"));
			}
		}%>
			<%if(!"1".equals(useCustomSearch)){%>
				<input type="hidden" name="pageId" id="pageId" <%="1".equals(useCustomSearch)?"_showCol='false'":""%> value="<%=PageIdConst.getPageId(urlType)%>"/>
			<%}%>
<%} %>
<%
String columnUrl = ""; 
String gridUrl = "";
if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){
	if("shareMutiDoc".equals(from) || urlType.equals("10")){
		//columnUrl = "ext/ShareMutiDocColumnExt.jsp";
		//gridUrl = "ext/ShareMutiDocGridExt.jsp";
		columnUrl = "ext/DocSearchViewColumnExt.jsp?displayUsage="+displayUsage;
		gridUrl = "ext/DocSearchGridExt.jsp?displayUsage="+displayUsage;
		if(userightmenu_self==1||true){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:shareNext(this),_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		}else{
			topButton +="{iconCls:'btn_nextStep',text:'"+SystemEnv.getHtmlLabelName(1402, user.getLanguage())+"',handler:function(){shareNext(this);}},";
			topButton +="'-',";
		}
	}else if((urlType.equals("11") || "shareManageDoc".equals(from))&&operatelevel>1){
		columnUrl = "ext/DocSearchViewColumnExt.jsp?displayUsage="+displayUsage;
		gridUrl = "ext/DocSearchGridExt.jsp?displayUsage="+displayUsage;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31798,user.getLanguage())+",javascript:shareNextManage(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31797,user.getLanguage())+",javascript:shareEntire(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else if("docsubscribe".equals(from)) {
		columnUrl = "ext/DocSubscribeColumnExt.jsp?displayUsage="+displayUsage;
		gridUrl = "ext/DocSubscribeGridExt.jsp?displayUsage="+displayUsage;
		if(userightmenu_self==1||true){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubscribe(this)',_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(17713,user.getLanguage())+",javascript:onShowSubscribeHistory()',_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(17714,user.getLanguage())+",javascript:onApprove()',_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17715,user.getLanguage())+",javascript:onBackSubscrible()',_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		
		
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;   
		}else{
			topButton +="{iconCls:'btn_submit',text:'"+SystemEnv.getHtmlLabelName(615, user.getLanguage())+"',handler:function(){onSubscribe(this);}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_subscribeHistory',text:'"+SystemEnv.getHtmlLabelName(17713, user.getLanguage())+"',handler:function(){onShowSubscribeHistory();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_approve',text:'"+SystemEnv.getHtmlLabelName(17714, user.getLanguage())+"',handler:function(){onApprove();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_backSubscrible',text:'"+SystemEnv.getHtmlLabelName(17715, user.getLanguage())+"',handler:function(){onBackSubscrible();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_back',text:'"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+"',handler:function(){onBack();}},";
			topButton +="'-',";
		}
	}else {
		columnUrl = "ext/DocSearchViewColumnExt.jsp?displayUsage="+displayUsage;
		gridUrl = "ext/DocSearchGridExt.jsp?displayUsage="+displayUsage;
		if(displayUsage==0){
			if(urlType.equals("8")){
			    RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:onAgree(),_top} " ;
			    RCMenuHeight += RCMenuHeightStep ;
			    RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:onReject(),_top} " ;
			    RCMenuHeight += RCMenuHeightStep ;
			}
			if(urlType.equals("9")){
			    RCMenu += "{"+SystemEnv.getHtmlLabelName(18666,user.getLanguage())+",javascript:onGetBack(),_top} " ;
			    RCMenuHeight += RCMenuHeightStep ;
			}
			if((userightmenu_self == 1||true)&&!isRanking && (urlType.equals("0")||urlType.equals("6")||urlType.equals("5"))&&!offical.equals("1")){
			    RCMenu += "{"+SystemEnv.getHtmlLabelName(19119,user.getLanguage())+",javascript:miniatureDisplay(),_top} " ;
			    RCMenuHeight += RCMenuHeightStep ;
			}else{
				topButton +="{iconCls:'btn_miniatureDisplay',text:'"+SystemEnv.getHtmlLabelName(19119, user.getLanguage())+"',handler:function(){miniatureDisplay();}},";
				topButton +="'-',";
			}
	    } else {
	    	if(userightmenu_self==1||true){
		        RCMenu += "{"+SystemEnv.getHtmlLabelName(15360,user.getLanguage())+",javascript:listDisplay(),_top} " ;
		        RCMenuHeight += RCMenuHeightStep ;
	    	}else{
	    		topButton +="{iconCls:'btn_listDisplay',text:'"+SystemEnv.getHtmlLabelName(15360, user.getLanguage())+"',handler:function(){listDisplay();}},";
				topButton +="'-',";
	    	}
	    } 
		if(userightmenu_self==1||true){
			if(isNew.equals(""))
		    	isNew = DocSearchComInfo.getIsNew() ;
		    if (isNew.equals("yes")) {
		         RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:signReaded(this),_top} " ;
		         RCMenuHeight += RCMenuHeightStep ;
		    }
			if(showtype==1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19254,user.getLanguage())+",javascript:sutraView();,_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19466,user.getLanguage())+",javascript:viewbyOrganization(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		    }else if(showtype==2){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19254,user.getLanguage())+",javascript:sutraView();,_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19253,user.getLanguage())+",javascript:treeView(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		
		    }else if(showtype==3){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19254,user.getLanguage())+",javascript:sutraView();,_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19253,user.getLanguage())+",javascript:treeView(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		
				RCMenu += "{"+SystemEnv.getHtmlLabelName(19466,user.getLanguage())+",javascript:viewbyOrganization(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		}else{
			if(showtype==1){
				topButton +="{iconCls:'btn_sutra',text:'"+SystemEnv.getHtmlLabelName(19254, user.getLanguage())+"',handler:function(){sutraView();}},";
				topButton +="'-',";
				topButton +="{iconCls:'btn_organization',text:'"+SystemEnv.getHtmlLabelName(19466, user.getLanguage())+"',handler:function(){viewbyOrganization();}},";
				topButton +="'-',";
		    }else if(showtype==2){
				topButton +="{iconCls:'btn_sutra',text:'"+SystemEnv.getHtmlLabelName(19254, user.getLanguage())+"',handler:function(){sutraView();}},";
				topButton +="'-',";
				topButton +="{iconCls:'btn_treeMode',text:'"+SystemEnv.getHtmlLabelName(19253, user.getLanguage())+"',handler:function(){treeView();}},";
				topButton +="'-',";
		
		    }else if(showtype==3){
		    	topButton +="{iconCls:'btn_sutra',text:'"+SystemEnv.getHtmlLabelName(19254, user.getLanguage())+"',handler:function(){sutraView();}},";
		    	topButton +="'-',";
		    	topButton +="{iconCls:'btn_treeMode',text:'"+SystemEnv.getHtmlLabelName(19253, user.getLanguage())+"',handler:function(){treeView();}},";
		    	topButton +="'-',";
		    	topButton +="{iconCls:'btn_organization',text:'"+SystemEnv.getHtmlLabelName(19466, user.getLanguage())+"',handler:function(){viewbyOrganization();}},";
		    	topButton +="'-',";
			}
		}
		if(userightmenu_self ==1||true){
		    /*RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
	    
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;*/
		}else{
			topButton +="{iconCls:'btn_first',text:'"+SystemEnv.getHtmlLabelName(18363, user.getLanguage())+"',handler:function(){_table.firstPage();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_previous',text:'"+SystemEnv.getHtmlLabelName(1258, user.getLanguage())+"',handler:function(){_table.prePage();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_next',text:'"+SystemEnv.getHtmlLabelName(1259, user.getLanguage())+"',handler:function(){_table.nextPage();}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_end',text:'"+SystemEnv.getHtmlLabelName(18362, user.getLanguage())+"',handler:function(){_table.lastPage();}},";
			topButton +="'-',";
			if(isNew.equals(""))
				isNew = DocSearchComInfo.getIsNew() ;
		    if (isNew.equals("yes")) {
				topButton +="{iconCls:'btn_signReaded',text:'"+SystemEnv.getHtmlLabelName(18492, user.getLanguage())+"',handler:function(){signReaded(this);}},";
				topButton +="'-',";
			}
		
		}
	} %>
	<%
	if(userightmenu_self ==1||true){
		/*RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/docs/tools/DocUserDefault.jsp',_top}} " ;
		RCMenuHeight += RCMenuHeightStep ;*/
	}else{
		topButton +="{iconCls:'btn_custom',text:'"+SystemEnv.getHtmlLabelName(73, user.getLanguage())+"',handler:function(){location.href='/workflow/request/RequestUserDefault.jsp'}},";
		topButton +="'-',";
	}
	if(isSysadmin==1){
		topButton +="{iconCls:'btn_viewUrl',text:'"+SystemEnv.getHtmlLabelName(21682, user.getLanguage())+"',handler:function(){viewSourceUrl()}},";
		topButton +="'-',";
	}
	if(topButton.length()>5){
		topButton = topButton.substring(0,topButton.length()-5);
	}
	topButton = "["+topButton+"]";
}

%>
<!-- <button type="button" class=btnCustomize accessKey=C type=button onclick="location.href='/docs/tools/DocUserDefault.jsp'"><U>C</U>-<%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%></BUTTON> -->
	</div>
	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td style="<%=TDWidth%>">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<% if(urlType.equals("8")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>" class="e8_btn_top" onclick="onAgree();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" class="e8_btn_top" onclick="onReject();"/>
			<%}else if(urlType.equals("6") && haveRightToDummy){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(21826,user.getLanguage())%>" class="e8_btn_top" onclick="importSelectedToDummy()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(21827,user.getLanguage())%>" class="e8_btn_top" onclick="importAllToDummy()"/>
			<%}else if(urlType.equals("9")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18666,user.getLanguage())%>" class="e8_btn_top" onclick="onGetBack();"/>
			<%}else if(urlType.equals("12")){ %>
<%if(HrmUserVarify.checkUserRight("Docs:SetPopUp", user)){%>
				<!--<input type="button" value="<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30747,user.getLanguage())%>" class="e8_btn_top" onclick="showDetailInfo();"/>-->
<%}%>
			<%}else if(urlType.equals("10")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>" class="e8_btn_top" onclick="shareNext(this);"/>
			<%}else if(urlType.equals("13")||urlType.equals("14")||urlType.equals("15")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_top" onclick="resetCondtion();"/>
			<%}else if(urlType.equals("5")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doMuliDelete()"/>
			<%}else if(urlType.equals("0")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18492,user.getLanguage())%>" class="e8_btn_top" onclick="signReaded(this)"/>
			<%} %>
			<%if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){ %>
				<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="<%= docsubject %>" onchange="setKeyword('flowTitle','docsubject','frmmain');"/>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
	String advanceattrs = "{'samePair':'advanceCondition'"; 
	boolean hasAdvanceCondition = false;
	if(urlType.equals("13")||urlType.equals("14")||urlType.equals("15")){
		advanceattrs += ",'display':'none'";
		hasAdvanceCondition = true;
	}
	advanceattrs += "}";
%>
<% int rowNum = 0; %>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >

  
<jsp:include page="DocCommonContent_table.jsp">
	<jsp:param  name="displayUsage"          value="<%=displayUsage%>" /> 
	<jsp:param  name="seccategory"           value="<%=seccategory%>" /> 
	<jsp:param  name="userightmenu_self"     value="<%=userightmenu_self%>" /> 
	<jsp:param  name="lang"                  value="<%=user.getLanguage()%>" /> 
	<jsp:param  name="subcategory"           value="<%=subcategory%>" /> 
	<jsp:param  name="maincategory"          value="<%=maincategory%>" /> 
	<jsp:param  name="customSearchPara"      value="<%=customSearchPara%>" /> 
	<jsp:param  name="from"                  value="<%=from%>" /> 
	<jsp:param  name="showtype"              value="<%=showtype%>" /> 
	<jsp:param  name="columnUrl"             value="<%=columnUrl%>" /> 
	<jsp:param  name="urlType"               value="<%=urlType%>" /> 
	<jsp:param  name="isShow"                value="<%=isShow%>" /> 
	<jsp:param  name="offical"               value="<%=offical%>" /> 
	<jsp:param  name="isUsedCustomSearch"    value="<%=isUsedCustomSearch%>" /> 
	<jsp:param  name="gridUrl"               value="<%=gridUrl%>" /> 
	<jsp:param  name="topButton"             value="<%=topButton%>" /> 
	<jsp:param  name="useCustomSearch"       value="<%=useCustomSearch%>" /> 
	<jsp:param  name="docdetachable"         value="<%=docdetachable%>" /> 
	<jsp:param  name="isDetach"              value="<%=isDetach%>" /> 
	<jsp:param  name="fromAdvancedMenu"      value="<%=fromAdvancedMenu%>" /> 
	<jsp:param  name="infoId"                value="<%=infoId%>" /> 
	<jsp:param  name="language"              value="<%=language%>" /> 
	<jsp:param  name="mouldid"              value="<%=mouldid%>" /> 
	<jsp:param  name="docsubject"              value="<%=docsubject%>" /> 
	<jsp:param  name="searchMsg"              value="<%=searchMsg%>" />
	<jsp:param  name="currentState"              value="<%=currentState%>" /> 
    <jsp:param  name="doccreaterid"              value="<%=doccreaterid%>" /> 
	<jsp:param  name="doccreaterid2"              value="<%=doccreaterid2%>" /> 
	<jsp:param  name="isgoveproj"              value="<%=isgoveproj%>" /> 
	<jsp:param  name="usertype"              value="<%=usertype%>" /> 
	<jsp:param  name="docstatus"              value="<%=docstatus%>" /> 
	<jsp:param  name="secinput"              value="<%=secinput%>" />
	<jsp:param  name="approveDateFrom"              value="<%=approveDateFrom%>" /> 
	<jsp:param  name="approveDateTo"              value="<%=approveDateTo%>" /> 
	<jsp:param  name="doccreatedatefrom"              value="<%=doccreatedatefrom%>" /> 
	<jsp:param  name="doccreatedateto"              value="<%=doccreatedateto%>" /> 
	<jsp:param  name="departmentid"              value="<%=departmentid%>" /> 
	<jsp:param  name="docno"              value="<%=docno%>" /> 
	<jsp:param  name="creatersubcompanyid"              value="<%=creatersubcompanyid%>" /> 
	<jsp:param  name="treeDocFieldId"              value="<%=treeDocFieldId%>" /> 
	<jsp:param  name="dspreply"              value="<%=dspreply%>" /> 
	<jsp:param  name="subscribeDateFrom"              value="<%=subscribeDateFrom%>" /> 
	<jsp:param  name="subscribeDateTo"              value="<%=subscribeDateTo%>" /> 
	<jsp:param  name="date2durings"              value="<%=date2durings%>" /> 
	<jsp:param  name="date2during"              value="<%=date2during%>" /> 
	<jsp:param  name="containreply"              value="<%=containreply%>" /> 
	<jsp:param  name="ownerid"              value="<%=ownerid%>" /> 
	<jsp:param  name="ownerid2"              value="<%=ownerid2%>" /> 
	<jsp:param  name="ownerdepartmentid"              value="<%=ownerdepartmentid%>" /> 
	<jsp:param  name="ownersubcompanyid"              value="<%=ownersubcompanyid%>" /> 
	<jsp:param  name="docpublishtype"              value="<%=docpublishtype%>" /> 
	<jsp:param  name="doclastmoddatefrom"              value="<%=doclastmoddatefrom%>" /> 
	<jsp:param  name="doclastmoddateto"              value="<%=doclastmoddateto%>" /> 
	<jsp:param  name="pop_state"              value="<%=pop_state%>" /> 
	<jsp:param  name="keyword"              value="<%=keyword%>" /> 
	<jsp:param  name="replaydoccountfrom"              value="<%=replaydoccountfrom%>" /> 
	<jsp:param  name="replaydoccountto"              value="<%=replaydoccountto%>" /> 
	<jsp:param  name="contentname"              value="<%=contentname%>" /> 
	<jsp:param  name="doclangurage"              value="<%=doclangurage%>" /> 
	<jsp:param  name="advanceattrs"              value="<%=advanceattrs%>" /> 
	<jsp:param  name="doclastmoduserid"              value="<%=doclastmoduserid%>" /> 
	<jsp:param  name="isNew"              value="<%=isNew%>" /> 
	<jsp:param  name="docarchivedateto"              value="<%=docarchivedateto%>" /> 
	<jsp:param  name="docarchivedatefrom"              value="<%=docarchivedatefrom%>" /> 
	<jsp:param  name="docarchiveuserid"              value="<%=docarchiveuserid%>" /> 
	<jsp:param  name="docapprovedatefrom"              value="<%=docapprovedatefrom%>" /> 
	<jsp:param  name="docapprovedateto"              value="<%=docapprovedateto%>" /> 
	<jsp:param  name="docapproveuserid"              value="<%=docapproveuserid%>" /> 
	<jsp:param  name="crmid"              value="<%=crmid%>" /> 
	<jsp:param  name="assetid"              value="<%=assetid%>" /> 
	<jsp:param  name="projectid"              value="<%=projectid%>" /> 
	<jsp:param  name="hrmresid"              value="<%=hrmresid%>" /> 
 
</jsp:include>
<%if(hasAdvanceCondition){ %>
	<div title="<%=SystemEnv.getHtmlLabelNames("17499,15364",user.getLanguage()) %>" style="width:30px;height:30px;cursor:pointer;background-image:url(/images/docs/down_wev8.png);background-repeat:no-repeat;background-position:50% 50%;float:right;" onclick="showEle('advanceCondition');showItemArea('#threeGroupTable');jQuery(this).hide();updateSearchDivHeight();">
	</div>
<%} %>
<div id='advicedSearchDiv' >

<div id='customSearchDiv'></div>
</div>

</div>
<%--开始显示自定义搜索条件--%>

<%--结束显示自定义搜索条件--%>


</form>
	</div>
<div id ='divContent' style='' ><div id='_xTable' style='background:#FFFFFF;width:100%' valign='top'> </div>
 </div>

<div style="display:none;">
	<brow:browser name="otherDocId" browserBtnID="otherDocId_btn" viewType="0" isMustInput="1" _callback="afterShowMDocidForOwner" getBrowserUrlFn="getBrowserUrl"></brow:browser>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="DocCommonContent_js.jsp">
	<jsp:param  name="displayUsage"          value="<%=displayUsage%>" /> 
	<jsp:param  name="seccategory"           value="<%=seccategory%>" /> 
	<jsp:param  name="userightmenu_self"     value="<%=userightmenu_self%>" /> 
	<jsp:param  name="lang"                  value="<%=user.getLanguage()%>" /> 
	<jsp:param  name="subcategory"           value="<%=subcategory%>" /> 
	<jsp:param  name="maincategory"          value="<%=maincategory%>" /> 
	<jsp:param  name="customSearchPara"      value="<%=customSearchPara%>" /> 
	<jsp:param  name="from"                  value="<%=from%>" /> 
	<jsp:param  name="showtype"              value="<%=showtype%>" /> 
	<jsp:param  name="columnUrl"             value="<%=columnUrl%>" /> 
	<jsp:param  name="urlType"               value="<%=urlType%>" /> 
	<jsp:param  name="userid"               value="<%=userid%>" /> 
	<jsp:param  name="isShow"                value="<%=isShow%>" /> 
	<jsp:param  name="offical"               value="<%=offical%>" /> 
	<jsp:param  name="isUsedCustomSearch"    value="<%=isUsedCustomSearch%>" /> 
	<jsp:param  name="gridUrl"               value="<%=gridUrl%>" /> 
	<jsp:param  name="topButton"             value="<%=topButton%>" /> 
	<jsp:param  name="useCustomSearch"       value="<%=useCustomSearch%>" /> 
	<jsp:param  name="docdetachable"         value="<%=docdetachable%>" /> 
	<jsp:param  name="isDetach"              value="<%=isDetach%>" /> 
	<jsp:param  name="fromAdvancedMenu"      value="<%=fromAdvancedMenu%>" /> 
	<jsp:param  name="infoId"                value="<%=infoId%>" /> 
	<jsp:param  name="selectedContent"       value="<%=selectedContent%>" />
	<jsp:param  name="language"              value="<%=language%>" /> 
	
	
</jsp:include>


<!-- Ext搜索结果显示列信息定义  -->




<%if(!urlType.equals("13")&&!urlType.equals("14") && !urlType.equals("15")){ %>
	<%if("shareMutiDoc".equals(from)) {%>
	<%@ include file="ext/ShareMutiDocExt.jsp"%>
	
	<%}else if("docsubscribe".equals(from)) {
	%>	
	<%@ include file="ext/DocSubsribeExt.jsp"%>
	<% }else{
	%>
	<%@ include file="ext/DocSearchViewExt.jsp"%>
	<%	
	}
}
	%>



</html>
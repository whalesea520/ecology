
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
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
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

if(!HrmUserVarify.checkUserRightSystemadmin("DocShareRight:all", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String from = Util.null2String(request.getParameter("from"));
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
<script language=javascript src="/js/weaver_wev8.js"></script>

</head>
<%





Enumeration em = request.getParameterNames();
boolean isinit = true;

isinit = Util.null2String(request.getParameter("isinit")).equals("false")?false:true;
/* while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("date2during"))
	{
		out.println(paramName);
		isinit = false;
		break;
	}
} */

//需要保留从快速搜索过来的文档标题信息
String temSubjuect = DocSearchComInfo.getDocsubject();
DocSearchComInfo.resetSearchInfo();
if(!isinit){
	DocSearchComInfo.setDocsubject(temSubjuect);
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid =user.getUID();
int advanced=Util.getIntValue(request.getParameter("advanced"),0);
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
boolean isUsedCustomSearch = "true".equals(Util.null2String(request.getParameter("isUsedCustomSearch")))?true:false;
//Docsubscribe add


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";


String docsubject = "" ;
String doccontent = "" ;
String containreply = "" ;
int maincategoryid= 0 ;
int subcategoryid= 0 ;
int seccategoryid= 0 ;
int maincategory= 0 ;
int subcategory= 0 ;
int seccategory= 0 ;
int docid= 0 ;
int departmentid= 0 ;
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

date2during=Util.getIntValue(request.getParameter("date2during"),0);

if(mouldid==0){
	if(request.getParameter("docsubject")!=null){
		
    	docsubject = Util.toScreenToEdit(request.getParameter("docsubject"),user.getLanguage());
	}else{
		docsubject = DocSearchComInfo.getDocsubject();
	}
    doccontent = Util.toScreenToEdit(request.getParameter("doccontent"),user.getLanguage());
    containreply = Util.toScreenToEdit(request.getParameter("containreply"),user.getLanguage());
    maincategory= Util.getIntValue(request.getParameter("maincategory"),0);
    subcategory= Util.getIntValue(request.getParameter("subcategory"),0);
    seccategory= Util.getIntValue(request.getParameter("seccategory"),0);
    docid= Util.getIntValue(request.getParameter("docid"),0);
    departmentid= Util.getIntValue(request.getParameter("departmentid"),0);
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
if(date2during==0)
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

<%@ include file="/docs/docs/DocCommExt.jsp"%>
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
	<div id='DocSearchDiv' style=''>
	
<form name="frmmain" method="post" action="DocSearchSharing.jsp">
<input type="hidden" name="mouldid" value="<%=mouldid%>">
<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
<input type="hidden" name = "customSearchPara">
<input type="hidden" name="opera">
<input type="hidden" name="from" value="<%=from%>">
<input type="hidden" name="showtype" value="<%=showtype%>">
<input type="hidden" name="self"  value="false">
<input type="hidden" name="isUsedCustomSearch"  value="<%=isUsedCustomSearch%>">
<input type="hidden" name="seccategoryid"  value="<%=seccategoryid%>">
<input type="hidden" id="isinit" name="isinit" value="<%=isinit%>">
<DIV style="display:none">
<%
if(userightmenu_self==1||true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onBtnSearchClick();}},";
	topButton +="'-',";
}


if(userightmenu_self==1||true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(31797,user.getLanguage())+",javascript:shareEntire(this),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(31797, user.getLanguage())+"',handler:function(){shareEntire(this);}},";
	topButton +="'-',";
}

%>
	<button type="button" class=btnSearch accessKey=S onClick="onBtnSearchClick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>

	

		<!--input type="hidden" name="advanced" value="<%=advanced%>"-->
		

<%
String columnUrl = ""; 
String gridUrl = "";

if("shareManageDoc".equals(from)){

	columnUrl = "ext/ShareManageDocColumnExt.jsp";
	gridUrl = "ext/ShareManageDocGridExt.jsp";
	if(userightmenu_self==1||true){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31798,user.getLanguage())+",javascript:shareNext(this),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}else{
		topButton +="{iconCls:'btn_nextStep',text:'"+SystemEnv.getHtmlLabelName(31798, user.getLanguage())+"',handler:function(){shareNext(this);}},";
		topButton +="'-',";
	}

}else if("shareMutiDoc".equals(from)){
	columnUrl = "ext/ShareMutiDocColumnExt.jsp";
	gridUrl = "ext/ShareMutiDocGridExt.jsp";
	if(userightmenu_self==1||true){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:shareNext(this),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}else{
		topButton +="{iconCls:'btn_nextStep',text:'"+SystemEnv.getHtmlLabelName(1402, user.getLanguage())+"',handler:function(){shareNext(this);}},";
		topButton +="'-',";
	}
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
		if(userightmenu_self == 1||true){
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
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
    
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    String isNew = DocSearchComInfo.getIsNew() ;
	    if (isNew.equals("yes")) {
	         RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:signReaded(),_top} " ;
	         RCMenuHeight += RCMenuHeightStep ;
	    }
	}else{
		topButton +="{iconCls:'btn_first',text:'"+SystemEnv.getHtmlLabelName(18363, user.getLanguage())+"',handler:function(){_table.firstPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_previous',text:'"+SystemEnv.getHtmlLabelName(1258, user.getLanguage())+"',handler:function(){_table.prePage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_next',text:'"+SystemEnv.getHtmlLabelName(1259, user.getLanguage())+"',handler:function(){_table.nextPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_end',text:'"+SystemEnv.getHtmlLabelName(18362, user.getLanguage())+"',handler:function(){_table.lastPage();}},";
		topButton +="'-',";
		String isNew = DocSearchComInfo.getIsNew() ;
	    if (isNew.equals("yes")) {
			topButton +="{iconCls:'btn_signReaded',text:'"+SystemEnv.getHtmlLabelName(18492, user.getLanguage())+"',handler:function(){signReaded();}},";
			topButton +="'-',";
		}
	
	}
} %>
<%
if(userightmenu_self ==1||true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/docs/tools/DocUserDefault.jsp',_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
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


%>
<button type="button" class=btnCustomize accessKey=C type=button onclick="location.href='/docs/tools/DocUserDefault.jsp'"><U>C</U>-<%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%></BUTTON>
	</div>
	

  <table class=ViewForm  cellspacing="0" cellpadding="0">
                <colgroup> <col width="49%"> 
				
				<col width=10> 
				
				<col width="49%">
                <tbody>
                <tr>
                  <td valign=top style="width: 50%">
                    <table  class=ViewForm style="margin-left:5px;" >
                      <colgroup> <col width="30%"> <col width="70%"> <tbody>
                 
                  <%if(mouldid==0||!(docno.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle  type="text" name="docno" value="<%=docno%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0||!(keyword.equals(""))){%>
                      <tr>
                        <td height=32><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></td>
                        <td class="field">
                          <input class=InputStyle  type="text" name="keyword" <%if(!(keyword.equals(""))){%>value="<%=keyword%>"<%}%>>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>

					  <%if(mouldid==0||!(contentname.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle  type="text" name="contentname" <%if(!(contentname.equals(""))){%>value="<%=contentname%>"<%}%>>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>

                      </tbody>
                      </table>
					  </td>
					  <td></td>
                       <td valign=top style="width: 50%">
                    <table  class=ViewForm style="margin-left:5px;"  >
                      <colgroup> <col width="30%"> <col width="70%"> <tbody>
    
                     <%if(mouldid==0||!(docsubject.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
                        <td class="field"  >
                          <input class=InputStyle type="text"  name="docsubject" value="<%=docsubject%>">
                           <SPAN id=remind style='cursor:hand'>
								<IMG src='/images/remind_wev8.png' align=absMiddle>
						  </SPAN>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(date2duringTokens.length>0){ %>
                      <tr>
                        <td class="lable"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
					    <td class="field">
					     <select class=inputstyle  size=1 id=date2during name=date2during style=width:40%>
					     	<option value="">&nbsp;</option>
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
					     	<!-- 全部 -->
  							<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					     </select>
					    </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%} %>
                      <%if(mouldid==0||doccreaterid!=0||doccreaterid2!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
                        <td class="field"  >
						<%if(!user.getLogintype().equals("2")){%>
						    <%if(mouldid==0||doccreaterid != 0){%>
						<%if(isgoveproj==0){%>
						  <%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:<button type="button" class=Browser onClick="onShowResource('doccreateridspan','doccreaterid')"></button>
                          
						  <%}else{%>
						  <%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%>:<button type="button" class=Browser onClick="onShowResource('doccreateridspan','doccreaterid')"></button>
						  <%}%>
						  <span id=doccreateridspan>

                          <%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>

                          </span>
    					  <%}%>
                          <input type="hidden" name="doccreaterid" value="<%=doccreaterid%>">
						  <%}%>
						  <%if(isgoveproj==0){%>
						  <br>
    					<%if(mouldid==0||doccreaterid2 != 0){%>
                          <%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:<button type="button" class=Browser id=SelectDeparment onClick="onShowParent('doccreaterid2span2','doccreaterid2')"></button>
                          <span id=doccreaterid2span2>

                          <%=Util.toScreen(CustomerInfo.getCustomerInfoname(doccreaterid2+""),user.getLanguage())%>

                          </span>
						  <%}%>
						  <%}%>
                          <input type="hidden" name="doccreaterid2" value="<%=doccreaterid2%>">
						  <input type="hidden" name="usertype" value="<%=usertype%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					   
		</tbody>
		</table></td></tr>
		<tr>
          <td></td>
          <td colspan='2' align ='right'>
            <a id="searchAdviceHref"  href="#" onClick="showSearchAdvice(this)"><img name="searchAdviceImg" src="/images/down_wev8.png" align=absMiddle> <%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%> </a>
          </td>
        </tr>
<!--		<tr>
			<td colspan='2' align ='right'>
	
				<a id="searchAdviceHref"  href="#" onClick="showSearchAdvice(this)"><img name="searchAdviceImg" src="/images/down_wev8.png" align=absMiddle> <%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%> </a>
 
			</td>
			
		</tr> -->
</tbody></table>
                      

<div id='advicedSearchDiv' style='display:none'>


<table class=ViewForm cellspacing="0" cellpadding="0" style="margin-top:-3px;">
  <tr>
    <td width="80%">
	
	<DIV>
		<input type="hidden" name="advanced" value="<%=advanced%>">
	</div>

              <table class=ViewForm>
                <colgroup> <col width="49%"> <col width=10> <col width="49%">
                <tbody>
                <tr>
                  <td valign=top style="width: 50%">
                    <table width="100%">
                      <colgroup> <col width="30%"> <col width="70%"> <tbody>
                 
                     <!--   <%if(mouldid==0||!(docno.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle  type="text" name="docno" value="<%=docno%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0||!(keyword.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle  type="text" name="keyword" <%if(!(keyword.equals(""))){%>value="<%=keyword%>"<%}%>>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      -->
                        
<%if(!user.getLogintype().equals("2")){%>
    <%if(mouldid==0||ownerid != 0){%>  
    <tr>
     <td><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></td>
                        <td class="field"  >
						<%if(isgoveproj==0){%>
						  <%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:<button type="button" class=Browser onClick="onShowResource('ownerspan','ownerid')"></button>
                          <%}else{%>
						  <%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%>:<button type="button" class=Browser onClick="onShowResource('ownerspan','ownerid')"></button>
						  <%}%>
						  <span id=ownerspan>

                          <%=Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage())%>

                          </span>
                            <input type="hidden" name="ownerid" value="<%=ownerid%>">
    <%}%>
                        
<%}%>
<%if(isgoveproj==0){%>
    <%if(mouldid==0||ownerid2 != 0){%>
						  <br><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:<button type="button" class=Browser id=SelectDeparment onClick="onShowParent('owner2span2','ownerid2')"></button>
						  <span id=owner2span2>

                          <%=Util.toScreen(CustomerInfo.getCustomerInfoname(ownerid2+""),user.getLanguage())%>

                          </span>
                           <input type="hidden" name="ownerid2" value="<%=ownerid2%>">
    <%}%>
	<%}%>
                         
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>

<%if(!user.getLogintype().equals("2")){%>
                      <%if(mouldid==0|| doclastmoduserid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(3002,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowResource('doclastmoduseridspan','doclastmoduserid')"></button>
                          <span id=doclastmoduseridspan>
                          <%if(doclastmoduserid!=0){%>
                          <%=Util.toScreen(ResourceComInfo.getResourcename(doclastmoduserid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="doclastmoduserid" value="<%=doclastmoduserid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
<%}%>

                      <%if(mouldid==0|| !doclastmoddatefrom.equals("") || !doclastmoddateto.equals("")){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></td>
                        <td align=left class="field"><button type="button" class=calendar id=SelectDate onClick="getDate(doclastmoddatefromspan,doclastmoddatefrom)"></button>&nbsp;
                          <span id=doclastmoddatefromspan ><%=doclastmoddatefrom%></span>
                          -&nbsp;&nbsp;<button type="button" class=calendar
			  id=SelectDate2 onClick="getDate(doclastmoddatetospan,doclastmoddateto)"></button>&nbsp;
                          <span id=doclastmoddatetospan><%=doclastmoddateto%></span>
                          <input type="hidden" name="doclastmoddatefrom" value="<%=doclastmoddatefrom%>">
                          <input type="hidden" name="doclastmoddateto" value="<%=doclastmoddateto%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0|| !docarchivedatefrom.equals("") || !docarchivedateto.equals("")){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></td>
                        <td align=left class="field"><button type="button" class=calendar id=SelectDate onClick="getDate(docarchivedatefromspan,docarchivedatefrom)"></button>&nbsp;
                          <span id=docarchivedatefromspan ><%=docarchivedatefrom%></span>
                          -&nbsp;&nbsp;<button type="button" class=calendar
			  id=SelectDate2 onClick="getDate(docarchivedatetospan,docarchivedateto)"></button>&nbsp;
                          <span id=docarchivedatetospan><%=docarchivedateto%></span>
                          <input type="hidden" name="docarchivedatefrom" value="<%=docarchivedatefrom%>">
                          <input type="hidden" name="docarchivedateto" value="<%=docarchivedateto%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                               <%if(mouldid==0 || !replaydoccountfrom.equals("") || !replaydoccountto.equals("") ){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(2001,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle type="text"  name="replaydoccountfrom" value="<%=replaydoccountfrom%>" size=8>
                          -
                          <input class=InputStyle type="text"  name="replaydoccountto" value="<%=replaydoccountto%>" size=9>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0||maincategory!=0||subcategory!=0||seccategory!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></td>
                        <td  class="field"  >
                          <select class=InputStyle id="maincategory"  name="maincategory"  onChange="mainSelect()">
                            <option value="0"></option>   
                          </select>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      
                      
                      <%if(mouldid==0||!(docstatus.equals(""))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
                        <td class="field"  >
                          <select class=InputStyle id="docstatus" name="docstatus" style="width:148">
                            <option value="">&nbsp;</option>
                            <option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
                            <option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
                            <option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
                          </select>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                    
					  <%if(mouldid==0||(containreply.equals("1"))){%>
                      <tr>
                       <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TD>
                         <TD CLASS="Field">
                            <SELECT  class=InputStyle id="dspreply" name=dspreply style="width:148">
                              <option value="0" selected>&nbsp;</option>
                              <option value="1" ><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
                              <option value="2"><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
                            </SELECT>                          
                         </TD> 
                       </tr>
					  <TR style="height:1px;">
					  
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
               
                      <%if(!user.getLogintype().equals("2")){%>
                      <%if(mouldid==0|| docarchiveuserid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(3003,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowResource('docarchiveuseridspan','docarchiveuserid')"></button>
                          <span id=docarchiveuseridspan>
                          <%if(docarchiveuserid!=0){%>
                          <%=Util.toScreen(ResourceComInfo.getResourcename(docarchiveuserid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="docarchiveuserid" value="<%=docarchiveuserid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
<%}%>
						 <%if(mouldid==0||doclangurage!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowLanguage()"></button>
                          <span id=languagespan>
                          <%if(doclangurage!=0){%>
                          <%=Util.toScreen(LanguageComInfo.getLanguagename(doclangurage+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="doclangurage" value="<%=doclangurage%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					  <%if(isgoveproj==0){%>
                      <%if(mouldid==0||crmid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowCustomer('crmspan','crmid')"></button>
                          <span id=crmspan>
                          <%if(crmid!=0){%>
                          <%=Util.toScreen(CustomerInfo.getCustomerInfoname(crmid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="crmid" value="<%=crmid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					  <%}%>
                      <%if(mouldid==0||assetid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowCpt('assetidspan','assetid')"></button>
                          <span id=assetidspan>
                          <%if(assetid!=0){%>
                          <%=Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="assetid" value="<%=assetid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      </tbody>
                    </table>
                  </td>
                  <td valign=top style="width: 50%">
                    <table width="100%">
                      <colgroup> <col width="30%"> <col width="70%"> <tbody> 
                     
                      <%if(!user.getLogintype().equals("2")){%>
                      <%if(mouldid==0||departmentid!=0){%>
                      <tr>
                        <td height=22><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
                        <td class="field"  height=32><button type="button" class=Browser onClick="onShowDept('deptname','departmentid')"></button>
                          <span id=deptname>
                          <%if(departmentid!=0){%>
                          <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="departmentid" value="<%=departmentid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%}%>                     
<%if(!user.getLogintype().equals("2")){%>
                      <%if(mouldid==0||docapproveuserid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(3001,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowResource('docapproveuseridspan','docapproveuserid')"></button>
                          <span id=docapproveuseridspan>
                          <%if(docapproveuserid!=0){%>
                          <%=Util.toScreen(ResourceComInfo.getResourcename(docapproveuserid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="docapproveuserid" value="<%=docapproveuserid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
<%}%>
                      <%if(mouldid==0|| !doccreatedatefrom.equals("") || !doccreatedateto.equals("")){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
                        <td align=left class="field"><button type="button" class=calendar id=SelectDate onClick="getDate(doccreatedatefromspan,doccreatedatefrom)"></button>&nbsp;
                          <span id=doccreatedatefromspan ><%=doccreatedatefrom%></span>
                          -&nbsp;&nbsp;<button type="button" class=calendar
			  id=SelectDate2 onClick="getDate(doccreatedatetospan,doccreatedateto)"></button>&nbsp;
                          <span id=doccreatedatetospan><%=doccreatedateto%></span>
                          <input type="hidden" name="doccreatedatefrom" value="<%=doccreatedatefrom%>">
                          <input type="hidden" name="doccreatedateto" value="<%=doccreatedateto%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0|| !docapprovedatefrom.equals("") || !docapprovedateto.equals("")){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%><input type="hidden" name="docapprovedatefrom" value="<%=docapprovedatefrom%>"><input type="hidden" name="docapprovedateto" value="<%=docapprovedateto%>"></td>
                        <td align=left class="field"><button type="button" class=calendar id=SelectDate onClick="getDate(docapprovedatefromspan,docapprovedatefrom)"></button>&nbsp;
                          <span id=docapprovedatefromspan><%=docapprovedatefrom%></span>
                          -&nbsp;&nbsp;<button type="button" class=calendar
			  id=SelectDate2 onClick="getDate(docapprovedatetospan,docapprovedateto)"></button>&nbsp;
                          <span id=docapprovedatetospan " ><%=docapprovedateto%></span>

                          <input type="hidden" name="docapprovedatetonouse" value="<%=docapprovedateto%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0 || !accessorycountfrom.equals("") || !accessorycountto.equals("") ){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(2002,user.getLanguage())%></td>
                        <td class="field" >
                          <input class=InputStyle type="text"  name="accessorycountfrom" value="<%=accessorycountfrom%>" size=8>
                          -
                          <input class=InputStyle type="text"  name="accessorycountto" value="<%=accessorycountto%>" size=9>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      
                      
                      
                   <%if(mouldid==0 || subcategory!=0||seccategory!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></td>
                        <td class="field" >
                          <select name="subcategory" id="subcategory" class=InputStyle  style="width:90%" onChange="subSelect()">
                           
                           
                          </select>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      
                      
                      
                      <%if(mouldid==0 ||seccategory!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
                        <td class="field">
                          <select class=InputStyle id="seccategory" name="seccategory" onChange="secSelect()">
                            <option value="0"></option>
                            
                          </select>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      
                      <%if(mouldid==0||!(docpublishtype.equals("0"))){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></td>
                        <td class="field"  >
                          <select class=InputStyle  id="docpublishtype" size="1" name="docpublishtype" style="width:148">
                            <option value="0">&nbsp;</option>
                            <option value="1" <%if (docpublishtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
                            <option value="2" <%if (docpublishtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
                            <option value="3" <%if (docpublishtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
                          </select>
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					  <%if(mouldid==0||treeDocFieldId!=""){%>
                      <tr>
                        <td ><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowMutiDummy1('treeDocFieldId','spanDummycata')"></button>
                          <span id=spanDummycata>
							  <%if(treeDocFieldId!=""){%>
								 <%=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId)%>
							  <%}%>
                          </span>
                          <input type="hidden" name="treeDocFieldId" id="treeDocFieldId" value="<%=treeDocFieldId%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(mouldid==0||itemmaincategoryid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowItemCategory('itemcategoryspan','itemmaincategoryid')"></button>
                          <span id=itemcategoryspan>
                          <%if(itemmaincategoryid!=0){%>
                          <%=Util.toScreen(AssetAssortmentComInfo.getAssortmentName(itemmaincategoryid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="itemmaincategoryid" value="<%=itemmaincategoryid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>


                      <%if(mouldid==0||hrmresid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowResource('resourcespan','hrmresid')"></button>
                          <span id=resourcespan>
                          <%if(hrmresid!=0){%>
                          <%=Util.toScreen(ResourceComInfo.getResourcename(hrmresid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="hrmresid" value="<%=hrmresid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					  <%if(isgoveproj==0){%>
                      <%if(mouldid==0||projectid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowProject('projectspan','projectid')"></button>
                          <span id=projectspan>
                          <%if(projectid!=0){%>
                          <%=Util.toScreen(ProjectInfo.getProjectInfoname(projectid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="projectid" value="<%=projectid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%}%>
                      </tbody>
                    </table>                  
                  </td>
                </tr>
               
                <tr>
                  <td valign=top>
                    <table width="100%">
                      <colgroup> <col width=30%> <col width=70%> <tbody>
                                   
                     


                      </tbody>
                    </table>
                  </td>
                  <td valign=top>
                    <table width="100%">
                      <colgroup> <col width="30%"> <col width="70%"> <tbody>
           
                      
                      <%--
                      <%if(mouldid==0||itemid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser onClick="onShowItem('itemspan','itemid')"></button>
                          <span id=itemspan>
                          <%if(itemid!=0){%>
                          <%=Util.toScreen(AssetComInfo.getAssetName(itemid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="itemid" value="<%=itemid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
                      <%if(isgoveproj==0){%>
                      <%if(mouldid==0||financeid!=0){%>
                      <tr>
                        <td><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></td>
                        <td class="field"  ><button type="button" class=Browser></button>
                          <%if(financeid!=0){%>
                          <%=financeid%>
                          <%}%>
                          <input type="hidden" name="financeid" value="<%=financeid%>">
                        </td>
                      </tr>
					  <TR style="height:1px;">
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}%>
					  <%}%>
                      --%>
                      
                      </tbody>
                    </table>
                  </td>
                </tr>
               
                </tbody>
              </table>
            </td>
        </tr>      
      </table>  

    </td>
  </tr>


<div id='customSearchDiv'></div>

</div>
<%--开始显示自定义搜索条件--%>

<%--结束显示自定义搜索条件--%>


</form>
	</div>
<div id ='divContent' style='' ><div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'> </div>
 </div>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<!-- Ext搜索结果显示列信息定义  -->






<script type='text/javascript' src='/js/WeaverTablePlugins_wev8.js'></script>
<script type="text/javascript">
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
	
	
	 try{
        if(document.all("ownerid2").value+"" != "0"){
            //document.all("ownerid").value = document.all("ownerid2").value;
        }

        if(document.all("doccreaterid2").value+"" != "0"){
            //document.all("doccreaterid").value = document.all("doccreaterid2").value;
        }
    }catch(e){}
    
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

		if(docSearchForm.elements[i].name=='maincategory' && maincategoryid!='0'){
			searchPara+='&maincategory='+maincategoryid;
		}
		else if(docSearchForm.elements[i].name=='subcategory'&&subcategoryid!='0'){
			searchPara+='&subcategory='+subcategoryid;
		}
		else if(docSearchForm.elements[i].name=='seccategory'&&seccategoryid!='0'){
			searchPara+='&seccategory='+seccategoryid;
		}else if(docSearchForm.elements[i].name!= ''){

			if(docSearchForm.elements[i].value!=''){

				if(docSearchForm.elements[i].name=='docsubject'){
					searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
				}else{
					searchPara+='&'+docSearchForm.elements[i].name+'='+docSearchForm.elements[i].value;
				}
			}
		}
	}
	
	searchPara='sessionId='+sessionId+'&list=all&from=<%=from%>&showtype=<%=showtype%>'+searchPara;

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
		//if(displayUsage==1){

		if(customSearchPara==''){
			url =url+'&'+getSearchPara();
		}else{
			url =url+'&'+customSearchPara;
		}
		//}


		//alert(url)

		//alert("colinfo:"+colInfo);
	
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
	    	//colInfo.subString(colInfo.indexOf("^^"))
		} else {
		} 	    
		
		
	
		/*Ext.Ajax.request({
		   url: url,
		   success: function(result, request){				
				colInfo=result.responseText.trim();
				alert(colInfo)
		   },
		   failure: function(result, request){
			   alert(result.responseText.trim());
		   },	 		  
		});*/

		
		
		/*var conn = Ext.lib.Ajax.getConnectionObject().conn;
		conn.open("post", url,false);
		conn.send(null);
		if (conn.status == "200") {
  			colInfo=conn.responseText.trim();
		} else {
		} */
		
		
		
}
</script>

<script type="text/javascript">
	
	getGridInfo();	
	//if(displayUsage==0){
		//alert(colInfo)
		//document.write(colInfo);
	//}
</script>
<%
if(displayUsage==1||true){
	%>
	<script language='javascript' type='text/javascript' src='/js/xmlextras_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/xmlextras_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/weaverTable_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/ArrayList_wev8.js'></script>
	<script type="text/javascript">
		
		 eval(colInfo);
		 var _xtable_checkedList = new ArrayList();
	     var _xtalbe_checkedValueList = new ArrayList();
	     var _xtalbe_radiocheckId =""; 
	     var _xtalbe_radiocheckValue = "";
	     var _table;
	</script>
	<SCRIPT FOR=window EVENT=onload LANGUAGE='JavaScript'>
		var isShowThumbnail = "";
		if(displayUsage==1){
			isShowThumbnail="1";
		}
     _table = new weaverTable('/weaver/weaver.common.util.taglib.SplitPageXmlServlet',0, '',
     sessionId,
	 'run',
	 '',
	 tableInfo,
	 '',
	 '',
	 '',
	 isShowThumbnail,
	 '5',
	 '',
	 '');
	 var showTableDiv  = document.getElementById('_xTable');
     showTableDiv.appendChild(_table.create());
     //提示窗口
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message"; 
     showTableDiv.appendChild(message_table_Div); 
     var message_table_Div  = document.getElementById("message_table_Div"); 
     message_table_Div.style.display=""; 
     /*if (readCookie("languageidweaver")==8){        
     	message_table_Div.innerHTML="Executing...."; 
     } else {        
		message_table_Div.innerHTML="服务器正在处理,请稍等...."; 
     } */
	 message_table_Div.innerHTML = SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver"));
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;   
     var pLeft= document.body.offsetWidth/2-50;   
     message_table_Div.style.position="absolute"
     message_table_Div.style.posTop=pTop;
     message_table_Div.style.posLeft=pLeft; 
	</script>
	<%
} %>

<script type="text/javascript">
 function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
	     $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	     $GetEle("usertype").value="1";
	     $GetEle("owner2span2").innerHTML="";
	     $GetEle("ownerid2").value="";
	     $GetEle("doccreaterid2span2").innerHTML="";
	     $GetEle("doccreaterid2").value="";
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     $GetEle(inputename).value="";
	     $GetEle("usertype").value="";
	  }
	}
}

function onShowParent(tdname,inputename){
   var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
   if((results)){
      if(wuiUtil.getJsonValueByIndex(results,0)!=""){
       jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
       $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
       $GetEle("usertype").value="2";
       
       $GetEle("ownerspan").innerHTML="";
	   $GetEle("ownerid").value="";
	   
	   $GetEle("doccreateridspan").innerHTML="";
	   $GetEle("doccreaterid").value="";
	  }else{
	   jQuery($GetEle(tdname)).html("");
	   $GetEle(inputename).value="";
	   $GetEle("usertype").value="";
	  }
   }
}

function onShowDept(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle("departmentid").value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowLanguage(){
	var results = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle("languagespan")).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle("doclangurage").value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle("languagespan")).html("");
         $GetEle("doclangurage").value="";
	  }
	}
}

function onShowItemCategory(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCustomer(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCpt(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowProject(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowMutiDummy1(input,span){	
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+$GetEle(input).value);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     var dummyidArray=wuiUtil.getJsonValueByIndex(results,0).split(",");
	     var dummynames=wuiUtil.getJsonValueByIndex(results,1).split(",");
	     var sHtml="";
	     for(var i=0;i<dummyidArray.length;i++){
	        if(dummyidArray[i]!=""){
	           sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[i]+"'>"+dummynames[i]+"</a>&nbsp";
	        }
	     }
	   
	     jQuery($GetEle(span)).html(sHtml);
         $GetEle(input).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(span)).html("");
         $GetEle(input).value="";
	  }
	
	}
}
function onShowBrowser1(id,url,type1){
	if(type1==1){
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		$GetEle("con"+id+"_valuespan").innerHTML=id1;
    	$GetEle("con"+id+"_value").value=id1;
     }else if(type1==2){
    	id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
 		$GetEle("con"+id+"_value1span").innerHTML=id1;
     	$GetEle("con"+id+"_value1").value=id1;
     }
}
function onShowBrowser(id,url){
	datas = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
            }
        	$GetEle("con"+id+"_valuespan").innerHTML=shtml;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}


function onShowBrowserCommon(id,url,type1){

		if(type1==162){
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));

		}
		id1 = window.showModalDialog(url);

		if(id1){

				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						shtml = ""
						ids = ids.substr(1);
						$GetEle("con"+id+"_value").value=ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							shtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;

						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						$GetEle("con"+id+"_value").value=ids;
						shtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;
						return ;
				   }


				}else{
						$GetEle("con"+id+"_valuespan").innerHTML="";
						$GetEle("con"+id+"_value").value="";
						$GetEle("con"+id+"_name").value="";
				}

			}

}

</script>

<script language=vbs>
sub onShowDept1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
            document.all(tdname).innerHTML = id(1)
            document.all(inputename).value=id(0)
            document.all("usertype").value="1"

            document.all("owner2span2").innerHTML = ""
            document.all("ownerid2").value = "0"

            document.all("doccreaterid2span2").innerHTML = ""
            document.all("doccreaterid2").value = "0"
		else
            document.all(tdname).innerHTML = empty
            document.all(inputename).value=""
            document.all("usertype").value=""
		end if
	end if
end sub

sub onShowParent1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            document.all(tdname).innerHTML = id(1)
            document.all(inputename).value=id(0)
            document.all("usertype").value="2"

            document.all("ownerspan").innerHTML = ""
            document.all("ownerid").value = ""

            document.all("doccreateridspan").innerHTML = ""
            document.all("doccreaterid").value = ""

        else
            document.all(tdname).innerHTML = empty
            document.all(inputename).value=""
            document.all("usertype").value=""
        end if
	end if
end sub

sub onShowLanguage1()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if not isempty(id) then
		if id(0)<>0 then
		languagespan.innerHTML = id(1)
		frmmain.doclangurage.value=id(0)
		else
		languagespan.innerHTML = ""
		frmmain.doclangurage.value=""
		end if
	end if
end sub

sub onShowCustomer1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowProject1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowItem(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowItemCategory1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub
sub onShowCpt1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub


sub onShowTreeDocField(spanName,inputeName)
    treeDocFieldId=document.frmMain.treeDocFieldId.value
    url=encode("/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId="+treeDocFieldId)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)

	if NOT isempty(id) then
	    if id(0)<> 0 then
            document.all(spanName).innerHTML = id(1)
		    document.all(inputeName).value=id(0)
		else
		    document.all(spanName).innerHTML = empty
		    document.all(inputeName).value="0"
		end if
	end if
end sub


sub onShowMutiDummy2(input,span)	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	if NOT isempty(id) then
	    if id(0)<> "" then	
			dummyidArray=Split(id(0),",")
			dummynames=Split(id(1),",")
			dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

			For k = 0 To dummyLen
				sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
			Next

			input.value=id(0)
			span.innerHTML=sHtml
		else			
			input.value=""
			span.innerHTML=""
		end if
	end if
end sub


</script>

<script language=javascript>
var isNeedSubmit = false;
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
	if(isNeedSubmit){
		document.frmmain.submit();
	}
	var isinit = document.getElementById("isinit").value;
	if(displayUsage==0&&false){
		//if(isinit=="false")
		loadGrid(getSearchPara(),gridUrl);
	}else{
		$GetEle("customSearchPara").value = getSearchPara();
		docSearchForm.submit();
	}
		

}	

function onBtnSearchClick(){
    $GetEle("self").value='true';
	//document.getElementById("self").value='true'
		search();
		try
		{
			var isinit = document.getElementById("isinit").value;
			if(isinit=="true")
			{
				//var wfsearchtab = Ext.getCmp('docsearchtab');
				//wfsearchtab.show();
				//wfsearchtab.setHeight(wfsearchtab.getHeight()-1);
				document.getElementById("isinit").value = "false";
			}
		}
		catch(e)
		{
		}
		$GetEle("self").value='true'
		search();
		
	  					
}


function bacthSharing22(){
 

    if(window.confim("cicciciciicic")){
     //alert("请先选择文档，再进行文档附件批量下载！");
     alert("<%=SystemEnv.getHtmlLabelName(27694,user.getLanguage())%>");
     return false;
    }else{
     window.location="/weaver/weaver.file.FileDownload?fieldvalue="+btdocids+"&displayUsage="+displayUsage+"&download=1&downloadBatch=1&docSearchFlag=1&requestid=";
    }
}


</script>

<script language="javaScript">
userightmenu_self = '<%=userightmenu_self%>';

if(userightmenu_self!=1){
	_divSearchDivHeightNo = 61;
    _divSearchDivHeight=185;
	<%if(userightmenu_self!=1){%>
		eval(rightMenuBarItem = <%=topButton%>);
	<%}%>
}else{
	_divSearchDivHeightNo = 33;
    _divSearchDivHeight=175;
}
_isViewPort=true;
_pageId="ExtDocSearch";  
_divSearchDiv='DocSearchDiv'; 
_defaultSearchStatus='show';  //close //show //more	

var customSearch = false;
var baseDiv = 400;
var basePanel = 360;
var baseRow = 23;
var rowCount=0;
var isLoadCombo = false;
</script>
</body>

<script type="text/javascript">


    function showSearchAdvice(obj){
    	if(!isLoadCombo)
		{
			ComboBoxExtProxy();
			isLoadCombo = true;
		}
        if(jQuery("#advicedSearchDiv").is(":hidden")){
           jQuery("#advicedSearchDiv").show();
           jQuery("#searchAdviceImg").attr("src","/images/up_wev8.png");
        }else{
           jQuery("#advicedSearchDiv").hide();
           jQuery("#searchAdviceImg").attr("src","/images/down_wev8.png");
        }
    }



	function showSearchAdvice1(obj){
			    if(!isLoadCombo)
				{
					ComboBoxExtProxy();
					isLoadCombo = true;
				}
				//var searchPanel = panelTitle.findById('searchPanel');
				if(Ext.getDom("advicedSearchDiv").style.display=='none'){
					Ext.getDom("advicedSearchDiv").style.display='';
					document.searchAdviceImg.src = '/images/up_wev8.png';
					/*if(customSearch){
						_divSearchDivHeight=baseDiv+baseRow*rowCount;	
						if(_divSearchDivHeight>450){
							_divSearchDivHeight = 450;
							if(userightmenu_self!=1){
								searchPanel.setHeight(395);
								//_divSearchDivHeight=_divSearchDivHeight+25;
							}else{
								searchPanel.setHeight(_divSearchDivHeight);
							}
							
						}else{
							if(userightmenu_self!=1){
								//_divSearchDivHeight=_divSearchDivHeight+25;
								searchPanel.setHeight(basePanel+baseRow*rowCount-25);
							}else{
								searchPanel.setHeight(basePanel+baseRow*rowCount);
							}
						}
					}else{
						_divSearchDivHeight=baseDiv;
						if(userightmenu_self!=1){	
							searchPanel.setHeight(basePanel-25);
							//_divSearchDivHeight=_divSearchDivHeight+25;
						}else{
							searchPanel.setHeight(basePanel);
						}
					}*/
				}else{
					Ext.getDom("advicedSearchDiv").style.display='none';
					document.searchAdviceImg.src = '/images/down_wev8.png';
					/*if(userightmenu_self!=1){	
							searchPanel.setHeight(90);
							_divSearchDivHeight=150;
					}else{
						searchPanel.setHeight(90);
						_divSearchDivHeight=125;
						
					}*/
					
					//searchPanel.setHeight(90);
				}
				//var row = obj.parentNode.parentNode;
				//row.parentNode.removeChild(row);
				if(_divSearchDivHeight>450){
					_divSearchDivHeight = 450;
				}
				
				//panelTitle.setHeight(_divSearchDivHeight);
				//panelTitle.doLayout();		
				//viewport.doLayout();
	}
	
	new Ext.ToolTip({
		        target: 'remind',
		        title: wmsg.wf.searchRemind,
		        //width:350,
		        //mouseOffset :[-100,0],
		        anchor: 'top',
		        html: wmsg.wf.searchRemindMsg,
		        trackMouse:false,
		        autoHide: true,
		        closable: false,
		        dismissDelay: 20000
		    });
	/*		
	new Ext.Button({   
		text: wmsg.wf.displaySearchAdvice,   
		iconCls: 'btn_searchAdvice1',   
		tooltip: wmsg.wf.displaySearchAdvice+'/'+wmsg.wf.hideSearchAdvice,
		minWidth:50,
		handler: function(){   
			var searchPanel = panelTitle.findById('searchPanel');
		
			if(Ext.getDom("advicedSearchDiv").style.display=='none'){
				Ext.getDom("advicedSearchDiv").style.display='';
				_divSearchDivHeight=423;	
				searchPanel.setHeight(390);
				this.setText(wmsg.wf.hideSearchAdvice);
			}else{
				Ext.getDom("advicedSearchDiv").style.display='none';
				_divSearchDivHeight=123;
				searchPanel.setHeight(90);
				this.setText(wmsg.wf.displaySearchAdvice);
			}	
		  panelTitle.setHeight(_divSearchDivHeight);
		
		  
		  panelTitle.doLayout();
		  viewport.doLayout();
		}   
		}).render(document.body,'AdvicedSearchBtn');
		*/
		
				
</script>
<script type='text/javascript' src='/js/doc/ComboBoxExt_wev8.js'></script>
<script type='text/javascript' src='/js/doc/DocSearch_wev8.js'></script>
<script type="text/javascript">
</script>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<%if("shareManageDoc".equals(from)){%>
<%@ include file="ext/ShareManageDocExt.jsp"%>
<%}else if("shareMutiDoc".equals(from)) {%>
<%@ include file="ext/ShareMutiDocExt.jsp"%>

<%}else if("docsubscribe".equals(from)) {
%>	
<%@ include file="ext/DocSubsribeExt.jsp"%>
<% }else{
%>
<%@ include file="ext/DocSearchViewExt.jsp"%>
<%	
}

%>

</html>
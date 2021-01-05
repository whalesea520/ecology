
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.docs.category.security.AclManager" %>

<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />

<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>



<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
</head>
<%
	String urlType = "6";
	String isNew = Util.null2String(request.getParameter("isNew"));
	String from = Util.null2String(request.getParameter("from"));
	if(isNew.equals("yes") && from.equals("elemore")){
		urlType = "18";
	}else if(isNew.equals("yes")){
		urlType = "0";
	}
	if(true){
		response.sendRedirect("/docs/search/DocSearchTab.jsp?urlType="+urlType+"&"+request.getQueryString());
		return;
	}
	if ("docsubscribe".equals(request.getParameter("from"))) {
	    response.sendRedirect("/docs/docsubscribe/DocSubscribe.jsp");
	    return ;
	} else if ("shareMutiDoc".equals(request.getParameter("from"))){
	    response.sendRedirect("/docs/docs/ShareMutiDocList.jsp");
	    return ;
	}
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(356,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean isViewPort=true;
	BaseBean baseBean = new BaseBean();
	int olddate2during = 0;
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
%>
<!--声明开始 此断请不要修改  可以放在此处，也可放在此文件开始处-->
<%@ page import="weaver.common.xtable.*"%>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%@ include file="/systeminfo/TopTitleExt.jsp"%>
<%@ include file="/docs/DocDetailLog.jsp"%>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />

<%
	ArrayList xTableColumnList = new ArrayList();
	ArrayList xTableOperationList = new ArrayList();
	ArrayList xTableToolBarList = new ArrayList();	
	TableSql xTableSql=new TableSql();
	Table xTable=new Table(request); 
	TableOperatePopedom xTableOperatePopedom=new TableOperatePopedom();
	
		//TableColumn xTableColumn_ID = new TableColumn();
		//xTableColumn_ID.setColumn("id");
		//xTableColumn_ID.setDataIndex("id");
		//xTableColumn_ID.setHeader("&nbsp;&nbsp;");
		//xTableColumn_ID.setSortable(false);
		//xTableColumn_ID.setHideable(false);
		//xTableColumn_ID.setWidth(0.0000001);
		//xTableColumnList.add(xTableColumn_ID);
	 //xTable.setColumnWidth(54);
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
%>
<!--声明结束-->
<%


String sqlWhere="";
//查询设置
String userid=user.getUID()+"" ;
String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
char flag=2;
boolean shownewicon=false;

String dspreply = DocSearchComInfo.getContainreply() ;
String tabletype="checkbox";
String browser="";
String urlfrom = Util.null2String(request.getParameter("from"));
String isreply=Util.null2String(request.getParameter("isreply"));
String frompage=Util.null2String(request.getParameter("frompage"));
String doccreatedatefrom=Util.null2String(request.getParameter("doccreatedatefrom"));
String doccreatedateto=Util.null2String(request.getParameter("doccreatedateto"));
String docpublishtype=Util.null2String(request.getParameter("docpublishtype"));

/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")),0);

String selectArr = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;
if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectArr,"|");
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(docCategoryArray[k].indexOf("M")>-1)
				inMainCategoryStr += "," + docCategoryArray[k].substring(1);
			if(docCategoryArray[k].indexOf("S")>-1)
				inSubCategoryStr += "," + docCategoryArray[k].substring(1);
		}
		if(inMainCategoryStr.substring(0,1).equals(",")) inMainCategoryStr=inMainCategoryStr.substring(1);
		if(inSubCategoryStr.substring(0,1).equals(",")) inSubCategoryStr=inSubCategoryStr.substring(1);
	}
}

int showTitle = Util.getIntValue(request.getParameter("showTitle"),0);
int showDocs = Util.getIntValue(request.getParameter("showDocs"),0);
String maincategory=Util.null2String(request.getParameter("maincategory"));
String subcategory=Util.null2String(request.getParameter("subcategory"));
String seccategory=Util.null2String(request.getParameter("seccategory"));
String tdspreply=Util.null2String(request.getParameter("dspreply"));
String tisNew = Util.null2String(request.getParameter("isNew"));
String tisMainOrSub = Util.null2String(request.getParameter("isMainOrSub"));
String tdepartmentid = Util.null2String(request.getParameter("departmentid"));
String tsubcompanyid = Util.null2String(request.getParameter("subcompanyid"));

String docnotmp = DocSearchComInfo.getDocno();
String usertypetmp = DocSearchComInfo.getUsertype();
String keywordtmp = DocSearchComInfo.getKeyword();
String doccreateridtmp = DocSearchComInfo.getDoccreaterid();
String doccreatedateFromtmp = DocSearchComInfo.getDoccreatedateFrom();
String doccreatedateTotmp = DocSearchComInfo.getDoccreatedateTo();

String tcontainreply = Util.null2String(request.getParameter("containreply"));
String taddfavourite = Util.null2String(request.getParameter("addfavourite"));
String tseccategory = seccategory;
String tsubcategory = subcategory;
String tmaincategory = maincategory;
String tmaincategoryname = "";
String tsubcategoryname ="";
String tseccategoryname="";
if("1".equals(taddfavourite))
{
	if(showDocs==1||!"".equals(maincategory)||!"".equals(subcategory)||!"".equals(seccategory)||!"".equals(tsubcompanyid)||!"".equals(tdepartmentid))
	{
		DocSearchComInfo.resetSearchInfo();
		DocSearchComInfo.setMaincategory(maincategory);
		DocSearchComInfo.setSubcategory(subcategory);
		DocSearchComInfo.setSeccategory(seccategory);
		DocSearchComInfo.setUserID(""+user.getUID());
		DocSearchComInfo.setDocSubCompanyId(tsubcompanyid);
		DocSearchComInfo.setDocdepartmentid(tdepartmentid);
		DocSearchComInfo.setIsMainOrSub(tisMainOrSub) ;
		if ("1".equals(tdspreply)) 
			DocSearchComInfo.setContainreply("1");   //全部
		else if("0".equals(tdspreply)) 
			DocSearchComInfo.setContainreply("0");   //非回复
		else if ("2".equals(tdspreply)) 
			DocSearchComInfo.setIsreply("1");  //仅回复
		else 
			DocSearchComInfo.setIsreply("");
		String strShowType="";
		if(showtype==0)
		{
			strShowType="";
		}
		else
		{
			strShowType=String.valueOf(showtype);
		}
		DocSearchComInfo.setShowType(strShowType);
		DocSearchComInfo.setLoginType("1");
		DocSearchComInfo.setIsNew(tisNew) ;
		DocSearchComInfo.addDocstatus("1");
		DocSearchComInfo.addDocstatus("2");
		DocSearchComInfo.addDocstatus("5");
		DocSearchComInfo.addDocstatus("7");
	}
}
DocSearchComInfo.setIsNew(tisNew) ;
if(!"".equals(tseccategory)) tsubcategory = SecCategoryComInfo.getSubCategoryid(tseccategory);
if(!"".equals(tsubcategory)) tmaincategory = SubCategoryComInfo.getMainCategoryid(tsubcategory);

if(showTitle==1){
	if(!"".equals(tmaincategory)){
		tmaincategoryname = MainCategoryComInfo.getMainCategoryname(tmaincategory);
		tmaincategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&maincategory="+tmaincategory + "\">" + tmaincategoryname + "</a>";
	}
	if(!"".equals(tsubcategory)){
		tsubcategoryname = SubCategoryComInfo.getSubCategoryname(tsubcategory);
		tsubcategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&subcategory="+tsubcategory + "\">" + tsubcategoryname + "</a>";
	}
	if(!"".equals(tseccategory) && tseccategory.indexOf(",")==-1){
		tseccategoryname = SecCategoryComInfo.getSecCategoryname(tseccategory);
		tseccategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&seccategory="+tseccategory + "\">" + tseccategoryname + "</a>";
	}

	titlename = tmaincategoryname;

	if(tsubcategory!=null&&!"".equals(tsubcategory)) titlename+= " > ";
	titlename += tsubcategoryname;

	if(tseccategory!=null&&!"".equals(tseccategory) && tseccategory.indexOf(",")==-1) titlename+= " > ";
	titlename += tseccategoryname;
}

/* edited end */

/* added by yinshun.xu 2006-07-19 按组织结构显示 */
//String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));
String subcompanyid=DocSearchComInfo.getDocSubCompanyId();
String departmentid=DocSearchComInfo.getDocdepartmentid();
/* added end */

/* added by fanggsh 2006-07-24 按树状字段显示 */
String treeDocFieldId=DocSearchComInfo.getTreeDocFieldId();
/* added end */






String tableString = "";
String tableInfo = "";

boolean isUsedCustomSearch = false;

if(DocSearchComInfo.getSeccategory()!=null&&!"".equals(DocSearchComInfo.getSeccategory())&&!"elemore".equalsIgnoreCase(Util.null2String(request.getParameter("from")))){
    isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
}
String strDummy=""; 
String strDummyEn="";

if(DocTreeDocFieldManager.getIsHaveRightToDummy(user.getUID())){
	//strDummy="&nbsp;&nbsp;[<a href='javascript:importSelectedToDummy()'>"+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"</a>]&nbsp;&nbsp;[<a href='javascript:importAllToDummy()'>"+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"</a>]"; 
	    //strDummyEn="&nbsp;&nbsp;[<a href='javascript:importSelectedToDummy()'>Import Selected Docs To Dummy Catelog</a>]&nbsp;&nbsp;[<a href='javascript:importAllToDummy()'>Import All Docs To Dummy Catelog</a>]";
	
	//xTableToolBarList.set(1,"{text:'"+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"',iconCls:'btn_import',handler:function(){importSelectedToDummy()}}");
	//xTableToolBarList.set(2,"{text:'"+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"',iconCls:'btn_import',handler:function(){importAllToDummy()}}");

} else {
 	strDummy="&nbsp;&nbsp;["+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"]&nbsp;&nbsp;["+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"]"; 
}

boolean isGetShareDetailTableByUserNew=false;
if(!isUsedCustomSearch&&((date2during>0&&date2during<37)||!UserDefaultManager.getHasoperate().equals("1"))){
	isGetShareDetailTableByUserNew=true;
}

if(isGetShareDetailTableByUserNew)
{
	tables=sharemanager.getShareDetailTableByUserNew("doc",user);
}
if(isUsedCustomSearch){
	
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
    //backFields
	String backFields = "";
	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname");

	//from
	String  sqlFrom = "DocDetail  t1, "+tables+"  t2";
	
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	whereclause += dm.getDateDuringSql(date2during);
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
     }	 
	}
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
		whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
	if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
		whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
	/* added end */
	//String tableInfo
	
	tableInfo = "[<a href='/docs/search/DocSearch.jsp?from=docsubscribe'>"+Util.replace(SystemEnv.getHtmlLabelName(21828,user.getLanguage()),"\\*",DocComInfo.getNoRightCount(whereclause,user),1)+"</a>]"+strDummy;
	xTableToolBarList.set(0,"{text:'"+Util.replace(SystemEnv.getHtmlLabelName(21828,user.getLanguage())+12121,"\\*",DocComInfo.getNoRightCount(whereclause,user),1)+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	//tableInfo = "[<a href='/docs/search/DocSearch.jsp?from=docsubscribe'>"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	//xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
		xTableToolBarList.set(0,"");
	}
	
	
		
	sqlFrom += ",(select ljt1.id as docid,ljt2.* from DocDetail ljt1 LEFT JOIN cus_fielddata ljt2 ON ljt1.id=ljt2.id and ljt2.scope='DocCustomFieldBySecCategory' and ljt2.scopeid="+DocSearchComInfo.getSeccategory()+") tcm";
	whereclause += " and t1.id = tcm.docid ";
	
	
	
	
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	
	//System.out.println(sqlWhere);
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
	}
	if(displayUsage==1){
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	}
	TableColumn xTableColumn_DocName = new TableColumn();
	xTableColumn_DocName.setColumn("docsubject");
	xTableColumn_DocName.setDataIndex("docsubject");
	xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
	xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId");
	xTableColumn_DocName.setPara_1("column:id");
	xTableColumn_DocName.setPara_2(userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount");
	//xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
	//xTableColumn_DocName.setLinkkey("id");
	xTableColumn_DocName.setSortable(true);
	xTableColumn_DocName.setWidth(0.22);
	xTableColumnList.add(xTableColumn_DocName);
	if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
	     //System.out.println("sqlwhere new  is "+sqlWhere);
		tabletype="checkbox";
		tableInfo="";
		//xTableToolBarList.set(0,"");
		colString ="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		xTableColumnList.clear();
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
		
		TableColumn xTableColumn_DocName2 = new TableColumn();
		xTableColumn_DocName2.setColumn("docsubject");
		xTableColumn_DocName2.setDataIndex("docsubject");
		xTableColumn_DocName2.setHeader(SystemEnv.getHtmlLabelName(58, user.getLanguage()));
		xTableColumn_DocName2.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew");
		xTableColumn_DocName2.setPara_1("column:id");
		xTableColumn_DocName2.setPara_2("column:docsubject");
		xTableColumn_DocName2.setTarget("_fullwindow");
		//xTableColumn_DocName2.setHref("/docs/docs/DocDsp.jsp");
		xTableColumn_DocName2.setLinkkey("id");
		xTableColumn_DocName2.setSortable(true);
		xTableColumn_DocName2.setWidth(0.22);
		xTableColumnList.add(xTableColumn_DocName2);
	}
	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
 		String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
	String operateString = "";
	if (UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0) 
	{
		operateString= "<operates width=\"20%\">";
		       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\"  otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
		       operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
		       operateString+="     <operate href=\"javascript:doDocDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
		       operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
		       operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
		       operateString+="</operates>";
		
		xTableOperatePopedom.setTransmethod("weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2");
		xTableOperatePopedom.setOtherpara(popedomOtherpara);
		xTableOperatePopedom.setOtherpara2(popedomOtherpara2);
		
		TableOperation xTableOperation_Edit = new TableOperation();
		xTableOperation_Edit.setHref("/docs/docs/DocEdit.jsp");
		xTableOperation_Edit.setLinkkey("id");
		xTableOperation_Edit.setLinkvaluecolumn("id");
		xTableOperation_Edit.setText(SystemEnv.getHtmlLabelName(93,user.getLanguage()));
		xTableOperation_Edit.setTarget("_fullwindow");
		xTableOperation_Edit.setIndex("1");
		xTableOperationList.add(xTableOperation_Edit);
	
		TableOperation xTableOperation_Del = new TableOperation();
		xTableOperation_Del.setHref("javascript:doDocDel()");
		xTableOperation_Del.setText(SystemEnv.getHtmlLabelName(91, user.getLanguage()));
		xTableOperation_Del.setTarget("_fullwindow");
		xTableOperation_Del.setIndex("2");
		xTableOperationList.add(xTableOperation_Del);
	
		TableOperation xTableOperation_Share = new TableOperation();
		xTableOperation_Share.setHref("javascript:doDocShare()");
		xTableOperation_Share.setText(SystemEnv.getHtmlLabelName(119,user.getLanguage()));
		xTableOperation_Share.setTarget("_fullwindow");
		xTableOperation_Share.setIndex("3");
		xTableOperationList.add(xTableOperation_Share);
	
		TableOperation xTableOperation_Log = new TableOperation();
		xTableOperation_Log.setHref("javascript:doDocViewLog()");
		xTableOperation_Log.setText(SystemEnv.getHtmlLabelName(83, user.getLanguage()));
		xTableOperation_Log.setTarget("_fullwindow");
		xTableOperation_Log.setIndex("4");
		xTableOperationList.add(xTableOperation_Log);     
	}
	
	//

    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
	RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+DocSearchComInfo.getSeccategory()+" order by viewindex");
	while(RecordSet.next()){
		int currId = RecordSet.getInt("id");
		int currDocPropertyId = RecordSet.getInt("docPropertyId");
		int currVisible = RecordSet.getInt("visible");
		
		int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
		//if(currType==1) continue;
		
		int currIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(currDocPropertyId+""));
		
		int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
		String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+""));
		
		String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
        
        if((currVisible==1 || currVisible==-1)&&displayUsage==0){
            if(currIsCustom==1){
                int tmpfieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId(currDocPropertyId+""));

                
                String tmpcustomName = SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"");
                int tempIndexId=tmpcustomName.lastIndexOf("("+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+")");
			    if(tempIndexId<=0){
				    tempIndexId=tmpcustomName.lastIndexOf("(user-defined)");
			    }
			    if(tempIndexId>0){
					tmpcustomName=tmpcustomName.substring(0,tempIndexId);
			    }
        	    backFields=getFilterBackFields(backFields,"tcm.field"+tmpfieldid);
        	    colString +="<col width=\"10%\"  text=\""+tmpcustomName+"\" column=\""+"field"+tmpfieldid+"\" orderkey=\""+"field"+tmpfieldid+"\"  transmethod=\"weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName\"   otherpara=\""+tmpfieldid+"+"+ user.getLanguage()+"\"/>";
        	    TableColumn xTableColumn_Field = new TableColumn();
				xTableColumn_Field.setColumn("field" + tmpfieldid);
				xTableColumn_Field.setDataIndex("field"+ tmpfieldid);
				xTableColumn_Field.setTransmethod("weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName");
				xTableColumn_Field.setPara_1("column:"+"field"+tmpfieldid);
				xTableColumn_Field.setPara_2(""+tmpfieldid+"+"+user.getLanguage());
				xTableColumn_Field.setHeader(tmpcustomName);
				xTableColumn_Field.setWidth(0.1);
				xTableColumn_Field.setSortable(true);
				xTableColumnList.add(xTableColumn_Field);
            } else {
                if(currType==1){
					if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"
					    colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
					}else{
						colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
					}
                } else if(currType==2){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docCode");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docCode\" orderkey=\"docCode\"/>";
                	TableColumn xTableColumn_DocCode = new TableColumn();
					xTableColumn_DocCode.setColumn("docCode");
					xTableColumn_DocCode.setDataIndex("docCode");
					xTableColumn_DocCode.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCode.setSortable(true);
					xTableColumn_DocCode.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCode);
                } else if(currType==3){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docpublishtype");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>";
                	TableColumn xTableColumn_DocPublishType = new TableColumn();
					xTableColumn_DocPublishType.setColumn("docpublishtype");
					xTableColumn_DocPublishType.setDataIndex("docpublishtype");
					xTableColumn_DocPublishType.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocPublishType.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocPublicType");
					xTableColumn_DocPublishType.setPara_1("column:docpublishtype");
					xTableColumn_DocPublishType.setPara_2(Integer.toString(user.getLanguage()));
					xTableColumn_DocPublishType.setSortable(true);
					xTableColumn_DocPublishType.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocPublishType);
                } else if(currType==4){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docedition");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docedition\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>";
                	TableColumn xTableColumn_DocEdition = new TableColumn();
					xTableColumn_DocEdition.setColumn("version");
					xTableColumn_DocEdition.setDataIndex("version");
					xTableColumn_DocEdition.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocEdition.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocVersion");
					xTableColumn_DocEdition.setPara_1("column:id");
					xTableColumn_DocEdition.setSortable(true);
					xTableColumn_DocEdition.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocEdition);
                } else if(currType==5){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docstatus");
            	    //colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\" otherpara=\""+user.getLanguage()+"\"/>";
            	    colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";            	    
                	TableColumn xTableColumn_DocStatus = new TableColumn();
					xTableColumn_DocStatus.setColumn("docstatus");
					xTableColumn_DocStatus.setDataIndex("docstatus");
					xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					//xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus2");
					xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
					xTableColumn_DocStatus.setPara_1("column:id");
					//xTableColumn_DocStatus.setPara_2(Integer.toString(user.getLanguage()));
					xTableColumn_DocStatus.setPara_2(Integer.toString(user.getLanguage())+"+column:docstatus+column:seccategory");
					xTableColumn_DocStatus.setSortable(true);
					xTableColumn_DocStatus.setWidth(0.05);
					xTableColumnList.add(xTableColumn_DocStatus);
                } else if(currType==6){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maincategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"maincategory\" orderkey=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaincategory\"/>";
                	TableColumn xTableColumn_MainCategory = new TableColumn();
					xTableColumn_MainCategory.setColumn("maincategory");
					xTableColumn_MainCategory.setDataIndex("maincategory");
					xTableColumn_MainCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_MainCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocMaincategory");
					xTableColumn_MainCategory.setPara_1("column:maincategory");
					xTableColumn_MainCategory.setSortable(true);
					xTableColumn_MainCategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_MainCategory);
                } else if(currType==7){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.subcategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"subcategory\" orderkey=\"subcategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubcategory\"/>";
                	TableColumn xTableColumn_SubCategory = new TableColumn();
					xTableColumn_SubCategory.setColumn("subcategory");
					xTableColumn_SubCategory.setDataIndex("subcategory");
					xTableColumn_SubCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_SubCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocSubcategory");
					xTableColumn_SubCategory.setPara_1("column:subcategory");
					xTableColumn_SubCategory.setSortable(true);
					xTableColumn_SubCategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_SubCategory);
                } else if(currType==8){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.seccategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"seccategory\" orderkey=\"seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSeccategory\"/>";
                	TableColumn xTableColumn_Seccategory = new TableColumn();
					xTableColumn_Seccategory.setColumn("seccategory");
					xTableColumn_Seccategory.setDataIndex("seccategory");
					xTableColumn_Seccategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_Seccategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocSeccategory");
					xTableColumn_Seccategory.setPara_1("column:seccategory");
					xTableColumn_Seccategory.setSortable(true);
					xTableColumn_Seccategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_Seccategory);
                } else if(currType==9){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docdepartmentid");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDepartment\"/>";
              	    TableColumn xTableColumn_DocDepartmentId = new TableColumn();
					xTableColumn_DocDepartmentId.setColumn("docdepartmentid");
					xTableColumn_DocDepartmentId.setDataIndex("docdepartmentid");
					xTableColumn_DocDepartmentId.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocDepartmentId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocDepartment");
					xTableColumn_DocDepartmentId.setPara_1("column:docdepartmentid");
					xTableColumn_DocDepartmentId.setSortable(true);
					xTableColumn_DocDepartmentId.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocDepartmentId);
                } else if(currType==10){
                	
                    
                } else if(currType==11){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclangurage");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclangurage\" orderkey=\"doclangurage\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocLangurage\"/>";
                	TableColumn xTableColumn_DocLangurage = new TableColumn();
					xTableColumn_DocLangurage.setColumn("doclangurage");
					xTableColumn_DocLangurage.setDataIndex("doclangurage");
					xTableColumn_DocLangurage.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocLangurage.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocLangurage");
					xTableColumn_DocLangurage.setPara_1("column:doclangurage");
					xTableColumn_DocLangurage.setSortable(true);
					xTableColumn_DocLangurage.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocLangurage);
                } else if(currType==12){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.keyword");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"keyword\" orderkey=\"keyword\"/>";
                	TableColumn xTableColumn_KeyWord = new TableColumn();
					xTableColumn_KeyWord.setColumn("keyword");
					xTableColumn_KeyWord.setDataIndex("keyword");
					xTableColumn_KeyWord.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_KeyWord.setSortable(true);
					xTableColumn_KeyWord.setWidth(0.1);
					xTableColumnList.add(xTableColumn_KeyWord);
                
                } else if(currType==13){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    //backFields=getFilterBackFields(backFields,"t1.doccreaterid,t1.doccreatedate,t1.doccreatetime");
            	    backFields=getFilterBackFields(backFields,"t1.doccreatedate,t1.doccreatetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
                	TableColumn xTableColumn_DocCreateDate = new TableColumn();
					xTableColumn_DocCreateDate.setColumn("doccreatedate");
					xTableColumn_DocCreateDate.setDataIndex("doccreatedate");
					xTableColumn_DocCreateDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCreateDate.setSortable(true);
					xTableColumn_DocCreateDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCreateDate);
                } else if(currType==14){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclastmoduserid,t1.doclastmoddate,t1.doclastmodtime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
                	TableColumn xTableColumn_DocLastModDate = new TableColumn();
					xTableColumn_DocLastModDate.setColumn("doclastmoddate");
					xTableColumn_DocLastModDate.setDataIndex("doclastmoddate");
					xTableColumn_DocLastModDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocLastModDate.setSortable(true);
					xTableColumn_DocLastModDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocLastModDate);
                } else if(currType==15){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docapproveuserid,t1.docapprovedate,t1.docapprovetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docapprovedate\" orderkey=\"docapprovedate\"/>";
                	TableColumn xTableColumn_DocApproveDate = new TableColumn();
					xTableColumn_DocApproveDate.setColumn("docapprovedate");
					xTableColumn_DocApproveDate.setDataIndex("docapprovedate");
					xTableColumn_DocApproveDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocApproveDate.setSortable(true);
					xTableColumn_DocApproveDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocApproveDate);
                } else if(currType==16){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docinvaluserid,t1.docinvaldate,t1.docinvaltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docinvaldate\" orderkey=\"docinvaldate\"/>";
                	TableColumn xTableColumn_DocInvalDate = new TableColumn();
					xTableColumn_DocInvalDate.setColumn("docinvaldate");
					xTableColumn_DocInvalDate.setDataIndex("docinvaldate");
					xTableColumn_DocInvalDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocInvalDate.setSortable(true);
					xTableColumn_DocInvalDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocInvalDate);
                } else if(currType==17){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docarchiveuserid,t1.docarchivedate,t1.docarchivetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docarchivedate\" orderkey=\"docarchivedate\"/>";
                	TableColumn xTableColumn_DocArchiveDate = new TableColumn();
					xTableColumn_DocArchiveDate.setColumn("docarchivedate");
					xTableColumn_DocArchiveDate.setDataIndex("docarchivedate");
					xTableColumn_DocArchiveDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocArchiveDate.setSortable(true);
					xTableColumn_DocArchiveDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocArchiveDate);
                } else if(currType==18){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doccanceluserid,t1.doccanceldate,t1.doccanceltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccanceldate\" orderkey=\"doccanceldate\"/>";
               		TableColumn xTableColumn_DocCancelDate = new TableColumn();
					xTableColumn_DocCancelDate.setColumn("doccanceldate");
					xTableColumn_DocCancelDate.setDataIndex("doccanceldate");
					xTableColumn_DocCancelDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCancelDate.setSortable(true);
					xTableColumn_DocCancelDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCancelDate);
                } else if(currType==19){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maindoc");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" otherpara=\"column:maindoc+"+user.getLanguage()+"\" orderkey=\"maindoc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaindoc\"/>";
                	TableColumn xTableColumn_MainDoc = new TableColumn();
					xTableColumn_MainDoc.setColumn("maindoc");
					xTableColumn_MainDoc.setDataIndex("maindoc");
					xTableColumn_MainDoc.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_MainDoc.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocMaindoc");
					xTableColumn_MainDoc.setPara_1("column:id");
					xTableColumn_MainDoc.setPara_2("column:maindoc+"+ user.getLanguage());
					xTableColumn_MainDoc.setSortable(true);
					xTableColumn_MainDoc.setWidth(0.1);
					xTableColumnList.add(xTableColumn_MainDoc);
                } else if(currType==20){
                    
                    
                } else if(currType==21){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.ownerid");
          	        colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
                	TableColumn xTableColumn_OwnerId = new TableColumn();
					xTableColumn_OwnerId.setColumn("ownerid");
					xTableColumn_OwnerId.setDataIndex("ownerid");
					xTableColumn_OwnerId.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_OwnerId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
					xTableColumn_OwnerId.setPara_1("column:ownerid");
					xTableColumn_OwnerId.setPara_2("column:usertype");
					xTableColumn_OwnerId.setSortable(true);
					xTableColumn_OwnerId.setWidth(0.08);
					xTableColumnList.add(xTableColumn_OwnerId);
                } else if(currType==22){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.invalidationdate");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"invalidationdate\" orderkey=\"invalidationdate\"/>";
                	TableColumn xTableColumn_InvalidationDate = new TableColumn();
					xTableColumn_InvalidationDate.setColumn("invalidationdate");
					xTableColumn_InvalidationDate.setDataIndex("invalidationdate");
					xTableColumn_InvalidationDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_InvalidationDate.setSortable(true);
					xTableColumn_InvalidationDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_InvalidationDate);
                }else if(currType==24){
                	int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
             	    
             	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDummyCategory\"/>";
                 	TableColumn xTableColumn_DocDummyCategory = new TableColumn();
                 	xTableColumn_DocDummyCategory.setColumn("docDummyCategory");
                 	xTableColumn_DocDummyCategory.setDataIndex("docDummyCategory");
                 	xTableColumn_DocDummyCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
                 	xTableColumn_DocDummyCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocDummyCategory");
                 	xTableColumn_DocDummyCategory.setPara_1("column:id");
                 	xTableColumn_DocDummyCategory.setSortable(false);
                 	xTableColumn_DocDummyCategory.setWidth(0.1);
 					xTableColumnList.add(xTableColumn_DocDummyCategory);
                }else if(currType==25){
                	
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.canPrintedNum");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"canPrintedNum\" orderkey=\"canPrintedNum\"/>";
                	TableColumn xTableColumn_CanPrintedNum = new TableColumn();
                	xTableColumn_CanPrintedNum.setColumn("canPrintedNum");
					xTableColumn_CanPrintedNum.setDataIndex("canPrintedNum");
					xTableColumn_CanPrintedNum.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_CanPrintedNum.setSortable(true);
					xTableColumn_CanPrintedNum.setWidth(0.1);
					xTableColumnList.add(xTableColumn_CanPrintedNum);
                }
                
                
            }
        }
    }
	
	
	
	
	
	
	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;
	}
	/*
	if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
	      dspcreater = true ;
	      backFields=getFilterBackFields(backFields,"t1.ownerid,t1.doccreaterid,t1.usertype");
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
	}
	if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
	    dspcreatedate = true ;
	    backFields=getFilterBackFields(backFields,"t1.doccreatedate");
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
	}
	if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
	    dspmodifydate = true ;
	    backFields=getFilterBackFields(backFields,"t1.doclastmoddate");
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
	}
	if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
	    dspcategory = true ;
	    backFields=getFilterBackFields(backFields,"t1.maincategory");
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
	}
	*/
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.replaydoccount");
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
		TableColumn xTableColumn_ReplayDocCount = new TableColumn();
		xTableColumn_ReplayDocCount.setColumn("replaydoccount");
		xTableColumn_ReplayDocCount.setDataIndex("replaydoccount");
		xTableColumn_ReplayDocCount.setHeader(SystemEnv.getHtmlLabelName(18470, user.getLanguage()));
		xTableColumn_ReplayDocCount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
		xTableColumn_ReplayDocCount.setPara_1("column:id");
		xTableColumn_ReplayDocCount.setPara_2("column:replaydoccount");
		xTableColumn_ReplayDocCount.setSortable(false);
		xTableColumn_ReplayDocCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_ReplayDocCount);	
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.accessorycount");
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
		
		TableColumn xTableColumn_AccessoryCount = new TableColumn();
		xTableColumn_AccessoryCount.setColumn("accessorycount");
		xTableColumn_AccessoryCount.setDataIndex("accessorycount");
		xTableColumn_AccessoryCount.setHeader(SystemEnv.getHtmlLabelName(2002, user.getLanguage()));
		xTableColumn_AccessoryCount.setSortable(true);
		xTableColumn_AccessoryCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_AccessoryCount);
	}
	

	backFields=getFilterBackFields(backFields,"t1.sumReadCount,t1.docstatus,t1.sumMark");
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		TableColumn xTableColumn_SumReadCount = new TableColumn();
		xTableColumn_SumReadCount.setColumn("sumReadCount");
		xTableColumn_SumReadCount.setDataIndex("sumReadCount");
		xTableColumn_SumReadCount.setHeader(SystemEnv.getHtmlLabelName(18469, user.getLanguage()));
		xTableColumn_SumReadCount.setSortable(true);
		xTableColumn_SumReadCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_SumReadCount);
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		TableColumn xTableColumn_SumMark = new TableColumn();
		xTableColumn_SumMark.setColumn("sumMark");
		xTableColumn_SumMark.setDataIndex("sumMark");
		xTableColumn_SumMark.setHeader(SystemEnv.getHtmlLabelName(15663, user.getLanguage()));
		xTableColumn_SumMark.setSortable(true);
		xTableColumn_SumMark.setWidth(0.05);
		xTableColumnList.add(xTableColumn_SumMark);
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
	}
	
	if(backFields.startsWith(",")) backFields=backFields.substring(1);
	if(backFields.endsWith(",")) backFields=backFields.substring(0,backFields.length()-1);
	
	
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	//System.out.println("sqlWhere is "+sqlWhere);
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		    sqlFrom=" (select * from (select "+backFields+" from "+sqlFrom+" "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";        
		    sqlWhere="  b.docid is  null) table1";
		    backFields="table1.*";
	    } else {
	        sqlFrom="from (select "+backFields+" from "+sqlFrom+" "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		    sqlWhere=" b.docid is  null";
		    backFields="*";
	    }
	}
	
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	
	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+=operateString;
    tableString+="</table>";  
    xTableSql.setBackfields(backFields);
    xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("false");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy); 
      
} else {
    
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
	//backFields
	//String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,";
	String backFields="t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid,";
	if(isGetShareDetailTableByUserNew)
    {
		backFields="t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
    }
	//from
	String  sqlFrom = "DocDetail  t1, "+tables+"  t2";  
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	
	
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	whereclause += dm.getDateDuringSql(date2during);
	
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1 ";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
     }	 
	}
	
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
		whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
	if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
		whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
	/* added end */
	
	
	//String tableInfo
	
	tableInfo = "[<a href='/docs/search/DocSearch.jsp?from=docsubscribe'>"+Util.replace(SystemEnv.getHtmlLabelName(21828,user.getLanguage()),"\\*",DocComInfo.getNoRightCount(whereclause,user),1)+"</a>]"+strDummy;
	xTableToolBarList.set(0,"{text:'"+Util.replace(SystemEnv.getHtmlLabelName(21828,user.getLanguage()),"\\*",DocComInfo.getNoRightCount(whereclause,user),1)+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	//tableInfo = "[<a href='/docs/search/DocSearch.jsp?from=docsubscribe'>"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	//xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
	    xTableToolBarList.set(0,"");
	}
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	//System.out.println(sqlWhere);
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
	}
	//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	TableColumn xTableColumn_DocName = new TableColumn();
	xTableColumn_DocName.setColumn("docsubject");
	xTableColumn_DocName.setDataIndex("docsubject");
	xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
	xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId");
	xTableColumn_DocName.setPara_1("column:id");
	//xTableColumn_DocName.setPara_2(userInfoForotherpara);
	xTableColumn_DocName.setPara_2(userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount");
	xTableColumn_DocName.setTarget("_fullwindow");
	//xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
	xTableColumn_DocName.setLinkkey("id");
	xTableColumn_DocName.setSortable(true);
	xTableColumn_DocName.setWidth(0.22);
	xTableColumnList.add(xTableColumn_DocName);
	if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
	     //System.out.println("sqlwhere new  is "+sqlWhere);
	     tabletype="checkbox";
	     tableInfo="";
	     //xTableToolBarList.set(0,"");
	     colString ="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
	     colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" otherpara=\"column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		xTableColumnList.clear();
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
		
		TableColumn xTableColumn_DocName3=new TableColumn();
		xTableColumn_DocName3.setColumn("docsubject");
		xTableColumn_DocName3.setDataIndex("docsubject");
		xTableColumn_DocName3.setHeader(SystemEnv.getHtmlLabelName(
				58, user.getLanguage()));
		xTableColumn_DocName3
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew");
		xTableColumn_DocName3.setPara_1("column:id");
		xTableColumn_DocName3.setPara_2("column:docsubject");
		xTableColumn_DocName3.setTarget("_fullwindow");
		//xTableColumn_DocName3.setHref("/docs/docs/DocDsp.jsp");
		xTableColumn_DocName3.setLinkkey("id");
		xTableColumn_DocName3.setSortable(true);
		xTableColumn_DocName3.setWidth(0.22);
		xTableColumnList.add(xTableColumn_DocName3);
	}
	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
	String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
	String operateString = "";
	if (UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0) 
	{
		operateString= "<operates width=\"20%\">";
	       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\"  otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
	       operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
	       operateString+="     <operate href=\"javascript:doDocDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
	       operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
	       operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
	       operateString+="</operates>";
	
		xTableOperatePopedom.setTransmethod("weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2");
		xTableOperatePopedom.setOtherpara(popedomOtherpara);
		xTableOperatePopedom.setOtherpara2(popedomOtherpara2);
		
		TableOperation xTableOperation_Edit = new TableOperation();
		xTableOperation_Edit.setHref("/docs/docs/DocEdit.jsp");
		xTableOperation_Edit.setLinkkey("id");
		xTableOperation_Edit.setLinkvaluecolumn("id");
		xTableOperation_Edit.setText(SystemEnv.getHtmlLabelName(93,user.getLanguage()));
		xTableOperation_Edit.setTarget("_fullwindow");
		xTableOperation_Edit.setIndex("1");
		xTableOperationList.add(xTableOperation_Edit);
	
		TableOperation xTableOperation_Del = new TableOperation();
		xTableOperation_Del.setHref("javascript:doDocDel()");
		xTableOperation_Del.setText(SystemEnv.getHtmlLabelName(91, user.getLanguage()));
		xTableOperation_Del.setTarget("_fullwindow");
		xTableOperation_Del.setIndex("2");
		xTableOperationList.add(xTableOperation_Del);
	
		TableOperation xTableOperation_Share = new TableOperation();
		xTableOperation_Share.setHref("javascript:doDocShare()");
		xTableOperation_Share.setText(SystemEnv.getHtmlLabelName(119,user.getLanguage()));
		xTableOperation_Share.setTarget("_fullwindow");
		xTableOperation_Share.setIndex("3");
		xTableOperationList.add(xTableOperation_Share);
	
		TableOperation xTableOperation_Log = new TableOperation();
		xTableOperation_Log.setHref("javascript:doDocViewLog()");
		xTableOperation_Log.setText(SystemEnv.getHtmlLabelName(83, user.getLanguage()));
		xTableOperation_Log.setTarget("_fullwindow");
		xTableOperation_Log.setIndex("4");
		xTableOperationList.add(xTableOperation_Log);
	}

	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;    
	}
	if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
	      dspcreater = true ;
	      //backFields+="ownerid,doccreaterid,t1.usertype,";
	      backFields+="ownerid,t1.usertype,";
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
		TableColumn xTableColumn_OwnerId = new TableColumn();
		xTableColumn_OwnerId.setColumn("ownerid");
		xTableColumn_OwnerId.setDataIndex("ownerid");
		xTableColumn_OwnerId.setHeader(SystemEnv.getHtmlLabelName(79, user.getLanguage()));
		xTableColumn_OwnerId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
		xTableColumn_OwnerId.setPara_1("column:ownerid");
		xTableColumn_OwnerId.setPara_2("column:usertype");
		xTableColumn_OwnerId.setSortable(true);
		xTableColumn_OwnerId.setWidth(0.08);
		xTableColumnList.add(xTableColumn_OwnerId);
	}
	if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
	    dspcreatedate = true ;
	    backFields+="doccreatedate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
		TableColumn xTableColumn_DocCreateDate = new TableColumn();
		xTableColumn_DocCreateDate.setColumn("doccreatedate");
		xTableColumn_DocCreateDate.setDataIndex("doccreatedate");
		xTableColumn_DocCreateDate.setHeader(SystemEnv.getHtmlLabelName(722, user.getLanguage()));
		xTableColumn_DocCreateDate.setSortable(true);
		xTableColumn_DocCreateDate.setWidth(0.1);
		xTableColumnList.add(xTableColumn_DocCreateDate);
	}
	if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
	    dspmodifydate = true ;
	    //backFields+="doclastmoddate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
		TableColumn xTableColumn_DocLastModDate = new TableColumn();
		xTableColumn_DocLastModDate.setColumn("doclastmoddate");
		xTableColumn_DocLastModDate.setDataIndex("doclastmoddate");
		xTableColumn_DocLastModDate.setHeader(SystemEnv.getHtmlLabelName(723, user.getLanguage()));
		xTableColumn_DocLastModDate.setSortable(true);
		xTableColumn_DocLastModDate.setWidth(0.1);
		xTableColumnList.add(xTableColumn_DocLastModDate);
	}
	if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
	    dspcategory = true ;
	    backFields+="maincategory,";
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
		TableColumn xTableColumn_Maincate=new TableColumn();
		xTableColumn_Maincate.setColumn("maincategory");
		xTableColumn_Maincate.setDataIndex("maincategory");
		xTableColumn_Maincate.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllDirName");
		xTableColumn_Maincate.setPara_1("column:id");
		xTableColumn_Maincate.setHeader(SystemEnv.getHtmlLabelName(92,user.getLanguage()));
		xTableColumn_Maincate.setSortable(true);
		xTableColumn_Maincate.setWidth(0.14); 
		xTableColumnList.add(xTableColumn_Maincate);
	}
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields+="replaydoccount,";
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
		TableColumn xTableColumn_Replaydoccount=new TableColumn();
		xTableColumn_Replaydoccount.setColumn("replaydoccount");
		xTableColumn_Replaydoccount.setDataIndex("replaydoccount");
		xTableColumn_Replaydoccount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
		xTableColumn_Replaydoccount.setPara_1("column:id");
		xTableColumn_Replaydoccount.setPara_2("column:replaydoccount");
		xTableColumn_Replaydoccount.setHeader(SystemEnv.getHtmlLabelName(18470,user.getLanguage()));
		xTableColumn_Replaydoccount.setSortable(false);
		xTableColumn_Replaydoccount.setWidth(0.06); 
		xTableColumnList.add(xTableColumn_Replaydoccount);
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields+="accessorycount,";
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
		TableColumn xTableColumn_AccessoryCount = new TableColumn();
		xTableColumn_AccessoryCount.setColumn("accessorycount");
		xTableColumn_AccessoryCount.setDataIndex("accessorycount");
		xTableColumn_AccessoryCount.setHeader(SystemEnv.getHtmlLabelName(2002, user.getLanguage()));
		xTableColumn_AccessoryCount.setSortable(true);
		xTableColumn_AccessoryCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_AccessoryCount);
	}
	
	backFields+="sumReadCount,docstatus,sumMark";
	
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		TableColumn xTableColumn_SumReadCount = new TableColumn();
		xTableColumn_SumReadCount.setColumn("sumReadCount");
		xTableColumn_SumReadCount.setDataIndex("sumReadCount");
		xTableColumn_SumReadCount.setHeader(SystemEnv.getHtmlLabelName(18469, user.getLanguage()));
		xTableColumn_SumReadCount.setSortable(true);
		xTableColumn_SumReadCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_SumReadCount);
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		TableColumn xTableColumn_SumMark = new TableColumn();
		xTableColumn_SumMark.setColumn("sumMark");
		xTableColumn_SumMark.setDataIndex("sumMark");
		xTableColumn_SumMark.setHeader(SystemEnv.getHtmlLabelName(15663, user.getLanguage()));
		xTableColumn_SumMark.setSortable(true);
		xTableColumn_SumMark.setWidth(0.05);
		xTableColumnList.add(xTableColumn_SumMark);
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
		colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";
		TableColumn xTableColumn_DocStatus = new TableColumn();
		xTableColumn_DocStatus.setColumn("docstatus");
		xTableColumn_DocStatus.setDataIndex("docstatus");
		xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(602, user.getLanguage()));
		//xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus2");
		xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
		xTableColumn_DocStatus.setPara_1("column:id");
		//xTableColumn_DocStatus.setPara_2(""+user.getLanguage());
		xTableColumn_DocStatus.setPara_2(""+user.getLanguage()+"+column:docstatus+column:seccategory");
		xTableColumn_DocStatus.setSortable(true);
		xTableColumn_DocStatus.setWidth(0.05);
		xTableColumnList.add(xTableColumn_DocStatus);
	}
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	//System.out.println("sqlWhere is "+sqlWhere);
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		    sqlFrom=" (select * from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a ,(select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b ";        
		    sqlWhere=" a.id=b.docid(+) and b.docid is  null) table1";
		    backFields="table1.*";
	    } else {
	        sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		    sqlWhere=" b.docid is  null";
		    backFields="*";
	    }
	} 
	//虚拟目录
	if(showtype==3){
		primarykey="id";
	  
		sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from DocDummyDetail where catelogid="+Util.getIntValue(treeDocFieldId,0)+") b on a.id=b.docid ";
		sqlWhere=" b.docid is  null";
		backFields="*";
		tableInfo="";
		xTableToolBarList.set(0,"");
	}
	
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	
	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+=operateString;
    tableString+="</table>";     
       
	xTableSql.setBackfields(backFields);
	xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("true");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy);
       
}       
%>
<BODY>   
<%
//判读是否在文档子目录的自定义列表中设置查询条件
    boolean isUseCondition=false;
	if(Util.getIntValue(DocSearchComInfo.getSeccategory(),0)>0){
		RecordSet.executeSql("select 1 from DocSecCategoryCusSearch where secCategoryId="+DocSearchComInfo.getSeccategory()+" and isCond='1' ");
		if(RecordSet.next()){
			isUseCondition = true;
		}
	}

%>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	String topButton = "";
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	%>
    <%
    if(userightmenu_self==1){
        //if(isUseCondition){
    		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchCondition(),_self}" ;
    		RCMenuHeight += RCMenuHeightStep ;
        //}

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
	
	    if(displayUsage==0){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(19119,user.getLanguage())+",javascript:location.href='DocSearchView.jsp?isNew="+tisNew+"&date2during="+date2during+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&displayUsage=1&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&showTitle="+showTitle+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&selectedContent="+selectedContent+"',_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;
	    } else {
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(15360,user.getLanguage())+",javascript:location.href='DocSearchView.jsp?isNew="+tisNew+"&date2during="+date2during+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&displayUsage=0&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&showTitle="+showTitle+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&selectedContent="+selectedContent+"',_top} " ;
	        RCMenuHeight += RCMenuHeightStep ;
	    } 
	    
	    
	    //RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='DocSearch.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&treeDocFieldId="+treeDocFieldId+"',_top} " ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='DocSearch.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&treeDocFieldId="+treeDocFieldId+"&date2during="+olddate2during+"',_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	   
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	
	    if (isNew.equals("yes")) {
	         RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:signReaded(),_top} " ;
	         RCMenuHeight += RCMenuHeightStep ;
	    }
    }else{
        //if(isUseCondition){
    		topButton +="{iconCls:'btn_sutra',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onSearchCondition();}},";
	    	topButton +="'-',";
        //}
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
	
	    topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(364, user.getLanguage())+"',handler:function(){location.href='DocSearch.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&treeDocFieldId="+treeDocFieldId+"&date2during="+olddate2during+"';}},";
    	topButton +="'-',";
    	
	    if(displayUsage==0){
		    topButton +="{iconCls:'btn_miniatureDisplay',text:'"+SystemEnv.getHtmlLabelName(19119, user.getLanguage())+"',handler:function(){location.href='DocSearchView.jsp?isNew="+tisNew+"&date2during="+date2during+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&displayUsage=1&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&showTitle="+showTitle+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&selectedContent="+selectedContent+"';}},";
	    	topButton +="'-',";
		    
	    } else {
	        topButton +="{iconCls:'btn_listDisplay',text:'"+SystemEnv.getHtmlLabelName(15360, user.getLanguage())+"',handler:function(){location.href='DocSearchView.jsp?isNew="+tisNew+"&date2during="+date2during+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&showtype="+showtype+"&displayUsage=0&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&showTitle="+showTitle+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&selectedContent="+selectedContent+"';}},";
	    	topButton +="'-',";
	    } 
	    
       
    	topButton +="{iconCls:'btn_first',text:'"+SystemEnv.getHtmlLabelName(18363, user.getLanguage())+"',handler:function(){_table.firstPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_previous',text:'"+SystemEnv.getHtmlLabelName(1258, user.getLanguage())+"',handler:function(){_table.prePage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_next',text:'"+SystemEnv.getHtmlLabelName(1259, user.getLanguage())+"',handler:function(){_table.nextPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_end',text:'"+SystemEnv.getHtmlLabelName(18362, user.getLanguage())+"',handler:function(){_table.lastPage();}},";
		topButton +="'-',";
	
	    if (isNew.equals("yes")) {
	    	topButton +="{iconCls:'btn_signReaded',text:'"+SystemEnv.getHtmlLabelName(18492, user.getLanguage())+"',handler:function(){signReaded();}},";
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
 
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="customconditiondiv"  style='display:none'>
<Form name="DocNewViewForm" method="post">
<input type="hidden" name="operation">
<input type="hidden" name="signValus">
<input type="hidden" name="toView">
<input type="hidden" name="seccategory">
<input type="hidden" name="maincategory">
<input type="hidden" name="subcategory">
<input type="hidden" name="keyword">
<input type="hidden" name="doccreaterid">
<input type="hidden" name="doccreatedatefrom">
<input type="hidden" name="doccreatedateto">
<input type="hidden" name="usertype">
<input type="hidden" name="docno">
<input type="hidden" name="from" value=<%=urlfrom %>>
<input type="hidden" name="isNew" value=<%=tisNew %>>
<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
<table class=ViewForm >
    <colgroup><col width="15%"><col width="35%"><col width="15%"><col width="35%">            
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
		<td class="field" >
		  <input class=InputStyle  type="text" name="docno_s" value="<%=docnotmp%>">
		</td>							 
		<td><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></td>
		<td class="field" >
		  <input class=InputStyle  type="text" name="keyword_s" value="<%=keywordtmp%>">
		</td>
	</tr>
	<tr style="height: 1px"><td class=Line colSpan=4></td></tr>					 
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
		<td align=left class="field">
			
			<button class=calendar type="button" id=SelectDate onClick="getDate(doccreatedatefromspan,doccreatedatefrom_s)"></button>&nbsp;
			<span id=doccreatedatefromspan><%=doccreatedateFromtmp%></span>-&nbsp;&nbsp;
			
			<button class=calendar type="button" id=SelectDate2 onClick="getDate(doccreatedatetospan,doccreatedateto_s)"></button>&nbsp;
			<span id=doccreatedatetospan><%=doccreatedateTotmp%></span>
			<input type="hidden" id="doccreatedatefrom_s" name="doccreatedatefrom_s" value="<%=doccreatedateFromtmp%>">
		    <input type="hidden" id="doccreatedateto_s" name="doccreatedateto_s" value="<%=doccreatedateTotmp%>">
		</td>
		<td height=22><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
		<td class="field">
		  <%if(loginType.equals("1")){ %>
		  <%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:
		  <button class=Browser type="button"  onClick="onShowResource('doccreateridspan','doccreaterid_s',1)"></button>
		  <span id=doccreateridspan>
		  <%if("1".equals(usertypetmp) && !"".equals(doccreateridtmp)){%>
			 <%=Util.toScreen(ResourceComInfo.getResourcename(doccreateridtmp),user.getLanguage())%>
		  <%}%>
		  </span>
		  <input type="hidden" name="doccreaterid_s" <%if("1".equals(usertypetmp)){%> value="<%=doccreateridtmp%>" <%}%>>
		  <br>
		  <%}%>
		  <%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:
		  <button class=Browser type="button" id=SelectDeparment onClick="onShowParent('doccreaterid2span2','doccreaterid2',1)"></button>
		  <span id=doccreaterid2span2>
		  <%if("2".equals(usertypetmp) && !"".equals(doccreateridtmp)){%>
			 <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(doccreateridtmp),user.getLanguage())%>
		  <%}%>
		  </span>
		  <input type="hidden" name="doccreaterid2" <%if("2".equals(usertypetmp)){%> value="<%=doccreateridtmp%>" <%}%>>
		  <input type="hidden" name="usertype_s" value="<%=usertypetmp%>">
		</td>
	 </tr>
	 <tr style="height: 1px"><td class=Line colSpan=4></td></tr>
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
	    <td colSpan=2> 
<%
	if(isUseCondition){
%>
<div align ='right'>
	    <a id="searchAdviceHref"  href="#" onClick="showSearchAdvice('advicedSearchDiv')"><img name="searchAdviceImg" src="/images/down_wev8.png" align=absMiddle><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></a></div>

<%
	}
%></td>
     </tr>
     <tr style="height: 1px"><td class=Line colSpan=4></td></tr>
     <%} %>
</table>
					

<div id='advicedSearchDiv' style='display:none'>
<jsp:include page="/docs/search/DocSearchCondition.jsp" flush="true">
	<jsp:param name="secCategoryId" value="<%=DocSearchComInfo.getSeccategory()%>" />
</jsp:include>
</div>


</Form>

</div>
<TABLE width=100% height=96% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<TD valign="top">
		<TABLE>	 		
         <TR>
			<TD valign="top">
					<div id="divContent">
					<%-- edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 --%>
					<% if(displayUsage==0){ 
							if(tabletype =="checkbox")
							{
								xTable.setTableGridType(TableConst.CHECKBOX);
							}
							else
							{
								xTable.setTableGridType(TableConst.NONE);
							}
							xTable.setTableNeedRowNumber(true);												
							xTable.setTableSql(xTableSql);
							xTable.setTableColumnList(xTableColumnList);
							xTable.setTableOperatePopedom(xTableOperatePopedom);
							xTable.setTableOperationList(xTableOperationList);
							xTable.setUser(user);

							String xTableToolBar = "";
							
							for(int i=0;i<xTableToolBarList.size();i++){
							
								if("".equals(xTableToolBarList.get(0))){
									break;
								}
								if(!"".equals(xTableToolBarList.get(i)))
									xTableToolBar+=xTableToolBarList.get(i).toString()+",'|',";
								
							}
							if(!xTableToolBar.equals("")){
								xTableToolBar = xTableToolBar.substring(0,xTableToolBar.length()-5);
							}
							xTableToolBar="["+xTableToolBar+"]";
							
							xTable.setTbar(xTableToolBar);
							
														
					%>		
						<%=xTable.toString2("_table") %> 						
					<% } else { %>
							
							<wea:SplitPageTag  tableString='<%=tableString%>'   mode="run" tableInfo="<%=tableInfo%>" isShowThumbnail="1" imageNumberPerRow="5"/>
					<% }%> 
				
					</div>
                <%-- edited by wdl end --%>
              </TD>  
         </TR>      
         </TABLE>
    </TD>
    <td ></td>
</TR>
</TABLE>
</BODY>
</HTML>



<%! 
private String getFilterBackFields(String oldbf,String addedbfs){
    String[] bfs = Util.TokenizerString2(addedbfs,",");
    String bf = "";
    for(int i=0;bfs!=null&&bfs.length>0&&i<bfs.length;i++){
        bf = bfs[i];
        if(oldbf.indexOf(","+bf+",")==-1){
            if(oldbf.endsWith(",")) oldbf+=bf+",";
            else oldbf+=","+bf+",";
        }
    }
    return oldbf;
}
%>


<Div id="divDummy" width="300px" height="160px" style='border:1px solid #CDCDCD;display:none;width:300px;height:160px;background-color:#FFFFFF;overflow:auto'>
<TABLE  style='width:100%;' cellspacing='0' cellpadding='0' valign='top'>
			<TR>
				<TD  style='background-color:#999999;color:#FFFFFF;height:24px'><div style='width:87%;float:left'>&nbsp;<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%></div> <div><a href='javaScript:onCloseImport()'>[<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>]</a></div></TD>
		   </TR>	
			<TR><TD id='tdContent'>
			 <table class='viewform' id='tblSetting' cellspacing='0' cellpadding='0' class='ViewForm' valign='top'>
				 	 <TR >
					  <TD  style='height:20px;width:30%'>&nbsp;<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></TD>
					  <TD class='field' style='height:20px;width:70%'><button class=Browser type="button" onClick="onShowMutiDummy($GetEle('txtDummy'),$GetEle('spanDummy'))"></button> <input type="hidden" id="txtDummy"  name="txtDummy"><span id="spanDummy"></span></TD>
					</TR>
					<TR colspan='2' style="height: 1px"><TD  CLASS='line'></TD></TR>						
				</table>
				<br>


				<table class='viewform' id='tblUploading' cellspacing='0' cellpadding='0' valign='top' style='display:none;text-align:center'>
				 <TR>
					<TD id="tdUploading">
						<img src="/images/loading_wev8.gif">&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...	
					</TD>				   
				 </TR>
			 </table>
			
			</TD></TR>
	</TABLE>
</TD>  
</TR>      
</TABLE>
</Div>


<!--
虚拟目录ids txtDummy
SQL语句  txtSql
文档ids   txtDocs
状态  txtStatus  1:被选的文档  2:SQL字符串
-->
<input type="hidden" id="txtSql"  name="txtSql">
<input type="hidden" id="txtDocs"  name="txtDocs">
<input type="hidden" id="txtStatus"  name="txtStatus">

<script language="javaScript">

_isViewPort=true;
_pageId="ExtDocSearch";
_defaultSearchStatus='show';  //close //show //more	
_divSearchDiv='customconditiondiv'; 
_divSearchDivHeight=160;

function onSearchCondition(){
	DocNewViewForm.action="/docs/search/DocSearchTemp.jsp";
    DocNewViewForm.toView.value=1; 
	DocNewViewForm.maincategory.value="<%=maincategory%>";
    DocNewViewForm.subcategory.value="<%=subcategory%>";
	DocNewViewForm.seccategory.value="<%=seccategory%>";
	
	try{
		if($GetEle("docno_s").value+"" != "0"){
		    DocNewViewForm.docno.value=$GetEle("docno_s").value;
		}
		if($GetEle("keyword_s").value+"" != "0"){
		    DocNewViewForm.keyword.value=$GetEle("keyword_s").value;
		}
		if($GetEle("doccreatedatefrom_s").value+"" != "0"){
		    DocNewViewForm.doccreatedatefrom.value=$GetEle("doccreatedatefrom_s").value;
		}
		if($GetEle("doccreatedateto_s").value+"" != "0"){
		    DocNewViewForm.doccreatedateto.value=$GetEle("doccreatedateto_s").value;
		}
		if($GetEle("usertype_s").value+"" != "0"){
		    DocNewViewForm.usertype.value=$GetEle("usertype_s").value;
		}	

		if($GetEle("doccreaterid_s").value+"" != "0"&&$GetEle("doccreaterid_s").value+"" != ""){
		    DocNewViewForm.doccreaterid.value=$GetEle("doccreaterid_s").value;
		}
		if($GetEle("doccreaterid2").value+"" != "0"&&$GetEle("doccreaterid2").value+"" != ""){
			DocNewViewForm.doccreaterid.value = $GetEle("doccreaterid2").value;
		}
    }catch(e){}
    
    DocNewViewForm.submit();    
}

function showSearchAdvice(obj){
	var customSearch = false;
	var baseDiv = 160;
	var basePanel = 140;
	var baseRow = 23;
	var rowCount=0;
	var searchPanel = panelTitle.findById('searchPanel');
	if(Ext.getDom("advicedSearchDiv").style.display=='none'){
		Ext.getDom("advicedSearchDiv").style.display='';
		document.searchAdviceImg.src = '/images/up_wev8.png';
		if(customSearch){
			_divSearchDivHeight=baseDiv+baseRow*rowCount;	
			if(_divSearchDivHeight>450){
				_divSearchDivHeight = 450;
				if(userightmenu_self!=1){
					searchPanel.setHeight(400-25);
				}else{
					searchPanel.setHeight(400);
				}
			}else{
				if(userightmenu_self!=1){
					searchPanel.setHeight(basePanel+baseRow*rowCount-60);
				}else{
					searchPanel.setHeight(basePanel+baseRow*rowCount);
				}
			}
		}else{
			_divSearchDivHeight=baseDiv;
			
			if(userightmenu_self!=1){	
				_divSearchDivHeight=_divSearchDivHeight+25;
				searchPanel.setHeight(basePanel-15);
			}else{
				searchPanel.setHeight(basePanel);
			}
		}
	}else{
		Ext.getDom("advicedSearchDiv").style.display='none';
		document.searchAdviceImg.src = '/images/down_wev8.png';
		if(userightmenu_self!=1){	
			_divSearchDivHeight=160;
			searchPanel.setHeight(95);
		}else{
			_divSearchDivHeight=130;
			searchPanel.setHeight(95);
		}
	}
	//var row = obj.parentNode.parentNode;
	//row.parentNode.removeChild(row);
	
	if(_divSearchDivHeight>450){
		_divSearchDivHeight = 450;
	}
	
	panelTitle.setHeight(_divSearchDivHeight);
	panelTitle.doLayout();		
	viewport.doLayout();
}

   userightmenu_self = '<%=userightmenu_self%>';

	if(userightmenu_self!=1){
		_divSearchDivHeight=170;
		divSearchHeight = 61
		<%if(userightmenu_self!=1){%>
			eval(rightMenuBarItem = <%=topButton%>);
		<%}%>
	}
	
	//_isViewPort=true;
	//_pageId="DocSearchView";  
	//_divSearchDiv='aa';
	
   function initToDummy(){
	   var pTop= document.body.offsetHeight/2+document.body.scrollTop-100;
	   var pLeft= document.body.offsetWidth/2-180;
		
		divDummy.style.position="absolute"
		divDummy.style.top=pTop;
		divDummy.style.left=pLeft;
		divDummy.style.display="";

   }
   function importSelectedToDummy(){ 
   		//alert(tableJson);
   		//_table.getCheckBoxValue();
   		//alert(_table._xtable_CheckedCheckboxId());
   		if(<%=displayUsage%> == 0)
   		{
			txtDocs.value=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			txtDocs.value=_xtable_CheckedCheckboxId();
		}
		if(txtDocs.value=="") {
			alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
		} else {
			initToDummy();
			txtStatus.value=1;   
		}
	}
		

   function importAllToDummy(){ 
		initToDummy(); 
		txtStatus.value=2;
		txtSql.value="<%=sqlWhere%>"		
		
   }
   function onCloseImport(){
	   tblSetting.style.display='';
	   tblUploading.style.display='none';
	   divDummy.style.display='none';
   }

   function showMsg(txt){		
		tdUploading.innerHTML=txt;
   }

   function onImporting(){
	     tblSetting.style.display='none';
	   tblUploading.style.display='';


	    var importHttp ;	
	    try{
	    	importHttp =new ActiveXObject("Microsoft.XMLHTTP");	  
	    }catch(e){
	    	importHttp =new XMLHttpRequest(); 
	    }  
		var actionUrl="DocUpToDummy.jsp?method=add&txtDummy="+txtDummy.value+"&txtSql="+txtSql.value+"&txtDocs="+txtDocs.value+"&txtStatus="+txtStatus.value;		
		//document.write(actionUrl)
		//alert(actionUrl);
		importHttp.open("get",actionUrl, true);
		//alert(importHttp.readyState);   
		importHttp.onreadystatechange = function () {	
			switch (importHttp.readyState) {			   
			   case 4 : 
				    var txt=importHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");;					
					if(txt=="success") {
						//this.onCloseImport();
						onCloseImport();
					} else {
						//this.showMsg(txt)
						showMsg(txt);
					}					 
			} 
		}	
		
		importHttp.setRequestHeader("Content-Type","text/xml")	

		importHttp.send(null);	
		
   }

   function onShowResource(tdname,inputename,objtmp){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
		if (data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
			document.all("usertype_s").value="1"
           
			if(objtmp == 2){
			}else{
				document.all("doccreaterid2span2").innerHTML = ""
				document.all("doccreaterid2").value = "0"
			}

		}else{
			document.all(tdname).innerHTML = ""
			document.all(inputename).value=""
			document.all("usertype_s").value=""
		}
	}
   }
   function onShowParent(tdname,inputename,objtmp){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (data){
		if (data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
			document.all("usertype_s").value="2"

           if(objtmp == 2){
           }else{
				document.all("doccreateridspan").innerHTML = ""
				document.all("doccreaterid_s").value = ""
           }

		}else{
			document.all(tdname).innerHTML = ""
			document.all(inputename).value=""
			document.all("usertype_s").value=""
		}
	}
   }
   function onShowMutiDummy(input,span){	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
	//msgbox("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
	
	if (data){
		if (data.id!=""){
			dummyidArray=data.id.split(",");
			dummynames=data.name.split(",");
			var sHtml="";
			for(var k=0;k<dummyidArray.length;k++){
				
				if(dummyidArray[k]!=""){
					sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a><br>"
				}
			} 

			if (sHtml!=""){
				sHtml=sHtml+"<input type=button  value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>' onclick='onImporting()'>"
			}
			
			input.value=data.id
			span.innerHTML=sHtml
		}else{			
			input.value=""
			span.innerHTML=""
		}
	}
   }
</script>


<script language="javaScript">
	var docid;
    function onSearch(){
        frmSearch.submit();    
    }

    function doDocDel(docid){
        if (isdel()){
        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        	
        	Ext.Ajax.request({
        		url : '/docs/docs/DocDwrProxy.jsp' , 
				params : {},
				url : url ,
				method: 'POST',
				success: function ( result, request) {
					alert(result.responseText.trim());
       				//Ext.Msg.alert('Status', result.responseText.trim());
       				_table.reLoad();
				},
				failure: function ( result, request) { 
					Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
				} 
			});
        }
    }

    function doDocShare(docid){        
		var DocSharePane=new DocShareSnip(docid,true).getGrid();
		
        var winShare = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.share,
	        items: DocSharePane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	        	winShare.hide();
	            }
	        }]
	    });
        winShare.show(null);
        //var url = "/docs/docs/DocOperate.jsp?operation=share&docid="+docid;
        //openFullWindowHaveBar(url);
    }

    function doDocViewLog(docid){
    	
    	var DocDetailLogPane=getDocDetailLogPane(docid,500,300,false);
		
        var winLog = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.detailLog,
	        items: DocDetailLogPane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	                 winLog.hide();
	            }
	        }]
	    });
	    winLog.show(null);    
       
    }
    function signReaded(){
        var signReadIds = "";
        if(<%=displayUsage%> == 0)
   		{
			signReadIds=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			signReadIds = _xtable_CheckedCheckboxId();
		}  
        if (signReadIds==""){
            alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
            return ;
        }
        document.DocNewViewForm.action="/docs/search/DocSearchOperation.jsp";
        document.DocNewViewForm.operation.value="signReaded";        
       
		document.DocNewViewForm.signValus.value=signReadIds;
        document.DocNewViewForm.submit();
    }
	function treeView(){
		document.parentWindow.parent.location.href="/docs/search/DocSummary.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
	}
	function viewbyOrganization(){
		document.parentWindow.parent.location.href="/docs/search/DocSummary.jsp?showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
	}
	function sutraView(){
		document.parentWindow.parent.location.href="/docs/search/DocSummary.jsp?showtype=0&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>";
	}

    function viewByTreeDocField(){
		document.parentWindow.parent.location.href="/docs/search/DocSummary.jsp?showtype=3";
    }   
</script>

<script language="javaScript">
 var displayUsage="<%=displayUsage%>";
</script>
<script type='text/javascript' src='/js/WeaverTablePlugins_wev8.js'></script>
<script type="text/javascript" src="/js/doc/DocSearchView_wev8.js"></script>
<script type="text/javascript" src="/js/doc/DocShareSnip_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>

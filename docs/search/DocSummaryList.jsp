
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%
if(true){
	response.sendRedirect("/docs/search/DocMain.jsp?urlType=6&"+request.getQueryString());
	return;
}
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);

int showDocs = Util.getIntValue(request.getParameter("showDocs"),0);

String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0"))maincategory="";

String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0"))subcategory="";

String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0"))seccategory="";

//User user = HrmUserVarify.getUser(request,response);
String logintype = user.getLogintype();

String isNew = Util.null2String(request.getParameter("isNew"));

int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String showtypedisplayUsageFromAdvancedMenuInfoId=Util.null2String(request.getParameter("showtype_displayUsage_fromadvancedmenu_infoId_selectedContent"));
if(!showtypedisplayUsageFromAdvancedMenuInfoId.equals("")){
	String tmppara[] = Util.TokenizerString2(showtypedisplayUsageFromAdvancedMenuInfoId,"_");
	showtype = Util.getIntValue(tmppara[0],0);
	displayUsage = Util.getIntValue(tmppara[1],0);
	fromAdvancedMenu = Util.getIntValue(tmppara[2],0);
	infoId = Util.getIntValue(tmppara[3],0);
	if(tmppara.length>4)
	{
		selectedContent = Util.null2String(tmppara[4]);
	}
}

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
selectArr+="|";
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

if(showDocs==1||!"".equals(seccategory)){
	
	DocSearchComInfo.resetSearchInfo();

	DocSearchComInfo.setContainreply("");
	DocSearchComInfo.setDocsubject("");
	DocSearchComInfo.setDoccontent("");

	DocSearchComInfo.setMaincategory(maincategory);
	
	DocSearchComInfo.setSubcategory(subcategory);
	
	DocSearchComInfo.setSeccategory(seccategory);

	DocSearchComInfo.setDocid("");
	DocSearchComInfo.setDoccreaterid("");
	DocSearchComInfo.setDocdepartmentid("");
	DocSearchComInfo.setDoclanguage("");
	DocSearchComInfo.setHrmresid("");
	DocSearchComInfo.setItemid("");
	DocSearchComInfo.setItemmaincategoryid("");
	DocSearchComInfo.setCrmid("");
	DocSearchComInfo.setProjectid("");
	DocSearchComInfo.setFinanceid("");
	DocSearchComInfo.setUsertype("");
	DocSearchComInfo.setUserID(""+user.getUID());
	DocSearchComInfo.setIsreply("") ;
	DocSearchComInfo.setIsNew(isNew) ;
	DocSearchComInfo.setIsMainOrSub("") ;
	DocSearchComInfo.setLoginType("") ;
	DocSearchComInfo.setNoRead("") ;
	DocSearchComInfo.addDocstatus("1");
	DocSearchComInfo.addDocstatus("2");
	DocSearchComInfo.addDocstatus("5");
	DocSearchComInfo.addDocstatus("7");
	DocSearchComInfo.setKeyword("");
	DocSearchComInfo.setOwnerid("");
	DocSearchComInfo.setDocno("");
	DocSearchComInfo.setDoclastmoddateFrom("");
	DocSearchComInfo.setDoclastmoddateTo("");
	DocSearchComInfo.setDocarchivedateFrom("");
	DocSearchComInfo.setDocarchivedateTo("");
	DocSearchComInfo.setDoccreatedateFrom("");
	DocSearchComInfo.setDoccreatedateTo("");
	DocSearchComInfo.setDocapprovedateFrom("");
	DocSearchComInfo.setDocapprovedateTo("");
	DocSearchComInfo.setReplaydoccountFrom("");
	DocSearchComInfo.setReplaydoccountTo("");
	DocSearchComInfo.setAccessorycountFrom("");
	DocSearchComInfo.setAccessorycountTo("");
	DocSearchComInfo.setDoclastmoduserid("");
	DocSearchComInfo.setDocarchiveuserid("");
	DocSearchComInfo.setDocapproveuserid("");
	DocSearchComInfo.setAssetid("");
	DocSearchComInfo.setCustomSqlWhere("");
	
	response.sendRedirect("DocSearchView.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&showDocs="+showDocs+"&showTitle=1&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&selectedContent="+selectedContent+"&isNew="+isNew);
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "";
String tseccategory = seccategory;
String tsubcategory = subcategory;
String tmaincategory = maincategory;
String tmaincategoryname = "";
String tsubcategoryname ="";
String tseccategoryname="";
if(!"".equals(tseccategory)) tsubcategory = SecCategoryComInfo.getSubCategoryid(tseccategory);
if(!"".equals(tsubcategory)) tmaincategory = SubCategoryComInfo.getMainCategoryid(tsubcategory);
if(!"".equals(tmaincategory)){
	tmaincategoryname = MainCategoryComInfo.getMainCategoryname(tmaincategory);
	tmaincategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&maincategory="+tmaincategory + "&selectedContent="+selectedContent+"\">" + tmaincategoryname + "</a>";
}
if(!"".equals(tsubcategory)){
	tsubcategoryname = SubCategoryComInfo.getSubCategoryname(tsubcategory);
	tsubcategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&subcategory="+tsubcategory + "&selectedContent="+selectedContent+"\">" + tsubcategoryname + "</a>";
}
if(!"".equals(tseccategory)){
	tseccategoryname = SecCategoryComInfo.getSecCategoryname(tseccategory);
	tseccategoryname = "<a href=\"DocSummaryList.jsp?showtype="+showtype+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&seccategory="+tseccategory + "&selectedContent="+selectedContent+"\">" + tseccategoryname + "</a>";
}
titlename = tmaincategoryname;
if(tsubcategory!=null&&!"".equals(tsubcategory)) titlename+= " > ";
titlename += tsubcategoryname;
if(tseccategory!=null&&!"".equals(tseccategory)) titlename+= " > ";
titlename += tseccategoryname;
if("".equals(titlename)) titlename=SystemEnv.getHtmlLabelName(65,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(19254,user.getLanguage())+",javascript:sutraView();,_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19466,user.getLanguage())+",javascript:viewbyOrganization(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(displayUsage==0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19119,user.getLanguage())+",javascript:location.href='DocSummaryList.jsp?displayUsage=1&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&selectedContent="+selectedContent+"',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}else if(displayUsage==1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(15360,user.getLanguage())+",javascript:location.href='DocSummaryList.jsp?displayUsage=0&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&selectedContent="+selectedContent+"',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
	
			<FORM id=weaver name=frmmain action=DocSummaryList.jsp method=post >
			
			<!--目录列表部分-->
			<%
	       	 	String andSql = "";
	            
	            //得到pageNum 与 perpage
	            int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
	            int perpage = UserDefaultManager.getNumperpage();
	            if(perpage <2) perpage=15;
	
	            //设置好搜索条件
	            String backFields ="";
	            String fromSql = "";
	            String sqlWhere = "";
	            String orderBy="";
	            String tableString="";
	            String linkkeyStr="";
			
				backFields ="id,categoryname,type,parent,doccount,categoryorder";
				if("".equals(maincategory)&&"".equals(subcategory)&&"".equals(seccategory)){//列出主目录
					if(logintype.equals("1")) //内部用户的处理
			            fromSql = " ( " +
								  " select id,categoryname,0 as type,0 as parent,categoryorder " +
								  " from DocMainCategory " +
								  " ) a inner join " +
								  " ( " +
								  " select t1.maincategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.maincategory!=0 " +
								  " and t1.subcategory!=0 " +
								  " and t1.seccategory!=0 " +
								  " and t1.id=t2.sourceid " +
								  (((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))?
								  " and t1.maincategory in (" + inMainCategoryStr + ") "
								  :"") +
								  (((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))?
								  " and t1.subcategory in (" + inSubCategoryStr + ") "
								  :"") +
								  " group by t1.maincategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
					else
			            fromSql = " ( " +
								  " select id,categoryname,0 as type,0 as parent,categoryorder " +
								  " from DocMainCategory " +
								  " ) a inner join " +
								  " ( " +
								  " select t1.maincategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.maincategory!=0 " +
								  " and t1.subcategory!=0 " +
								  " and t1.seccategory!=0 " +
								  " and t1.id=t2.sourceid " +
								  (((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))?
								  " and t1.maincategory in (" + inMainCategoryStr + ") "
								  :"") +
								  (((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))?
								  " and t1.subcategory in (" + inSubCategoryStr + ") "
								  :"") +
								  " group by t1.maincategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
		            linkkeyStr = "maincategory";
				} else if(!"".equals(maincategory)){//列出分目录
					if(logintype.equals("1")) //内部用户的处理
			            fromSql = " ( " +
								  " select id,categoryname,1 as type,maincategoryid as parent,subOrder as categoryorder " +
								  " from DocSubCategory " +
								  " where maincategoryid = " + maincategory +
								  " ) a inner join " +
								  " ( " +
								  " select t1.subcategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.id=t2.sourceid " +
								  " and t1.maincategory = " + maincategory +
								  (((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))?
								  " and t1.maincategory in (" + inMainCategoryStr + ") "
								  :"") +
								  (((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))?
								  " and t1.subcategory in (" + inSubCategoryStr + ") "
								  :"") +
								  " group by t1.subcategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
					else
			            fromSql = " ( " +
								  " select id,categoryname,1 as type,maincategoryid as parent,subOrder as categoryorder " +
								  " from DocSubCategory " +
								  " where maincategoryid = " + maincategory +
								  " ) a inner join " +
								  " ( " +
								  " select t1.subcategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.id=t2.sourceid " +
								  " and t1.maincategory = " + maincategory +
								  (((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))?
								  " and t1.maincategory in (" + inMainCategoryStr + ") "
								  :"") +
								  (((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))?
								  " and t1.subcategory in (" + inSubCategoryStr + ") "
								  :"") +								  
								  " group by t1.maincategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
		            linkkeyStr = "subcategory";
				} else if(!"".equals(subcategory)){//列出子目录
					if(logintype.equals("1")) //内部用户的处理
			            fromSql = " ( " +
								  " select id,categoryname,2 as type,subcategoryid as parent,secOrder as categoryorder " +
								  " from DocSecCategory " +
								  " where subcategoryid = " + subcategory +
								  " ) a inner join " +
								  " ( " +
								  " select t1.seccategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.id=t2.sourceid " +
								  " and t1.subcategory = " + subcategory +
								  " group by t1.seccategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
					else
			            fromSql = " ( " +
								  " select id,categoryname,2 as type,subcategoryid as parent,secOrder as categoryorder " +
								  " from DocMainCategory " +
								  " where subcategoryid = " + subcategory +
								  " ) a inner join " +
								  " ( " +
								  " select t1.maincategory as categoryid,0+count(t1.id) doccount " +
								  " from DocDetail  t1," +
								  tables +
								  " t2 " +
								  " where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) " +
								  " and t1.id=t2.sourceid " +
								  " and t1.subcategory = " + subcategory +
								  " group by t1.seccategory " +
								  " ) b " +
								  " on a.id = b.categoryid " +
								  " where doccount > 0 ";
		            linkkeyStr = "seccategory";
				}
	            sqlWhere = "";
	            orderBy="categoryorder";
	            if(displayUsage==0){
             		tableString="<table pagesize=\""+perpage+"\" tabletype=\"none\">";
	            } else {
             		tableString+="<table pagesize=\""+perpage+"\" tabletype=\"thumbnail\">";
             		tableString+="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"categoryId\" linkvaluecolumn=\"id\" />";
	            }
             	tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
                "<head>"+
                (displayUsage!=1?"<col name=\"id\" width=\"3%\" align=\"center\" text=\" \" column=\"categoryname\" transmethod=\"weaver.splitepage.transform.SptmForCategory.getCategoryIcon\" />":"")+
                "<col width=\"70%\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"categoryname\" orderkey=\"categoryname\" href=\"DocSummaryList.jsp?showtype_displayUsage_fromadvancedmenu_infoId_selectedContent="+showtype+"_"+displayUsage+"_"+fromAdvancedMenu+"_"+infoId+"_"+selectedContent+"\" linkkey=\""+linkkeyStr+"\" linkvaluecolumn=\"id\" target=\"_self\" />"+
                (displayUsage!=1?"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"\" column=\"doccount\" orderkey=\"doccount\" transmethod=\"weaver.splitepage.transform.SptmForCategory.getCategoryDocsNum\" otherpara=\"column:id+column:type\" />":"")+
                "</head>"+
                "</table>";

               %>
                            <% if(displayUsage==0){ %>
                            	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"/>
                            <% } else { %>
                            	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" isShowThumbnail="1" imageNumberPerRow="5"/>
                            <% } %>
            </form>

	</td>
</tr>
</table>
<script language="JavaScript">
function sutraView(){
	window.parent.location.href="/docs/search/DocSummary.jsp?displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewbyOrganization(){
	window.parent.location.href="/docs/search/DocSummary.jsp?showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewByTreeDocField(){
	//jQuery(document)
   window.parent.location.href="/docs/search/DocSummary.jsp?showtype=3";
}

</script>
</body>
</html>

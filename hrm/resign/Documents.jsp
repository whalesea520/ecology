
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.common.Constants"%>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
String id = Util.null2String(request.getParameter("id"));
String userId = "" + user.getUID();
String managerId = ResourceComInfo.getManagerID(id);
if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int userid=Util.getIntValue(request.getParameter("id")) ;
String loginType = "0" ;



//初始化值
String doccreaterid = ""+userid ;
String docstatus = Util.null2String(request.getParameter("docstatus"));
String maincategory = Util.null2String(request.getParameter("maincategory"));
String dspreply = Util.null2String(request.getParameter("dspreply")) ;

if(doccreaterid.equals("")) doccreaterid = ""+user.getUID() ;
if(dspreply.equals("")) dspreply="1";
//页标题
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":" ;
if(user.getLogintype().equals("1"))
	titlename += ResourceComInfo.getResourcename(doccreaterid);
else
    titlename += CustomerInfoComInfo.getCustomerInfoname(doccreaterid);

String needfav ="1";
String needhelp ="";


//  查询设置
DocSearchComInfo.resetSearchInfo() ;
DocSearchComInfo.setDoccreaterid(doccreaterid) ;
DocSearchComInfo.setUsertype(user.getLogintype()) ;
if(!docstatus.equals(""))  DocSearchComInfo.addDocstatus(docstatus) ;
if(!maincategory.equals(""))  DocSearchComInfo.setMaincategory(maincategory) ;

if ("0".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("1".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
else if ("2".equals(dspreply)) DocSearchComInfo.setIsreply("1");  //仅回复
//backFields
String backFields="t1.id,t1.seccategory,doclastmodtime,docsubject,t1.docextendname,";
//from
String sqlFrom = "DocDetail  t1";
//where

String sqlWhere = " where  t1.ownerid="+userid+" and (ishistory is null or ishistory = 0) " ;
//orderBy
String orderBy = "doclastmoddate,doclastmodtime";
//primarykey
String primarykey = "t1.id";
//pagesize
int pagesize = UserDefaultManager.getNumperpage();
if(pagesize <2) pagesize=10;
//colString
String colString ="<col name=\"id\" width=\"10%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
       colString +="<col name=\"id\" width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30041,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" />";


//  用户自定义设置
boolean dspcreater = false ;
boolean dspcreatedate = false ;
boolean dspmodifydate = false ;
boolean dspdocid = false;
boolean dspcategory = false ;
boolean dspaccessorynum = false ;
boolean dspreplynum = false ;




      backFields+="ownerid,";
      colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(83562,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"  otherpara=\""+loginType+"\"/>";


    backFields+="doccreatedate,";
    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(81517,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";

    backFields+="doclastmoddate,";
    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(83563,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";

    //backFields+="maincategory,";
    colString +="<col width=\"15%\"  pkey=\"id+weaver.splitepage.transform.SptmForDoc.getAllDirName\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"secCategory\" orderkey=\"secCategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";

    backFields+="replaydoccount,";
    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(83576,user.getLanguage())+"\" column=\"replaydoccount\" orderkey=\"replaydoccount\"/>";

    backFields+="accessorycount,";
    colString +="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";

backFields+="sumReadCount,docstatus";
colString +="<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(83580,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(25102,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\"/>";

//默认为按文档创建日期排序所以,必须要有这个字段
if (backFields.indexOf("doclastmoddate")==-1) {
    backFields+=",doclastmoddate";
}

String pageId = "HRM_RESIGN_DOCUMENTS" ; 

String tableString="<table  pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"/>";
       tableString+="<head>"+colString+"</head>";

       tableString+="</table>";
%>



<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;"><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
</BODY>
</HTML>
<script language="javaScript">
    function onSearch(){
        frmSearch.submit();
    }

    function doDocDel(docid){
        if (isdel()){
            var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
            openFullWindow1(url);
        }
    }

    function doDocShare(docid){
        var url = "/docs/docs/DocOperate.jsp?operation=share&docid="+docid;
        openFullWindowHaveBar(url);
    }

    function doDocViewLog(docid){
        var url = "/docs/docs/DocOperate.jsp?operation=viewLog&docid="+docid;
        openFullWindowHaveBar(url);
    }
</script>

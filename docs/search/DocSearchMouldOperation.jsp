<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DocSearchMouldManager" class="weaver.docs.search.DocSearchMouldManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.null2String(request.getParameter("opera"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
String newmould=Util.fromScreen(request.getParameter("newmould"),user.getLanguage());
int userid=user.getUID();
int advanced=Util.getIntValue(request.getParameter("advanced"),0);

String docsubject = Util.fromScreen(request.getParameter("docsubject"),user.getLanguage());
String doccontent = Util.fromScreen(request.getParameter("doccontent"),user.getLanguage());
String containreply = Util.fromScreen(request.getParameter("containreply"),user.getLanguage());
int maincategory=Util.getIntValue(request.getParameter("maincategory"),0);
int subcategory=Util.getIntValue(request.getParameter("subcategory"),0);
int seccategory=Util.getIntValue(request.getParameter("seccategory"),0);
int docid=Util.getIntValue(request.getParameter("docid"),0);
int createrid=Util.getIntValue(request.getParameter("doccreaterid"),0);
int createrid2=Util.getIntValue(request.getParameter("doccreaterid2"),0);
int departmentid=Util.getIntValue(request.getParameter("departmentid"),0);
int doclangurage=Util.getIntValue(request.getParameter("doclangurage"),0);
int hrmresid=Util.getIntValue(request.getParameter("hrmresid"),0);
int itemid=Util.getIntValue(request.getParameter("itemid"),0);
int itemmaincategoryid=Util.getIntValue(request.getParameter("itemmaincategoryid"),0);
int crmid=Util.getIntValue(request.getParameter("crmid"),0);
int projectid=Util.getIntValue(request.getParameter("projectid"),0);
int financeid=Util.getIntValue(request.getParameter("financeid"),0);
String docpublishtype=Util.null2String(request.getParameter("docpublishtype"));
if(docpublishtype.equals("")) docpublishtype="0";
String docstatus=Util.null2String(request.getParameter("docstatus"));
if(docstatus.equals("")) docstatus="6";
String keyword=Util.fromScreen(request.getParameter("keyword"),user.getLanguage());
int ownerid=Util.getIntValue(request.getParameter("ownerid"),0);
int ownerid2=Util.getIntValue(request.getParameter("ownerid2"),0);


String docno = Util.fromScreen(request.getParameter("docno"),user.getLanguage());
String doclastmoddatefrom = Util.null2String(request.getParameter("doclastmoddatefrom"));
String doclastmoddateto = Util.null2String(request.getParameter("doclastmoddateto"));
String docarchivedatefrom = Util.null2String(request.getParameter("docarchivedatefrom"));
String docarchivedateto = Util.null2String(request.getParameter("docarchivedateto"));
String doccreatedatefrom = Util.null2String(request.getParameter("doccreatedatefrom"));
String doccreatedateto = Util.null2String(request.getParameter("doccreatedateto"));
String docapprovedatefrom = Util.null2String(request.getParameter("docapprovedatefrom"));
String docapprovedateto = Util.null2String(request.getParameter("docapprovedateto"));
String replaydoccountfrom = Util.null2String(request.getParameter("replaydoccountfrom"));
String replaydoccountto = Util.null2String(request.getParameter("replaydoccountto"));
String accessorycountfrom = Util.null2String(request.getParameter("accessorycountfrom"));
String accessorycountto = Util.null2String(request.getParameter("accessorycountto"));

int doclastmoduserid = Util.getIntValue(request.getParameter("doclastmoduserid"),0);
int docarchiveuserid = Util.getIntValue(request.getParameter("docarchiveuserid"),0);
int docapproveuserid = Util.getIntValue(request.getParameter("docapproveuserid"),0);
int assetid = Util.getIntValue(request.getParameter("assetid"),0);
int treeDocFieldId = Util.getIntValue(request.getParameter("treeDocFieldId"),0);

if(opera.equals("insert") || opera.equals("update") ){

    if(opera.equals("update")) DocSearchMouldManager.setId(mouldid);
	DocSearchMouldManager.setMouldname(newmould);
	DocSearchMouldManager.setUserid(userid);
	DocSearchMouldManager.setDocsubject(docsubject);
	DocSearchMouldManager.setDoccontent(doccontent);
	DocSearchMouldManager.setContainreply(containreply);
	DocSearchMouldManager.setMaincategory(maincategory);
	DocSearchMouldManager.setSubcategory(subcategory);
	DocSearchMouldManager.setSeccategory(seccategory);
	DocSearchMouldManager.setDocid(docid);
	DocSearchMouldManager.setDoccreaterid(createrid);
	DocSearchMouldManager.setDoccreaterid2(createrid2);
	DocSearchMouldManager.setDepartmentid(departmentid);
	DocSearchMouldManager.setDoclangurage(doclangurage);
	DocSearchMouldManager.setHrmresid(hrmresid);
	DocSearchMouldManager.setItemid(itemid);
	DocSearchMouldManager.setItemmaincategoryid(itemmaincategoryid);
	DocSearchMouldManager.setCrmid(crmid);
	DocSearchMouldManager.setProjectid(projectid);
	DocSearchMouldManager.setFinanceid(financeid);
	DocSearchMouldManager.setDocpublishtype(docpublishtype);
	DocSearchMouldManager.setDocstatus(docstatus);
    DocSearchMouldManager.setKeyword(keyword);
    DocSearchMouldManager.setOwnerid(ownerid);
    DocSearchMouldManager.setOwnerid2(ownerid2);

    DocSearchMouldManager.setDocno( docno) ;
    DocSearchMouldManager.setDoclastmoddatefrom( doclastmoddatefrom) ;
    DocSearchMouldManager.setDoclastmoddateto( doclastmoddateto) ;
    DocSearchMouldManager.setDocarchivedatefrom( docarchivedatefrom) ;
    DocSearchMouldManager.setDocarchivedateto( docarchivedateto) ;
    DocSearchMouldManager.setDoccreatedatefrom( doccreatedatefrom) ;
    DocSearchMouldManager.setDoccreatedateto( doccreatedateto) ;
    DocSearchMouldManager.setDocapprovedatefrom( docapprovedatefrom) ;
    DocSearchMouldManager.setDocapprovedateto( docapprovedateto) ;
    DocSearchMouldManager.setReplaydoccountfrom( replaydoccountfrom) ;
    DocSearchMouldManager.setReplaydoccountto( replaydoccountto) ;
    DocSearchMouldManager.setAccessorycountfrom( accessorycountfrom) ;
    DocSearchMouldManager.setAccessorycountto( accessorycountto) ;

    DocSearchMouldManager.setDoclastmoduserid( doclastmoduserid) ;
    DocSearchMouldManager.setDocarchiveuserid( docarchiveuserid) ;
    DocSearchMouldManager.setDocapproveuserid( docapproveuserid) ;
    DocSearchMouldManager.setAssetid( docapproveuserid) ;

    DocSearchMouldManager.setTreeDocFieldId( treeDocFieldId) ;


	if(opera.equals("insert")) {
        int newmouldid = DocSearchMouldManager.insertSearchMould();
        response.sendRedirect("DocSearch.jsp?mouldid="+newmouldid);
    }
    else {
        DocSearchMouldManager.updateSearchMould();
	    response.sendRedirect("DocSearch.jsp?mouldid="+mouldid+"&advanced="+advanced);
    }
}

if(opera.equals("delete")){
	DocSearchMouldManager.setId(mouldid);
	DocSearchMouldManager.deleteSearchMould();
	response.sendRedirect("DocSearch.jsp?mouldid=0");
}

%>
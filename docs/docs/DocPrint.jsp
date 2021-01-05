<%@ page import="weaver.general.Util,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />


<html>
<%
int docid = Util.getIntValue(request.getParameter("id"),0);
int docmouldid = Util.getIntValue(request.getParameter("docmouldid"),0);

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
String docpublishtype=DocManager.getDocpublishtype();
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docsubject=DocManager.getDocsubject();
String doccontent=DocManager.getDoccontent();
int docdepartmentid=DocManager.getDocdepartmentid();
String doccreatedate=DocManager.getDoccreatedate();
String doccreatetime=DocManager.getDoccreatetime();
int doclastmoduserid=DocManager.getDoclastmoduserid();
String doclastmoddate=DocManager.getDoclastmoddate();
String doclastmodtime=DocManager.getDoclastmodtime();
String docapprovedate=DocManager.getDocapprovedate();
String docapprovetime=DocManager.getDocapprovetime();
String docstatus=DocManager.getDocstatus();
int ownerid=DocManager.getOwnerid();
String usertype=DocManager.getUsertype();
String docno = DocManager.getDocno();
int replydocid=DocManager.getReplydocid();


if(docpublishtype.equals("2")){
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1)
		doccontent = doccontent.substring(tmppos+8,doccontent.length());
}

String docstatusname = "" ;

if (docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0)  docstatusname = SystemEnv.getHtmlLabelName(220,user.getLanguage()); 
if (docstatus.equals("1") || docstatus.equals("2")) docstatusname = SystemEnv.getHtmlLabelName(1984,user.getLanguage()) ;
if (docstatus.equals("3")) docstatusname = SystemEnv.getHtmlLabelName(360,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(244,user.getLanguage());
if (docstatus.equals("4")) docstatusname=SystemEnv.getHtmlLabelName(236,user.getLanguage()) ;
if (docstatus.equals("5")) docstatusname=SystemEnv.getHtmlLabelName(251,user.getLanguage());

String tmppublishtype="";
if(docpublishtype.equals("1")) tmppublishtype=SystemEnv.getHtmlLabelName(1984,user.getLanguage());
if(docpublishtype.equals("2")) tmppublishtype=SystemEnv.getHtmlLabelName(227,user.getLanguage());
if(docpublishtype.equals("3")) tmppublishtype=SystemEnv.getHtmlLabelName(229,user.getLanguage());


Hashtable hr = new Hashtable();
hr.put("DOC_MainCategory",MainCategoryComInfo.getMainCategoryname(""+maincategory));
hr.put("DOC_SubCategory",SubCategoryComInfo.getSubCategoryname(""+subcategory));
hr.put("DOC_SecCategory",SecCategoryComInfo.getSecCategoryname(""+seccategory));
hr.put("DOC_Department","<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+docdepartmentid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())+"</a>");
hr.put("DOC_Content",doccontent);
if(usertype.equals("1"))  {
    hr.put("DOC_CreatedBy",Util.toScreen(ResourceComInfo.getFirstname(""+ownerid),user.getLanguage()));
    hr.put("DOC_CreatedByLink","<a href='javaScript:openhrm("+ownerid+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())+"</a>");
    hr.put("DOC_CreatedByFull",Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage()));
}
else {
    hr.put("DOC_CreatedBy",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage()));
    hr.put("DOC_CreatedByLink","<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+ownerid+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())+"</a>");
    hr.put("DOC_CreatedByFull",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage()));
}

hr.put("DOC_CreatedDate",doccreatedate);
hr.put("DOC_DocId",Util.add0(docid,12));
hr.put("DOC_ModifiedBy",Util.toScreen(ResourceComInfo.getFirstname(""+doclastmoduserid),user.getLanguage()));
hr.put("DOC_ModifiedDate",doclastmoddate);
hr.put("DOC_Language",LanguageComInfo.getLanguagename(""+doclangurage));
hr.put("DOC_ParentId",Util.add0(replydocid,12));
hr.put("DOC_Status",docstatusname);
hr.put("DOC_Subject",docsubject);
hr.put("DOC_Publish",tmppublishtype);
hr.put("DOC_ApproveDate",docapprovedate);
hr.put("DOC_NO", docno) ;

int tmpmouldid=docmouldid ;
if(tmpmouldid ==0)
    tmpmouldid = MouldManager.getDefaultMouldId();
MouldManager.setId(tmpmouldid);
MouldManager.getMouldInfoById();
String mouldname= MouldManager.getMouldName();
String mouldtext= MouldManager.getMouldText();
MouldManager.closeStatement();
mouldtext = Util.fillValuesToString(mouldtext,hr);


%>
<body>
<%=mouldtext%>
</body>
</html>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/docs/common.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js">
</script>
</head>
<%

String isrequest = Util.null2String(request.getParameter("isrequest"));    

if(!HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int docid = Util.getIntValue(request.getParameter("id"),0);
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);


char flag=Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int requestid=Util.getIntValue(request.getParameter("requestid"),0);

String requestname="";
int workflowid=0;
int formid=0;
int billid=0;
int nodeid=0;
String nodetype="";
int hasright=0;
String status="";
int creater=0;
int isremark=0;
int operatortype = 0;



DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

//文档信息
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=DocManager.getDocreplyable();
String isreply=DocManager.getIsreply();
int replydocid=DocManager.getReplydocid();
String docsubject=DocManager.getDocsubject();
String doccontent=DocManager.getDoccontent();
String docpublishtype=DocManager.getDocpublishtype();
int itemid=DocManager.getItemid();
int itemmaincategoryid=DocManager.getItemmaincategoryid();
int hrmresid=DocManager.getHrmresid();
int crmid=DocManager.getCrmid();
int projectid=DocManager.getProjectid();
int financeid=DocManager.getFinanceid();
int doccreaterid=DocManager.getDoccreaterid();
int docdepartmentid=DocManager.getDocdepartmentid();
String doccreatedate=DocManager.getDoccreatedate();
String doccreatetime=DocManager.getDoccreatetime();
int doclastmoduserid=DocManager.getDoclastmoduserid();
String doclastmoddate=DocManager.getDoclastmoddate();
String doclastmodtime=DocManager.getDoclastmodtime();
int docapproveuserid=DocManager.getDocapproveuserid();
String docapprovedate=DocManager.getDocapprovedate();
String docapprovetime=DocManager.getDocapprovetime();
int docarchiveuserid=DocManager.getDocarchiveuserid();
String docarchivedate=DocManager.getDocarchivedate();
String docarchivetime=DocManager.getDocarchivetime();
String docstatus=DocManager.getDocstatus();
String parentids=DocManager.getParentids();
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();
String docno = DocManager.getDocno();


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



//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
String subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
String docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
String publishable=Util.null2String(""+RecordSet.getString("publishable"));
String replyable=Util.null2String(""+RecordSet.getString("replyable"));
String shareable=Util.null2String(""+RecordSet.getString("shareable"));
String cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
cusertype = cusertype.trim();
String cuserseclevel=Util.null2String(""+RecordSet.getString("cuserseclevel"));
if(cuserseclevel.equals("255")) cuserseclevel="0";
String cdepartmentid1=Util.null2String(""+RecordSet.getString("cdepartmentid1"));
String cdepseclevel1=Util.null2String(""+RecordSet.getString("cdepseclevel1"));
if(cdepseclevel1.equals("255")) cdepseclevel1="0";
String cdepartmentid2=Util.null2String(""+RecordSet.getString("cdepartmentid2"));
String cdepseclevel2=Util.null2String(""+RecordSet.getString("cdepseclevel2"));
if(cdepseclevel2.equals("255")) cdepseclevel2="0";
String croleid1=Util.null2String(""+RecordSet.getString("croleid1"));
String crolelevel1=Util.null2String(""+RecordSet.getString("crolelevel1"));
String croleid2=Util.null2String(""+RecordSet.getString("croleid2"));
String crolelevel2=Util.null2String(""+RecordSet.getString("crolelevel2"));
String croleid3=Util.null2String(""+RecordSet.getString("croleid3"));
String crolelevel3=Util.null2String(""+RecordSet.getString("crolelevel3"));
String approvewfid=RecordSet.getString("approveworkflowid");
String needapprovecheck="";
if(approvewfid.equals(""))  approvewfid="0";
if(approvewfid.equals("0"))
    needapprovecheck="0";
else
    needapprovecheck="1";
String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
String hasasset=Util.toScreen(RecordSet.getString("hasasset"),user.getLanguage());
String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),user.getLanguage());
String hasitems =Util.toScreen(RecordSet.getString("hasitems"),user.getLanguage());
String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),user.getLanguage());
String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),user.getLanguage());
String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),user.getLanguage());
String hascrm =Util.toScreen(RecordSet.getString("hascrm"),user.getLanguage());
String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),user.getLanguage());
String hasproject =Util.toScreen(RecordSet.getString("hasproject"),user.getLanguage());
String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),user.getLanguage());
String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),user.getLanguage());
String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),user.getLanguage());
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),user.getLanguage());
String readCount = " ";
String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid);



/***************************取出文章被阅读的次数*********************************************************/
int readCount_int = 0 ;
String sql_readCount ="select sum(readCount) from docreadtag where docid =" + docid ;
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0) ;

boolean  canReader = false;
boolean  canEdit = false;
String sharelevel="";

if(logintype.equals("1")) {

    RecordSet.executeSql("select sharelevel from  "+tables+" where sourecid="+docid);

}
else {
    RecordSet.executeSql("select sharelevel from  "+tables+" where sourecid="+docid);
}

if(RecordSet.next()) {
    sharelevel = Util.null2String(RecordSet.getString(1)) ;
    if(sharelevel.equals("2")) canEdit = true ;
    canReader = true ;
}

if(isrequest.equals("1")) canReader = true ;

if(!canReader)  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

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

int tmpmouldid=Util.getIntValue(docmouldid,0);
if(tmpmouldid ==0)
    tmpmouldid = MouldManager.getDefaultMouldId();
MouldManager.setId(tmpmouldid);
MouldManager.getMouldInfoById();
String mouldname= MouldManager.getMouldName();
String mouldtext= MouldManager.getMouldText();
MouldManager.closeStatement();
mouldtext = Util.fillValuesToString(mouldtext,hr);


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+docsubject + Util.toScreen("        (阅读",7,"0") + readCount_int + Util.toScreen("次)",7,"0") ;
String needfav ="1";
String needhelp ="";


%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteDoc(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='DocMonitor.jsp?pagenum="+pagenum+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

</DIV>
<FORM id=weaver name=weaver action="/system/systemmonitor/MonitorOperation.jsp" method=post>
<div style="display:none">
<BUTTON class=btnDelete accessKey=D type=button onclick="deleteDoc()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=R onClick="location.href='DocMonitor.jsp?pagenum=<%=pagenum%>'"><U>R</U>-返回</BUTTON>
</div>
<input type=hidden name=operation value="deletedoc">
<input type=hidden name=deletedocid value="<%=docid%>">
</form>
<TABLE class=ViewForm>
<TBODY>
<tr><td>&nbsp;</td></tr>
<tr>
<td>
<%=mouldtext%>
</td>
</tr>
</tbody>
</table>
<br>

<%
if(!publishable.trim().equals("")){
%>
<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing><TD class=Line1 colspan=2></TD></TR>
<tr>
<td width=15%><b><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></b></td>
<td width=85% class=field>
<%=tmppublishtype%>
</td>
</tr>
</tbody>
</table>
<%}%>

<div id=oDiv style="display:''">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width=35%>
  <COL width="15%">
  <COL width=35%>
  <TBODY>
  <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></td>
  <td class=field>
  <%=MainCategoryComInfo.getMainCategoryname(""+maincategory)%>
  </td>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td class=field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(docdepartmentid+""),user.getLanguage())%></td>
  </tr>
  <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></td>
  <td class=field>
  <%=SubCategoryComInfo.getSubCategoryname(""+subcategory)%>
  </td>
  <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
  <td class=field>
  <%=LanguageComInfo.getLanguagename(""+doclangurage)%>
  </td>
  </tr>
    <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
  <td class=field>
  <%=SecCategoryComInfo.getSecCategoryname(""+seccategory)%>
  </td>
  <td><%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%></td>
  <td class=field><a href="/docs/search/DocSearchTemp.jsp?keyword=<%=keyword%>"><%=keyword%><a></td>
  </td>
  </tr>
    <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
  </tbody>
  </table>



<TABLE class=ViewForm>
<TBODY>
<tr>
<%
int needtr=0;
if(!hashrmres.trim().equals("0")&&!hashrmres.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
	if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(!user.getLogintype().equals("2")){%>
<%if(hrmresid!=0){%>
<A  href='javaScript:openhrm(<%=hrmresid%>);' onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></A>
<%}%>
<%}%>
</td>

<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasasset.trim().equals("0")&&!hasasset.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
	if(!assetlabel.trim().equals("")) curlabel = assetlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(!user.getLogintype().equals("2")){%>
<%if(assetid!=0){%>
<a href="/cpt/capital/CptCapital.jsp?id=<%=assetid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),user.getLanguage())%></a>
<%}%>
<%}%>
</td>
<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>

<%
if(!hascrm.trim().equals("0")&&!hascrm.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
	if(!crmlabel.trim().equals("")) curlabel = crmlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(crmid!=0){%>
<a  href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=crmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+crmid),user.getLanguage())%></a>
<%}%>
</td>
<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasitems.trim().equals("0")&&!hasitems.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
	if(!itemlabel.trim().equals("")) curlabel = itemlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(itemid!=0){%>
<A href='/lgc/asset/LgcAsset.jsp?paraid=<%=itemid%>'><%=AssetComInfo.getAssetName(""+itemid)%></a>
<%}%>

</td>
<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasproject.trim().equals("0")&&!hasproject.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
	if(!projectlabel.trim().equals("")) curlabel = projectlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(projectid!=0){%>
<A  href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(""+projectid),user.getLanguage())%></a>
<%}%>
</td>
<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasfinance.trim().equals("0")&&!hasfinance.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
	if(!financelabel.trim().equals("")) curlabel = financelabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
<%if(financeid!=0) {%><%=financeid%><%}%>
</td>
<%
if(needtr==1){ out.print("</tr><TR><TD class=Line colSpan=4></TD></TR><tr>");needtr=0;}
else needtr++;
}%>
<%
	int i= 0;
	DocImageManager.resetParameter();
	DocImageManager.setDocid(docid);
	DocImageManager.selectDocImageInfo();
	while(DocImageManager.next()){
		String curimgid = DocImageManager.getImagefileid();
		String curimgname = DocImageManager.getImagefilename();
		i++;
		String curlabel = SystemEnv.getHtmlLabelName(156,user.getLanguage())+i;
%>
<td width=15%><%=curlabel%></td>
<td colspan=3 class=field>
<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
<input type=hidden name=accessory<%=i%> value="<%=curimgid%>">
<BUTTON class=btn accessKey=<%=i%> onclick="location='/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1'"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></BUTTON>
</td>
</tr>
<%}%>
<input type=hidden name=accessorynum value="<%=i%>">
</tbody>
</table>


</div>

<TABLE class=ViewForm>
 <COLGROUP>
  <COL width="15%">
  <COL width=35%>
  <COL width="15%">
  <COL width=35%>

<TBODY>
<tr>
<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
<td class=field>
<%=docno%>
</td>
<td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td class=field>
<%=docid%>
</td>
</tr>
  <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></td>
<td class=field>
<%if(usertype.equals("1")){%>
	<a href='javaScript:openhrm(<%=doccreaterid%>);' onclick='pointerXY(event);'>
	<%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%></a>
	<%}else{%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doccreaterid%>">
	<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())%></a>
<%}%>
&nbsp;<%=doccreatedate%>&nbsp;<%=doccreatetime%>
</td>
<td><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></td>
<td class=field>
<%if(usertype.equals("1")){%>
	<a href='javaScript:openhrm(<%=doclastmoduserid%>);' onclick='pointerXY(event);'>
	<%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%></a>
	<%}else{%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doclastmoduserid%>">
	<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doclastmoduserid),user.getLanguage())%></a>
<%}%>
&nbsp;<%=doclastmoddate%>&nbsp;<%=doclastmodtime%>
</td>
</tr>
  <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></td>
<td class=field>
<%if(docapproveuserid!=0){%>
<A<%if(user.getType()==0){%> href='javaScript:openhrm(<%=docapproveuserid%>"<%}%>);' onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+docapproveuserid),user.getLanguage())%></A>
&nbsp;<%=docapprovedate%>&nbsp;<%=docapprovetime%>
<%}%>
</td>
<td><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></td>
<td class=field>
<%if(docarchiveuserid!=0){%>
<A<%if(user.getType()==0){%> href='javaScript:openhrm(<%=docarchiveuserid%><%}%>);' onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+docarchiveuserid),user.getLanguage())%></A>
&nbsp;<%=docarchivedate%>&nbsp;<%=docarchivetime%>
<%}%>
</td>
</tr>
  <TR>
	<TD class=Line colSpan=4></TD>
  </TR>
</tbody>
</table>



		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


<script language="javascript">
function deleteDoc(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.weaver.submit();
	}
}
</script>
</body>
</html>

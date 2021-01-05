
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ page import="java.util.*" %>
<%@ include file="/docs/common.jsp" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ctci" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
rightStr="HrmContractEdit:Edit";
}

%>
<%
String temStr = request.getRequestURI();
temStr="/docs/docs/";

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

String id = Util.null2String(request.getParameter("id"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String contractman = "";
String startdate = "";
String enddate = "";
String proenddate = "";
String typeid = "";
int docid = 0;
int versionId = Util.getIntValue(request.getParameter("versionId"),0);
String sql = "select * from HrmContract where id = "+id;
rs.executeSql(sql);

while(rs.next()){
  contractman = rs.getString("contractman");
  typeid = rs.getString("contracttypeid");
  startdate = rs.getString("contractstartdate");
  enddate = rs.getString("contractenddate");
  proenddate = rs.getString("proenddate");
  docid = Util.getIntValue(rs.getString("contractdocid"),0);
}

int aheaddate = ctci.getRemindAheadDate(typeid);

String ishrm = "";
sql = "select * from HrmContractType where id = "+typeid;

rs.executeSql(sql);
while(rs.next()){
  ishrm = rs.getString("ishirecontract");
}

String man = Util.null2String(request.getParameter("contractman"));
if(!man.equals("")){
  contractman = man;
}

sql = "select startdate,enddate,probationenddate from HrmResource where id = "+contractman;

rs.executeSql(sql);

while(rs.next()){
   if(ishrm.equals("1")){
     startdate = rs.getString("startdate");
     enddate  = rs.getString("enddate");
   }
   proenddate = rs.getString("probationenddate");
}
//取得文档数据
 sql = "";
if(versionId==0){
    sql = "select * from DocImageFile where docid="+docid+" order by versionId desc";
}else{
    sql = "select * from DocImageFile where docid="+docid+" and versionId="+versionId;
}
//System.out.println("versionID sql:"+sql);
RecordSet.executeSql(sql) ;
RecordSet.next();
versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
String fileName=Util.null2String(""+RecordSet.getString("imagefilename"));
String filetype=Util.null2String(""+RecordSet.getString("docfiletype"));
if(filetype.equals("3")){
    filetype=".doc";
}else if(filetype.equals("4")){
    filetype=".xls";
}else if(filetype.equals("5")){
    filetype=".ppt";
}else if(filetype.equals("6")){
    filetype=".wps";
}else if(filetype.equals("7")){
    filetype=".docx";
}else if(filetype.equals("8")){
    filetype=".xlsx";
}else if(filetype.equals("9")){
    filetype=".pptx";
}else if(filetype.equals("10")){
    filetype=".et";
}else{
    filetype=".doc";
}


String  docEditType=Util.null2String(request.getParameter("docEditType"));
if(docEditType.equals("")){
    docEditType = "1";
}

String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);

String needinputitems = "";
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
	int assetid=DocManager.getAssetid();
	int ownerid=DocManager.getOwnerid();
	String keyword=DocManager.getKeyword();
	int accessorycount=DocManager.getAccessorycount();
    int replaydoccount=DocManager.getReplaydoccount();
	String usertype=DocManager.getUsertype();

    String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
    String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）

DocManager.closeStatement();
String docmain = "";

if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
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
/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
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



temStr="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

temStr+=SystemEnv.getHtmlLabelName(401,user.getLanguage())+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage());




String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage())+":"+Util.add0(docid,12)+"    "+temStr;
String needfav ="1";
String needhelp ="";

if(docstatus.equals("0")){
    docEditType = "1";
}else{
    docEditType = "2";
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</head>
<script>
function StatusMsg(mString){
  StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
  }
}
function Load(){
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=(versionId==0?"":versionId+"")%>_<%=docid%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="<%=fileName%>";
  weaver.WebOffice.FileType="<%=filetype%>";
  //weaver.WebOffice.EditType="2";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="3,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="3";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebOpen();  	//打开该文档
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>
  StatusMsg(weaver.WebOffice.Status);
  weaver.WebOffice.UserName="<%=user.getUID()%>"; 
  //var onlstr = new clsDateTime();
  }catch(e){
      //alert("error");
  }
}

function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("<%=SystemEnv.getHtmlLabelName(83475,user.getLanguage())%>");
  }
  }catch(e){}
  return false;
}

function WebOpenSignature(){
  try{
    weaver.WebOffice.WebOpenSignature();
    StatusMsg(weaver.WebOffice.Status);
    return true;
  }catch(e){
      return false;
  }
}

function SaveDocument(){
  //weaver.WebOffice.FileName=weaver.docsubject.value+"<%=filetype%>";
  weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");
  if (!weaver.WebOffice.WebSave(<%=isNoComment%>)){
     StatusMsg(weaver.WebOffice.Status);
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19007,user.getLanguage())%>");
     return false;
  }else{
     StatusMsg(weaver.WebOffice.Status);
     //alert(weaver.WebOffice.WebGetMsgByName("CREATEID"));
     //weaver.docId.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
     //weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
     //alert(weaver.docId.value);
     //alert(weaver.docType.value);

     return true;
  }
}



function protectDoc(){
    event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,user.getLanguage())%>";
}

</script>

</head>
<BODY id="mybody" onload="Load()" onunload="UnLoad()" onbeforeunload="protectDoc()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//if(!docstatus.equals("3") && !docstatus.equals("4")) {
//RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:onHtml(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(Util.dayDiff(today,enddate)==aheaddate ||Util.dayDiff(today,proenddate)==aheaddate){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:oninfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contract/HrmContractViewExt.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<table style="position: relative;width: 100%;">
<tr>
<td>
<B><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%>:</B><%=doccreatedate%>&nbsp;<%=doccreatetime%>&nbsp<B> 
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><A href="/hrm/resource/HrmResource.jsp?id=<%=doccreaterid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%></A> 
 <B><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>:</B><%=doclastmoddate%>&nbsp;<%=doclastmodtime%>&nbsp<B> 
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><A href="/hrm/resource/HrmResource.jsp?id=<%=doclastmoduserid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%></A>
  </td>
  </tr>
</table> 
</DIV>
<FORM id=weaver name=weaver action="/docs/docs/UploadDoc.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input class=inputstyle type=hidden name=isreply value="<%=isreply%>">
<input class=inputstyle type=hidden name=replydocid value="<%=replydocid%>">
<input class=inputstyle type=hidden name=conId value=<%=id%>>
<input class=inputstyle type=hidden name=docreplyable value="<%=replyable%>">
<input class=inputstyle type=hidden name=docstatus value="0">
<input class=inputstyle type=hidden name=olddocstatus value="<%=docstatus%>">
<input class=inputstyle type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input class=inputstyle type=hidden name=docCreaterType value="<%=docCreaterType%>">
<input class=inputstyle type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input class=inputstyle type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input class=inputstyle type=hidden name=docapproveuserid value="<%=docapproveuserid%>">
<input class=inputstyle type=hidden name=docapprovedate value="<%=docapprovedate%>">
<input class=inputstyle type=hidden name=docapprovetime value="<%=docapprovetime%>">
<input class=inputstyle type=hidden name=docarchiveuserid value="<%=docarchiveuserid%>">
<input class=inputstyle type=hidden name=docarchivedate value="<%=docarchivedate%>">
<input class=inputstyle type=hidden name=docarchivetime value="<%=docarchivetime%>">
<input class=inputstyle type=hidden name=usertype value="<%=usertype%>">
<input class=inputstyle type=hidden name="ownerid" value="<%=ownerid%>">
<input class=inputstyle type=hidden name="ownerType" value="<%=ownerType%>">
<input class=inputstyle type=hidden name="oldownerid" value="<%=ownerid%>">
<input class=inputstyle type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input class=inputstyle type=hidden name=doclangurage value="<%=doclangurage%>">
<input class=inputstyle type=hidden name=urlfrom value=hr>
<input class=inputstyle type=hidden name=typeid value=<%=typeid%>>

<%
if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
%>
<TABLE class=viewform>
<TBODY>
<tr>
<td width=15%><b><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></b></td>
<td width=40%>
<%
String ischeck1="";
String ischeck2="";
String ischeck3="";
if(docpublishtype.equals("1")) ischeck1=" checked";

if(docpublishtype.equals("2")) {
	ischeck2=" checked";
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1){
		docmain = doccontent.substring(0,tmppos);
		doccontent = doccontent.substring(tmppos+8,doccontent.length());
	}
}

if(docpublishtype.equals("3")) ischeck3=" checked";
%>
<input class=inputstyle type=radio name="docpublishtype" value=1 <%=ischeck1%> onclick="onshowdocmain(0)"><font color=red><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></font>
<input class=inputstyle type=radio name="docpublishtype" value=2 <%=ischeck2%> onclick="onshowdocmain(1)"><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font>
<input class=inputstyle type=radio name="docpublishtype" value=3 <%=ischeck3%> onclick="onshowdocmain(0)"><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font>
</td>
</tbody>
</table>
<%}%>
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		
        <input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>"></input>
		
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
   </table>
<div id=oDiv style="display:''">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></wea:item>
		<wea:item>
		<%
			String sqlwherestr = "";
			boolean onlyselfdept = CheckSubCompanyRight.getDecentralizationAttr(user.getUID(),"HrmContractAdd:Add",-1,-1,1);
			boolean isall = CheckSubCompanyRight.getIsall();
			String departments = CheckSubCompanyRight.getDepartmentids();
			String subcompanyids = CheckSubCompanyRight.getSubcompanyids();
			if(!isall){
				if(onlyselfdept){
					sqlwherestr = " ("+Util.getSubINClause(departments, "t1.departmentid", "in") +") ";
				}else{
					sqlwherestr = " ("+Util.getSubINClause(subcompanyids, "t1.subcompanyid1", "in") +") ";
				}
			}
			String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmContractAdd:Add";
			String dataUrl = "/data.jsp";
			if(!"".equals(sqlwherestr)){
				dataUrl = "/data.jsp?whereClause="+xssUtil.put(sqlwherestr);
			}
		%>
			<brow:browser viewType="0" name="contractman"  browserValue='<%=contractman%>' 
							browserUrl="<%=browserUrl%>"
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
							completeUrl="<%=dataUrl%>" linkUrl="javascript:openhrm($id$)" width="165px"
							browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(contractman),user.getLanguage()) %>'></brow:browser>
							   <%
		    needinputitems += ",contractman";
		    %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15777,user.getLanguage())%></wea:item>
		<wea:item> 
	        <button type=button  class=Calendar id=selectcontractstartdate onClick="getDate(contractstartdatespan,contractstartdate)"></button> 
	        <span id=contractstartdatespan ><%=startdate%></span> -&nbsp;
	        <button type=button  class=Calendar id=selectcontractenddate onClick="getDate(contractenddatespan,contractenddate)"></button> 
	        <span id=contractenddatespan ><%=enddate%></span> 
	        <input class=inputstyle type="hidden" name="contractstartdate" value="<%=startdate%>">
	        <input class=inputstyle type="hidden" name="contractenddate" value="<%=enddate%>">
      	</wea:item>
		<%
      if(ishrm.equals("1")){
      %> 
         <wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
		<wea:item> 
	     <button class=Calendar type="button" id=selectproenddate onClick="getDate(proenddatespan,proenddate)"></button> 
          <span id=proenddatespan ><%=proenddate%></span>       
          <input class=inputstyle type="hidden" name="proenddate" value="<%=proenddate%>">      
      	</wea:item>
	  <%
      }
    %> 
	<wea:item></wea:item>
	<wea:item>
    <input type=hidden name=maincategory value="<%=maincategory%>">
    <input type=hidden name=subcategory value="<%=subcategory%>">
    <input type=hidden name=seccategory value="<%=seccategory%>">
	</wea:item>
	</wea:group>
</wea:layout>  


</div>

<div id=noDiv style="display:none">
<TABLE class=viewform>
<TBODY>
<TR class=spacing><TD class=line1 colspan=4></TD></TR>
<tr>
<%
int needtr=0;
if(!hashrmres.trim().equals("0")&&!hashrmres.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
	if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
  <button class=Browser onClick="onShowHrmresID(<%=hashrmres%>)"></button>
  <span id=hrmresspan>
  <%if(hashrmres.equals("2"))
  	needinputitems += ",hrmresid";
  %>
  <A href="/hrm/resource/HrmResource.jsp?id=<%=hrmresid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></A>
  </span> 
    <input class=inputstyle type=hidden name=hrmresid value="<%=hrmresid%>">
</td>

  <%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasasset.trim().equals("0")&&!hasasset.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
	if(!assetlabel.trim().equals("")) curlabel = assetlabel;
%>
<td width=20%><%=curlabel%></td>
<td width=30% class=field>
  <button class=Browser onClick="onShowAssetId(<%=hasasset%>)"></button>
  <span id=assetidspan>
  <%if(hasasset.equals("2"))
  	needinputitems += ",assetid";
  %>
   <A href="/cpt/capital/CapitalBrowser.jsp?id=<%=assetid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(""+assetid),user.getLanguage())%></A>
  </span> 
  <input class=inputstyle type=hidden name=assetid value="<%=assetid%>">
</td>

<%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hascrm.trim().equals("0")&&!hascrm.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
	if(!crmlabel.trim().equals("")) curlabel = crmlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
  <button class=Browser onClick="onShowCrmID(<%=hascrm%>)"></button>
  <span id=crmidspan>
  <%if(hascrm.equals("2"))
  	needinputitems += ",crmid";
  %>
  <a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=crmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+crmid),user.getLanguage())%></a>
  </span> 
  <input class=inputstyle type=hidden name=crmid value="<%=crmid%>">
</td>
<%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasitems.trim().equals("0")&&!hasitems.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
	if(!itemlabel.trim().equals("")) curlabel = itemlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
   <button class=Browser onClick="onShowItemID(<%=hasitems%>)"></button>
  <span id=itemspan>
  <%if(hasitems.equals("2")){
  	needinputitems += ",itemid";
  }
  %>
  <A href='/lgc/asset/LgcAsset.jsp?paraid=<%=itemid%>'><%=AssetComInfo.getAssetName(""+itemid)%></a>
  </span> 
  <input class=inputstyle type=hidden name=itemid value="<%=itemid%>">
</td>
<%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>
<%if(!hasproject.trim().equals("0")&&!hasproject.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
	if(!projectlabel.trim().equals("")) curlabel = projectlabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
  <button class=Browser onClick="onShowProjectID(<%=hasproject%>)"></button>
  <span id=projectidspan>
  <%if(hasproject.equals("2"))
  	needinputitems += ",projectid";
  %>
  <A href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(""+projectid),user.getLanguage())%></a>
  </span> 
    <input class=inputstyle type=hidden name=projectid value="<%=projectid%>">
</td>
<%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>
<%
if(!hasfinance.trim().equals("0")&&!hasfinance.trim().equals("")){
	String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
	if(!financelabel.trim().equals("")) curlabel = financelabel;
%>
<td width=15%><%=curlabel%></td>
<td width=35% class=field>
  <button class=Browser></button>
    <input class=inputstyle type=hidden name=financeid value="<%=financeid%>">
</td>
<%
if(needtr==1){ out.print("</tr><tr>");needtr=0;}
else needtr++;
}%>

<%
if(!hasaccessory.trim().equals("")){
	int i= 0;
	DocImageManager.resetParameter();
	DocImageManager.setDocid(docid);
	DocImageManager.selectDocImageInfo();
	while(DocImageManager.next()){
		String curimgid = DocImageManager.getImagefileid();
		String curimgname = DocImageManager.getImagefilename();
//	while(i<accessorynum){
		i++;
		String curlabel = SystemEnv.getHtmlLabelName(156,user.getLanguage())+i;
%>
<tr>
<td width=15%><%=curlabel%></td>
<td colspan=3 class=field>
<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
<BUTTON class=btnDelete accessKey=<%=i%> onclick="onDelpic(<%=curimgid%>)"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
</BUTTON>
</td>
</tr>
<%
	}
	%>
	<input class=inputstyle type=hidden name=accessorynum value="<%=(accessorynum-i)%>">
	<%
	int j=0;
	while(j<(accessorynum-i)){
	j++;
	String curlabel = SystemEnv.getHtmlLabelName(156,user.getLanguage())+(i+j);
%>
<tr>
<td width=15%><%=curlabel%></td>
<td colspan=3 class=field>
<input class=inputstyle type=file size=60 name=accessory<%=j%>>
</td>
</tr>
<%	
	}
	
}%>
</tbody>
</table>

</div>

<script language=javascript>
function showHeader(){
	if(oDiv.style.display=='')
		oDiv.style.display='none';
	else
		oDiv.style.display='';
}
</script>
<TABLE class=viewform>
<TBODY>
<TR class=spacing><TD class=line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=85% class=field>
<input class=inputstyle  size=70 name=docsubject  value="<%=docsubject%>" onChange="checkinput('docsubject','docsubjectspan')">
<SPAN id=docsubjectspan></SPAN>
<%needinputitems += ",docsubject";%>
</td>
</tr>
<tr id=otrtmp <%if(!docpublishtype.equals("2")){%>style="display:none"<%}%>>
<td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
<td width=80% class=field>
<input class=inputstyle  size=70 name="docmain" value="<%=docmain%>" onChange="checkinput('docmain','docmainspan')" >
<SPAN id="docmainspan">
</SPAN>
<%
//needinputitems += ",docmain";
%>
</td>
</tr>
</tbody>
</table>

<TABLE class=viewform>
<TBODY>
<TR class=spacing>
<TD class=line1 colspan=2></TD></TR>
<TR><TD colspan=2>

<div  id="worddiv" style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
    <OBJECT  id="WebOffice" style="POSITION: relative;top:-20" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </OBJECT>
</div>

</TD>
<tr><td colspan = 2>
    <span id=StatusBar>&nbsp;</span>
</td></tr>
</TR>
</TBODY>
</TABLE>

<script language=vbs>
sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	language.innerHtml = id(1)
	weaver.doclangurage.value=id(0)
end sub
</script>  
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=docid%>">
<input class=inputstyle type=hidden name=delimgid>
<input class=inputstyle type=hidden name=hrmContractId value="<%=id%>">
</FORM>
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

<script language=vbs>
sub onShowResource111()

	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
end if 
	if NOT isempty(id) then
	    if id(0)<> "" then
			contractmanspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
			weaver.contractman.value=id(0)
			weaver.contractman.value=id(1)
			else
			contractmanspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.contractman.value=""
			
		end if
		 mybody.onbeforeunload=null
		weaver.action="HrmContractEditExt.jsp?id=<%=id%>&contractman="&id(0)
		weaver.submit()
	end if

end sub
sub onShowHrmresID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			hrmresspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.hrmresid.value=id(0)
		else
			if objval="2" then
				hrmresspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				hrmresspan.innerHtml =""
			end if
			weaver.hrmresid.value=""
		end if
	end if
end sub

sub onShowAssetId(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assetidspan.innerHtml = "<A href='/cpt/capital/CapitalBrowser.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.assetid.value=id(0)
	else
		if objval="2" then
				assetidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				assetidspan.innerHtml =""
			end if
	weaver.assetid.value="0"
	end if
	end if
end sub

sub onShowItemID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	itemspan.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
	weaver.itemid.value=id(0)
	else
		if objval="2" then
				itemspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				itemspan.innerHtml =""
			end if
	weaver.itemid.value="0"
	end if
	end if
end sub

sub onShowItemmaincategoryID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	itemmaincategorypan.innerHtml = id(1)
	weaver.itemmaincategoryid.value=id(0)
	else
		if objval="2" then
				itemmaincategorypan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				itemmaincategorypan.innerHtml =""
			end if
	weaver.itemmaincategoryid.value="0"
	end if
	end if
end sub


sub onShowCrmID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	crmidspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.crmid.value=id(0)
	else
		if objval="2" then
				crmidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				crmidspan.innerHtml =""
			end if
	weaver.crmid.value="0"
	end if
	end if
end sub

sub onShowProjectID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectidspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	weaver.projectid.value=id(0)
	else
	if objval="2" then
				projectidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				projectidspan.innerHtml =""
			end if
	weaver.projectid.value="0"
	end if
	end if
end sub
</script>
<script language="javascript">

function onShowResource(){
	var url = "";
	if(<%=detachable%> != 1){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>";
	}
	return url; 
}

function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else
		otrtmp.style.display='none';
}
function openVersion(vid){
    docVersion(vid);
}

function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else
		otrtmp.style.display='none';
}

<%--Add by Charoes Huang ON May 21,2004--%>
function checkDateValidity(){
    var isValid = false;
    isValid = checkDateRange(weaver.contractstartdate,weaver.contractenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")<%if(ishrm.equals("1")){%>&&checkDateBetween(weaver.contractstartdate.value,weaver.proenddate.value,weaver.contractenddate.value,"<%=SystemEnv.getHtmlLabelName(17411,user.getLanguage())%>")<%}%>;
    return isValid;
}

function onSave(obj){

	 document.getElementById("worddiv").style.display="none";
	if(checkform_c(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
		
        document.weaver.docstatus.value=1;
        document.weaver.operation.value='editsave';
        if(SaveDocument()){
            mybody.onbeforeunload=null;
            obj.disabled = true ;
            document.weaver.submit();
        }
    }
}

function onSaveNewVersion(obj){
    if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
        document.weaver.docstatus.value=1;
        document.weaver.operation.value='editsave';
        if(SaveDocumentNewV()){
            mybody.onbeforeunload=null;
            obj.disabled = true ;
            document.weaver.submit();
        }
    }
}


function onDraft(obj){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
        document.weaver.docstatus.value=0;
        document.weaver.operation.value='editdraft';
        if(SaveDocument()){
            mybody.onbeforeunload=null;
            obj.disabled = true ;
            document.weaver.submit();
        }
	}
}

function onPreview(obj){
    if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
        document.weaver.docstatus.value=0;
        document.weaver.operation.value='editpreview';
        if(SaveDocument()){
            mybody.onbeforeunload=null;
            obj.disabled = true ;
            document.weaver.submit();
        }
	}
}

function onDelpic(imgid){
	document.weaver.operation.value='delpic';
	document.weaver.delimgid.value=imgid;
	document.weaver.submit();
}

function onHtml(thiswin){
	if(document.weaver.doccontent.style.display==''){
		text = document.weaver.doccontent.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.doccontent.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.doccontent.style.display='';
		divifrm.style.display='none';
	}
}

accessorynum = 2 ;
function addannexRow()
{
	ncol = rewardTable.cols;
	oRow = rewardTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		switch(j) {
             case 0:
				var oDiv = document.createElement("div");
				 var sHtml = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=file size=70 name='accessory"+accessorynum+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	accessorynum = accessorynum*1 +1;
	document.weaver.accessorynum.value = accessorynum ;
}

function oninfo(){
  if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
    location="HrmContractOperation.jsp?id=<%=id%>";
  }
}

function getDate(spanname,inputname){ 
	
	WdatePicker({el:spanname,onpicked:function(dp){
	var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
		document.weaver.operation.value="delete";
		window.onbeforeunload=null;
		document.weaver.submit();
	}
}
function checkform_c(thiswins,items)
{
	

	thiswin = thiswins
	items = ","+items + ",";
	
	var tempfieldvlaue1 = "";
	try{
		tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
	}catch (e) {
	}

	for(i=1;i<=thiswin.length;i++){
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
	    if(tmpvalue==null){
	        continue;
	    }

		if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){
			var href = location.href;
			if(href && href.indexOf("Ext.jsp")!=-1){
				window.__oriAlert__ = true;
			}
			if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
				while(tmpvalue.indexOf(" ") >= 0){
					tmpvalue = tmpvalue.replace(" ", "");
				}
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}

				if(tmpvalue == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"未填写");
						}else{
							var tempElement = thiswin.elements[i-1];
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"未填写", function () {
						    formElementFocus(tempElement);						
							});
						}
						return false;
					}else{
						if(window.__oriAlert__){
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                            document.getElementById("worddiv").style.display="";
                            });
						}else{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                            document.getElementById("worddiv").style.display="";
                            });
						}
						return false;
					}
				}
			} else {
				var divttt=document.createElement("div");
				divttt.innerHTML = tmpvalue;
				var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
				if(tmpvaluettt == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\";"+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"未填写");
						}else{
							var tempElement = thiswin.elements[i-1];
							
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"未填写", function () {
								formElementFocus(tempElement);
							});
							
						}
						return false;
					}else{
						if(window.__oriAlert__){
							  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                          document.getElementById("worddiv").style.display="";
                            });
						}else{
								 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                             document.getElementById("worddiv").style.display="";
                            });
						}
						return false;
					}
				}
			}
		}
	}
	return true;
}
</script>
<%@include file="/hrm/include.jsp"%>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

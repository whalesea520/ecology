<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,weaver.hrm.resource.ResourceComInfo" %>
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
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%!
	/**
	*@param comInfo
	*@param user 当前登陆用户 
	*@resourceid 被查看的人的ID
	*/
	private boolean hasRightToViewContract(ResourceComInfo  comInfo,User user,String resourceid){
		boolean hasRight = false;
		int hrmid = user.getUID();
		boolean ism = comInfo.isManager(hrmid,resourceid); //上级
		boolean ishe = (hrmid == Util.getIntValue(resourceid)); //本人
		boolean ishr = (HrmUserVarify.checkUserRight("HrmContractAdd:Add",user));//人力资源管理员
		if(ism || ishe || ishr) hasRight = true;
		return hasRight;
	}
%>

<%
  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

String id = Util.null2String(request.getParameter("id"));
String cmd = Util.null2String(request.getParameter("cmd"));
String isclose = Util.null2String(request.getParameter("isclose"));

String contractman = "";
String startdate = "";
String enddate = "";
String proenddate = "";
String typeid = "";
int docid = 0;
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

/*STAET	Add By Charoes Huang On May 28, 2004*/
boolean hasRight = hasRightToViewContract(ResourceComInfo,user,contractman);
if(!hasRight){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
/*END*/
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

sql = "select startdate,enddate,probationenddate,departmentid from HrmResource where id = "+contractman;

rs.executeSql(sql);

String _departmentid = "";
String _subid = "";
while(rs.next()){
   if(ishrm.equals("1")){
   //根据qc212896 不需要 合同开始和合同结束日期同人事卡片一致  
     //startdate = rs.getString("startdate");
    // enddate  = rs.getString("enddate");
   }
   //proenddate = rs.getString("probationenddate");
   _departmentid = Util.null2String(rs.getString("departmentid"));
}

String ddip=Util.null2String(request.getParameter("ddip"));
String ssid=Util.null2String(request.getParameter("ssid"));


String subid=Util.null2String(request.getParameter("subid"));

int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);

String needinputitems = "";


//int docid = Util.getIntValue(request.getParameter("id"),0);
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
int docType = DocManager.getDocType();
if(docType == 2){
    response.sendRedirect("HrmContractViewExt.jsp?id="+id);
    return;
}

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
String approvewfid=RecordSet.getString("approveworkflowid");
String needapprovecheck="";
    if(approvewfid.equals(""))  approvewfid="0";
    if(approvewfid.equals("0"))
        needapprovecheck="0";
    else
        needapprovecheck="1";
//System.out.println("seccategory"+seccategory);
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



String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage())+":"+Util.add0(docid,12);
String needfav ="1";
String needhelp ="";
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	if("<%=isclose%>" == "1"){
		parentWin._departmentid = "<%=ddip%>";
		parentWin._subid = "<%=ssid%>";
		parentWin.closeDialog();
	}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


if(HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(Util.dayDiff(today,enddate)==aheaddate ||Util.dayDiff(today,proenddate)==aheaddate){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:oninfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contract/HrmContract.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
<td ></td>
<td valign="top">
<B><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%>:</B><%=doccreatedate%>&nbsp;<%=doccreatetime%>&nbsp<B>
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><A href="/hrm/resource/HrmResource.jsp?id=<%=doccreaterid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%></A>
 <B><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>:</B><%=doclastmoddate%>&nbsp;<%=doclastmodtime%>&nbsp<B>
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><A href="/hrm/resource/HrmResource.jsp?id=<%=doclastmoduserid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%></A>
</DIV>
<FORM id=weaver name=weaver action="/docs/docs/UploadDoc.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input class=inputstyle type=hidden name=isreply value="<%=isreply%>">
<input class=inputstyle type=hidden name=replydocid value="<%=replydocid%>">

<input class=inputstyle type=hidden name=docreplyable value="<%=replyable%>">
<input class=inputstyle type=hidden name=docstatus value="0">
<input class=inputstyle type=hidden name=olddocstatus value="<%=docstatus%>">
<input class=inputstyle type=hidden name=doccreaterid value="<%=doccreaterid%>">
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
<input class=inputstyle type=hidden name="oldownerid" value="<%=ownerid%>">
<input class=inputstyle type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input class=inputstyle type=hidden name=doclangurage value="<%=doclangurage%>">
<input class=inputstyle type=hidden name=urlfrom value=hr>
<input class=inputstyle type=hidden name=typeid value=<%=typeid%>>

<%
if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
%>
<TABLE class=ViewForm>
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

<div id=oDiv style="display:''">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width=35%>
 <TBODY>
  <TR class=spacing style="height:2px">
    <TD class=line1 colspan=4>
    </TD>
  </TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></td>
    <td class=field>
      <SPAN id=contractmanspan><%=ResourceComInfo.getResourcename(contractman)%>
      </SPAN>
      <input class=inputstyle type=hidden id=contractman name=contractman value="<%=contractman%>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15777,user.getLanguage())%></td>
    <td class=field>
       <SPAN id=contractstartdatespan ><%=startdate%></SPAN> -
      <SPAN id=contractenddatespan ><%=enddate%></SPAN>
      <input class=inputstyle type="hidden" name="contractstartdate" value="<%=startdate%>">
      <input class=inputstyle type="hidden" name="contractenddate" value="<%=enddate%>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%
  if(ishrm.equals("1")){
%>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></td>
    <td class=field>
       <SPAN id=proenddatespan ><%=proenddate%></SPAN>
      <input class=inputstyle type="hidden" name="proenddate" value="<%=proenddate%>">
    </td>
  </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%
  }
%>
	<!--
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></td>
    <td class=field>
      <%=MainCategoryComInfo.getMainCategoryname(""+maincategory)%>
      <input class=inputstyle type=hidden name=maincategory value="<%=maincategory%>">
    </td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
    <td class=field>
      <%=SubCategoryComInfo.getSubCategoryname(""+subcategory)%>
      <input class=inputstyle type=hidden name=subcategory value="<%=subcategory%>">
    </td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></td>
    <td class=field>
      <%=SecCategoryComInfo.getSecCategoryname(""+seccategory)%>
      <input class=inputstyle type=hidden name=seccategory value="<%=seccategory%>">
    </td>
  </tr>
	-->
  </tbody>
  </table>
</div>

<div id=noDiv style="">
<TABLE class=ViewForm>
<TBODY>
<TR class=spacing style="height:1px"><TD class=line1 colspan=4></TD></TR>
<%
// System.out.println("hasaccessory =="+hasaccessory)  ;
// System.out.println("docid ==" +docid);
if(!hasaccessory.trim().equals("")){
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
<tr>
<td width=15%><%=curlabel%></td>
<td colspan=3 class=field>
<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1&fromhrmcontract=<%=id%>"><%=curimgname%></a>&nbsp;
</td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%	}	%>
	<input class=inputstyle type=hidden name=accessorynum value="<%=(accessorynum-i)%>">
	<%
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
<TABLE class=ViewForm>
<TBODY>
<TR class=spacing  style="height:2px"><TD class=line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=85% class=field>
<%=docsubject%>
<SPAN id=docsubjectspan></SPAN>
<%needinputitems += ",docsubject";%>
</td>
</tr>
<tr id=otrtmp <%if(!docpublishtype.equals("2")){%>style="display:none"<%}%>>
<td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
<td width=80% class=field>
<%=docmain%>
<SPAN id="docmainspan">
</SPAN>
<%
//needinputitems += ",docmain";
%>
</td>
</tr>
</tbody>
</table>

<TABLE class=ViewForm>
<TBODY>
<TR class=spacing  style="height:2px">
<TD class=line1 colspan=2></TD></TR>
<TR><TD colspan=2>
<%=doccontent%>
</TD>

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
</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

<script language=vbs>
sub onShowResource()

	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
			contractmanspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
			weaver.contractman.value=id(0)
			weaver.contractman.value=id(1)
			else
			contractmanspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.contractman.value=""

		end if
			weaver.action="HrmContractEdit.jsp?id=<%=id%>&contractman="&id(0)
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript">
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

function onSave(){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.innerText=text;
	document.weaver.docstatus.value=1;
	document.weaver.operation.value='editsave';
	document.weaver.submit();
//	alert(text);
//	number=0;
//	startpos=text.indexOf("src=\"");
//	while(startpos!=-1){
//		endpos=text.indexOf("\"",startpos+5);
	//	alert(startpos+'shit'+endpos);
//		curpath = text.substring(startpos+5,endpos);
//		number++;
	//	alert(curpath);
	//	var oDiv = document.createElement("div");
	//	var sHtml = "<input class=inputstyle class=inputstyle type='file' size='25' name='docimages"+number+"' value="+curpath+">";
	//	var sHtml = "<input class=inputstyle class=inputstyle type='file' size='25' name='docimages"+number+"' value='c:\\'>";
	//	oDiv.innerHTML = sHtml;
	//	imgfield.appendChild(oDiv);
//		startpos = text.indexOf("src=\"",endpos);
//	}
}
}

function onDraft(){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.innerText=text;
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='editdraft';
	document.weaver.submit();
	}
}

function onPreview(){
if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.value=text;
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='editpreview';
	document.weaver.submit();
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

function oninfo(){
  if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
    location="HrmContractOperation.jsp?id=<%=id%>";
  }
}

function onEdit(){
    location = "HrmContractEdit.jsp?id=<%=id%>";
}
</script>

</body>
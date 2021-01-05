<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<script language="javascript" type="text/javascript">
window.onload=function(){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	FCKEditorExt.initEditor('weaver','doccontent',lang);
};
</script>
</head>
<%
String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));
String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);
topage=URLDecoder.decode(tmptopage);
if(!showsubmit.equals("0"))  showsubmit="1"; 

String usertype = user.getLogintype();
int ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid=user.getUserDepartment() ;
String needinputitems = "";
needinputitems += "maincatgory,subcategory,seccategory";
AclManager am = new AclManager();
int newsid=Util.getIntValue(request.getParameter("newsid"),0);//杨国生2003-09-05加用于解决网站传递新闻组的接口
int secid=Util.getIntValue(Util.null2String(request.getParameter("secid")), -1);
int subid=Util.getIntValue(Util.null2String(request.getParameter("subid")), -1);
int mainid=Util.getIntValue(Util.null2String(request.getParameter("mainid")), -1);
if (secid == -1) {
    CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC);
    if (subid != -1) {
        CommonCategory cc = tree.findCategory(subid, AclManager.CATEGORYTYPE_SUB);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == AclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    } else if (mainid != -1) {
        CommonCategory cc = tree.findCategory(subid, AclManager.CATEGORYTYPE_MAIN);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == AclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    }
}
if (secid != -1) {
    subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid), -1);
    mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);
}

String path = "";
if (secid != -1) {
    path = "/"+CategoryUtil.getCategoryPath(secid);
}

//String doctypeid=Util.null2String(request.getParameter("doctypeid"));
String docmodule=Util.null2String(request.getParameter("docmodule"));
//if(doctypeid.equals("")) doctypeid = "0"; 

String categoryname="";
String subcategoryid="";
String docmouldid="";
String publishable="";
String replyable="";
String shareable="";
//String docdefseclevel="";
// String docseclevel="";
//int docmaxseclevel=-1;

String needapprovecheck="";

char flag=2;
String tempsubcategoryid="";

if(secid > 0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	 categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
	 docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
	 publishable=Util.null2String(""+RecordSet.getString("publishable"));
	 replyable=Util.null2String(""+RecordSet.getString("replyable"));
	 shareable=Util.null2String(""+RecordSet.getString("shareable"));
	 
	 
	 String approvewfid=RecordSet.getString("approveworkflowid");
	 if(approvewfid.equals("")) approvewfid="0";
    if(approvewfid.equals("0")) 
        needapprovecheck="0";
    else
        needapprovecheck="1";
}

// check user right

int haschecked =0;
int trueright = 0;

/* 谭小鹏 2003-05-29日 修改 将原来的权限判断改为新的方法，下面注释中的是原代码 */
if (am.hasPermission(secid, AclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC)) {
    trueright = 1;
}
if (secid < 0) {
    trueright = 1;
}

/*
//	是否满足创建者类型＋安全级别的要求

if(cusertype.equals("0")){//判断内部用户的安全级别
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cuserseclevel) )
		trueright = 1;
}

//	是否满足部门＋安全级别的要求
if(user.getUserDepartment()==Util.getIntValue(cdepartmentid1,0) &&user.getUserDepartment()!=0 ){
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cdepseclevel1) )
		trueright = 1;
}
if(!cdepartmentid1.equals("0"))
	haschecked = 1;
if(user.getUserDepartment()==Util.getIntValue(cdepartmentid2,0) &&user.getUserDepartment()!=0 ){
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cdepseclevel2) )
		trueright = 1;
}
if(!cdepartmentid2.equals("0"))
	haschecked = 1;
//	是否满足角色＋级别的要求

if(!croleid1.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid1,crolelevel1))
		trueright=1;
	haschecked =1 ;
}
if(!croleid2.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid2,crolelevel2))
		trueright=1;
	haschecked =1 ;
}
if(!croleid3.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid3,crolelevel3))
		trueright=1;
	haschecked =1 ;
}
//	该子目录是否有安全限制
if(haschecked ==0)
{
	trueright = 1;
}
*/


// 	Check Right
if(trueright!=1)
{
  	response.sendRedirect("/web/notice/noright.jsp");
	return;
}

// add by liuyu for dsp moulde text
String mouldtext = "" ;
if(!docmodule.equals("")) {
	MouldManager.setId(Util.getIntValue(docmodule));
	MouldManager.getMouldInfoById();
	mouldtext=MouldManager.getMouldText();
	MouldManager.closeStatement();
}

String gopage = "";
%>
<body>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<script>
function onSelectCategory(whichcategory) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/PermittedCategoryBrowser.jsp?operationcode=<%=AclManager.OPERATION_CREATEDOC%>");
	if (result != null) {
	    if (result[0] > 0)  {
	        location = "DocAdd.jsp?secid="+result[1];
    	} else {
    	    location = "DocAdd.jsp";
    	}
	}
}
</script>
<div>
<%if(showsubmit.equals("1")){%>
<button class=btnSave accessKey=S onClick="onSave()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<%}%>
<!--BUTTON class=btn accessKey=0  onclick="onDraft()"><U>0</U>-<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=1  onclick="onPreview()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></BUTTON-->
<button class=btn accessKey=2 onClick="FCKEditorExt.switchEditMode()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%></button>
<!--BUTTON class=btn accessKey=3 onclick="showHeader()"><U>3</U>-<%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=4 onClick="addannexRow();"><U>4</U>-附件</BUTTON-->
</div>
<br>
<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input type=hidden name=docreplyable value="<%=replyable%>">
<input type=hidden name=docstatus value="0">
<input type=hidden name=usertype value="<%=usertype%>">
<input type=hidden name=topage value="<%=topage%>">
<input type=hidden name=doclangurage value=<%=user.getLanguage()%>>
<input type=hidden name=maincategory value="<%=(mainid==-1?"":Integer.toString(mainid))%>">
<input type=hidden name=subcategory value="<%=(subid==-1?"":Integer.toString(subid))%>">
<input type=hidden name=seccategory value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type=hidden name=docpublishtype value="2">
<input type=hidden name="ownerid" value="<%=ownerid%>">
<input type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">	
<input type=hidden name=keyword  value="">
<input type=hidden name=newsid  value="<%=newsid%>">
<div id=oDiv style="display:''">


<%
/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());

String Id=""+secid;
RecordSet.executeProc("Doc_SecCategory_SelectByID",Id);
if(RecordSet.next());
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
%>
<!--TABLE width="100%" class=form>
<TR class=separator><TD class=Sep1></TD></TR>
</Table>
<TABLE cols=2 id="rewardTable">
<TBODY >
<tr>
<td width=20%>附件</td>
<td width=80%>
<input type=file size=50 name="accessory1">
</td>
</tr>
</tbody>
</table-->
<input type=hidden name=accessorynum value="1">
</div>

<script language=javascript>
function showHeader(){
	if(oDiv.style.display=='')
		oDiv.style.display='none';
	else
		oDiv.style.display='';
}
</script>
<table class=form>
<tbody>
<tr class=separator><td class=Sep1 colspan=2></td></tr>
<tr>
<td width=20%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=80% class=field>
<input class=saveHistory size=50 name="docsubject" onChange="checkinput('docsubject','docsubjectspan')" >
<span id="docsubjectspan">
<img src="/images/BacoError_wev8.gif" align=absMiddle>
</span>
<%
needinputitems += ",docsubject";
%>
</td>
</tr>

<tr id=otrtmp style="display:none">
<td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
<td width=80% class=field>
<input class=saveHistory size=70 name="docmain" onChange="checkinput('docmain','docmainspan')" >
<span id="docmainspan">
<img src="/images/BacoError_wev8.gif" align=absMiddle>
</span>
<%
//needinputitems += ",docmain";
%>
</td>
</tr>

</tbody>
</table>
<div id=imgfield>
</div>
<table class=form>
<colgroup>
  <col width="20%">
  <col width=80%>
  
<tbody>
<tr class=separator>
<td class=Sep1 colspan=2></td></tr>
<tr><td>
<%=SystemEnv.getHtmlLabelName(681,user.getLanguage())%>
</td><td>
<div id=divimg name=divimg>
<input type=file name=docimages_0 size=60></input>
</div>
<input type=hidden name=docimages_num value=0></input>
</td></tr>
<%
int pos = mouldtext.indexOf("<IMG alt=");
while(pos!=-1){
	pos = mouldtext.indexOf("?fileid=",pos);
	int endpos = mouldtext.indexOf("\"",pos);
	String tmpid = mouldtext.substring(pos+8,endpos);
	int startpos = mouldtext.lastIndexOf("\"",pos);
	String servername = request.getServerName();
	String tmpcontent = mouldtext.substring(0,startpos+1);
	tmpcontent += "http://"+servername;
	tmpcontent += mouldtext.substring(startpos+1);
	mouldtext=tmpcontent;
%>
<input type=hidden name=moduleimages value="<%=tmpid%>">
<%
	pos = mouldtext.indexOf("<IMG alt=",endpos);
}
%>
<tr><td colspan=2>
<textarea name=doccontent style="display:none;width:100%;height:500px"><%=mouldtext%></textarea>
<!---###@2007-08-29 modify by yeriwei!
<div id=divifrm style="display:'';">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height=500px" id="dhtmlFrm"></iframe>
</div>
<%  if(!mouldtext.equals("")) {%>
<script FOR=window event="onload" LANGUAGE=javascript>
  document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=document.weaver.doccontent.innerText;
</script>
<%}%>
--->
</td>
</tr>

</TBODY>
</table>
<script language=vbs>
sub onShowLanguage
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	language.innerHtml = id(1)
	weaver.doclangurage.value=id(0)
end sub 
</script>  
<input type=hidden name=operation>

</form>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		owneridspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		weaver.ownerid.value=id(0)
		weaver.docdepartmentid.value=id(1)
		else
		owneridspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		weaver.ownerid.value=""
		end if
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

<script language=javascript>
function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else	
		otrtmp.style.display='none';
}
function onSave(){
	if(check_form(document.weaver,'<%=needinputitems%>')){
		/***##@2007-08-29 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		****/
		FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=1;
		document.weaver.operation.value='addsave';
		
		document.weaver.submit();
	//	alert(text);
		number=0;
		startpos=text.indexOf("src=\"");
		while(startpos!=-1){
			endpos=text.indexOf("\"",startpos+5);
		//	alert(startpos+'shit'+endpos);
			curpath = text.substring(startpos+5,endpos);
			number++;
		//	alert(curpath);
		//	var oDiv = document.createElement("div");
		//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value="+curpath+">";
		//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value='c:\\'>";
		//	oDiv.innerHTML = sHtml;    
		//	imgfield.appendChild(oDiv); 
			startpos = text.indexOf("src=\"",endpos);
		}
	}
}
function onDraft(){
	if(check_form(document.weaver,'<%=needinputitems%>')){
		/****###@2007-08-29 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		***/
		FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='adddraft';
		document.weaver.submit();
	}
}

function onPreview(){
if(check_form(document.weaver,'<%=needinputitems%>')){
	/***###@2007-08-29 modify by yeriwei!
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.value=text;
	***/
	FCKEditorExt.updateContent();
	
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='addpreview';
	document.weaver.submit();
}
}

function onHtml(){
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
				var sHtml = "附件"; 
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
</script>
<input type=hidden name=SecId value="<%=Id%>">
</body>
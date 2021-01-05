<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init.jsp" %>
<%@ page import="java.util.*" %>
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
<%@ include file="/docs/common.jsp" %>
<%
String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);
int newsid=Util.getIntValue(request.getParameter("newsid"),0);//杨国生2003-09-05加用于解决网站传递新闻组的接口
String needinputitems = "";
int docid = Util.getIntValue(request.getParameter("id"),0);
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
// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
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

//权限检查
/************************************************************************************************/
    boolean  canEdit = false;
	String sharelevel="";
    String logintype = user.getLogintype() ;
    String userid = "" +user.getUID() ;

    if(logintype.equals("1")) {

        RecordSet.executeSql("select sharelevel from   "+tables+" where sourecid="+docid);
        
    }
    else {
        RecordSet.executeSql("select sharelevel from  "+tables+" where sourecid="+docid);
    }

    if(RecordSet.next()) {
        sharelevel = Util.null2String(RecordSet.getString(1)) ;
        if(sharelevel.equals("2")) canEdit = true ;
    }

    if(!canEdit)  {
        response.sendRedirect("/web/notice/noright.jsp") ;
	    return ;
    }
   

%>

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
<body>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<div>
<button class=btnSave accessKey=S onClick="onSave()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<% if(!docstatus.equals("3") && !docstatus.equals("4")) {%>
<!--BUTTON class=btn accessKey=0  onclick="onDraft()"><U>0</U>-<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=1  onclick="onPreview()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></BUTTON-->
<%}%>
<button class=btn accessKey=2 onClick="FCKEditorExt.switchEditMode()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%></button>
<!--BUTTON class=btn accessKey=3 onclick="showHeader()"><U>3</U>-<%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=4 onClick="addannexRow();"><U>4</U>-附件</BUTTON-->

</div>
<br>

<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input type=hidden name=isreply value="<%=isreply%>">
<input type=hidden name=replydocid value="<%=replydocid%>">

<input type=hidden name=docreplyable value="<%=replyable%>">
<input type=hidden name=docstatus value="0">
<input type=hidden name=olddocstatus value="<%=docstatus%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input type=hidden name=docapproveuserid value="<%=docapproveuserid%>">
<input type=hidden name=docapprovedate value="<%=docapprovedate%>">
<input type=hidden name=docapprovetime value="<%=docapprovetime%>">
<input type=hidden name=docarchiveuserid value="<%=docarchiveuserid%>">
<input type=hidden name=docarchivedate value="<%=docarchivedate%>">
<input type=hidden name=docarchivetime value="<%=docarchivetime%>">
<input type=hidden name=usertype value="<%=usertype%>">
<input type=hidden name="ownerid" value="<%=ownerid%>">
<input type=hidden name="oldownerid" value="<%=ownerid%>">
<input type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input type=hidden name=doclangurage value="<%=doclangurage%>">
<input type=hidden name=keyword  value="<%=keyword%>">
<input type=hidden name=docpublishtype value="2">
<input type=hidden name=maincategory value="<%=maincategory%>">
<input type=hidden name=subcategory value="<%=subcategory%>">
<input type=hidden name=seccategory value="<%=seccategory%>">
<input type=hidden name=newsid  value="<%=newsid%>">
<div id=oDiv style="display:''">

<!--TABLE cols=2 id="rewardTable">
<TBODY >
<td width=15%>附件</td>
<td width=85%>
<input type=file size=70 name="accessory1">
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
<td width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=85% class=field>
<input class=saveHistory size=70 name=docsubject  value="<%=docsubject%>" onChange="checkinput('docsubject','docsubjectspan')">
<span id=docsubjectspan></span>
<%needinputitems += ",docsubject";%>
</td>
</tr>
<tr id=otrtmp <%if(!docpublishtype.equals("2")){%>style="display:none"<%}%>>
<td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
<td width=80% class=field>
<input class=saveHistory size=70 name="docmain" value="<%=docmain%>" onChange="checkinput('docmain','docmainspan')" >
<span id="docmainspan">
</span>
<%
//needinputitems += ",docmain";
%>
</td>
</tr>
</tbody>
</table>

<table class=form>
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
if(docpublishtype.equals("2")) {
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1){
		docmain = doccontent.substring(0,tmppos);
		doccontent = doccontent.substring(tmppos+8,doccontent.length());
	}
}
int oldpicnum = 0;
int pos = doccontent.indexOf("<IMG alt=");
while(pos!=-1){
	pos = doccontent.indexOf("?fileid=",pos);
	int endpos = doccontent.indexOf("\"",pos);
	String tmpid = doccontent.substring(pos+8,endpos);
	int startpos = doccontent.lastIndexOf("\"",pos);
	String servername = request.getServerName();
	String tmpcontent = doccontent.substring(0,startpos+1);
	tmpcontent += "http://"+servername;
	tmpcontent += doccontent.substring(startpos+1);
	doccontent=tmpcontent;
%>
<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
<%
	pos = doccontent.indexOf("<IMG alt=",endpos);
	oldpicnum += 1;
}
%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
<tr><td colspan=2>
<textarea name=doccontent style="display:none;width:100%;height:500px"><%=doccontent%></textarea>
<!--###2007-08-29 modify by yeriwei!
<div id=divifrm style="display:'';">
<iframe frameborder=0 style="width:100%;height=500px" name="dhtmlFrm" id="dhtmlFrm" src="/docs/docs/dhtml.jsp"></iframe>

</div>

<script FOR=window event="onload" LANGUAGE=javascript>
  document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=document.weaver.doccontent.innerText;
</script>
--->
</td>

</tr>
</TBODY>
</table>

<script language=vbs>
sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	language.innerHtml = id(1)
	weaver.doclangurage.value=id(0)
end sub
</script>  
<input type=hidden name=operation>
<input type=hidden name=id value="<%=docid%>">
<input type=hidden name=delimgid>
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
	document.weaver.doccontent.innerText=text;
	****/
	FCKEditorExt.updateContent();
	
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
	//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value="+curpath+">";
	//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value='c:\\'>";
	//	oDiv.innerHTML = sHtml;    
	//	imgfield.appendChild(oDiv); 
//		startpos = text.indexOf("src=\"",endpos);
//	}
}
}

function onDraft(){
	if(check_form(document.weaver,'<%=needinputitems%>')){
	/***##@2007-08-29 modify by yeriwei!
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.innerText=text;
	***/
	FCKEditorExt.updateContent();
	
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='editdraft';
	document.weaver.submit();
	}
}

function onPreview(){
if(check_form(document.weaver,'<%=needinputitems%>')){
	/***##@2007-08-29 modify by yeriwei!	
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.value=text;
	***/
	FCKEditorExt.updateContent();
	
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
</body>
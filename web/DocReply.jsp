<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init.jsp" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
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
    int docid = Util.getIntValue(request.getParameter("id"),0);
	int newsid=Util.getIntValue(request.getParameter("newsid"),0);
	//杨国生2003-09-05加用于解决网站传递新闻组的接口
    String parentids=Util.null2String(request.getParameter("parentids"));
    DocManager.resetParameter();
    DocManager.setId(docid);
    DocManager.getDocInfoById();

    int maincategory=DocManager.getMaincategory();
    int subcategory=DocManager.getSubcategory();
    int seccategory=DocManager.getSeccategory();
    int replydocid=DocManager.getReplydocid();
    String docsubject=DocManager.getDocsubject();
    DocManager.closeStatement();
	if (docid==0) 
	{
	 seccategory = Util.getIntValue(request.getParameter("secid"),0);
	 subcategory = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+seccategory),0);
	 maincategory = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subcategory),0);
	}

	int trueright = 0;
	AclManager am = new AclManager();
	if (seccategory == 0) {
    CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC);
	}
	/* 谭小鹏 2003-05-29日 修改 将原来的权限判断改为新的方法，下面注释中的是原代码 */
	if (am.hasPermission(seccategory, AclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC)) {
		trueright = 1;
	}
	if (seccategory < 0) {
		trueright = 1;
	}
	// 	Check Right
	if(trueright!=1)
	{
		response.sendRedirect("/web/notice/noright.jsp");
		return;
	}


%>
<body>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<div>
<button class=btnSave accessKey=S onClick="onSave()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<!--BUTTON class=btn accessKey=0  onclick="onDraft()"><U>0</U>-<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></BUTTON-->
<button class=btn accessKey=2 onClick="FCKEditorExt.switchEditMode()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%></button>
</div>
<br>
<input type=hidden name=ownerid value="<%=user.getUID()%>">
<input type=hidden name=docapprovable value="0">
<input type=hidden name=docreplyable value="1">
<input type=hidden name=isreply value="1">
<input type=hidden name=docpublishtype value="2">
<input type=hidden name=replydocid value="<%=docid%>">
<input type=hidden name=usertype value="<%=user.getLogintype()%>">
<input type=hidden name=maincategory value="<%=maincategory%>">  
<input type=hidden name=docdepartmentid value="<%=user.getUserDepartment()%>">
<input type=hidden name=subcategory value="<%=subcategory%>">
<input type=hidden name=doclangurage value="<%=user.getLanguage()%>">
<input type=hidden name=seccategory value="<%=seccategory%>">
<input type=hidden name=operation>
<input type=hidden name=parentids value="<%=parentids%>">
<input type=hidden name=docstatus>
<input type=hidden name=newsid  value="<%=newsid%>">

<table class=form>
<tbody>
<tr class=separator><td class=Sep1 colspan=2></td></tr>
<tr>
<td width=20%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=80% class=field>
<input class=saveHistory size=70 name="docsubject" value="<%if (docid!=0) {%>Re:<%}%> <%=docsubject%>" onChange="checkinput('docsubject','docsubjectspan')" >
<span id="docsubjectspan"></span>
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
<tr><td colspan=2>
<textarea name=doccontent style="display:none;width:100%;height:500px"></textarea>
<!---##@2007-08-29 modify by yeriwei!
<div id=divifrm style="display:'';">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height=500px" id="dhtmlFrm"></iframe>
</div>
-->
</td></tr>

</tbody>
</table>
</form>


<script language=javascript>
function onSave(){
	if(check_form(document.weaver,'docsubject')){
		/***
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		**/
		FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=1;
		document.weaver.operation.value='addsave';
		
		document.weaver.submit();
		number=0;
		startpos=text.indexOf("src=\"");
		while(startpos!=-1){
			endpos=text.indexOf("\"",startpos+5);
			curpath = text.substring(startpos+5,endpos);
			number++;
			startpos = text.indexOf("src=\"",endpos);
		}
	}
}

function onDraft(){
	if(check_form(document.weaver,'docsubject')){
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='adddraft';
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
</script>
</body>
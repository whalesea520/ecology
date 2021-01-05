
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="km" class="weaver.general.KnowledgeTransMethod" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
	int subcompanyid = 0;
	int id = Util.getIntValue(request.getParameter("id"),0);
	String secid = id +"";
	String qname = Util.null2String(request.getParameter("qname"));
	String fromSubId = Util.null2String(request.getParameter("curSubId"));
	String from = Util.null2String(request.getParameter("from"));
	if(isEntryDetail.equals(""))isEntryDetail = "0";
	String titlename = "";
	String refresh = Util.null2String(request.getParameter("refresh"));
	String reftree = Util.null2String(request.getParameter("reftree"));
	String isUseFTPOfSystem=BaseBean.getPropValue("FTPConfig","ISUSEFTP");
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	categoryname = categoryname.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");
	String parentId = Util.null2String(RecordSet.getString("parentid"));
	String uploadExt=Util.null2String(RecordSet.getString("uploadExt"));
	subcompanyid = Util.getIntValue(RecordSet.getString("subcompanyid"));
 %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<%if(!isDialog.equals("1")){ %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<%} %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<script language=javascript >
var parentWin = null;
var parentDialog = null;
<%if(isDialog.equals("1")){%>
	parentWin = parent.parent.getParentWindow(parent);
	parentDialog = parent.parent.getDialog(parent);
<%}%>
if("<%=isclose%>"=="1"){
	 parentWin = parent.parent.getParentWindow(parent);
	 parentDialog = parent.parent.getDialog(parent);
	<%if(from.equals("")){%>
		//parentWin.location.href="DocMainCategoryList.jsp";
		parentWin.parent.parent.refreshTreeMain(<%=Util.getIntValue(parentId,0)%>,<%=Util.getIntValue(parentId,0)%>,true);
		parentWin._table.reLoad();
	<%}else if(from.equals("subedit")){%>
		parentWin.parent.parent.refreshTreeMain(<%=Util.getIntValue(parentId,0)%>,<%=Util.getIntValue(parentId,0)%>,true);
		//parentWin.location.href="/docs/category/DocSubCategoryBaseInfoEdit.jsp?id=<%=id%>";
		parentWin._table.reLoad();
	<%}else{%>
		//parentWin.location.href="/docs/category/DocSecCategoryBaseInfoEdit.jsp?refresh=1&id=<%=id%>";
		parentWin.parent.location.href="/docs/category/DocCategoryTab.jsp?_fromURL=3&refresh=1&reftree=1&id=<%=id%>";
	<%}%>
	parentWin.closeDialog();	
}

jQuery(document).ready(function(){
	<%if(!"1".equals(isDialog)){ %>
		jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:false,
	    	needInitBoxHeight:false,
	    	needFix:true,
	    	hideSelector:"#seccategorybox"
	    });
	<%}%>
	
	resizeDialog(document);
});

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function _userDelCallback(text,name){
	if(!jQuery("#parentid").val()){
		showEle("_subcompanyid");
	}
}

function showOrHideExtendAttr(e,datas,name,params){
	if(datas){
		if(datas.id){
			hideEle("_subcompanyid");
		}else{
			showEle("_subcompanyid");
		}
	}
}

//存为模板
function openDialog2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=10&curSubId=<%=id%>&from=secedit&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(19468,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 213;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

</script>
</head>
<%
MultiAclManager am = new MultiAclManager();

int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
CategoryManager cm = new CategoryManager();

	String parentName = scc.getAllParentName(""+id);
	String dirid = RecordSet.getString("dirid");
	String dirtype = RecordSet.getString("dirtype");
	String coder=Util.toScreenToEdit(RecordSet.getString("coder"),user.getLanguage());
	String subcategoryid=RecordSet.getString("subcategoryid");
	//String docmouldid=RecordSet.getString("docmouldid");
	/* added by wdl 2006.7.3 TD.4617 start */
	//String wordmouldid = RecordSet.getString("wordmouldid");
	/* added end */
	String publishable=RecordSet.getString("publishable");
	String replyable=RecordSet.getString("replyable");
	String shareable=RecordSet.getString("shareable");
    float secorder = RecordSet.getFloat("secorder");
    
	int logviewtype = Util.getIntValue(RecordSet.getString("logviewtype"),0);

	String cusertype=RecordSet.getString("cusertype");
	String cuserseclevel=RecordSet.getString("cuserseclevel");
	if(cuserseclevel.equals("255")) cuserseclevel="";
	String cdepartmentid1=RecordSet.getString("cdepartmentid1");
	String cdepseclevel1=RecordSet.getString("cdepseclevel1");
	if(cdepseclevel1.equals("255")) cdepseclevel1="";
	String cdepartmentid2=RecordSet.getString("cdepartmentid2");
	String cdepseclevel2=RecordSet.getString("cdepseclevel2");
	if(cdepseclevel2.equals("255")) cdepseclevel2="";
	String croleid1=RecordSet.getString("croleid1");
	String crolelevel1=RecordSet.getString("crolelevel1");
	String croleid2=RecordSet.getString("croleid2");
	String crolelevel2=RecordSet.getString("crolelevel2");
	String croleid3=RecordSet.getString("croleid3");
	String crolelevel3=RecordSet.getString("crolelevel3");
	String approvewfid=RecordSet.getString("approveworkflowid");
	String hasaccessory=RecordSet.getString("hasaccessory");
	String accessorynum=RecordSet.getString("accessorynum");
	String hasasset=RecordSet.getString("hasasset");
	String assetlabel=RecordSet.getString("assetlabel");
	String hasitems=RecordSet.getString("hasitems");
	String itemlabel=RecordSet.getString("itemlabel");
	String hashrmres=RecordSet.getString("hashrmres");
	String hrmreslabel=RecordSet.getString("hrmreslabel");
	String hascrm=RecordSet.getString("hascrm");
	String crmlabel=RecordSet.getString("crmlabel");
	String hasproject=RecordSet.getString("hasproject");
	String projectlabel=RecordSet.getString("projectlabel");
	String hasfinance=RecordSet.getString("hasfinance");
	String financelabel=RecordSet.getString("financelabel");

	String defaultDummyCata=Util.null2String(RecordSet.getString("defaultDummyCata"));
	int relationable  = Util.getIntValue(RecordSet.getString("relationable"),0);

    int markable=Util.getIntValue(Util.null2String(RecordSet.getString("markable")),0);
    int markAnonymity=Util.getIntValue(Util.null2String(RecordSet.getString("markAnonymity")),0);
    int orderable=Util.getIntValue(Util.null2String(RecordSet.getString("orderable")),0);
    int defaultLockedDoc=Util.getIntValue(Util.null2String(RecordSet.getString("defaultLockedDoc")),0);
    int isSetShare=Util.getIntValue(Util.null2String(RecordSet.getString("isSetShare")),0);
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
    
    int maxOfficeDocFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxOfficeDocFileSize")),8);
    int maxUploadFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxUploadFileSize")),0);
    int allownModiMShareL=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareL")),0);
    int allownModiMShareW=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareW")),0);
    String allowShareTypeStrs=Util.null2String(RecordSet.getString("allowShareTypeStrs"));
    ArrayList allowShareTypeList = Util.TokenizerString(allowShareTypeStrs,",");
    
    int noDownload = Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0);
    int noRepeatedName = Util.getIntValue(Util.null2String(RecordSet.getString("norepeatedname")),0);
    int bacthDownload = Util.getIntValue(Util.null2String(RecordSet.getString("bacthDownload")),0);
    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
	int pushOperation = Util.getIntValue(Util.null2String(RecordSet.getString("pushOperation")),0);
    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);
    String pushways=Util.null2String(RecordSet.getString("pushways"));
    String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
    int printApplyWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("printApplyWorkflowId")),0);
    
    String isLogControl = Util.null2String(RecordSet.getString("isLogControl"));
    
    int isOpenAttachment = Util.getIntValue(Util.null2String(RecordSet.getString("isOpenAttachment")),0);
    
    int isAutoExtendInfo = Util.getIntValue(Util.null2String(RecordSet.getString("isAutoExtendInfo")),0);

    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);
    int appointedWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("appointedWorkflowId")),0);    
    int appliedTemplateId = Util.getIntValue(Util.null2String(RecordSet.getString("appliedTemplateId")),0);
    String appliedTemplateName = "";
    if(appliedTemplateId>0){
    	RecordSet.executeSql(" select name from DocSecCategoryTemplate where id = " + appliedTemplateId);
    	RecordSet.next();
    	appliedTemplateName = Util.null2String(RecordSet.getString(1));
    }


    
   /* RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
    RecordSet.next();
    if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1||Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(subcategoryid),0)==1)
        noRepeatedName = 11;
*/
	boolean canEdit = false;
	boolean canAdd = false;
	boolean canDelete = false;
	boolean canLog = false;
	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(id, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	if(Util.getIntValue(parentId)>0){
		hasSecManageRight = am.hasPermission(Util.getIntValue(parentId), MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) ||hasSecManageRight){
	    canEdit = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) || hasSecManageRight){
        canAdd = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) || hasSecManageRight) {
    	if(km.getDocDirCheckbox(""+id).equals("true")){
        	canDelete = true;
    	}
    }
    if (HrmUserVarify.checkUserRight("DocSecCategory:log", user) || hasSecManageRight) {
        canLog = true;
    }

    int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
    int operatelevel=0;

	    if(detachable==1){
	    	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
	    }else{
	        if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
	            operatelevel=2;
	    }

 if(!canEdit)operatelevel = 0;
if(operatelevel>0){
	 canEdit = true;
	 canAdd = true;
	 if(km.getDocDirCheckbox(""+id).equals("true")){
        	canDelete = true;
    	}
	 canLog = true;
	 hasSubManageRight = true;
	 hasSecManageRight = true;

}else{
	 canEdit = false;
	 canAdd = false;
	 canDelete = false;
	 canLog = false;
	 hasSubManageRight = false;
	 hasSecManageRight = false;

}


String isdisplay="";
String ischeck="";

//求分目录中文档创建者相关的权限
String PCreater = "3";
String PCreaterManager = "1";
String PCreaterJmanager = "1";
String PCreaterDownOwner = "0";
String PCreaterSubComp = "0";
String PCreaterDepart = "0";
String PCreaterDownOwnerLS = "0";
String PCreaterSubCompLS = "0";
String PCreaterDepartLS = "0";

String PCreaterW = "3";
String PCreaterManagerW = "1";
String PCreaterJmanagerW = "1";

RecordSet1.executeSql("select * from secCreaterDocPope where secid = "+id);
if (RecordSet1.next()) {
    PCreater = Util.null2String(RecordSet1.getString("PCreater"));
    PCreaterManager = Util.null2String(RecordSet1.getString("PCreaterManager"));
    PCreaterJmanager = Util.null2String(RecordSet1.getString("PCreaterJmanager"));
    PCreaterDownOwner = Util.null2String(RecordSet1.getString("PCreaterDownOwner"));
    PCreaterSubComp = Util.null2String(RecordSet1.getString("PCreaterSubComp"));
    PCreaterDepart = Util.null2String(RecordSet1.getString("PCreaterDepart"));
    PCreaterDownOwnerLS = Util.null2String(RecordSet1.getString("PCreaterDownOwnerLS"));   
    PCreaterSubCompLS = Util.null2String(RecordSet1.getString("PCreaterSubCompLS"));   
    PCreaterDepartLS = Util.null2String(RecordSet1.getString("PCreaterDepartLS"));
    PCreaterW = Util.null2String(RecordSet1.getString("PCreaterW"));
    PCreaterManagerW = Util.null2String(RecordSet1.getString("PCreaterManagerW"));
    PCreaterJmanagerW = Util.null2String(RecordSet1.getString("PCreaterJmanagerW"));
}

String tempName = SubCategoryComInfo.getSubCategoryname(""+subcategoryid);
tempName = tempName.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");;
%>
<script type="text/javascript">
	try{
		//parent.setTabObjName("<%=categoryname%>");
		parent.jQuery("#objName").size() > 0 ? parent.jQuery("#objName").html("<%=categoryname%>") : parent.setTabObjName("<%=tempName%>");
	}catch(e){};
</script>
<style type="text/css">
	#seccategorybox{
		filter:alpha(opacity=0);
		-moz-opacity:0;
		-khtml-opacity: 0;
		opacity: 0;
	}
</style>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(!"1".equals(isDialog)){ %>
<div class="e8_box demo2" id="seccategorybox">
    <ul class="tab_menu">
       	 <li class="current">
        	<a href="#baseInfoSet" onclick="showItemArea('#baseInfoSet');__tabNamespace__.jumpToAnchor('#baseInfoSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
        	</a>
        </li>
         <li>
        	<a href="#managentSet" onclick="showItemArea('#managentSet');__tabNamespace__.jumpToAnchor('#managentSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(32383,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#shareSet" onclick="showItemArea('#shareSet');__tabNamespace__.jumpToAnchor('#shareSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#officeDocSet" onclick="showItemArea('#officeDocSet');__tabNamespace__.jumpToAnchor('#officeDocSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(32384,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#attachmentSet" onclick="showItemArea('#attachmentSet');__tabNamespace__.jumpToAnchor('#attachmentSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(23796,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#printSet" onclick="showItemArea('#printSet');__tabNamespace__.jumpToAnchor('#printSet');return false;">
        		<%=SystemEnv.getHtmlLabelName(20756,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#docLog" onclick="showItemArea('#docLog');__tabNamespace__.jumpToAnchor('#docLog');return false;">
        		<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage()) %>
        	</a>
        </li>
        <%if("1".equals(isUseFTPOfSystem)){ %>
			<li>
				<a href="#ftpconfig" onclick="showItemArea('#ftpconfig');__tabNamespace__.jumpToAnchor('#ftpconfig');return false;">
					<%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%>
				</a>
			</li>
		<%} %>
        <li>
        	<a href="#type" onclick="showItemArea('#type');__tabNamespace__.jumpToAnchor('#type');return false;">
        		<%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %>
        	</a>
        </li>
	        
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box" style="display:none;">
        <div>
        </div>
    </div>
</div>
<%} %>
	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(<%=isEntryDetail %>);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<%if("1".equals(isDialog)){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
				<%}else{ %>
					<input type=button class="e8_btn_top" onclick="onImport();" value="<%=SystemEnv.getHtmlLabelName(34243, user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<%if(canAdd && !"1".equals(isDialog)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog2(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<script type="text/javascript">
<%
if(messageid !=0) {
 if(messageid==87){
%>

top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21536,user.getLanguage())%>"); 
<% }else{
%>
top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%>");
<%}
}%>
<%
if(errorcode == 10) {
%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %>");
<%}%>
</script>
<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver name=weaver action="SecCategoryOperation.jsp" method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="fromtab" value="0">
<input type=hidden name="tab" value="0">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">
<input type="hidden" name="from" id="from" value="<%=from%>">
<input type="hidden" name="secId" id="secId" value="<%=fromSubId%>">
<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if(!"1".equals(isDialog)){
if (canEdit) {
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(34243,user.getLanguage())+",javascript:onImport(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(32520,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19468,user.getLanguage())+",javascript:onSaveAsTmpl(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

}if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)&&operatelevel>0){
	
RCMenu += "{Excel"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:onImportExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel,javascript:onExportExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<!-- 页面过大拆分 -->
	<jsp:include page="DocSecCategoryBaseInfoEdit_inner.jsp">
		<jsp:param name="canEdit_str" value="<%=canEdit %>"/>
		<jsp:param name="id" value="<%=id %>"/>
		<jsp:param name="hasSecManageRight_str" value="<%=hasSecManageRight %>"/>
		<jsp:param name="parentId" value="<%=parentId %>"/>
		<jsp:param name="parentName" value="<%=java.net.URLEncoder.encode(parentName, "UTF-8") %>"/>
		<jsp:param name="dirid" value="<%=dirid %>"/>
		<jsp:param name="dirtype" value="<%=dirtype %>"/>
		<jsp:param name="subcategoryid" value="<%=subcategoryid %>"/>
		<jsp:param name="categoryname" value="<%=java.net.URLEncoder.encode(categoryname, "UTF-8") %>"/>
		<jsp:param name="uploadExt" value="<%=uploadExt %>"/>
		<jsp:param name="coder" value="<%=coder %>"/>
		<jsp:param name="noRepeatedName" value="<%=noRepeatedName %>"/>
		<jsp:param name="detachable" value="<%=detachable %>"/>
		<jsp:param name="isDialog" value="<%=isDialog %>"/>
		<jsp:param name="isControledByDir" value="<%=isControledByDir %>"/>
		<jsp:param name="secorder" value='<%=secorder+"" %>'/>
		<jsp:param name="publishable" value="<%=publishable %>"/>
		<jsp:param name="defaultDummyCata" value="<%=defaultDummyCata %>"/>
		<jsp:param name="ischeck" value="<%=ischeck %>"/>
		<jsp:param name="PCreaterManager" value="<%=PCreaterManager %>"/>
		<jsp:param name="PCreaterSubCompLS" value="<%=PCreaterSubCompLS %>"/>
		
		<jsp:param name="isSetShare" value="<%=isSetShare %>"/>
		<jsp:param name="defaultLockedDoc" value="<%=defaultLockedDoc %>"/>
		<jsp:param name="noDownload" value="<%=noDownload %>"/>
		<jsp:param name="maxOfficeDocFileSize" value="<%=maxOfficeDocFileSize %>"/>
		<jsp:param name="maxUploadFileSize" value="<%=maxUploadFileSize %>"/>
		<jsp:param name="pubOperation" value="<%=pubOperation %>"/>
		<jsp:param name="pushOperation" value="<%=pushOperation %>"/>
		<jsp:param name="pushways" value="<%=pushways %>"/>
		<jsp:param name="orderable" value="<%=orderable %>"/>
		<jsp:param name="markable" value="<%=markable %>"/>
		<jsp:param name="markAnonymity" value="<%=markAnonymity %>"/>
		<jsp:param name="childDocReadRemind" value="<%=childDocReadRemind %>"/>
		<jsp:param name="relationable" value="<%=relationable %>"/>
		<jsp:param name="hashrmres" value="<%=hashrmres %>"/>
		<jsp:param name="hascrm" value="<%=hascrm %>"/>
		
		<jsp:param name="readOpterCanPrint" value="<%=readOpterCanPrint %>"/>
		<jsp:param name="replyable" value="<%=replyable %>"/>
		<jsp:param name="appointedWorkflowId" value="<%=appointedWorkflowId %>"/>
		<jsp:param name="allownModiMShareL" value="<%=allownModiMShareL %>"/>
		<jsp:param name="shareable" value="<%=shareable %>"/>
		<jsp:param name="bacthDownload" value="<%=bacthDownload %>"/>
		<jsp:param name="isOpenAttachment" value="<%=isOpenAttachment %>"/>
		<jsp:param name="isAutoExtendInfo" value="<%=isAutoExtendInfo %>"/>
		<jsp:param name="isPrintControl" value="<%=isPrintControl %>"/>
		<jsp:param name="printApplyWorkflowId" value="<%=printApplyWorkflowId %>"/>
		<jsp:param name="logviewtype" value="<%=logviewtype %>"/>
		<jsp:param name="isLogControl" value="<%=isLogControl %>"/>
		<jsp:param name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem %>"/>
		<jsp:param name="hasasset" value="<%=hasasset %>"/>
		<jsp:param name="assetlabel" value="<%=assetlabel %>"/>
		<jsp:param name="hrmreslabel" value="<%=hrmreslabel %>"/>
		
		<jsp:param name="hasproject" value="<%=hasproject %>"/>
		<jsp:param name="crmlabel" value="<%=crmlabel %>"/>
		<jsp:param name="projectlabel" value="<%=projectlabel %>"/>
		<jsp:param name="approvewfid" value="<%=approvewfid %>"/>
		<jsp:param name="PCreater" value="<%=PCreater %>"/>
		<jsp:param name="PCreaterSubComp" value="<%=PCreaterSubComp %>"/>
		<jsp:param name="PCreaterDepart" value="<%=PCreaterDepart %>"/>
		<jsp:param name="PCreaterDepartLS" value="<%=PCreaterDepartLS %>"/>
		<jsp:param name="PCreaterW" value="<%=PCreaterW %>"/>
		<jsp:param name="PCreaterManagerW" value="<%=PCreaterManagerW %>"/>
		
		<jsp:param name="subcompanyid" value="<%=subcompanyid %>"/>
		<jsp:param name="appliedTemplateName" value="<%=appliedTemplateName %>"/>
		<jsp:param name="operatelevel" value="<%=operatelevel %>"/>
		<jsp:param name="appliedTemplateId" value="<%=appliedTemplateId %>"/>
		<jsp:param name="software" value="<%=software %>"/>
		
	</jsp:include>

   <SCRIPT language="javaScript">
       function onSelectChange(obj1,obj2){
            var selectValue = obj1.value;
            if (selectValue!=0) obj2.style.display="";
            else  obj2.style.display="none";           
       }
   
   </SCRIPT>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">

function checkPositiveNumber(label,obj){
	var def = jQuery(obj).attr("defValue");
	if(obj.value<0){
		alert("'"+label+"'<%=SystemEnv.getHtmlLabelName(22065,user.getLanguage())%>")
		obj.value=def;
	}
}

function changeTemplate(e,data,name){
	if(data){
		if(data.id!="0"&&data.id!=""){
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18767,user.getLanguage())%>",function(){
				window.location="/docs/category/DocSecCategorySaveAsTmplOperation.jsp?isdialog=<%=isDialog%>&secCategoryId=<%=id%>&tmplId="+data.id+"&method=getsettingfromtmpl"
			});
		
		}else{
			$GetEle("dirmouldid").value="";
			$GetEle("dirmouldidspan").innerHTML="";
		}
	}
}
function onSaveAsTmpl(obj){
	//window.parent.location="DocSecCategorySaveAsTmpl.jsp?id=<%=id%>";
	openDialog2(<%=id %>);
}
function onImportExcel(){
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=100&isdialog=1&categoryid=<%=id%>";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window; 
	dialog.Title = "Excel<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.CancelEvent = function(){
		if(dialog.innerWin.tabcontentframe.location.href.indexOf("SecCategoryImportResult.jsp") > -1){
			parent.parent.location.href = parent.parent.location.href;
		}
		dialog.close();
	};
	dialog.show();
}
function onExportExcel() {
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/category/SecCategoryExport.jsp?isall=0";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";
	dialog.Width = 360;
	dialog.Height = 120;
	dialog.normalDialog=false;
	dialog.Drag = true;
	dialog.OKEvent = function(){
		if(dialog.innerFrame.contentWindow.document.getElementById('isinclude').checked){
			window.location.href="/docs/category/SecCategoryExportProcess.jsp?ids="+<%=id%>+"&isinclude=1";
		}else{
			window.location.href="/docs/category/SecCategoryExportProcess.jsp?ids="+<%=id%>;
		}
	dialog.close();
	};//点击确定后调用的方法
	dialog.URL = url;
	dialog.show();
}
function onSave(isEnterDetail){
	try{
		parent.disableTabBtn();
	}catch(e){}
	if(isEnterDetail)jQuery('#isentrydetail').val(isEnterDetail);
	if(check_form(document.weaver,'categoryname')){
		<%if(detachable==1 && Util.getIntValue(parentId)<=0){%>
			if(check_form(document.weaver,'subcompanyId')){
		<%}%>
		document.weaver.operation.value="edit";
		document.weaver.submit();
		<%if(detachable==1 && Util.getIntValue(parentId)<=0){%>
			}else{
				try{
					parent.enableTabBtn();
				}catch(e){}
			}
		<%}%>
	}else{
		try{
			parent.enableTabBtn();
		}catch(e){}
	}
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function onImport(){
	jQuery('#dirMouldBtn').trigger('click');
}
function onNew(){
	//window.parent.location="DocSecCategoryAdd.jsp?id=<%=subcategoryid%>&mainid=<%=mainid%>";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=8&from=subedit&OriSubId=<%=id%>&isdialog=1&id=<%=parentId%>&mainid=<%=mainid%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	dialog.Width = 650;
	dialog.Height = 360;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function onLog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&secid=66&sqlwhere=<%=xssUtil.put("where operateitem=3 and relatedid="+id)%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17480",user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 610;
	dialog.checkDataChange = false;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.weaver.operation.value="delete";
		document.weaver.submit();
	});
}
function onMarkableClick(){
		var markable=$G("markable")
		var markAnonymity=$G("markAnonymity")
    if(markable.checked){
    	disOrEnableSwitch(markAnonymity,false)
    } else {
    	changeSwitchStatus(markAnonymity,false)
      disOrEnableSwitch(markAnonymity,true)
    }
}

function onPushOperationClick(){
		var pushOperation=$G("pushOperation");
		var pushway=jQuery(".pushway");
    if(pushOperation.checked){
    	pushway.css("display",""); 
    } else {
    	pushway.css("display","none"); 
    }
}

//与共享相关的操作 
 function onOrderAbleClick(obj,obj2,obj3) {
     if (obj.checked){
         obj2.checked = true;
         obj3.checked = true;
         obj2.disabled = true;
         obj3.disabled = false ;
     } else {
         obj2.disabled = false ;
         obj3.disabled = true ;
     }
 }
function allowAddSharer3Onclick(obj) { //完全控制者
    if (obj.checked){       
    } else {
        if (document.getElementById("allowAddSharer4").checked||document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("<%= SystemEnv.getHtmlLabelName(83397,user.getLanguage())%>")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer4Onclick(obj) { //编辑权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
    }else {
        if (document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("<%=SystemEnv.getHtmlLabelName(83399,user.getLanguage())%>")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer5Onclick(obj) { //查看权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
       document.getElementById("allowAddSharer4").checked = true;
    }
}
  function chkAllClick(obj){   
    var chks = document.getElementsByName("chkShareId");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function onDelShare(){   
    document.weaver.action="ShareOperation.jsp?secid=<%=id%>&method=delMShare";
    document.weaver.submit();
}

function showFTPConfig(){
    if($GetEle("isUseFTP").checked){
        //document.all("FTPConfigDiv").style.display = "block";
        showEle("FTPConfigDiv");
    }else{
    	//document.all("FTPConfigDiv").style.display = "none";
    	hideEle("FTPConfigDiv");
    }
}

function loadDocFTPConfigInfo(obj){
	$GetEle("DocFTPConfigInfoGetter").src="DocFTPConfigIframe.jsp?operation=loadDocFTPConfigInfo&FTPConfigId="+obj.value;
}


function returnDocFTPConfigInfo(FTPConfigName,FTPConfigDesc,serverIP,serverPort,userName,userPassword,defaultRootDir,maxConnCount,showOrder){
	FTPConfigNameSpan.innerHTML=FTPConfigName;
	FTPConfigDescSpan.innerHTML=FTPConfigDesc;
	serverIPSpan.innerHTML=serverIP;
	serverPortSpan.innerHTML=serverPort;
	userNameSpan.innerHTML=userName;
	userPasswordSpan.innerHTML=userPassword;
	defaultRootDirSpan.innerHTML=defaultRootDir;
	maxConnCountSpan.innerHTML=maxConnCount;
	showOrderSpan.innerHTML=showOrder;
}
function setBacthDownload(o){
    var bacthDownload = document.getElementById("bacthDownload");
 	if(o.checked){
 	 //bacthDownload.value="1";
 	 //bacthDownload.checked="true";
 	 bacthDownload.disabled="true"
 	 
 	}else{
 	  //bacthDownload.value="";
 	  //bacthDownload.checked=false;
 	  bacthDownload.disabled=false;

 	}
 }
</script>
<script type="text/javascript">
 $(document).ready(function(){
 	<% if(refresh.equals("1")){%>
 		parent.parent.refreshTreeMain(<%=id%>,<%=Util.getIntValue(parentId,0)%>,<%=reftree.equals("1")?true:false%>);
 	<%}%>
    $($GetEle("noDownload")).click(function(){
	    if($($GetEle("noDownload")).attr("checked")==true){
			$($GetEle("bacthDownload")).trigger("checked",false);
	         $($GetEle("bacthDownload")).trigger("disabled",true);
			  
	    }else{
	          $($GetEle("bacthDownload")).trigger("disabled",false);
	    }
   });
   jQuery(".e8tips").wTooltip({html:true});
 });


 var diag_vote;
 function settingForNewDoc(){
     <%if(!canEdit){%>
			return;
	 <%}%>
     if(window.top.Dialog){
         diag_vote = new window.top.Dialog();
     } else {
         diag_vote = new Dialog();
     }
     diag_vote.currentWindow = window;
     diag_vote.Width = 800;
     diag_vote.Height = 500;
     diag_vote.Modal = true;
     diag_vote.Title = "设置";
     diag_vote.URL = "/docs/remindfornew/commonTab.jsp?urlType=1&secid=<%=secid%>";
     diag_vote.show();
 }

</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');onSave(this);">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');onSave(this);">
		    	<span class="e8_sep_line">|</span>--%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
	
</div>
	
<%} %>
</BODY></HTML>

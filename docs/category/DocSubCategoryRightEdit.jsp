
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<% 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#searchfrm").submit();
	}
	function reloadPage(){
		window.location.reload();
	}
	var parentWin = null;
	<%if("1".equals(isDialog)){%>
		var refreshDialog = true;
		parentWin =parent.parent.getParentWindow(parent);
	<%}%>
</script>
</head>
<%
String pageSize = PageIdConst.getPageSize(PageIdConst.DOC_SUBCATEGORRIGHT,user.getUID(),PageIdConst.DOC);
String pageId = PageIdConst.DOC_SUBCATEGORRIGHT;
int id = Util.getIntValue(request.getParameter("id"),0);
String categoryname=SubCategoryComInfo.getSubCategoryname(""+id);
String coder = SubCategoryComInfo.getCoder(""+id);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+id),0);
int fathersubid = Util.getIntValue(SubCategoryComInfo.getFatherSubCategoryid(""+id),-1);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
boolean canEdit = false;
boolean canAdd = false;
boolean canDelete = false;
boolean canLog = false;
boolean hasSubManageRight = false;
AclManager am = new AclManager();
String  operateString= "";
String sqlWhere = "";
String tabletype="none";
String tableString = "";
String intanceid = "subPermission";

/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
//hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:edit", user) || hasSubManageRight) {
    canEdit = true;
}


if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) || hasSubManageRight) {
    canAdd = true;
}

if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:Delete", user) || hasSubManageRight) {
    canDelete = true;
}
if (HrmUserVarify.checkUserRight("DocSubCategory:log", user) || hasSubManageRight) {
    canLog = true;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(66,user.getLanguage())+":"+categoryname;
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
%>

<%
   int[] labels = {92,633,385};
   int operationcode = AclManager.OPERATION_CREATEDIR;
   int categorytype = AclManager.CATEGORYTYPE_SUB;
%>
<BODY>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_SUBCATEGORRIGHT %>"/>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
<%
if(errorcode == 10) {
%>
<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onPermissionDelShare"+operationcode+"(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onPermissionDelShare<%=operationcode%>();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="SubCategoryOperation.jsp" method=post>
<DIV>

<%@ include file="/docs/category/PermissionList.jsp" %>

<input type=hidden name="operation">
<script>
function onSave(){
	window.parent.location = "DocSubCategoryEdit.jsp?id=<%=id%>";
}
//增加权限
var dialog = null;

function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/category/AddCategoryPermission.jsp?categoryid=<%=id%>&categorytype=<%=categorytype%>&operationcode=<%=operationcode%>";
	dialog.Title = "<%=am.getMultiLabel(labels,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 285;
	dialog.isIframe = false;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>		
<%} %>
</BODY></HTML>

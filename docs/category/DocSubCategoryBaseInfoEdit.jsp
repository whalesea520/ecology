
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
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<% 
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
	int id = Util.getIntValue(request.getParameter("id"),0);
	String from = Util.null2String(request.getParameter("from"));
	if(isEntryDetail.equals(""))isEntryDetail = "0";
	String qname = Util.null2String(request.getParameter("flowTitle"));
	boolean showList = false;
	RecordSet.executeSql("select 1 from DocSecCategory where subCategoryId=" + id);
	if(RecordSet.next()){
		showList = true;
	}
	int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+id),0);
	String refresh = Util.null2String(request.getParameter("refresh"));
	String optype = Util.null2String(request.getParameter("optype"));
	if(isDialog.equals("1") && isclose.equals("1")){
		optype = "1";
		if(isEntryDetail.equals("1")){
			optype="0";
		}
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var parentDialog = null;
<%if("1".equals(isDialog)){ %>
	parentWin = parent.parent.getParentWindow(parent);
	parentDialog = parent.parent.getDialog(parent);
<%}%>
if("<%=isclose%>"=="1"){
	parentWin = parent.parent.getParentWindow(parent);
	parentDialog = parent.parent.getDialog(parent);
	<%if(id==0){%>
		//parentWin.location.href="/docs/category/DocMainCategoryList.jsp";
		parentWin._table.reLoad();
	<%}else if(from.equals("mainedit")){%>
		parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=id%>);
		//parentWin.location.href="/docs/category/DocMainCategoryBaseInfoEdit.jsp?id=<%=id%>";
		parentWin._table.reLoad();
	<%}else{%>
		parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=mainid%>);
		//parentWin.location.href="/docs/category/DocSubCategoryBaseInfoEdit.jsp?id=<%=id%>";
		parentWin.parent.location.href="/docs/category/DocCategoryTab.jsp?_fromURL=2&id=<%=id%>";
	<%}%>
	
	parentWin.closeDialog();	
}

jQuery(document).ready(function(){
	<% if(refresh.equals("1")){%>
		parent.parent.refreshTreeMain(<%=id%>,<%=mainid%>);
	<%}%>
});

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		for(var i=0;i<idArr.length;i++){
			jQuery.ajax({
				url:"SecCategoryOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:false,
				dataType:"text",
				success:function(data){
				},
				complete:function(xhr,status){
					if(i==idArr.length-1){
						_table.reLoad();
						parent.parent.refreshTreeMain(<%=id%>,<%=id%>);
						//_xtable_CleanCheckedCheckbox();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建子目录
function openDialog3(id,isedit){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=8&from=subedit&isdialog=1&id="+id+"&mainid=<%=mainid%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,67",user.getLanguage())%>";
	if(!!isedit){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=9&curSubId=<%=id%>&isdialog=1&from=subedit&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,67",user.getLanguage())%>";
	}
	dialog.Width = 650;
	dialog.Height = 356;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//编辑子目录
function openDialog4(id){
	openDialog3(id,"1");
}

//存为模板
function openDialog2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=10&curSubId=<%=id%>&from=subedit&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(19468,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 213;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//新建分目录
function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=4&optype=0&curSubId=<%=id%>&from=subedit&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,66",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLogSec(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&secid=66&sqlwhere=<%=xssUtil.put("where operateitem=3 and relatedid=")%>&relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17480",user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 610;
	dialog.Drag = true;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

//目录权限维护
function openDialog5(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		return;
	}
	var url="/docs/tabs/DocCommonTab.jsp?_fromURL=11&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 472;
	dialog.Drag = true;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&secid=66&sqlwhere=<%=xssUtil.put("where operateitem=2 and relatedid="+id)%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17480",user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 610;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.checkDataChange = false;
	dialog.URL = url;
	dialog.show();
}

</script>
<%if(!isDialog.equals("1")){ %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<%} %>
</head>
<%
String categoryname=SubCategoryComInfo.getSubCategoryname(""+id);
categoryname = categoryname.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");
String coder = SubCategoryComInfo.getCoder(""+id);
int noRepeatedName = Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(""+id),0);

int fathersubid = Util.getIntValue(SubCategoryComInfo.getFatherSubCategoryid(""+id),-1);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
RecordSet.executeSql("select suborder from DocSubCategory where id = "+id);
RecordSet.next();
float suborder = RecordSet.getFloat("suborder");//顺序
RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
RecordSet.next();
if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1) noRepeatedName = 11;

boolean canEdit = false;
boolean canAdd = false;
boolean canDelete = false;
boolean canLog = false;
boolean hasSubManageRight = false;
AclManager am = new AclManager();

/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
//hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:edit", user) || hasSubManageRight) {
    canEdit = true;
}
boolean hasSecManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);;

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
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=categoryname%>");
	}catch(e){}
	jQuery(document).ready(function(){
		try{
			if("<%=optype%>"!="1"){
				jQuery("#sublist",parent.document).removeClass("current");
				jQuery("#baseinfo",parent.document).addClass("current");
			}
		}catch(e){
			
		}
	});
</script>
<BODY>

<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(!"1".equals(isDialog)){ 
	if(!optype.equals("1")){
		if (canEdit) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		}if(canAdd){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())+",javascript:openDialog("+mainid+"),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		}
		if(canDelete && !showList){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		}if(canLog){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		}
	}else{
		if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) ||hasSecManageRight){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(67,user.getLanguage())+",javascript:onNewSec(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(HrmUserVarify.checkUserRight("DocSecCategoryDelete:delete", user) ||hasSecManageRight){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(67,user.getLanguage())+",javascript:doDel(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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

<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

	<form action="" name="searchfrm" id="searchfrm">
	<INPUT type=hidden name="id" value="<%=id%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!"1".equals(isDialog)){ %>
				<%if(optype.equals("1")){ %>
					<%if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)||hasSecManageRight){ %>
						<input type=button class="e8_btn_top" onclick="openDialog3(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
					<%} %>
					<%if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user)||hasSecManageRight){ %>
						<input type=button class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="doDel();" ></input>
					<%} %>
				<%}else{ %>
					<%if(canEdit){ %>
						<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
					<%} %>
					<%if(HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)){ %>
						<input type=button class="e8_btn_top" onclick="openDialog(<%=mainid %>);" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
					<%} %>
				<%} %>
			<%}else{ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(<%= isEntryDetail%>);">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%
	String sqlWhere = "subcategoryid="+id;
	if(!qname.equals("")){
		sqlWhere += " and categoryname like '%"+qname+"%'";
	}
	String  operateString= "";
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDocSecDirOperate\" otherpara=\""+HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("DocSubCategoryEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("DocSubCategory:log", user)+":"+HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog4();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:onLogSec();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog2();\" text=\""+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog5();\" text=\""+SystemEnv.getHtmlLabelName(32452,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage())+"\" index=\"4\"/>";
	 	       operateString+="</operates>";	
	 String tabletype="checkbox";
	 if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user)){
	 	tabletype = "checkbox";
	 }
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_SUBCATEGORYDETAIL+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_SUBCATEGORYDETAIL,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocSecDirCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategory\" sqlorderby=\"secorder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
			 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" href=\""+Util.toHtmlForSplitPage("/docs/category/DocCategoryTab.jsp?_fromURL=3&refresh=1")+"\" column=\"categoryname\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"/>"+
			 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19388,user.getLanguage())+"\" column=\"coder\"/>"+
			 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(88,user.getLanguage())+"\" column=\"secorder\"/>"+
	   "</head>"+
	   "</table>";
%>

<FORM id=weaver name=frmMain action="SubCategoryOperation.jsp" method=post>
<%if(!"1".equals(isDialog)){ %>
	<input type="hidden" name="from" id="from" value="subedit">
<%}else{ %>
	<input type="hidden" name="from" id="from" value="<%=from%>">
<%} %>

 <wea:layout>
 	<%if(!optype.equals("1")){ %>
    <wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></wea:item>
    	<wea:item><INPUT type=hidden name="id" value='<%=id%>'><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
    	<wea:item><INPUT type=hidden name="mainid" value='<%=mainid%>'><%=id%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelNames("66,33439",user.getLanguage())%></wea:item>
    	<wea:item>
    		<wea:required id="categorynamespan" required="true" value='<%=categoryname%>'>
    		<%if(canEdit){%>
	    		<INPUT class=InputStyle temptitle="<%=SystemEnv.getHtmlLabelNames("66,33439",user.getLanguage())%>" maxLength=100 size=60 name="categoryname" value="<%=categoryname%>"
	          onChange="checkinput('categoryname','categorynamespan')">
	          <%}else{%><%=categoryname%><%}%>
	          <INPUT type=hidden maxLength=60 size=50 name="srccategoryname" value="<%=categoryname%>">
    		</wea:required>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></wea:item>
    	<wea:item><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value='<%=coder%>'><%}else{%><%=coder%><%}%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
    	<wea:item><%if(canEdit){%><INPUT maxLength=5 size=5 class=InputStyle style="width:30px;" name="suborder" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("suborder")' value='<%=suborder%>'><%}else{%><%=suborder%><%}%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></wea:item>
    	<wea:item>
    		<INPUT type="checkbox" tzCheckbox="true" class=InputStyle name="norepeatedname" value="1" <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> <%if(!canEdit){%>disabled<%}%>>
    	</wea:item>
    	<%      if (fathersubid >= 0) {   %>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></wea:item>
	    	<wea:item><INPUT type=hidden name="subid" value='<%=fathersubid%>'><%=SubCategoryComInfo.getSubCategoryname(""+fathersubid)%></wea:item>
	    <%} %>
    </wea:group>
    <%
	String isUseFTPOfSystem=BaseBean.getPropValue("FTPConfig","ISUSEFTP");
	if(!"1".equals(isDialog) && "1".equals(isUseFTPOfSystem)){
		String refreshSec="1";
		String isUseFTP="0";
		int FTPConfigId=0;
		String FTPConfigName="";
		String FTPConfigDesc="";
		String serverIP="";
		String serverPort="";
		String userName="";
		String userPassword="";
		String defaultRootDir="";
		int maxConnCount=0;
		float showOrder=0;

		RecordSet.executeSql("select * from DocSubCatFTPConfig where subCategoryId=" + id);
		if(RecordSet.next()){
			refreshSec = Util.null2String(RecordSet.getString("refreshSec"));
			isUseFTP = Util.null2String(RecordSet.getString("isUseFTP"));
			FTPConfigId = Util.getIntValue(RecordSet.getString("FTPConfigId"),0);
		}

		if(FTPConfigId==0){
			DocFTPConfigComInfo.setTofirstRow();
			if(DocFTPConfigComInfo.next()){
				FTPConfigId=Util.getIntValue(DocFTPConfigComInfo.getId(),0);
			}
		}

		FTPConfigName = Util.null2String(DocFTPConfigComInfo.getFTPConfigName(""+FTPConfigId));
		FTPConfigDesc = Util.null2String(DocFTPConfigComInfo.getFTPConfigDesc(""+FTPConfigId));
		serverIP = Util.null2String(DocFTPConfigComInfo.getServerIP(""+FTPConfigId));
		serverPort = Util.null2String(DocFTPConfigComInfo.getServerPort(""+FTPConfigId));
		userName = Util.null2String(DocFTPConfigComInfo.getUserName(""+FTPConfigId));
		userPassword = Util.null2String(DocFTPConfigComInfo.getUserPassword(""+FTPConfigId));
        if(!userPassword.equals("")){
		    userPassword="●●●●●●";
	    }
		defaultRootDir = Util.null2String(DocFTPConfigComInfo.getDefaultRootDir(""+FTPConfigId));
		maxConnCount = Util.getIntValue(DocFTPConfigComInfo.getMaxConnCount(""+FTPConfigId),0);
		showOrder = Util.getFloatValue(DocFTPConfigComInfo.getShowOrder(""+FTPConfigId),0);
%>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%>'>
    	<wea:item>
				<INPUT type="hidden" name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem%>">
				<%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%>
			</wea:item>
			<wea:item><INPUT type="checkbox" name="refreshSec" value="1" <%if(!refreshSec.equals("0")){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22518,user.getLanguage())%></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
			<wea:item><INPUT type="checkbox" class=InputStyle name="isUseFTP" value="1" onclick="showFTPConfig()"  <%if("1".equals(isUseFTP)){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>></wea:item>
			<%String attrs = "{\"isTableList\":true,'colspan':'full'"; %>
			<%
			attrs += ",\"samePair\":\"FTPConfigDiv\"";
			attrs += ",\"display\":\""+("1".equals(isUseFTP)?"":"none")+"\"}";
					%>
			<wea:item attributes='<%=attrs %>'>
					
					<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></wea:item>
							<wea:item>
								 <SELECT class=inputstyle name="FTPConfigId" onChange="loadDocFTPConfigInfo(this)">
									<%
						            DocFTPConfigComInfo.setTofirstRow();
						            while(DocFTPConfigComInfo.next()){
									%>
						                <OPTION value=<%= DocFTPConfigComInfo.getId() %> <% if(Util.getIntValue(DocFTPConfigComInfo.getId(),-1) == FTPConfigId) { %> selected <% } %> ><%= DocFTPConfigComInfo.getFTPConfigName() %></OPTION>
									<%
						            }
									%>
						        </SELECT>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="FTPConfigNameSpan"><%=FTPConfigName%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="FTPConfigDescSpan"><%=FTPConfigDesc%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
							<wea:item> <SPAN id="serverIPSpan"><%=serverIP%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="serverPortSpan"><%=serverPort%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="userNameSpan"><%=userName%></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="userPasswordSpan"><%=userPassword%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="defaultRootDirSpan"><%=defaultRootDir%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></wea:item>
							<wea:item> <SPAN id="maxConnCountSpan"><%=maxConnCount%></SPAN></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
							<wea:item><SPAN id="showOrderSpan"><%=showOrder%></SPAN></wea:item>
						</wea:group>
					</wea:layout>
			</wea:item>
		</wea:group>
		<%} %>
		<%} %>
		<%if(!"1".equals(isDialog)){ %>
			<%if(optype.equals("1")){ %>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(27170,user.getLanguage())+SystemEnv.getHtmlLabelName(67,user.getLanguage())%>'  attributes="{\"groupDisplay\":\"none\"}">
					
					<wea:item attributes="{\"isTableList\":true}">
						<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_SUBCATEGORYDETAIL %>"/>
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
					</wea:item>
				</wea:group>
			<%} %>
	<%} %>
 </wea:layout>	
<input type=hidden name="operation">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');onSave();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');onSave();">
		    	<span class="e8_sep_line">|</span> --%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	
<%} %>

</BODY></HTML>
<script>
function onNew(){
	window.parent.location="DocSubCategoryAdd.jsp?id=<%=mainid%>";
}
function onNewSec(){
	//window.parent.location="DocSecCategoryAdd.jsp?id=<%=id%>&mainid=<%=mainid%>";
	openDialog3(<%=id %>);
}
function onSave(isEnterDetail){
	if(isEnterDetail){
		jQuery('#isentrydetail').val(isEnterDetail);
	}
	if(check_form(document.frmMain,'categoryname')){
		//document.frmMain.target="contentframe";
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}
function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		//document.frmMain.target="contentframe";
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	});
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

jQuery(document).ready(function(){
	resizeDialog(document);
});

</script>


<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.FormModeConfig"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page"/>
<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
 
AppInfoService appInfoService = new AppInfoService();
ModelInfoService modelInfoService = new ModelInfoService();
FormInfoService formInfoService = new FormInfoService();
int appId = Util.getIntValue(request.getParameter("appId"), 0);
int modelId = Util.getIntValue(request.getParameter("id"), 0);
if(modelId<=0){
	modelId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId = Util.getIntValue(request.getParameter("formId"),0);
if(modelId > 0 && formId == 0){
	formId = modelInfoService.getFormInfoIdByModelId(modelId); 
}

boolean isloadleft = Util.null2String(request.getParameter("isloadleft")).equals("1");

Map<String, Object> data = modelInfoService.getModelInfoById(modelId);
String modeName = Util.null2String(data.get("modename")); //模型
String modeDesc = Util.null2String(data.get("modedesc"));
String operate = modelId<=0?"AddMode":"EditMode";
int modetype = Util.getIntValue(Util.null2String(data.get("modetype")),0);
int tempId = modetype;
if(tempId==0){
	tempId = appId;
}
Map<String, Object> appInfo = appInfoService.getAppInfoById(tempId);
String modetypename = Util.null2String(appInfo.get("treefieldname")); //模块

if(modetype>0){
	appId = modetype;
}

Map<String, Object> formdata = formInfoService.getFormInfoById(formId);
String formName = Util.null2String(formdata.get("labelname")); //表单
String tableName = Util.null2String(formdata.get("tablename"));

//TODO java
int showhtmlid=0, addhtmlid=0, edithtmlid=0, monitorhtmlid=0, printhtmlid=0;
String showhtmlname="", addhtmlname="", edithtmlname="", monitorhtmlname="", printhtmlname="";
int showhtmlversion=0, addhtmlversion=0, edithtmlversion=0, monitorhtmlversion=0, printhtmlversion=0;	
RecordSet.executeSql("select * from modehtmllayout where modeid="+modelId+" and formid="+formId+" and isdefault=1");
while(RecordSet.next()){
	int type_tmp = Util.getIntValue(RecordSet.getString("type"), 0);
	int id_tmp = Util.getIntValue(RecordSet.getString("id"), 0);
	String layoutname_tmp = Util.null2String(RecordSet.getString("layoutname"));
	int version_tmp = Util.getIntValue(RecordSet.getString("version"), 0);
	switch(type_tmp){
		case 0 :
			showhtmlid = id_tmp;
			showhtmlname = layoutname_tmp;
			showhtmlversion = version_tmp;
		break ;
		case 1 :
			addhtmlid = id_tmp;
			addhtmlname = layoutname_tmp;
			addhtmlversion = version_tmp;
		break ;
		case 2 :
			edithtmlid = id_tmp;
			edithtmlname = layoutname_tmp;
			edithtmlversion = version_tmp;
		break ;
		case 3 :
			monitorhtmlid = id_tmp;
			monitorhtmlname = layoutname_tmp;
			monitorhtmlversion = version_tmp;
		break ;
		case 4 :
			printhtmlid = id_tmp;
			printhtmlname = layoutname_tmp;
			printhtmlversion = version_tmp;
		break ;
	}
}

String maincategory = Util.null2String(data.get("maincategory"));
String subcategory = Util.null2String(data.get("subcategory"));
String seccategory = Util.null2String(data.get("seccategory"));

int categorytype = Util.getIntValue(Util.null2String(data.get("categorytype")),0);
int selectcategory = Util.getIntValue(Util.null2String(data.get("selectcategory")),0);
String path = "";
if(!seccategory.equals("0")){
	path=SecCCI.getAllParentName(seccategory,true);
}
int isImportDetail = Util.getIntValue(Util.null2String(data.get("isimportdetail")),0);
int codeid = Util.getIntValue(Util.null2String(data.get("codeid")),0);
String DefaultShared = Util.null2String(data.get("defaultshared"));
String NonDefaultShared = Util.null2String(data.get("nondefaultshared"));
String dsporder = Util.null2String(data.get("dsporder"));
RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formId);
int isvirtualform = 0;
if(RecordSet.next()){
	isvirtualform = RecordSet.getInt("isvirtualform");
}

String titlename=SystemEnv.getHtmlLabelName(19049,user.getLanguage())+" / " + modeName +" / "+SystemEnv.getHtmlLabelName(81990,user.getLanguage());//模块 / xx / 基础

int subCompanyId = Util.getIntValue(Util.null2String(data.get("subCompanyId")),-1);
if(subCompanyId==-1){
	subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId2 = ""+subCompanyId;
if(modelId<=0){
	int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);
	subCompanyId2 = ""+currentSubCompanyId;
}
String isEnFormModeReply = "";
int fmComModeid = 0;
int isAllowReply = Util.getIntValue(Util.null2String(data.get("isAllowReply")),0);
int isAddRightByWorkFlow = Util.getIntValue(Util.null2String(data.get("isaddrightbyworkflow")),1);
FormModeConfig formModeConfig = new FormModeConfig();
RecordSet.executeSql("select * from formEngineSet where isdelete=0");
if(RecordSet.next()){
	fmComModeid = RecordSet.getInt("modeid");
	isEnFormModeReply = RecordSet.getString("isEnFormModeReply");
}
%>
<html>
<head>
	<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<style type="text/css">
.checkSuccess{
	background: url('/images/BacoCheck_wev8.gif') no-repeat;
	padding-left: 20px;
	background-position: left 2px;
}
</style>
<link href="/formmode/css/formmode_wev8.css?v=1" type="text/css" rel="stylesheet" />
<link href="/mobilemode/css/mec/handler/Navigation_wev8.css" type="text/css" rel="stylesheet" />

<style>
a:hover{color:#0072C6 !important;}
.e8_data_virtualform{
	background: url(/formmode/images/circleBgGold_wev8.png) no-repeat 1px 1px;
	width: 16px;
	display:inline;
	color: #fff;
	font-size: 9px;
	font-style: italic;
	top: 5px;
	padding-left: 3px;
	padding-right: 6px;
	padding-top: 2px;
/* 	padding-bottom: 4px; */
	
}
</style>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(modelId>0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28349,user.getLanguage())+", javascript:newModel(),_top} " ;//新建模块
	RCMenuHeight += RCMenuHeightStep ;
	}
	//td84541去掉删除按钮
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteData(),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	if(!Util.null2String(formId).equals("")){
	//if(formId>0){
		if(modelId>0)
		{
			//废弃模块
			RCMenu += "{"+SystemEnv.getHtmlLabelName(81999,user.getLanguage())+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+",javascript:deleteMode("+modelId+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			//创建菜单新建
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(82,user.getLanguage())+"),javascript:createMenuNew(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//查看菜单地址新建
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(82,user.getLanguage())+"),javascript:viewmenu(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form name="weaver" id="weaver" method="post" action="/formmode/setup/ModeOperation.jsp">
<input type="hidden" name="modeId" id="modeId" value="<%=modelId%>">
<input type="hidden" name="operate" id="operate" value="<%=operate %>">
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 --></td>
	<td class="e8_tblForm_field">
	<input id="modeName" name="modeName" type="text" style="width:80%;" value="<%=modeName %>" onChange="checkinput('modeName','modeNamespan')"/>
	<span id=modeNamespan><%if(modeName.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82186,user.getLanguage())%><!-- 所属应用 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<select name=typeId name=typeId style="width:200px">
		<%
		String appSql = " select * from modeTreeField where (isdelete is null or isdelete=0 )";
		if(fmdetachable.equals("1")){
	          	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEAPP:ALL",0);
	  			String subCompanyIds = "";
	  			for(int i=0;i<mSubCom.length;i++){
	  				if(i==0){
	  					subCompanyIds += ""+mSubCom[i];
	  				}else{
	  					subCompanyIds += ","+mSubCom[i];
	  				}
	  			}
	  			if(subCompanyIds.equals("")){
	  				appSql+= " and 1=2 ";
	  			}else{
	  				appSql+= " and subCompanyId in ("+subCompanyIds+") ";
	  			}
	      }
		appSql += " order  by showOrder asc ";
		RecordSet.executeSql(appSql);
		boolean isInSubCompany = false;
		while(RecordSet.next()){
			int tempAppId = Util.getIntValue(RecordSet.getString("id"),0);
			if(tempAppId==appId){
				isInSubCompany = true;
			}
		%>
		<option value="<%=RecordSet.getString("id")%>" <%if(tempAppId==appId){out.print("selected");}%>><%=RecordSet.getString("treeFieldName")%></option>
		<%}
			if(!isInSubCompany){
				appSql = "select  * from modeTreeField where id="+appId;
				RecordSet.executeSql(appSql);
				if(RecordSet.next()){
			%>
				<option value="<%=RecordSet.getString("id")%>"  selected="selected"> <%=RecordSet.getString("treeFieldName")%></option>
			<% } }
		%>
  	</select>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><!-- 表单 --><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82187,user.getLanguage())%><!-- 模块对应的自定义表单。 --></div></td>
	<td class="e8_tblForm_field">
	<%   String bname = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
  		 RecordSet.executeSql("select * from workflow_bill where id='"+formId+"'");
 		 if(RecordSet.next()){
 			int tmplable = RecordSet.getInt("namelabel");
 			bname = "<a href=\"#\" onclick=\"toformtab('"+formId+"')\">"+SystemEnv.getHtmlLabelName(tmplable,user.getLanguage())+"</a>";
 		 }else{
 			formId = 0;
 		 }
  		 %>
  		 <%if(isvirtualform==1){ bname = bname + "<div class=\"e8_data_virtualform\" title=\""+SystemEnv.getHtmlLabelName(33885,user.getLanguage())+"\">V</div>";} %><!-- 虚拟表单 -->
  		 <%
  			String hasInput = "true";
  			if(modelId==fmComModeid && modelId!=0){
  				hasInput = "false";
  			}
  			String formIdBrowserValue = formId==0?"":""+formId;
  			String formIdTempTitle = SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage());
  		 %>
  		 <brow:browser viewType="0" name="formId" browserValue='<%=formIdBrowserValue%>' 
  		 		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp"
						hasInput='<%=hasInput%>' isSingle="true" hasBrowser = "true" isMustInput="2"  tempTitle="<%=formIdTempTitle%>"
						completeUrl="/data.jsp?type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="228px"
						browserDialogWidth="510px"
						browserSpanValue='<%=bname %>'
						></brow:browser>
					<!-- 如果没有表单请点击表单字段新建 -->
		&nbsp;<div style="width:156px;position:relative;float:left;margin-top:4px;margin-left:2px;"><font color="red"><%=SystemEnv.getHtmlLabelName(18720,user.getLanguage())%><a id="toNewForm" href="#" onclick="toformtab('')"><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></a><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></font></div>
		<%if(formId!=0 && isvirtualform!=1){ %>
  		 <%-- <button id="testModeFormBtn" class="btn" onclick="javascript:testModeForm('<%=formId %>');" type="button" style="margin-left:10px;width:118px;"><u>J</u>-检测表单字段</button> --%>
  		 <div id="testModeFormBtn"  class="MADN_SaveBtn" onclick="javascript:testModeForm('<%=formId %>');" style="margin-left:5px;width:118px;position:relative;float:left;"><%=SystemEnv.getHtmlLabelName(82188,user.getLanguage())%><!-- 检测表单字段 --></div>
  		 <span id="testModeFormSpan" style="line-height:27px;"></span>
  		 <%} %>
		<span id=createMenuSpan ></span>
		<input type="hidden" id="oldFormId" name="oldFormId" value="<%=formId%>">
	</td>
</tr>
<%if(modelId>0){ %>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(20873,user.getLanguage())%></td>
	<td class="e8_tblForm_field">
		<%if(operatelevel>0){ %>
		<div style="float:left;"><button type="button" class="initbtn" onclick="batchSetExcelField()" title="<%=SystemEnv.getHtmlLabelNames("20873,21673,64",user.getLanguage())%>"></button></div><div style="float:left;margin-left:4px;height:20px;line-height:20px;"><%=SystemEnv.getHtmlLabelNames("20873,21673,64",user.getLanguage())%></div>
		<%} %>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82134,user.getLanguage())%><!-- 显示布局 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
		<%if(operatelevel>0){ %>
		<button type="button" class="copybtn2" onclick="onShowModeBrowser('showhtmlid','showhtmlspan',0)" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
		<button type="button" class="addbtn2" onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modelId%>&formId=<%=formId%>&isdefault=1')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>"></button><!-- 新建模板 -->
		<button type="button" class="addbtn3" onclick="onshowExcelDesign('0','0')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>-new"></button><!-- 新建模板 -->
		<%} %>
		<span id="showhtmlspan"><a href="#" 
		<%if(showhtmlversion==2){ %>
			onclick="onshowExcelDesign('0','<%=showhtmlid %>')"
		<%}else{ %>
			onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modelId%>&formId=<%=formId%>&Id=<%=showhtmlid%>')"
		<%} %>
		><%=showhtmlname%></a></span>
		<input type="hidden" id="showhtmlid" name="showhtmlid" value="<%=showhtmlid%>">
		<input type="hidden" id="showhtmltype" name="showhtmltype" value="0">
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82135,user.getLanguage())%><!-- 新建布局 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<%if(operatelevel>0){ %>
		<button type="button" class="copybtn2" onclick="onShowModeBrowser('addhtmlid','addhtmlspan',1)" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
		<button type="button" class="addbtn2" onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=1&modeId=<%=modelId%>&formId=<%=formId%>&isdefault=1')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>"></button><!-- 新建模板 -->
		<button type="button" class="addbtn3" onclick="onshowExcelDesign('1','0')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>-new"></button><!-- 新建模板 -->
	<%} %>
		<span id="addhtmlspan"><a href="#" 
		<%if(addhtmlversion==2){ %>
			onclick="onshowExcelDesign('1','<%=addhtmlid %>')"
		<%}else{ %>
			onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=1&modeId=<%=modelId%>&formId=<%=formId%>&Id=<%=addhtmlid%>')"
		<%} %>
		><%=addhtmlname%></a></span>
		<input type="hidden" id="addhtmlid" name="addhtmlid" value="<%=addhtmlid%>">
		<input type="hidden" id="addhtmltype" name="addhtmltype" value="1">
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<%if(operatelevel>0){ %>
		<button type="button" class="copybtn2" onclick="onShowModeBrowser('edithtmlid','edithtmlspan',2)" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
		<button type="button" class="addbtn2" onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modelId%>&formId=<%=formId%>&isdefault=1')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>"></button><!-- 新建模板 -->
		<button type="button" class="addbtn3" onclick="onshowExcelDesign('2','0')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>-new"></button><!-- 新建模板 -->
	<%} %>
		<span id="edithtmlspan"><a href="#" 
		<%if(edithtmlversion==2){ %>
			onclick="onshowExcelDesign('2','<%=edithtmlid %>')"
		<%}else{ %>
			onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modelId%>&formId=<%=formId%>&Id=<%=edithtmlid%>')"
		<%} %>
		><%=edithtmlname%></a></span>
		<input type="hidden" id="edithtmlid" name="edithtmlid" value="<%=edithtmlid%>">
		<input type="hidden" id="edithtmltype" name="edithtmltype" value="2">
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82137,user.getLanguage())%><!-- 监控布局 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<%if(operatelevel>0){ %>
		<button type="button" class="copybtn2" onclick="onShowModeBrowser('monitorhtmlid','monitorhtmlspan',3)" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
		<button type="button" class="addbtn2" onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=3&modeId=<%=modelId%>&formId=<%=formId%>&isdefault=1')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>"></button><!-- 新建模板 -->
		<button type="button" class="addbtn3" onclick="onshowExcelDesign('3','0')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>-new"></button><!-- 新建模板 -->
	<%} %>
		<span id="monitorhtmlspan"><a href="#" 
		<%if(monitorhtmlversion==2){ %>
			onclick="onshowExcelDesign('3','<%=monitorhtmlid %>')"
		<%}else{ %>
			onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=3&modeId=<%=modelId%>&formId=<%=formId%>&Id=<%=monitorhtmlid%>')"
		<%} %>
		><%=monitorhtmlname%></a></span>
		<input type="hidden" id="monitorhtmlid" name="monitorhtmlid" value="<%=monitorhtmlid%>">
		<input type="hidden" id="monitorhtmltype" name="monitorhtmltype" value="1">
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82138,user.getLanguage())%><!-- 打印布局 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<%if(operatelevel>0){ %>
		<button type="button" class="copybtn2" onclick="onShowModeBrowser('printhtmlid','printhtmlspan',4)" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
		<button type="button" class="addbtn2" onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=4&modeId=<%=modelId%>&formId=<%=formId%>&isdefault=1')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>"></button><!-- 新建模板 -->
		<button type="button" class="addbtn3" onclick="onshowExcelDesign('4','0')" title="<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>-new"></button><!-- 新建模板 -->
	<%} %>
		<span id="printhtmlspan"><a href="#" 
		<%if(printhtmlversion==2){ %>
			onclick="onshowExcelDesign('4','<%=printhtmlid %>')"
		<%}else{ %>
			onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=4&modeId=<%=modelId%>&formId=<%=formId%>&Id=<%=printhtmlid%>')"
		<%} %>
		><%=printhtmlname%></a></span>
		<input type="hidden" id="printhtmlid" name="printhtmlid" value="<%=printhtmlid%>">
		<input type="hidden" id="printhtmltype" name="printhtmltype" value="4">
	</td>
</tr>
<%} %>
<tr>
	<td class="e8_tblForm_label"><!-- 附件上传目录 --><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82189,user.getLanguage())%><!-- 表单附件存放的文档目录。 --></div></td>
	<td class="e8_tblForm_field">
		<select name="categorytype" id="categorytype" onchange="categorytypeChange(this)">
			<option value="0" <%=(0==categorytype?"selected":"") %>><%=SystemEnv.getHtmlLabelName(19213, user.getLanguage()) %></option>
			<option value="1" <%=(1==categorytype?"selected":"") %>><%=SystemEnv.getHtmlLabelName(19214, user.getLanguage()) %></option>
		</select>&nbsp;
		<span id="gdml" style="display: <%=(0==categorytype?"":"none")%>">
		<button type="button" class=Browser id=selectCategoryid name=selectCategoryid onClick="onShowCatalog('mypath')" ></BUTTON>
		<span id=mypath><%=path%></span>
	    <input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
		<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
		<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
		</span>
		<span id="xzml" style="display: <%=(1==categorytype?"":"none")%>">
			<select name="selectcategory" style="width:100px;" id="selectcategory" onChange="selectCategoryChange()">
				<option value="0"></option>
				<%
					boolean scMust=false;
					RecordSet.executeSql("select * from workflow_billfield where fieldhtmltype=5 and (detailtable='' or detailtable is null) and billid="+formId);
					while(RecordSet.next()){
						String selectfield = Util.null2String(RecordSet.getString("id"));
						String selectfieldlabel = Util.null2String(RecordSet.getString("fieldlabel")); 
						RecordSet1.executeSql("select * from workflow_SelectItem where fieldid="+selectfield);
						boolean isDocCategory=false;
						while(RecordSet1.next()){
							String docCategory = Util.null2String(RecordSet1.getString("docPath"));
							if("".equals(docCategory)){
								isDocCategory = false;
								break;
							}
							isDocCategory = true;
						}
						if(isDocCategory){
							if(selectfield.equals(selectcategory+"")){
								scMust=true;
							}
							out.println("<option value='"+selectfield+"' "+(selectfield.equals(selectcategory+"")?"selected":"") +">"+SystemEnv.getHtmlLabelName(Util.getIntValue(selectfieldlabel,0),user.getLanguage())+"</option>");
						}
					}
				 %>
			</select>
			<span id="selectcategoryMust" style="display: <%=(!scMust?"":"none")%>">
			<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
			</span>
		</span>
	</td>
</tr>
<%
boolean ishaveDetail = false;
RecordSet.executeSql("select * from workflow_billfield where billid = '"+formId+"' and viewtype='1'");
if(RecordSet.next()){
	ishaveDetail = true;
}
if(modelId>0 && ishaveDetail){ %>
<tr class="showTR" <%if(isvirtualform==1){%>style="display: none;"<%} %>>
	<td class="e8_tblForm_label"><!-- 允许创建时导入明细 --><%=SystemEnv.getHtmlLabelName(28503,user.getLanguage())%><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
	<input type="checkbox" name="isImportDetail" id="isImportDetail" value="1" <% if(isImportDetail==1) {%> checked=checked <%}%> >
	</td>
</tr>
<%} %>
<tr class="showTR" <%if(isvirtualform==1){%>style="display: none;"<%} %>>
	<td class="e8_tblForm_label"><!-- 允许修改共享 --><%=SystemEnv.getHtmlLabelName(20449,user.getLanguage())%><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
		<INPUT class="inputstyle" type="checkbox" id="DefaultShared" name="DefaultShared" value="1" <%if(DefaultShared.equals("1")) out.println("checked=checked");%>><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%><!-- 默认共享 -->
				&nbsp;&nbsp;
		<INPUT class="inputstyle" type="checkbox" id="NonDefaultShared" name="NonDefaultShared" value="1" <%if(NonDefaultShared.equals("1")) out.println("checked=checked");%>><%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%><!--  非默认共享  -->
	</td>
</tr>
<%if(fmdetachable.equals("1")){%>
<tr >
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
	<td class="e8_tblForm_field">
	<brow:browser name="subCompanyId" viewType="0" hasBrowser="true" hasAdd="false" 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=ModeSetting:All" isMustInput="2" isSingle="true" hasInput="true"
        completeUrl="/data.jsp?type=164_1&rightStr=ModeSetting:All"  width="260px" browserValue='<%=subCompanyId2%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>' />
	</td>
</tr>
<%}else{%>
	<input type="hidden" name="subCompanyId" id="subCompanyId" value="<%=subCompanyId2 %>" />
<%} %>
<%if(!"uf_Reply".equals(tableName) && "1".equals(isEnFormModeReply)){%>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82552,user.getLanguage())%><!-- 是否允许回复 --></td>
	<td class="e8_tblForm_field">
		<input type="checkbox" name="isAllowReply" id="isAllowReply" value="1" onclick="checkIsAllowReply(this)" <%if(isAllowReply==1) {%> checked=checked <%}%> >
	</td>
</tr>
<%}%>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelNames("83023,125272",user.getLanguage())%><!-- 是否流程赋权 --></td>
	<td class="e8_tblForm_field">
		<input type="checkbox" name="isAddRightByWorkFlow" id="isAddRightByWorkFlow" value="1" onclick="checkIsAllowReply(this,'isAddRightByWorkFlow')" <%if(isAddRightByWorkFlow==1) {%> checked=checked <%}%> >
		<%
		String css = "";
		if(modelId>0){
			if(isAddRightByWorkFlow==1){
				css = "display:none";
			}
		%>
			<span id="isAddRightByWorkFlowSpan" style="margin-left:10px;<%=css%>"><a href="javascript:void(0);" style="color:#0072C6;" onclick="cleanData();"><%=SystemEnv.getHtmlLabelNames("311,28149",user.getLanguage())%></a></span>
		<%}%>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field"><input type="text" class="inputstyle"  onchange="checkVal()" id="dsporder" name="dsporder" value="<%=dsporder %>"/></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"></div></td><!-- '模块描述','文本长度不能超过','1个中文字符等于2个长度' -->
	<td class="e8_tblForm_field"><textarea name="modeDesc"  id="modeDesc" style="width:80%;height:40px;overflow:auto;" onchange="checkLengthfortext('modeDesc','1000','<%=SystemEnv.getHtmlLabelName(82182,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"><%=modeDesc %></textarea></td>
</tr>
</table>
</form>
</body>
<script type="text/javascript">
	var diag_vote;
	function checkVal(){
			var valid=false;
			var checkrule='^(-?\\d+)(\\.\\d+)?$';
			var dsporder=document.getElementById("dsporder").value;
			eval("valid=/"+checkrule+"/.test(\""+dsporder+"\");");
			if (dsporder!=''&&!valid){
				alert('<%=SystemEnv.getHtmlLabelName(82018,user.getLanguage())%>');//显示顺序中请输入数字!
				document.getElementById("dsporder").value='';
			}
	}
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId==''||modeId==''){
		$("#createMenuSpan").attr("style","display:none");
	}
	
	<%if(isloadleft){%>
		try{
			parent.parent.refreshWithFormCreated(<%=modelId%>);
		}catch(e){}
	<%}%>
	<%if(modelId==fmComModeid && modelId!=0){%>
		$("#formId_browserbtn").attr("style","display:none");
	<%}%>
})

function testModeForm(formId){
	var testModeFormBtn = document.getElementById("testModeFormBtn");
	testModeFormBtn.disabled = true;
	var $testModeFormSpan = $("#testModeFormSpan");
	$testModeFormSpan.removeClass("checkSuccess");
	$testModeFormSpan.html("");
	var ajax=ajaxinit();
    ajax.open("POST", "repairModeFormXml.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("src=testModeForm&formId="+formId);
    ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	if(ajax.responseText == "0"){
            		$testModeFormSpan.addClass("checkSuccess");
            		$testModeFormSpan.html("<%=SystemEnv.getHtmlLabelName(82190,user.getLanguage())%>");//检测通过
            	}else if(ajax.responseText == "1"){
            		var url = "/formmode/setup/repairModeForm.jsp?dialog=1&formid=" + formId;
					
					diag_vote = new window.top.Dialog();
					diag_vote.currentWindow = window;
					diag_vote.Modal = true;
					diag_vote.Width = 1000;
					diag_vote.Height = 380;
					diag_vote.URL = url;
					diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82191,user.getLanguage())%>";//表单字段修复
					<%-- diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1&appid=<%=appId%>"+parm; --%>
					diag_vote.isIframe=false;
					diag_vote.show();
            	}else{
            		alert("<%=SystemEnv.getHtmlLabelName(82192,user.getLanguage())%>");//后台出现未知错误
            	}
            }catch(e){}
        }
        testModeFormBtn.disabled = false;
    }
}

function createMenu(){
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId == '') {
		alert("<%=SystemEnv.getHtmlLabelName(82183,user.getLanguage())%>");//请选择表单！
		return;
	}
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	
	var parmes = escape("/formmode/view/AddFormMode.jsp?modeId="+modeId+"&formId="+formId+"&type=1");
	var url = "/formmode/menu/CreateMenu.jsp?menuaddress="+parmes;
	var handw = "dialogHeight="+height+";dialogWidth="+width;
	window.open(url);
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    	ajax = new XMLHttpRequest();
    }
    return ajax;
}
function newModel(){
	parent.document.location.href = 'modelInfo.jsp?appId=<%=appId%>';
}

function exportMode(modeid){
	var xmlHttp = ajaxinit();
	xmlHttp.open("post","/formmode/setup/modeoperationxml.jsp", true);
	var timestamp = (new Date()).valueOf();
	var postStr = "src=export&modeid="+modeid+"&ti="+timestamp;
	xmlHttp.onreadystatechange = function () 
	{
		switch (xmlHttp.readyState) 
		{
		   case 4 : 
		   		if (xmlHttp.status==200)
		   		{
		   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
		   			window.open(downxml,"_self");
		   		}
			    break;
		} 
	}
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
	xmlHttp.send(postStr);
}
function deleteMode(modeid){
	rightMenu.style.visibility = "hidden";
	if(isdel()){
		enableAllmenu();
		document.weaver.operate.value="deleteMode";
		weaver.submit();
	}
}
function viewmenu(){
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId == '') {
		alert("<%=SystemEnv.getHtmlLabelName(82183,user.getLanguage())%>");//请选择表单！
		return;
	}
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	
	var url = "/formmode/view/AddFormMode.jsp?modeId="+modeId+"&formId="+formId+"&type=1";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>)",url);//查看菜单地址新建
}

function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	} 
}
function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}
function submitData(){
    rightMenu.style.visibility = "hidden";
    if($("#formId").val()=='0'){
        	$("#formId").val("");
	}
	if(jQuery("#categorytype").val()==1){
		if(jQuery("#selectcategory").val()==0){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	if(checkFieldValue("modeName,formId")){
		enableAllmenu();
		weaver.submit();
	}
}
function deleteData(){
    rightMenu.style.visibility = "hidden";
	if(isdel()){
		enableAllmenu();
		document.weaver.operate.value="DeleteMode";
		weaver.submit();
	}
}

function toformtabFormChoosed(data){
	var dataArr=data.split("_");
	var formid=dataArr[0];
	var isvirtualform=dataArr[1];
	toformtab(formid,isvirtualform);
}

function toformtab(formid,isvirtualform){
    if (formid && (<%=isvirtualform%> == 1||isvirtualform==1)) {
        FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, formid);
    	clickTopSubMenu(2);
    } else {
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		var parm = "&formid="+formid;
		if(formid=='') {
			
			parm = '';
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		}else{
		    
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";//编辑表单
		}
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1&appid=<%=appId%>"+parm;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
}

function onShowCatalog(spanName) {
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
	showColDialog1(url ,spanName);
}

function onShowModeBrowser(ids,spans,type){
	var urls = "/formmode/setup/FormModeHtmlBrowser.jsp?modeId="+<%=modelId%>+"&formId="+<%=formId%>+"&type="+type;
	urls = "/systeminfo/BrowserMain.jsp?url="+escape(urls);
	var dlg = top.createTopDialog();
	dlg.currentWindow = window;
	dlg.Model = true;
	dlg.Width = 500;//定义长度
	dlg.Height = 600;
	dlg.URL = urls;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(81986,user.getLanguage())%>";//请选择模板
	dlg.callback = function(datas){
		if (datas != undefined && datas != null) {
			if(datas.id!=""){
			    var layoutid = datas.id+"";
				jQuery("#"+ids).val(layoutid);
				var version = datas.version;
				if(version==2){
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"onshowExcelDesign("+type+","+layoutid+")\">"+datas.name+"</a>");
				}else{
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type="+type+"&modeId=<%=modelId%>&formId=<%=formId%>&Id="+layoutid+"')\">"+datas.name+"</a>");
				}
			}else{
				jQuery("#"+ids).val("");
				jQuery("#"+spans).html("");
			}
		}
		dlg.close();
	};
	dlg.show();
}

function customDialogCallBack(isvirtualform){
	if(isvirtualform==1){//
		$(".showTR").hide();
		changeCheckboxStatus(document.getElementById("isImportDetail"), false);
		changeCheckboxStatus(document.getElementById("DefaultShared"), false);
		changeCheckboxStatus(document.getElementById("NonDefaultShared"), false);
	}else{
		$(".showTR").show();
	}
}

var dialog = null;
function showColDialog1(url ,spanName){
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
   	dialog.Drag = true;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(25449,user.getLanguage())%>";//选择附件上传目录
   	dialog.Width = 600;
   	dialog.Height = 400;
   	dialog.callbackfun = function(callbackfunParam, data){
	   	if (data) {
	        if (data.tag>0)  {
	           $G(spanName).innerHTML = data.path;
	           $G("maincategory").value=data.mainid;
	           $G("subcategory").value=data.subid;
	           $G("seccategory").value=data.id;
	        }else{
	           $G(spanName).innerHTML = "";
	           $G("maincategory").value="";
	           $G("subcategory").value="";
	           $G("seccategory").value="";
	        }
	    }
    }
   	dialog.URL = url;
	dialog.show();
}

function closeColDialog(){
	dialog.close();
}

function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
}
function checkIsAllowReply(obj,objname){
	var f = false;
	if($(obj).attr("checked")){
		$(obj).val(1);
		f = true;
	}else{
		$(obj).val(0);
	}
	if(<%=modelId%> > 0&&objname&&objname=='isAddRightByWorkFlow'){
		if(!f){
			jQuery("#isAddRightByWorkFlowSpan").show();
		}else{
			jQuery("#isAddRightByWorkFlowSpan").hide();
		}
	}
}
function createMenuNew(){
	var _formId = $("#formId").val();
	var _modeId = $("#modeId").val();
	if(_formId == '') {
		alert("<%=SystemEnv.getHtmlLabelName(82183,user.getLanguage())%>");//请选择表单！
		return;
	}
	var parmes = escape("/formmode/view/AddFormMode.jsp?modeId="+_modeId+"&formId="+_formId+"&type=1")
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 350;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>";
	diag_vote.URL = "/formmode/setup/modelMenuAdd.jsp?dialog=1&isFromMode=1&parmes="+parmes;
	diag_vote.isIframe=false;
	diag_vote.show();
}
function categorytypeChange(obj){
	if(obj.value==0||obj.value==undefined){
		jQuery("#gdml").show();
		jQuery("#xzml").hide();
	}else if(obj.value==1){
		jQuery("#gdml").hide();
		jQuery("#xzml").show();
	}
}
function selectCategoryChange(){
	var selectcategory = jQuery("#selectcategory").val();
	if(selectcategory==0){
		jQuery("#selectcategoryMust").show();
	}else{
		jQuery("#selectcategoryMust").hide();
	}
}

//新表单设计器-批量设置表单字段
function batchSetExcelField(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/formmode/exceldesign/excelInitModule.jsp?modeid=<%=modelId%>&formid=<%=formId%>&layouttype=1&isdefault=1&fromwhere=batchset";;
	dialog.Title = "设置单元格格式";
	dialog.Width = 810;
	dialog.Height = 570;
	dialog.hideDraghandle = true;	
	dialog.URL = url;
	dialog.show();
}

//打开新表单设计器
function onshowExcelDesign(layouttype, layoutid){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow=window;
	dlg.Model=true;
    if ($.browser.msie && parseInt($.browser.version, 10) < 9) {		//run for ie7/8
    	dlg.maxiumnable=false;
    	dlg.Width = 1000;
		dlg.Height = 600;
    	dlg.URL="/wui/common/page/sysRemind.jsp?labelid=124796";
    	dlg.hideDraghandle = false;
    }else{
    	dlg.maxiumnable=true;
    	dlg.Width = $(window.top).width()-60;
		dlg.Height = $(window.top).height()-80;
    	dlg.URL="/formmode/exceldesign/excelMain.jsp?modeid=<%=modelId%>&formid=<%=formId%>&layoutid="+layoutid+"&layouttype="+layouttype+"&isdefault=1";
    	dlg.hideDraghandle = true;
    } 
	dlg.Title="新版流程模式设计器";
	dlg.closeHandle = function (paramobj, datas){
		window.location.reload();
	}
　　 dlg.show();
}

//创建表单保存后回调函数
function createFormCallBackFun(formid,formlabelname){
	jQuery("#formId").val(formid);
	var sHtml = "<a href='#' onclick=\"toformtab('"+formid+"')\">" + formlabelname + "</a>";
	sHtml = wrapshowhtml(sHtml,formid,1);
	jQuery("#formIdspan").html(sHtml);
	checkinput('formId','formIdspanimg');
}

function cleanData(){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("84051,125272,33363",user.getLanguage())%>"+"？",function(){
			jQuery.ajax({
				type: "POST",
				dataType:"json",
				url: "/formmode/setup/rightAction.jsp?action=deleteFlowRight",
				data: "modeId=<%=modelId%>&formId=<%=formId%>",
				success: function(data){
					if(data.status==1){
						Dialog.alert("<%=SystemEnv.getHtmlLabelName(28222,user.getLanguage())%>");
					}
				}
			});
		});
}
</script>
</html>

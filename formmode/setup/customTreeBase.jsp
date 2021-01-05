
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.formmode.service.CustomtreeService"%>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <style type="text/css">
		table{empty-cells:show;border-collapse:collapse;border-spacing:0;margin-left: -15px;}
		.demo{width:auto;margin:0px 0px 0 0px;}
		.listext th{background:#FFF;color:#000000;border:solid 0px #BFCDDB;text-align:center;padding:1px;}
		.listext td{border:solid 0px #BFCDDB;padding-bottom:2px;padding-top:2px;padding:1px;}
		.rc-handle-container{position:relative;}
		.rc-handle{position:absolute;width:7px;cursor:ew-resize;*cursor:pointer;margin-left:-3px;}
		.disTD{
		   background-color:#FFFFF;
		   height:15px;
		   width: 10px;
		}
		.enTD{
		  padding-left: 5px
		}
		.addrow{
		   height:25px;
		}
	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	//树形设置:基本信息
	String titlename = SystemEnv.getHtmlLabelName(30208,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(1361,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
	String oldid=Util.null2String(request.getParameter("oldid"));
	String modeid=Util.null2String(request.getParameter("modeid"));
	String appid=Util.null2String(request.getParameter("appid"),"1");
	String treename = Util.null2String(request.getParameter("treename"));
	String rootname = Util.null2String(request.getParameter("rootname"));
	String treedesc = Util.null2String(request.getParameter("treedesc"));
	String treeremark = Util.null2String(request.getParameter("treeremark"));
	String rooticon = Util.null2String(request.getParameter("rooticon"));
	String defaultaddress = Util.null2String(request.getParameter("defaultaddress"));
	String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
		
	int showtype = Util.getIntValue(Util.null2String(request.getParameter("showtype")),0);
	int isselsub = Util.getIntValue(Util.null2String(request.getParameter("isselsub")),0);
	int isonlyleaf = Util.getIntValue(Util.null2String(request.getParameter("isonlyleaf")),0);
	int isRefreshTree = Util.getIntValue(Util.null2String(request.getParameter("isRefreshTree")),0);
	int isQuickSearch = Util.getIntValue(Util.null2String(request.getParameter("isQuickSearch")),0);
	int isshowsearchtab = Util.getIntValue(Util.null2String(request.getParameter("isshowsearchtab")),0);
	String searchbrowserid = Util.null2String(request.getParameter("searchbrowserid"));
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customtree a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	AppInfoService appInfoService = new AppInfoService();
	Map<String, Object> appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
	String treelevel = Util.null2String(appInfo.get("treelevel"));
	if(subCompanyId==-1){
		subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
	CustomtreeService customtreeService = new CustomtreeService();
	Map<String, Object> data = customtreeService.getCustomtreeById(id);
	String modename = "";
	treename = Util.null2String(data.get("treename"));
	rootname = Util.null2String(data.get("rootname"));
	treedesc = Util.null2String(data.get("treedesc"));
	if(id > 0 ){
		treeremark = Util.null2String(data.get("treeremark"));
	}
	if("".equals(treeremark)){
		treeremark = SystemEnv.getHtmlLabelName(82269,user.getLanguage())+"\n"+SystemEnv.getHtmlLabelName(82270,user.getLanguage());
	}
	rooticon = Util.null2String(data.get("rooticon"));
	defaultaddress = Util.null2String(data.get("defaultaddress"));
	expandfirstnode = Util.null2String(data.get("expandfirstnode"));
	
	showtype = Util.getIntValue(Util.null2String(data.get("showtype")),0);
	isselsub = Util.getIntValue(Util.null2String(data.get("isselsub")),0);
	isonlyleaf = Util.getIntValue(Util.null2String(data.get("isonlyleaf")),0);
	isRefreshTree = Util.getIntValue(Util.null2String(data.get("isRefreshTree")),0);
	isQuickSearch = Util.getIntValue(Util.null2String(data.get("isQuickSearch")),0);
	isshowsearchtab = Util.getIntValue(Util.null2String(data.get("isshowsearchtab")),0);
	searchbrowserid = Util.null2String(data.get("searchbrowserid"));
	if(searchbrowserid.equals("0")){
		searchbrowserid = "";
	}
	
	if(modeid.isEmpty()){
		modeid = Util.null2String(data.get("modeid"));
	}
	String appidtemp = Util.null2String(data.get("appid"));
	if(!appidtemp.isEmpty()){
		appid = appidtemp;
	}
	if(!modeid.isEmpty()){
		int mid =  Util.getIntValue(Util.null2String(modeid),0);
		Map<String, Object> modeMap = customtreeService.getModeinfoById(mid);
		modename =  Util.null2String(modeMap.get("modename"));
	}
	String refreshType = Util.null2String(request.getParameter("refreshType"));
	
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String editType = "edit";//编辑
if(id==0){
	editType = "save";//新建
}
if(editType.equals("edit")){
	if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0")&&id!=0)||fmdetachable.equals("1")&&!treelevel.equals("0")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
		RCMenuHeight += RCMenuHeightStep;
	}
	if(operatelevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;//删除
		RCMenuHeight += RCMenuHeightStep;
	}
	if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82069,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建树
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(30215,user.getLanguage())+",javaScript:AddTreeNode(),_self} " ;//新建树节点
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82842,user.getLanguage())+",javascript:copyTree(),_top} " ;//复制树
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javaScript:doPreview(),_self} " ;//预览
	RCMenuHeight += RCMenuHeightStep;
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createMenuNew(),_self} " ;//创建菜单
		RCMenuHeight += RCMenuHeightStep;
	}
}else{
	if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0")&&id!=0)||fmdetachable.equals("1")&&!treelevel.equals("0")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
		RCMenuHeight += RCMenuHeightStep;
	}
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
}

String usedSql = "select count(1) as num from workflow_billfield where (type=256 or type=257) and fieldhtmltype=3 and fielddbtype='"+id+"'";
rs.executeSql(usedSql);
String usednum = "0";
if(rs.next()){
	usednum = rs.getString("num");
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<form name="frmSearch" method="post" action="/formmode/setup/customTreeAction.jsp" enctype="multipart/form-data">
		<input type="hidden" id="operation" name="operation" value="edit">
		<input type="hidden" id="id" name="id" value="<%=id%>">
		<input type="hidden" id="appid" name="appid" value="<%=appid%>">
		<table class="e8_tblForm">
		<colgroup>
			<col width="200px">
			<col width="*">
		</colgroup>
		<tr>
				<td class="e8_tblForm_label">
					<!-- 树形名称 -->
					<%=SystemEnv.getHtmlLabelName(30209,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input id="treename" name="treename" type="text" value="<%=treename%>" style="width:80%" maxlength="100" onblur="checkinput2('treename','treenamespan',1)">
					<span id="treenamespan">
						<%
							if(treename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
				</td>
			</tr>
						
			<tr>
				<td class="e8_tblForm_label">
					<!-- 根节点名称-->
					<%=SystemEnv.getHtmlLabelName(30210,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="rootname" name="rootname" type="text" value="<%=rootname%>" style="" maxlength="50" onblur="checkinput2('rootname','rootnamespan',1)">
					<span id="rootnamespan">
						<%
							if(treename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<%=SystemEnv.getHtmlLabelName(23724,user.getLanguage())%><!-- 显示样式 -->
				</td>
				<td class=e8_tblForm_field>
					<%
						String isSelSubTRStyle = "display:none;";
						String istreeremark = "";
						String typeCheckIndex = "0";
						if(id==0){
							typeCheckIndex = "0";
						}else{
							typeCheckIndex = ""+showtype;
						}
						if(showtype==1){
							isSelSubTRStyle = "";
							istreeremark = "display:none;";
						}
					%>
					<input <%if(!usednum.equals("0")){%>disabled="disabled"<%} %> type="radio" name="showtype" class="showtyperadio" id="showtype0" value="0" onclick="showIsSelSubTR(0);" <%if(typeCheckIndex.equals("0")){%>checked="checked"<%} %>><%=SystemEnv.getHtmlLabelName(82070,user.getLanguage())%><!-- 导航树 -->
					<input <%if(!usednum.equals("0")){%>disabled="disabled"<%} %> type="radio" name="showtype" class="showtyperadio" id="showtype1" value="1" onclick="showIsSelSubTR(1);" <%if(typeCheckIndex.equals("1")){%>checked="checked"<%} %> ><%=SystemEnv.getHtmlLabelName(82071,user.getLanguage())%><!-- 树形浏览框 -->
					<%if(!usednum.equals("0")){%>
						<input type="hidden" name="showtype" value="<%=typeCheckIndex %>">
					<% }%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			<tr id="isSelSubTR" style="<%=isSelSubTRStyle %>">
				<td class="e8_tblForm_label">
					<%=SystemEnv.getHtmlLabelName(82072,user.getLanguage())%><!-- 多选时是否选中子项 -->
				</td>
				<td class=e8_tblForm_field>
					<input type="checkbox" name="isselsub" id="isselsub" value="<%=isselsub %>" <%if(isselsub==1){%>checked="checked"<%} %> onclick="changeBoxVal('isselsub');">
					<span style="font-size:12px;color:#666666">&nbsp;<%=SystemEnv.getHtmlLabelName(82073,user.getLanguage())%><!-- （仅在字段设置为“自定义树形多选”时有效） --></span>
				</td>
			</tr>
			
			<tr id="isonlyleafTR" style="<%=isSelSubTRStyle %>">
				<td class="e8_tblForm_label">
					<%=SystemEnv.getHtmlLabelName(82074,user.getLanguage())%><!-- 仅允许选择叶子节点 -->
				</td>
				<td class=e8_tblForm_field>
					<input type="checkbox" name="isonlyleaf" id="isonlyleaf" value="<%=isonlyleaf %>" <%if(isonlyleaf==1){%>checked="checked"<% } %> onclick="changeBoxVal('isonlyleaf');">
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 根节点图标-->
					<%=SystemEnv.getHtmlLabelName(30211,user.getLanguage())%>
					<div class="e8_label_desc">(16px*16px)</div>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="oldrooticon" name="oldrooticon" type="hidden" value="<%=rooticon%>">
					<input class="inputstyle" id="rooticon" name="rooticon" type="file" value="<%=rooticon%>" onchange="selectImg(this)">
					<div>
					<span id="oldimg">
						<%
							if(!rooticon.equals("")&&!rooticon.equals("0")) {
						%>
								<img src="/weaver/weaver.file.FileDownload?fileid=<%=rooticon%>">
						<%
							}
						%>
					</span>
					<span id="delspan"><!-- 删除根节点图标 -->
						<a href="javascript:void(0)" onclick="javascript:delRootIcon()"><%=SystemEnv.getHtmlLabelName(30228,user.getLanguage())%></a>
					</span>
					</div>					
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 根节点链接地址-->
					<%=SystemEnv.getHtmlLabelName(81440,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="defaultaddress" name="defaultaddress" type="text" value="<%=defaultaddress%>" style="width:80%" maxlength="1000">
					<span id="defaultaddressspan">
					</span>
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 是否默认展开一级节点-->
					<%=SystemEnv.getHtmlLabelName(81441,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="expandfirstnode" name="expandfirstnode" type="checkbox" value="1" <%if(expandfirstnode.equals("1")){out.println("checked");} %>>
					<span id="expandfirstnodespan">
					</span>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label">
					<!-- 描述 -->
					<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="treedesc" name="treedesc" type="text" value="<%=treedesc%>" style="width:80%" maxlength="2000">
					<span id="treedescspan">
					</span>
				</td>
			</tr>
			<tr id="refresh" <%if(showtype == 1){ %> style="display:none" <%} %>>
			   <td class="e8_tblForm_label">
			   <!--是否刷新树 -->
			       <%=SystemEnv.getHtmlLabelName(124923,user.getLanguage())%>
			   </td>
			   <td class=e8_tblForm_field>
				  <input type="checkbox" id="isRefreshTree" name="isRefreshTree" value="<%=isRefreshTree %>" tzCheckbox="true" onclick="changeValue(this)" <%if(isRefreshTree == 1){ %>checked="checked"<%}%>>			   
			   </td>
			</tr>
			
			<tr id="quickSearch" <%if(showtype == 1){ %> style="display:none" <%} %>>
			   <td class="e8_tblForm_label">
			   <!--是否快捷搜索 -->
			       <%=SystemEnv.getHtmlLabelNames("83023,126436",user.getLanguage())%>
			   </td>
			   <td class=e8_tblForm_field>
				  <input type="checkbox" id="isQuickSearch" name="isQuickSearch" value="<%=isQuickSearch %>" tzCheckbox="true" onclick="changeValue(this)" <%if(isQuickSearch == 1){ %>checked="checked"<%}%>>			   
			   </td>
			</tr>
			
			<tr id="isshowsearchtabTr" style="<%=isSelSubTRStyle %>">
			   <td class="e8_tblForm_label" >
			   		<!--是否显示组合查询 -->
			        <%=SystemEnv.getHtmlLabelName(125487,user.getLanguage())%>
			   </td>
			   <td class=e8_tblForm_field>
				  <input type="checkbox" id="isshowsearchtab" name="isshowsearchtab" value="<%=isshowsearchtab %>" tzCheckbox="true" onclick="changeValue(this);showBrowserTr()" <%if(isshowsearchtab == 1){ %>checked="checked"<%}%>>
				    <span id="remind" title="<%=SystemEnv.getHtmlLabelName(125794,user.getLanguage())%>&#10;1.<%=SystemEnv.getHtmlLabelName(82074,user.getLanguage())%>&#10;2.<%=SystemEnv.getHtmlLabelName(82076,user.getLanguage())%>&#10;3.<%=SystemEnv.getHtmlLabelName(82078,user.getLanguage())%>&#10;">
						<img align="absMiddle" src="/images/remind_wev8.png">
					</span>			   
			   </td>
			</tr>
			<%
			int count = 0;
   			if(id>0){
				sql = "select 1 from mode_customtreedetail where mainid="+id;
				rs.executeSql(sql);
				count = rs.getCounts();
   			}
			%>
			<tr id="searchbrowseridTr" <%if(count>1||(isshowsearchtab != 1||showtype!=1)){ %>style="display: none"<%} %>>
			   <td class="e8_tblForm_label">
			   	   <!--选择浏览框 -->
			       <%=SystemEnv.getHtmlLabelName(125488,user.getLanguage())%>
			   </td>
			   <td class=e8_tblForm_field>
			   		<%
			   			String searchbrowserName = "";
			   			if(!searchbrowserid.equals("")){
			   				sql = "select customname from mode_custombrowser where id="+searchbrowserid;
			   				rs.executeSql(sql);
			   				if(rs.next()){
			   					searchbrowserName = rs.getString("customname");
			   				}
			   			}
			   		%>
			   		<brow:browser viewType="0" name="searchbrowserid" browserValue="<%=searchbrowserid %>" 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/BrowserBaseList.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="550px"
						browserSpanValue="<%=searchbrowserName %>"
						></brow:browser>
			   </td>
			</tr>
			<tr id="operatorremark" style="<%=istreeremark %>">
			   <td class="e8_tblForm_label">
			   <%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%>
			   </td>
			   <td class=e8_tblForm_field>
			   	   <textarea rows="4" cols="87" class="inputstyle" id="treeremark" name="treeremark"><%=treeremark %></textarea> 
			   </td>
			</tr>
		</table>
	</form>
	
	
<%if(editType.equals("edit")){
	String SqlWhere = " where mainid = " + id;

	String perpage = "10";
	String backFields = "id,mainid,nodename,nodedesc,sourcefrom,sourceid,tablename,tablekey,tablesup,showfield,hreftype,hrefid,hreftarget,hrefrelatefield,nodeicon,supnode,supnodefield,nodefield,showorder";
	String sqlFrom = "from mode_customtreedetail";
	//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
	String tableString=""+
		"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"showorder asc\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				"<head>"+   //名称                          
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"nodename\" orderkey=\"nodename\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/setup/customTreeNodeBase.jsp\"/>"+
						//描述
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"nodedesc\"/>"+
					//数据来源
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(28006,user.getLanguage())+"\" column=\"sourcefrom\" orderkey=\"sourcefrom\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.tree.CustomTreeUtil.getSourceFrom\"/>"+
					//数据来源名称
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30231,user.getLanguage())+"\" column=\"sourceid\" orderkey=\"sourcefrom\" otherpara=\"column:sourcefrom\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
					//表名
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21900,user.getLanguage())+"\" column=\"tablename\" orderkey=\"tablename\"/>"+
					//链接目标来源
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30174,user.getLanguage())+"\" column=\"hreftype\" orderkey=\"hreftype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefType\"/>"+
					//链接目标
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30181,user.getLanguage())+"\" column=\"hrefid\" orderkey=\"hrefid\" otherpara=\"column:hreftype\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
					//链接目标地址
					"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30178,user.getLanguage())+"\" column=\"hreftarget\" orderkey=\"hreftarget\"/>"+
					//显示顺序
					"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
				"</head>"+
		"</table>";
		%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
<% }%>
<script type="text/javascript">

jQuery(function($){
	if(<%=usednum%>>0){
		var showtype = $(".showtyperadio");
		for(var i=0;i<showtype.length;i++){
			var obj = showtype.get(i);
			disOrEnableCheckbox(obj,true);
		}
	}
});

function copyTree(){
	$('#rightMenu').css('visibility','hidden');
	parent.copyTreeSetting();
}

function changeValue(obj){
   if($(obj).attr("checked")){
         $(obj).val(1);
   }else{
         $(obj).val(0);
   }
}

function showBrowserTr(){
	if(<%=count>1%>){
		return;
	}
	var isshowsearchtab = jQuery("#isshowsearchtab").val();
	if(isshowsearchtab=="1"){
		jQuery("#searchbrowseridTr").show();
	}else{
		jQuery("#searchbrowseridTr").hide();
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
function doAdd(){
    rightMenu.style.visibility = "hidden";
	enableAllmenu();
    parent.location.href="/formmode/setup/customTreeInfo.jsp?appid=<%=appid%>";
}
    function doSubmit(){
        rightMenu.style.visibility = "hidden";
	    enableAllmenu();
		if(checkFieldValue("treename,rootname")){
	        $("#operation").val("<%=editType%>");
	        document.frmSearch.submit();			
		}
    }
    function doEdit(){
    	enableAllmenu();
    	location.href="/formmode/setup/customTreeModify.jsp?id=<%=id%>";
	}
    
    function createmenu(){
    	var url = "/formmode/tree/ViewCustomTree.jsp?id=<%=id%>";
    	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
    }
    function viewmenu(){
    	var url = "/formmode/tree/ViewCustomTree.jsp?id=<%=id%>";
    	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
    }
	function AddTreeNode(){
		location.href = "/formmode/setup/customTreeNodeBase.jsp?mainid=<%=id%>";
	}
    function doBack(){
		enableAllmenu();
        location.href="/formmode/setup/customTreeBase.jsp?id=<%=oldid%>";
    }
    function doDel(){
        rightMenu.style.visibility = "hidden";
        if(<%=usednum%>>0){
        	window.top.Dialog.alert("<%=treename%><%=SystemEnv.getHtmlLabelName(82075,user.getLanguage())%>");//已经被字段引用，不能删除！
			return;
        }
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
		});
	}

    function onShowCondition(spanName){
		if("<%=id%>"<=0){
			//请先保存页面数据，再进行该设置
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
			return;
		}		
	}

	function detailSet(){
		if("<%=id%>"<=0){
			//请先保存页面数据，再进行该设置
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
			return;
		}
		
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		var modeid = jQuery("input[name=modeid]").val();
		url = "/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid;
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	}
	}
    
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function onShowHrefTarget(inputName, spanName){
        var url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		}else if(hreftype=="3"){//模块查询列表
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/search/CustomSearchBrowser.jsp";
		} 
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	    getHrefTarget();
    	} 
    }
    
	function getHrefTarget(){
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype!=""&&hrefid!=""){
			var url = "/formmode/interfaces/ModePageExpandAjax.jsp?hrefid="+hrefid+"&hreftype="+hreftype;
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "",
				dataType : "text",
				async : true,
				success: function do4Success(msg){
					var returnurl = jQuery.trim(msg);
					jQuery("#hreftarget").val(returnurl);
					if(returnurl==""){
						jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
					}else{
						jQuery("#hreftargetspan").html("");
					}
				}
			});
		}else{
			jQuery("#hreftarget").val("");
			jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
		}
	}
	
	function onShowTypeChange(){
		var showtype = jQuery("#showtype").val();
		var hreftype = jQuery("#hreftype").val();
		if(showtype=="1"){
			jQuery("#opentype").hide();
			jQuery("#opentypetr").hide();
			jQuery("#opentypelinetr").hide();
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(showtype=="2"){
			jQuery("#opentype").show();
			jQuery("#opentypetr").show();
			jQuery("#opentypelinetr").show();
			if(hreftype=="2"){
				jQuery("#relatedfieldtr").hide();
				jQuery("#relatedfieldtrline").hide();
			}
		}
	}
	
	function onHrefTypeChange(){
		var hreftype = jQuery("#hreftype").val();
		if(hreftype=="1"){
			jQuery("#hrefidtr").show();
			jQuery("#hrefidlinetr").show();
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(hreftype=="2"){
			jQuery("#hrefidtr").hide();
			jQuery("#hrefidlinetr").hide();
			jQuery("#hrefid").val("");
			jQuery("#hrefidspan").html("");
			jQuery("#relatedfieldtr").hide();
			jQuery("#relatedfieldtrline").hide();
		}else if(hreftype=="3"){
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}
	}
	
	$(document).ready(function(){//onload事件
		refreshPage();
		onShowTypeChange();
		onHrefTypeChange();
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
	
	/**
	 * 刷新页面
	 */
	function refreshPage(){
		<%if(!refreshType.equals("")){%>
			parent.parent.reloadDataWithChange("<%=id%>","<%=refreshType%>");
		<%}%>
	}
	
	function delRootIcon(){
    	$("#oldimg").html("");
    	$("#oldrooticon").val("");
    	$("#rooticon").val("");
    	//var objFile = document.getElementById('rooticon');
    	//objFile.outerHTML=objFile.outerHTML.replace(/(value=\").+\"/i,"$1\""); 
	}
	
	function showIsSelSubTR(index){
		if(index==0){
			$("#isonlyleafTR").hide();
			$("#isSelSubTR").hide();
			$("#isshowsearchtabTr").hide();
			$("#refresh").show();
			$("#quickSearch").show();
			$("#operatorremark").show();
		}else{
			$("#isonlyleafTR").show();
			$("#isSelSubTR").show();
			$("#isshowsearchtabTr").show();
			$("#quickSearch").hide();
			$("#refresh").hide();
			$("#operatorremark").hide();
		}
		showBrowserTr();
	}
	
	function changeBoxVal(id){
		var obj = $("#"+id);
		if(obj.val()=='0'){
			obj.val('1');
			changeCheckboxStatus(document.getElementById(id),true);
		}else{
			obj.val('0');
			changeCheckboxStatus(document.getElementById(id),false);
		}
	}
	function doPreview(){
    	if(<%=showtype%>==0){
    		window.open("/formmode/tree/ViewCustomTree.jsp?id=<%=id%>");
    		return;
    	}
    	$("#rightMenu").css("visibility","hidden");
    	var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Width = 260 ;
			dialog.Height = 120;
			dialog.normalDialog = false;
			dialog.URL = "/formmode/setup/CustomTypeBrowser.jsp";
			dialog.callbackfun = function (paramobj, id1) {
				doPreviewBrowser(id1.id);
			} ;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";//提示信息
			dialog.Drag = true;
			dialog.show();
    }
    
    function doPreviewBrowser(type){
		var url = "";
    	var previewType = type;
    	if(previewType==1){
    		url = "/formmode/tree/treebrowser/CustomTreeBrowser.jsp?type=<%=id%>_256&isview=1";
    	}else{
    		url = "/formmode/tree/treebrowser/CustomTreeBrowser.jsp?type=<%=id%>_257&isview=1";
    	}
   	 	var previewDialog = new window.top.Dialog();
		previewDialog.currentWindow = window;
		previewDialog.URL = url;
		previewDialog.callbackfun = function (paramobj, id1) {
		}
		previewDialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>";//预览
		previewDialog.Width = 550 ;
		previewDialog.Height = 550;
		previewDialog.Drag = true;
		previewDialog.show();
    }
function createMenuNew(){
	var url = "/formmode/tree/ViewCustomTree.jsp?id=<%=id%>";
    var parmes = escape(url);
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
</script>

</BODY>
</HTML>

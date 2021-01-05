
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML>
<HEAD>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/jquery/plugins/treeview/jquery.treeview_wev8.css" />
<script src="/js/jquery/plugins/treeview/jquery.treeview_wev8.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" media="all" href="/formmode/css/formmode_wev8.css" />
<style>
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
</HEAD>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

String modeId = Util.null2String(request.getParameter("id"));
String typeId = Util.null2String(request.getParameter("typeId"));

String treeFieldId = "";

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23669,user.getLanguage());//模块设置
String needfav ="1";
String needhelp ="";
%>
<%
int userid=user.getUID();
%>	
<body scroll=no>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="loading" >
	<span><img src="/images/loadingext_wev8.gif" align="absmiddle"></span>
	<span id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></span><!-- 页面加载中，请稍候... -->
</div>
<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
<!-- 第一层tab开始 -->
  <tr>
	<td height="30px" class="FormMode" align=left >	
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
		<tr align=left>
			<td nowrap class="item itemSelected" id = 'BasicTab' type='firstItem'
				title="<%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%></td><!--模块设置 -->
            <td nowrap width=2px>&nbsp;<td>
            <td nowrap class="item" id = 'LinkAgeTab' type='firstItem'
				title="<%=SystemEnv.getHtmlLabelName(21683,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(21683,user.getLanguage())%></td><!-- 字段联动 -->
            <td nowrap width=2px>&nbsp;<td>
            <td nowrap class="item" id = 'DefinedTab' type='firstItem'
				title="<%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></td><!-- 自定义信息 -->
            <td nowrap width=2px>&nbsp;<td>
            <td nowrap class="item" id = 'InterfaceTab' type='firstItem'
				title="<%=SystemEnv.getHtmlLabelName(19665,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(19665,user.getLanguage())%></td><!-- 接口设置 -->
            <td nowrap width=2px>&nbsp;<td>
			<td nowrap class="righttab" align=right></td>
		</tr>
	 </table>
	</td>
  </tr>
<!-- 第一层tab结束 -->
  <tr>
	<td colspan="2" style="border-left:1px solid #81b3cc;" valign="top">
		<!-- 模块设置-基本信息(第二层tab) -->
		<div id=divContent  class=firstDiv style="height:100%;width:100%"> 
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="FormModeDtl" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
						  <!-- 基本信息 -->
						  <td nowrap class="item itemSelected" id = 'modeBasicTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></td>
				          <td nowrap width=2px>&nbsp;<td>
				          <!-- 页面布局 -->
				          <td nowrap class="item" id = 'modeHtmlTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(24666,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(24666,user.getLanguage())%></td>
						  <td nowrap width=2px>&nbsp;<td>
						  <!-- 默认值设置 -->
				          <td nowrap class="item" id = 'defaultValueTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></td>
						  <td nowrap width=2px>&nbsp;<td>
						  <!-- 权限设置 -->
				          <td nowrap class="item" id = 'rightSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(16526,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(16526,user.getLanguage())%></td>
						  <td nowrap width=2px>&nbsp;<td>
						  <!-- 编码规则 -->
				          <td nowrap class="item" id = 'codeSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(19381,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(19381,user.getLanguage())%></td>
						  <td nowrap width=2px>&nbsp;<td>
				          <td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;" valign="top">
				   <!-- 数据层-基本信息 -->
				   <div id=modeBasic class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="modeBasicList" src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-页面布局 -->
				   <div id=modeHtml class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="modeHtmlList" src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-默认值设置 -->
				   <div id=defaultValue class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=defaultValueList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-权限设置 -->
				   <div id=rightSet class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=rightSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-编码规则 -->
				   <div id=codeSet class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=codeSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				  </td>
				</tr>
			  </table>
			 </td>
			</tr>
		  </table>
		</div>
		<!-- 模块设置-联动设置(第二层tab) -->
		<div id=divLinkage  class=firstDiv style="height:100%;width:100%"> 
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="FormModeDtl" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
						  <td nowrap class="item" id = 'proplinkageTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(28477,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(28477,user.getLanguage())%></td><!--属性联动 -->
				           <td nowrap width=2px>&nbsp;<td>
				           <td nowrap class="item" id = 'fieldlinkageTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(21848,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(21848,user.getLanguage())%></td><!--字段联动 -->
							<td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;">
				   <!-- 数据层-属性联动 -->
				   <div id=proplinkage class='secondDiv'  style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="proplinkageList" src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-字段联动 -->
				   <div id=fieldlinkage class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="fieldlinkageList" src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				  </td>
				</tr>
			  </table>
			 </td>
			</tr>
		  </table>
		</div>
		<!-- 模块设置-自定义(第二层tab) -->
		<div id=divDefined  class=firstDiv style="height:100%;width:100%"> 
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="FormModeDtl" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
							<!-- 查询设置 -->
						   <td nowrap class="item" id = 'selectSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></td>
				           <td nowrap width=2px>&nbsp;<td>
				            <!-- 报表设置 -->
				           <td nowrap class="item" id = 'reportSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(26504,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(26504,user.getLanguage())%></td>
						   <td nowrap width=2px>&nbsp;<td>
						   <!-- 浏览按钮 -->
				           <td nowrap class="item" id = 'browseSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></td>
						   <td nowrap width=2px>&nbsp;<td>
							<td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;">
				   <!-- 数据层-查询 -->
				   <div id=selectSet class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=selectSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-报表 -->
				   <div id=reportSet class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=reportSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 数据层-浏览按钮  -->
				   <div id=browseSet class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=browseSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				  </td>
				</tr>
			  </table>
			 </td>
			</tr>
		  </table>
		</div>
		<!-- 接口设置-接口信息(第二层tab) -->
		<div id=divInterface  class=firstDiv style="height:100%;width:100%"> 
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="FormModeDtl" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
							<!-- 数据批量导入 -->
							<td nowrap class="item" id = 'batchImportSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%></td>
						   	<td nowrap width=2px>&nbsp;<td>
							<!-- 流程数据转模块数据 -->
						   	<td nowrap class="item" id = 'workflowToModeSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(30055,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(30055,user.getLanguage())%></td>
				           	<td nowrap width=2px>&nbsp;<td>
				            <!-- 模块数据触发流程审批 -->
				           	<td nowrap class="item" id = 'modeToWorkflowSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(30056,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(30056,user.getLanguage())%></td>
						   	<td nowrap width=2px>&nbsp;<td>
				            <!-- 页面扩展-->
				           	<td nowrap class="item" id = 'pageExpandSetTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(30090,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(30090,user.getLanguage())%></td>
						   	<td nowrap width=2px>&nbsp;<td>
							<td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;">
				   <!-- 数据批量导入 -->
				   <div id=batchImport class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=batchImportSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 流程数据转模块数据 -->
				   <div id=workflowToMode class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=workflowToModeSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 模块数据触发流程审批  -->
				   <div id=modeToWorkflow class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=modeToWorkflowSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 页面扩展  -->
				   <div id=pageExpand class='secondDiv' style="height:100%;width:100%">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id=pageExpandSetList src="" width="100%" height="100%" frameborder="0" ></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				  </td>
				</tr>
			  </table>
			 </td>
			</tr>
		  </table>
		</div>
	  </td>
	</tr>
</table>


<script language="javascript">
$(document).ready(function(){
	$("#modeBasicList").attr("src","/formmode/setup/ModeBasic.jsp?ajax=1&modeId=<%=modeId%>&typeId=<%=typeId%>");
	$(".firstDiv").hide();
	$("#divContent").show();
	
	$(".secondDiv").hide();
	$("#modeBasic").show();
})
//绑定tab页点击事件
$(".item").bind("click", function(){
 	clickItem(this);
});
function clickItem(obj){
	if($(obj).hasClass("itemSelected")){
 		return;
  	}else{
  		var itemSelected = $(".itemSelected");
  		for(var i=0;i<itemSelected.length;i++){
  			if($(itemSelected[i]).attr("type")==$(obj).attr("type")){
  				$(itemSelected[i]).removeClass("itemSelected");
  				break;
  			}
  		}
  		$(obj).addClass("itemSelected");
  	}
  	reloadDate($(obj).attr('id'));
  }
  
function reloadDate(id){
	$(".loading").show();
	
	displayOtherIframe();
	
	//第一层
	if(id=='BasicTab'){
		hideFirstDiv($("#divContent"));
		clickItem($("#modeBasicTab"));
	}else if(id=='LinkAgeTab'){
		hideFirstDiv($("#divLinkage"));
		clickItem($("#proplinkageTab"));
	}else if(id=='DefinedTab'){
		hideFirstDiv($("#divDefined"));
		clickItem($("#selectSetTab"));
	}else if(id=='InterfaceTab'){
		hideFirstDiv($("#divInterface"));
		clickItem($("#batchImportSetTab"));
	}

	//第二层
	if(id=='modeBasicTab'){		//基本信息tab
		hideSelectedDiv($("#modeBasic"));
		$("#modeBasicList").attr("src","/formmode/setup/ModeBasic.jsp?ajax=1&modeId=<%=modeId%>&typeId=<%=typeId%>");
	}else if(id=='modeHtmlTab'){	//HTML模板tab
		hideSelectedDiv($("#modeHtml"));
		$("#modeHtmlList").attr("src","/formmode/setup/ModeHtmlSet.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='defaultValueTab'){	//默认值设置
		hideSelectedDiv($("#defaultValue"));
		$("#defaultValueList").attr("src","/formmode/setup/modelDefaultValue.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='proplinkageTab'){		//属性联动
		hideSelectedDiv($("#proplinkage"));
		$("#proplinkageList").attr("src","/formmode/setup/LinkageAttr.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='fieldlinkageTab'){	//字段联动
		hideSelectedDiv($("#fieldlinkage"));
		$("#fieldlinkageList").attr("src","/formmode/setup/fieldTrigger.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='rightSetTab'){	//权限设置
		hideSelectedDiv($("#rightSet"));
		$("#rightSetList").attr("src","/formmode/setup/ModeRightEdit.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='selectSetTab'){	//查询设置
		hideSelectedDiv($("#selectSet"));
		$("#selectSetList").attr("src","/formmode/search/CustomSearch.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='reportSetTab'){	//报表设置
		hideSelectedDiv($("#reportSet"));
		$("#reportSetList").attr("src","/formmode/report/ReportManage.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='browseSetTab'){	//浏览按钮设置
		hideSelectedDiv($("#browseSet"));
		$("#browseSetList").attr("src","/formmode/browser/CustomBrowser.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='codeSetTab'){	//编码规则
		hideSelectedDiv($("#codeSet"));
		$("#codeSetList").attr("src","/formmode/setup/ModeCode.jsp?ajax=1&modeId=<%=modeId%>");
	}else if(id=='batchImportSetTab'){	//批量导入
		hideSelectedDiv($("#batchImport"));
		$("#batchImportSetList").attr("src","/formmode/interfaces/ModeDataBatchImport.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='workflowToModeSetTab'){	//流程数据转模块数据
		hideSelectedDiv($("#workflowToMode"));
		$("#workflowToModeSetList").attr("src","/formmode/interfaces/WorkflowToModeList.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='modeToWorkflowSetTab'){	//模块数据审批
		hideSelectedDiv($("#modeToWorkflow"));
		$("#modeToWorkflowSetList").attr("src","/formmode/interfaces/ModeTriggerWorkflowSet.jsp?ajax=1&modeid=<%=modeId%>");
	}else if(id=='pageExpandSetTab'){	//页面扩展
		hideSelectedDiv($("#pageExpand"));
		$("#pageExpandSetList").attr("src","/formmode/interfaces/ModePageExpand.jsp?ajax=1&modeid=<%=modeId%>");
	}
	
}

function displayOtherIframe(){
	$("iframe").each(function(){
		//if($(this).attr("src").indexOf("/formmode/")>-1){
			$(this).attr("src","");
		//}
	});
}

//隐藏第一层tab中的DIV，顺便将本DIV显示，公共方法，只适合第二层tab的DIV
function hideFirstDiv(obj){
	//var firstDiv = $(".firstDiv");
	$(".firstDiv").hide();
	//for(var i=0;i<firstDiv.length;i++){
	//	$(firstDiv[i]).hide();
	//}
	$(obj).show();
}

//隐藏第二层tab中的DIV，顺便将本DIV显示，公共方法，只适合第二层tab的DIV
function hideSelectedDiv(obj){
	//var selectedDiv = $(".secondDiv");
	$(".secondDiv").hide();
	//for(var i=0;i<selectedDiv.length;i++){
	//	$(selectedDiv[i]).hide();
	//}
	$(obj).show();
}
</script>
</body>

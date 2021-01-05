
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(18032,user.getLanguage()) %></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/jquery/plugins/treeview/jquery.treeview_wev8.css" />
<script src="/js/jquery/plugins/treeview/jquery.treeview_wev8.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" media="all" href="/cowork/css/cowork_wev8.css" />
</HEAD>
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
/*if(HrmUserVarify.checkUserRight("", user)){
	isCoworkLader = true;
}*/
%>	
<body scroll=no>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class='loading'><img src='/images/loadingext_wev8.gif'></div>
<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
<!-- 第一层tab开始 -->
<tr>
	<td height="30px" class="coworkTab" align=left >	
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
		<tr align=left>
			<td nowrap class="item itemSelected" id = 'BasicTab' type='firstItem'
				title="<%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%></td><!--模块设置 -->
            <td nowrap width=2px>&nbsp;<td>
            <td nowrap class="item" id = 'Forms' type='firstItem'
            	title='<%=SystemEnv.getHtmlLabelName(699,user.getLanguage())%>'>
            	<%=SystemEnv.getHtmlLabelName(699,user.getLanguage())%></td><!-- 表单管理 -->
            <td nowrap width=2px>&nbsp;<td>
			<td nowrap class="righttab" align=right></td>
		</tr>
	 </table>
	</td>
</tr>
<!-- 第一层tab结束 -->
<tr>
	<td colspan="2" style="border-left:1px solid #81b3cc;">
		<!-- 模块设置-基本信息(第二层tab) -->
		<div id=divContent style="display: ''"> 
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="coworkTab" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
						  <td nowrap class="item itemSelected" id = 'modeBasicTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></td><!--基本信息 -->
				           <td nowrap width=2px>&nbsp;<td>
				           <td nowrap class="item" id = 'modeHtmlTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(24666,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(24666,user.getLanguage())%></td><!--页面布局 -->
				           <td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;">
				   <!-- 数据层 -->
				   <div id=modeBasic style="display: ''">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="modeBasicList" src="/formmode/setup/ModeBasic.jsp?modeId=<%=modeId%>&typeId=<%=typeId%>" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
						 </td>
						</tr>
					  </table>
				   </div>
				   <!-- 页面布局 -->
				   <div id=modeHtml style="display: 'none'">
				      <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
						<tr height=5px><td></td></tr>
						<tr>
						 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
						  <iframe id="modeHtmlList" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
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
		<!-- 表单管理-第二层开始 -->
		<div id=formContent style="display: 'none'">
		  <table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr height=5px><td></td></tr>
			<tr>
			<td nowrap width=2px>&nbsp;<td>
			 <td style="margin:0px;padding:0px"  width="100%" valign="top" >
			  <table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">
			  	<tr>
					<td height="30px" class="coworkTab" align=left >	
					  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
						<tr align=left>
						  <td nowrap class="item itemSelected" id = 'formBasicTab' type='secondItem'
						    title="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
								<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></td><!-- -->
				            <td nowrap width=2px>&nbsp;<td>
				            <td nowrap class="righttab" align=right></td>
						</tr>
					  </table>
					</td>
				</tr>
				<tr>
				  <td colspan="2" style="border-left:1px solid #81b3cc;">
				   <div id=formBasic style="display: 'none'"> asdsad
				   </div>
				  </td>
				</tr>
			  </table>
			 </td>
			</tr>
		  </table>
		</div>
		<!-- 表单管理-第二层结束 -->
	  </td>
	</tr>
</table>
<script language="javascript">
//绑定tab页点击事件
jQuery(".item").bind("click", function(){
 	if(jQuery(this).hasClass("itemSelected")){
 		return;
  	}else{
  		var itemSelected = jQuery(".itemSelected");
  		for(var i=0;i<itemSelected.length;i++){
  			if(jQuery(itemSelected[i]).attr("type")==jQuery(this).attr("type")){
  				jQuery(itemSelected[i]).removeClass("itemSelected");
  				break;
  			}
  		}
  		jQuery(this).addClass("itemSelected");
  	}
  	reloadDate(jQuery(this).attr('id'));
});


function reloadDate(id){
	if(id=='BasicTab'){
		jQuery("#divContent").attr("style","display:''");
		jQuery("#modeBasic").attr("style","display:''");
	}else if(id=='modeBasicTab'){	//基本信息tab
		jQuery("#modeHtml").attr("style","display:'none'");
		jQuery("#modeBasic").attr("style","display:''");
	}else if(id=='modeHtmlTab'){	//HTML模板tab
		jQuery("#modeBasic").attr("style","display:'none'");
		jQuery("#modeHtml").attr("style","display:''");
		if(jQuery("#modeHtmlList").attr("src")=="")
			jQuery("#modeHtmlList").attr("src","/formmode/setup/ModeHtmlSet.jsp?modeId=<%=modeId%>");
		
	}
	//jQuery(".loading").show();
}
</script>
</body>
<!--<script src="/formmode/js/EditMode_wev8.js" type="text/javascript"></script>-->
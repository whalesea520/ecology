<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));
String encryptclass = Util.null2String(request.getParameter("encryptclass"));
String encryptmethod = Util.null2String(request.getParameter("encryptmethod"));
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
String encryptname = Util.null2String(request.getParameter("encryptname"));
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/

String backto = Util.null2String(request.getParameter("backto"));
if(!"".equals(backto))
	typename = backto;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

/*String namesimple = Util.null2String(request.getParameter("namesimple"));
if(!namesimple.equals("")){
	encryptclass=namesimple;
}*/

/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
/*rs.execute("select * from outter_encryptclass");
while(rs.next()){
    String methed = Util.null2String(rs.getString("encryptmethod"));
    String name1 = Util.null2String(rs.getString("encryptname"));
    int id = rs.getInt("id");
    if(name1.equals("")){
        rs.execute("update outter_encryptclass  set encryptname = '" + methed + "' where id = " + id);
    }
}*/
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/

String sqlwhere = "where 1=1 ";

String tableString="";

if(!"".equals(encryptclass))
{	
	sqlwhere+=" and encryptclass like '%"+encryptclass+"%'";
}
if(!"".equals(encryptmethod))
{	
	sqlwhere+=" and encryptmethod like '%"+encryptmethod+"%'";
}
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
if(!"".equals(encryptname))
{	
	sqlwhere+=" and encryptname like '%"+encryptname+"%'";
}
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/
String backfields=" * " ;
String perpage="10";
String PageConstId = "OutterEncryptclass_gxh";
String fromSql=" outter_encryptclass "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.SplitPageTransmethod.getOutterCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
		  /*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17589 ,user.getLanguage())+SystemEnv.getHtmlLabelName(84276,user.getLanguage())+"\" column=\"id\"  orderkey=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getOutterEncryptclassEdit\"  otherpara=\"column:encryptname\" target=\"_self\" />"+
         /*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(32345,user.getLanguage())+"\" column=\"encryptclass\" orderkey=\"encryptclass\" transmethod=\"weaver.interfaces.outter.OutterUtil.getNameLink\"  otherpara=\"column:id\"  />"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(32346,user.getLanguage())+"\" column=\"encryptmethod\"  orderkey=\"encryptmethod\"  />"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(125621,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getEcryptClassReferenceInfo\"  />"+
         "       </head>"+
         "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getEcryptClassPopedom\" ></popedom> "+
		 "     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "</operates>"+
         " </table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="outter_encryptclass.jsp" method="post" name="datalist" id="datalist" >
<input type="hidden" name="typename" value="<%=typename%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<input type="text" class="searchInput" name="namesimple" value="<%=encryptclass%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		    <!-- /*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/ -->
		    <wea:item><%= SystemEnv.getHtmlLabelName(17589 ,user.getLanguage())+SystemEnv.getHtmlLabelName(84276,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="encryptname" value='<%=encryptname%>'></wea:item>
			<!-- /*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/ -->
			<wea:item><%= SystemEnv.getHtmlLabelName(32345,user.getLanguage())%></wea:item>
			<wea:item><input  type="text" name="encryptclass" value='<%=encryptclass%>'></wea:item>
			<wea:item><%= SystemEnv.getHtmlLabelName(32346,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="encryptmethod" value='<%=encryptmethod%>'></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit" id="e8_btn_submit"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId%>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 750;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function resetCondtion()
{
//qc281739[80][90]集成登录-高级搜索中点击重置，会重置下面跳转、分页两个文本框
      $(".advancedSearchDiv input[type=text]").val('');
}
function doRefresh()
{
	//$("#datalist").submit(); 
	var encryptclass=$("input[name='namesimple']",parent.document).val();
	$("input[name='encryptclass']").val(encryptclass);
	window.location="/interface/outter/outter_encryptclass.jsp?encryptclass="+encryptclass;
}
function add()
{
   var url = "/interface/outter/outter_encryptclassTab.jsp?urlType=1&backto=<%=backto%>&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelNames("365,125409",user.getLanguage())%>";
	openDialog(url,title);
}
function doDelete(ids)
{
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
	}
	//alert("ids : "+ids);
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/interface/outter/outter_encryptclassOperation.jsp?backto=<%=typename%>&operation=delete&id="+ids;
	}, function () {}, 320, 90);	
}
function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/interface/outter/outter_encryptclassOperation.jsp?backto=<%=typename%>&operation=delete&id="+id;
	}, function () {}, 320, 90);	
}
function doEditById(id)
{
	if(id=="") return ;
	var url = "/interface/outter/outter_encryptclassTab.jsp?urlType=2&isdialog=1&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelNames("93,125409",user.getLanguage())%>";
	openDialog(url,title);
}
</script>

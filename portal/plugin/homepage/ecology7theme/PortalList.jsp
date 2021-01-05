
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String titlename = SystemEnv.getHtmlLabelName(27714,user.getLanguage());
	String theme = Util.null2String(request.getParameter("theme"));
%>



<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
	.table div{
		text-align: center;
	}
	html,body{
	-webkit-text-size-adjust:none;
	}
</style>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if("ecology7".equals(theme)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33347,user.getLanguage())+",javascript:onImp(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
String linkkey="preview";
String imgurl="/weaver/weaver.splitepage.transform.SptmForPortalThumbnail";
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if("ecology7".equals(theme)){ %>
			<input type=button class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(33347,user.getLanguage()) %>" onclick="onImp();"></input>
			<%}else{ 
				linkkey = "div";
				imgurl="";
			} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
String tableString="<table  datasource=\"weaver.admincenter.homepage.PortalDataSource.getEcology7Theme\" sourceparams=\"theme:"+theme+"\" pagesize=\"10\" tabletype=\"thumbnailNoCheck\">"+
	   "<browser imgurl=\""+imgurl+"\" linkkey=\""+linkkey+"\" linkvaluecolumn=\""+linkkey+"\" path=\"\" />"+
	   "<sql backfields=\"id\" sqlform=\"tmpTable\" sqlsortway=\"asc\" sqlorderby=\"id\" sqlprimarykey=\"id\" />"+
	   "<head>"
	   		+"<col width=\"20%\"  text=\"\" column=\"themeName\" transmethod=\"weaver.splitepage.transform.SptmForPortalThumbnail.getHref\" otherpara=\"column:id+column:name+"+theme+"\"/>"+
	   "</head>";
	   if("ecology8".equals(theme)){
		   tableString+="<operates><popedom transmethod=\"weaver.splitepage.transform.SptmForThumbnail.getPortalOperate\" otherpara=\"column:type\"></popedom> "
		
		 +"<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
		 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
		
		tableString+= "</operates>";
		}
		tableString+= "</table>";      
 %>
<input type="hidden" name="pageId" id="pageId" value="1"/>
<TABLE width="100%">
	<tr><td>&nbsp;</td></tr>
	<TR>
		<TD valign="top">
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowThumbnail="1" imageNumberPerRow="5"/>
		</TD>
	</TR>
</TABLE>	


</body>
</html>
<script language="javascript">
function onImp(){
	var theme_imp = new window.top.Dialog();
	theme_imp.currentWindow = window;   //传入当前window
 	theme_imp.Width = 500;
 	theme_imp.Height = 200;
 	theme_imp.Modal = true;
 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(33347,user.getLanguage())%>"; 
 	theme_imp.URL = "/portal/plugin/homepage/ecology7theme/themeIpmTab.jsp?theme=<%=theme%>";
 	theme_imp.show();
	
}
//zip包名需与ID一致
function onDownload(themeid){
	var theme="<%=theme%>";
	var themepath = "/wui/theme/zip/"+theme+"/"+themeid+".zip";
	window.open(themepath);
}

function onEdit(id){

	var theme_imp = new window.top.Dialog();
	theme_imp.currentWindow = window;   //传入当前window
 	theme_imp.Width = getDialogWidth();
 	theme_imp.Height = getDialogHeight();
 	theme_imp.Modal = true;
 	theme_imp.maxiumnable=true;
 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
 	theme_imp.URL = "/systeminfo/template/ThemeEditorTab.jsp?id="+id;
 	theme_imp.show();
}
function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>",function(){
		$.post("/systeminfo/template/themeOperation.jsp",
			{method:'del',id:id},
			function(data){
				data = $.parseJSON($.trim(data));
				document.location.reload();
			//	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83472,user.getLanguage())%>');
			}
		)
	});
	
}

function getDialogWidth(){
	return top.document.body.clientWidth;
}

function getDialogHeight(){
	return top.document.body.clientHeight;
}
</script>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String titlename = SystemEnv.getHtmlLabelName(23088,user.getLanguage());
String templatetype = Util.null2String(request.getParameter("templatetype"));
String templateName = Util.null2String(request.getParameter("templateName"));

templatetype = "".equals(templatetype)?"0":templatetype;

String sqlWhere = " templatetype=" + templatetype;
if(!"".equals(templateName))sqlWhere += " and templateName like '%"+templateName+"%'";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body  id="myBody">
<form id="newsSearchForm" name="newsSearchForm" method="post" action="/page/maint/template/news/NewsTemplateList.jsp">
	<input type="hidden" id="operate" name="operate" value=""/>
	<input type="hidden" id="templatetype" name="templatetype" value="<%=templatetype%>"/>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">					
				</td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd('','');" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onImportLayout()">
					<input type="text" class="searchInput" name="templateName"/>
					&nbsp;&nbsp;&nbsp;
					<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
	</form>
<%
String tableString=""+
	"<table pagesize=\"20\" tabletype=\"checkbox\">"+
	"<sql backfields=\"  id,templatename,templatedesc,templatetype,templatedir  \" sqlform=\" pagenewstemplate \" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlorderby=\"id\" sqlwhere=\" "+sqlWhere+" \" />"+
	"<head>"+
		"<col width=\"5%\"   text=\"ID\"   column=\"id\"/>"+
		"<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(22009,user.getLanguage())+"\" column=\"templatename\" orderkey=\"templatename\" transmethod=\"weaver.splitepage.transform.SptmForNewsThumbnail.getHref\" otherpara=\"column:id+column:templatename+column:templatetype+column:templatedir\" />"+
		"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"templatedesc\"/>"+
	"</head>"
	+ "<operates><popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForNewsThumbnail.getOperate\"></popedom> "
	 + "<operate href=\"javascript:onPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
	 + "<operate href=\"javascript:onDownload();\" text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
	 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
	 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
	 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"
	 + "</operates></table>";
%>
<TABLE width="100%">
	<TR>
		<TD valign="top">
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</TD>
	</TR>
</TABLE>
</body>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
	$(document).ready(function(){	
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onSearch(){
		newsSearchForm.submit();
	}
	
	function onPriview(newsid){
		var newsdir = jQuery("#newsthumbnail_"+newsid).attr("newsdir");
	 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
	 	var url = "/page/news/"+newsdir+"index.htm?e="+new Date().getTime();
	 	showDialog(title,url,768,660,true);
	}
	
	function onDownload(newsid){
		var newsdir = jQuery("#newsthumbnail_"+newsid).attr("newsdir");
	 	var url = "/weaver/weaver.page.maint.template.news.NewsTemplateDownloadServlet?newsdir="+newsdir;
	 	window.open(url);
	}
	
	function onAdd(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>"; 
	 	var url = "/page/maint/template/news/NewsTemplateEdit.jsp?pageUrl=list&newstemptype=<%=templatetype%>&operation=save&isCreate=1";
	 	showDialog(title,url,900,660,false);
	}
	
	function onEdit(newsid){
		var newstype = jQuery("#newsthumbnail_"+newsid).attr("newstype");	
	 	var title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"; 
	 	var url = "/page/maint/template/news/NewsTemplateEdit.jsp?pageUrl=list&operation=save&newstempid="+newsid+"&newstemptype="+newstype;
	 	showDialog(title,url,900,660,false);
	}
	
	function onImportLayout(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"; 
	 	var url = "/page/maint/template/news/NewsTemplateImport.jsp?pageUrl=list&newstemptype=<%=templatetype%>&operation=save&isCreate=1";
	 	showDialog(title,url,600,360,false);
	}
	
	function onDel(newsid){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			var newstype = jQuery("#newsthumbnail_"+newsid).attr("newstype");
			jQuery.post("/page/maint/template/news/NewsTemplateoperate.jsp?pageUrl=list&operation=delTemplate&newstempid="+newsid+"&newstemptype="+newstype,function(data){
				if(data.indexOf("OK")){location.reload();}
			});
		})
	}
	
	function saveNew(newsid){
		var newstype = jQuery("#newsthumbnail_"+newsid).attr("newstype");
	 	var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	var url = "/page/maint/template/news/NewsTemplateEdit.jsp?pageUrl=list&operation=saveNew&newstempid="+newsid+"&newstemptype="+newstype;
	 	showDialog(title,url,600,360,false);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
</script>
</html>

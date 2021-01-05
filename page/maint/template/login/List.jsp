
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String titlename = SystemEnv.getHtmlLabelName(23140,user.getLanguage());
String portalname = Util.null2String(request.getParameter("portalname"));
String dirTemplate=pc.getConfig().getString("template.path");
String sqlWhere ="";
if(!"".equals(portalname)) sqlWhere += " templatename like '%"+portalname+"%'"; 
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33347,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<!--For Dialog-->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

</head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form action="List.jsp" method="post" name="PortalForm" action="List.jsp">
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(33347,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd();" />
				<input type="text" class="searchInput" name="portalname" value="<%=portalname%>"/>
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
	//得到pageNum 与 perpage
	int perpage =10;
	//设置好搜索条件
	String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\">"
	  + "<sql backfields=\" id,templatename,templatedesc,templatetype,templateusetype,dir,zipName \" sqlform=\" pagetemplate \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
		"<head >"+
			"<col width=\"5%\"   text=\"ID\"   column=\"id\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22009,user.getLanguage())+"\"   column=\"templatename\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"templatedesc\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\"   column=\"templatetype\" otherpara=\""+user.getLanguage()+"+column:id+column:dir+column:zipName\" transmethod=\"weaver.splitepage.transform.SptmForPortalLayout.getTempalteUseType\"/>"+
		"</head>"
		 + "<operates><popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForPortalLayout.getOperate\"></popedom> "
		 + "<operate href=\"javascript:onPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
		 + "<operate href=\"javascript:onDownload();\" text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
		 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
		 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
		 + "</operates></table>";						
	%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
			</TD>
		</TR>
	</TABLE>
</body>
</html>
<script>
	function onPriview(templateid){
		var a_href = "<%=dirTemplate%>";
		a_href += jQuery("#template_"+templateid).attr("templateDir");
		a_href += "index.htm";
		var template_dialog = new window.top.Dialog();
		template_dialog.currentWindow = window;   //传入当前window
	 	template_dialog.Width = 800;
	 	template_dialog.Height = 500;
	 	template_dialog.maxiumnable=true;
	 	template_dialog.Modal = true;
	 	template_dialog.Title = $("#template_"+templateid).parents("tr:first").find("td:nth-child(3)").html(); 
	 	template_dialog.URL = a_href;
		template_dialog.show();
	}
	
	function onDownload(templateid){
		var a_href = "<%=dirTemplate%>zip/";
		a_href += jQuery("#template_"+templateid).attr("templateDir");
		a_href = a_href.substring(0,a_href.length-1)+".zip";
		window.open(a_href);
	}

	function onAdd(){
		var hpTemp_add = new window.top.Dialog();
		hpTemp_add.currentWindow = window;   //传入当前window
	 	hpTemp_add.Width = 500;
	 	hpTemp_add.Height = 300;
	 	hpTemp_add.Modal = true;
	 	hpTemp_add.Title = "<%=SystemEnv.getHtmlLabelName(84154,user.getLanguage())%>"; 
	 	hpTemp_add.URL = "/page/maint/template/login/PortalTemplateEdit.jsp?method=add";
	 	hpTemp_add.show();
	}
	
	function onEdit(templateid){		
		var hpTemp_add = new window.top.Dialog();
		hpTemp_add.currentWindow = window;   //传入当前window
	 	hpTemp_add.Width = 500;
	 	hpTemp_add.Height = 300;
	 	hpTemp_add.Modal = true;
	 	hpTemp_add.Title = "<%=SystemEnv.getHtmlLabelName(84155,user.getLanguage())%>"; 
	 	hpTemp_add.URL = "/page/maint/template/login/PortalTemplateEdit.jsp?method=edit&templateid="+templateid;
	 	hpTemp_add.show();
	}

	function onDel(templateid){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			$.post("/page/maint/template/login/Operate.jsp",{"method":'del',"templateid":templateid},function(data){
				window.location.reload();
			}); 
		});
	}

	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
	});
	
	function onSearch(){
		PortalForm.submit();
	}
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("templaterar").value;
		if(fileName!=''){
			fileName=fileName.toLowerCase();   
			var lens=fileName.length;   
			var extname=fileName.substring(lens-4,lens);   
			if(extname!=".zip")   
			{   
			  alert("<%=SystemEnv.getHtmlLabelName(23942,user.getLanguage())%>");  
			  return false;
			} 
			if(/.*[\u4e00-\u9fa5]+.*$/.test(fileName.substr(fileName.lastIndexOf('\\')+1))){
		    	 alert("<%=SystemEnv.getHtmlLabelName(23984,user.getLanguage())%>");  
		    	return false;
		    }
		    
		    return true; 
	    }else{
	    	return true;
	    } 
	}
	//提交判断必填项是否为空
	function actionCheck(){
		var txtName = document.getElementById("templatename").value;
		var descName = document.getElementById("templatedesc").value;
		var rarName = document.getElementById("templaterar").value;
		if(frmAdd.method.value=="add"){
			if(txtName==''||descName==''||rarName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}else if (frmAdd.method.value=="edit"){
			if(txtName==''||descName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}
		return true;
	}
</script>

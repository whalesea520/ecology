<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#form1").submit();
	}
</script>
</head>
<%
String imagetype=Util.null2String(request.getParameter("imagetype"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));
String qname = Util.null2String(request.getParameter("flowTitle"));

boolean canAdd=false;
boolean canDelete=false;
boolean canEdit=false;
if(HrmUserVarify.checkUserRight("DocPicUploadAdd:Add", user)){
	canAdd=true;
}
if(HrmUserVarify.checkUserRight("DocPicUploadEdit:Delete", user)){
	canDelete=true;
}
if(HrmUserVarify.checkUserRight("DocPicUploadEdit:Edit", user)){
	canEdit=true;
}
%>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/docs/tools/DocPicUpload.jsp";
	parentWin.closeDialog();	
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(url,isEdit){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(isEdit){
<%if(canEdit){%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,74",user.getLanguage())%>";
<%}else{%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("367,74",user.getLanguage())%>";
<%}%>
		dialog.maxiumnable = true;
		dialog.Width = 800;
		dialog.Height = 600;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,74",user.getLanguage())%>";
		dialog.Width = 500;
		dialog.Height = 300;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onDelete(id){
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
	var ids = id.split(",");
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33442,user.getLanguage())%>",function() {
		var ajaxNum = 0;
		for(var i=0;i<ids.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"UploadImage.jsp?operation=delete&isdialog=2&id="+ids[i],
				method:"post",
				dataType:"text",
				complete:function(xhr,ts){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				},
				error:function(xhr,msg,e){
					
				}
			});
		}
	});
}

function onLog(){
	var dialog = new window.top.Dialog();
	dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem =8")%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
	dialog.Width = jQuery(document).width();
	dialog.Height = 610;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.show();
	
}

</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canAdd){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(canDelete){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocPicUpload:Log", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form1" name="form1" method="post" action="DocPicUpload.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td width="60%">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		
		<%
			if(canAdd){
			%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:onNew()"/>
			<%
			}
			%>
			<%if(canDelete){ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:onDelete()"/>
			<%} %>
			<input type="hidden" name="imagetype" id="imagetype" value="<%=imagetype %>"/>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

    	<%
		String sqlWhere = "";
		if(imagetype.equals("")){
			sqlWhere = "1=1";
		}else{
			sqlWhere = "pictype="+imagetype;
		}
		if(!qname.equals("")){
			sqlWhere += " and picname like '%"+qname+"%'";
		}
		String browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"imagefileid\" linkvaluecolumn=\"imagefileid\" />";
		String operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getNewsImgOperate\" ></popedom> ";
if(canEdit){
	 	       operateString+="     <operate href=\"javascript:onEdit();\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
}else{
	 	       operateString+="     <operate href=\"javascript:onEdit();\"  text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" index=\"0\"/>";
}
if(canDelete){
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
}			  
	 	       operateString+="</operates>";	
		String tableString=""+
		   "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_NEWSPICLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"thumbnail\">"+
		   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getImageCheckbox\"  popedompara=\"column:id\" />"+
		   browser+
		   "<sql backfields=\"id,pictype,picname,imagefilesize,imagefileid\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"DocPicUpload\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   operateString+
		   "<head>"+							 
				/* "<col width=\"20%\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.KnowledgeTransMethod.getPicType\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"pictype\" orderkey=\"pictype\"/>"+*/
				 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" transmethod=\"weaver.general.KnowledgeTransMethod.getPicName\"  column=\"picname\" otherpara=\"column:id\" orderkey=\"picname\"/>"+
				 /*"<col width=\"30%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPicPreview\" text=\""+SystemEnv.getHtmlLabelName(74,user.getLanguage())+"\" column=\"imagefileid\"/>"+
				 "<col width=\"20%\" otherpara=\""+user.getLanguage()+"\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPicSize\" text=\""+SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(2036,user.getLanguage())+"\" column=\"imagefilesize\"/>"+*/					
		   "</head>"+
		   "</table>"; 
		   
		
%>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_NEWSPICLIST %>"/>
<wea:SplitPageTag isShowThumbnail="true" isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</form>
<script>
    function onNew(){
    	openDialog("/docs/tabs/DocCommonTab.jsp?_fromURL=17&isdialog=1",false);
    }
    function onEdit(id){
    	openDialog("/docs/tabs/DocCommonTab.jsp?_fromURL=18&isdialog=1&id="+id,true);
    }
</script>
</BODY></HTML>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<% 
	String refresh = Util.null2String(request.getParameter("refresh"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">

jQuery(document).ready(function(){
	<%if("1".equals(refresh)){%>
		parent.parent.refreshTreeMain(0,0);
	<%}else if("2".equals(refresh)){%>
		parent.parent.refreshTreeMain(0,0,{add:true});
	<%}%>
});

function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
try{
	parent.setTabObjName("<%= SystemEnv.getHtmlLabelName(16978,user.getLanguage()) %>");
}catch(e){}
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
		//window.location.href="/docs/sendDoc/WorkflowKeywordOperation.jsp?isdialog=1&operation=Delete&id="+id;
		jQuery.ajax({
			url:"/docs/sendDoc/WorkflowKeywordOperation.jsp?isdialog=1&operation=Delete&id="+id,
			type:"post",
			dataType:"html",
			success:function(data){
				parent.parent.refreshTreeMain(null,null);
				_table.reLoad();
			},
			error:function(xhr,status,e){
				//console.log(e);
			}
		});
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&parentId=0&hisId=0";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16978",user.getLanguage())%>";
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=39&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16978",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&parentId=0&hisId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16978",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog3(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&parentId="+id+"&hisId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16978",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
	<%if("1".equals(refresh)){%>
		parent.parent.refreshTreeMain(null,null);
	<%}%>
});

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
       
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

}

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(343),_top} " ;
RCMenuHeight += RCMenuHeightStep ;


%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<% if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%
	String sqlWhere = "parentId<=0";
	if(!qname.equals("")){
		sqlWhere += " and keywordName like '%"+qname+"%'";
	}							
	String  operateString= "";
	if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getKeywordOperate\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog2()\" text=\""+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog3()\" text=\""+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="</operates>";	
	 }	
	String tableString=""+
	   "<table instanceid=\"docMouldTable\" pageId=\""+PageIdConst.DOC_DOCKEYWORDLIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCKEYWORDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getWfKeywordCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"Workflow_Keyword\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  href=\"/docs/sendDoc/DocKeywordTab.jsp?_fromURL=3\" column=\"keywordName\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" orderkey=\"keywordName\"/>"+
			 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"keywordDesc\"/>"+
			 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showOrder\"/>"+
	   "</head>"+
	   "</table>";
%> 
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCKEYWORDLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />


</BODY></HTML>

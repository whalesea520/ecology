
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%	
	if(!HrmUserVarify.checkUserRight("newstype:maint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
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
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
			window.location="/docs/news/type/newstypeOperation.jsp?from=list&txtMethod=del&id="+id;
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
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=19&isdialog=1";
		if(!!id){
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,19789",user.getLanguage())%>";
			url = url+"&type=edit&id="+id;
		}else{
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,19789",user.getLanguage())%>";
		}
		dialog.Width = 600;
		dialog.Height = 249;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onLog(){
		var dialog = new window.top.Dialog();
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem =100")%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
		
	}

</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19859,user.getLanguage());
String needfav ="1";
String needhelp ="";
String typename = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("newstype:maint", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="newstypeList.jsp" name="frmmain" id="frmmain">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%
				if(HrmUserVarify.checkUserRight("newstype:maint", user)){
				%>
					<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openDialog();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" class="e8_btn_top" onclick="doDel();"/>
				<%
				}
				%>
				<input type="text" class="searchInput" name="flowTitle" value="<%= typename %>"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
</form>
			<%
				//设置好搜索条件				
				String sqlWhere = "1=1";
				if(!typename.equals("")){
					sqlWhere = " typename like '%"+typename+"%'";
				}
				String  operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getNewsTypeOperate\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";
				String tableString=""+
					   "<table pageId=\""+PageIdConst.DOC_NEWSTYPELIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_NEWSTYPELIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
					   " <checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getNewsTypeChecbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"newstype\" sqlorderby=\"dspnum\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   operateString+
					   "<head>"+							 
							 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\" transmethod=\"weaver.general.KnowledgeTransMethod.getTypeName\" otherpara=\"column:id\"/>"+
							 "<col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\"/>"+
							 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dspnum\" orderkey=\"dspnum\"/>"+						
					   "</head>"+
					   "</table>";      
			  %>
			  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_NEWSTYPELIST %>"/>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
</BODY>
</HTML>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML><HEAD>
<%String parentid = Util.null2String(request.getParameter("parentid")); %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#flowTitle").val(parent.jQuery("#flowTitle").val());
	jQuery("#searchfrm").submit();
}
</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
	<script type="text/javascript">
		function onAdd(){
			var wordDialog = new window.top.Dialog();
			wordDialog.currentWindow = window;
			var url = "/security/sensitive/SensitiveTab.jsp?_fromURL=1";
			wordDialog.Title = "<%=SystemEnv.getHtmlLabelNames("611,131596",user.getLanguage())%>";
			wordDialog.Height = 300;
			wordDialog.Width = 600;
			wordDialog.Drag = true;
			wordDialog.URL = url;
			wordDialog.show();
		}

		function onEdit(id){
			if(!id){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
				return;
			}
			var wordDialog = new window.top.Dialog();
			wordDialog.currentWindow = window;
			var url = "/security/sensitive/SensitiveTab.jsp?_fromURL=2&id="+id;
			wordDialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,131596",user.getLanguage())%>";
			wordDialog.Height = 300;
			wordDialog.Width = 600;
			wordDialog.Drag = true;
			wordDialog.URL = url;
			wordDialog.show();
		}

		function onDelete(id){
			if(!id){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83439,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/security/sensitive/SensitiveWordOperation.jsp?operation=delete&id="+id,
			type:"post",
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			success:function(data){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
				_table.reLoad();
			},
			complete:function(xhr,status){
				e8showAjaxTips("",false);
			}
		});
	});
		}

	</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
 %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.toHtml2(Util.null2String(request.getParameter("flowTitle")));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onAdd(),_top}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onAdd();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onAdd();" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle"  id="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
	String sqlWhere = "";
	if(!qname.equals("")){
		sqlWhere = " word like '%"+qname+"%'";
	}	
	 String tabletype="checkbox";
	String  operateString= "";
	operateString = "<operates width=\"20%\" isalwaysshow=\"true\">";
	 	       operateString+="     <operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	String tableString=""+
	   "<table pageId=\"SensitiveWords_20170919\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize("SensitiveWords_20170919",user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"sensitive_words\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col pkey=\"id\" width=\"5%\" text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
			 "<col pkey=\"words\" width=\"75%\" text=\""+SystemEnv.getHtmlLabelName(131596,user.getLanguage())+"\" column=\"word\"/>";
	   tableString += "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" value="SensitiveWords_20170919" _showCol=false/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  />
</BODY>
</HTML>
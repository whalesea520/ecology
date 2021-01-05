
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
</script>
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String name = Util.null2String(request.getParameter("flowTitle"));
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
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
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
			window.location='/web/webmagazine/WebMagazineOperation.jsp?method=typedel&typeid='+id;
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
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=40&isdialog=1";
		if(!!id){
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,31516",user.getLanguage())%>";
			url ="/docs/tabs/DocCommonTab.jsp?_fromURL=41&isdialog=1&typeID="+id;
		}else{
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,31516",user.getLanguage())%>";
		}
		dialog.Width = 600;
		dialog.Height = 214;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}

function openDialogMagazine(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=42&isdialog=1&typeID="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,31518",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 249;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}

function onLog(){
		_onViewLog(273,"<%=xssUtil.put("where operateitem=273")%>");
	}

function doPreview(id){
	window.open("/tom_magazine.jsp?typeID="+id);
}

</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("webMagazineType_subcompanyid")));

	String hasRightSub = Util.null2String(session.getAttribute("hasRightSub2"));
	if(!hasRightSub.equals("")){
	subcompanyId=hasRightSub;
	}
	session.removeAttribute("hasRightSub2");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="WebMagazineTypeList.jsp" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td width="30%">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openDialog();"/>
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(91 ,user.getLanguage())%>" onclick="javascript:doDel();"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%= name %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
		 <!--列表部分-->
		  <%
				//得到pageNum 与 perpage
				int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
				int perpage =10;
				//设置好搜索条件
				String backFields ="id , name , remark ";
				String fromSql = " WebMagazineType ";                              
				String orderBy="id";
				
				String sqlWhere = "1=1";
				if(!name.equals("")){
					sqlWhere += " and name like '%"+name+"%'";
				}
				if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
					sqlWhere += " and subcompanyid in("+subcompanyId+")";
				}	
				String tableString=""+
					   "<table pageId=\""+PageIdConst.DOC_WEBMAGAZINETYPELIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_WEBMAGAZINETYPELIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
					   "<sql backfields=\""+backFields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"  sqldistinct=\"true\" />"+
					   "<head>"+                                           
							 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(31517,user.getLanguage())+"\" target=\"_parent\" column=\"name\" orderkey=\"name\" linkvaluecolumn=\"id\"  href =\"DocWebTab.jsp?_fromURL=2\" linkkey=\"typeID\"/>"+
							 "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"/>"+                                           
					   "</head>"+
					   "<operates width=\"20%\">"+
					   "	<operate href=\"javascript:doPreview()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" />"+
					   "	<operate href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" />"+
					   "	<operate href=\"javascript:openDialogMagazine()\" text=\""+SystemEnv.getHtmlLabelName(456,user.getLanguage())+SystemEnv.getHtmlLabelName(31518,user.getLanguage())+"\" />"+
					   "	<operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" />"+
					   "</operates>"+
					   "</table>";                                             
			  %>
			  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_WEBMAGAZINETYPELIST %>"/>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowBottomInfo="true"/> 
</BODY>
</HTML>

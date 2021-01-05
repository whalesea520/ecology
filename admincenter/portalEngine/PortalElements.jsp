
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
  <head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>
<%
String titlename=""; 
String ename = Util.null2String(request.getParameter("flowTitle"));
String sqlWhere = " loginview != '4' ";
if(!"".equals(ename))sqlWhere += " and title like '%"+ename+"%'";
%>  
  <body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form id="searchEle" name="searchEle" method="post" action="PortalElements.jsp">
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(33619,user.getLanguage())%>" class="e8_btn_top"
						onclick="onAllArchive()" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(33620,user.getLanguage())%>" class="e8_btn_top"
						onclick="unAllArchive()" />
				<input type="text" class="searchInput" name="flowTitle"/>
				&nbsp;&nbsp;&nbsp;
				<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
	
	
</form>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33619,user.getLanguage())+",javascript:onAllArchive();',_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33620,user.getLanguage())+",javascript:unAllArchive();',_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
		<%
		//得到pageNum 与 perpage
		int perpage =10;
		//设置好搜索条件
		String tableString="<table pageId=\""+PageIdConst.HP_ELEMENTS+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.HP_ELEMENTS,user.getUID(),PageIdConst.HP)+"\" tabletype=\"checkbox\" valign=\"top\">"
		  + "<sql backfields=\" id,title,elementtype,elementdesc,isuse,loginview \" sqlform=\" from hpBaseElement \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
			"<head >"+
				"<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"   column=\"title\"/>"+
				"<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"elementdesc\"/>"+
				"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"   column=\"isuse\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getIsUseStr\"/>"+
				"<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+"\"   column=\"loginview\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getERange\"/>"+
			"</head>"
			 + "<operates><popedom otherpara=\"column:isuse+column:elementtype\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getOperate\"></popedom> "
			 + "<operate href=\"javascript:onPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
			 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
			 + "<operate href=\"javascript:onArchive();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
			 + "<operate href=\"javascript:unArchive();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
			 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"
			 + "<operate href=\"javascript:Queryreferences();\" text=\""+SystemEnv.getHtmlLabelName(33364,user.getLanguage())+"\" target=\"_self\"  index=\"5\"/>"
			 + "</operates></table>";						
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HP_ELEMENTS %>"/>
		<TABLE width="100%">
			<TR>
				<TD valign="top">
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
				</TD>
			</TR>
		</TABLE>
					
  </body>
</html>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onSearch(){
		searchEle.submit();
	}
	
	function onArchive(ebaseid){//封存
		jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp",{"ebaseid":ebaseid,"operate":"onArchive"},function(data){
			
			if(data.indexOf("OK")!=-1){
				location.reload();
			}
		});		
	}
	
	function unArchive(ebaseid){//解封
		jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp",{"ebaseid":ebaseid,"operate":"unArchive"},function(data){
			
			if(data.indexOf("OK")!=-1){
				location.reload();
			}
		});		
	}
	
	function onAllArchive(){//批量封存
		var ebaseids = _xtable_CheckedCheckboxId();
		
		if(ebaseids!="")
			onArchive(ebaseids);		
	}
	
	function unAllArchive(){//批量解封
		var ebaseids = _xtable_CheckedCheckboxId();
		if(ebaseids!="")
			unArchive(ebaseids);		
	}
	
	function Queryreferences(ebaseid){//查看引用
		var eferences_dialog = new window.top.Dialog();
		eferences_dialog.currentWindow = window;   //传入当前window
	 	eferences_dialog.Width = 700;
	 	eferences_dialog.Height = 500;
	 	eferences_dialog.Modal = true;
	 	eferences_dialog.Title = "<%=SystemEnv.getHtmlLabelName(33364,user.getLanguage())%>"; 
	 	eferences_dialog.URL = "/homepage/maint/HomepageTabs.jsp?_fromURL=pReferences&ebaseid="+ebaseid;
	 	eferences_dialog.show();
		
	}
	
	function onPriview(ebaseid){
		var eview_dialog = new window.top.Dialog();
		eview_dialog.currentWindow = window;   //传入当前window
	 	eview_dialog.Width = 700;
	 	eview_dialog.Height = 500;
	 	eview_dialog.Modal = true;
	 	eview_dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>";
	 	eview_dialog.URL = "/admincenter/portalEngine/ElementPriview.jsp?isDialog=1&ebaseid="+ebaseid+"&date=" + new Date().getTime();
	 	eview_dialog.show();
	}
	
	function onEdit(ebaseid){
		var eview_dialog = new window.top.Dialog();
		eview_dialog.currentWindow = window;   //传入当前window
	 	eview_dialog.Width = 700;
	 	eview_dialog.Height = 500;
	 	eview_dialog.Modal = true;
	 	eview_dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
	 	eview_dialog.URL = "/admincenter/portalEngine/ElementCustomEdit.jsp?isDialog=1&ebaseid="+ebaseid+"&date=" + new Date().getTime();
	 	eview_dialog.show();
	}
	
	function onDel(ebaseid){
		jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp",{"ebaseid":ebaseid,"operate":"del"},function(data){
			if(data.indexOf("OK")!=-1){
				location.reload();
			}
		});	
	}
</script>

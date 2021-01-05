
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
  <head>

    
    <title><%=SystemEnv.getHtmlLabelName(33463,user.getLanguage())%></title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>
<%
String titlename=""; 
%>  
  <body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>	
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>		
				</td>
				<td style="text-align:right">
					<form id="searchEle" name="searchEle" method="post" action="PortalElementoperation.jsp">
						<input type="text" class="searchInput"  name="name" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" onclick="searchElement();"/>&nbsp;&nbsp;&nbsp;
						<input type="image" src="/images/requestImages/3_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"/>
					</form>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:12px;font-weight:bold;display:inline-block;display:-moz-inline-stack;line-height:40px;width:75px;text-align:center;background-color:#E3E1E2"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span> 
		</div>
		<%
		//得到pageNum 与 perpage
		int perpage =10;
		//设置好搜索条件
		String tableString="<table pageId=\""+PageIdConst.HP_ELEMENTS+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.HP_ELEMENTS,user.getUID(),PageIdConst.HP)+"\" tabletype=\"checkbox\" valign=\"top\">"
		  + "<sql backfields=\" id,title,elementtype,elementdesc,isuse,loginview \" sqlform=\" from hpBaseElement \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\" loginview != 4 \" sqlisdistinct=\"false\" />"+
			"<head >"+
				"<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(82755,user.getLanguage())+"\"   column=\"title\"/>"+
				"<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"elementdesc\"/>"+
				"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(81513,user.getLanguage())+"\"   column=\"isuse\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getIsUseStr\"/>"+
				"<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(33839,user.getLanguage())+"\"   column=\"loginview\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getERange\"/>"+
			"</head>"
			 + "<operates><popedom otherpara=\"column:isuse+column:elementtype\" transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getOperate\"></popedom> "
			 + "<operate href=\"javascript:Queryreferences();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
			 + "<operate href=\"javascript:onArchive();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
			 + "<operate href=\"javascript:Queryreferences();\" text=\""+SystemEnv.getHtmlLabelName(33364,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
			 + "<operate href=\"javascript:unArchive();\" text=\""+SystemEnv.getHtmlLabelName(33839,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
			 + "<operate href=\"javascript:onArchive();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"
			 + "<operate href=\"javascript:unArchive();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" target=\"_self\"  index=\"5\"/>"
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
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onArchive(elmenteid){//封存
		jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp",{"elementid":elmenteid,"operate":"onArchive"},function(data){
			location.reload();
		});		
	}
	
	function unArchive(elmenteid){//解封
		jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp",{"elementid":elmenteid,"operate":"unArchive"},function(data){
			location.reload();
		});		
	}
	
	function Queryreferences(elmenteid){//查询引用
		location.href="/admincenter/portalEngine/PortalReferencesInfo.jsp?elementid="+elmenteid;
	}
</script>

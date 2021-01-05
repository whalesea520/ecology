<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.PageIdConst"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

int userid=user.getUID(); 
int usertype = 0 ;

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
String hpid = Util.null2String(request.getParameter("hpid"));
int subCompanyId =Util.getIntValue(pc.getSubcompanyid(hpid) , -1);
%>
<html>
  <head>
    <base href="<%=basePath%>">
	
	<style type="text/css">
		* {
			font-size:12px;
		}
	</style>
	
	<script type="text/javascript">
	
	$(function () {
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	})
	
	function onBtnSearchClick() {
		$("#noticeform")[0].submit();
	}
	
	function onNewnotice() {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = "/page/element/newNotice/detailsetting.jsp?isfromlist=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) + SystemEnv.getHtmlLabelName(23666,user.getLanguage())%>";
		
		dialog.Width = 600;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.maxiumnable = true;
		dialog.callbackfun = function (paramobj, id1) {
			dialog.close();
		};
		dialog.show();
	}
	
	
	function updateNotice(id) {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = "/page/element/newNotice/detailviewTab.jsp?eid=<%=eid%>&subCompanyId=<%=subCompanyId %>&hpid=<%=hpid %>&isfromlist=1&id=" + id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + SystemEnv.getHtmlLabelName(23666,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.maxiumnable = true;
		dialog.callbackfun = function (paramobj, id1) {
			dialog.close();
		};
		dialog.show();
	}
	
	
	function updateNotice2(id) {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = "/page/element/newNotice/detailsetting.jsp?isfromlist=1&id=" + id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) + SystemEnv.getHtmlLabelName(23666,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.maxiumnable = true;
		dialog.callbackfun = function (paramobj, id1) {
			dialog.close();
		};
		dialog.show();
	}
	
	function onDel(nid) {
		nids = nid + ",";
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83877,user.getLanguage())%>?",function(){
			$.ajax({
				url: "/page/element/newNotice/detailsettingOperation.jsp",
				type : "GET", 
				data : {isdel:"true", delids:nids, isfromlist:"1"},
		        contentType : "charset=UTF-8", 
		        error:function(ajaxrequest){
		        	//dialog.close();
				}, 
		        success:function(content) {
		        	_table.reLoad();
				}
			});
		});
	}
	
	function onMultiDel() {
		if (_xtable_CheckedCheckboxId() == "") {
			alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			return ;
		}
		
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83877,user.getLanguage())%>?",function(){
			$.ajax({
				url: "/page/element/newNotice/detailsettingOperation.jsp",
				type : "GET", 
				data : {isdel:"true", delids:_xtable_CheckedCheckboxId(), isfromlist:"1"},
		        contentType : "charset=UTF-8", 
		        error:function(ajaxrequest){
		        	//dialog.close();
				}, 
		        success:function(content) {
		        	//parentWin.location.reload();
		        	//dialog.close();
		        	_table.reLoad();
				}
			});
		});
	}
	</script>
  </head>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  <%
  %>
  <body>
  	<%
  	
  	String title = Util.null2String(request.getParameter("title"));
  	
	String tableString = "";
	int perpage=10;              
	
	String sqlWhere = "";
	String orderby ="";
	String backfields = "";
	String fromSql  = "";
	
	fromSql = " from hpElement_notice ";
	sqlWhere = " where 1=1 ";
	if (!"".equals(title)) {
	    sqlWhere += " and title like '%" + title + "%' ";
	}
	
	//System.out.println(sqlWhere);
	backfields = " id, title, content, imgsrc, creator, creatortype, createdate, createtime, lastupdatedate, lastupdatetime ";
	orderby = " id ";
	
	tableString =   " <table instanceid=\"portal_newnoticelisttable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize("portal_newnoticelisttable", user.getUID())+"\">"+
					" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.notice.Notice.getCheckBox\" />" +
	                "     <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"" + orderby + "\" sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"false\" />"+
	                "     <head>"+
	                "         <col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" otherpara=\"column:id\" transmethod=\"weaver.notice.Notice.convertTitle\"/>"+
	                "         <col width=\"*\" text=\""+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"\" column=\"content\" transmethod=\"weaver.general.Util.delHtmlWithSpace\"/>"+
	                "         <col width=\"100px\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creator\" otherpara=\"0\" orderkey=\"creator\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
	                "         <col width=\"180px\" text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" otherpara=\"column:createtime\" />" + 
	                "         <col width=\"180px\" text=\""+SystemEnv.getHtmlLabelName(83563,user.getLanguage())+"\" column=\"lastupdatedate\" orderkey=\"lastupdatedate\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" otherpara=\"column:lastupdatetime\" />"+
	                "       </head>"+
	                "     <operates>"+
					"  		<popedom transmethod=\"weaver.rdeploy.portal.PortalUtil.getResOperaotes\" otherpara=\"" + HrmUserVarify.checkUserRight("homepage:Maint", user) + "\"></popedom> " +
					"		<operate href=\"javascript:updateNotice2();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
	                "		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		</operates>"+                   
	                " </table>";
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= "portal_newnoticelisttable" %>"  _showCol=false/>
	<TABLE width="100%" cellspacing=0 cellpadding="0" height="100%">
	    <tr>
	        <td valign="top">  
	            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
	        </td>
	    </tr>
	</TABLE>	
	<form method="post" action="/page/element/newNotice/list.jsp" id="noticeform"> 
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;" >	
			<%
			if(HrmUserVarify.checkUserRight("homepage:Maint", user)){
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) + SystemEnv.getHtmlLabelName(23666,user.getLanguage())%>" style="font-size:12px" class="e8_btn_top" onclick="onNewnotice(this)">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" style="font-size:12px" class="e8_btn_top middle" onclick="onMultiDel(this)">
				<input type="text" class="searchInput" value="<%=Util.null2String(request.getParameter("title"))%>" name="title"/>
				&nbsp;&nbsp;
				
				
			<%
			}
			%>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu"></span>
			</td>
		</tr>
	</table>
	</form>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  </body>
</html>

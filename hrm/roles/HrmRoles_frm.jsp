
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-30 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
	String imagefilename = "/images/hdHRM_wev8.gif";
	String titlename = "";
	String needfav ="1";
	String needhelp ="";

	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//是否分权系统，如不是，则不显示框架，直接转向到列表页面
	/*
	rs.executeSql("select detachable from SystemSet");
	int detachable=0;
	if(rs.next()){
		detachable=rs.getInt("detachable");
		session.setAttribute("detachable",String.valueOf(detachable));
	}
	*/
//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)

String detachable="0";
if(Util.null2String(ManageDetachComInfo.getDetachable()).equals("1")){
	detachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable","1");
}else{
	detachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable","0");
}	

	if("0".equals(detachable)){
		response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmRoles");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="JavaScript">
			var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"HrmRoles.jsp";
			if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
				jQuery(document).ready(function () {
					jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
					window.onresize = function () {
						jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
					};
				});
			}
			
			function reload(){
				window.location.reload();
			}
		</script>
	</HEAD>
	<body scroll="no">
		<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
		<TBODY>
			<tr>
				<td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
					<IFRAME name=leftframe id=leftframe src="HrmRoles_left.jsp?rightStr=HrmRolesAdd:Add" width="100%" height="100%" frameborder=no scrolling=no>
					<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
				</td>
				<!--<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
					<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
					浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
				</td>-->
				<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
					<IFRAME name=contentframe id=contentframe src="/hrm/HrmTab.jsp?_fromURL=HrmRoles" width="100%" height="100%" frameborder=no scrolling=yes>
					<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
				</td>
			</tr>
		</TBODY>
		</TABLE>
	</body>
</html>
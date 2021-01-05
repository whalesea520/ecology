
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String subcomid=Util.null2String(request.getParameter("subcomid"));
String deptid=Util.null2String(request.getParameter("deptid"));
String gotopage=Util.null2String(request.getParameter("gotopage"));
String parments=Util.null2String(request.getParameter("parments"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
parments=parments.replace('_','&');
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}

%>

<%
if(!HrmUserVarify.checkUserRight("Structure:Mag", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

//获得companyid
int id=-100;
rs.executeProc("HrmCompany_Select","");
if(rs.next()){
	id = rs.getInt(1);
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}

</script>
</HEAD>
<body scroll="no">
<TABLE width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="246px" style="border-right:0px;">
<IFRAME name=leftframe id=leftframe src="HrmCompany_left.jsp?subcomid=<%=subcomid%>&deptid=<%=deptid%>&nodeid=<%=nodeid%>&rightStr=HrmResourceAdd:Add" width="100%" height="100%" frameborder=no scrolling=no>
</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
<IFRAME name=contentframe id=contentframe <%if(!gotopage.equals("")){%>src="<%=gotopage%>?<%=parments%>"<%}else{%>src="/hrm/HrmTab.jsp?_fromURL=HrmCompanyDsp&id=<%=id%>"<%}%> width="100%" height="100%" frameborder=no scrolling=no>
</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>
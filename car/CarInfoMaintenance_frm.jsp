
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select carsdetachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt(1);
    session.setAttribute("carsdetachable",String.valueOf(detachable));
}
if(detachable==0){
    response.sendRedirect("CarInfoMaintenance.jsp?subCompanyId=-1");
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
   
   
</script>
<script type="text/javascript">
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
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style="border-right:0px;">
<IFRAME name=leftframe id=leftframe src="CarInfoMaintenance_left.jsp?rightStr=Car:Maintenance" width="100%" height="100%" frameborder=no scrolling=no>
</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
<IFRAME name=contentframe id=contentframe src="CarInfoMaintenance.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>
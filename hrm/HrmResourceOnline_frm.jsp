
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<SCRIPT language="javascript" defer="defer" src='/js/datetime_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
/*
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}*/
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
	 session.setAttribute("detachable","1");
  session.setAttribute("hrmdetachable","1");
}else{
	 session.setAttribute("detachable","0");
  session.setAttribute("hrmdetachable","0");
}
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"/hrm/search/HrmResourceSearchTmp.jsp";
//alert(contentUrl);
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<STYLE TYPE="text/css">
	margin:0px;padding:0px;
</STYLE>
<body  scroll="no">



<TABLE class=viewform width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px">
  <TBODY> 
	<tr>
		<td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
			<IFRAME name=leftframe id=leftframe src="HrmResource_left.jsp?rightStr=HrmResourceAdd:Add" width="100%" height="100%" frameborder=no scrolling=no></IFRAME>
		</td>
		<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
			<iframe name="middleframe" id="middleframe" border="0"
												frameborder="no" noresize="noresize" height="100%" width="100%"
												scrolling="no" src="/framemiddle.jsp"></iframe></td>
		<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
			<IFRAME name=contentframe id=contentframe src="/hrm/search/HrmResourceSearchTmp.jsp" width="100%" height="100%" frameborder=no scrolling=yes></IFRAME>
		</td>
	</tr>
  </TBODY>
</TABLE>

 </body>

</html>
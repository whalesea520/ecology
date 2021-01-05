
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.hrm.company.SubCompanyComInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
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
//取第一分部
SubCompanyComInfo subcomObj = new SubCompanyComInfo();
subcomObj.setTofirstRow();
String subcompanyid = "";
while(subcomObj.next()){
	if("0".equals(subcomObj.getCompanyiscanceled()) || "".equals(subcomObj.getCompanyiscanceled())){
		if(user.getUID() != 1) {
			subcompanyid = ""+user.getUserSubCompany1();
		} else {
			subcompanyid=subcomObj.getSubCompanyid();
		}
		break;
	}
}
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
<TABLE width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" >
<IFRAME name=leftframe id=leftframe src="PSLManagement_left.jsp?rightStr=PaidSickLeave:All" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
<IFRAME name=contentframe id=contentframe src="/hrm/HrmTab.jsp?_fromURL=PSLManagementView&subcompanyid=<%=subcompanyid %>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>

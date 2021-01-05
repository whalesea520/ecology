
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
 
<%
if(!HrmUserVarify.checkUserRight("Wechat:Mgr", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
//微信模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
String wechatdetachable="0";
boolean isUseWcManageDetach=ManageDetachComInfo.isUseWcManageDetach();
String dftsubcomid=ManageDetachComInfo.getWcdftsubcomid();
dftsubcomid="".equals(dftsubcomid)?"0":dftsubcomid;
if(isUseWcManageDetach){
   wechatdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("wechatdetachable",wechatdetachable);
}else{
   wechatdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("wechatdetachable",wechatdetachable);
}
if("1".equals(wechatdetachable)&&!"".equals(dftsubcomid)){
 	rs.executeSql("update wechat_platform set subcompanyid="+dftsubcomid+" where subcompanyid = '' or subcompanyid is null or subcompanyid=0");
}
if("0".equals(wechatdetachable)){
    response.sendRedirect("/wechat/platformListTab.jsp");
    return;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
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
<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’ cellpadding="0px" cellspacing="0px">
<IFRAME name=leftframe id=leftframe src="platform_left.jsp?rightStr=Wechat:Mgr" width="100%" height="100%" frameborder=no scrolling=no >
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="/wechat/platformListTab.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>
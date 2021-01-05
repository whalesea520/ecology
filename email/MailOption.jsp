
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
BaseBean baseBeanRigthMenu = new BaseBean();
int userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
%>
<!--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
-->
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" src="/js/tab_wev8.js"></script>
<script type="text/javascript" language="javascript">


dojo.require("dojo.widget.TabSet");
dojo.require("dojo.io.*");
dojo.require("dojo.event.*");


</script>

<link href="/js/src/widget/templates/HtmlTabSet_wev8.css" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" media="screen" />
<style type="text/css" media="screen">
/* <[CDATA[ */
span.href{color:blue;text-decoration:underline;cursor:hand;}
label.browser{width:185px;}
label.ruleDefine{width:80px;}
select.rule{width:100px}
#tabContainer{padding:0px}
#mainTabSet{height:100%}
.tabPostionTop {
	top:27px!important;
}
/* ]]> */
</style>
</head>
<body>

<select id="folderSelect" style="display:none">
<%rs.executeSql("SELECT id,folderName FROM MailInboxFolder WHERE userId="+user.getUID()+"");while(rs.next()){%>
<option value="<%=rs.getString("id")%>"><%=rs.getString("folderName")%></option>
<%}%>
</select>
<div id="tabContainer">
<div id="mainTabSet" dojoType="TabSet" >
	<div id="tab1" class="tabPostionTop" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%>" onSelected="tabref('MailAccount.jsp','tab01iframe');"  <%if(userightmenu == 1){%> onmouseup="if(event.button==2) {initMenu(this);}" <%}%>>
	  <iframe id="tab01iframe" name="tab01iframe" frameborder="0" width=100% height=100% scrolling="auto" src=""></iframe>
	</div>
	<div id="tab2"  class="tabPostionTop" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(19828,user.getLanguage())%>" onSelected="tabref('MailRule.jsp','tab02iframe');" <%if(userightmenu == 1){%> onmouseup="if(event.button==2) {initMenu(this);}" <%}%>>
	  <iframe id="tab02iframe" name="tab02iframe" frameborder="0" width=100% height=100% scrolling="auto" src=""></iframe>
	</div>
	<div id="tab3"  class="tabPostionTop" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>" onSelected="tabref('MailSetting.jsp','tab03iframe');"  <%if(userightmenu == 1){%> onmouseup="if(event.button==2) {initMenu(this);}" <%}%>>
	  <iframe id="tab03iframe" name="tab03iframe" frameborder="0" width=100% height=100% scrolling="auto" src=""></iframe>
	</div>
</div>
</div>
</body>

<script type="text/javascript">

function tabref(url,iframe){
  document.all(iframe).src=url;
}

tabref('MailAccount.jsp','tab01iframe');


</script>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int language=user.getLanguage();
String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
if(!HrmUserVarify.checkUserRight("intergration:SAPsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<body>

<br>

<p><strong><%=SystemEnv.getHtmlLabelName(19010 ,user.getLanguage())%></strong></p>
<ul> 
 
 
 	 <li>&nbsp;&nbsp;1、<%=SystemEnv.getHtmlLabelName(30627 ,user.getLanguage())%>【<%=SystemEnv.getHtmlLabelName(30657 ,user.getLanguage())%>】，<%=SystemEnv.getHtmlLabelName(30629 ,user.getLanguage())%>。</li>
	<%
		if("0".equals(w_type)){
	%>
		<li>&nbsp;&nbsp;2、【<%=SystemEnv.getHtmlLabelName(30630 ,user.getLanguage())%>】<%=SystemEnv.getHtmlLabelName(30631 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30634 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30637 ,user.getLanguage())%>。</li>
	<%	
		}else{
	%>
		
		<li>&nbsp;&nbsp;2、【<%=SystemEnv.getHtmlLabelName(18624 ,user.getLanguage())%>】<%=SystemEnv.getHtmlLabelName(30631 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30633 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30635 ,user.getLanguage())%>。</li>
	<%
		
		}
	 %>
  
  
  
</ul>
<p><strong>注意事项</strong></p>
	<ul>
		<li>&nbsp;&nbsp;1、参数都以字符串的格式进行处理，即OA传入到SAP的数据都为字符串格式，SAP传入到OA的数据也必须都为字符串格式。</li>
		<li>&nbsp;&nbsp;2、集成浏览按钮的配置不支持内表，即输入(出)参数里面不能嵌套输入(出)表和输入(出)结构</li>
	</ul>
</body>
</html>